class ShoppingItem{
  final String id;
  final String name;
  final bool isBought;
  final int quantity;
  final String category;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    this.isBought = false
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'category': category,
    'quantity': quantity,
    'isBought': isBought
  };

  factory ShoppingItem.fromMap(Map<String, dynamic> map) => ShoppingItem(
    id: map['id'],
    name: map['name'],
    category: map['category'] ?? 'Inne',
    quantity: map['quantity'] ?? 1,
    isBought: map['isBought']
  );
}