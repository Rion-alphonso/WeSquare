/// User roles in the application
enum UserRole { user, admin }

/// KYC verification status
enum KycStatus { notSubmitted, pending, approved, rejected }

/// Achievement badge model
class AchievementBadgeData {
  final String id;
  final String name;
  final String icon;
  final String description;
  final bool unlocked;
  final DateTime? unlockedAt;

  const AchievementBadgeData({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    this.unlocked = false,
    this.unlockedAt,
  });

  factory AchievementBadgeData.fromJson(Map<String, dynamic> json) {
    return AchievementBadgeData(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String,
      unlocked: json['unlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'description': description,
        'unlocked': unlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  /// Predefined badges
  static List<AchievementBadgeData> defaultBadges() => [
        AchievementBadgeData(
          id: 'first_blood',
          name: 'First Blood',
          icon: '🩸',
          description: 'Win your first match',
          unlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 25)),
        ),
        AchievementBadgeData(
          id: 'sniper_elite',
          name: 'Sniper Elite',
          icon: '🎯',
          description: '50+ kills with snipers',
          unlocked: true,
          unlockedAt: DateTime.now().subtract(const Duration(days: 12)),
        ),
        const AchievementBadgeData(
          id: 'conqueror',
          name: 'Conqueror',
          icon: '👑',
          description: 'Reach top 500 on leaderboard',
          unlocked: true,
        ),
        const AchievementBadgeData(
          id: 'squad_leader',
          name: 'Squad Leader',
          icon: '🛡️',
          description: 'Lead a squad to 10 victories',
          unlocked: true,
        ),
        const AchievementBadgeData(
          id: 'centurion',
          name: 'Centurion',
          icon: '💯',
          description: 'Play 100 matches',
        ),
        const AchievementBadgeData(
          id: 'untouchable',
          name: 'Untouchable',
          icon: '🔥',
          description: 'Win 5 matches in a row',
        ),
        const AchievementBadgeData(
          id: 'big_spender',
          name: 'Big Spender',
          icon: '💰',
          description: 'Spend ₹5000 in entry fees',
        ),
        const AchievementBadgeData(
          id: 'early_bird',
          name: 'Early Bird',
          icon: '🐦',
          description: 'Be the first to join 10 tournaments',
        ),
      ];
}

/// User model
class UserModel {
  final String id;
  final String username;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final UserRole role;
  final KycStatus kycStatus;
  final double walletBalance;
  final DateTime createdAt;
  final String? referralCode;

  // ─── Gamification Fields ──────────────────────
  final int level;
  final int xp;
  final int xpToNextLevel;
  final int matchesPlayed;
  final int wins;
  final int totalKills;
  final List<AchievementBadgeData> badges;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.role = UserRole.user,
    this.kycStatus = KycStatus.notSubmitted,
    this.walletBalance = 0.0,
    required this.createdAt,
    this.referralCode,
    this.level = 1,
    this.xp = 0,
    this.xpToNextLevel = 500,
    this.matchesPlayed = 0,
    this.wins = 0,
    this.totalKills = 0,
    this.badges = const [],
  });

  /// Derived stats
  double get winRate =>
      matchesPlayed > 0 ? (wins / matchesPlayed) * 100 : 0.0;
  double get kdRatio =>
      matchesPlayed > 0 ? totalKills / matchesPlayed : 0.0;
  double get xpProgress =>
      xpToNextLevel > 0 ? xp / xpToNextLevel : 0.0;
  int get unlockedBadgeCount => badges.where((b) => b.unlocked).length;

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? phone,
    String? avatarUrl,
    UserRole? role,
    KycStatus? kycStatus,
    double? walletBalance,
    DateTime? createdAt,
    String? referralCode,
    int? level,
    int? xp,
    int? xpToNextLevel,
    int? matchesPlayed,
    int? wins,
    int? totalKills,
    List<AchievementBadgeData>? badges,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      kycStatus: kycStatus ?? this.kycStatus,
      walletBalance: walletBalance ?? this.walletBalance,
      createdAt: createdAt ?? this.createdAt,
      referralCode: referralCode ?? this.referralCode,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      matchesPlayed: matchesPlayed ?? this.matchesPlayed,
      wins: wins ?? this.wins,
      totalKills: totalKills ?? this.totalKills,
      badges: badges ?? this.badges,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.user,
      ),
      kycStatus: KycStatus.values.firstWhere(
        (e) => e.name == json['kycStatus'],
        orElse: () => KycStatus.notSubmitted,
      ),
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      referralCode: json['referralCode'] as String?,
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      xpToNextLevel: json['xpToNextLevel'] as int? ?? 500,
      matchesPlayed: json['matchesPlayed'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      totalKills: json['totalKills'] as int? ?? 0,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((b) =>
                  AchievementBadgeData.fromJson(b as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'role': role.name,
      'kycStatus': kycStatus.name,
      'walletBalance': walletBalance,
      'createdAt': createdAt.toIso8601String(),
      'referralCode': referralCode,
      'level': level,
      'xp': xp,
      'xpToNextLevel': xpToNextLevel,
      'matchesPlayed': matchesPlayed,
      'wins': wins,
      'totalKills': totalKills,
      'badges': badges.map((b) => b.toJson()).toList(),
    };
  }

  /// Mock user for development
  static UserModel mock() {
    return UserModel(
      id: 'usr_001',
      username: 'ProGamer99',
      email: 'gamer@wesquare.com',
      phone: '9876543210',
      role: UserRole.user,
      kycStatus: KycStatus.approved,
      walletBalance: 1250.0,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      referralCode: 'WESQUARE2024',
      level: 24,
      xp: 3750,
      xpToNextLevel: 5000,
      matchesPlayed: 42,
      wins: 12,
      totalKills: 187,
      badges: AchievementBadgeData.defaultBadges(),
    );
  }

  static UserModel mockAdmin() {
    return UserModel(
      id: 'adm_001',
      username: 'AdminBoss',
      email: 'admin@wesquare.com',
      role: UserRole.admin,
      kycStatus: KycStatus.approved,
      walletBalance: 0.0,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    );
  }
}
