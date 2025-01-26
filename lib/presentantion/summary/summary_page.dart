import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_tracker/presentantion/common/empty_placeholder_widget.dart';
import 'package:tot_tracker/presentantion/summary/bloc/summary_bloc_cubit.dart';

import '../model/baby_event_type.dart';
import '../model/selection_type.dart';

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
                  if (state.eventType == BabyEventType.all ||
                      state.eventType == BabyEventType.nursing)
                    const SizedBox(height: 20),
                  if (state.eventType == BabyEventType.all ||
                      state.eventType == BabyEventType.nursing)
                    _buildChartSection(
                      title: "Feed Times",
                      data: state.summary.feedData,
                      upper: state.summary.feedUpperData,
                      lower: state.summary.feedLowerData,
                    ),
                  if (state.eventType == BabyEventType.all ||
                      state.eventType == BabyEventType.poop)
                    const SizedBox(height: 20),
                  if (state.eventType == BabyEventType.all ||
                      state.eventType == BabyEventType.poop)
                    _buildChartSection(
                      title: "Poop times",
                      data: state.summary.poopData,
                      upper: state.summary.poopUpperData,
                      lower: state.summary.poopLowerData,
                    ),
                  if (state.eventType == BabyEventType.all ||
                      state.eventType == BabyEventType.wee)
                    const SizedBox(height: 20),
                  if (state.eventType == BabyEventType.all ||
                      state.eventType == BabyEventType.wee)
                    _buildChartSection(
                      title: "Wee times",
                      data: state.summary.weeData,
                      upper: state.summary.weeUpperData,
                      lower: state.summary.weeLowerData,
                    ),
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
                ],
              ),
            ));
          } else if (state is SummaryLoadedNoItem) {
            return const EmptyPlaceholderWidget();
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  // Chart Section with Title and Chart
  Widget _buildChartSection(
      {required String title,
      required Map<int, int> data,
      required Map<int, int> upper,
      required Map<int, int> lower}) {
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
                minX: 1,
                maxX: 31,
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
    return Wrap(
      runSpacing: 20,
      alignment: WrapAlignment.center,
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
    );
  }

  Widget _getFilterEventChips(SummaryLoaded state) {
    return Wrap(
      runSpacing: 20,
      alignment: WrapAlignment.center,
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
    );
  }
}
