class Reservation {
  int? id; // ID untuk SQLite (auto-increment)
  final String name;
  final String date;
  final String time;
  final String field;

  Reservation({
    this.id,
    required this.name,
    required this.date,
    required this.time,
    required this.field,
  });

  // Convert Reservation object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'time': time,
      'field': field,
    };
  }

  // Convert Map to Reservation object
  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'],
      name: map['name'],
      date: map['date'],
      time: map['time'],
      field: map['field'],
    );
  }
}
