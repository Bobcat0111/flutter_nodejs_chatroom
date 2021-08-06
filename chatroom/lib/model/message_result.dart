
class Message{

  int id=-1;
  int fromUserId=-1;
  int toUserId=-1;
  String content="";
  int types=-1;
  DateTime sendTime=DateTime.now();
  bool selfUser=true;

  bool timeVisility=true;

  Message();

  Message.fromJson(Map<String,dynamic> json)
  :id=json['id'],
  fromUserId=json['fromuserid'],
  toUserId=json['touserid'],
  content = json['content'],
  types = json['types'],
  selfUser = json['selfuser'];
 // sendTime = DateTime.parse(json['sendTime']);

  Map<String,dynamic> toJson(){
    return {
      'fromUserId': fromUserId,
      'toUserId':toUserId,
    };
  }

}