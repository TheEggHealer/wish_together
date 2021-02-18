import 'package:cloud_functions/cloud_functions.dart';
import 'package:wishtogether/constants.dart';

class FunctionService {

  Future call() async {
    dynamic result = await FirebaseFunctions.instance.httpsCallable('test').call();

    debug('Called function, returned: ${result.data}');
  }

  Future sendNotificatio(String token) {

  }

}