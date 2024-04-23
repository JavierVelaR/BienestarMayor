class Recordatorio{
  final int id;
  final int id_medicamento;

  /// Será insertado a la db como String en formato YYYY-MM-DD HH:MM:SS.mmm
  final String hora;

  Recordatorio({this.id = -1, required this.id_medicamento, required this.hora});

  Recordatorio copyWith({int? id, int? id_medicamento, String? hora}){
    return Recordatorio(id: id ?? this.id, id_medicamento: id_medicamento ?? this.id_medicamento, hora: hora ?? this.hora);
  }

  factory Recordatorio.fromMap(Map<String, dynamic> map){
    return Recordatorio(id: map['id'], id_medicamento: map['id_medicamento'], hora: map['hora']);
  }

  Map<String, Object> toMap(){
    Map<String, Object> map = {
      'id_medicamento': id_medicamento,
      'hora': hora,
    };

    if(id!=-1) map['id'] = id;

    return map;
  }
}