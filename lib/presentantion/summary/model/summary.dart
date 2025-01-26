class SummaryChartData {
  final Map<int, int> poopData;
  final Map<int, int> poopUpperData;
  final Map<int, int> poopLowerData;
  final Map<int, int> weeData;
  final Map<int, int> weeUpperData;
  final Map<int, int> weeLowerData;
  final Map<int, int> feedUpperData;
  final Map<int, int> feedLowerData;
  final Map<int, int> feedData;

  SummaryChartData(
      {required this.poopUpperData,
      required this.poopLowerData,
      required this.weeUpperData,
      required this.weeLowerData,
      required this.feedUpperData,
      required this.feedLowerData,
      required this.poopData,
      required this.weeData,
      required this.feedData});
}
