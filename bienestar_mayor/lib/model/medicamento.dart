class Medicamento{
  final int id;
  final String nombre;

  // "500ml", "1000mg"
  final String dosis;

  // Cada cuantas horas
  final int frecuencia;

  // Duración del tratamiento en días
  final int duracion;

  final String? foto;

  Medicamento({this.id = -1, required this.nombre,
      this.dosis = "Sin especificar",
      required this.frecuencia,
      required this.duracion,
      this.foto});

  Medicamento copyWith({int? id, String? nombre, String? dosis, int? frecuencia, int? duracion, String? foto}){
    return Medicamento(id: id ?? this.id, nombre: nombre ?? this.nombre,
        dosis: dosis ?? this.dosis, frecuencia: frecuencia ?? this.frecuencia,
        duracion: duracion ?? this.duracion, foto: foto ?? this.foto);
  }

  factory Medicamento.fromMap(Map<String, dynamic> map){
    return Medicamento(id: map['id'], nombre: map['nombre'],
        dosis: map['dosis'] ?? 'Sin especificar',
        frecuencia: map['frecuencia'],
        duracion: map['duracion'],
        foto: map['foto'] ?? '');
  }

  Map<String, Object> toMap(){
    Map<String, Object> map = {
      'nombre': nombre,
      'frecuencia' : frecuencia,
      'duracion': duracion,
    };

    if(id!=-1) map['id'] = id;
    if (!dosis.contains("especificar")) map['dosis'] = dosis;
    if (foto != null && foto!.isNotEmpty) map['foto'] = foto!;

    return map;
  }
}