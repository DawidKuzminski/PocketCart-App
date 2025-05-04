class ShoppingItem{
  final String id;
  final String name;
  final bool isBought;
  final int quantity;

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.isBought = false
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'isBought': isBought
  };

  factory ShoppingItem.fromMap(Map<String, dynamic> map) => ShoppingItem(
    id: map['id'],
    name: map['name'],
    quantity: map['quantity'] ?? 1,
    isBought: map['isBought']
  );
}