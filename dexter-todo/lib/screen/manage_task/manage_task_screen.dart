import 'package:dexter_todo/domain/models/modal_item.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:dexter_todo/screen/manage_task/manage_task_bloc.dart';
import 'package:dexter_todo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ManageTaskScreen extends StatefulWidget {
  const ManageTaskScreen({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ManageTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final bloc = BlocProvider.of<ManageTasksBloc>(context);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShiftSelector(),
                  _buildUserSelector(),
                ],
              ),
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
    return BlocBuilder<ManageTasksBloc, ManageTaskState>(
        builder: (context, state) {
      final b = BlocProvider.of<ManageTasksBloc>(context);
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: InkWell(
          onTap: () async {
            final datePicked = await showDateTimePicker(
              context: context,
              initialDate: DateTime.tryParse(state.dateTime) ?? DateTime.now(),
            );
            if (datePicked != null) {
              b.add(OnTaskDateTimeSelected(datePicked.toIso8601String()));
            }
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade300,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
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
          ),
        ),
      );
    });
  }

  Widget _buildShiftSelector() {
    final b = RepositoryProvider.of<ManageTasksBloc>(context);
    return BlocBuilder<ManageTasksBloc, ManageTaskState>(
      builder: (context, state) => Container(
        margin: const EdgeInsets.only(top: 48),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.green,
        ),
        child: InkWell(
          onTap: () {
            showOptionsBottomSheet(
              context: context,
              title: 'Select Shift',
              items: RepositoryProvider.of<TaskRepo>(context)
                  .shifts
                  .map((e) => ModalItem(e.id, e.type))
                  .toList(),
              onItemSelected: (item) => b.add(OnTaskShiftSelected(item.key)),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shield_moon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                state.shift.type,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserSelector() {
    final b = RepositoryProvider.of<ManageTasksBloc>(context);
    return BlocBuilder<ManageTasksBloc, ManageTaskState>(
      builder: (context, state) => Container(
        margin: const EdgeInsets.only(top: 48),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.deepPurple,
        ),
        child: InkWell(
          onTap: () {
            showOptionsBottomSheet(
              context: context,
              title: 'Select User',
              items: RepositoryProvider.of<UserRepo>(context)
                  .users
                  .map((e) => ModalItem(e.id, e.username))
                  .toList(),
              onItemSelected: (item) => b.add(OnTaskUserSelected(item.key)),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_pin, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                state.selectedUser.username,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return BlocBuilder<ManageTasksBloc, ManageTaskState>(
        builder: (context, state) {
      final b = BlocProvider.of<ManageTasksBloc>(context);
      return Padding(
        padding: const EdgeInsets.only(top: 64),
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
