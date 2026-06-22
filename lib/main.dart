import 'package:app_pedidos/core/bloc/app/app_bloc.dart';
import 'package:app_pedidos/core/provider/cart_provider.dart';
import 'package:app_pedidos/core/provider/order_provider.dart';
import 'package:app_pedidos/core/provider/product_provider.dart';
import 'package:app_pedidos/core/service/notification_service.dart';
import 'package:app_pedidos/locator.dart';
import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/theme/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  // await locator<NotificationService>().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppBloc()..initialize(), lazy: false),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}