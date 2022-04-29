class ProfileAcMember {
  bool ok;
  Showprofileactivitimg showprofileactivitimg;

  ProfileAcMember({this.ok, this.showprofileactivitimg});

  ProfileAcMember.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    showprofileactivitimg = json['showprofileactivitimg'] != null
        ? new Showprofileactivitimg.fromJson(json['showprofileactivitimg'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.showprofileactivitimg != null) {
      data['showprofileactivitimg'] = this.showprofileactivitimg.toJson();
    }
    return data;
  }
}

class Showprofileactivitimg {
  int imacId;
  int acId;
  String imacImg;

  Showprofileactivitimg({this.imacId, this.acId, this.imacImg});

  Showprofileactivitimg.fromJson(Map<String, dynamic> json) {
    imacId = json['imac_id'];
    acId = json['ac_id'];
    imacImg = json['imac_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imac_id'] = this.imacId;
    data['ac_id'] = this.acId;
    data['imac_img'] = this.imacImg;
    return data;
  }
}