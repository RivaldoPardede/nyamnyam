import 'menu_item.dart';

/// Menus model containing foods and drinks
class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  const Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: (json['foods'] as List<dynamic>)
          .map((f) => MenuItem.fromJson(f as Map<String, dynamic>))
          .toList(),
      drinks: (json['drinks'] as List<dynamic>)
          .map((d) => MenuItem.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}
