import 'package:apps/utils/importer.dart';

TextStyle get robotoLight300 {
  return const TextStyle(
      fontSize: 14,
      fontFamily: 'roboto',
      fontWeight: FontWeight.w300,
      color: Colors.black);
}

TextStyle get robotoRegular400 => const TextStyle(
    fontSize: 14,
    fontFamily: 'roboto',
    fontWeight: FontWeight.w400,
    color: Colors.black);

TextStyle get robotoMedium500 {
  return const TextStyle(
      fontSize: 14,
      fontFamily: 'roboto',
      fontWeight: FontWeight.w500,
      color: Colors.black);
}

TextStyle get robotoSemiBold600 {
  return const TextStyle(
      fontSize: 14,
      fontFamily: 'roboto',
      fontWeight: FontWeight.w600,
      color: Colors.black);
}

TextStyle get robotoBold700 {
  return const TextStyle(
      fontSize: 14,
      fontFamily: 'roboto',
      fontWeight: FontWeight.w700,
      color: Colors.black);
}

InputDecoration textFieldDecoration({
  Icon? prefixIcon,
  String hint = '',
  bool isFocused = true,
  Icon? suffixIcon,
}) {
  return InputDecoration(
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hint,
    prefixIconColor: isFocused ? primaryColor : onPrimaryColor,
    filled: true,
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(
        color: Color.fromRGBO(77, 186, 128, 1),
        width: 3.5,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        borderSide: BorderSide(color: onPrimaryColor)),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(color: primaryColor),
    ),
  );
}
