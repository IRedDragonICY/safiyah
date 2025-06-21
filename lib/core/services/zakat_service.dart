import '../../data/models/zakat_model.dart';

class ZakatService {
  static const double _goldNisab = 85.0; // 85 gram emas
  static const double _silverNisab = 595.0; // 595 gram perak
  static const double _standardZakatRate = 0.025; // 2.5%

  // Harga emas dan perak saat ini (dalam IDR per gram)
  // Dalam implementasi nyata, ini akan diambil dari API
  static const double _currentGoldPrice = 1050000.0; // IDR per gram
  static const double _currentSilverPrice = 14000.0; // IDR per gram

  /// Mendapatkan informasi semua jenis zakat
  static List<ZakatTypeInfo> getAllZakatTypes() {
    return [
      ZakatTypeInfo(
        type: ZakatType.wealth,
        name: 'Wealth Zakat',
        nameIndonesian: 'Zakat Mal',
        description: 'Zakat on wealth including cash, savings, and assets',
        descriptionIndonesian: 'Zakat atas harta kekayaan termasuk uang tunai, tabungan, dan aset',
        nisabInGold: _goldNisab,
        zakatRate: _standardZakatRate,
        requirements: [
          'Wealth must reach nisab (equivalent to 85g gold)',
          'Owned for at least one lunar year (haul)',
          'Free from debt',
          'Not for basic needs'
        ],
        requirementsIndonesian: [
          'Harta mencapai nisab (setara 85 gram emas)',
          'Dimiliki selama satu tahun hijriah (haul)',
          'Bebas dari hutang',
          'Bukan untuk kebutuhan pokok'
        ],
        calculationFormula: 'Wealth × 2.5%',
        calculationFormulaIndonesian: 'Harta × 2.5%',
      ),
      ZakatTypeInfo(
        type: ZakatType.fitrah,
        name: 'Fitrah Zakat',
        nameIndonesian: 'Zakat Fitrah',
        description: 'Obligatory charity paid during Ramadan',
        descriptionIndonesian: 'Zakat wajib yang dibayar saat bulan Ramadan',
        nisabInGold: 0, // Tidak ada nisab untuk zakat fitrah
        zakatRate: 0, // Tidak dihitung dengan persentase
        requirements: [
          'Must be Muslim',
          'Alive at sunset of last day of Ramadan',
          'Have basic necessities',
          'Pay for family members'
        ],
        requirementsIndonesian: [
          'Beragama Islam',
          'Hidup saat matahari terbenam di akhir Ramadan',
          'Memiliki kebutuhan pokok',
          'Membayar untuk anggota keluarga'
        ],
        calculationFormula: '2.5kg rice or equivalent value',
        calculationFormulaIndonesian: '2.5kg beras atau nilai setaranya',
      ),
      ZakatTypeInfo(
        type: ZakatType.goldSilver,
        name: 'Gold & Silver Zakat',
        nameIndonesian: 'Zakat Emas dan Perak',
        description: 'Zakat on gold and silver jewelry and assets',
        descriptionIndonesian: 'Zakat atas perhiasan dan aset emas dan perak',
        nisabInGold: _goldNisab,
        zakatRate: _standardZakatRate,
        requirements: [
          'Gold: minimum 85 grams',
          'Silver: minimum 595 grams',
          'Owned for one lunar year',
          'Beyond daily use jewelry'
        ],
        requirementsIndonesian: [
          'Emas: minimal 85 gram',
          'Perak: minimal 595 gram',
          'Dimiliki selama satu tahun hijriah',
          'Melebihi perhiasan untuk pemakaian sehari-hari'
        ],
        calculationFormula: 'Gold/Silver weight × current price × 2.5%',
        calculationFormulaIndonesian: 'Berat emas/perak × harga saat ini × 2.5%',
      ),
      ZakatTypeInfo(
        type: ZakatType.trade,
        name: 'Trade Zakat',
        nameIndonesian: 'Zakat Perdagangan',
        description: 'Zakat on business assets and inventory',
        descriptionIndonesian: 'Zakat atas aset bisnis dan inventori',
        nisabInGold: _goldNisab,
        zakatRate: _standardZakatRate,
        requirements: [
          'Business assets reach nisab',
          'Assets owned for one year',
          'Include inventory and receivables',
          'Exclude fixed assets'
        ],
        requirementsIndonesian: [
          'Aset bisnis mencapai nisab',
          'Aset dimiliki selama satu tahun',
          'Termasuk inventori dan piutang',
          'Tidak termasuk aset tetap'
        ],
        calculationFormula: '(Inventory + Cash + Receivables - Payables) × 2.5%',
        calculationFormulaIndonesian: '(Inventori + Kas + Piutang - Hutang) × 2.5%',
      ),
      ZakatTypeInfo(
        type: ZakatType.agriculture,
        name: 'Agriculture Zakat',
        nameIndonesian: 'Zakat Pertanian',
        description: 'Zakat on agricultural produce',
        descriptionIndonesian: 'Zakat atas hasil pertanian',
        nisabInGold: 0, // Menggunakan nisab khusus (653 kg)
        zakatRate: 0.1, // 10% untuk tadah hujan, 5% untuk irigasi
        requirements: [
          'Minimum 653 kg of produce',
          'Staple food crops',
          'Paid at harvest time',
          'Different rates for irrigation'
        ],
        requirementsIndonesian: [
          'Minimal 653 kg hasil panen',
          'Tanaman makanan pokok',
          'Dibayar saat panen',
          'Tarif berbeda untuk irigasi'
        ],
        calculationFormula: 'Rain-fed: 10%, Irrigated: 5%',
        calculationFormulaIndonesian: 'Tadah hujan: 10%, Irigasi: 5%',
      ),
      ZakatTypeInfo(
        type: ZakatType.livestock,
        name: 'Livestock Zakat',
        nameIndonesian: 'Zakat Peternakan',
        description: 'Zakat on cattle, goats, and camels',
        descriptionIndonesian: 'Zakat atas sapi, kambing, dan unta',
        nisabInGold: 0, // Menggunakan nisab khusus per jenis hewan
        zakatRate: 0, // Tidak dihitung dengan persentase
        requirements: [
          'Grazing animals',
          'Minimum quantities per type',
          'Owned for one lunar year',
          'Not for immediate trade'
        ],
        requirementsIndonesian: [
          'Hewan yang merumput',
          'Jumlah minimal per jenis',
          'Dimiliki selama satu tahun hijriah',
          'Bukan untuk diperdagangkan segera'
        ],
        calculationFormula: 'Based on animal count and type',
        calculationFormulaIndonesian: 'Berdasarkan jumlah dan jenis hewan',
      ),
      ZakatTypeInfo(
        type: ZakatType.investment,
        name: 'Investment Zakat',
        nameIndonesian: 'Zakat Investasi',
        description: 'Zakat on stocks, bonds, and investments',
        descriptionIndonesian: 'Zakat atas saham, obligasi, dan investasi',
        nisabInGold: _goldNisab,
        zakatRate: _standardZakatRate,
        requirements: [
          'Investment value reaches nisab',
          'Owned for one lunar year',
          'Include dividends and profits',
          'Market value assessment'
        ],
        requirementsIndonesian: [
          'Nilai investasi mencapai nisab',
          'Dimiliki selama satu tahun hijriah',
          'Termasuk dividen dan keuntungan',
          'Penilaian berdasarkan nilai pasar'
        ],
        calculationFormula: 'Investment value × 2.5%',
        calculationFormulaIndonesian: 'Nilai investasi × 2.5%',
      ),
      ZakatTypeInfo(
        type: ZakatType.profession,
        name: 'Professional Zakat',
        nameIndonesian: 'Zakat Profesi',
        description: 'Zakat on professional income and salary',
        descriptionIndonesian: 'Zakat atas penghasilan profesi dan gaji',
        nisabInGold: _goldNisab,
        zakatRate: _standardZakatRate,
        requirements: [
          'Income reaches nisab',
          'Can be paid monthly',
          'Include all income sources',
          'After basic needs'
        ],
        requirementsIndonesian: [
          'Penghasilan mencapai nisab',
          'Bisa dibayar bulanan',
          'Termasuk semua sumber penghasilan',
          'Setelah kebutuhan pokok'
        ],
        calculationFormula: 'Monthly income × 2.5%',
        calculationFormulaIndonesian: 'Penghasilan bulanan × 2.5%',
      ),
      ZakatTypeInfo(
        type: ZakatType.savings,
        name: 'Savings Zakat',
        nameIndonesian: 'Zakat Tabungan',
        description: 'Zakat on savings and deposits',
        descriptionIndonesian: 'Zakat atas tabungan dan deposito',
        nisabInGold: _goldNisab,
        zakatRate: _standardZakatRate,
        requirements: [
          'Savings reach nisab',
          'Owned for one lunar year',
          'Include all bank accounts',
          'Include accrued interest'
        ],
        requirementsIndonesian: [
          'Tabungan mencapai nisab',
          'Dimiliki selama satu tahun hijriah',
          'Termasuk semua rekening bank',
          'Termasuk bunga yang diperoleh'
        ],
        calculationFormula: 'Total savings × 2.5%',
        calculationFormulaIndonesian: 'Total tabungan × 2.5%',
      ),
    ];
  }

  /// Menghitung nisab dalam mata uang tertentu
  static double calculateNisabInCurrency(String currency) {
    // Menggunakan nilai emas sebagai patokan
    double goldNisabValue = _goldNisab * _currentGoldPrice;
    
    // Dalam implementasi nyata, konversi mata uang akan menggunakan API
    switch (currency.toUpperCase()) {
      case 'USD':
        return goldNisabValue / 15000; // Asumsi 1 USD = 15,000 IDR
      case 'EUR':
        return goldNisabValue / 16000; // Asumsi 1 EUR = 16,000 IDR
      case 'MYR':
        return goldNisabValue / 3500; // Asumsi 1 MYR = 3,500 IDR
      case 'SAR':
        return goldNisabValue / 4000; // Asumsi 1 SAR = 4,000 IDR
      case 'IDR':
      default:
        return goldNisabValue;
    }
  }

  /// Menghitung zakat berdasarkan jenis dan jumlah
  static ZakatModel calculateZakat({
    required String userId,
    required ZakatType type,
    required double amount,
    required String currency,
    Map<String, dynamic>? additionalData,
  }) {
    double nisabAmount = calculateNisabInCurrency(currency);
    double zakatDue = 0.0;
    double zakatRate = _standardZakatRate;

    switch (type) {
      case ZakatType.wealth:
      case ZakatType.goldSilver:
      case ZakatType.trade:
      case ZakatType.investment:
      case ZakatType.profession:
      case ZakatType.savings:
        if (amount >= nisabAmount) {
          zakatDue = amount * zakatRate;
        }
        break;

      case ZakatType.fitrah:
        // Zakat fitrah berdasarkan harga beras atau makanan pokok
        double ricePrice = additionalData?['ricePrice'] ?? 15000.0; // IDR per kg
        zakatDue = 2.5 * ricePrice; // 2.5 kg beras
        int familyMembers = additionalData?['familyMembers'] ?? 1;
        zakatDue *= familyMembers;
        zakatRate = 0.0; // Tidak applicable
        nisabAmount = 0.0; // Tidak ada nisab
        break;

      case ZakatType.agriculture:
        double nisabKg = 653.0; // 653 kg
        if (amount >= nisabKg) {
          bool isRainFed = additionalData?['isRainFed'] ?? true;
          zakatRate = isRainFed ? 0.1 : 0.05; // 10% atau 5%
          double pricePerKg = additionalData?['pricePerKg'] ?? 10000.0;
          zakatDue = amount * pricePerKg * zakatRate;
        }
        nisabAmount = nisabKg;
        break;

      case ZakatType.livestock:
        zakatDue = _calculateLivestockZakat(amount, additionalData);
        zakatRate = 0.0; // Tidak applicable
        nisabAmount = 0.0; // Bervariasi per jenis hewan
        break;
    }

    return ZakatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      type: type,
      amount: amount,
      zakatDue: zakatDue,
      calculatedAt: DateTime.now(),
      paymentDueDate: _calculatePaymentDueDate(type),
      status: ZakatStatus.calculated,
      calculationDetails: ZakatCalculationDetails(
        nisabAmount: nisabAmount,
        zakatRate: zakatRate,
        currency: currency,
        goldPricePerGram: _currentGoldPrice,
        silverPricePerGram: _currentSilverPrice,
        additionalData: additionalData ?? {},
      ),
    );
  }

  /// Menghitung zakat peternakan
  static double _calculateLivestockZakat(double count, Map<String, dynamic>? data) {
    String animalType = data?['animalType'] ?? 'goat';
    
    switch (animalType.toLowerCase()) {
      case 'goat':
      case 'sheep':
        if (count >= 40 && count <= 120) return 1.0;
        if (count >= 121 && count <= 200) return 2.0;
        if (count >= 201 && count <= 300) return 3.0;
        if (count > 300) return (count / 100).floor().toDouble();
        break;
        
      case 'cattle':
      case 'buffalo':
        if (count >= 30 && count <= 39) return 1.0; // 1 tahun
        if (count >= 40 && count <= 59) return 1.0; // 2 tahun
        if (count >= 60) return (count / 30).floor().toDouble();
        break;
        
      case 'camel':
        if (count >= 5 && count <= 9) return 1; // 1 kambing
        if (count >= 10 && count <= 14) return 2; // 2 kambing
        // Dan seterusnya sesuai tabel zakat unta
        break;
    }
    
    return 0;
  }

  /// Menghitung tanggal jatuh tempo pembayaran zakat
  static DateTime? _calculatePaymentDueDate(ZakatType type) {
    DateTime now = DateTime.now();
    
    switch (type) {
      case ZakatType.fitrah:
        // Zakat fitrah harus dibayar sebelum shalat Eid
        // Asumsi Eid 10 hari dari sekarang (untuk demo)
        return now.add(const Duration(days: 10));
        
      case ZakatType.agriculture:
        // Zakat pertanian dibayar saat panen
        // Tidak ada deadline khusus, tapi sebaiknya segera
        return now.add(const Duration(days: 30));
        
      default:
        // Zakat lainnya dibayar setelah haul (1 tahun hijriah)
        // Asumsi 354 hari untuk tahun hijriah
        return now.add(const Duration(days: 354));
    }
  }

  /// Mengecek apakah zakat wajib dibayar
  static bool isZakatObligatory(ZakatType type, double amount, String currency) {
    double nisabAmount = calculateNisabInCurrency(currency);
    
    switch (type) {
      case ZakatType.fitrah:
        return true; // Selalu wajib untuk yang mampu
        
      case ZakatType.agriculture:
        return amount >= 653.0; // 653 kg
        
      case ZakatType.livestock:
        return amount >= 5; // Minimal 5 ekor (berbeda per jenis)
        
      default:
        return amount >= nisabAmount;
    }
  }

  /// Mendapatkan informasi zakat berdasarkan jenis
  static ZakatTypeInfo? getZakatTypeInfo(ZakatType type) {
    return getAllZakatTypes().firstWhere(
      (info) => info.type == type,
    );
  }

  /// Menghitung total zakat yang harus dibayar untuk semua jenis
  static double calculateTotalZakatDue(List<ZakatModel> zakatList) {
    return zakatList
        .where((zakat) => zakat.status != ZakatStatus.paid)
        .fold(0.0, (sum, zakat) => sum + zakat.zakatDue);
  }

  /// Mendapatkan zakat yang sudah jatuh tempo
  static List<ZakatModel> getOverdueZakat(List<ZakatModel> zakatList) {
    DateTime now = DateTime.now();
    return zakatList
        .where((zakat) => 
            zakat.paymentDueDate != null && 
            zakat.paymentDueDate!.isBefore(now) &&
            zakat.status != ZakatStatus.paid)
        .toList();
  }

  /// Format mata uang
  static String formatCurrency(double amount, String currency) {
    switch (currency.toUpperCase()) {
      case 'IDR':
        return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'MYR':
        return 'RM ${amount.toStringAsFixed(2)}';
      case 'SAR':
        return '﷼${amount.toStringAsFixed(2)}';
      default:
        return '${amount.toStringAsFixed(2)} $currency';
    }
  }
} 