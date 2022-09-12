enum StatusEnum{
  text("text"),
  image("image"),
  video("video");

  final String type;

  const StatusEnum(this.type);
}

extension StringToStatusEnum on String {
  StatusEnum toEnum(){
    switch(this){
      case "text":
        return StatusEnum.text;
      case "video":
        return StatusEnum.video;
      case "image":
        return StatusEnum.image;
      default:
        return StatusEnum.text;
    }
  }
}
