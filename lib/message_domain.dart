
enum To{A,B}
class Message {
  String message;
  String publicKey;
  List<int> valuesMessageEncription;
  To to;
  DateTime date;
  Message({
    required this.message,required this.publicKey,required this.to,required this.date,required this.valuesMessageEncription});
  
}