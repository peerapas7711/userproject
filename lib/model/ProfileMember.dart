class ProfileMember {
  bool ok;
  Showprofileimg showprofileimg;

  ProfileMember({this.ok, this.showprofileimg});

  ProfileMember.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    showprofileimg = json['showprofileimg'] != null
        ? new Showprofileimg.fromJson(json['showprofileimg'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.showprofileimg != null) {
      data['showprofileimg'] = this.showprofileimg.toJson();
    }
    return data;
  }
}

class Showprofileimg {
  int iuId;
  int uId;
  String iuImg;

  Showprofileimg({this.iuId, this.uId, this.iuImg});

  Showprofileimg.fromJson(Map<String, dynamic> json) {
    iuId = json['iu_id'];
    uId = json['u_id'];
    iuImg = json['iu_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iu_id'] = this.iuId;
    data['u_id'] = this.uId;
    data['iu_img'] = this.iuImg;
    return data;
  }
}