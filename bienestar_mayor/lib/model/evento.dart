class Evento{
  final int id;
  final String titulo;
  final String descripcion;
  // YYYY-MM-DD
  final String fecha;

  //TODO: añadir categoria TEXT, para decoracion del calendario

  Evento({this.id = -1, required this.titulo,
      this.descripcion = "",
      required this.fecha});

  Evento copyWith({int? id, String? titulo, String? descripcion, String? fecha}){
    return Evento(id: id ?? this.id, titulo: titulo ?? this.titulo,
        descripcion: descripcion ?? this.descripcion, fecha: fecha ?? this.fecha );
  }

  factory Evento.fromMap(Map<String, dynamic> map){
    return Evento(id: map['id'], titulo: map['titulo'],
        descripcion: map['descripcion'], fecha: map['fecha']);
  }

  Map<String, Object> toMap(){
    Map<String, Object> map = {
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
    };

    if (id != -1) map['id'] = id;
    if (descripcion.isNotEmpty) map['descripcion'] = descripcion;

    return map;
  }
}