import 'package:app_pedidos/router.dart';
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
              SizedBox(width: 250, child: getSideBar()),
              Expanded(
                child: Scaffold(
                  appBar: AppBar(title: Text("App")),
                  body: widget.child,
                ),
              ),
            ],
          )
        : Scaffold(
            appBar: AppBar(title: const Text('App')),
            drawer: getSideBar(), // 👈 aqui entra a sidebar
            body: widget.child,
          );
  }

  Widget getSideBar({isDrawer = true}) {
    final items = [
      {
        'icon': Icons.house,
        'label': 'Destaques',
        'path': Routes.home,
        'auth': false,
      },
      {
        'icon': Icons.category,
        'label': 'Categorias',
        'path': Routes.category,
        'auth': false,
      },
      {
        'icon': Icons.production_quantity_limits,
        'label': '...',
        'path': Routes.addProduct,
        'auth': true,
      },
    ];

    final sidebarContent = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          // 🔹 HEADER (com primary color)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: [ 
                Image.asset('images/logo.jpg', height: 60),
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

          // 🔹 ITENS
          Expanded(
            child: ListView(
              children: List.generate(items.length, (index) {
                return ListTile(
                  leading: Icon(
                    items[index]['icon'] as IconData,
                    color: Colors.black87,
                  ),
                  title: Text(
                    items[index]['label'] as String,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    context.go(items[index]['path'] as String);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );

    return isDrawer ? Drawer(child: sidebarContent,) : sidebarContent;
  }
}
