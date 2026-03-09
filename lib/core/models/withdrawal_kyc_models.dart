/// Withdrawal request status
enum WithdrawalStatus { pending, approved, rejected, processed }

/// Withdrawal request model
class WithdrawalRequest {
  final String id;
  final String userId;
  final double amount;
  final WithdrawalStatus status;
  final String upiId;
  final String? rejectReason;
  final DateTime createdAt;
  final DateTime? processedAt;

  const WithdrawalRequest({
    required this.id,
    required this.userId,
    required this.amount,
    this.status = WithdrawalStatus.pending,
    required this.upiId,
    this.rejectReason,
    required this.createdAt,
    this.processedAt,
  });

  factory WithdrawalRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequest(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: WithdrawalStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => WithdrawalStatus.pending,
      ),
      upiId: json['upiId'] as String,
      rejectReason: json['rejectReason'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'amount': amount,
    'status': status.name,
    'upiId': upiId,
    'rejectReason': rejectReason,
    'createdAt': createdAt.toIso8601String(),
    'processedAt': processedAt?.toIso8601String(),
  };

  static List<WithdrawalRequest> mockList() {
    final now = DateTime.now();
    return [
      WithdrawalRequest(id: 'wd_001', userId: 'usr_001', amount: 1000, upiId: 'gamer@upi', status: WithdrawalStatus.pending, createdAt: now.subtract(const Duration(hours: 6))),
      WithdrawalRequest(id: 'wd_002', userId: 'usr_002', amount: 500, upiId: 'sniper@paytm', status: WithdrawalStatus.approved, createdAt: now.subtract(const Duration(days: 1)), processedAt: now.subtract(const Duration(hours: 12))),
      WithdrawalRequest(id: 'wd_003', userId: 'usr_003', amount: 2000, upiId: 'rush@gpay', status: WithdrawalStatus.rejected, rejectReason: 'KYC not verified', createdAt: now.subtract(const Duration(days: 2))),
    ];
  }
}

/// KYC document type
enum KycDocumentType { aadhaar, pan, drivingLicense, passport }

/// KYC status
enum KycVerificationStatus { pending, approved, rejected }

/// KYC model
class KycModel {
  final String id;
  final String userId;
  final KycDocumentType documentType;
  final String documentUrl;
  final KycVerificationStatus status;
  final String? rejectReason;
  final DateTime submittedAt;

  const KycModel({
    required this.id,
    required this.userId,
    required this.documentType,
    required this.documentUrl,
    this.status = KycVerificationStatus.pending,
    this.rejectReason,
    required this.submittedAt,
  });

  factory KycModel.fromJson(Map<String, dynamic> json) {
    return KycModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      documentType: KycDocumentType.values.firstWhere(
        (e) => e.name == json['documentType'],
        orElse: () => KycDocumentType.aadhaar,
      ),
      documentUrl: json['documentUrl'] as String,
      status: KycVerificationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => KycVerificationStatus.pending,
      ),
      rejectReason: json['rejectReason'] as String?,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'documentType': documentType.name,
    'documentUrl': documentUrl,
    'status': status.name,
    'rejectReason': rejectReason,
    'submittedAt': submittedAt.toIso8601String(),
  };
}

/// Notification type
enum NotificationType { tournamentReminder, roomReleased, resultPublished, withdrawalApproved, general }

/// App notification model
class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final String? referenceId;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    this.type = NotificationType.general,
    this.isRead = false,
    this.referenceId,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.general,
      ),
      isRead: json['isRead'] as bool? ?? false,
      referenceId: json['referenceId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type.name,
    'isRead': isRead,
    'referenceId': referenceId,
    'createdAt': createdAt.toIso8601String(),
  };
}
