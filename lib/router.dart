import 'package:app_pedidos/ui/screens/category/category_screen.dart';
import 'package:app_pedidos/ui/screens/home/home_screen.dart';
import 'package:app_pedidos/ui/screens/main_menu.dart';
import 'package:app_pedidos/ui/screens/add_product/product_screen.dart';
import 'package:app_pedidos/ui/screens/table/select_table.dart';
import 'package:app_pedidos/ui/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const _ = '/';
  static const startSession = '/start-session';
  static const home = '/home';
  static const category = '/category';
  static const addProduct = '/add-product';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.startSession,
    routes: [
      GoRoute(path: Routes._, builder: (context, state) => SplashScreen()),
      GoRoute(
        path: Routes.startSession,
        builder: (context, state) => SelectTable(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainMenu(child: child);
        },
        routes: [
          GoRoute(path: Routes.home, builder: (context, state) => HomePage()),
          GoRoute(
            path: Routes.category,
            builder: (context, state) => CategoryScreen(),
          ),
          GoRoute(
            path: Routes.addProduct,
            builder: (context, state) => ProductScreen(),
          ),
        ],
      ),
    ],
  );
}
