import 'package:fit_page/models/variable_model.dart';
import 'package:fit_page/utils/enums.dart';

/// For storing values of criterias
class CriteriaModel {
  CriteriaModel({
    required this.criteriaType,
    required this.text,
    this.variableModel,
  });

  /// Fecthing [CriteriaModel] from API.
  factory CriteriaModel.fromJson({required Map<String, dynamic> json}) {
    final variable =
        (json['variable'] ?? <String, dynamic>{}) as Map<String, dynamic>;
    final list = <VariableModel>[];

    for (final i in variable.entries) {
      final model = VariableModel.fromJson(
          json: i.value as Map<String, dynamic>, text: i.key);
      list.add(model);
    }

    return CriteriaModel(
      criteriaType: (json['type'] as String).getCriteriaType(),
      text: <String>[...(json['text'] as String).split(" ")],
      variableModel: list,
    );
  }

  /// Updating [CriteriaModel]
  CriteriaModel copyWith({
    List<VariableModel>? variableModel,
    List<String>? text,
  }) {
    return CriteriaModel(
      criteriaType: criteriaType,
      text: text ?? this.text,
      variableModel: variableModel ?? this.variableModel,
    );
  }

  /// Defining criteriaType
  final CriteriaType criteriaType;

  /// String text splitted into words
  final List<String> text;

  /// VariableModel
  final List<VariableModel>? variableModel;
}
