import 'package:dexter_todo/domain/models/date_filter.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:dexter_todo/filter_generator.dart';
import 'package:dexter_todo/screen/list/todo_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoListBloc(filters: generateDateFilters()),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeadline(context),
                const SizedBox(height: 16),
                _buildDateSelectionCard(context),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<TodoListBloc, TodoListStates>(
                    builder: (_, state) {
                      if (state is UpdatedTodoListState) {
                        if (state.firstShift.isEmpty &&
                            state.secondShift.isEmpty &&
                            state.thirdShift.isEmpty) {
                          return _buildEmpty();
                        }
                        return CustomScrollView(
                          slivers: [
                            ..._buildShifts(
                                'First Shift', context, state.firstShift),
                            ..._buildShifts(
                                'Second Shift', context, state.secondShift),
                            ..._buildShifts(
                                'Third Shift', context, state.thirdShift),
                          ],
                        );
                      }
                      return _buildEmpty();
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade900,
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildHeadline(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hello,',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(
          'Username.',
          style: Theme.of(context)
              .textTheme
              .headline4
              ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildDateSelectionCard(BuildContext context) {
    return BlocBuilder<TodoListBloc, TodoListStates>(
      builder: (_, state) => Card(
        elevation: 0,
        color: Colors.grey.shade100,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (ctx, cons) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: state.filters
                    .map((e) => _generateFilterItems(e, cons.maxWidth / 5, ctx))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _generateFilterItems(
    DateFilter e,
    double width,
    BuildContext context,
  ) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () => context.read<TodoListBloc>().add(OnFilterDateChanged(e)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(e.isSelected ? 16 : 12),
              decoration: BoxDecoration(
                color: e.isSelected
                    ? Colors.deepPurple.shade900
                    : Colors.grey.shade400,
                borderRadius: e.isSelected ? BorderRadius.circular(12) : null,
                shape: e.isSelected ? BoxShape.rectangle : BoxShape.circle,
              ),
              child: Text(
                e.date.toString(),
                style: Theme.of(context).textTheme.subtitle2?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              e.currentDay,
              style: Theme.of(context).textTheme.subtitle2?.copyWith(
                  color: e.isSelected ? Colors.black : Colors.grey.shade400),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildShifts(
    String title,
    BuildContext context,
    List<Task> tasks,
  ) {
    if (tasks.isEmpty) {
      return [const SliverToBoxAdapter()];
    }
    return [
      SliverToBoxAdapter(
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => Padding(
              padding: EdgeInsets.only(bottom: index == 4 ? 0 : 16),
              child: _buildCheckTile(context, tasks[index].title),
            ),
            childCount: tasks.length,
          ),
        ),
      ),
    ];
  }

  Widget _buildCheckTile(BuildContext context, String title) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (v) {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return LayoutBuilder(
      builder: (_, cons) => Center(
        child: Image.asset(
          'assets/empty_tasks.png',
          height: cons.maxWidth / 3,
          width: cons.maxWidth / 3,
        ),
      ),
    );
  }
}
