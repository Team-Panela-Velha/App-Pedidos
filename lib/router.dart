import 'package:app_pedidos/data/mock_data.dart';
import 'package:app_pedidos/ui/screens/cart/cart_screen.dart';
import 'package:app_pedidos/ui/screens/category/category_screen.dart';
import 'package:app_pedidos/ui/screens/home/home_screen.dart';
import 'package:app_pedidos/ui/screens/main_menu.dart';
import 'package:app_pedidos/ui/screens/add_product/product_screen.dart';
import 'package:app_pedidos/ui/screens/order/order_screen.dart';
import 'package:app_pedidos/ui/screens/session/new_tab.dart';
import 'package:app_pedidos/ui/screens/session/select_table.dart';
import 'package:app_pedidos/ui/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const _ = '/';
  static const startSession = '/start-session';
  static const newComanda = '/comanda';
  static const home = '/home';
  static const category = '/category';
  static const addProduct = '/add-product';
  static const order = '/order';
  static const cart = '/cart';
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
      GoRoute(
        path: Routes.newComanda,
        builder: (context, state) {
          final tableCode = state.extra as String;
          return NewTab(tableCode: tableCode);
        },
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
            builder: (context, state) {
              final product = state.extra as ProductModel;
              return ProductScreen(product: product);
            },
          ),
          GoRoute(
            path: Routes.order,
            builder: (context, state) => const OrderScreen(),
          ),
          GoRoute(
            path: Routes.cart,
            builder: (context, state) => const CartScreen(),
          ),
        ],
      ),
    ],
  );
}