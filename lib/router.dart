import 'package:app_pedidos/ui/screens/category_screen.dart';
import 'package:app_pedidos/ui/screens/product_screen.dart';
import 'package:app_pedidos/ui/screens/select_table.dart';
import 'package:app_pedidos/ui/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => CategoryScreen(),
      ),
    ],
  );
}