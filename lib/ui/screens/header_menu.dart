import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      toolbarHeight: 100,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      titleSpacing: 0,
      flexibleSpace: SafeArea(
        child: Row(
          children: [

            // 🔹 MESA + SEARCH
            Expanded(
              child: Container(
                height: 100,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.white,
                child: Row(
                  children: [

                    const SizedBox(width: 20),

                    // 🔹 MESA
                    const Text(
                      'MESA 12',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 26,          // ← aumentado
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(width: 24),

                    // 🔹 SEARCH
                    SizedBox(
                      width: 200,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const TextField(
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,       // ← aumentado
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'BUSCAR',
                            hintStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,     // ← aumentado
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black54,
                              size: 26,         // ← aumentado
                            ),
                            contentPadding: EdgeInsets.only(top: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 BOTÕES (só ícones)
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Row(
                children: [

                  _headerIcon(icon: Icons.support_agent),

                  const SizedBox(width: 28),

                  _headerIcon(icon: Icons.receipt_long),

                  const SizedBox(width: 28),

                  _headerIcon(icon: Icons.shopping_cart_outlined),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 BOTÃO SÓ COM ÍCONE
  Widget _headerIcon({required IconData icon}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 34,             // ← ícone maior
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}