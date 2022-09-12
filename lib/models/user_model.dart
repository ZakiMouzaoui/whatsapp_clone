class UserModel{
  final String uid;
  final String name;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupIds;


  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupIds
  });

  Map<String, dynamic> toJson(){
    return {
      "uid": uid,
      "name": name,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "groupIds": groupIds,
      "isOnline": isOnline
    };
  }

  static UserModel fromJson(Map<String, dynamic> json){
    return UserModel(
        uid: json["uid"] ?? "",
        name: json["name"] ?? "",
        profilePic: json["profilePic"] ?? "",
        isOnline: json["isOnline"] ?? false,
        phoneNumber: json["phoneNumber"] ?? "",
        groupIds: List<String>.from(json["groupÎds"] ?? [])
    );
  }
}