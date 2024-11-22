import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/view/login/welcome_view.dart';
import 'package:project/view/main_tabview/main_tabview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Handle the auth state changes
      builder: (context, snapshot) {
        //   loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        //   check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return MainTabView();
        } else {
          return WelcomeView();
        }
      },
    );
  }
}
