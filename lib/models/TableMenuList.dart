import 'CategoryDishes.dart';

class TableMenuList {
  String menuCategory;
  String menuCategoryId;
  String menuCategoryImage;
  String nexturl;
  List<CategoryDishes> categoryDishes;

  TableMenuList(
      {this.menuCategory,
        this.menuCategoryId,
        this.menuCategoryImage,
        this.nexturl,
        this.categoryDishes});

  TableMenuList.fromJson(Map<String, dynamic> json) {
    menuCategory = json['menu_category'];
    menuCategoryId = json['menu_category_id'];
    menuCategoryImage = json['menu_category_image'];
    nexturl = json['nexturl'];
    if (json['category_dishes'] != null) {
      categoryDishes = new List<CategoryDishes>();
      json['category_dishes'].forEach((v) {
        categoryDishes.add(new CategoryDishes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_category'] = this.menuCategory;
    data['menu_category_id'] = this.menuCategoryId;
    data['menu_category_image'] = this.menuCategoryImage;
    data['nexturl'] = this.nexturl;
    if (this.categoryDishes != null) {
      data['category_dishes'] =
          this.categoryDishes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
