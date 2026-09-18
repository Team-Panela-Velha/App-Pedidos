import 'package:app_pedidos/core/model/product/product.dart';
import 'package:app_pedidos/core/model/category.dart';
import 'package:app_pedidos/core/model/order/order_item.dart';
import 'package:app_pedidos/core/model/order/extra.dart';
import 'package:app_pedidos/core/model/tab/tab.dart' as model;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app_pedidos/ui/widgets/category_grid.dart';
import 'package:app_pedidos/ui/screens/header_menu.dart';
import 'package:app_pedidos/router.dart';
import 'package:go_router/go_router.dart';

void main() {
  test(
    'produto mantém os campos usados pelo app com disponibilidade adicional',
    () {
      final product = Product.fromJson({
        'id': 1,
        'name': 'Poke',
        'price': 25.0,
        'description': 'Descrição',
        'image': 'image.png',
        'categoryId': 2,
        'available': false,
        'extras': [],
      });

      expect(product.id, 1);
      expect(product.name, 'Poke');
      expect(product.price, 25.0);
      expect(product.extras, isEmpty);
      expect(product.categoryId, 2);
      expect(product.available, isFalse);
    },
  );

  test('total pendente inclui adicionais para cada unidade', () {
    final item = OrderItem(
      productId: 1,
      quantity: 2,
      unitPrice: 10,
      extras: [Extra(id: 3, name: 'Abacate', price: 3)],
    );
    expect(item.estimatedTotal, 26);
    expect(item.toJson()['extraIds'], [3]);
  });

  testWidgets('grade de categorias usa dados reais e abre a categoria tocada', (
    tester,
  ) async {
    Category? selected;
    final categories = [
      Category(id: 2, name: 'Bebidas'),
      Category(id: 3, name: 'Pokes'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryGrid(
            categories: categories,
            onSelected: (category) => selected = category,
          ),
        ),
      ),
    );
    expect(find.text('Bebidas'), findsOneWidget);
    expect(find.text('Pokes'), findsOneWidget);
    await tester.tap(find.text('Pokes'));
    expect(selected?.id, 3);
  });

  testWidgets('busca do header abre resultados sem criar campo na home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final router = GoRouter(
      initialLocation: Routes.home,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const Scaffold(
            appBar: MainHeader(),
            body: Center(child: Text('Home de destaques')),
          ),
        ),
        GoRoute(
          path: Routes.search,
          builder: (context, state) => Scaffold(
            appBar: const MainHeader(),
            body: Text('Resultado: ${state.uri.queryParameters['keyword']}'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.enterText(find.byType(TextField), 'salmão');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    expect(find.text('Resultado: salmão'), findsOneWidget);
    await tester.tap(find.byTooltip('Limpar busca'));
    await tester.pumpAndSettle();
    expect(find.text('Home de destaques'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('comanda mantém os campos usados pelo app com data adicional', () {
    final tab = model.Tab.fromJson({
      'id': 3,
      'totalValue': 42.50,
      'closed': false,
      'tableId': 4,
      'tableCode': 'A1',
      'openedAt': '2026-09-16T12:00:00Z',
    });

    expect(tab.id, 3);
    expect(tab.totalValue, 42.50);
    expect(tab.closed, isFalse);
    expect(tab.tableCode, 'A1');
  });
}
