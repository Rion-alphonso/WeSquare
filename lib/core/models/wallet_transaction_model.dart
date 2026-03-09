/// Transaction type
enum TransactionType { credit, debit }

/// Transaction status
enum TransactionStatus { pending, completed, failed, cancelled }

/// Wallet transaction model
class WalletTransaction {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;
  final TransactionStatus status;
  final String description;
  final String? referenceId;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    this.status = TransactionStatus.completed,
    required this.description,
    this.referenceId,
    required this.createdAt,
  });

  bool get isCredit => type == TransactionType.credit;
  bool get isDebit => type == TransactionType.debit;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.debit,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
      description: json['description'] as String,
      referenceId: json['referenceId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type.name,
      'status': status.name,
      'description': description,
      'referenceId': referenceId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static List<WalletTransaction> mockList() {
    final now = DateTime.now();
    return [
      WalletTransaction(
        id: 'txn_001',
        userId: 'usr_001',
        amount: 500,
        type: TransactionType.credit,
        description: 'Added money via UPI',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      WalletTransaction(
        id: 'txn_002',
        userId: 'usr_001',
        amount: 50,
        type: TransactionType.debit,
        description: 'Joined WeSquare Pro League #1',
        referenceId: 'trn_001',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      WalletTransaction(
        id: 'txn_003',
        userId: 'usr_001',
        amount: 2000,
        type: TransactionType.credit,
        description: 'Won 1st prize — Weekend Classic',
        referenceId: 'trn_005',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      WalletTransaction(
        id: 'txn_004',
        userId: 'usr_001',
        amount: 1000,
        type: TransactionType.debit,
        status: TransactionStatus.pending,
        description: 'Withdrawal to UPI (user@upi)',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      WalletTransaction(
        id: 'txn_005',
        userId: 'usr_001',
        amount: 100,
        type: TransactionType.debit,
        description: 'Joined Squad Showdown',
        referenceId: 'trn_002',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }
}
