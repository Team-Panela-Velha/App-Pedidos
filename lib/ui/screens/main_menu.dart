import 'package:app_pedidos/router.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatefulWidget {
  final Widget child;

  const MainMenu({super.key, required this.child});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App'),
      ),
      drawer: getSideBar(), // 👈 aqui entra a sidebar
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: widget.child,
        ), 
    );
  }

  Widget getSideBar() {
    final items = [
      {'icon': Icons.house, 'label': 'Destaques', 'path': Routes.home, 'auth': false},
      {'icon': Icons.category, 'label': 'Categorias', 'path': Routes.category, 'auth': false},
      {'icon': Icons.production_quantity_limits, 'label': '...', 'path': Routes.addProduct, 'auth': true},
    ];

    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // 🔹 Header (opcional)
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),

            // 🔹 Itens
            ...List.generate(items.length, (index) {
              return ListTile(
                leading: Icon(items[index]['icon'] as IconData),
                title: Text(items[index]['label'] as String),
                onTap: () {
                  // navegação
                  Navigator.pop(context); // fecha o drawer

                  // exemplo com GoRouter:
                  // context.go(items[index]['path'] as String);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}