class HoraDeToma{
  final int id;
  final int id_medicamento;
  final String hora;

  HoraDeToma({this.id = -1, required this.id_medicamento, required this.hora});

  HoraDeToma copyWith({int? id, int? id_medicamento, String? hora}){
    return HoraDeToma(id: id ?? this.id, id_medicamento: id_medicamento ?? this.id_medicamento, hora: hora ?? this.hora);
  }

  factory HoraDeToma.fromMap(Map<String, dynamic> map){
    return HoraDeToma(id: map['id'], id_medicamento: map['id_medicamento'], hora: map['hora']);
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