class GroupModel {
  String groupId;
  String name;
  String groupPic;
  String adminId;
  List<dynamic> members;
  String lastMessage;
  DateTime createdAt;

  GroupModel(
      {required this.groupId,
      required this.name,
      required this.groupPic,
      required this.adminId,
      required this.members,
      required this.createdAt,
      required this.lastMessage});

  static GroupModel fromJson(Map<String, dynamic> json) {
    return GroupModel(
        groupId: json["groupId"],
        name: json["name"],
        groupPic: json["groupPic"],
        adminId: json["adminId"],
        members: json["members"],
        createdAt: json["createdAt"],
        lastMessage: json["lastMessage"]);
  }

  Map<String, dynamic> toJson(){
    return {
      "groupId": groupId,
      "name": name,
      "groupPic": groupPic,
      "adminId": adminId,
      "members": members,
      "createdAt": createdAt,
      "lastMessage": lastMessage
    };
  }
}
