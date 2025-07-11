import 'package:flutter/material.dart';

class RouterDestination {
  const RouterDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

const destinations = [
  RouterDestination(label: 'Listy', icon: Icons.home),
  RouterDestination(label: 'Kategorie', icon: Icons.category)
];