import 'dart:convert';

import 'package:evdspidata/models/kurlar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiCall {
  List<Kurlar> kurlar = List<Kurlar>();
  List<Map<dynamic, dynamic>> kurlarMapList = List<Map<dynamic, dynamic>>();
  

  Future<List<Map<dynamic, dynamic>>> getApiKurlar(String type,String dokuz) async {
    DateTime tarih = DateTime.now();
    List<String> tarihList = tarih.toString().split(" ")[0].split("-");

    kurlarMapList.clear();
    kurlar.clear();
    var response;
    if (dokuz=="9") {
      response = await http.get(Uri.encodeFull(
        "https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.USD.$type-TP.DK.EUR.$type-TP.DK.CHF.$type-TP.DK.GBP.$type-TP.DK.JPY.$type&startDate=09-04-2021&endDate=09-04-2021&type=json&key=tc0zlKJARg"));
    } else {
      response = await http.get(Uri.encodeFull(
        "https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.USD.$type-TP.DK.EUR.$type-TP.DK.CHF.$type-TP.DK.GBP.$type-TP.DK.JPY.$type&startDate=${tarihList[2]}-${tarihList[1]}-${tarihList[0]}&endDate=${tarihList[2]}-${tarihList[1]}-${tarihList[0]}&type=json&key=tc0zlKJARg"));
    }
    

    var list = json.decode(response.body);
    kurlar.add(Kurlar.fromJson(json.decode(response.body)));

    //var listresult = list["result"];
    var listresult = list["items"];
    for (var i = 0; i < listresult.length; i++) {
      kurlarMapList.add(listresult[i]);
    }

    return kurlarMapList;
  }

  ////////////////////
  Future<List<Map<dynamic, dynamic>>> getApiKurlarTarihAralik(
      String type, List<String> basTarih, List<String> sonTarih) async {
    List<Map<dynamic, dynamic>> kurlarMapList = List<Map<dynamic, dynamic>>();
    kurlar.clear();
    var response;

    response = await http.get(Uri.encodeFull(
        "https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.USD.$type-TP.DK.EUR.$type-TP.DK.CHF.$type-TP.DK.GBP.$type-TP.DK.JPY.$type&startDate=${basTarih[2]}-${basTarih[1]}-${basTarih[0]}&endDate=${sonTarih[2]}-${sonTarih[1]}-${sonTarih[0]}&type=json&key=tc0zlKJARg"));

    var list = await json.decode(response.body);
    kurlar.add(Kurlar.fromJson(json.decode(response.body)));

    var listresult = await list["items"];
    for (var i = 0; i < listresult.length; i++) {
      kurlarMapList.add(listresult[i]);
    }

    return kurlarMapList;
  }
}
