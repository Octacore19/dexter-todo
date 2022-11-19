import 'package:dexter_todo/domain/models/modal_item.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:dexter_todo/screen/manage_task/manage_task_bloc.dart';
import 'package:dexter_todo/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ManageTaskScreen extends StatefulWidget {
  const ManageTaskScreen({super.key, this.task});

  final Task? task;

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ManageTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController =
        TextEditingController(text: widget.task?.description);
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
        actions: [
          BlocBuilder<ManageTasksBloc, ManageTaskState>(
              builder: (context, state) {
            final bloc = BlocProvider.of<ManageTasksBloc>(context);
            return Checkbox(
              value: state.isCompleted,
              onChanged: (widget.task != null && widget.task!.isCompleted)
                  ? null
                  : (v) => bloc.add(OnTaskStatusUpdated()),
            );
          })
        ],
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
      ),
      body: BlocListener<ManageTasksBloc, ManageTaskState>(
        listener: (BuildContext context, state) {
          if (state.success) {
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTitleTextForm(),
                _buildDescriptionTextForm(),
                _buildPatientSelector(),
                _buildScheduledTimeView(),
                _buildShiftSelector(),
                _buildUserSelector(),
                _buildAddTaskButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleTextForm() {
    final bloc = BlocProvider.of<ManageTasksBloc>(context);
    return TextFormField(
      controller: _titleController,
      onChanged: (text) => bloc.add(OnTaskTitleChanged(text.trim())),
      enabled: !(widget.task != null && widget.task!.isCompleted),
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
    final bloc = BlocProvider.of<ManageTasksBloc>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextFormField(
        controller: _descriptionController,
        minLines: 3,
        maxLines: null,
        onChanged: (text) => bloc.add(OnTaskTitleChanged(text.trim())),
        enabled: !(widget.task != null && widget.task!.isCompleted),
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
          onTap: (widget.task != null && widget.task?.isCompleted == true)
              ? null
              : () async {
                  final datePicked = await showDateTimePicker(
                    context: context,
                    initialDate:
                        DateTime.tryParse(state.dateTime) ?? DateTime.now(),
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
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade300,
        ),
        child: InkWell(
          onTap: (widget.task != null && widget.task?.isCompleted == true)
              ? null
              : () {
                  showOptionsBottomSheet(
                    context: context,
                    title: 'Select Shift',
                    items: RepositoryProvider.of<TaskRepo>(context)
                        .shifts
                        .map((e) => ModalItem(e.id, e.type))
                        .toList(),
                    onItemSelected: (item) =>
                        b.add(OnTaskShiftSelected(item.key)),
                  );
                },
          child: Row(
            children: [
              const Icon(Icons.shield_moon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.shift.type,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const Icon(Icons.expand_circle_down_outlined),
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
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade300,
        ),
        child: InkWell(
          onTap: (widget.task != null && widget.task?.isCompleted == true)
              ? null
              : () {
                  showOptionsBottomSheet(
                    context: context,
                    title: 'Select User',
                    items: RepositoryProvider.of<UserRepo>(context)
                        .users
                        .map((e) => ModalItem(e.id, e.username))
                        .toList(),
                    onItemSelected: (item) =>
                        b.add(OnTaskUserSelected(item.key)),
                  );
                },
          child: Row(
            children: [
              const Icon(Icons.person_pin),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.selectedUser.username,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              const Icon(Icons.expand_circle_down_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientSelector() {
    final b = RepositoryProvider.of<ManageTasksBloc>(context);
    return BlocBuilder<ManageTasksBloc, ManageTaskState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(top: 32),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade300,
          ),
          child: InkWell(
            onTap: (widget.task != null && widget.task?.isCompleted == true)
                ? null
                : () {
                    showOptionsBottomSheet(
                      context: context,
                      title: 'Select Patient',
                      items: RepositoryProvider.of<TaskRepo>(context)
                          .patients
                          .map((e) => ModalItem(e.id, e.name))
                          .toList(),
                      onItemSelected: (item) => b.add(
                        OnTaskPatientSelected(item.key),
                      ),
                    );
                  },
            child: Row(
              children: [
                const Icon(Icons.personal_injury),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.patient.id.isEmpty
                        ? 'Select patient'
                        : state.patient.name,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                const Icon(Icons.expand_circle_down_outlined),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddTaskButton() {
    if (widget.task != null && widget.task?.isCompleted == true) {
      return const SizedBox.shrink();
    }
    return BlocBuilder<ManageTasksBloc, ManageTaskState>(
        builder: (context, state) {
      final b = BlocProvider.of<ManageTasksBloc>(context);
      return Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(top: 64),
        child: ElevatedButton(
          onPressed: !state.enableSubmission
              ? null
              : () => b.add(OnManageTaskSubmitted(widget.task != null)),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
          ),
          child: Text(widget.task != null ? 'Update Task' : 'Add new Task'),
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
