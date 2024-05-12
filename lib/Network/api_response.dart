// ignore_for_file: constant_identifier_names

class ApiResponse<T> {
  Status status = Status.LOADING;
  T data = RequestHandler.create(T) as T;
  String message = "Loading";

  ApiResponse.loading(this.message) : status = Status.LOADING;

  ApiResponse.completed(this.data) : status = Status.COMPLETED;

  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

class RequestHandler {
  static final _constructors = RequestHandler();

  static RequestHandler create(Type type) {
    return _constructors;
  }
}

class RequestHandler2 extends RequestHandler {}

enum Status { LOADING, COMPLETED, ERROR }
