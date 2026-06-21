import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../core/constants/app_strings.dart';

class CartController extends ChangeNotifier {
  List<CartItemModel> _items = [];

  CartController() {
    _loadCart();
  }

  List<CartItemModel> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  bool isInCart(int productId) =>
      _items.any((item) => item.product.id == productId);

  int quantityInCart(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index != -1 ? _items[index].quantity : 0;
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + quantity,
      );
    } else {
      _items.add(CartItemModel(product: product, quantity: quantity));
    }

    _saveCart();
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.removeWhere((item) => item.product.id == productId);
    _saveCart();
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      _saveCart();
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity <= 1) {
        removeFromCart(productId);
      } else {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity - 1,
        );
        _saveCart();
        notifyListeners();
      }
    }
  }

  void clearCart() {
    _items.clear();
    _saveCart();
    notifyListeners();
  }

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(AppStrings.cartKey);
      if (cartJson != null) {
        _items = CartItemModel.decodeList(cartJson);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = CartItemModel.encodeList(_items);
      await prefs.setString(AppStrings.cartKey, cartJson);
    } catch (_) {}
  }
}
