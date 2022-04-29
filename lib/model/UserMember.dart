class UsersMember {
  bool ok;
  Info info;

  UsersMember({this.ok, this.info});

  UsersMember.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    return data;
  }
}

class Info {
  int uId;
  String uUser;
  String uPass;
  String uName;
  String uLname;
  String uOld;
  String uEmail;
  String uTel;
  // String uImg;

  Info(
      {this.uId,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLname,
      this.uOld,
      this.uEmail,
      this.uTel,
      // this.uImg
      });

  Info.fromJson(Map<String, dynamic> json) {
    uId = json['u_id'];
    uUser = json['u_user'];
    uPass = json['u_pass'];
    uName = json['u_name'];
    uLname = json['u_lname'];
    uOld = json['u_old'];
    uEmail = json['u_email'];
    uTel = json['u_tel'];
    // uImg = json['u_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['u_id'] = this.uId;
    data['u_user'] = this.uUser;
    data['u_pass'] = this.uPass;
    data['u_name'] = this.uName;
    data['u_lname'] = this.uLname;
    data['u_old'] = this.uOld;
    data['u_email'] = this.uEmail;
    data['u_tel'] = this.uTel;
    // data['u_img'] = this.uImg;
    return data;
  }
}