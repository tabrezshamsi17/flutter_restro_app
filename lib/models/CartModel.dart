class CartModel {
  int iId;
  int dishId;
  String dishName;
  double dishPrice;
  double dishCalories;
  int dishQty;

  CartModel(
      {this.iId,
        this.dishId,
        this.dishName,
        this.dishPrice,
        this.dishCalories,
        this.dishQty});

  CartModel.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    dishId = json['dish_id'];
    dishName = json['dish_name'];
    dishPrice = json['dish_price'];
    dishCalories = json['dish__calories'];
    dishQty = json['dish_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.iId;
    data['dish_id'] = this.dishId;
    data['dish_name'] = this.dishName;
    data['dish_price'] = this.dishPrice;
    data['dish__calories'] = this.dishCalories;
    data['dish_qty'] = this.dishQty;
    return data;
  }
}
