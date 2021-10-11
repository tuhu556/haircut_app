import 'package:haircut_app/models/service.dart';
import 'package:haircut_app/repository/service/repository.dart';

class ServiceController {
  final Repository _repository;
  ServiceController(this._repository);

  Future<List<Service>> fechServiceList() async {
    return _repository.getService();
  }
}
