
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_list_app/layouts/layout_scaffold.dart';
import 'package:shopping_list_app/models/routes.dart';
import 'package:shopping_list_app/screens/categories_screen.dart';
import 'package:shopping_list_app/screens/shopping_list_detail_screen.dart';
import 'package:shopping_list_app/screens/shopping_list_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.homePage,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => LayoutScaffold(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.homePage,
              builder: (context, state) => const ShoppingListScreen(),
              routes: [
                GoRoute(
                  path: Routes.details,
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>;
                    final name = extra['name'] as String;
                    final listId = extra['listId'] as String;

                    return ShoppingListDetailScreen(name: name, listId: listId);
                  } 
                )
              ],
            )
          ]
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.categoriesPage,
              builder: (context, state) => const CategoriesScreen(),
            )
          ]
        ),
      ],
    ),
  ],
);