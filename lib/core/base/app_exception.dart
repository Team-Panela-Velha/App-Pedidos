class AppException {
  var message = '';
  int? code = 0;

  AppException({required this.message, this.code = 0});

  Map<String, dynamic> toJson() => <String, dynamic>{'code': code, 'message': message};

}
