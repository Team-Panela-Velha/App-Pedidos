import 'package:app_pedidos/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 650;
            return Row(
              children: [
                // 🔹 MESA + SEARCH
                Expanded(
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.only(
                      left: compact ? 16 : 20,
                      right: compact ? 8 : 20,
                    ),
                    color: Colors.white,
                    child: Row(
                      children: [
                        // 🔹 MESA
                        if (!compact)
                          const Text(
                            'MESA 12',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 26, // ← aumentado
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                        if (!compact) const SizedBox(width: 24),

                        // 🔹 SEARCH
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: compact ? double.infinity : 200,
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const _HeaderSearch(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔹 BOTÕES (só ícones)
                if (!compact)
                  Container(
                    height: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.white,
                    child: Row(
                      children: [
                        _headerIcon(icon: Icons.support_agent),

                        const SizedBox(width: 28),

                        _headerIcon(
                          icon: Icons.receipt_long,
                          onTap: () => context.go(Routes.order),
                        ),

                        const SizedBox(width: 28),

                        _headerIcon(
                          icon: Icons.shopping_cart_outlined,
                          onTap: () => context.go(Routes.cart),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _headerIcon(
                      icon: Icons.shopping_cart_outlined,
                      onTap: () => context.go(Routes.cart),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 🔹 BOTÃO SÓ COM ÍCONE
  Widget _headerIcon({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 34, // ← ícone maior
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _HeaderSearch extends StatefulWidget {
  const _HeaderSearch();

  @override
  State<_HeaderSearch> createState() => _HeaderSearchState();
}

class _HeaderSearchState extends State<_HeaderSearch> {
  final _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final keyword = GoRouterState.of(context).uri.queryParameters['keyword'];
    if (_controller.text.isEmpty && keyword != null) {
      _controller.text = keyword;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final keyword = _controller.text.trim();
    FocusScope.of(context).unfocus();
    if (keyword.isEmpty) {
      if (GoRouterState.of(context).uri.path == Routes.search) {
        context.go(Routes.home);
      }
      return;
    }
    final location = Uri(
      path: Routes.search,
      queryParameters: {'keyword': keyword},
    ).toString();
    context.push(location);
  }

  void _clear() {
    _controller.clear();
    setState(() {});
    if (GoRouterState.of(context).uri.path == Routes.search) {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      onChanged: (_) => setState(() {}),
      onSubmitted: (_) => _submit(),
      style: const TextStyle(color: Colors.black87, fontSize: 16),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'BUSCAR',
        hintStyle: const TextStyle(color: Colors.black45, fontSize: 16),
        prefixIcon: IconButton(
          tooltip: 'Buscar produtos',
          onPressed: _submit,
          icon: const Icon(Icons.search, color: Colors.black54, size: 26),
        ),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Limpar busca',
                onPressed: _clear,
                icon: const Icon(Icons.close, size: 18),
              ),
        contentPadding: const EdgeInsets.only(top: 12),
      ),
    );
  }
}
