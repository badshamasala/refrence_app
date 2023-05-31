class SocialUserModel {
  String? displayName;
  String? email;
  String? photoUrl;
  String? signInVia;
  String? gmailToken;
  String? facebookToken;

  SocialUserModel(
      {this.displayName,
      this.email,
      this.photoUrl,
      this.signInVia,
      this.gmailToken,
      this.facebookToken});

  SocialUserModel.fromJson(Map<String, dynamic> map)
      : this(
          displayName: map['displayName'],
          email: map['email'],
          photoUrl: map['photoUrl'],
          signInVia: map['signInVia'],
          gmailToken: map['gmailToken'],
          facebookToken: map['token'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayName'] = displayName;
    data['photoUrl'] = photoUrl;
    data['signInVia'] = signInVia;
    data['gmailToken'] = gmailToken;
    data['facebookToken'] = facebookToken;
    return data;
  }
}
