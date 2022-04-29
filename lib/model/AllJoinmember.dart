class AllJoinmember {
  bool ok;
  List<Showuseractivityjoinall> showuseractivityjoinall;

  AllJoinmember({this.ok, this.showuseractivityjoinall});

  AllJoinmember.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['showuseractivityjoinall'] != null) {
      showuseractivityjoinall = new List<Showuseractivityjoinall>();
      json['showuseractivityjoinall'].forEach((v) {
        showuseractivityjoinall.add(new Showuseractivityjoinall.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.showuseractivityjoinall != null) {
      data['showuseractivityjoinall'] =
          this.showuseractivityjoinall.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Showuseractivityjoinall {
  int jId;
  int uId;
  int acId;
  String joTime;
  String uUser;
  String uPass;
  String uName;
  String uLname;
  String uOld;
  String uEmail;
  String uTel;
  int iuId;
  String iuImg;

  Showuseractivityjoinall(
      {this.jId,
      this.uId,
      this.acId,
      this.joTime,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLname,
      this.uOld,
      this.uEmail,
      this.uTel,
      this.iuId,
      this.iuImg});

  Showuseractivityjoinall.fromJson(Map<String, dynamic> json) {
    jId = json['j_id'];
    uId = json['u_id'];
    acId = json['ac_id'];
    joTime = json['jo_time'];
    uUser = json['u_user'];
    uPass = json['u_pass'];
    uName = json['u_name'];
    uLname = json['u_lname'];
    uOld = json['u_old'];
    uEmail = json['u_email'];
    uTel = json['u_tel'];
    iuId = json['iu_id'];
    iuImg = json['iu_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['j_id'] = this.jId;
    data['u_id'] = this.uId;
    data['ac_id'] = this.acId;
    data['jo_time'] = this.joTime;
    data['u_user'] = this.uUser;
    data['u_pass'] = this.uPass;
    data['u_name'] = this.uName;
    data['u_lname'] = this.uLname;
    data['u_old'] = this.uOld;
    data['u_email'] = this.uEmail;
    data['u_tel'] = this.uTel;
    data['iu_id'] = this.iuId;
    data['iu_img'] = this.iuImg;
    return data;
  }
}