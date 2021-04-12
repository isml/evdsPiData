import 'package:evdspidata/models/paraBirim.dart';
import 'package:evdspidata/models/vtKurlar.dart';
import 'package:evdspidata/utilities.dart';
import 'package:flutter/material.dart';

class AlSatHesap extends StatefulWidget {
  List<ParaBirim> paraBirimler;
  List<VtKurlar> vtKurlar;
  AlSatHesap({this.paraBirimler, this.vtKurlar});
  @override
  _AlSatHesapState createState() => _AlSatHesapState();
}

class _AlSatHesapState extends State<AlSatHesap> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  List<String> spinnerItems = ['USD', 'EUR', 'CHF', 'GBP', 'JPY'];
  double tutar, tutarSat, kurAl, kurSat;
  String dropdownValue = "USD";
  bool alKontrol = false, satKontrol = false;
  Utilities uti = Utilities();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Alış-Satış Hesapmala",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: uti.themeColor),
        ),
        elevation: 15,
      ),
      body: _bodyWidget(screenSize),
    );
  }

  _bodyWidget(Size screenSize) {
    return Stack(
      children: [
        Container(
          height: screenSize.height,
          width: screenSize.width,
          decoration: BoxDecoration(gradient: uti.themeColor),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(width: 2, color: Colors.amber[100])),
                      elevation: 4,
                      child: Container(
                          width: screenSize.width / 1.1,
                          height: screenSize.height / 2.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 2),
                              gradient: uti.kurCardThemeColor),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Alış Hesaplama",
                                  style: TextStyle(
                                      fontSize:30,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              _dropdownWidget(),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 250,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: new InputDecoration(
                                            labelText: "Lütfen Miktar Giriniz",
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            fillColor: Colors.white,

                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(15.0),
                                              borderSide: new BorderSide(),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          onSaved: (var value) {
                                            tutar = double.tryParse(value);
                                            print(tutar.toString());
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(
                                              kurAl.toString() + "bu kısma bak ");
                                          if (_formKey.currentState.validate()) {
                                            _formKey.currentState.save();
                                            print("denemeee");
                                            //boolean true yapılacak ve aşağı kısımda çar fiyat görünecek
                                            setState(() {
                                              alKontrol = true;
                                              if (kurAl == null ||
                                                  kurSat == null) {
                                                kurAl = double.parse(
                                                    widget.vtKurlar[0].usd);
                                                kurSat = double.parse(
                                                    widget.vtKurlar[1].usd);
                                              }
                                            });
                                          }
                                        },
                                        child: Text('Hesapla'),
                                      ),
                                    ),
                                    alKontrol == true
                                        ? Text("Tutar : " +
                                            (tutar * kurAl).toString() +
                                            " ₺",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w900),)
                                        : Text("")
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(width: 2, color: Colors.purple[100])),
                      elevation: 4,
                      child: Container(
                          width: screenSize.width / 1.1,
                          height: screenSize.height / 2.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(width: 2),
                              gradient: uti.homeCardThemeColor),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Satış Hesaplama",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              _dropdownWidget(),
                              Form(
                                key: _formKey2,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 250,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: new InputDecoration(
                                            labelText: "Lütfen Miktar Giriniz",
                                            labelStyle:
                                                TextStyle(color: Colors.white),
                                            fillColor: Colors.white,

                                            border: new OutlineInputBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(15.0),
                                              borderSide: new BorderSide(),
                                            ),
                                            //fillColor: Colors.green
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          onSaved: (var value) {
                                            tutarSat = double.tryParse(value);
                                            print(tutar.toString());
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(
                                              kurAl.toString() + "bu kısma bak ");
                                          if (_formKey2.currentState.validate()) {
                                            _formKey2.currentState.save();
                                            print("denemeee");
                                            //boolean true yapılacak ve aşağı kısımda çar fiyat görünecek
                                            setState(() {
                                              satKontrol = true;
                                              if (kurAl == null ||
                                                  kurSat == null) {
                                                kurAl = double.parse(
                                                    widget.vtKurlar[0].usd);
                                                kurSat = double.parse(
                                                    widget.vtKurlar[1].usd);
                                              }
                                              print(kurAl.toString() +
                                                  "kural " +
                                                  kurSat.toString() +
                                                  "kursat");
                                            });
                                          }
                                        },
                                        child: Text('Hesapla'),
                                      ),
                                    ),
                                    satKontrol == true
                                        ? Text("Tutar : " +
                                            (tutarSat * kurSat).toString() +
                                            " ₺",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w900))
                                        : Text("")
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _dropdownWidget() {
    //kurAl=double.parse( widget.vtKurlar[0].usd);
    //kurSat=double.parse( widget.vtKurlar[1].usd);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Kur Birimi',
            labelStyle: Theme.of(context)
                .primaryTextTheme
                .caption
                .copyWith(color: Colors.white),
            border: const OutlineInputBorder(),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              isDense: true, // Reduces the dropdowns height by +/- 50%
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              style: TextStyle(color: Colors.red, fontSize: 18),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String data) {
                setState(() {
                  dropdownValue = data;
                  print(dropdownValue);
                  switch (dropdownValue) {
                    case "USD":
                      {
                        kurAl = double.parse(widget.vtKurlar[0].usd);
                        kurSat = double.parse(widget.vtKurlar[1].usd);
                      }
                      break;
                    case "EUR":
                      {
                        kurAl = double.parse(widget.vtKurlar[0].eur);
                        kurSat = double.parse(widget.vtKurlar[1].eur);
                      }
                      break;
                    case "CHF":
                      {
                        kurAl = double.parse(widget.vtKurlar[0].chf);
                        kurSat = double.parse(widget.vtKurlar[1].chf);
                      }
                      break;
                    case "GBP":
                      {
                        kurAl = double.parse(widget.vtKurlar[0].gbp);
                        kurSat = double.parse(widget.vtKurlar[1].gbp);
                      }
                      break;
                    default:
                      {
                        print("girdii");
                        kurAl = double.parse(widget.vtKurlar[0].jpy);
                        kurSat = double.parse(widget.vtKurlar[1].jpy);
                        print(kurAl.toString());
                      }
                      break;
                  }
                  print(kurAl.toString() + "bu kısma bak ");
                });
              },
              items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
