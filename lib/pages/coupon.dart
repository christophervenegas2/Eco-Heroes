import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecoheroes/ui/to_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ecoheroes/ui/to_appbar.dart';

class Coupon extends StatefulWidget {
  final String userid;
  const Coupon({Key key, this.userid}) : super(key: key);

  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> {
  var loading = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var coupons = [];

  Future<void> getcupons() async {
    try {
      await firestore.collection('users/${widget.userid}/coupons').doc('coupons').get().then((value) => {coupons = value.data()['coupons']});
    } catch (e) {}
    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    getcupons();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            TOAppBar(back: true),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    loading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Color(0xFF4AD6A7)),
                            strokeWidth: 3,
                          )
                        : coupons.length < 1
                            ? Text('No tienes cupones disponibles')
                            : Expanded(
                                child: loading
                                    ? SizedBox
                                    : ListView.builder(
                                        itemCount: coupons.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Column(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Container(child: Text(coupons[index]['code'])),
                                                    InkWell(
                                                      onTap: () {
                                                        showDialogTO(
                                                          context,
                                                          Column(
                                                            children: <Widget>[
                                                              Row(
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.help_outline,
                                                                    color: Color(0xFFDF2126),
                                                                    size: 35,
                                                                  ),
                                                                  Padding(padding: EdgeInsets.only(right: 10)),
                                                                  Expanded(
                                                                    child: Text(
                                                                      'Marca: ${coupons[index]['brand']}\nMonto: ${coupons[index]['youget']}\nTerminos y Condiciones\n${coupons[index]['tc']}',
                                                                      textAlign: TextAlign.center,
                                                                      textScaleFactor: 1.0,
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontFamily: 'Proxima Nova',
                                                                        decoration: TextDecoration.none,
                                                                        fontWeight: FontWeight.w500,
                                                                        fontSize: 15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      child: Icon(Icons.help_outline),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Divider(),
                                            ],
                                          );
                                        },
                                      ),
                              ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
