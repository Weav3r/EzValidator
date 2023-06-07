import 'package:ez_validator/validator/ez_validator_locale.dart';

class FrLocale implements EzLocale {
  const FrLocale();

  @override
  String name() => 'fr';

  @override
  String minLength(String v, int n, [String? label]) =>
      '${label ?? 'Ce champ'} doit contenir au moins $n caractères';
  @override
  String maxLength(String v, int n, [String? label]) =>
      '${label ?? 'Ce champ'} doit contenir au plus $n caractères';
  @override
  String email(String v, [String? label]) =>
      '${label ?? 'Ce champ'} n\'est pas une adresse e-mail valide';

  @override
  String phoneNumber(String v, [String? label]) =>
      "${label ?? 'Ce champ'} n'est pas un numéro de téléphone valide";

  @override
  String required([String? label]) => '${label ?? 'Ce champ'} est requis';

  @override
  String ip(String v, [String? label]) =>
      '${label ?? 'Ce champ'} n\'est pas une adresse IP valide';

  @override
  String ipv6(String v, [String? label]) =>
      '${label ?? 'Ce champ'} n\'est pas une adresse IPv6 valide';

  @override
  String url(String v, [String? label]) =>
      '${label ?? 'Ce champ'} n\'est pas une adresse URL valide';

  @override
  String boolean(String v, [String? label]) =>
      '${label ?? 'Ce champ'} n\'est pas de type booléen';

  @override
  String uuid(String v, [String? label]) =>
      "${label ?? 'Ce champ'} n'est pas un uuid valide";

  @override
  String lowerCase(String v, [String? label]) =>
      "${label ?? 'Ce champ'} n'est pas en minuscule";

  @override
  String upperCase(String v, [String? label]) =>
      "${label ?? 'Ce champ'} n'est pas en majuscule";

  @override
  String max(String v, int n, [String? label]) =>
      "${label ?? 'Ce champ'} doit être inférieur ou égal à $n";

  @override
  String min(String v, int n, [String? label]) =>
      "${label ?? 'Ce champ'} doit être supérieur ou égal à $n";

  @override
  String oneOf(List<String?> items, String v, [String? label]) =>
      "${label ?? 'Ce champ'} doit être l'une des valeurs suivantes : ${items.join(',')}";

  @override
  String notOneOf(List<String?> items, String v, [String? label]) =>
      "${label ?? 'Ce champ'} ne doit pas être l'une des valeurs suivantes : ${items.join(',')}";

  @override
  String notNumber(String v, [String? label]) =>
      "${label ?? 'Ce champ'} ne doit pas être un nombre";

  @override
  String number(String v, [String? label]) =>
      "${label ?? 'Ce champ'} n'est pas un numéro valide";

  @override
  String matches(String pattern, String v, [String? label]) =>
      "${label ?? 'Ce champ'} doit correspondre à ce qui suit : $pattern";

  @override
  String date(String v, [String? label]) =>
      "${label ?? 'Ce champ'} doit être de type date";

  @override
  String negative(String v, [String? label]) =>
      "${label ?? 'Ce champ'} doit être un nombre négatif";

  @override
  String positive(String v, [String? label]) =>
      "${label ?? 'Ce champ'} doit être un nombre positif";
}
