
class Kurlar {
  String usd;
  String eur;
  String chf;
  String gbp;
  String jpy;
  String tarih;
  String unixtime;

  Kurlar({
    this.usd,
    this.eur,
    this.chf,
    this.gbp,
    this.jpy,
    this.tarih,
    this.unixtime,
  });

  factory Kurlar.fromJson(Map<String, dynamic> json) {
    return Kurlar(
        usd: json['TP_DK_USD_A'].toString(),
        eur: json['TP_DK_EUR_A'].toString(),
        chf: json['TP_DK_CHF_A'].toString(),
        gbp: json['TP_DK_GBP_A'].toString(),
        jpy: json['TP_DK_JPY_A'].toString(),
        tarih: json['Tarih'],
        );
  }
}