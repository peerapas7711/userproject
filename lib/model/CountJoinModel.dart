class CountJoinModel {
  CountJoin countJoin;

  CountJoinModel({this.countJoin});

  CountJoinModel.fromJson(Map<String, dynamic> json) {
    countJoin = json['countJoin'] != null
        ? new CountJoin.fromJson(json['countJoin'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countJoin != null) {
      data['countJoin'] = this.countJoin.toJson();
    }
    return data;
  }
}

class CountJoin {
  int countJoin;

  CountJoin({this.countJoin});

  CountJoin.fromJson(Map<String, dynamic> json) {
    countJoin = json['countJoin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countJoin'] = this.countJoin;
    return data;
  }
}