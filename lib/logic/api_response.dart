class APIresponse<T> {

T  data;
bool error;
String errorMessage;


APIresponse({this.data ,  this.error , this.errorMessage});
}