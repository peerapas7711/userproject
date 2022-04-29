class CommentMember {
  bool ok;
  List<Showcomment> showcomment;

  CommentMember({this.ok, this.showcomment});

  CommentMember.fromJson(Map<String, dynamic> json) {
    ok = json['ok'];
    if (json['showcomment'] != null) {
      showcomment = new List<Showcomment>();
      json['showcomment'].forEach((v) {
        showcomment.add(new Showcomment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ok'] = this.ok;
    if (this.showcomment != null) {
      data['showcomment'] = this.showcomment?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Showcomment {
  int comId;
  int acId;
  int uId;
  String comMessage;
  String comDate;
  String comTime;
  String uUser;
  String uPass;
  String uName;
  String uLname;
  String uOld;
  String uEmail;
  String uTel;
  // String uImg;
  int iuId;
  String iuImg;

  Showcomment(
      {this.comId,
      this.acId,
      this.uId,
      this.comMessage,
      this.comDate,
      this.comTime,
      this.uUser,
      this.uPass,
      this.uName,
      this.uLname,
      this.uOld,
      this.uEmail,
      this.uTel,
      // this.uImg,
      this.iuId,
      this.iuImg});

  Showcomment.fromJson(Map<String, dynamic> json) {
    comId = json['com_id'];
    acId = json['ac_id'];
    uId = json['u_id'];
    comMessage = json['com_message'];
    comDate = json['com_date'];
    comTime = json['com_time'];
    uUser = json['u_user'];
    uPass = json['u_pass'];
    uName = json['u_name'];
    uLname = json['u_lname'];
    uOld = json['u_old'];
    uEmail = json['u_email'];
    uTel = json['u_tel'];
    // uImg = json['u_img'];
    iuId = json['iu_id'];
    iuImg = json['iu_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['com_id'] = this.comId;
    data['ac_id'] = this.acId;
    data['u_id'] = this.uId;
    data['com_message'] = this.comMessage;
    data['com_date'] = this.comDate;
    data['com_time'] = this.comTime;
    data['u_user'] = this.uUser;
    data['u_pass'] = this.uPass;
    data['u_name'] = this.uName;
    data['u_lname'] = this.uLname;
    data['u_old'] = this.uOld;
    data['u_email'] = this.uEmail;
    data['u_tel'] = this.uTel;
    // data['u_img'] = this.uImg;
    data['iu_id'] = this.iuId;
    data['iu_img'] = this.iuImg;
    return data;
  }
}