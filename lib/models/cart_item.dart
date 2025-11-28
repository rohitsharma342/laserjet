import 'printer.dart';

class CartItem {
  final String id;
  final Printer printer;
  int quantity;

  CartItem({
    required this.id,
    required this.printer,
    this.quantity = 1,
  });

  double get totalPrice => printer.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      printer: Printer.fromJson(json['printer']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'printer': printer.toJson(),
      'quantity': quantity,
    };
  }
}