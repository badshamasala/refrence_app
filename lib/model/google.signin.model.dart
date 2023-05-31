class GoogleSignInModel {
  String? displayName;
  String? email;
  String? photoUrl;
  String? id;
  String? token;

  GoogleSignInModel(
      {this.displayName,
      this.email,
      this.photoUrl,
      this.id,
      this.token});

  GoogleSignInModel.fromJson(Map<String, dynamic> map)
      : this(
          displayName: map['displayName'],
          email: map['email'],
          photoUrl: map['photoUrl'],
          id: map['id'],
          token: map['token'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['photoUrl'] = photoUrl;
    data['id'] = id;
    data['token'] = token;
    return data;
  }
}

/* {
    "displayName": "Mahesh Karande",
    "email": "maheshkarande2009@gmail.com",
    "id": "101968539793636185988",
    "photoUrl": "https://lh3.googleusercontent.com/a-/AOh14Ghgv9PiFkPmhOnR8kl_yfxiLmU0h1cDfMkWxc8SoQ=s96-c",
    "serverAuthCode": "4/0AX4XfWjqdc1MhTdmymJZL5gbi-oLDH6D_HjlvX4X1D18iq8C16nv4MQuKluLiH07QS8asw"
} */