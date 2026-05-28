import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/ui/screens/header_menu.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainMenu extends StatefulWidget {
  final Widget child;

  const MainMenu({super.key, required this.child});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return isLandscape
        ? Row(
            children: [
              SizedBox(width: 110, child: getSideBar(isDrawer: false)),
              Expanded(
                child: Scaffold(
                  appBar: MainHeader(),
                  body: widget.child,
                ),
              ),
            ],
          )
        : Scaffold(
            appBar: const MainHeader(),
            drawer: getSideBar(),
            body: widget.child,
          );
  }

  Widget getSideBar({bool isDrawer = true}) {
    final items = [
      {
        'icon': Icons.house,
        'label': 'Destaques',
        'path': Routes.home,
      },
      {
        'icon': Icons.category,
        'label': 'Categorias',
        'path': Routes.category,
      },
      {
        'icon': Icons.receipt_long,
        'label': 'Pedido',
        'path': Routes.order,
      },
      {
        'icon': Icons.shopping_cart,
        'label': 'Carrinho',
        'path': Routes.cart,
        'badge': 2,
      },
    ];

    final sidebarContent = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: [
                Image.asset('images/logo2.png',height: 60),
                const SizedBox(height: 10),
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final badge = item['badge'] as int?;
                final hasBadge = badge != null && badge > 0;

                return InkWell(
                  onTap: () {
                    if (isDrawer) {
                      Navigator.of(context).pop();
                    }
                    context.go(item['path'] as String);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              size: 38,
                              color: Colors.black87,
                            ),
                            if (hasBadge)
                              Positioned(
                                top: -6,
                                right: -10,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  child: Text(
                                    badge > 99 ? '99+' : '$badge',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );

    return isDrawer
        ? Drawer(child: sidebarContent)
        : Material(child: sidebarContent);
  }
}