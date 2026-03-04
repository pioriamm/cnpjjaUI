import 'package:cnpjjaUi/model/status.dart';

class CnpjStatus {
  final String cnpj;
  Status status;

  CnpjStatus({required this.cnpj}) : status = Status.inicial;
}
