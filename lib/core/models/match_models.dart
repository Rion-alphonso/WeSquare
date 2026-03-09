/// Registration status
enum RegistrationStatus { confirmed, cancelled, waitlisted }

/// Tournament registration model
class TournamentRegistration {
  final String id;
  final String tournamentId;
  final String userId;
  final RegistrationStatus status;
  final DateTime registeredAt;

  const TournamentRegistration({
    required this.id,
    required this.tournamentId,
    required this.userId,
    this.status = RegistrationStatus.confirmed,
    required this.registeredAt,
  });

  factory TournamentRegistration.fromJson(Map<String, dynamic> json) {
    return TournamentRegistration(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      userId: json['userId'] as String,
      status: RegistrationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RegistrationStatus.confirmed,
      ),
      registeredAt: DateTime.parse(json['registeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tournamentId': tournamentId,
    'userId': userId,
    'status': status.name,
    'registeredAt': registeredAt.toIso8601String(),
  };
}

/// Match result model for a player in a tournament
class MatchResult {
  final String id;
  final String tournamentId;
  final String userId;
  final String username;
  final int kills;
  final int placement;
  final double totalPoints;
  final String? screenshotUrl;

  const MatchResult({
    required this.id,
    required this.tournamentId,
    required this.userId,
    required this.username,
    required this.kills,
    required this.placement,
    required this.totalPoints,
    this.screenshotUrl,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      id: json['id'] as String,
      tournamentId: json['tournamentId'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      kills: json['kills'] as int,
      placement: json['placement'] as int,
      totalPoints: (json['totalPoints'] as num).toDouble(),
      screenshotUrl: json['screenshotUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'tournamentId': tournamentId,
    'userId': userId,
    'username': username,
    'kills': kills,
    'placement': placement,
    'totalPoints': totalPoints,
    'screenshotUrl': screenshotUrl,
  };

  static List<MatchResult> mockLeaderboard() {
    return [
      const MatchResult(id: 'mr_001', tournamentId: 'trn_005', userId: 'usr_001', username: 'ProGamer99', kills: 12, placement: 1, totalPoints: 42.0),
      const MatchResult(id: 'mr_002', tournamentId: 'trn_005', userId: 'usr_002', username: 'SniperKing', kills: 9, placement: 2, totalPoints: 34.0),
      const MatchResult(id: 'mr_003', tournamentId: 'trn_005', userId: 'usr_003', username: 'RushMaster', kills: 11, placement: 5, totalPoints: 31.0),
      const MatchResult(id: 'mr_004', tournamentId: 'trn_005', userId: 'usr_004', username: 'ClutchGod', kills: 8, placement: 3, totalPoints: 29.0),
      const MatchResult(id: 'mr_005', tournamentId: 'trn_005', userId: 'usr_005', username: 'HeadshotAce', kills: 7, placement: 4, totalPoints: 27.0),
      const MatchResult(id: 'mr_006', tournamentId: 'trn_005', userId: 'usr_006', username: 'Destroyer', kills: 6, placement: 8, totalPoints: 21.0),
      const MatchResult(id: 'mr_007', tournamentId: 'trn_005', userId: 'usr_007', username: 'NightOwl', kills: 5, placement: 6, totalPoints: 20.0),
      const MatchResult(id: 'mr_008', tournamentId: 'trn_005', userId: 'usr_008', username: 'PhantomX', kills: 4, placement: 7, totalPoints: 17.0),
      const MatchResult(id: 'mr_009', tournamentId: 'trn_005', userId: 'usr_009', username: 'ThunderBolt', kills: 3, placement: 10, totalPoints: 13.0),
      const MatchResult(id: 'mr_010', tournamentId: 'trn_005', userId: 'usr_010', username: 'IronFist', kills: 2, placement: 12, totalPoints: 10.0),
    ];
  }
}

/// Screenshot review status
enum ScreenshotStatus { pending, approved, rejected }

/// Screenshot model
class ScreenshotModel {
  final String id;
  final String matchResultId;
  final String imageUrl;
  final ScreenshotStatus status;
  final String? reviewNote;
  final DateTime uploadedAt;

  const ScreenshotModel({
    required this.id,
    required this.matchResultId,
    required this.imageUrl,
    this.status = ScreenshotStatus.pending,
    this.reviewNote,
    required this.uploadedAt,
  });

  factory ScreenshotModel.fromJson(Map<String, dynamic> json) {
    return ScreenshotModel(
      id: json['id'] as String,
      matchResultId: json['matchResultId'] as String,
      imageUrl: json['imageUrl'] as String,
      status: ScreenshotStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ScreenshotStatus.pending,
      ),
      reviewNote: json['reviewNote'] as String?,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'matchResultId': matchResultId,
    'imageUrl': imageUrl,
    'status': status.name,
    'reviewNote': reviewNote,
    'uploadedAt': uploadedAt.toIso8601String(),
  };
}
