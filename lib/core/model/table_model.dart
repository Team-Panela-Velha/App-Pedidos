class TableModel {
  final int id;
  final String code;
  // Numero visivel da mesa ("Mesa 3"); o code so desbloqueia o tablet.
  final int? number;

  TableModel({
    required this.id,
    required this.code,
    this.number,
  });

  /// Como a mesa aparece na tela: o numero, ou o codigo se a API nao mandar numero.
  String get label => number?.toString() ?? code;

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      code: json['code'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'number': number,
    };
  }
}
