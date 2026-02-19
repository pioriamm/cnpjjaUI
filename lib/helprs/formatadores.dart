class Formatadores {

  static String formatarCnpj(String cnpj) {
    final numeros = cnpj.replaceAll(RegExp(r'\D'), '');

    if (numeros.length != 14) return cnpj;

    return numeros.replaceAllMapped(
      RegExp(r'^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$'),
          (match) => "${match[1]}.${match[2]}.${match[3]}/${match[4]}-${match[5]}",
    );
  }

}