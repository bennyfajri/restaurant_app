import 'dart:convert';

class ListRestaurant {
  List<Restaurants>? restaurants;

  ListRestaurant({this.restaurants});

  ListRestaurant.fromJson(Map<String, dynamic> json) {
    if (json['restaurants'] != null) {
      restaurants = <Restaurants>[];
      json['restaurants'].forEach((v) {
        restaurants!.add(Restaurants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (restaurants != null) {
      data['restaurants'] = restaurants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurants {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  num? rating;
  ListMenu? menus;

  Restaurants(
      {this.id,
        this.name,
        this.description,
        this.pictureId,
        this.city,
        this.rating,
        this.menus});

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureId = json['pictureId'];
    city = json['city'];
    rating = json['rating'];
    menus = json['menus'] != null ? ListMenu.fromJson(json['menus']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['pictureId'] = pictureId;
    data['city'] = city;
    data['rating'] = rating;
    if (menus != null) {
      data['menus'] = menus?.toJson();
    }
    return data;
  }
}

class ListMenu {
  List<Menu>? foods;
  List<Menu>? drinks;

  ListMenu({this.foods, this.drinks});

  ListMenu.fromJson(Map<String, dynamic> json) {
    if (json['foods'] != null) {
      foods = <Menu>[];
      json['foods'].forEach((v) {
        foods!.add(Menu.fromJson(v));
      });
    }
    if (json['drinks'] != null) {
      drinks = <Menu>[];
      json['drinks'].forEach((v) {
        drinks!.add(Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (foods != null) {
      data['foods'] = foods?.map((v) => v.toJson()).toList();
    }
    if (drinks != null) {
      data['drinks'] = drinks?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Menu {
  String? name;

  Menu({this.name});

  Menu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

ListRestaurant parseListRestaurant(String? json) {
  if(json == null) {
    return ListRestaurant();
  }

  final dynamic parsed = jsonDecode(json);
  return ListRestaurant.fromJson(parsed);
}