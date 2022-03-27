
class game{
  final String image_url;
  final int answer;
  final List choice_list;

  game({
    required this.answer,
    required this.choice_list,
    required this.image_url,
  });

  factory game.fromJson(Map<String, dynamic> json) {
    return game(
      image_url:json["image_url"],
      answer:   json["answer"],
      choice_list:   (json['choice_list'] as List).map((choice_list) => choice_list).toList() ,
    );
  }
}