import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/app/auth_widget.dart';
import 'package:starter_architecture_flutter_firebase/app/home/banana_entries/entry_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/bananas/edit_banana_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/account/edit_account_page.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/entry.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/banana.dart';
import 'package:starter_architecture_flutter_firebase/app/home/models/account.dart';
import 'package:starter_architecture_flutter_firebase/app/sign_in/email_password/email_password_sign_in_page.dart';

class Routes {
  static const authWidget = '/';
  static const emailPasswordSignInPageBuilder =
      '/email-password-sign-in-page-builder';
  static const editBananaPage = '/edit-banana-page';
  static const entryPage = '/entry-page';
  static const editAccountPage = '/edit-account-page';
}

class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.authWidget:
        return MaterialPageRoute<dynamic>(
          builder: (_) => AuthWidget(userSnapshot: args),
          settings: settings,
        );
      case Routes.emailPasswordSignInPageBuilder:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EmailPasswordSignInPageBuilder(onSignedIn: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.editBananaPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditBananaPage(banana: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.editAccountPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => EditAccountPage(account: args),
          settings: settings,
          fullscreenDialog: true,
        );
      case Routes.entryPage:
        final Map<String, dynamic> mapArgs = args;
        final Banana banana = mapArgs['banana'];
        final Entry entry = mapArgs['entry'];
        return MaterialPageRoute<dynamic>(
          builder: (_) => EntryPage(banana: banana, entry: entry),
          settings: settings,
          fullscreenDialog: true,
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
