import 'package:fit_page/utils/enums.dart';

/// Model to store all the attributes related to variable
class VariableModel {
  VariableModel({
    required this.variableType,
    required this.value,
    this.parameterName,
    this.minValue,
    this.studyType,
    this.maxValue,
    this.defaultValue,
    this.values,
  });

  /// value of the varibale
  final String value;

  /// Variable type
  final VariableType variableType;

  /// Study type of variable
  final String? studyType;

  /// Parameter name
  final String? parameterName;

  /// Minimum value of the variable
  final int? minValue;

  /// Maximum value of the variable
  final int? maxValue;

  /// Default value of the variable
  final int? defaultValue;

  /// List of all the values that a user can choose from based on [String]
  final List<String>? values;

  /// Fetch [VariableModel] from API.
  factory VariableModel.fromJson(
      {required Map<String, dynamic> json, required String text}) {
    return VariableModel(
      value: text,
      variableType: (json['type'] as String).getVariableType(),
      parameterName: ((json['parameter_name'] ?? '') as String),
      studyType: ((json['study_type'] ?? '') as String),
      minValue: ((json['min_value'] ?? -1) as int),
      maxValue: ((json['max_value'] ?? -1) as int),
      defaultValue: ((json['default_value'] ?? -1) as int),
      values: [
        ...((json['values'] ?? []) as List<dynamic>)
            .map((e) => e.toString())
            .toList()
      ],
    );
  }

  /// Update [VariableModel]
  VariableModel copyWith({String? value}) {
    return VariableModel(
      variableType: variableType,
      value: value ?? this.value,
      values: values,
      parameterName: parameterName,
      minValue: minValue,
      maxValue: maxValue,
      defaultValue: defaultValue,
    );
  }
}
