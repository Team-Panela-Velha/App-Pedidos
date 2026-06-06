import 'package:app_pedidos/core/service/table_service.dart';
import 'package:app_pedidos/router.dart';
import 'package:app_pedidos/theme/app_colors.dart';
import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SelectTable extends StatefulWidget {
  const SelectTable({super.key});

  @override
  State<SelectTable> createState() => _SelectTableState();
}

class _SelectTableState extends State<SelectTable> {
  final TextEditingController tableCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _entrar() async {
    final codigo = tableCodeController.text.trim();
    if (codigo.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final tableService = TableService();
      final table = await tableService.getTableByCode(codigo);
      
      if (mounted) {
        context.go(Routes.newComanda, extra: table.code);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Mesa não encontrada ou código inválido"),
            backgroundColor: Colors.red,
          ),
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
            ClipRRect(
              child: Image.asset(
                'images/logo.jpg',
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),

            Center(
              child: SizedBox(
                width: 250,
                child: Text(
                  "Please enter the code to access your desired table.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            Center(
              child: SizedBox(
                height: 52,
                width: 240,
                child: TextField(
                  controller: tableCodeController,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.text, // Mudado para text caso o código tenha letras
                  onSubmitted: (_) => _entrar(),
                  decoration: InputDecoration(
                    hintText: "Table Code",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textIconSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.iconSquareColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            SimpleButton(
              onTap: _entrar, 
              text: "Select Table",
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}