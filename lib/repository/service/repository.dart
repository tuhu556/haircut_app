import 'package:haircut_app/models/service.dart';

abstract class Repository {
  Future<List<Service>> getService();
}
