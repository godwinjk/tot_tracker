import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/date_time_util.dart';
import 'baby_bloc/baby_event_cubit.dart';
import 'model/baby_event.dart';
import 'model/baby_event_type.dart';

class AddEventDialog extends StatefulWidget {
  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  bool _isNursing = false;
  bool _isPoop = false;
  bool _isWee = false;
  bool _isWeight = false;

  // Nursing properties
  double _nursingTime = 1; // Slider for feeding time
  double _milkAmount = 50; // Slider for milk amount in ml
  String _feedingType = 'Breastfeed'; // Radio button for feeding type
  final TextEditingController _nursingInfoController = TextEditingController();

  // Poop properties
  double _poopQuantity = 1; // Poop emoji selector
  String _poopColor = 'Yellow'; // Radio button for color
  final TextEditingController _poopInfoController = TextEditingController();
  final TextEditingController _poopColorController = TextEditingController();

  // Wee properties
  double _weeQuantity = 1; // Water emoji selector
  final TextEditingController _weeInfoController = TextEditingController();

  //Weight
  final TextEditingController _addWeightController = TextEditingController();

  double weight = 0;
  final List<String> _colors = ['Red', 'Black', 'Yellow', 'Green', 'Other'];

  DateTime eventTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Baby Event'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkboxes for event types
            Text('Select Event Types'),
            CheckboxListTile(
              title: Text('Nursing'),
              value: _isNursing,
              onChanged: (value) => setState(() => _isNursing = value!),
            ),
            CheckboxListTile(
              title: Text('Poop'),
              value: _isPoop,
              onChanged: (value) => setState(() => _isPoop = value!),
            ),
            CheckboxListTile(
              title: Text('Wee'),
              value: _isWee,
              onChanged: (value) => setState(() => _isWee = value!),
            ),
            CheckboxListTile(
              title: Text('Add Weight'),
              value: _isWeight,
              onChanged: (value) => setState(() => _isWeight = value!),
            ),
            // Nursing section
            if (_isNursing) ...[
              SizedBox(height: 10),
              Text(
                'Nursing',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Nursing Time (minutes)'),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      min: 1,
                      max: 60,
                      divisions: 60,
                      label: '${_nursingTime.round()} min',
                      value: _nursingTime,
                      onChanged: (value) =>
                          setState(() => _nursingTime = value),
                    ),
                  ),
                  Text('${_nursingTime.round()} min')
                ],
              ),
              Text('Milk Amount (ml)'),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      min: 0,
                      max: 300,
                      divisions: 30,
                      label: '${_milkAmount.round()} ml',
                      value: _milkAmount,
                      onChanged: (value) => setState(() => _milkAmount = value),
                    ),
                  ),
                  Text('${_milkAmount.round()} ml')
                ],
              ),
              Text('Feeding Type'),
              Wrap(
                children:
                    ['Breastfeed', 'Expressed Milk', 'Formula'].map((type) {
                  return RadioListTile<String>(
                    title: Text(type),
                    value: type,
                    groupValue: _feedingType,
                    onChanged: (value) => setState(() => _feedingType = value!),
                  );
                }).toList(),
              ),
              TextField(
                controller: _nursingInfoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Additional Information(Optional)'),
              ),
            ],

            // Poop section
            if (_isPoop) ...[
              SizedBox(height: 10),
              Text(
                'Poop',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Poop Quantity'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.circle,
                      size: 30,
                      color: index + 1 <= _poopQuantity
                          ? Colors.brown
                          : Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _poopQuantity = (index + 1).toDouble()),
                  );
                }),
              ),
              Text('Poop Color'),
              Column(
                children: _colors.map((color) {
                  return RadioListTile<String>(
                    title: Text(color),
                    value: color,
                    groupValue: _poopColor,
                    onChanged: (value) {
                      setState(() {
                        _poopColor = value!;
                        if (value != 'Other') _poopColorController.clear();
                      });
                    },
                  );
                }).toList(),
              ),
              if (_poopColor == 'other')
                TextField(
                  controller: _poopColorController,
                  decoration: InputDecoration(labelText: 'Custom Color'),
                ),
              TextField(
                controller: _poopInfoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Additional Information(Optional)'),
              ),
            ],

            // Wee section
            if (_isWee) ...[
              SizedBox(height: 10),
              Text(
                'Poop',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Wee Quantity'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index + 1 <= _weeQuantity
                          ? Icons.water_drop
                          : Icons.water_drop_outlined,
                      size: 30,
                      color:
                          index + 1 <= _weeQuantity ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _weeQuantity = (index + 1).toDouble()),
                  );
                }),
              ),
              TextField(
                controller: _weeInfoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Additional Information(Optional)'),
              ),
            ],
            if (_isWeight) ...[
              SizedBox(height: 10),
              Text(
                'Add Weight',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                ],
                controller: _addWeightController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Add weight (in KG)'),
              ),
            ],
            Wrap(
              children: [
                Text('Event Time: '),
                Text(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  formatDateTime(eventTime),
                ),
                ElevatedButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Text('Change'))
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final events = [];
            if (_isNursing) {
              events.add(BabyEvent(
                  type: BabyEventType.nursing,
                  eventTime: eventTime.millisecondsSinceEpoch,
                  nursingTime: _nursingTime.toInt(),
                  quantity: _milkAmount,
                  info: _nursingInfoController.text,
                  feedType: _feedingType,
                  poopColor: ''));
            }
            if (_isPoop) {
              events.add(BabyEvent(
                  type: BabyEventType.poop,
                  eventTime: eventTime.millisecondsSinceEpoch,
                  nursingTime: 0,
                  quantity: _poopQuantity,
                  info: _weeInfoController.text,
                  poopColor: _poopColorController.text.isNotEmpty
                      ? _poopColorController.text
                      : _poopColor));
            }
            if (_isWee) {
              events.add(BabyEvent(
                  type: BabyEventType.wee,
                  eventTime: eventTime.millisecondsSinceEpoch,
                  nursingTime: 0,
                  quantity: _weeQuantity,
                  info: _weeInfoController.text,
                  poopColor: ''));
            }
            if (_isWeight) {
              events.add(BabyEvent(
                  type: BabyEventType.weight,
                  eventTime: eventTime.millisecondsSinceEpoch,
                  nursingTime: 0,
                  quantity: double.tryParse(_addWeightController.text) ?? 0,
                  info: 'Added weight',
                  poopColor: ''));
            }

            for (var event in events) {
              BlocProvider.of<BabyEventCubit>(context).addEvent(event);
            }

            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // Default date is today
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      // 1 year in the past
      lastDate:
          DateTime.now().add(const Duration(days: 365)), // 1 year in the future
    );
    if (picked == null) {
      return;
    }
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (pickedTime != null) {
      picked =
          picked.copyWith(hour: pickedTime.hour, minute: pickedTime.minute);
      eventTime = picked;
      setState(() {});
    }
  }
}
