import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restro_app/Constants/DatabaseHelper.dart';
import 'package:flutter_restro_app/HomeScreen.dart';

class OrderSummary extends StatefulWidget {
  @override
  _OrderSummary createState() => _OrderSummary();
}

class _OrderSummary extends State<OrderSummary> {
  DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  var cartList = [];
  int totalItems = 0;
  double total = 0.0;
  int _n = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Text(
          "Order Summary",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              children: [
                Container(
                  height: 60.0,
                  width: double.infinity,
                  margin: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green[900],
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Center(
                    child: Text(
                      "$totalItems Dishes - $totalItems Items",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartList.length == 0 ? 0 : cartList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                            BorderRadius.circular(5.0),
                                        color: Colors.green),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cartList[index]["dish_name"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Container(
                                            child: Text(
                                              "INR ${cartList[index]["dish_price"]}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            cartList[index]["dish__calories"] +
                                                " calories",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 130.0,
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Colors.green,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                              cartList[index]["dish_qty"],
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white),
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
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      "INR ${qtyTotal(index)}",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Amount",
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      total.toString(),
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ),
            InkWell(
              onTap: () {
                _showMyDialog();
              },
              child: Container(
                height: 50.0,
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Center(
                  child: Text(
                    "Place Order",
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCart() {
    Future<List> cartListItem = _databaseHelper.getCart();
    cartListItem.then((value) {
      setState(() {
        cartList = value;
      });
      setState(() {
        total = 0;
        for (int i = 0; i < cartList.length; i++) {
          total += double.parse(cartList[i]['dish_price'].toString()) *
              double.parse(cartList[i]['dish_qty'].toString());
          totalItems++;
        }
      });
      //debugPrint(cartList.toString());
    });
  }

  void add() {
    setState(() {
      _n++;
    });
    //calc();
  }

  void minus() {
    setState(() {
      if (_n > 0) _n--;
    });
    //calc();
  }

  String qtyTotal(int index) {
    double totalAmount;
    totalAmount = double.parse(cartList[index]["dish_qty"]) *
        double.parse(cartList[index]["dish_price"]);
    return totalAmount.toString();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Order successfully placed'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _databaseHelper.deleteCart();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }
}
