class Historial{
  final int id;
  final int id_recordatorio;
  final bool tomado;

  Historial({this.id = -1, required this.id_recordatorio, this.tomado = false});

  Historial copyWith({int? id, int? id_recordatorio, bool? tomado}){
    return Historial(id: id ?? this.id,id_recordatorio: id_recordatorio ?? this.id_recordatorio,
        tomado: tomado ?? this.tomado);
  }

  factory Historial.fromMap(Map<String, dynamic> map){
    return Historial(id: map['id'], id_recordatorio: map['id_recordatorio'],
        tomado: map['tomado']);
  }

  Map<String, Object> toMap(){
    Map<String, Object> map = {
      'id_recordatorio': id_recordatorio,
      'tomado': tomado,
    };

    if(id!=-1) map['id'] = id;

    return map;
  }
}