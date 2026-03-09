import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/tournament_model.dart';
import '../data/tournament_repository.dart';

/// Tournament list state
class TournamentListState {
  final List<TournamentModel> tournaments;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final TournamentStatus? statusFilter;
  final double? maxEntryFeeFilter;

  const TournamentListState({
    this.tournaments = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.statusFilter,
    this.maxEntryFeeFilter,
  });

  TournamentListState copyWith({
    List<TournamentModel>? tournaments,
    bool? isLoading,
    String? error,
    String? searchQuery,
    TournamentStatus? statusFilter,
    double? maxEntryFeeFilter,
  }) {
    return TournamentListState(
      tournaments: tournaments ?? this.tournaments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      maxEntryFeeFilter: maxEntryFeeFilter ?? this.maxEntryFeeFilter,
    );
  }
}

/// Tournament list notifier
class TournamentListNotifier extends StateNotifier<TournamentListState> {
  final TournamentRepository _repository;

  TournamentListNotifier(this._repository) : super(const TournamentListState()) {
    loadTournaments();
  }

  Future<void> loadTournaments() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final tournaments = await _repository.getTournaments(
        status: state.statusFilter,
        maxEntryFee: state.maxEntryFeeFilter,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
      );
      state = state.copyWith(tournaments: tournaments, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
    loadTournaments();
  }

  void setStatusFilter(TournamentStatus? status) {
    state = state.copyWith(statusFilter: status);
    loadTournaments();
  }

  void setMaxEntryFee(double? fee) {
    state = state.copyWith(maxEntryFeeFilter: fee);
    loadTournaments();
  }

  void clearFilters() {
    state = const TournamentListState();
    loadTournaments();
  }
}

/// Providers
final tournamentListProvider =
    StateNotifierProvider<TournamentListNotifier, TournamentListState>((ref) {
  return TournamentListNotifier(ref.watch(tournamentRepositoryProvider));
});

/// Single tournament detail provider
final tournamentDetailProvider =
    FutureProvider.family<TournamentModel, String>((ref, id) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.getTournamentById(id);
});

/// Join tournament provider
final joinTournamentProvider =
    FutureProvider.family<bool, String>((ref, id) async {
  final repo = ref.watch(tournamentRepositoryProvider);
  return repo.joinTournament(id);
});
