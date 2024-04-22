class Medicamento{
  final int id;
  final String nombre;
  final String dosis;
  final int frecuencia;
  final int duracion;
  final String? foto;

  Medicamento({this.id = -1, required this.nombre,
    this.dosis = "Sin dosis especificada", required this.frecuencia, required this.duracion, this.foto});

  Medicamento copyWith({int? id, String? nombre, String? dosis, int? frecuencia, int? duracion, String? foto}){
    return Medicamento(id: id ?? this.id, nombre: nombre ?? this.nombre,
        dosis: dosis ?? this.dosis, frecuencia: frecuencia ?? this.frecuencia,
        duracion: duracion ?? this.duracion, foto: foto ?? this.foto);
  }

  factory Medicamento.fromMap(Map<String, dynamic> map){
    return Medicamento(id: map['id'], nombre: map['nombre'],
        dosis: map['dosis'], frecuencia: map['frecuencia'], duracion: map['duracion'], foto: map['foto']);
  }

  Map<String, Object> toMap(){
    Map<String, Object> map = {
      'nombre': nombre,
      'frecuencia' : frecuencia,
      'duracion': duracion,
    };

    if(id!=-1) map['id'] = id;
    if(!dosis.contains("especificada")) map['dosis'] = dosis;
    if(foto!=null) map['foto'] = foto!;

    return map;
  }
}