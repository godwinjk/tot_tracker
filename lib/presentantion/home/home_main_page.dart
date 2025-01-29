import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tot_tracker/di/injection_base.dart';
import 'package:tot_tracker/presentantion/home/baby_bloc/baby_event_cubit.dart';
import 'package:tot_tracker/presentantion/home/model/selection_type.dart';
import 'package:tot_tracker/res/asset_const.dart';
import 'package:tot_tracker/router/route_path.dart';
import 'package:tot_tracker/theme/color_palette.dart';

import '../../persistence/shared_pref_const.dart';
import '../summary/model/average_data.dart';
import 'add_event_dialog.dart';
import 'baby_stat_card.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  @override
  void initState() {
    context.read<BabyEventCubit>().loadForDashboard(FilterType.last24);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 300,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: getIt<ColorPalette>().secondary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      // Top-left corner radius
                      topRight: Radius.circular(40), // Top-right corner radius
                    ),
                  ),
                  height: 200,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        // Top-left corner radius
                        topRight:
                            Radius.circular(30), // Top-right corner radius
                      ),
                    ),
                    height: 50,
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                            future: SharedPreferences.getInstance(),
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                String name = snapshot.data?.getString(
                                        SharedPrefConstants.babyName) ??
                                    '';
                                return Text(
                                  textAlign: TextAlign.center,
                                  'Hello $name',
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                );
                              } else {
                                return const Text('Hello');
                              }
                            }),
                        Lottie.asset(AssetConstant.lBabySleeping, height: 200),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  getIt<GoRouter>().go(RoutePath.homeDetails);
                },
                child: Text('See Detailed Report')),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: BlocBuilder<BabyEventCubit, BabyEventState>(
                builder: (context, state) {
                  if (state is BabyEventLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Last 24 details'),
                        GridView(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 2 columns
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1, // Card size
                            ),
                            shrinkWrap: true,
                            children: [
                              BabyStatCard(
                                title: 'Fed',
                                value: state.model!.feed.length,
                                icon: Icons.local_dining,
                                color: Colors.pink.shade100,
                                subValue: state.model!.consumedMilk,
                              ),
                              BabyStatCard(
                                title: 'Pooped',
                                value: state.model!.poop.length,
                                icon: Icons.baby_changing_station,
                                color: Colors.brown.shade100,
                              ),
                              BabyStatCard(
                                title: 'Wee',
                                value: state.model!.wee.length,
                                icon: Icons.water_drop,
                                color: Colors.blue.shade100,
                              ),
                              BabyStatCard(
                                title: 'Weight',
                                value: state.model!.babyWeight,
                                icon: Icons.monitor_weight,
                                color: Colors.orangeAccent.shade100,
                              )
                            ]),
                        SizedBox(
                          height: 20,
                        ),
                        _buildChartSection(
                            title: 'Weight chart',
                            data: state.weightData,
                            upper: AverageDataConst.babyWeightUpperLimit,
                            lower: AverageDataConst.babyWeightLowerLimit),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildChartSection(
      {required String title,
      required Map<int, double> data,
      required Map<int, double> upper,
      required Map<int, double> lower}) {
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 300,
              width: 1000,
              child: LineChart(
                duration: const Duration(seconds: 1),
                LineChartData(
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(
                        width: 1,
                      ),
                      bottom: BorderSide(width: 1),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                        axisNameWidget: Text('Weight'), axisNameSize: 40),
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
                      axisNameWidget: Text('Weeks'),
                      axisNameSize: 40,
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
                  minX: upper.keys.first.toDouble(),
                  maxX: upper.keys.last.toDouble(),
                  // Days in a month (1–31)
                  minY: 0,
                  maxY: _getMaxY(AverageDataConst.babyWeightUpperLimit),
                  // Scale Y dynamically
                  lineBarsData: [
                    _createDataLine(data, Colors.blue),
                    _createDataLine(upperLine, Colors.green.shade200,
                        isDashed: true),
                    _createDataLine(lowerLine, Colors.red.shade200,
                        isDashed: true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Create line for data
  LineChartBarData _createDataLine(Map<int, double> data, Color color,
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
  Map<int, double> _generateUpperLine(Map<int, double> data) {
    return data.map((key, value) => MapEntry(key, value));
  }

  // Generate the lower line by subtracting 1 from each value (ensure >= 0)
  Map<int, double> _generateLowerLine(Map<int, double> data) {
    return data.map((key, value) => MapEntry(key, value > 0 ? value : 0));
  }

  // Dynamically calculate max Y-axis value
  double _getMaxY(
    Map<int, double> upperData,
  ) {
    final upper = (upperData.values.reduce((a, b) => a > b ? a : b)).toDouble();
    return upper;
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(),
    );
  }

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
}
