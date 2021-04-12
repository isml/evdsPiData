import 'package:evdspidata/db/db.dart';
import 'package:evdspidata/models/paraBirim.dart';
import 'package:evdspidata/services/apiCallServices.dart';
import 'package:evdspidata/utilities.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Graphic extends StatefulWidget {
  @override
  GraphicState createState() => GraphicState();
}

class GraphicState extends State<Graphic> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false,
      basTarihKontrol = false,
      sonTarihKontrol = false,
      sayfaWidgetKontrol = false,
      kontrol = false;

  DateTime basTarih;
  DateTime sonTarih;

  List<ParaBirim> paraBirimler;
  List<Map<dynamic, dynamic>> kurlarAl;
  List<Map<dynamic, dynamic>> kurlarSat;

  List<FlSpot> spotsKur;
  List<double> kurValuesAl = [];
  List<double> kurValuesSat = [];
  Db db = Db();
  List<String> spinnerItems = ['USD', 'EUR', 'CHF', 'GBP', 'JPY'];
  String birim = "USD";
  String dropdownValue = "USD";
  ApiCall apiCall = ApiCall();
  Utilities uti = Utilities();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Grafiksel Analiz",
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

  widgetCenter(String type) {
    return Center(
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.70,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  color: Color(0xff232d37)),
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 18.0, left: 12.0, top: 24, bottom: 12),
                child: LineChart(
                  mainData(type),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData mainData(String type) {
    List<double> typeList;
    if (type == "A") {
      typeList = kurValuesAl;
    } else {
      typeList = kurValuesSat;
    }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 13),
          getTitles: (value) {
            if (value.toInt() == 0) {
              List<String> basTarihList =
                  basTarih.toString().split(" ")[0].split("-");
              return basTarihList[2] +
                  "/ \n" +
                  basTarihList[1] +
                  "/ \n" +
                  basTarihList[0];
            } else if (value.toInt() == spotsKur.length - 1) {
              List<String> sonTarihList =
                  sonTarih.toString().split(" ")[0].split("-");
              return sonTarihList[2] +
                  "/ \n" +
                  sonTarihList[1] +
                  "/ \n" +
                  sonTarihList[0];
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            print(value.toString() + "bu kısma bakacaksın alooo");

            if (value.toInt() == 0) {
              return "0";
            } else {
              if (value.toInt() == typeList[typeList.length - 1].toInt()) {
                //en üstte olacak değer
                return typeList[typeList.length - 1].toString();
              } else {
                return " ";
              }
            }
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: typeList.length.toDouble() - 1,
      minY: 0,
      maxY: typeList[typeList.length - 1].toInt()+1.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spotsKur,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  _bodyWidget(screenSize) {
    return sayfaWidgetKontrol == false
        ? Stack(
            children: [
              Container(
                height: screenSize.height,
                width: screenSize.width,
                decoration: BoxDecoration(gradient: uti.themeColor),
              ),
              Center(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _dropdownWidget(),
                    kontrol == true
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(
                                          width: 2, color: Colors.cyan[100])),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(width: 2),
                                        gradient: uti.homeCardThemeColorLight),
                                    width: screenSize.width / 2.2,
                                    height: screenSize.height / 9,
                                    child: InkWell(
                                        onTap: () async {
                                          DateTime _dateTime = DateTime.now();
                                          await showDatePicker(
                                                  context: context,
                                                  initialDate: _dateTime,
                                                  firstDate: DateTime(2015),
                                                  lastDate: DateTime(
                                                      _dateTime.year,
                                                      _dateTime.month,
                                                      _dateTime.day))
                                              .then((date) {
                                            setState(() {
                                              print(date.toString());

                                              basTarih = date;
                                              basTarihKontrol = true;
                                            });
                                          });
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              "Başlangıç Tarihi Seçiniz",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        )),
                                  ),
                                ),
                                basTarihKontrol == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: basTarih == null
                                            ? Text("Tarih seçmediniz",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey[200]))
                                            : Text(
                                                basTarih
                                                    .toString()
                                                    .split(" ")[0],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey[200]),
                                              ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(""),
                                      )
                              ],
                            ),
                          )
                        : Text(""),
                    basTarih != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: BorderSide(
                                          width: 2, color: Colors.purple[200])),
                                  elevation: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(width: 2),
                                        gradient: uti.homeCardThemeColor),
                                    width: screenSize.width / 2.2,
                                    height: screenSize.height / 9,
                                    child: InkWell(
                                        onTap: () async {
                                          DateTime _dateTime = DateTime.now();
                                          await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime(
                                                      basTarih.year,
                                                      basTarih.month,
                                                      basTarih.day + 1),
                                                  firstDate: DateTime(
                                                      basTarih.year,
                                                      basTarih.month,
                                                      basTarih.day + 1),
                                                  lastDate: DateTime(
                                                      _dateTime.year,
                                                      _dateTime.month,
                                                      _dateTime.day))
                                              .then((date) {
                                            setState(() {
                                              print(date.toString());

                                              sonTarih = date;
                                              sonTarihKontrol = true;
                                            });
                                          });
                                        },
                                        child: Center(
                                            child: Text(
                                          "Bitiş Tarihini Seçiniz",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800),
                                        ))),
                                  ),
                                ),
                                sonTarihKontrol == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: sonTarih == null
                                            ? Text("Tarih seçmediniz",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey[200]))
                                            : Text(
                                                sonTarih
                                                    .toString()
                                                    .split(" ")[0],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.grey[200]),
                                              ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(""),
                                      )
                              ],
                            ),
                          )
                        : Text(""),
                    sonTarih != null
                        ? Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                    width: 2, color: Colors.lightGreen[200])),
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(width: 2),
                                  gradient: uti.graphicSeeColor),
                              width: screenSize.width / 2.2,
                              height: screenSize.height / 9,
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      sayfaWidgetKontrol = true;
                                    });
                                  },
                                  child: Center(
                                      child: Text(
                                    "Grafiği Gör",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ))),
                            ),
                          )
                        : Text("")
                  ],
                ),
              )),
            ],
          )
        : _graphicWidgetLoad(birim, screenSize);
  }

  _graphicWidgetLoad(String birim, Size screenSize) {
    return FutureBuilder<Object>(
        future: _loadData(birim),
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
                  SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          basTarih.toString().split(" ")[0] +
                              "/" +
                              sonTarih.toString().split(" ")[0] +
                              "  " +
                              birim.toUpperCase() +
                              "  " +
                              "Alış Grafiği",
                          style:
                              TextStyle(color: Colors.grey[200], fontSize: 20),
                        ),
                        widgetCenter("A"),
                        Text(
                          basTarih.toString().split(" ")[0] +
                              "/" +
                              sonTarih.toString().split(" ")[0] +
                              "  " +
                              birim.toUpperCase() +
                              "  " +
                              "Satış Grafiği",
                          style:
                              TextStyle(color: Colors.grey[200], fontSize: 20),
                        ),
                        widgetCenter("S")
                      ],
                    ),
                  ),
                ],
              );
            }
          }
        });
  }

  _loadData(String birim) async {
    birim.toUpperCase();
    kurValuesAl.clear();
    kurValuesSat.clear();
    List<String> basTarihList = basTarih.toString().split(" ")[0].split("-");
    List<String> sonTarihList = sonTarih.toString().split(" ")[0].split("-");
    paraBirimler = await db.getParaBirim();

    kurlarAl =
        await apiCall.getApiKurlarTarihAralik("A", basTarihList, sonTarihList);
    print("kurlar al ın hemen altı");

    print(kurlarAl);
    for (var i = 0; i < kurlarAl.length; i++) {
      if (kurlarAl[i]["TP_DK_${birim}_A"].toString() == "null") {
        if (kurlarAl[i - 1]["TP_DK_${birim}_A"].toString() != "null") {
          kurlarAl[i] = kurlarAl[i - 1];
        } else {
          kurlarAl[i] = kurlarAl[i + 1];
        }
      }
    }
    for (int i = 0; i < kurlarAl.length; i++) {
      print("2.for");
      print(kurlarAl[i]["TP_DK_${birim}_A"].toString());
      double kur = double.parse(kurlarAl[i]["TP_DK_${birim}_A"].toString());
      print(kur.toString());
      kurValuesAl.add(kur);
      //print(kurValuesAl);

      //kurValues.add(den);
      // spotsKur.add(_spotWidget(double.tryParse(i.toString()),
      //  double.tryParse(kurlarAl[i]["TP_DK_USD_A"].toString() )));
    }
    kurValuesAl.sort();

    int j = -1;
    spotsKur = kurValuesAl.asMap().entries.map((e) {
      j++;
      return FlSpot(j.toDouble(), e.value);
    }).toList();
    print(spotsKur);
    kurlarSat =
        await apiCall.getApiKurlarTarihAralik("S", basTarihList, sonTarihList);

    for (var i = 0; i < kurlarSat.length; i++) {
      if (kurlarSat[i]["TP_DK_${birim}_S"].toString() == "null") {
        if (kurlarSat[i - 1]["TP_DK_${birim}_S"].toString() != "null") {
          kurlarSat[i] = kurlarSat[i - 1];
        } else {
          kurlarSat[i] = kurlarSat[i + 1];
        }
      }
    }
    for (int i = 0; i < kurlarSat.length; i++) {
      print("2.for");
      print(kurlarSat[i]["TP_DK_${birim}_S"].toString());
      double kur = double.parse(kurlarSat[i]["TP_DK_${birim}_S"].toString());
      print(kur.toString());
      kurValuesSat.add(kur);
      //print(kurValuesAl);

      //kurValues.add(den);
      // spotsKur.add(_spotWidget(double.tryParse(i.toString()),
      //  double.tryParse(kurlarAl[i]["TP_DK_USD_A"].toString() )));
    }
    kurValuesSat.sort();

    int k = -1;
    spotsKur = kurValuesSat.asMap().entries.map((e) {
      k++;
      return FlSpot(k.toDouble(), e.value);
    }).toList();
  }

  _dropdownWidget() {
   
    return Padding(
      padding: const EdgeInsets.all(18.0),
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

              style: TextStyle(color: Colors.red, fontSize: 25),

              onChanged: (String data) {
                setState(() {
                  dropdownValue = data;
                  birim = data;
                  kontrol = true;
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
