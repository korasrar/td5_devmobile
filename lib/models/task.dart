import 'dart:convert';

class Task {
  int? id;
  String title;
  List<String> tags;
  int nbhours;
  int difficulty;
  String description;
  bool isExported;

  Task({
    this.id,
    required this.title,
    required this.tags,
    required this.nbhours,
    required this.difficulty,
    required this.description,
    this.isExported = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    var tagsRaw = json['tags'];
    List<String> tagsList = [];

    // j'avais une erreur avec les tags et supabase
    if (tagsRaw is String) {
      try {

        var decoded = jsonDecode(tagsRaw);
        if (decoded is List) {
          tagsList = List<String>.from(decoded);
        } else {
          tagsList = tagsRaw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        }
      } catch (e) {
        tagsList = tagsRaw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
    } else if (tagsRaw is List) {
      tagsList = List<String>.from(tagsRaw);
    }

    return Task(
      id: json['id'],
      title: json['title'],
      tags: tagsList,
      nbhours: json['nbhours'] ?? 0,
      difficulty: json['difficulty'] ?? 0,
      description: json['description'] ?? '',
      isExported: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'tags': tags,
      'nbhours': nbhours,
      'difficulty': difficulty,
      'description': description,
    };
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'tags': tags.join(','),
      'nbhours': nbhours,
      'difficulty': difficulty,
      'description': description,
      'isExported': isExported ? 1 : 0,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    var tagsRaw = map['tags'] as String? ?? '';
    return Task(
      id: map['id'],
      title: map['title'] ?? '',
      tags: tagsRaw.isEmpty ? [] : tagsRaw.split(','),
      nbhours: map['nbhours'] ?? 0,
      difficulty: map['difficulty'] ?? 0,
      description: map['description'] ?? '',
      isExported: map['isExported'] == 1,
    );
  }

  @override
  String toString() {
    return 'Task{id: $id, title: $title, tags: $tags, nbhours: $nbhours, difficulty: $difficulty, description: $description, isExported: $isExported}';
  }
}
