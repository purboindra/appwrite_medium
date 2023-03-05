import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_medium/providers/appwrite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(account: ref.watch(appwriteAccountProvider));
});

class AuthController extends StateNotifier<bool> {
  final Account _account;
  AuthController({
    required Account account,
  })  : _account = account,
        super(false);

  Future<void> signUp(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      state = true;
      final response = await _account.create(
          userId: ID.unique(), email: email, password: password);
      // CREATE SESSION FOR USER
      final session =
          await _account.createEmailSession(email: email, password: password);
      log('SESSION ${session.userId}');
      log('RESPONSE SIGN UP ${response.toMap()}');
      // AFTER AUTHENTICATION SUCCESSs
      // YOU CAN ROUTE TO HOME VIEW OR MAIN VIEW
      state = false;
      Future.delayed(
        Duration.zero,
        () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Register Success'))),
      );
    } catch (e) {
      state = false;
      log(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // DONT FORGET TO PUT EMAIL AND PASSWORD AS PARAMATERS
  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      state = true;
      final response =
          await _account.createEmailSession(email: email, password: password);
      // STORE SESSION ID TO LOCAL STORAGE
      prefs.setString('sessionID', response.$id);
      state = false;
      Future.delayed(
        Duration.zero,
        () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign In Success!'))),
      );
      log('SIGN IN RESPONSES ${response.toMap()}');
      log('STORE TO LOCAL ${prefs.getString('sessionID')}');
    } catch (e) {
      state = false;
      log('ERROR FROM SIGN IN $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      state = true;
      // SEE THE USER DATA
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionId = prefs.getString('sessionID') ?? '';
      final resp = await _account.deleteSession(sessionId: sessionId);
      state = false;
      // REMOVE FROM LOCAL STORAGE
      await prefs.remove('sessionID');
      log('SUCCESS LOG OUT $resp');
      // ROUTE TO YOUR MAIN SCREEN HERE
      // YOU CAN HANDLE EVERY VARIABLE THAT RELATE WITH AUTO LOGIN, ETC
      // LIKE:
      // isLoggedIn = false;
      // user = null;
      // OR REFRESH USER
      Future.delayed(
        Duration.zero,
        () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sign Out Success!'))),
      );
    } on AppwriteException catch (e) {
      log('ERROR FROM SIGN OUT $e');
      state = false;
    }
  }
}
