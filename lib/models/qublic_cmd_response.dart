class QubicCmdResponse {
  late bool status;
  String? publicId;
  String? error;
  String? transaction;

  QubicCmdResponse(
      {required this.status, this.publicId, this.error, this.transaction});

  factory QubicCmdResponse.fromJson(Map<String, dynamic> json) {
    return QubicCmdResponse(
      status: json['status'] == "ok" ? true : false,
      publicId: json.containsKey("publicId") ? json['publicId'] : null,
      error: json.containsKey("error") ? json['error'] : null,
      transaction: json.containsKey("transaction") ? json['transaction'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status ? "true" : false;
    data['publicId'] = publicId;
    data['error'] = error;
    data['transaction'] = transaction;
    return data;
  }
}
