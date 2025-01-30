import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_tracker/presentantion/profile/bloc/profile_cubit.dart';
import 'package:tot_tracker/util/date_time_util.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileCubit>().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Centered Baby Name Title
                  Center(
                    child: Text(
                      'Hello, ${state.babyName}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Profile Details List
                  _buildProfileOption(context, "Baby Name", state.babyName, () {
                    _showEditDialog(context, "Baby Name", state.babyName,
                        (newValue) {
                      context.read<ProfileCubit>().updateBabyName(newValue);
                    });
                  }),
                  if (state.dueDate != null)
                    _buildProfileOption(
                        context, "Due Date", formatDateTime(state.dueDate!),
                        () {
                      _selectDueDate(context, state.dueDate!);
                    }),
                  _buildProfileOption(context, "Gender", state.gender, () {
                    _showGenderSelection(context);
                  }),

                  Spacer(),

                  // App Version
                  Center(
                    child: Text(
                      "App Version: ${state.appVersion}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Sign Out Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await context.read<ProfileCubit>().signOut();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Sign Out",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Profile Option Row with Change Button
  Widget _buildProfileOption(
      BuildContext context, String title, String value, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 18,
              )),
          Row(
            children: [
              Text(value,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              GestureDetector(
                onTap: onTap,
                child: Icon(Icons.edit, color: Colors.greenAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Show Edit Dialog for Baby Name
  void _showEditDialog(BuildContext context, String title, String currentValue,
      Function(String) onSave) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  // Show Date Picker for Due Date
  void _selectDueDate(BuildContext context, DateTime currentDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      context.read<ProfileCubit>().updateDueDate(pickedDate);
    }
  }

  // Show Gender Selection Dialog
  void _showGenderSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          title: Text('Boy'),
          onTap: () {
            context.read<ProfileCubit>().updateGender('boy');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Girl'),
          onTap: () {
            context.read<ProfileCubit>().updateGender('girl');
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Any'),
          onTap: () {
            context.read<ProfileCubit>().updateGender('any');
            Navigator.pop(context);
          },
        )
      ]),
    );
  }
}
