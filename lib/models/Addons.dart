class Addons {
  String dishId;
  String dishName;
  double dishPrice;
  String dishImage;
  String dishCurrency;
  double dishCalories;
  String dishDescription;
  bool dishAvailability;
  int dishType;

  Addons(
      {this.dishId,
        this.dishName,
        this.dishPrice,
        this.dishImage,
        this.dishCurrency,
        this.dishCalories,
        this.dishDescription,
        this.dishAvailability,
        this.dishType});

  Addons.fromJson(Map<String, dynamic> json) {
    dishId = json['dish_id'];
    dishName = json['dish_name'];
    dishPrice = json['dish_price'];
    dishImage = json['dish_image'];
    dishCurrency = json['dish_currency'];
    dishCalories = json['dish_calories'];
    dishDescription = json['dish_description'];
    dishAvailability = json['dish_Availability'];
    dishType = json['dish_Type'];
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
    return data;
  }
}