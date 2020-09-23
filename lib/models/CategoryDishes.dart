import 'AddonCat.dart';

class CategoryDishes {
  String dishId;
  String dishName;
  double dishPrice;
  String dishImage;
  String dishCurrency;
  double dishCalories;
  String dishDescription;
  bool dishAvailability;
  int dishType;
  String nexturl;
  List<AddonCat> addonCat;

  CategoryDishes(
      {this.dishId,
        this.dishName,
        this.dishPrice,
        this.dishImage,
        this.dishCurrency,
        this.dishCalories,
        this.dishDescription,
        this.dishAvailability,
        this.dishType,
        this.nexturl,
        this.addonCat});

  CategoryDishes.fromJson(Map<String, dynamic> json) {
    dishId = json['dish_id'];
    dishName = json['dish_name'];
    dishPrice = json['dish_price'];
    dishImage = json['dish_image'];
    dishCurrency = json['dish_currency'];
    dishCalories = json['dish_calories'];
    dishDescription = json['dish_description'];
    dishAvailability = json['dish_Availability'];
    dishType = json['dish_Type'];
    nexturl = json['nexturl'];
    if (json['addonCat'] != null) {
      addonCat = new List<AddonCat>();
      json['addonCat'].forEach((v) {
        addonCat.add(new AddonCat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_id'] = this.dishId;
    data['dish_name'] = this.dishName;
    data['dish_price'] = this.dishPrice;
    data['dish_image'] = this.dishImage;
    data['dish_currency'] = this.dishCurrency;
    data['dish_calories'] = this.dishCalories;
    data['dish_description'] = this.dishDescription;
    data['dish_Availability'] = this.dishAvailability;
    data['dish_Type'] = this.dishType;
    data['nexturl'] = this.nexturl;
    if (this.addonCat != null) {
      data['addonCat'] = this.addonCat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}