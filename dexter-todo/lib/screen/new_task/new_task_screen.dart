import 'package:dexter_todo/screen/new_task/new_task_bloc.dart';
import 'package:dexter_todo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<NewTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<NewTasksBloc>(context);
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _titleController.addListener(() {
      final text = _titleController.text.trim();
      bloc.add(OnTaskTitleChanged(text));
    });
    _descriptionController.addListener(() {
      final text = _descriptionController.text.trim();
      bloc.add(OnTaskDescriptionChanged(text));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
        ),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildTitleTextForm(),
              _buildDescriptionTextForm(),
              _buildScheduledTimeView(),
              _buildAddTaskButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleTextForm() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        hintText: 'Task Title',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDescriptionTextForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextFormField(
        controller: _descriptionController,
        minLines: 3,
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Task Description (Optional)',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduledTimeView() {
    return BlocBuilder<NewTasksBloc, NewTaskState>(builder: (context, state) {
      final b = BlocProvider.of<NewTasksBloc>(context);
      return GestureDetector(
        onTap: () async {
          final datePicked = await showDateTimePicker(
            context: context,
            initialDate: DateTime.tryParse(state.dateTime) ?? DateTime.now(),
          );
          if (datePicked != null) {
            b.add(OnTaskDateTimeSelected(datePicked.toIso8601String()));
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade300,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.alarm),
              const SizedBox(width: 8),
              Text(
                state.dateTime.isEmpty
                    ? 'Select scheduled Time'
                    : DateFormat().format(DateTime.parse(state.dateTime)),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAddTaskButton() {
    return BlocBuilder<NewTasksBloc, NewTaskState>(builder: (context, state) {
      final b = BlocProvider.of<NewTasksBloc>(context);
      return Padding(
        padding: const EdgeInsets.only(top: 32),
        child: ElevatedButton(
          onPressed: !state.enableSubmission
              ? null
              : () => b.add(OnNewTaskSubmitted()),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
          ),
          child: const Text('Add new Task'),
        ),
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
