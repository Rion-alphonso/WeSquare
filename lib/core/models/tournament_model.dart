/// Tournament status
enum TournamentStatus { upcoming, live, completed, cancelled }

/// Tournament model
class TournamentModel {
  final String id;
  final String title;
  final String description;
  final String game;
  final String map;
  final String mode;
  final double entryFee;
  final double prizePool;
  final DateTime startTime;
  final int maxSlots;
  final int joinedCount;
  final TournamentStatus status;
  final String? roomId;
  final String? roomPassword;
  final double killMultiplier;
  final Map<int, double> placementPoints;
  final List<String> prizeDistribution;
  final String? bannerUrl;
  final DateTime createdAt;

  const TournamentModel({
    required this.id,
    required this.title,
    this.description = '',
    this.game = 'WeSquare',
    this.map = 'Erangel',
    this.mode = 'Squad',
    required this.entryFee,
    required this.prizePool,
    required this.startTime,
    required this.maxSlots,
    this.joinedCount = 0,
    this.status = TournamentStatus.upcoming,
    this.roomId,
    this.roomPassword,
    this.killMultiplier = 1.0,
    this.placementPoints = const {},
    this.prizeDistribution = const [],
    this.bannerUrl,
    required this.createdAt,
  });

  bool get isFull => joinedCount >= maxSlots;
  int get availableSlots => maxSlots - joinedCount;
  bool get isUpcoming => status == TournamentStatus.upcoming;
  bool get isLive => status == TournamentStatus.live;
  bool get hasRoomDetails => roomId != null && roomPassword != null;

  TournamentModel copyWith({
    String? id,
    String? title,
    String? description,
    String? game,
    String? map,
    String? mode,
    double? entryFee,
    double? prizePool,
    DateTime? startTime,
    int? maxSlots,
    int? joinedCount,
    TournamentStatus? status,
    String? roomId,
    String? roomPassword,
    double? killMultiplier,
    Map<int, double>? placementPoints,
    List<String>? prizeDistribution,
    String? bannerUrl,
    DateTime? createdAt,
  }) {
    return TournamentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      game: game ?? this.game,
      map: map ?? this.map,
      mode: mode ?? this.mode,
      entryFee: entryFee ?? this.entryFee,
      prizePool: prizePool ?? this.prizePool,
      startTime: startTime ?? this.startTime,
      maxSlots: maxSlots ?? this.maxSlots,
      joinedCount: joinedCount ?? this.joinedCount,
      status: status ?? this.status,
      roomId: roomId ?? this.roomId,
      roomPassword: roomPassword ?? this.roomPassword,
      killMultiplier: killMultiplier ?? this.killMultiplier,
      placementPoints: placementPoints ?? this.placementPoints,
      prizeDistribution: prizeDistribution ?? this.prizeDistribution,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      game: json['game'] as String? ?? 'WeSquare',
      map: json['map'] as String? ?? 'Erangel',
      mode: json['mode'] as String? ?? 'Squad',
      entryFee: (json['entryFee'] as num).toDouble(),
      prizePool: (json['prizePool'] as num).toDouble(),
      startTime: DateTime.parse(json['startTime'] as String),
      maxSlots: json['maxSlots'] as int,
      joinedCount: json['joinedCount'] as int? ?? 0,
      status: TournamentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TournamentStatus.upcoming,
      ),
      roomId: json['roomId'] as String?,
      roomPassword: json['roomPassword'] as String?,
      killMultiplier: (json['killMultiplier'] as num?)?.toDouble() ?? 1.0,
      placementPoints: (json['placementPoints'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(int.parse(k), (v as num).toDouble()),
          ) ??
          const {},
      prizeDistribution: (json['prizeDistribution'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      bannerUrl: json['bannerUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'game': game,
      'map': map,
      'mode': mode,
      'entryFee': entryFee,
      'prizePool': prizePool,
      'startTime': startTime.toIso8601String(),
      'maxSlots': maxSlots,
      'joinedCount': joinedCount,
      'status': status.name,
      'roomId': roomId,
      'roomPassword': roomPassword,
      'killMultiplier': killMultiplier,
      'prizeDistribution': prizeDistribution,
      'bannerUrl': bannerUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Generate mock tournaments for development
  static List<TournamentModel> mockList() {
    final now = DateTime.now();
    return [
      TournamentModel(
        id: 'trn_001',
        title: 'WeSquare Pro League #1',
        description: 'First qualifier round of the WeSquare Pro League Season 4',

        entryFee: 50,
        prizePool: 5000,
        startTime: now.add(const Duration(hours: 2)),
        maxSlots: 100,
        joinedCount: 76,
        status: TournamentStatus.upcoming,
        prizeDistribution: ['1st: ₹2000', '2nd: ₹1500', '3rd: ₹1000', '4th-5th: ₹250'],
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      TournamentModel(
        id: 'trn_002',
        title: 'Squad Showdown',
        description: 'Weekly squad battle royale with massive prize pool',
        game: 'WeSquare', // Explicitly set game
        // email: 'admin@wesquare.com', // Removed as it's not a field in TournamentModel
        entryFee: 100,
        prizePool: 10000,
        startTime: now.add(const Duration(hours: 5)),
        maxSlots: 200,
        joinedCount: 145,
        status: TournamentStatus.upcoming,
        killMultiplier: 1.5,
        prizeDistribution: ['1st: ₹4000', '2nd: ₹3000', '3rd: ₹2000', '4th-10th: ₹142'],
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      TournamentModel(
        id: 'trn_003',
        title: 'Solo Warrior',
        description: 'Solo mode tournament for the bravest warriors',
        mode: 'Solo',
        entryFee: 30,
        prizePool: 3000,
        startTime: now.subtract(const Duration(hours: 1)),
        maxSlots: 100,
        joinedCount: 100,
        status: TournamentStatus.live,
        roomId: '12345678',
        roomPassword: 'wesquare2024',

        prizeDistribution: ['1st: ₹1500', '2nd: ₹800', '3rd: ₹400', '4th-5th: ₹150'],
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      TournamentModel(
        id: 'trn_004',
        title: 'Duo Domination',
        description: 'Duo mode with kill-based scoring system',
        mode: 'Duo',
        map: 'Sanhok',
        entryFee: 75,
        prizePool: 7500,
        startTime: now.add(const Duration(days: 1)),
        maxSlots: 150,
        joinedCount: 42,
        status: TournamentStatus.upcoming,
        killMultiplier: 2.0,
        prizeDistribution: ['1st: ₹3000', '2nd: ₹2000', '3rd: ₹1500', '4th-5th: ₹500'],
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      TournamentModel(
        id: 'trn_005',
        title: 'Weekend Classic',
        description: 'Classic squad mode tournament every weekend',
        entryFee: 25,
        prizePool: 2500,
        startTime: now.subtract(const Duration(days: 2)),
        maxSlots: 100,
        joinedCount: 100,
        status: TournamentStatus.completed,
        prizeDistribution: ['1st: ₹1000', '2nd: ₹750', '3rd: ₹500', '4th-5th: ₹125'],
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
