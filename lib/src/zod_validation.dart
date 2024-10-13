import 'package:zod_validation/src/models/validade_model.dart';
import 'package:zod_validation/src/validations.dart';

/// type of return of the validation
typedef CallBack = String? Function(dynamic value);

/// this is the main class of the package
/// it is responsible for validating the data
/// and returning the error message
class Zod {
  /// list of validations
  final List<CallBack> _validations = [];

  /// custom message to return if validation is not true
  final String message;

  Zod(this.message);

  /// this method is responsible for email validation
  Zod email() {
    return _add((v) {
      return Validations.isEmail(v) ? null : message;
    });
  }

  /// this method is responsible for phone validation
  Zod phone() {
    return _add((v) {
      return Validations.isPhone(v) ? null : message;
    });
  }

  /// this method is responsible for password validation
  ///
  /// number = true
  /// special = true
  /// upper = true
  /// lower = true
  /// minLength = 8
  Zod password({
    String? message,
    bool number = true,
    bool special = true,
    bool upper = true,
    bool lower = true,
    int minLength = 8,
  }) {
    return _add((v) {
      return Validations.isValidPassword(v,
              lower: lower,
              minLength: minLength,
              number: number,
              special: special,
              upper: upper)
          ? null
          : message;
    });
  }

  /// this method is responsible for type validation
  ///
  /// example:
  /// ```dart
  /// Zod().type<int>()
  /// ```
  ///
  Zod type<T>() {
    return _add((v) {
      return Validations.matchTypes<T>(v) ? null : message;
    });
  }

  /// verify emails validate separated by comma
  /// example: email1@gmail,com,email2@gmail,com
  Zod isEmails() {
    return _add((v) {
      return Validations.required(v) ? null : message;
    });
  }

  /// verify equals validate
  Zod equals(value) {
    return _add((v) {
      return Validations.equals(value, v) ? null : message;
    });
  }

  /// this method is responsible for validation if the param existe
  Zod required() {
    return _add((v) {
      return Validations.required(v) ? null : message;
    });
  }

  /// this method is responsible for min validation
  Zod min(int min) {
    return _add((v) {
      return Validations.minCharacters(v, min) ? null : message;
    });
  }

  /// this method is responsible for max validation
  Zod max(int max) {
    return _add((v) {
      return Validations.maxCharacters(v, max) ? null : message;
    });
  }

  /// this method is responsible for cpf validation
  Zod cpf() {
    return _add((v) {
      return Validations.validateCPF(v) ? null : message;
    });
  }

  /// this method is responsible for cnpj validation
  Zod cnpj() {
    return _add((v) {
      return Validations.validateCNPJ(v) ? null : message;
    });
  }

  Zod cpfCnpj() {
    return _add((v) {
      return Validations.validateCPF(v) || Validations.validateCNPJ(v)
          ? null
          : message;
    });
  }

  Zod isDate({DateTime? max, DateTime? min}) {
    return _add((v) {
      return Validations.date(v, maxDate: max, minDate: min) ? null : message;
    });
  }

  Zod optional({bool isValidWhenEmpty = true}) {
    return _add((v) {
      if (v == null) return 'opt';
      if (isValidWhenEmpty && v is String && v.isEmpty) return 'opt';
      return null;
    });
  }

  Zod custom(bool Function(dynamic) validate) {
    return _add((v) {
      if (validate(v)) return null;
      return message;
    });
  }

  Zod _add(CallBack validator) {
    _validations.add(validator);
    return this;
  }

  String? build(dynamic value) {
    for (var validate in _validations) {
      final result = validate(value);
      if (result != null) {
        if (result == 'opt') return null;
        return result;
      }
    }
    return null;
  }

  /// The return id a List<String> with the errors
  ///
  static ValidateModel validate(
      {required Map<String, dynamic> data,
      required Map<String, dynamic> schema}) {
    if (!_validSchemaData(data: data, schema: schema)) {
      throw Exception("Invalid data");
    }
    final str = _validateString(data: data, schedule: schema);
    return ValidateModel(isValid: str.isEmpty, resultSTR: str);
  }

  static bool _validSchemaData(
      {required Map<String, dynamic> data,
      required Map<String, dynamic> schema}) {
    var schemaKeys = schema.entries.map((entry) => entry.key).toList().toSet();
    var dataKeys = data.entries.map((entry) => entry.key).toList().toSet();
    return schemaKeys.difference(dataKeys).isEmpty &&
        dataKeys.difference(schemaKeys).isEmpty;
  }

  static List<String> _validateString(
      {required Map<String, dynamic> data,
      required Map<String, dynamic> schedule}) {
    final errors = <String>[];

    schedule.forEach((key, value) {
      if (value is Zod) {
        final valid = value.build(data[key] ?? '');
        if (valid != null) errors.add('$key: $valid');
      } else if (value is Map) {
        final res = _validateString(
          data: data[key] ?? {},
          schedule: value as Map<String, dynamic>,
        );
        res.forEach((e) => errors.add('$key.$e'));
      }
    });
    return errors;
  }
}
