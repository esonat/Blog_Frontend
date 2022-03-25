class Category {
  Category({
    this.id,
    required this.name
  });

  int? id;
  String name;

  factory Category.fromJson(Map<String,dynamic> json) {
    return Category(
      id: json['ID'],
      name: json['Name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID':id.toString(),
      'Name':name,
    };
  }

  @override
  String toString(){
    return "Name:"+name;
  }
}
