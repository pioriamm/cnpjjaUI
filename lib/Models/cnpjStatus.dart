import 'package:proj_flutter/Models/status.dart';

class CnpjStatus {
  final String cnpj;
  Status status;

  CnpjStatus({required this.cnpj}) : status = Status.inicial;
}