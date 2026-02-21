import 'package:intl/intl.dart';

class Formatadores {

  static String formatarCnpj(String cnpj) {
    final numeros = cnpj.replaceAll(RegExp(r'\D'), '');

    if (numeros.length != 14) return cnpj;

    return numeros.replaceAllMapped(
      RegExp(r'^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$'),
          (match) => "${match[1]}.${match[2]}.${match[3]}/${match[4]}-${match[5]}",
    );
  }

  static String formatarReal(double valor) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(valor);
  }

  static String formatarCnae(String valor) {
    if (valor.length < 3) return valor;

    final inicio = valor.substring(0, valor.length - 2);
    final fim = valor.substring(valor.length - 2);

    return '$inicio-$fim';
  }

}