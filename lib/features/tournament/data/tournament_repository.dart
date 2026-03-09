import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/tournament_model.dart';
import '../../../core/network/api_client.dart';

/// Tournament repository provider
final tournamentRepositoryProvider = Provider<TournamentRepository>((ref) {
  return TournamentRepository(apiClient: ref.watch(apiClientProvider));
});

/// Repository for tournament CRUD and join operations
class TournamentRepository {
  final ApiClient apiClient;

  TournamentRepository({required this.apiClient});

  /// Fetch all tournaments with optional filters
  Future<List<TournamentModel>> getTournaments({
    TournamentStatus? status,
    double? maxEntryFee,
    double? minPrize,
    String? search,
  }) async {
    // TODO: Replace with real API call
    // final response = await apiClient.get(ApiEndpoints.tournaments, queryParameters: {
    //   if (status != null) 'status': status.name,
    //   if (maxEntryFee != null) 'maxEntryFee': maxEntryFee,
    //   if (minPrize != null) 'minPrize': minPrize,
    //   if (search != null) 'search': search,
    // });

    await Future.delayed(const Duration(milliseconds: 800));
    var tournaments = TournamentModel.mockList();

    // Apply mock filters
    if (status != null) {
      tournaments = tournaments.where((t) => t.status == status).toList();
    }
    if (maxEntryFee != null) {
      tournaments =
          tournaments.where((t) => t.entryFee <= maxEntryFee).toList();
    }
    if (search != null && search.isNotEmpty) {
      tournaments = tournaments
          .where((t) => t.title.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return tournaments;
  }

  /// Get single tournament by ID
  Future<TournamentModel> getTournamentById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return TournamentModel.mockList().firstWhere((t) => t.id == id);
  }

  /// Join a tournament
  Future<bool> joinTournament(String tournamentId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  /// Get room details (only for paid members)
  Future<Map<String, String>> getRoomDetails(String tournamentId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'roomId': '12345678',
      'roomPassword': 'wesquare2024',
    };
  }

  /// Create tournament (Admin)
  Future<TournamentModel> createTournament(TournamentModel tournament) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return tournament;
  }

  /// Update tournament (Admin)
  Future<TournamentModel> updateTournament(TournamentModel tournament) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return tournament;
  }

  /// Set room ID and password (Admin)
  Future<bool> setRoomDetails({
    required String tournamentId,
    required String roomId,
    required String roomPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
