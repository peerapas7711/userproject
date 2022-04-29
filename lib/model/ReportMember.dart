class ReportMember {
  bool ok;
  List<Reportinfo> reportinfo;

  ReportMember({this.ok, this.reportinfo});

  ReportMember.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['reportinfo'] != null) {
      reportinfo = new List<Reportinfo>();
      json['reportinfo'].forEach((v) {
        reportinfo.add(new Reportinfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.reportinfo != null) {
      data['reportinfo'] = this.reportinfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reportinfo {
  int reId;
  int acId;
  String reDetel;

  Reportinfo({this.reId, this.acId, this.reDetel});

  Reportinfo.fromJson(Map<String, dynamic> json) {
    reId = json['re_id'];
    acId = json['ac_id'];
    reDetel = json['re_detel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['re_id'] = this.reId;
    data['ac_id'] = this.acId;
    data['re_detel'] = this.reDetel;
    return data;
  }
}