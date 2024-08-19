class Data<T> {

  String message;
  T? data;
  int statusCode;

  Data({
    this.message = "",
    this.statusCode = 200,
    required this.data,
  });

}