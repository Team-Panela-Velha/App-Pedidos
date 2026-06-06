class Tab {
  final int id;
  final double totalValue;
  final bool closed;
  final int tableId;
  final String tableCode;

  Tab({
    required this.id,
    required this.totalValue,
    required this.closed,
    required this.tableId,
    required this.tableCode,
  });

  factory Tab.fromJson(Map<String, dynamic> json) {
    return Tab(
      id: json['id'],
      totalValue: (json['totalValue'] as num?)?.toDouble() ?? 0.0,
      closed: json['closed'] ?? false,
      tableId: json['tableId'],
      tableCode: json['tableCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalValue': totalValue,
      'closed': closed,
      'tableId': tableId,
      'tableCode': tableCode,
    };
  }
}
