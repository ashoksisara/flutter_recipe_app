class RecipeModel{
  String label, image, source, url;
  RecipeModel({this.url, this.source, this.label, this.image});

  factory RecipeModel.fromMap(Map<String,dynamic> parsedJson){
    return RecipeModel(
      url: parsedJson['url'],
      label: parsedJson['label'],
      image: parsedJson['image'],
      source: parsedJson['source']
    );
  }
}