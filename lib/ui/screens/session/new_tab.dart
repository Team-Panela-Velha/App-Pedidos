import 'package:app_pedidos/core/bloc/app/app_bloc.dart';
import 'package:app_pedidos/core/service/tab_service.dart';
import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NewTab extends StatefulWidget {
  final String tableCode;

  const NewTab({super.key, required this.tableCode});

  @override
  State<NewTab> createState() => _NewTabState();
}

class _NewTabState extends State<NewTab> {
  bool _isLoading = false;

  Future<void> _iniciarComanda(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final tabService = TabService();
      // Chama o endpoint /tabs/start para iniciar a comanda
      final tab = await tabService.startTab(widget.tableCode);

      if (mounted) {
        context.read<AppBloc>().startSession(tab.id, widget.tableCode);
        context.go(Routes.home);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao iniciar comanda: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ícone da mesa
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.iconSquareColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.table_restaurant_outlined,
                size: 48,
                color: AppColors.textIconSecondary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Mesa ${widget.tableCode}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: 250,
              child: Text(
                "Nenhuma comanda ativa.\nInicie uma para começar os pedidos.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textIconSecondary,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Card informativo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.iconSquareColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.textIconSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Ao iniciar, você poderá adicionar itens ao pedido desta mesa.",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textIconSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SimpleButton(
              onTap: () => _iniciarComanda(context),
              text: "Iniciar Comanda",
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}