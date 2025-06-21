import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/transaction_model.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  // Mock payment gateway integrations
  final Map<PaymentType, PaymentGateway> _gateways = {
    PaymentType.creditCard: CreditCardGateway(),
    PaymentType.debitCard: CreditCardGateway(),
    PaymentType.visa: CreditCardGateway(),
    PaymentType.mastercard: CreditCardGateway(),
    PaymentType.amex: CreditCardGateway(),
    PaymentType.jcb: CreditCardGateway(),
    PaymentType.unionPay: CreditCardGateway(),
    PaymentType.discover: CreditCardGateway(),
    PaymentType.bankTransfer: BankTransferGateway(),
    PaymentType.qris: QRISGateway(),
    PaymentType.alipay: DigitalWalletGateway(),
    PaymentType.touchNGo: DigitalWalletGateway(),
    PaymentType.grabPay: DigitalWalletGateway(),
    PaymentType.shopeePay: DigitalWalletGateway(),
    PaymentType.dana: DigitalWalletGateway(),
    PaymentType.gopay: DigitalWalletGateway(),
    PaymentType.ovo: DigitalWalletGateway(),
    PaymentType.linkAja: DigitalWalletGateway(),
    PaymentType.paypal: PayPalGateway(),
    PaymentType.applePay: ApplePayGateway(),
    PaymentType.googlePay: GooglePayGateway(),
  };

  // Get available payment methods based on region and amount
  List<PaymentMethodOption> getAvailablePaymentMethods({
    required String country,
    required double amount,
    required String currency,
  }) {
    final methods = <PaymentMethodOption>[];

    // Credit/Debit Cards - Available globally
    methods.addAll([
      PaymentMethodOption(
        type: PaymentType.visa,
        name: 'Visa',
        icon: Icons.credit_card,
        processingFee: amount * 0.029, // 2.9%
        isPopular: true,
      ),
      PaymentMethodOption(
        type: PaymentType.mastercard,
        name: 'Mastercard',
        icon: Icons.credit_card,
        processingFee: amount * 0.029,
        isPopular: true,
      ),
      PaymentMethodOption(
        type: PaymentType.amex,
        name: 'American Express',
        icon: Icons.credit_card,
        processingFee: amount * 0.035, // 3.5%
      ),
    ]);

    // Digital Wallets based on region
    if (country == 'ID') {
      methods.addAll([
        PaymentMethodOption(
          type: PaymentType.gopay,
          name: 'GoPay',
          icon: Icons.account_balance_wallet,
          processingFee: amount * 0.02,
          isPopular: true,
        ),
        PaymentMethodOption(
          type: PaymentType.ovo,
          name: 'OVO',
          icon: Icons.account_balance_wallet,
          processingFee: amount * 0.02,
        ),
        PaymentMethodOption(
          type: PaymentType.dana,
          name: 'DANA',
          icon: Icons.account_balance_wallet,
          processingFee: amount * 0.02,
        ),
        PaymentMethodOption(
          type: PaymentType.shopeePay,
          name: 'ShopeePay',
          icon: Icons.account_balance_wallet,
          processingFee: amount * 0.025,
        ),
        PaymentMethodOption(
          type: PaymentType.qris,
          name: 'QRIS',
          icon: Icons.qr_code,
          processingFee: amount * 0.007,
          isPopular: true,
        ),
      ]);
    } else if (country == 'MY') {
      methods.addAll([
        PaymentMethodOption(
          type: PaymentType.touchNGo,
          name: 'Touch \'n Go',
          icon: Icons.account_balance_wallet,
          processingFee: amount * 0.018,
          isPopular: true,
        ),
        PaymentMethodOption(
          type: PaymentType.grabPay,
          name: 'GrabPay',
          icon: Icons.account_balance_wallet,
          processingFee: amount * 0.02,
        ),
      ]);
    }

    // Global payment methods
    methods.addAll([
      PaymentMethodOption(
        type: PaymentType.paypal,
        name: 'PayPal',
        icon: Icons.payment,
        processingFee: amount * 0.034,
      ),
      PaymentMethodOption(
        type: PaymentType.alipay,
        name: 'Alipay',
        icon: Icons.account_balance_wallet,
        processingFee: amount * 0.025,
      ),
    ]);

    // Bank Transfer
    methods.add(
      PaymentMethodOption(
        type: PaymentType.bankTransfer,
        name: 'Bank Transfer',
        icon: Icons.account_balance,
        processingFee: 0,
        processingTime: '1-2 business days',
      ),
    );

    // Platform-specific payment methods
    methods.addAll([
      PaymentMethodOption(
        type: PaymentType.applePay,
        name: 'Apple Pay',
        icon: Icons.phone_iphone,
        processingFee: amount * 0.03,
        requiresPlatform: 'ios',
      ),
      PaymentMethodOption(
        type: PaymentType.googlePay,
        name: 'Google Pay',
        icon: Icons.phone_android,
        processingFee: amount * 0.03,
        requiresPlatform: 'android',
      ),
    ]);

    return methods;
  }

  // Process payment
  Future<PaymentResult> processPayment({
    required PaymentMethod paymentMethod,
    required double amount,
    required String currency,
    required Map<String, dynamic> orderDetails,
  }) async {
    try {
      final gateway = _gateways[paymentMethod.type];
      if (gateway == null) {
        throw Exception('Payment method not supported');
      }

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      final result = await gateway.processPayment(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
        orderDetails: orderDetails,
      );

      return result;
    } catch (e) {
      return PaymentResult(
        success: false,
        transactionId: null,
        errorMessage: e.toString(),
      );
    }
  }

  // Validate payment method
  Future<bool> validatePaymentMethod(PaymentMethod method) async {
    switch (method.type) {
      case PaymentType.creditCard:
      case PaymentType.debitCard:
        return _validateCard(method);
      case PaymentType.bankTransfer:
        return _validateBankAccount(method);
      default:
        return true;
    }
  }

  bool _validateCard(PaymentMethod method) {
    if (method.cardLast4 == null || method.cardLast4!.length != 4) {
      return false;
    }
    // Add more card validation logic
    return true;
  }

  bool _validateBankAccount(PaymentMethod method) {
    if (method.accountNumber == null || method.bankName == null) {
      return false;
    }
    return true;
  }

  // Get supported banks by country
  List<Bank> getSupportedBanks(String country) {
    switch (country) {
      case 'ID':
        return [
          Bank('BCA', 'Bank Central Asia'),
          Bank('BNI', 'Bank Negara Indonesia'),
          Bank('BRI', 'Bank Rakyat Indonesia'),
          Bank('Mandiri', 'Bank Mandiri'),
          Bank('CIMB', 'CIMB Niaga'),
          Bank('Danamon', 'Bank Danamon'),
          Bank('Permata', 'Bank Permata'),
          Bank('BTN', 'Bank Tabungan Negara'),
          Bank('Maybank', 'Maybank Indonesia'),
          Bank('Panin', 'Bank Panin'),
          Bank('OCBC', 'OCBC NISP'),
          Bank('Bukopin', 'Bank Bukopin'),
          Bank('BSI', 'Bank Syariah Indonesia'),
          Bank('Muamalat', 'Bank Muamalat'),
        ];
      case 'MY':
        return [
          Bank('Maybank', 'Malayan Banking Berhad'),
          Bank('CIMB', 'CIMB Bank'),
          Bank('PublicBank', 'Public Bank Berhad'),
          Bank('RHB', 'RHB Bank'),
          Bank('HongLeong', 'Hong Leong Bank'),
          Bank('AmBank', 'AmBank'),
          Bank('UOB', 'United Overseas Bank'),
          Bank('OCBC', 'OCBC Bank'),
          Bank('HSBC', 'HSBC Bank Malaysia'),
          Bank('StandardChartered', 'Standard Chartered'),
          Bank('Affin', 'Affin Bank'),
          Bank('Alliance', 'Alliance Bank'),
          Bank('BSN', 'Bank Simpanan Nasional'),
          Bank('BankIslam', 'Bank Islam Malaysia'),
          Bank('BankRakyat', 'Bank Rakyat'),
        ];
      case 'SG':
        return [
          Bank('DBS', 'DBS Bank'),
          Bank('OCBC', 'Oversea-Chinese Banking Corporation'),
          Bank('UOB', 'United Overseas Bank'),
          Bank('HSBC', 'HSBC Singapore'),
          Bank('StandardChartered', 'Standard Chartered Singapore'),
          Bank('Citibank', 'Citibank Singapore'),
          Bank('Maybank', 'Maybank Singapore'),
          Bank('CIMB', 'CIMB Bank Singapore'),
        ];
      default:
        return [
          Bank('HSBC', 'HSBC'),
          Bank('StandardChartered', 'Standard Chartered'),
          Bank('Citibank', 'Citibank'),
          Bank('BankOfAmerica', 'Bank of America'),
          Bank('JPMorgan', 'JPMorgan Chase'),
          Bank('Wells Fargo', 'Wells Fargo'),
          Bank('Barclays', 'Barclays'),
          Bank('DeutscheBank', 'Deutsche Bank'),
        ];
    }
  }
}

class PaymentMethodOption {
  final PaymentType type;
  final String name;
  final IconData icon;
  final double processingFee;
  final String? processingTime;
  final bool isPopular;
  final String? requiresPlatform;

  PaymentMethodOption({
    required this.type,
    required this.name,
    required this.icon,
    required this.processingFee,
    this.processingTime,
    this.isPopular = false,
    this.requiresPlatform,
  });
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final String? errorMessage;
  final Map<String, dynamic>? additionalData;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.errorMessage,
    this.additionalData,
  });
}

class Bank {
  final String code;
  final String name;

  Bank(this.code, this.name);
}

// Payment Gateway Interfaces
abstract class PaymentGateway {
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> orderDetails,
  });
}

class CreditCardGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> orderDetails,
  }) async {
    // Simulate credit card processing
    await Future.delayed(const Duration(seconds: 2));
    return PaymentResult(
      success: true,
      transactionId: 'CC${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

class BankTransferGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> orderDetails,
  }) async {
    // Simulate bank transfer
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult(
      success: true,
      transactionId: 'BT${DateTime.now().millisecondsSinceEpoch}',
      additionalData: {
        'virtualAccount': '8806${DateTime.now().millisecondsSinceEpoch % 10000}',
        'expiryTime': DateTime.now().add(const Duration(hours: 24)),
      },
    );
  }
}

class QRISGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> orderDetails,
  }) async {
    // Generate QRIS code
    await Future.delayed(const Duration(milliseconds: 500));
    return PaymentResult(
      success: true,
      transactionId: 'QR${DateTime.now().millisecondsSinceEpoch}',
      additionalData: {
        'qrCode': 'https://api.qris.id/qr/${DateTime.now().millisecondsSinceEpoch}',
        'expiryTime': DateTime.now().add(const Duration(minutes: 15)),
      },
    );
  }
}

class DigitalWalletGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> orderDetails,
  }) async {
    // Redirect to wallet app
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult(
      success: true,
      transactionId: 'DW${DateTime.now().millisecondsSinceEpoch}',
      additionalData: {
        'deepLink': 'wallet://pay?amount=$amount&ref=${DateTime.now().millisecondsSinceEpoch}',
      },
    );
  }
}

class PayPalGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> orderDetails,
  }) async {
    // PayPal integration
    await Future.delayed(const Duration(seconds: 2));
    return PaymentResult(
      success: true,
      transactionId: 'PP${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

class ApplePayGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> orderDetails,
  }) async {
    // Apple Pay integration
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult(
      success: true,
      transactionId: 'AP${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}

class GooglePayGateway implements PaymentGateway {
  @override
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required PaymentMethod paymentMethod,
    required Map<String, dynamic> orderDetails,
  }) async {
    // Google Pay integration
    await Future.delayed(const Duration(seconds: 1));
    return PaymentResult(
      success: true,
      transactionId: 'GP${DateTime.now().millisecondsSinceEpoch}',
    );
  }
} 