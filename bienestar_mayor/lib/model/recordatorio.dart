class Recordatorio{
  final int id;
  final String nombre;
  final String descripcion;

  /// Será insertado a la db como String en formato YYYY-MM-DD HH:MM:SS.mmm
  final String fecha_hora;

  Recordatorio({this.id = -1, required this.nombre,
    required this.descripcion, required this.fecha_hora});

  Recordatorio copyWith({int? id,/* int? id_usuario,*/ String? nombre, String? descripcion, String? fecha_hora}){
    return Recordatorio(id: id ?? this.id,nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion, fecha_hora: fecha_hora ?? this.fecha_hora);
  }

  factory Recordatorio.fromMap(Map<String, dynamic> map){
    return Recordatorio(id: map['id'], nombre: map['nombre'],
        descripcion: map['descripcion'], fecha_hora: map['frecuencia'], );
  }

  Map<String, Object> toMap(){
    Map<String, Object> map = {
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_hora': fecha_hora,
    };

    if(id!=-1) map['id'] = id;

    return map;
  }
}