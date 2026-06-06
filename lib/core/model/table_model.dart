class TableModel {
  final int id;
  final String code;

  TableModel({
    required this.id,
    required this.code,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
    };
  }
}
