import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restro_app/Constants/DatabaseHelper.dart';
import 'package:flutter_restro_app/models/CategoryDishes.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  CategoryDishes categoryDishesList;

  ProductDetails(this.categoryDishesList);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  int _n = 1;
  double _itemTotalAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.grey),
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Text(widget.categoryDishesList.dishName,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    )),
                background: CachedNetworkImage(
                  imageUrl: widget.categoryDishesList.dishImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    child: Image.asset(
                      'assets/img/placeholder.png',
                      scale: 6,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16.0, 0.0, 12.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Text(
                          widget.categoryDishesList.dishName,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        child: Text(
                          widget.categoryDishesList.dishDescription,
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey.shade700),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        child: Text(
                          'INR ' + widget.categoryDishesList.dishPrice.toString(),
                          style: TextStyle(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0.0, 16.0, 12.0, 16.0),
                        width: 100.0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14.0,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 130.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.green,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        minus();
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        size: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '$_n',
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.white),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        add();
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.green,
                  child: MaterialButton(
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            int result = await _databaseHelper.addCart(
                                widget.categoryDishesList.dishId,
                                widget.categoryDishesList.dishName,
                                widget.categoryDishesList.dishPrice
                                    .toString(),
                                widget.categoryDishesList.dishCalories
                                    .toString(),
                                _n.toString());
                            if (result != 0) {
                              var data = 1;
                              Navigator.pop(context, data);
                            }
                          },
                          child: Text(
                            'Add To Cart',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'Total = ' + calc().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void add() {
    setState(() {
      _n++;
    });
    print("QTY $_n");
    calc();
  }

  void minus() {
    setState(() {
      if (_n != 1) _n--;
    });
    calc();
  }

  double calc() {
    double tempTotal = 0.0;
    if (widget.categoryDishesList.dishPrice.toString() != "") {
      tempTotal = double.parse(widget.categoryDishesList.dishPrice.toString()) *
          double.parse(_n.toString());
      _itemTotalAmount = tempTotal;
      return _itemTotalAmount;
    } else {
      return null;
    }
  }
}
