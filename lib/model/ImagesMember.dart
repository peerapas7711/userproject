class ImagesMembers {
  bool ok;
  List<Showactivitimg> showactivitimg;

  ImagesMembers({this.ok, this.showactivitimg});

  ImagesMembers.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['showactivitimg'] != null) {
      showactivitimg = new List<Showactivitimg>();
      json['showactivitimg'].forEach((v) {
        showactivitimg.add(new Showactivitimg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.showactivitimg != null) {
      data['showactivitimg'] =
          this.showactivitimg.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Showactivitimg {
  int imId;
  int acId;
  String imImg;

  Showactivitimg({this.imId, this.acId, this.imImg});

  Showactivitimg.fromJson(Map<String, dynamic> json) {
    imId = json['im_id'];
    acId = json['ac_id'];
    imImg = json['im_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['im_id'] = this.imId;
    data['ac_id'] = this.acId;
    data['im_img'] = this.imImg;
    return data;
  }
}