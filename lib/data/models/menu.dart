import 'menu_item.dart';

/// Menu model containing foods and drinks
class Menu {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  const Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      foods: (json['foods'] as List<dynamic>)
          .map((f) => MenuItem.fromJson(f as Map<String, dynamic>))
          .toList(),
      drinks: (json['drinks'] as List<dynamic>)
          .map((d) => MenuItem.fromJson(d as Map<String, dynamic>))
          .toList(),
    );
  }
}
