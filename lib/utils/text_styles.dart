import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textStyleOnboardingScreensMainText(context) {
  return GoogleFonts.openSans(textStyle: 
  TextStyle(
    fontSize: 18, 
    color: Theme.of(context).secondaryHeaderColor, 
    fontWeight: FontWeight.w400));
}

textStyleHeader({@required color}) {
  return GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: 20, 
        fontWeight: FontWeight.w700, 
        letterSpacing: -0.3, 
        color: color
      )
    );
}

textStyleTransactionListAmount({double size = 16, Color color = Colors.grey, FontWeight fontWeight = FontWeight.w400}) {
  return GoogleFonts.nunito(textStyle: TextStyle(
      fontSize: size, 
      fontWeight: fontWeight, 
      letterSpacing: -0.3, 
      color: color
    ));
}

textStyleTransactionListCurrency({double size = 16, Color color = Colors.grey, FontWeight fontWeight = FontWeight.w400}) {
  return TextStyle(
    fontSize: size, 
    fontWeight: fontWeight, 
    letterSpacing: -0.3, 
    color: color
  );
}

transactionsListDescriptionTextStyle({double size = 16, Color color = Colors.grey, FontWeight fontWeight = FontWeight.w400}) {
  return GoogleFonts.nunito(textStyle: TextStyle(
      fontSize: size, 
      fontWeight: fontWeight, 
      letterSpacing: -0.3, 
      color: color));
}


