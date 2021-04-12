import 'package:evdspidata/db/db.dart';
import 'package:evdspidata/models/kurlar.dart';
import 'package:evdspidata/models/paraBirim.dart';
import 'package:evdspidata/models/vtKurlar.dart';
import 'package:evdspidata/screens/addParaBirim.dart';
import 'package:evdspidata/screens/alSatHesap.dart';
import 'package:evdspidata/screens/graphic.dart';
import 'package:evdspidata/services/apiCallServices.dart';
import 'package:evdspidata/utilities.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ParaBirim> paraBirimler;
  List<Map<dynamic, dynamic>> kurlarAl;
  List<Map<dynamic, dynamic>> kurlarSat;
  List<VtKurlar> vtKurlar;
  Db db = Db();
  ApiCall apiCall = ApiCall();
  bool birimKontrol = false;
  Utilities uti = Utilities();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Güncel Kurlar",
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

  _getData() async {
    paraBirimler = await db.getParaBirim();
    vtKurlar = await db.getKurlar();
    if (paraBirimler.isNotEmpty) {
      birimKontrol = true;
    }
    DateTime tarih = DateTime.now();

    List<String> tarihListNow = tarih.toString().split(" ")[0].split("-");

    if (vtKurlar.isEmpty) {
      print("vtKurlar boş");
      _vtKaydet("0");
    } else {
      print("vtKurlar dolu");
    }
    if (vtKurlar.length != 0) {
      List<String> tarihList = vtKurlar[0].tarih.split("-");
      print(tarihList[0] + tarihListNow[2].toString() + tarihList[2]);
      if (tarihList[0] != tarihListNow[2].toString() ||
          tarihList[1] != tarihListNow[1].toString() ||
          tarihList[2] != tarihListNow[0].toString()) {
        _vtKaydet("1");
      }
    }

    // print(kurlar);
  }

  void _vtKaydet(String met) async {
    kurlarAl = await apiCall.getApiKurlar("A", "");
    if (kurlarAl[0]["TP_DK_USD_A"].toString() != "null") {
      vtKurlar.clear();

      for (var i = 0; i < kurlarAl.length; i++) {
        VtKurlar kurAl = VtKurlar(
            i,
            kurlarAl[i]["TP_DK_USD_A"].toString(),
            kurlarAl[i]["TP_DK_EUR_A"].toString(),
            kurlarAl[i]["TP_DK_CHF_A"].toString(),
            kurlarAl[i]["TP_DK_GBP_A"].toString(),
            kurlarAl[i]["TP_DK_JPY_A"].toString(),
            kurlarAl[i]["Tarih"].toString());
        print(kurAl.usd + "alış");
        if (met == "0") {
          db.SaveKurlar(kurAl);
        } else {
          db.updateKurlar(kurAl);
        }
      }
      //SATIŞ KISMINI ÇEKİYORUM
      kurlarSat = await apiCall.getApiKurlar("S", "");

      for (var i = 0; i < kurlarSat.length; i++) {
        VtKurlar kurSat = VtKurlar(
            1,
            kurlarSat[i]["TP_DK_USD_S"].toString(),
            kurlarSat[i]["TP_DK_EUR_S"].toString(),
            kurlarSat[i]["TP_DK_CHF_S"].toString(),
            kurlarSat[i]["TP_DK_GBP_S"].toString(),
            kurlarSat[i]["TP_DK_JPY_S"].toString(),
            kurlarSat[i]["Tarih"].toString());
        print(kurSat.usd + "satış");
        if (met == "0") {
          db.SaveKurlar(kurSat);
        } else {
          db.updateKurlar(kurSat);
        }
      }
    } else if (kurlarAl[0]["TP_DK_USD_A"].toString() == "null" &&
        vtKurlar.isEmpty) {
      // bu kısımda 9 nisan verisini aldırıcaz
      kurlarAl = await apiCall.getApiKurlar("A", "9");
      vtKurlar.clear();

      for (var i = 0; i < kurlarAl.length; i++) {
        VtKurlar kurAl = VtKurlar(
            i,
            kurlarAl[i]["TP_DK_USD_A"].toString(),
            kurlarAl[i]["TP_DK_EUR_A"].toString(),
            kurlarAl[i]["TP_DK_CHF_A"].toString(),
            kurlarAl[i]["TP_DK_GBP_A"].toString(),
            kurlarAl[i]["TP_DK_JPY_A"].toString(),
            kurlarAl[i]["Tarih"].toString());
        print(kurAl.usd + "alış");
        if (met == "0") {
          db.SaveKurlar(kurAl);
        } else {
          db.updateKurlar(kurAl);
        }
      }
      //SATIŞ KISMINI ÇEKİYORUM
      kurlarSat = await apiCall.getApiKurlar("S", "9");

      for (var i = 0; i < kurlarSat.length; i++) {
        VtKurlar kurSat = VtKurlar(
            1,
            kurlarSat[i]["TP_DK_USD_S"].toString(),
            kurlarSat[i]["TP_DK_EUR_S"].toString(),
            kurlarSat[i]["TP_DK_CHF_S"].toString(),
            kurlarSat[i]["TP_DK_GBP_S"].toString(),
            kurlarSat[i]["TP_DK_JPY_S"].toString(),
            kurlarSat[i]["Tarih"].toString());
        print(kurSat.usd + "satış");
        if (met == "0") {
          db.SaveKurlar(kurSat);
        } else {
          db.updateKurlar(kurSat);
        }
      }
    }
  }

  _kurWidget(String birim, Size screenSize) {
    print(vtKurlar[0].usd + "asdsajdjksad" + vtKurlar[1].usd);
    String tutar = "";
    switch (birim.toLowerCase()) {
      case "usd":
        {
          tutar = vtKurlar[0].usd;
        }
        break;
      case "eur":
        {
          tutar = vtKurlar[0].eur;
        }
        break;
      case "chf":
        {
          tutar = vtKurlar[0].chf;
        }
        break;
      case "gbp":
        {
          tutar = vtKurlar[0].gbp;
        }
        break;
      default:
        {
          tutar = vtKurlar[0].jpy;
        }
        break;
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            child: Row(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/images/${birim.toLowerCase()}.png"),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              birim.toUpperCase() + " : ",
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(tutar.toString() + " ₺",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        )),
      ),
    );
  }

  _bodyWidget(Size screenSize) {
    return FutureBuilder<Object>(
        future: _getData(),
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
                    decoration: BoxDecoration(gradient: uti.themeColor),
                  ),
                  Center(
                      child: Text('Bağlantı Hatası',
                          style: TextStyle(color: Colors.white))),
                ],
              );
            } else {
              return Stack(
                children: [
                  Container(
                    height: screenSize.height,
                    width: screenSize.width,
                    decoration: BoxDecoration(gradient: uti.themeColor),
                  ),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: screenSize.height / 1.5,
                          width: screenSize.width,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                birimKontrol == true
                                    ? Material(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            side: BorderSide(
                                                width: 2,
                                                color: Colors.amber[100])),
                                        elevation: 4,
                                        child: Container(
                                          width: screenSize.width / 1.4,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(width: 2),
                                              gradient: uti
                                                  .kurCardThemeColor),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: paraBirimler.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return _kurWidget(
                                                    paraBirimler[index].birim,
                                                    screenSize);
                                              }),
                                        ),
                                      )
                                    : Center(
                                        child: Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Colors.purple[200])),
                                          elevation: 2,
                                          child: Container(
                                            width: screenSize.width / 1.3,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(width: 2),
                                                gradient:
                                                    uti.homeCardThemeColor),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Flexible(
                                                child: Text(
                                                  "Para birimi eklemeniz gerekmektedir. Lütfen para birimi ekle kısmından görmek istediğiniz para birimlerini ekleyiniz",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SafeArea(
                            child: SingleChildScrollView(
                              child: Container(
                                height: screenSize.height / 4,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Colors.purple[200])),
                                          elevation: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(width: 2),
                                                gradient:
                                                    uti.homeCardThemeColor),
                                            width: screenSize.width / 2.2,
                                            height: screenSize.height / 9,
                                            child: InkWell(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.add_circle,
                                                        color: Colors.teal,
                                                        size: 30,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Flexible(
                                                        child: Text(
                                                          "Para Birimi Ekle",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddParaBirim()));
                                              },
                                            ),
                                          ),
                                        ),
                                        Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Colors.cyan[100])),
                                          elevation: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(width: 2),
                                                gradient: uti
                                                    .homeCardThemeColorLight),
                                            width: screenSize.width / 2.2,
                                            height: screenSize.height / 9,
                                            child: InkWell(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.update,
                                                        color:
                                                            Colors.purple[200],
                                                        size: 30,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Flexible(
                                                        child: Text(
                                                          "Kur Bilgilerini Güncelle",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  //kur bilgileri güncelleniyor

                                                  _vtKaydet("1");
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 15.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Colors.cyan[100])),
                                          elevation: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(width: 2),
                                                gradient: uti
                                                    .homeCardThemeColorLight),
                                            width: screenSize.width / 2.2,
                                            height: screenSize.height / 9,
                                            child: InkWell(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.calculate_rounded,
                                                        color:
                                                            Colors.purple[200],
                                                        size: 30,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Flexible(
                                                        child: Text(
                                                          "Alış Satış Hesaplama",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AlSatHesap(
                                                                paraBirimler:
                                                                    paraBirimler,
                                                                vtKurlar:
                                                                    vtKurlar)));
                                              },
                                            ),
                                          ),
                                        ),
                                        Material(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  width: 2,
                                                  color: Colors.purple[200])),
                                          elevation: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(width: 2),
                                                gradient:
                                                    uti.homeCardThemeColor),
                                            width: screenSize.width / 2.2,
                                            height: screenSize.height / 9,
                                            child: InkWell(
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.bar_chart,
                                                        color: Colors.teal,
                                                        size: 30,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Flexible(
                                                        child: Text(
                                                          "Grafiksel Analiz",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Graphic()));
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }
        });
  }
}
