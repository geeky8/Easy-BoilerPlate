// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// enum [CriteriaType] defined to identify type of criteria
enum CriteriaType {
  /// Representing variable criteriaType
  VARIABLE,

  /// Representing plain text criteriaType
  PLAINTEXT,
}

/// enum [VariableType] defined to identify different variable types
enum VariableType {
  /// [INDICATOR] to represnt indicator type of variable
  INDICATOR,

  /// [VALUE] to represent value based indicator
  VALUE,
}

/// extension on [String] to get [CriteriaType]
extension Criteria on String {
  CriteriaType getCriteriaType() {
    switch (this) {
      case 'variable':
        return CriteriaType.VARIABLE;
      case 'plain_text':
        return CriteriaType.PLAINTEXT;
    }
    return CriteriaType.PLAINTEXT;
  }
}

/// extension on [String] to get [VariableType]
extension Variable on String {
  VariableType getVariableType() {
    switch (this) {
      case 'value':
        return VariableType.VALUE;
      case 'indicator':
        return VariableType.INDICATOR;
    }
    return VariableType.INDICATOR;
  }
}

/// extension on [String] to get [Color]
extension GetColor on String {
  Color getColors() {
    switch (this) {
      case 'green':
        return Colors.green[600]!;
      case 'red':
        return Colors.red[500]!;
    }
    return Colors.black;
  }
}

/// enum [StoreState] defined to identify the state of the [MainController]
enum StoreState {
  /// [LOADING] represents loading state [CircularProgressIndicator]
  LOADING,

  /// [SUCCESS] represents list based on [MainModel]
  SUCCESS,

  /// [EMPTY] represents no data fetched from API.
  EMPTY,
}
