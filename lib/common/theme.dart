import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sonomaneoutlet/common/colors.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: false,
    dataTableTheme: DataTableThemeData(
      headingRowColor:
          MaterialStatePropertyAll(SonomaneColor.scaffoldColorLight),
      dataRowColor: MaterialStatePropertyAll(SonomaneColor.containerLight),
    ),
    listTileTheme: ListTileThemeData(
      selectedColor: SonomaneColor.primary,
      selectedTileColor: SonomaneColor.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: SonomaneColor.primary),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 1.w),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 1.w),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.w,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.w,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.nunitoSans(
          fontSize: 22.sp,
          color: SonomaneColor.textTitleLight,
          fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          color: SonomaneColor.textTitleLight,
          fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          color: SonomaneColor.textTitleLight,
          fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          color: SonomaneColor.textParaghrapLight,
          fontWeight: FontWeight.w500),
      titleMedium: GoogleFonts.nunitoSans(
          fontSize: 12.sp,
          color: SonomaneColor.textTitleLight,
          fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.nunitoSans(
          fontSize: 12.sp,
          color: SonomaneColor.textParaghrapLight,
          fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.nunitoSans(),
      displaySmall: GoogleFonts.nunitoSans(),
    ),
    brightness: Brightness.light,
    splashColor: SonomaneColor.primary,
    highlightColor: Colors.transparent,
    primaryColor: SonomaneColor.primary,
    cardColor: SonomaneColor.containerLight,
    canvasColor: SonomaneColor.scaffoldColorLight,
    colorScheme: ColorScheme.light(
        outline: SonomaneColor.textParaghrapLight,
        primary: SonomaneColor.primary,
        background: SonomaneColor.scaffoldColorLight,
        primaryContainer: SonomaneColor.containerLight,
        tertiary: SonomaneColor.textTitleLight,
        secondaryContainer: SonomaneColor.secondaryContainerLigth),
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: false,
    dataTableTheme: DataTableThemeData(
      headingRowColor:
          MaterialStatePropertyAll(SonomaneColor.scaffoldColorDark),
      dataRowColor: MaterialStatePropertyAll(SonomaneColor.containerDark),
    ),
    listTileTheme: ListTileThemeData(
      selectedColor: SonomaneColor.primary,
      selectedTileColor: SonomaneColor.primary,
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: SonomaneColor.primary),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 1.w),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 1.w),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.w,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline, width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.w,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.nunitoSans(
          fontSize: 22.sp,
          color: SonomaneColor.textTitleDark,
          fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          color: SonomaneColor.textTitleDark,
          fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          color: SonomaneColor.textTitleDark,
          fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.nunitoSans(
          fontSize: 16.sp,
          color: SonomaneColor.textParaghrapDark,
          fontWeight: FontWeight.w500),
      titleMedium: GoogleFonts.nunitoSans(
          fontSize: 12.sp,
          color: SonomaneColor.textTitleDark,
          fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.nunitoSans(
          fontSize: 12.sp,
          color: SonomaneColor.textParaghrapDark,
          fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.nunitoSans(),
      displaySmall: GoogleFonts.nunitoSans(),
    ),
    brightness: Brightness.dark,
    splashColor: SonomaneColor.primary,
    highlightColor: Colors.transparent,
    primaryColor: SonomaneColor.primary,
    cardColor: SonomaneColor.containerDark,
    canvasColor: SonomaneColor.scaffoldColorDark,
    colorScheme: ColorScheme.dark(
        outline: SonomaneColor.textParaghrapDark,
        primary: SonomaneColor.primary,
        background: SonomaneColor.scaffoldColorDark,
        primaryContainer: SonomaneColor.containerDark,
        tertiary: SonomaneColor.textTitleDark,
        secondaryContainer: SonomaneColor.secondaryContainerDark),
  );
}
