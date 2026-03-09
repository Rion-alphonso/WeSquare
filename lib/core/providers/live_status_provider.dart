import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simulated live event for the platform
class LiveEvent {
  final String tournamentId;
  final String message;
  final LiveEventType type;
  final DateTime timestamp;

  const LiveEvent({
    required this.tournamentId,
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

enum LiveEventType { slotFilled, notification }

/// State holding live slot updates and notifications
class LiveStatusState {
  final Map<String, int> slotBumps; // tournamentId -> extra slots filled
  final List<LiveEvent> notifications;

  const LiveStatusState({
    this.slotBumps = const {},
    this.notifications = const [],
  });

  LiveStatusState copyWith({
    Map<String, int>? slotBumps,
    List<LiveEvent>? notifications,
  }) {
    return LiveStatusState(
      slotBumps: slotBumps ?? this.slotBumps,
      notifications: notifications ?? this.notifications,
    );
  }

  int extraSlots(String tournamentId) => slotBumps[tournamentId] ?? 0;
}

/// Notifier that simulates live platform activity
class LiveStatusNotifier extends StateNotifier<LiveStatusState> {
  LiveStatusNotifier() : super(const LiveStatusState()) {
    _startSimulation();
  }

  Timer? _slotTimer;
  Timer? _notifTimer;
  final _rng = Random();

  final _tournamentIds = ['trn_001', 'trn_002', 'trn_004'];
  final _playerNames = [
    'ClutchGod', 'SniperKing', 'RushB_Pro', 'ViperStrike',
    'BlazeRunner', 'NightCrawler', 'IronSight', 'ShadowFox',
    'ThunderBolt', 'PhantomX',
  ];

  void _startSimulation() {
    // Randomly bump slots every 4-8 seconds
    _slotTimer = Timer.periodic(
      Duration(seconds: _rng.nextInt(5) + 4),
      (_) => _simulateSlotFill(),
    );

    // Push a notification every 8-15 seconds
    _notifTimer = Timer.periodic(
      Duration(seconds: _rng.nextInt(8) + 8),
      (_) => _simulateNotification(),
    );
  }

  void _simulateSlotFill() {
    final tid = _tournamentIds[_rng.nextInt(_tournamentIds.length)];
    final updatedBumps = Map<String, int>.from(state.slotBumps);
    updatedBumps[tid] = (updatedBumps[tid] ?? 0) + 1;

    state = state.copyWith(slotBumps: updatedBumps);
  }

  void _simulateNotification() {
    final player = _playerNames[_rng.nextInt(_playerNames.length)];
    final messages = [
      '$player just joined a tournament!',
      '$player won a match! 🏆',
      'New tournament starting in 5 minutes!',
      '$player claimed ₹500 prize! 💰',
      'Hot match! 3 slots remaining 🔥',
    ];

    final event = LiveEvent(
      tournamentId: _tournamentIds[_rng.nextInt(_tournamentIds.length)],
      message: messages[_rng.nextInt(messages.length)],
      type: LiveEventType.notification,
      timestamp: DateTime.now(),
    );

    final updatedNotifs = [event, ...state.notifications];
    // Keep only the last 20 notifications
    if (updatedNotifs.length > 20) {
      updatedNotifs.removeRange(20, updatedNotifs.length);
    }

    state = state.copyWith(notifications: updatedNotifs);
  }

  /// Get the most recent notification (for display)
  LiveEvent? get latestNotification =>
      state.notifications.isNotEmpty ? state.notifications.first : null;

  @override
  void dispose() {
    _slotTimer?.cancel();
    _notifTimer?.cancel();
    super.dispose();
  }
}

/// Provider for live status
final liveStatusProvider =
    StateNotifierProvider<LiveStatusNotifier, LiveStatusState>((ref) {
  return LiveStatusNotifier();
});
