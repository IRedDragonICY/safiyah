import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/zakat_service.dart';
import '../../../data/models/zakat_model.dart';

class ZakatCalculatorPage extends StatefulWidget {
  final ZakatType zakatType;

  const ZakatCalculatorPage({
    super.key,
    required this.zakatType,
  });

  @override
  State<ZakatCalculatorPage> createState() => _ZakatCalculatorPageState();
}

class _ZakatCalculatorPageState extends State<ZakatCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _ricePriceController = TextEditingController();
  final _familyMembersController = TextEditingController();
  final _pricePerKgController = TextEditingController();
  
  String _selectedCurrency = 'IDR';
  String _selectedAnimalType = 'goat';
  bool _isRainFed = true;
  int _familyMembers = 1;
  
  ZakatModel? _calculatedZakat;
  bool _isCalculating = false;
  
  ZakatTypeInfo? _zakatTypeInfo;

  final List<String> _currencies = ['IDR', 'USD', 'EUR', 'MYR', 'SAR'];
  final List<String> _animalTypes = ['goat', 'sheep', 'cattle', 'buffalo', 'camel'];

  @override
  void initState() {
    super.initState();
    _zakatTypeInfo = ZakatService.getZakatTypeInfo(widget.zakatType);
    _initializeDefaults();
  }

  void _initializeDefaults() {
    switch (widget.zakatType) {
      case ZakatType.fitrah:
        _ricePriceController.text = '15000';
        _familyMembersController.text = '1';
        break;
      case ZakatType.agriculture:
        _pricePerKgController.text = '10000';
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _ricePriceController.dispose();
    _familyMembersController.dispose();
    _pricePerKgController.dispose();
    super.dispose();
  }

  void _calculateZakat() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCalculating = true;
    });

    await Future.delayed(const Duration(milliseconds: 500)); // Simulated calculation delay

    Map<String, dynamic> additionalData = {};
    double amount = 0;

    switch (widget.zakatType) {
      case ZakatType.fitrah:
        additionalData = {
          'ricePrice': double.parse(_ricePriceController.text),
          'familyMembers': int.parse(_familyMembersController.text),
        };
        amount = 2.5; // 2.5 kg rice
        break;

      case ZakatType.agriculture:
        additionalData = {
          'isRainFed': _isRainFed,
          'pricePerKg': double.parse(_pricePerKgController.text),
        };
        amount = double.parse(_amountController.text);
        break;

      case ZakatType.livestock:
        additionalData = {
          'animalType': _selectedAnimalType,
        };
        amount = double.parse(_amountController.text);
        break;

      default:
        amount = double.parse(_amountController.text);
        break;
    }

    final zakat = ZakatService.calculateZakat(
      userId: 'user_123', // In real app, get from auth
      type: widget.zakatType,
      amount: amount,
      currency: _selectedCurrency,
      additionalData: additionalData,
    );

    setState(() {
      _calculatedZakat = zakat;
      _isCalculating = false;
    });
  }

  void _payZakat() {
    if (_calculatedZakat == null) return;
    
    // Navigate to payment page
    context.push('/payment', extra: {
      'type': 'zakat',
      'amount': _calculatedZakat!.zakatDue,
      'currency': _calculatedZakat!.calculationDetails.currency,
      'zakatModel': _calculatedZakat,
    });
  }

  void _saveZakat() {
    if (_calculatedZakat == null) return;
    
    // In real app, save to local storage or database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Zakat calculation saved successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _getZakatTypeColor(widget.zakatType),
        foregroundColor: AppColors.onPrimary,
        title: Text(
          _zakatTypeInfo?.nameIndonesian ?? 'Zakat Calculator',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog();
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              _buildHeaderCard(),
              const SizedBox(height: 24),
              
              // Input Section
              _buildInputSection(),
              const SizedBox(height: 24),
              
              // Calculate Button
              _buildCalculateButton(),
              const SizedBox(height: 24),
              
              // Result Section
              if (_calculatedZakat != null) _buildResultSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getZakatTypeColor(widget.zakatType).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getZakatTypeColor(widget.zakatType).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getZakatTypeColor(widget.zakatType),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getZakatTypeIcon(widget.zakatType),
                  color: AppColors.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _zakatTypeInfo?.nameIndonesian ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      _zakatTypeInfo?.name ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _zakatTypeInfo?.descriptionIndonesian ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          
          // Nisab Information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.info.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: AppColors.info,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getNisabInfo(),
                    style: TextStyle(
                      color: AppColors.info,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculation Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 16),
          
          // Currency Selection (for most zakat types)
          if (widget.zakatType != ZakatType.fitrah && widget.zakatType != ZakatType.livestock) ...[
            Text(
              'Currency',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.attach_money),
              ),
              items: _currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
          
          // Type-specific inputs
          ..._buildTypeSpecificInputs(),
        ],
      ),
    );
  }

  List<Widget> _buildTypeSpecificInputs() {
    switch (widget.zakatType) {
      case ZakatType.fitrah:
        return [
          TextFormField(
            controller: _ricePriceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Harga Beras per KG (IDR)',
              prefixIcon: const Icon(Icons.rice_bowl),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan harga beras';
              }
              if (double.tryParse(value) == null) {
                return 'Masukkan angka yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _familyMembersController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Jumlah Anggota Keluarga',
              prefixIcon: const Icon(Icons.family_restroom),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan jumlah anggota keluarga';
              }
              if (int.tryParse(value) == null || int.parse(value) < 1) {
                return 'Masukkan angka yang valid (minimal 1)';
              }
              return null;
            },
          ),
        ];

      case ZakatType.agriculture:
        return [
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            decoration: InputDecoration(
              labelText: 'Jumlah Hasil Panen (KG)',
              prefixIcon: const Icon(Icons.agriculture),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan jumlah hasil panen';
              }
              if (double.tryParse(value) == null) {
                return 'Masukkan angka yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _pricePerKgController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            decoration: InputDecoration(
              labelText: 'Harga per KG ($_selectedCurrency)',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan harga per KG';
              }
              if (double.tryParse(value) == null) {
                return 'Masukkan angka yang valid';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Jenis Pengairan',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('Tadah Hujan (10%)'),
                  value: true,
                  groupValue: _isRainFed,
                  onChanged: (value) {
                    setState(() {
                      _isRainFed = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('Irigasi (5%)'),
                  value: false,
                  groupValue: _isRainFed,
                  onChanged: (value) {
                    setState(() {
                      _isRainFed = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ];

      case ZakatType.livestock:
        return [
          Text(
            'Jenis Hewan',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedAnimalType,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.pets),
            ),
            items: _animalTypes.map((animal) {
              return DropdownMenuItem(
                value: animal,
                child: Text(_getAnimalDisplayName(animal)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAnimalType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Jumlah Hewan',
              prefixIcon: const Icon(Icons.pets),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan jumlah hewan';
              }
              if (int.tryParse(value) == null || int.parse(value) < 1) {
                return 'Masukkan angka yang valid (minimal 1)';
              }
              return null;
            },
          ),
        ];

      default:
        return [
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            decoration: InputDecoration(
              labelText: 'Jumlah Harta ($_selectedCurrency)',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Masukkan jumlah harta';
              }
              if (double.tryParse(value) == null) {
                return 'Masukkan angka yang valid';
              }
              return null;
            },
          ),
        ];
    }
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: _isCalculating ? null : _calculateZakat,
        icon: _isCalculating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onPrimary,
                ),
              )
            : const Icon(Icons.calculate),
        label: Text(_isCalculating ? 'Menghitung...' : 'Hitung Zakat'),
        style: FilledButton.styleFrom(
          backgroundColor: _getZakatTypeColor(widget.zakatType),
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    final isObligatory = ZakatService.isZakatObligatory(
      _calculatedZakat!.type,
      _calculatedZakat!.amount,
      _calculatedZakat!.calculationDetails.currency,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isObligatory
              ? AppColors.primaryGradient
              : [AppColors.warning.withOpacity(0.7), AppColors.warning],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isObligatory ? AppColors.primary : AppColors.warning).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isObligatory ? Icons.check_circle : Icons.info,
                  color: AppColors.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isObligatory ? 'Zakat Wajib' : 'Zakat Tidak Wajib',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (!isObligatory) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.onPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Harta Anda belum mencapai nisab atau belum memenuhi syarat wajib zakat.',
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Amount Details
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Jumlah Harta',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ZakatService.formatCurrency(
                        _calculatedZakat!.amount,
                        _calculatedZakat!.calculationDetails.currency,
                      ),
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Zakat yang Harus Dibayar',
                      style: TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ZakatService.formatCurrency(
                        _calculatedZakat!.zakatDue,
                        _calculatedZakat!.calculationDetails.currency,
                      ),
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (isObligatory && _calculatedZakat!.zakatDue > 0) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saveZakat,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.onPrimary,
                      side: const BorderSide(color: AppColors.onPrimary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _payZakat,
                    icon: const Icon(Icons.payment),
                    label: const Text('Bayar Zakat'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.onSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_zakatTypeInfo?.nameIndonesian ?? ''),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Deskripsi:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(_zakatTypeInfo?.descriptionIndonesian ?? ''),
              const SizedBox(height: 16),
              Text(
                'Syarat-syarat:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...(_zakatTypeInfo?.requirementsIndonesian ?? []).map(
                (req) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(req)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Formula Perhitungan:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(_zakatTypeInfo?.calculationFormulaIndonesian ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  String _getNisabInfo() {
    switch (widget.zakatType) {
      case ZakatType.fitrah:
        return 'Zakat fitrah wajib bagi setiap muslim yang mampu.';
      case ZakatType.agriculture:
        return 'Nisab: 653 kg hasil panen makanan pokok.';
      case ZakatType.livestock:
        return 'Nisab berbeda per jenis hewan (min. 5 kambing, 30 sapi, dll).';
      default:
        return 'Nisab saat ini: ${ZakatService.formatCurrency(ZakatService.calculateNisabInCurrency(_selectedCurrency), _selectedCurrency)}';
    }
  }

  String _getAnimalDisplayName(String animal) {
    switch (animal) {
      case 'goat':
        return 'Kambing';
      case 'sheep':
        return 'Domba';
      case 'cattle':
        return 'Sapi';
      case 'buffalo':
        return 'Kerbau';
      case 'camel':
        return 'Unta';
      default:
        return animal;
    }
  }

  Color _getZakatTypeColor(ZakatType type) {
    switch (type) {
      case ZakatType.wealth:
        return AppColors.primary;
      case ZakatType.fitrah:
        return AppColors.secondary;
      case ZakatType.goldSilver:
        return const Color(0xFFFFD700);
      case ZakatType.trade:
        return AppColors.info;
      case ZakatType.agriculture:
        return AppColors.success;
      case ZakatType.livestock:
        return const Color(0xFF8BC34A);
      case ZakatType.investment:
        return const Color(0xFF9C27B0);
      case ZakatType.profession:
        return const Color(0xFF607D8B);
      case ZakatType.savings:
        return const Color(0xFF00BCD4);
    }
  }

  IconData _getZakatTypeIcon(ZakatType type) {
    switch (type) {
      case ZakatType.wealth:
        return Icons.account_balance_wallet;
      case ZakatType.fitrah:
        return Icons.rice_bowl;
      case ZakatType.goldSilver:
        return Icons.diamond;
      case ZakatType.trade:
        return Icons.store;
      case ZakatType.agriculture:
        return Icons.agriculture;
      case ZakatType.livestock:
        return Icons.pets;
      case ZakatType.investment:
        return Icons.trending_up;
      case ZakatType.profession:
        return Icons.work;
      case ZakatType.savings:
        return Icons.savings;
    }
  }
} 