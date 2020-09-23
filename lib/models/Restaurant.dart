import 'TableMenuList.dart';

class Restaurant {
  String restaurantId;
  String restaurantName;
  String restaurantImage;
  String tableId;
  String tableName;
  String branchName;
  String nexturl;
  List<TableMenuList> tableMenuList;

  Restaurant(
      {this.restaurantId,
        this.restaurantName,
        this.restaurantImage,
        this.tableId,
        this.tableName,
        this.branchName,
        this.nexturl,
        this.tableMenuList});

  Restaurant.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    restaurantImage = json['restaurant_image'];
    tableId = json['table_id'];
    tableName = json['table_name'];
    branchName = json['branch_name'];
    nexturl = json['nexturl'];
    if (json['table_menu_list'] != null) {
      tableMenuList = new List<TableMenuList>();
      json['table_menu_list'].forEach((v) {
        tableMenuList.add(new TableMenuList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_image'] = this.restaurantImage;
    data['table_id'] = this.tableId;
    data['table_name'] = this.tableName;
    data['branch_name'] = this.branchName;
    data['nexturl'] = this.nexturl;
    if (this.tableMenuList != null) {
      data['table_menu_list'] =
          this.tableMenuList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}