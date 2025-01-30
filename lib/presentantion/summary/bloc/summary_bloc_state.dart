part of 'summary_bloc_cubit.dart';

sealed class SummaryState extends Equatable {
  const SummaryState();
}

final class SummaryInitial extends SummaryState {
  @override
  List<Object> get props => [];
}

final class SummaryProgress extends SummaryState {
  @override
  List<Object?> get props => [];
}

final class SummaryLoaded extends SummaryState {
  final SummaryChartData summary;
  final FilterType filterType;
  final BabyEventType eventType;

  const SummaryLoaded(this.summary, this.filterType, this.eventType);

  @override
  List<Object?> get props => [summary];
}

