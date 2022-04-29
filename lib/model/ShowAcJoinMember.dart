class ShowAcJoinMember {
  bool ok;
  List<Showactivityjoin> showactivityjoin;

  ShowAcJoinMember({this.ok, this.showactivityjoin});

  ShowAcJoinMember.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['showactivityjoin'] != null) {
      showactivityjoin = new List<Showactivityjoin>();
      json['showactivityjoin'].forEach((v) {
        showactivityjoin.add(new Showactivityjoin.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.showactivityjoin != null) {
      data['showactivityjoin'] =
          this.showactivityjoin.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Showactivityjoin {
  int jId;
  int uId;
  int acId;
  String joTime;
  String acName;
  String acType;
  String acTime;
  String acDate;
  String acLdate;
  int acNumber;
  String acHome;
  String acSub;
  String acDistrict;
  String acProvince;
  String acDetel;
  double acLa;
  double acLong;
  String uUser;
  String uPass;
  String uName;
  String uLname;
  String uOld;
  String uEmail;
  String uTel;
  int imacId;
  String imacImg;

  Showactivityjoin(
      {this.jId,
      this.uId,
      this.acId,
      this.joTime,
      this.acName,
      this.acType,
      this.acTime,
      this.acDate,
      this.acLdate,
      this.acNumber,
      this.acHome,
      this.acSub,
      this.acDistrict,
      this.acProvince,
      this.acDetel,
      this.acLa,
      this.acLong,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLname,
      this.uOld,
      this.uEmail,
      this.uTel,
      this.imacId,
      this.imacImg
      });

  Showactivityjoin.fromJson(Map<String, dynamic> json) {
    jId = json['j_id'];
    uId = json['u_id'];
    acId = json['ac_id'];
    joTime = json['jo_time'];
    acName = json['ac_name'];
    acType = json['ac_type'];
    acTime = json['ac_time'];
    acDate = json['ac_date'];
    acLdate = json['ac_ldate'];
    acNumber = json['ac_number'];
    acHome = json['ac_home'];
    acSub = json['ac_sub'];
    acDistrict = json['ac_district'];
    acProvince = json['ac_province'];
    acDetel = json['ac_detel'];
    acLa = json['ac_la'];
    acLong = json['ac_long'];
    uUser = json['u_user'];
    uPass = json['u_pass'];
    uName = json['u_name'];
    uLname = json['u_lname'];
    uOld = json['u_old'];
    uEmail = json['u_email'];
    uTel = json['u_tel'];
    imacId = json['imac_id'];
    imacImg = json['imac_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['j_id'] = this.jId;
    data['u_id'] = this.uId;
    data['ac_id'] = this.acId;
    data['jo_time'] = this.joTime;
    data['ac_name'] = this.acName;
    data['ac_type'] = this.acType;
    data['ac_time'] = this.acTime;
    data['ac_date'] = this.acDate;
    data['ac_ldate'] = this.acLdate;
    data['ac_number'] = this.acNumber;
    data['ac_home'] = this.acHome;
    data['ac_sub'] = this.acSub;
    data['ac_district'] = this.acDistrict;
    data['ac_province'] = this.acProvince;
    data['ac_detel'] = this.acDetel;
    data['ac_la'] = this.acLa;
    data['ac_long'] = this.acLong;
    data['u_user'] = this.uUser;
    data['u_pass'] = this.uPass;
    data['u_name'] = this.uName;
    data['u_lname'] = this.uLname;
    data['u_old'] = this.uOld;
    data['u_email'] = this.uEmail;
    data['u_tel'] = this.uTel;
    data['imac_id'] = this.imacId;
    data['imac_img'] = this.imacImg;
    return data;
  }
}