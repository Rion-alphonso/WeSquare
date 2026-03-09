import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/match_models.dart';
import '../../../core/network/api_client.dart';

/// Leaderboard repository provider
final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(apiClient: ref.watch(apiClientProvider));
});

class LeaderboardRepository {
  final ApiClient apiClient;
  LeaderboardRepository({required this.apiClient});

  Future<List<MatchResult>> getLeaderboard(String tournamentId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return MatchResult.mockLeaderboard();
  }
}

/// Leaderboard provider with polling support
final leaderboardProvider =
    FutureProvider.family<List<MatchResult>, String>((ref, tournamentId) async {
  final repo = ref.watch(leaderboardRepositoryProvider);
  return repo.getLeaderboard(tournamentId);
});
