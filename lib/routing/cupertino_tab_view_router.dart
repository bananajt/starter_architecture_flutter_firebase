// import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:starter_architecture_flutter_firebase/app/home/banana_entries/banana_entries_page.dart';

// Reverting back to manually generated routes until this is clarified: https://github.com/Milad-Akarie/auto_route_library/issues/62
// @CupertinoAutoRouter()
// class $CupertinoTabViewRouter {
//   @CupertinoRoute(fullscreenDialog: false)
//   BananaEntriesPage bananaEntriesPage;
// }

class CupertinoTabViewRoutes {
  static const bananaEntriesPage = '/banana-entries-page';
}

class CupertinoTabViewRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CupertinoTabViewRoutes.bananaEntriesPage:
        final banana = settings.arguments;
        return CupertinoPageRoute(
          builder: (_) => BananaEntriesPage(banana: banana),
          settings: settings,
          fullscreenDialog: true,
        );
    }
    return null;
  }
}
