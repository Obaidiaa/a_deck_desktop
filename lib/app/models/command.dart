// data model for deck command

class Command {
  Command({
    required this.id,
    required this.name,
    required this.command,
    required this.picture,
  });

  String? id;
  String? name;
  String? command;
  String? picture;

  Command.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        command = json['command'],
        picture = json['picture'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'command': command, 'picture': picture};
}
