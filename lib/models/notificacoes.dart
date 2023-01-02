class Notificacao {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;
  final DateTime? criadoEm;
  final int? id_documento;

  Notificacao({
    this.id,
    required this.criadoEm,
    this.id_documento,
    this.title,
    this.body,
    this.payload,
  });

  factory Notificacao.fromMap(Map<String, dynamic> json) => Notificacao(
        id: json['id'],
        criadoEm: DateTime.parse(json['criadoEm']),
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'criadoEm': criadoEm!.toIso8601String(),
    };
  }
}
