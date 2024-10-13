import 'package:zod_validation/zod_validation.dart';

void main() {
  final schema = {
    'id': Zod("Invalid ID").type<int>(),
    'name': Zod("Name should be at least 3 characters and at most 10")
        .min(3)
        .max(10),
    'email': Zod("Invalid email").email(),
    'phone': Zod("Invalid phone").phone(),
  };

  /// the received params from the request
  final requestParams = <String, dynamic>{
    'id': 1,
    'name': 'John Doe',
    'email': 'welito@gmail.com',
    'phone': '',
  };

  final result = Zod.validate(schema: schema, data: requestParams);
  if (result.isNotValid) print(result.resultSTR);
  if (result.isValid) print('Valid');
}
