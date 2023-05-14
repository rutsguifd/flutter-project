import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskAlertDialog extends StatefulWidget {
  const AddTaskAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTaskAlertDialog> createState() => _AddTaskAlertDialogState();
}

class _AddTaskAlertDialogState extends State<AddTaskAlertDialog> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final List<String> taskTags = ['Lab', 'Module', 'Exam'];
  final List<String> doneTags = ['Done', 'Partially', 'Not Done'];
  late String selectedValue = '';
  late String selectedDone = '';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'New Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.pink),
      ),
      content: SizedBox(
        height: height * 0.35,
        width: width,
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: taskNameController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Student',
                  hintStyle: const TextStyle(fontSize: 14),
                  icon: const Icon(CupertinoIcons.square_list,
                      color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: taskDescController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Group',
                  hintStyle: const TextStyle(fontSize: 14),
                  icon: const Icon(CupertinoIcons.bubble_left_bubble_right,
                      color: Colors.pink),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  const Icon(CupertinoIcons.tag, color: Colors.pink),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: DropdownButtonFormField2(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Add a task tag',
                        style: TextStyle(fontSize: 14),
                      ),
                      // buttonHeight: 60,
                      // buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      // dropdownDecoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                      validator: (value) => value == null
                          ? 'Please select the task tag'
                          : "Other",
                      items: taskTags
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) => setState(
                        () {
                          if (value != null) selectedValue = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: <Widget>[
                    const Icon(CupertinoIcons.tag, color: Colors.pink),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        hint: const Text(
                          'Add a task tag',
                          style: TextStyle(fontSize: 14),
                        ),
                        // buttonHeight: 60,
                        // buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                        // dropdownDecoration: BoxDecoration(
                        //   borderRadius: BorderRadius.circular(15),
                        // ),
                        validator: (value) => value == null
                            ? 'Please select the task tag'
                            : "Other",
                        items: doneTags
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) => setState(
                          () {
                            if (value != null) selectedDone = value;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final taskName = taskNameController.text;
            final taskDesc = taskDescController.text;
            final taskTag = selectedValue;
            final done = selectedDone;
            _addTasks(
                taskName: taskName,
                taskDesc: taskDesc,
                taskTag: taskTag,
                done: done);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future _addTasks(
      {required String taskName,
      required String taskDesc,
      required String taskTag,
      required String done}) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskName': taskName,
        'taskDesc': taskDesc,
        'taskTag': taskTag,
        'done': done
      },
    );
    String taskId = docRef.id;
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update(
      {'id': taskId},
    );
    _clearAll();
  }

  void _clearAll() {
    taskNameController.text = '';
    taskDescController.text = '';
  }
}
