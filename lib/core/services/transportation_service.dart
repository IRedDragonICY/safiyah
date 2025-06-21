import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class TransportationService {
  static final TransportationService _instance = TransportationService._internal();
  factory TransportationService() => _instance;
  TransportationService._internal();

  bool _nfcEnabled = false;
  bool _nfcAvailable = false;
  StreamController<bool> _nfcStatusController = StreamController<bool>.broadcast();

  Stream<bool> get nfcStatusStream => _nfcStatusController.stream;
  bool get isNFCEnabled => _nfcEnabled;
  bool get isNFCAvailable => _nfcAvailable;

  Future<void> initialize() async {
    await _checkNFCAvailability();
    await _initializeNFC();
  }

  Future<void> _checkNFCAvailability() async {
    try {
      // Simulate NFC availability check
      await Future.delayed(const Duration(milliseconds: 500));
      _nfcAvailable = true;
      debugPrint('NFC is available on this device');
    } catch (e) {
      _nfcAvailable = false;
      debugPrint('NFC is not available: $e');
    }
  }

  Future<void> _initializeNFC() async {
    if (!_nfcAvailable) return;
    
    try {
      // Simulate NFC initialization
      await Future.delayed(const Duration(milliseconds: 300));
      _nfcEnabled = true;
      _nfcStatusController.add(_nfcEnabled);
      debugPrint('NFC initialized successfully');
    } catch (e) {
      _nfcEnabled = false;
      _nfcStatusController.add(_nfcEnabled);
      debugPrint('Failed to initialize NFC: $e');
    }
  }

  Future<bool> enableNFC() async {
    if (!_nfcAvailable) {
      throw Exception('NFC is not available on this device');
    }

    try {
      // Simulate enabling NFC
      await Future.delayed(const Duration(milliseconds: 500));
      _nfcEnabled = true;
      _nfcStatusController.add(_nfcEnabled);
      return true;
    } catch (e) {
      debugPrint('Failed to enable NFC: $e');
      return false;
    }
  }

  Future<bool> disableNFC() async {
    try {
      // Simulate disabling NFC
      await Future.delayed(const Duration(milliseconds: 300));
      _nfcEnabled = false;
      _nfcStatusController.add(_nfcEnabled);
      return true;
    } catch (e) {
      debugPrint('Failed to disable NFC: $e');
      return false;
    }
  }

  Future<PaymentResult> processNFCPayment({
    required double amount,
    required String currency,
    required String transportType,
    required String route,
    Map<String, dynamic>? metadata,
  }) async {
    if (!_nfcEnabled) {
      throw Exception('NFC is not enabled');
    }

    try {
      // Simulate NFC payment processing
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate payment success/failure
      final success = DateTime.now().millisecond % 10 != 0; // 90% success rate
      
      if (success) {
        return PaymentResult(
          success: true,
          transactionId: _generateTransactionId(),
          amount: amount,
          currency: currency,
          timestamp: DateTime.now(),
          paymentMethod: 'NFC',
          receipt: PaymentReceipt(
            transactionId: _generateTransactionId(),
            amount: amount,
            currency: currency,
            transportType: transportType,
            route: route,
            timestamp: DateTime.now(),
            metadata: metadata,
          ),
        );
      } else {
        return PaymentResult(
          success: false,
          error: 'Payment declined',
          timestamp: DateTime.now(),
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        error: 'Payment processing failed: $e',
        timestamp: DateTime.now(),
      );
    }
  }

  String _generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'TXN$timestamp$random';
  }

  Future<List<PaymentMethod>> getSupportedPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      PaymentMethod(
        id: 'nfc',
        name: 'NFC Payment',
        type: PaymentType.nfc,
        isAvailable: _nfcEnabled,
        icon: '📱',
        supportedCards: ['Suica', 'Pasmo', 'ICOCA', 'Credit Card'],
      ),
      PaymentMethod(
        id: 'ic_card',
        name: 'IC Card',
        type: PaymentType.icCard,
        isAvailable: true,
        icon: '💳',
        supportedCards: ['Suica', 'Pasmo', 'ICOCA', 'Kitaca'],
      ),
      PaymentMethod(
        id: 'qr_code',
        name: 'QR Code',
        type: PaymentType.qrCode,
        isAvailable: true,
        icon: '📱',
        supportedCards: ['PayPay', 'Line Pay', 'Rakuten Pay'],
      ),
      PaymentMethod(
        id: 'cash',
        name: 'Cash',
        type: PaymentType.cash,
        isAvailable: true,
        icon: '💴',
        supportedCards: [],
      ),
    ];
  }

  void dispose() {
    _nfcStatusController.close();
  }
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final double? amount;
  final String? currency;
  final String? error;
  final DateTime timestamp;
  final String? paymentMethod;
  final PaymentReceipt? receipt;

  PaymentResult({
    required this.success,
    this.transactionId,
    this.amount,
    this.currency,
    this.error,
    required this.timestamp,
    this.paymentMethod,
    this.receipt,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'transactionId': transactionId,
      'amount': amount,
      'currency': currency,
      'error': error,
      'timestamp': timestamp.toIso8601String(),
      'paymentMethod': paymentMethod,
      'receipt': receipt?.toJson(),
    };
  }
}

class PaymentReceipt {
  final String transactionId;
  final double amount;
  final String currency;
  final String transportType;
  final String route;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PaymentReceipt({
    required this.transactionId,
    required this.amount,
    required this.currency,
    required this.transportType,
    required this.route,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'amount': amount,
      'currency': currency,
      'transportType': transportType,
      'route': route,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

enum PaymentType { nfc, icCard, qrCode, cash, creditCard }

class PaymentMethod {
  final String id;
  final String name;
  final PaymentType type;
  final bool isAvailable;
  final String icon;
  final List<String> supportedCards;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    required this.isAvailable,
    required this.icon,
    required this.supportedCards,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'isAvailable': isAvailable,
      'icon': icon,
      'supportedCards': supportedCards,
    };
  }
} 