class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final List<Order> orderHistory;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.orderHistory = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      orderHistory: (json['orderHistory'] as List<dynamic>?)
          ?.map((order) => Order.fromJson(order))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'orderHistory': orderHistory.map((order) => order.toJson()).toList(),
    };
  }
}

class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final String status;
  final double totalAmount;
  final List<String> productIds;

  Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.productIds,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      orderNumber: json['orderNumber'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      totalAmount: json['totalAmount'].toDouble(),
      productIds: List<String>.from(json['productIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'date': date.toIso8601String(),
      'status': status,
      'totalAmount': totalAmount,
      'productIds': productIds,
    };
  }
}