import 'package:evdspidata/db/db.dart';
import 'package:evdspidata/models/paraBirim.dart';
import 'package:evdspidata/utilities.dart';
import 'package:flutter/material.dart';

class AddParaBirim extends StatefulWidget {
  @override
  _AddParaBirimState createState() => _AddParaBirimState();
}

class _AddParaBirimState extends State<AddParaBirim> {
  final _formKey = GlobalKey<FormState>();
  List<String> spinnerItems = ['USD', 'EUR', 'CHF', 'GBP', 'JPY'];
  bool kontrol = true;
  String birim = "USD", ulke, aciklama, dropdownValue = "USD";
  List<ParaBirim> paraBirimler;
  Db db = Db();
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
          "Para Birimlerim",
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
          child: Column(
            children: [
              FutureBuilder<Object>(
                  future: _getBirimler(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Stack(
                        children: [
                          Container(
                            height: screenSize.height,
                            width: screenSize.width,
                            decoration: BoxDecoration(gradient: uti.themeColor),
                          ),
                          Center(child: uti.spinkit()),
                        ],
                      );
                    } else {
                      if (snapshot.hasError) {
                        return Stack(
                          children: [
                            Container(
                              height: screenSize.height,
                              width: screenSize.width,
                              decoration:
                                  BoxDecoration(gradient: uti.themeColor),
                            ),
                            Center(
                                child: Text('Bağlantı Hatası',
                                    style: TextStyle(color: Colors.white))),
                          ],
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            itemCount: paraBirimler.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 2,
                                              color: Colors.cyan[100]),
                                          gradient:
                                              uti.homeCardThemeColorLight),
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "assets/images/${paraBirimler[index].birim.toLowerCase()}.png"),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Text(
                                            paraBirimler[index]
                                                .birim
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Text("-",
                                              style: TextStyle(
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Flexible(
                                            child: Text(
                                              paraBirimler[index].ulke,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Text("-",
                                              style: TextStyle(
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Flexible(
                                            child: Text(
                                              paraBirimler[index].aciklama,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.amber),
                                              onPressed: () {
                                                setState(() {
                                                  db.deleteBirim(
                                                      paraBirimler[index].id);
                                                });
                                              })
                                        ],
                                      )),
                                ),
                              );
                            });
                      }
                    }
                  }),
              Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(width: 2, color: Colors.purple[100])),
                  elevation: 4,
                  child: Container(
                    width: screenSize.width / 1.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(width: 2),
                        gradient: uti.homeCardThemeColor),
                    child: _addBirimWidget(),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  _getBirimler() async {
    paraBirimler = await db.getParaBirim();
    //print("asdasdasjkdjsandkad" + paraBirimler.length.toString());
  }

  _dropdownWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
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
              isDense: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              style: TextStyle(color: Colors.red, fontSize: 25),
              onChanged: (String data) {
                setState(() {
                  dropdownValue = data;
                  birim = data;
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

  _addBirimWidget() {
    return Column(
      children: [_dropdownWidget(), _formWidget()],
    );
  }

  _formWidget() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  width: 250,
                  child: TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Ülke Bilgisi Giriniz",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Lütfen Ülke Bilgisi giriniz';
                      }
                      return null;
                    },
                    onSaved: (var value) {
                      ulke = value.toString();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  width: 250,
                  child: TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Açıklama Ekleyiniz",
                      labelStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide(),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Lütfen Açıklama  giriniz';
                      }
                      return null;
                    },
                    onSaved: (var value) {
                      aciklama = value.toString();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side:
                            BorderSide(width: 3, color: Colors.blueGrey[600])),
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 3),
                          color: Colors.green[300]),
                      child: FlatButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            int sonId;
                            _formKey.currentState.save();
                            await db.getParaBirim().then((value) => {
                                  if (value.isEmpty)
                                    {sonId = 1}
                                  else
                                    {
                                      sonId = value.last.id + 1,
                                      //print(value.last.id.toString()+"asdasdasd")
                                    }
                                });
                            ParaBirim paraBirim = ParaBirim(
                                sonId,
                                birim.toString(),
                                ulke.toString(),
                                aciklama.toString());
                            setState(() {
                              for (var item in paraBirimler) {
                                print(item.birim + "-------" + birim);
                                if (item.birim.toUpperCase() ==
                                    birim.toUpperCase()) {
                                  //yeni kayıt yapmayacak
                                  kontrol = false;
                                }
                              }
                              if (kontrol == true) {
                                db.SaveBirim(paraBirim);
                              }
                            });
                          }
                          //print(sonId.toString());
                        },
                        child: Text(
                          'Ekle'.toUpperCase(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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
}
