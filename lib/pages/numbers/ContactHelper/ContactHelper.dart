class ContactHelper {
  int id;
  String name;
  String numbers;

  ContactHelper(this.id, this.name, this.numbers);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'numbers': numbers,
    };
    return map;
  }

  ContactHelper.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    numbers = map['numbers'];
  }
}
