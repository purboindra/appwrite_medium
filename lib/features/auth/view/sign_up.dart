import 'package:appwrite_medium/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInView extends ConsumerStatefulWidget {
  const SignInView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailC.dispose();
    _passC.dispose();
  }

  void signUp() {
    ref
        .read(authControllerProvider.notifier)
        .signUp(_emailC.text, _passC.text, context);
  }

  void signIn() {
    ref.read(authControllerProvider.notifier).signIn(
          context,
          _emailC.text,
          _passC.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextFormField(
              controller: _emailC,
              decoration: const InputDecoration(
                hintText: 'Email',
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: _passC,
              decoration: const InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            ElevatedButton(
                onPressed: () => signIn(),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(isLoading ? 'Loading...' : 'Sign In'),
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(context),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(isLoading ? 'Loading...' : 'Sign Out'),
                  ),
                )),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
