class Category {
  Category({
    required this.id,
    required this.name
  });

  int id;
  String name;

  factory Category.fromJson(Map<String,dynamic> json) {
    return Category(
      id: json['ID'],
      name: json['Name'],
    );
  }

  @override
  String toString(){
    return "Name:"+name;
  }
}
