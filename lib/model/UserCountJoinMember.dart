class UserCountJoinMember {
  CountJoinUser countJoinUser;

  UserCountJoinMember({this.countJoinUser});

  UserCountJoinMember.fromJson(Map<String, dynamic> json) {
    countJoinUser = json['countJoinUser'] != null
        ? new CountJoinUser.fromJson(json['countJoinUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countJoinUser != null) {
      data['countJoinUser'] = this.countJoinUser.toJson();
    }
    return data;
  }
}

class CountJoinUser {
  int countJoinUser;

  CountJoinUser({this.countJoinUser});

  CountJoinUser.fromJson(Map<String, dynamic> json) {
    countJoinUser = json['countJoinUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countJoinUser'] = this.countJoinUser;
    return data;
  }
}