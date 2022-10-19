import 'package:fit_page/models/criteria_model.dart';
import 'package:fit_page/utils/enums.dart';
import 'package:flutter/cupertino.dart';

/// [MainModel] to store all the variables (name,tag,criterias,color) from API.
class MainModel {
  MainModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.color,
    required this.criterias,
    required this.isTapped,
  });

  /// Fetch [MainModel] from API.
  factory MainModel.fromJson({required Map<String, dynamic> json}) {
    final data = (json['criteria'] as List<dynamic>);
    final list = <CriteriaModel>[];
    for (final i in data) {
      final model = CriteriaModel.fromJson(json: i as Map<String, dynamic>);
      list.add(model);
    }
    return MainModel(
      id: (json['id'] as int),
      name: (json['name'] as String),
      tag: (json['tag'] as String),
      color: (json['color'] as String).getColors(),
      criterias: list,
      isTapped: false,
    );
  }

  /// Updating [MainModel]
  MainModel copyWith({
    String? name,
    Color? color,
    List<CriteriaModel>? criterias,
    bool? isTapped,
  }) {
    return MainModel(
      id: id,
      name: name ?? this.name,
      tag: tag,
      color: color ?? this.color,
      criterias: criterias ?? this.criterias,
      isTapped: isTapped ?? this.isTapped,
    );
  }

  /// Id of a the entry
  final int id;

  /// Name of the attribute
  final String name;

  /// Tag of the attribute
  final String tag;

  /// Color of the tag
  final Color color;

  /// List of [CriteriaModel]
  final List<CriteriaModel> criterias;

  /// To keep a tab of whether the tile is opened or not.
  final bool isTapped;
}
