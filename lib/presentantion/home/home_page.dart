import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_tracker/presentantion/baby_bloc/baby_event_cubit.dart';
import 'package:tot_tracker/presentantion/model/baby_event_type.dart';

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
  Widget build(BuildContext context) {
    return BlocBuilder<BabyEventCubit, BabyEventState>(
      builder: (context, state) {
        if (state is BabyEventLoaded) {
          return Scaffold(
            body: ListView.builder(
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
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddEventDialog(context),
              child: const Icon(Icons.add),
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
    return SizedBox();
  }

  Color _getCardColor(BabyEventType type) {
    switch (type) {
      case BabyEventType.nursing:
        return Colors.lightBlue.shade100;
      case BabyEventType.wee:
        return Colors.lightGreen.shade100;
      case BabyEventType.poop:
        return Colors.orange.shade100;
    }
  }

  void _showAddEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(),
    );
  }
}
