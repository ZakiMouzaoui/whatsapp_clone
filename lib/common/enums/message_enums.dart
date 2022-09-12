enum MessageEnum{
  text("text"),
  image("image"),
  audio("audio"),
  video("video"),
  gif("gif");

  final String type;

  const MessageEnum(this.type);
}

extension StringToEnum on String {
  MessageEnum toEnum(){
    switch(this){
      case "text":
        return MessageEnum.text;
      case "video":
        return MessageEnum.video;
      case "audio":
        return MessageEnum.audio;
      case "image":
        return MessageEnum.image;
      default:
        return MessageEnum.gif;
    }
  }
}