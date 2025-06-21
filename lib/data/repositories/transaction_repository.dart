import 'dart:async';
import '../models/transaction_model.dart';

class TransactionRepository {
  static final TransactionRepository _instance = TransactionRepository._internal();
  factory TransactionRepository() => _instance;
  TransactionRepository._internal();

  // Mock database
  final List<TransactionModel> _transactions = [];
  final _transactionController = StreamController<List<TransactionModel>>.broadcast();

  Stream<List<TransactionModel>> get transactionStream => _transactionController.stream;

  // Initialize with mock data
  void init() {
    _generateMockTransactions();
    _transactionController.add(_transactions);
  }

  void _generateMockTransactions() {
    final now = DateTime.now();
    
    // Flight transaction
    _transactions.add(
      TransactionModel(
        id: 'TRX001',
        userId: 'user123',
        type: TransactionType.flight,
        status: TransactionStatus.completed,
        amount: 2500000,
        currency: 'IDR',
        paymentMethod: PaymentMethod(
          type: PaymentType.visa,
          cardLast4: '4242',
          cardBrand: 'Visa',
        ),
        createdAt: now.subtract(const Duration(days: 30)),
        completedAt: now.subtract(const Duration(days: 30)),
        details: TransactionDetails(
          title: 'Jakarta to Singapore',
          description: 'Lion Air JT-153',
          imageUrl: 'https://example.com/lion-air.png',
          itemDetails: {
            'airline': 'Lion Air',
            'flightNumber': 'JT-153',
            'class': 'Economy',
            'seats': ['12A', '12B'],
          },
          departureDate: now.add(const Duration(days: 15)),
          arrivalDate: now.add(const Duration(days: 15, hours: 2)),
          origin: 'CGK - Jakarta',
          destination: 'SIN - Singapore',
          quantity: 2,
          passengerNames: ['John Doe', 'Jane Doe'],
        ),
        refundInfo: RefundInfo(
          refundPolicy: RefundPolicy(
            name: 'Standard Flight Refund',
            tiers: [
              RefundTier(daysBeforeDeparture: 14, refundPercentage: 90),
              RefundTier(daysBeforeDeparture: 7, refundPercentage: 50),
              RefundTier(daysBeforeDeparture: 3, refundPercentage: 25),
              RefundTier(daysBeforeDeparture: 0, refundPercentage: 0),
            ],
          ),
          departureDate: now.add(const Duration(days: 15)),
          requestedAt: now,
          status: RefundStatus.requested,
        ),
        history: [
          TransactionHistory(
            action: 'Payment Initiated',
            timestamp: now.subtract(const Duration(days: 30)),
          ),
          TransactionHistory(
            action: 'Payment Completed',
            timestamp: now.subtract(const Duration(days: 30)),
          ),
        ],
        referenceNumber: 'LNR-2024-001234',
      ),
    );

    // Train transaction
    _transactions.add(
      TransactionModel(
        id: 'TRX002',
        userId: 'user123',
        type: TransactionType.train,
        status: TransactionStatus.refundable,
        amount: 350000,
        currency: 'IDR',
        paymentMethod: PaymentMethod(
          type: PaymentType.gopay,
          walletType: 'GoPay',
        ),
        createdAt: now.subtract(const Duration(days: 5)),
        completedAt: now.subtract(const Duration(days: 5)),
        details: TransactionDetails(
          title: 'Jakarta to Bandung',
          description: 'Argo Parahyangan - Executive',
          imageUrl: 'https://example.com/kai.png',
          itemDetails: {
            'trainName': 'Argo Parahyangan',
            'trainNumber': 'AP-23',
            'class': 'Executive',
            'seats': ['5A'],
          },
          departureDate: now.add(const Duration(days: 2)),
          arrivalDate: now.add(const Duration(days: 2, hours: 3)),
          origin: 'Gambir Station',
          destination: 'Bandung Station',
          quantity: 1,
        ),
        refundInfo: RefundInfo(
          refundPolicy: RefundPolicy(
            name: 'Train Ticket Refund',
            tiers: [
              RefundTier(daysBeforeDeparture: 3, refundPercentage: 85),
              RefundTier(daysBeforeDeparture: 1, refundPercentage: 50),
              RefundTier(daysBeforeDeparture: 0, refundPercentage: 0),
            ],
          ),
          departureDate: now.add(const Duration(days: 2)),
          requestedAt: now,
          status: RefundStatus.requested,
        ),
        history: [
          TransactionHistory(
            action: 'Booking Created',
            timestamp: now.subtract(const Duration(days: 5)),
          ),
          TransactionHistory(
            action: 'Payment Completed',
            timestamp: now.subtract(const Duration(days: 5)),
          ),
        ],
        referenceNumber: 'KAI-2024-005678',
      ),
    );

    // Hotel transaction
    _transactions.add(
      TransactionModel(
        id: 'TRX003',
        userId: 'user123',
        type: TransactionType.hotel,
        status: TransactionStatus.completed,
        amount: 1200000,
        currency: 'IDR',
        paymentMethod: PaymentMethod(
          type: PaymentType.bankTransfer,
          bankName: 'BCA',
          accountNumber: '1234567890',
        ),
        createdAt: now.subtract(const Duration(days: 45)),
        completedAt: now.subtract(const Duration(days: 44)),
        details: TransactionDetails(
          title: 'Grand Hyatt Jakarta',
          description: 'Deluxe Room - 2 Nights',
          imageUrl: 'https://example.com/hyatt.png',
          itemDetails: {
            'hotelName': 'Grand Hyatt Jakarta',
            'roomType': 'Deluxe Room',
            'checkIn': '2024-01-15',
            'checkOut': '2024-01-17',
            'nights': 2,
            'guests': 2,
          },
          merchantName: 'Grand Hyatt Jakarta',
          quantity: 1,
        ),
        history: [
          TransactionHistory(
            action: 'Reservation Made',
            timestamp: now.subtract(const Duration(days: 45)),
          ),
          TransactionHistory(
            action: 'Payment Verified',
            timestamp: now.subtract(const Duration(days: 44)),
          ),
          TransactionHistory(
            action: 'Check-in Completed',
            timestamp: now.subtract(const Duration(days: 20)),
          ),
        ],
        referenceNumber: 'HTL-2024-009012',
      ),
    );

    // Hajj package transaction
    _transactions.add(
      TransactionModel(
        id: 'TRX004',
        userId: 'user123',
        type: TransactionType.hajjUmroh,
        status: TransactionStatus.processing,
        amount: 35000000,
        currency: 'IDR',
        paymentMethod: PaymentMethod(
          type: PaymentType.bankTransfer,
          bankName: 'BSI',
          accountNumber: '9876543210',
        ),
        createdAt: now.subtract(const Duration(days: 10)),
        completedAt: null,
        details: TransactionDetails(
          title: 'Hajj Package 2024 - Premium',
          description: '40 Days Full Service Package',
          imageUrl: 'https://example.com/hajj.png',
          itemDetails: {
            'packageType': 'Premium Hajj',
            'duration': '40 days',
            'departureMonth': 'June 2024',
            'services': ['Flight', 'Hotel', 'Transportation', 'Guide', 'Visa'],
            'makkahHotel': 'Hilton Makkah',
            'madinahHotel': 'Sheraton Madinah',
          },
          merchantName: 'Al-Haramain Travel',
          departureDate: DateTime(2024, 6, 15),
          quantity: 1,
        ),
        refundInfo: RefundInfo(
          refundPolicy: RefundPolicy(
            name: 'Hajj Package Refund Policy',
            tiers: [
              RefundTier(daysBeforeDeparture: 90, refundPercentage: 80),
              RefundTier(daysBeforeDeparture: 60, refundPercentage: 50),
              RefundTier(daysBeforeDeparture: 30, refundPercentage: 20),
              RefundTier(daysBeforeDeparture: 0, refundPercentage: 0),
            ],
            conditions: [
              'Visa rejection: 100% refund',
              'Medical emergency with certificate: 90% refund',
              'Force majeure: Case by case basis',
            ],
          ),
          departureDate: DateTime(2024, 6, 15),
          requestedAt: now,
          status: RefundStatus.requested,
        ),
        history: [
          TransactionHistory(
            action: 'Booking Created',
            timestamp: now.subtract(const Duration(days: 10)),
          ),
          TransactionHistory(
            action: 'Down Payment Received (30%)',
            timestamp: now.subtract(const Duration(days: 10)),
          ),
          TransactionHistory(
            action: 'Document Verification in Progress',
            timestamp: now.subtract(const Duration(days: 5)),
          ),
        ],
        referenceNumber: 'HAJ-2024-003456',
      ),
    );

    // Food delivery transaction
    _transactions.add(
      TransactionModel(
        id: 'TRX005',
        userId: 'user123',
        type: TransactionType.food,
        status: TransactionStatus.completed,
        amount: 125000,
        currency: 'IDR',
        paymentMethod: PaymentMethod(
          type: PaymentType.ovo,
          walletType: 'OVO',
        ),
        createdAt: now.subtract(const Duration(hours: 4)),
        completedAt: now.subtract(const Duration(hours: 3)),
        details: TransactionDetails(
          title: 'McDonald\'s Order',
          description: 'Big Mac Meal x2, McFlurry x1',
          imageUrl: 'https://example.com/mcdonalds.png',
          itemDetails: {
            'items': [
              {'name': 'Big Mac Meal', 'quantity': 2, 'price': 55000},
              {'name': 'McFlurry Oreo', 'quantity': 1, 'price': 15000},
            ],
            'deliveryFee': 10000,
            'discount': 5000,
          },
          merchantName: 'McDonald\'s Grand Indonesia',
        ),
        history: [
          TransactionHistory(
            action: 'Order Placed',
            timestamp: now.subtract(const Duration(hours: 4)),
          ),
          TransactionHistory(
            action: 'Restaurant Confirmed',
            timestamp: now.subtract(const Duration(hours: 4)),
          ),
          TransactionHistory(
            action: 'Driver Assigned',
            timestamp: now.subtract(const Duration(hours: 3, minutes: 45)),
          ),
          TransactionHistory(
            action: 'Order Delivered',
            timestamp: now.subtract(const Duration(hours: 3)),
          ),
        ],
        referenceNumber: 'FD-2024-789012',
      ),
    );
  }

  // Get all transactions
  Future<List<TransactionModel>> getAllTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _transactions.where((t) => t.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get transactions by type
  Future<List<TransactionModel>> getTransactionsByType(
    String userId,
    TransactionType type,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _transactions
        .where((t) => t.userId == userId && t.type == type)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // Get transaction by ID
  Future<TransactionModel?> getTransactionById(String transactionId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _transactions.firstWhere((t) => t.id == transactionId);
    } catch (e) {
      return null;
    }
  }

  // Request refund
  Future<bool> requestRefund(String transactionId, String reason) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) return false;

    final transaction = _transactions[index];
    if (transaction.status != TransactionStatus.completed &&
        transaction.status != TransactionStatus.refundable) {
      return false;
    }

    // Calculate refund amount
    final refundAmount = transaction.calculateRefundAmount();
    if (refundAmount <= 0) return false;

    // Update transaction with refund info
    final updatedTransaction = TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      type: transaction.type,
      status: TransactionStatus.refundable,
      amount: transaction.amount,
      currency: transaction.currency,
      paymentMethod: transaction.paymentMethod,
      createdAt: transaction.createdAt,
      updatedAt: DateTime.now(),
      completedAt: transaction.completedAt,
      details: transaction.details,
      refundInfo: RefundInfo(
        refundPolicy: transaction.refundInfo!.refundPolicy,
        departureDate: transaction.refundInfo!.departureDate,
        requestedAt: DateTime.now(),
        status: RefundStatus.requested,
        refundAmount: refundAmount,
        reason: reason,
      ),
      history: [
        ...transaction.history,
        TransactionHistory(
          action: 'Refund Requested',
          timestamp: DateTime.now(),
          details: {'reason': reason, 'amount': refundAmount},
        ),
      ],
      referenceNumber: transaction.referenceNumber,
      metadata: transaction.metadata,
    );

    _transactions[index] = updatedTransaction;
    _transactionController.add(_transactions);
    
    return true;
  }

  // Process refund (admin function)
  Future<bool> processRefund(
    String transactionId,
    bool approved, {
    String? notes,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index == -1) return false;

    final transaction = _transactions[index];
    if (transaction.refundInfo?.status != RefundStatus.requested) {
      return false;
    }

    final newStatus = approved ? RefundStatus.approved : RefundStatus.rejected;
    final transactionStatus = approved 
        ? TransactionStatus.refunded 
        : TransactionStatus.completed;

    // Update transaction
    final updatedTransaction = TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      type: transaction.type,
      status: transactionStatus,
      amount: transaction.amount,
      currency: transaction.currency,
      paymentMethod: transaction.paymentMethod,
      createdAt: transaction.createdAt,
      updatedAt: DateTime.now(),
      completedAt: transaction.completedAt,
      details: transaction.details,
      refundInfo: RefundInfo(
        refundPolicy: transaction.refundInfo!.refundPolicy,
        departureDate: transaction.refundInfo!.departureDate,
        requestedAt: transaction.refundInfo!.requestedAt,
        status: newStatus,
        refundAmount: transaction.refundInfo!.refundAmount,
        reason: transaction.refundInfo!.reason,
        processedBy: 'System Admin',
        processedAt: DateTime.now(),
        notes: notes,
      ),
      history: [
        ...transaction.history,
        TransactionHistory(
          action: approved ? 'Refund Approved' : 'Refund Rejected',
          timestamp: DateTime.now(),
          performedBy: 'System Admin',
          details: {
            'status': newStatus.name,
            'notes': notes,
            if (approved) 'refundAmount': transaction.refundInfo!.refundAmount,
          },
        ),
      ],
      referenceNumber: transaction.referenceNumber,
      metadata: transaction.metadata,
    );

    _transactions[index] = updatedTransaction;
    _transactionController.add(_transactions);
    
    // If approved, initiate actual refund process
    if (approved) {
      // This would integrate with payment gateway for actual refund
      await Future.delayed(const Duration(seconds: 1));
    }
    
    return true;
  }

  // Add new transaction
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _transactions.add(transaction);
    _transactionController.add(_transactions);
    return transaction;
  }

  // Get transaction statistics
  Future<TransactionStatistics> getTransactionStatistics(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final userTransactions = _transactions.where((t) => t.userId == userId);
    
    final totalSpent = userTransactions
        .where((t) => t.status == TransactionStatus.completed)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final totalRefunded = userTransactions
        .where((t) => t.status == TransactionStatus.refunded)
        .fold(0.0, (sum, t) => sum + (t.refundInfo?.refundAmount ?? 0));
    
    final pendingRefunds = userTransactions
        .where((t) => t.refundInfo?.status == RefundStatus.requested)
        .length;
    
    final transactionsByType = <TransactionType, int>{};
    for (final transaction in userTransactions) {
      transactionsByType[transaction.type] = 
          (transactionsByType[transaction.type] ?? 0) + 1;
    }
    
    return TransactionStatistics(
      totalTransactions: userTransactions.length,
      totalSpent: totalSpent,
      totalRefunded: totalRefunded,
      pendingRefunds: pendingRefunds,
      transactionsByType: transactionsByType,
    );
  }

  void dispose() {
    _transactionController.close();
  }
}

class TransactionStatistics {
  final int totalTransactions;
  final double totalSpent;
  final double totalRefunded;
  final int pendingRefunds;
  final Map<TransactionType, int> transactionsByType;

  TransactionStatistics({
    required this.totalTransactions,
    required this.totalSpent,
    required this.totalRefunded,
    required this.pendingRefunds,
    required this.transactionsByType,
  });
} 