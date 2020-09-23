import 'Addons.dart';

class AddonCat {
  String addonCategory;
  String addonCategoryId;
  int addonSelection;
  String nexturl;
  List<Addons> addons;

  AddonCat(
      {this.addonCategory,
        this.addonCategoryId,
        this.addonSelection,
        this.nexturl,
        this.addons});

  AddonCat.fromJson(Map<String, dynamic> json) {
    addonCategory = json['addon_category'];
    addonCategoryId = json['addon_category_id'];
    addonSelection = json['addon_selection'];
    nexturl = json['nexturl'];
    if (json['addons'] != null) {
      addons = new List<Addons>();
      json['addons'].forEach((v) {
        addons.add(new Addons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addon_category'] = this.addonCategory;
    data['addon_category_id'] = this.addonCategoryId;
    data['addon_selection'] = this.addonSelection;
    data['nexturl'] = this.nexturl;
    if (this.addons != null) {
      data['addons'] = this.addons.map((v) => v.toJson()).toList();
    }
    return data;
  }
}