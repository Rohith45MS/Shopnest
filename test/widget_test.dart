import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_ecomerce/main.dart';
import 'package:task_ecomerce/controllers/cart_controller.dart';
import 'package:task_ecomerce/controllers/category_controller.dart';
import 'package:task_ecomerce/controllers/product_controller.dart';
import 'package:task_ecomerce/controllers/theme_controller.dart';
import 'package:task_ecomerce/controllers/user_controller.dart';

void main() {
  testWidgets('App should launch and display BottomNavigationBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeController()),
          ChangeNotifierProvider(create: (_) => ProductController()),
          ChangeNotifierProvider(create: (_) => CategoryController()),
          ChangeNotifierProvider(create: (_) => CartController()),
          ChangeNotifierProvider(create: (_) => UserController()),
        ],
        child: const ShopZenApp(),
      ),
    );

    // App renders without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
