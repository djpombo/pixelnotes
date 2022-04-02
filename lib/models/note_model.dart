class Note {
  int? id;
  String? titulo;
  DateTime? date;
  String? prioridade;
  int? status;

  Note({this.titulo, this.date, this.prioridade, this.status});

  Note.widthId({this.id, this.titulo, this.date, this.prioridade, this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }

    map['titulo'] = titulo;
    map['date'] = date!.toIso8601String();
    map['prioridade'] = prioridade;
    map['status'] = status;

    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note.widthId(
        id: map['id'],
        titulo: map['titulo'],
        date: DateTime.parse(map['date']),
        prioridade: map['prioridade'],
        status: map['status']);
  }
}
