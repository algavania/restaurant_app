// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

Restaurant restaurantFromJson(String str) => Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  Restaurant({
    required this.restaurants,
  });

  List<RestaurantItem> restaurants;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    restaurants: List<RestaurantItem>.from(json["restaurants"].map((x) => RestaurantItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
  };
}

class RestaurantItem {
  RestaurantItem({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  String id;
  String name;
  String description;
  String pictureId;
  String city;
  double rating;
  Menus menus;

  factory RestaurantItem.fromJson(Map<String, dynamic> json) => RestaurantItem(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    pictureId: json["pictureId"],
    city: json["city"],
    rating: json["rating"].toDouble(),
    menus: Menus.fromJson(json["menus"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "pictureId": pictureId,
    "city": city,
    "rating": rating,
    "menus": menus.toJson(),
  };
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  List<Menu> foods;
  List<Menu> drinks;

  factory Menus.fromJson(Map<String, dynamic> json) => Menus(
    foods: List<Menu>.from(json["foods"].map((x) => Menu.fromJson(x))),
    drinks: List<Menu>.from(json["drinks"].map((x) => Menu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}

class Menu {
  Menu({
    required this.name,
  });

  String name;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
