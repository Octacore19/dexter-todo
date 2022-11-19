import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_todo/data/repo/task_repo.dart';
import 'package:dexter_todo/data/repo/user_repo.dart';
import 'package:dexter_todo/domain/models/task.dart';
import 'package:dexter_todo/domain/repo/task_repo.dart';
import 'package:dexter_todo/domain/repo/user_repo.dart';
import 'package:dexter_todo/screen/manage_task/manage_task_bloc.dart';
import 'package:dexter_todo/screen/manage_task/manage_task_screen.dart';
import 'package:dexter_todo/utils.dart';
import 'package:dexter_todo/firebase_options.dart';
import 'package:dexter_todo/screen/auth/user_cubit.dart';
import 'package:dexter_todo/screen/auth/user_screen.dart';
import 'package:dexter_todo/screen/list/todo_list_bloc.dart';
import 'package:dexter_todo/screen/list/todo_list_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepo>(
          create: (_) => UserRepoImpl(
            db: FirebaseFirestore.instance,
          ),
        ),
        RepositoryProvider<TaskRepo>(
          create: (context) => TaskRepoImpl(
            db: FirebaseFirestore.instance,
            userRepo: RepositoryProvider.of(context),
          )..getAllShifts(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.grey.shade200,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        themeMode: ThemeMode.light,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          Widget route = Container();
          switch (settings.name) {
            case '/':
              route = BlocProvider(
                create: (context) => UserCubit(
                  repo: RepositoryProvider.of(context),
                ),
                child: const UserScreen(),
              );
              break;
            case '/todo-list-screen':
              route = BlocProvider(
                create: (context) => TodoListBloc(
                  filters: generateDateFilters(),
                  taskRepo: RepositoryProvider.of(context),
                  userRepo: RepositoryProvider.of(context),
                ),
                child: TodoListScreen(
                  username: settings.arguments as String?,
                ),
              );
              break;
            case '/manage-todo-screen':
              route = BlocProvider(
                create: (context) => ManageTasksBloc(
                  taskRepo: RepositoryProvider.of(context),
                  userRepo: RepositoryProvider.of(context),
                  task: settings.arguments as Task?,
                ),
                child: ManageTaskScreen(task: settings.arguments as Task?),
              );
              break;
          }
          return MaterialPageRoute(builder: (context) => route);
        },
      ),
    );
  }
}
