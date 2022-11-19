import 'package:dexter_todo/screen/auth/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
        ),
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            Navigator.pushReplacementNamed(context, '/todo-list-screen', arguments: state.username);
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LayoutBuilder(
                  builder: (_, cons) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 32),
                          Image.asset(
                            "assets/nurse.png",
                            height: cons.maxWidth / 2,
                            width: cons.maxWidth / 2,
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            onChanged:
                            context.read<UserCubit>().onUserNameChanged,
                            decoration: InputDecoration(
                              hintText: 'Username',
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
                          const SizedBox(height: 32),
                          SizedBox(
                            width: cons.maxWidth,
                            child: ElevatedButton(
                              onPressed: () => context.read<UserCubit>().submitUsername(),
                              style: ElevatedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Get Started'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
