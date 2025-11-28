class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final List<Order> orderHistory;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.orderHistory = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
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
      'avatar': avatar,
      'orderHistory': orderHistory.map((order) => order.toJson()).toList(),
    };
  }
}

class Order {
  final String id;
  final DateTime date;
  final String status;
  final double total;
  final List<String> items;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      total: json['total'].toDouble(),
      items: List<String>.from(json['items']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'status': status,
      'total': total,
      'items': items,
    };
  }
}