import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/printer.dart';

class CartService extends ChangeNotifier {
  List<CartItem> _items = [];
  int _notificationCount = 3;

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  int get notificationCount => _notificationCount;
  
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(Printer printer, {int quantity = 1}) {
    final existingIndex = _items.indexWhere((item) => item.printer.id == printer.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        printer: printer,
        quantity: quantity,
      ));
    }
    
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }
    
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      _items[index].quantity = quantity;
      notifyListeners();
    }
  }

  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String printerId) {
    return _items.any((item) => item.printer.id == printerId);
  }

  void markNotificationsAsRead() {
    _notificationCount = 0;
    notifyListeners();
  }
}