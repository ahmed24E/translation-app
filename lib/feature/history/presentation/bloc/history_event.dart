abstract class HistoryEvent {}


class LoadHistoryEvent extends HistoryEvent {}


class ClearHistoryEvent extends HistoryEvent {}


class SearchHistoryEvent extends HistoryEvent {
  final String query;

  SearchHistoryEvent(this.query);
}