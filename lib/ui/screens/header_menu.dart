import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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

          // 🔹 LADO ROSA
          Expanded(
            child: Container(
              height: 100,

              padding: const EdgeInsets.only(
                right:20,
              ),

              color: colors.primary,

              child: Row(
                children: [

                  // 🔹 LOGO
                  Image.asset(
                    'images/logo2.png',
                    height: 82,
                  ),

                  const SizedBox(width: 50),

                  // 🔹 MESA
                  Text(
                    'MESA 12',

                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // 🔹 SEARCH
                  SizedBox(
                    width: 140,

                    child: Container(
                      height: 45,

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),

                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: TextField(
                        style: TextStyle(
                          color: colors.onPrimary,
                        ),

                        decoration: InputDecoration(
                          border: InputBorder.none,

                          hintText: 'BUSCAR',

                          hintStyle: TextStyle(
                            color: colors.onPrimary
                                .withOpacity(0.7),
                          ),

                          prefixIcon: Icon(
                            Icons.search,
                            color: colors.onPrimary,
                          ),

                          contentPadding:
                              const EdgeInsets.only(top: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 LADO BRANCO
          Container(
            height: 100,

            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            color: Colors.white,

            child: Row(
              children: [

                _headerButton(
                  icon: Icons.support_agent,
                  label: 'Garçom',
                ),

                const SizedBox(width: 24),

                _headerButton(
                  icon: Icons.receipt_long,
                  label: 'Pedido',
                ),

                const SizedBox(width: 24),

                _headerButton(
                  icon: Icons.shopping_cart_outlined,
                  label: 'Carrinho',
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  // 🔹 BOTÃO DO LADO DIREITO
  Widget _headerButton({
    required IconData icon,
    required String label,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),

      onTap: () {},

      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),

        child: Row(
          children: [

            Icon(
              icon,
              size: 30,
              color: Colors.black87,
            ),

            const SizedBox(width: 10),

            Text(
              label,

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
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(80);
}