import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  //properties
  String selectedCurrency = currenciesList[0];
  Map<String, double> values = {};

  //functions
  Widget androidDropdownMenu() {
    List<DropdownMenuItem> items = [];
    for (var item in currenciesList) {
      DropdownMenuItem itemValue = DropdownMenuItem(
        child: Text(item),
        value: item,
      );
      items.add(itemValue);
    }

    return DropdownButton(
      value: selectedCurrency,
      items: items,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
        });
        getRate(selectedCurrency);
      },
    );
  }

  Widget iosPicker() {
    List<Text> items = [];
    for (var item in currenciesList) {
      Text itemValue = Text(item);
      items.add(itemValue);
    }
    return CupertinoPicker(
        itemExtent: 30,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            getRate(selectedCurrency);
          });
        },
        children: items);
  }

  getRate(String assetIdQuote) async {
    try {
      for (var item in cryptoList) {
        NetworkHandler networkHandler = NetworkHandler(
            "https://rest.coinapi.io/v1/exchangerate/$item/$assetIdQuote?apikey=$apiKey");
        var recievedData = await networkHandler.getData();
        double newRate = recievedData['rate'];
        setState(() {
          values[item] = newRate;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List<Widget> viewWidget() {
    List<Widget> widgetList = [];

    values.forEach((key, value) {
      Widget w = Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
            child: Text(
              '1 $key = ${value.toInt()} $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
      widgetList.add(w);
    });

    return widgetList;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getRate(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: viewWidget(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? androidDropdownMenu() : iosPicker(),
          ),
        ],
      ),
    );
  }
}
