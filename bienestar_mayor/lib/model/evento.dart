class Evento{
  final int id;
  final String titulo;
  final String descripcion;

  Evento({this.id = -1, required this.titulo,
    required this.descripcion});

  Evento copyWith({int? id, String? nombre, String? descripcion}){
    return Evento(id: id ?? this.id,titulo: nombre ?? this.titulo,
        descripcion: descripcion ?? this.descripcion);
  }

  factory Evento.fromMap(Map<String, dynamic> map){
    return Evento(id: map['id'], titulo: map['nombre'],
        descripcion: map['descripcion']);
  }

  Map<String, Object> toMap(){
    Map<String, Object> map = {
      'nombre': titulo,
      'descripcion': descripcion,
    };

    if(id!=-1) map['id'] = id;

    return map;
  }
}