import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_tracker/presentantion/common/empty_placeholder_widget.dart';
import 'package:tot_tracker/presentantion/summary/bloc/summary_bloc_cubit.dart';

import '../home/model/baby_event_type.dart';
import '../home/model/selection_type.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  @override
  void initState() {
    context.read<SummaryCubit>().load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<SummaryCubit, SummaryState>(
        builder: (context, state) {
          if (state is SummaryLoaded) {
            return Scaffold(
                body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _getFilterDateChips(state),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _getFilterEventChips(state),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    if (state.summary.feedData.isNotEmpty ||
                        state.summary.poopData.isNotEmpty ||
                        state.summary.weeData.isNotEmpty) ...[
                      if (state.filterType == FilterType.day ||
                          state.filterType == FilterType.last24)
                        _buildDayConsolidateChart(state)
                      else
                        _buildDailyChart(state),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.redAccent,
                                  size: 16.0, // Warning icon
                                ),
                                const SizedBox(width: 4.0),
                                const Text(
                                  "Disclaimer",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            const Text(
                              "The upper and lower limits are derived from authentic resources, "
                              "but they may vary depending on individual genetics, parents, "
                              "ethnicity, baby gestation, and other factors. These values are "
                              "only for analyzing trends. If you have concerns, please consult your doctor.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 12.0,
                                height: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else
                      const EmptyPlaceholderWidget(),
                  ]),
            ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildDayConsolidateChart(SummaryLoaded state) {
    final Map<String, Map<String, int>> data = {
      "poop": {
        "current": state.summary.poopData[1] ?? 0,
        "upper": state.summary.poopUpperData[1] ?? 0,
        "lower": state.summary.poopLowerData[1] ?? 0,
      },
      "wee": {
        "current": state.summary.weeData[1] ?? 0,
        "upper": state.summary.weeUpperData[1] ?? 0,
        "lower": state.summary.weeLowerData[1] ?? 0,
      },
      "feed": {
        "current": state.summary.feedData[1] ?? 0,
        "upper": state.summary.feedUpperData[1] ?? 0,
        "lower": state.summary.feedLowerData[1] ?? 0,
      },
    };

    final maxY = [
      state.summary.poopData[1] ?? 0,
      state.summary.poopUpperData[1] ?? 0,
      state.summary.weeData[1] ?? 0,
      state.summary.weeUpperData[1] ?? 0,
      state.summary.feedData[1] ?? 0,
      state.summary.feedUpperData[1] ?? 0,
    ].reduce(max);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLegendItem(Colors.blue, "Current"),
              SizedBox(width: 8),
              _buildLegendItem(Colors.green.shade200, "Upper"),
              SizedBox(width: 8),
              _buildLegendItem(Colors.red.shade200, "Lower"),
            ],
          ),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: _generateBarGroups(data),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2, // Adjust the Y-axis interval
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _getCategoryLabel(value.toInt()),
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: true),
                maxY: maxY
                    .toDouble(), // Adjust based on the max value in your data
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyChart(SummaryLoaded state) {
    return Column(
      children: [
        if ((state.eventType == BabyEventType.all ||
                state.eventType == BabyEventType.nursing) &&
            state.summary.feedData.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildChartSection(
            title: "Feed Times",
            data: state.summary.feedData,
            upper: state.summary.feedUpperData,
            lower: state.summary.feedLowerData,
          ),
        ],
        if ((state.eventType == BabyEventType.all ||
                state.eventType == BabyEventType.poop) &&
            state.summary.poopData.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildChartSection(
            title: "Poop times",
            data: state.summary.poopData,
            upper: state.summary.poopUpperData,
            lower: state.summary.poopLowerData,
          ),
        ],
        if ((state.eventType == BabyEventType.all ||
                state.eventType == BabyEventType.wee) &&
            state.summary.weeData.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildChartSection(
            title: "Wee times",
            data: state.summary.weeData,
            upper: state.summary.weeUpperData,
            lower: state.summary.weeLowerData,
          ),
        ],
      ],
    );
  }

  // Chart Section with Title and Chart
  Widget _buildChartSection(
      {required String title,
      required Map<int, int> data,
      required Map<int, int> upper,
      required Map<int, int> lower}) {
    final keyList = data.keys.toList();
    keyList.sort();

    final minX = keyList.first;
    final maxX = keyList.last;
    final upperLine = _generateUpperLine(
      upper,
    );
    final lowerLine = _generateLowerLine(lower);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: LineChart(
              duration: const Duration(seconds: 1),
              LineChartData(
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(width: 1),
                    bottom: BorderSide(width: 1),
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 2,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      interval: 2,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ),
                minX: minX.toDouble(),
                maxX: maxX.toDouble(),
                // Days in a month (1–31)
                minY: 0,
                maxY: _getMaxY(data, upper),
                // Scale Y dynamically
                lineBarsData: [
                  _createDataLine(data, Colors.blue),
                  _createDataLine(upperLine, Colors.red, isDashed: true),
                  _createDataLine(lowerLine, Colors.green, isDashed: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Create line for data
  LineChartBarData _createDataLine(Map<int, int> data, Color color,
      {bool isDashed = false}) {
    final List<FlSpot> spots = data.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
        .toList();

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      dashArray: isDashed ? [5, 5] : null,
      // Dashed line if specified
      belowBarData: BarAreaData(show: false),
    );
  }

  // Generate the upper line by adding 1 to each value
  Map<int, int> _generateUpperLine(Map<int, int> data) {
    return data.map((key, value) => MapEntry(key, value));
  }

  // Generate the lower line by subtracting 1 from each value (ensure >= 0)
  Map<int, int> _generateLowerLine(Map<int, int> data) {
    return data.map((key, value) => MapEntry(key, value > 0 ? value : 0));
  }

  // Dynamically calculate max Y-axis value
  double _getMaxY(
    Map<int, int> data,
    Map<int, int> upperData,
  ) {
    final average = (data.values.reduce((a, b) => a > b ? a : b)).toDouble();
    final upper = (upperData.values.reduce((a, b) => a > b ? a : b)).toDouble();
    return max(average, upper) + 2;
  }

  Widget _getFilterDateChips(SummaryLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Wrap(
        runSpacing: 20,
        alignment: WrapAlignment.start,
        spacing: 10,
        children: [
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context.read<SummaryCubit>().filter(type: FilterType.all);
                }
              },
              label: const Text('All'),
              selected: state.filterType == FilterType.all),
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context.read<SummaryCubit>().filter(type: FilterType.last24);
                }
              },
              label: const Text('Last 24'),
              selected: state.filterType == FilterType.last24),
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context.read<SummaryCubit>().filter(type: FilterType.day);
                }
              },
              label: const Text('Day'),
              selected: state.filterType == FilterType.day),
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context.read<SummaryCubit>().filter(type: FilterType.week);
                }
              },
              label: const Text('Week'),
              selected: state.filterType == FilterType.week),
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context.read<SummaryCubit>().filter(type: FilterType.month);
                }
              },
              label: const Text('Month'),
              selected: state.filterType == FilterType.month),
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context.read<SummaryCubit>().filter(type: FilterType.year);
                }
              },
              label: const Text('Year'),
              selected: state.filterType == FilterType.year),
        ],
      ),
    );
  }

  Widget _getFilterEventChips(SummaryLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Wrap(
        runSpacing: 20,
        alignment: WrapAlignment.start,
        spacing: 10,
        children: [
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context
                      .read<SummaryCubit>()
                      .filter(eventType: BabyEventType.all);
                }
              },
              label: const Text('All'),
              selected: state.eventType == BabyEventType.all),
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context
                      .read<SummaryCubit>()
                      .filter(eventType: BabyEventType.nursing);
                }
              },
              label: const Text('Feed'),
              selected: state.eventType == BabyEventType.nursing),
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context
                      .read<SummaryCubit>()
                      .filter(eventType: BabyEventType.poop);
                }
              },
              label: const Text('Poop'),
              selected: state.eventType == BabyEventType.poop),
          ChoiceChip(
              onSelected: (isSelected) {
                if (isSelected) {
                  context
                      .read<SummaryCubit>()
                      .filter(eventType: BabyEventType.wee);
                }
              },
              label: const Text('Wee'),
              selected: state.eventType == BabyEventType.wee),
        ],
      ),
    );
  }

  // Generate pie chart sections
  List<BarChartGroupData> _generateBarGroups(
      Map<String, Map<String, int>> data) {
    int index = 0;
    return data.entries.map((entry) {
      final current = entry.value['current']!.toDouble();
      final upper = entry.value['upper']!.toDouble();
      final lower = entry.value['lower']!.toDouble();

      return BarChartGroupData(
        x: index++,
        barRods: [
          BarChartRodData(
            toY: upper,
            color: Colors.green.shade200,
            width: 10,
          ),
          BarChartRodData(
            toY: current,
            color: Colors.blue,
            width: 10,
          ),
          BarChartRodData(
            toY: lower,
            color: Colors.red.shade200,
            width: 10,
          ),
        ],
        barsSpace: 5, // Space between the bars within a group
      );
    }).toList();
  }

  // Build a legend item
  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Get category label for the X-axis
  String _getCategoryLabel(int index) {
    switch (index) {
      case 0:
        return "Poop";
      case 1:
        return "Wee";
      case 2:
        return "Feed";
      default:
        return "";
    }
  }
}
