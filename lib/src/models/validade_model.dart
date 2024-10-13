///
/// ValidateModel
///
class ValidateModel {
  /// true when all params are valid
  final bool isValid;

  /// Map with the errors
  ///
  /// example:
  ///
  /// ```dart
  /// {
  ///    'data': {
  ///      'user_name': 'At least 8 characters'
  ///    }
  /// }
  /// ```
  ///

  /// List with the errors
  ///
  /// example:
  /// ```dart
  /// [
  ///  'user_name: At least 8 characters',
  /// ]
  /// ```
  final List<String> resultSTR;

  ValidateModel({required this.isValid, required this.resultSTR});

  /// true when `isValid` is false
  bool get isNotValid => !isValid;
}
