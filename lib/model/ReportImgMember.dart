class ReportImgMember {
  bool ok;
  List<Showreportactivitimg> showreportactivitimg;

  ReportImgMember({this.ok, this.showreportactivitimg});

  ReportImgMember.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['showreportactivitimg'] != null) {
      showreportactivitimg = new List<Showreportactivitimg>();
      json['showreportactivitimg'].forEach((v) {
        showreportactivitimg.add(new Showreportactivitimg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.showreportactivitimg != null) {
      data['showreportactivitimg'] =
          this.showreportactivitimg.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Showreportactivitimg {
  int reimgId;
  int acId;
  String reimgImg;

  Showreportactivitimg({this.reimgId, this.acId, this.reimgImg});

  Showreportactivitimg.fromJson(Map<String, dynamic> json) {
    reimgId = json['reimg_id'];
    acId = json['ac_id'];
    reimgImg = json['reimg_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reimg_id'] = this.reimgId;
    data['ac_id'] = this.acId;
    data['reimg_img'] = this.reimgImg;
    return data;
  }
}