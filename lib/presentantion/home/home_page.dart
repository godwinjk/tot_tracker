import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_tracker/presentantion/baby_bloc/baby_event_cubit.dart';
import 'package:tot_tracker/presentantion/common/empty_placeholder_widget.dart';
import 'package:tot_tracker/presentantion/model/baby_event_type.dart';
import 'package:tot_tracker/presentantion/model/selection_type.dart';

import '../../util/date_time_util.dart';
import '../model/baby_event.dart';
import 'add_event_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<BabyEventCubit>().load();
    super.initState();
  }

  @override
  Widget build(BuildContext _) {
    return BlocBuilder<BabyEventCubit, BabyEventState>(
      builder: (_, state) {
        if (state is BabyEventLoaded) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                mainAxisSize: MainAxisSize.min,
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
                  SizedBox(
                    height: 20,
                  ),
                  state.events.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.events.length,
                            itemBuilder: (context, index) {
                              final event = state.events[index];

                              // Render different cards based on the event type
                              switch (event.type) {
                                case BabyEventType.nursing:
                                  return _buildNursingCard(event);
                                case BabyEventType.poop:
                                  return _buildPoopCard(event);
                                case BabyEventType.wee:
                                  return _buildWeeCard(event);
                                case BabyEventType.all:
                                  return const SizedBox.shrink();
                              }
                            },
                          ),
                        )
                      : Expanded(child: const EmptyPlaceholderWidget()),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showAddEventDialog(context),
                child: const Icon(Icons.add),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

// Nursing Card
  Widget _buildNursingCard(BabyEvent event) {
    return Card(
      color: _getCardColor(event.type),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: _getEventTitle(event),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nursing Time: ${event.nursingTime} min'),
            Text('Milk Amount: ${event.quantity} ml'),
            Text('Feed Type: ${event.feedType}'),
            if (event.info.isNotEmpty) Text('Notes: ${event.info}'),
            //reflux
            //chock
            //info
          ],
        ),
      ),
    );
  }

  // Poop Card
  Widget _buildPoopCard(BabyEvent event) {
    return Card(
      color: _getCardColor(event.type),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: _getEventTitle(event),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Poop Quantity: '),
                for (int i = 1; i <= 5; i++)
                  Icon(Icons.circle,
                      color: i <= event.quantity ? Colors.brown : Colors.grey,
                      size: 16),
              ],
            ),
            Text('Poop Color: ${event.info}'),
            if (event.info.isNotEmpty) Text('Notes: ${event.info}'),
            //reflux
            //chock
            //info
          ],
        ),
      ),
    );
  }

  // Wee Card
  Widget _buildWeeCard(BabyEvent event) {
    return Card(
      color: _getCardColor(event.type),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        title: _getEventTitle(event),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Wee Quantity: '),
                for (int i = 1; i <= 5; i++)
                  Icon(
                      i <= event.quantity
                          ? Icons.water_drop
                          : Icons.water_drop_outlined,
                      color:
                          i <= event.quantity ? Colors.blueAccent : Colors.grey,
                      size: 16),
              ],
            ),

            if (event.info.isNotEmpty) Text('Notes: ${event.info}'),
            //reflux
            //chock
            //info
          ],
        ),
      ),
    );
  }

  Widget _getEventTitle(BabyEvent event) {
    final time = formatEpochToHourMin(event.eventTime);
    if (event.type == BabyEventType.nursing) {
      return RichText(
        maxLines: 3,
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            const TextSpan(text: 'Baby fed for '),
            TextSpan(
              text: '${event.nursingTime} min',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const TextSpan(text: ' on '),
            TextSpan(
              text: time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      );
    } else if (event.type == BabyEventType.poop) {
      return RichText(
        maxLines: 3,
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            const TextSpan(text: 'Baby pooped at '),
            TextSpan(
              text: time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      );
    } else if (event.type == BabyEventType.wee) {
      return RichText(
        maxLines: 3,
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            const TextSpan(text: 'Baby weed at '),
            TextSpan(
              text: time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      );
    }
    return SizedBox.shrink();
  }

  Widget _getFilterDateChips(BabyEventLoaded state) {
    return Wrap(
      runSpacing: 20,
      alignment: WrapAlignment.start,
      spacing: 10,
      children: [
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context.read<BabyEventCubit>().filter(type: FilterType.all);
              }
            },
            label: const Text('All'),
            selected: state.filterType == FilterType.all),
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context.read<BabyEventCubit>().filter(type: FilterType.last24);
              }
            },
            label: const Text('Last 24'),
            selected: state.filterType == FilterType.last24),
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context.read<BabyEventCubit>().filter(type: FilterType.day);
              }
            },
            label: const Text('Day'),
            selected: state.filterType == FilterType.day),
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context.read<BabyEventCubit>().filter(type: FilterType.week);
              }
            },
            label: const Text('Week'),
            selected: state.filterType == FilterType.week),
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context.read<BabyEventCubit>().filter(type: FilterType.month);
              }
            },
            label: const Text('Month'),
            selected: state.filterType == FilterType.month),
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context.read<BabyEventCubit>().filter(type: FilterType.year);
              }
            },
            label: const Text('Year'),
            selected: state.filterType == FilterType.year),
      ],
    );
  }

  Widget _getFilterEventChips(BabyEventLoaded state) {
    return Wrap(
      runSpacing: 20,
      alignment: WrapAlignment.start,
      spacing: 10,
      children: [
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context
                    .read<BabyEventCubit>()
                    .filter(eventType: BabyEventType.all);
              }
            },
            label: const Text('All'),
            selected: state.eventType == BabyEventType.all),
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context
                    .read<BabyEventCubit>()
                    .filter(eventType: BabyEventType.nursing);
              }
            },
            label: const Text('Feed'),
            selected: state.eventType == BabyEventType.nursing),
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context
                    .read<BabyEventCubit>()
                    .filter(eventType: BabyEventType.poop);
              }
            },
            label: const Text('Poop'),
            selected: state.eventType == BabyEventType.poop),
        ChoiceChip(
            onSelected: (isSelected) {
              if (isSelected) {
                context
                    .read<BabyEventCubit>()
                    .filter(eventType: BabyEventType.wee);
              }
            },
            label: const Text('Wee'),
            selected: state.eventType == BabyEventType.wee),
      ],
    );
  }

  Color _getCardColor(BabyEventType type) {
    switch (type) {
      case BabyEventType.nursing:
        return Colors.lightBlue.shade100;
      case BabyEventType.wee:
        return Colors.lightGreen.shade100;
      case BabyEventType.poop:
        return Colors.orange.shade100;
      case BabyEventType.all:
        return Colors.white;
    }
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(),
    );
  }
}
