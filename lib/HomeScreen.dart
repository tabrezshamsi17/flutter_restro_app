import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restro_app/Constants/DatabaseHelper.dart';
import 'package:flutter_restro_app/OrderSummary.dart';
import 'package:flutter_restro_app/ProductDetails.dart';
import 'package:flutter_restro_app/SignIn.dart';
import 'package:flutter_restro_app/models/CategoryDishes.dart';
import 'package:flutter_restro_app/models/Restaurant.dart';
import 'package:flutter_restro_app/models/TableMenuList.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future getRestaurantFuture;
  Future getDishCategoryFuture;
  TabController _tabController;
  static List<TableMenuList> tableMenuList = [];
  static List<Restaurant> restaurantList = [];
  static List<CategoryDishes> categoryDishesList = [];
  var loading = false;
  String uid;
  String name;
  String number;
  int cartCount = 0;
  double totals = 0.0;

  Future<List<Restaurant>> getTableMenuList() async {
    setState(() {
      loading = true;
    });
    String url = "https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad";
    var response = await http
        .get(Uri.encodeFull(url), headers: {'Accept': 'application/json'});

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var map in data) {
          setState(() {
            restaurantList.add(Restaurant.fromJson(map));
          });
        }
        print("restaurantList ${restaurantList.length}");
      }
    } catch (e, _) {
      debugPrint(e.toString());
    }
    return restaurantList;
  }

  @override
  void initState() {
    getRestaurantFuture = getTableMenuList();
    _databaseHelper.getUserData().then((value) {
      if (value != null) {
        setState(() {
          uid = value[0]['user_uid'];
          name = value[0]['user_name'];
          number = value[0]['user_number'];
        });
      }
    });
    getCartCount();
    super.initState();
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getRestaurantFuture,
      builder: (context, snap) {
        if (snap.hasData) {
          tableMenuList = snap.data[0].tableMenuList;
          _tabController =
              TabController(vsync: this, length: tableMenuList.length);
          List<Tab> tabs = new List<Tab>();
          for (int i = 0; i < tableMenuList.length; i++) {
            tabs.add(Tab(
              child: Text(
                tableMenuList[i].menuCategory,
                style: TextStyle(color: Colors.black),
              ),
            ));
          }
          return DefaultTabController(
            length: snap.data.length,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                title: Text(""),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderSummary()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Badge(
                        position: BadgePosition.topLeft(top: 4, left: 8),
                        badgeContent: Text(
                          cartCount.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                        animationType: BadgeAnimationType.fade,
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.black,
                  tabs: tabs,
                ),
              ),
              drawer: Drawer(
                child: Column(
                  children: [
                    Container(
                      height: 220.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(14.0),
                            bottomRight: Radius.circular(14.0),
                          )),
                      padding: EdgeInsets.only(top: 50.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_circle,
                            size: 80.0,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            name == null ? number : name,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "ID : ",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    uid.toString(),
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    InkWell(
                      onTap: () async {
                        auth.signOut();
                        auth.currentUser.delete();
                        _databaseHelper.deleteUser();
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              size: 30.0,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              width: 6.0,
                            ),
                            Text(
                              "Log out",
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              body: Stack(
                children: [
                  TabBarView(
                    controller: _tabController,
                    children: List<Widget>.generate(tableMenuList.length,
                        (int index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: tableMenuList.length,
                          itemBuilder: (context, index) {
                            categoryDishesList =
                                tableMenuList[index].categoryDishes;
                            return ListView.builder(
                              itemCount: categoryDishesList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onTap: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                    categoryDishesList[i])));
                                    if (result == 1) {
                                      getCartCount();
                                    } else {}
                                  },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 6),
                                              height: 20.0,
                                              width: 20.0,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  height: 12.0,
                                                  width: 12.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      color: categoryDishesList[
                                                                      i]
                                                                  .dishType ==
                                                              1
                                                          ? Colors.red
                                                          : Colors.green),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    categoryDishesList[i]
                                                        .dishName,
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "INR ${categoryDishesList[i].dishPrice.toString()}",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        categoryDishesList[i]
                                                                .dishCalories
                                                                .toString() +
                                                            " calories",
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text(
                                                    categoryDishesList[i]
                                                        .dishDescription,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[600]),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  categoryDishesList[i]
                                                              .addonCat
                                                              .length ==
                                                          0
                                                      ? Container()
                                                      : Text(
                                                          "Customizations available",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Container(
                                              height: 100.0,
                                              width: 80.0,
                                              child: CachedNetworkImage(
                                                imageUrl: categoryDishesList[i]
                                                    .dishImage,
                                                progressIndicatorBuilder: (context,
                                                        url,
                                                        downloadProgress) =>
                                                    Center(
                                                        child: CircularProgressIndicator(
                                                            value:
                                                                downloadProgress
                                                                    .progress)),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        "assets/img/placeholder.png"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                          child: Divider(
                                            thickness: 1.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ),
                  cartCount > 0
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.green,
                              child: MaterialButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                OrderSummary(),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            height: 30.0,
                                            width: 30.0,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Text(
                                              '$cartCount',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            'See Cart',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'Total Rs $totals',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        } else if (snap.hasError) {
          return Center(
            child: Text("Error${snap.error}"),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Loading"),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  /*void getFireUser() {
    final User user = auth.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
        if (user.displayName.toString() == null) {
          number = user.phoneNumber.toString();
        } else {
          name = user.displayName.toString();
        }
      });
      print("uid $uid");
      print("name $name");
      print("number $number");
    }
  }*/

  void getCartCount() async {
    Future<List> count = _databaseHelper.getCartCount();
    count.then((value) {
      if (value != null || value.length > 0) {
        if (mounted) {
          setState(() {
            cartCount = value[0]['counts'];
            totals = value[0]['totalSum'];
          });
        }
      }
    });
  }
}
