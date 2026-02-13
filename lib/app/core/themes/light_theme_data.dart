import 'package:flutter/material.dart';

import 'app_colors.dart';

class LightThemeData
{
    static ThemeData get theme 
    {
        return ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.backgroundLight,
            fontFamily: "Poppins",

            // Color Scheme
            colorScheme: const ColorScheme.light(
                primary: AppColors.primary,
                secondary: AppColors.secondary,
                surface: AppColors.surfaceLight,
                error: AppColors.errorLight,
                onPrimary: AppColors.white,
                onSecondary: AppColors.white,
                onSurface: AppColors.textPrimaryLight,
                onError: AppColors.white,
                surfaceContainerHighest: AppColors.lightCard100,
            ),


            // App Bar Theme
            appBarTheme: const AppBarTheme(
                // backgroundColor: AppColors.background,
                foregroundColor: AppColors.black,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.black),
                titleTextStyle: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                )
            ),

            // Text Themes
            textTheme: const TextTheme(
                displayLarge: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                ),
                displayMedium: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),
                displaySmall: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
                headlineMedium: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                ),
                headlineSmall: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                ),
                titleLarge: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),
                bodyLarge: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                ),
                bodyMedium: TextStyle(
                    color: AppColors.textPrimaryLight,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                ),
                bodySmall: TextStyle(
                    color: AppColors.textDisabledLight,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                )
            ),

            // Button Themes
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    )
                )
            ),

            // Outline Button Themes
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.grey,
                    backgroundColor: AppColors.greyLight,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    side: BorderSide(width: 1.4, color: AppColors.grey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    )
                )
            ),

            // Switch Theme
            switchTheme: SwitchThemeData(
                thumbColor: WidgetStateProperty.resolveWith<Color?>((states)
                    {
                        if (states.contains(WidgetState.disabled) && states.contains(WidgetState.selected)) 
                        {
                            return AppColors.primary.withAlpha(100); // ON but disabled -> faded green
                        }
                        if (states.contains(WidgetState.selected)) return AppColors.white; // ON
                        if (states.contains(WidgetState.disabled)) return AppColors.primary.withAlpha(100); // OFF & disabled
                        return AppColors.white; // default
                    }
                ),

                trackColor: WidgetStateProperty.resolveWith<Color?>((states)
                    {
                        if (states.contains(WidgetState.disabled) && states.contains(WidgetState.selected)) 
                        {
                            return AppColors.primary.withAlpha(50); // ON but disabled -> faded red
                        }
                        if (states.contains(WidgetState.selected)) return AppColors.primary; // ON
                        if (states.contains(WidgetState.disabled)) return AppColors.primary.withAlpha(60); // OFF & disabled
                        return AppColors.primary.withAlpha(150); // default
                    }
                ),
                trackOutlineColor: WidgetStateProperty.all(Colors.white),
                overlayColor: WidgetStateProperty.resolveWith<Color?>((states)
                    {
                        if (states.contains(WidgetState.disabled) && states.contains(WidgetState.selected)) 
                        {
                            return AppColors.primary.withAlpha(80); // ON but disabled -> faded overlay
                        }

                        if (states.contains(WidgetState.selected)) return AppColors.primary; // normal ON
                        if (states.contains(WidgetState.disabled)) return AppColors.primary.withAlpha(50); // OFF disabled
                        return AppColors.primary.withAlpha(50);
                    }
                )
            ),

            // Text Selection Theme
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColors.primary,
                selectionColor: AppColors.primary.withValues(alpha:0.25),
                selectionHandleColor: AppColors.primary
            ),

            // Input Decoration Theme
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderLight)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderLight)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary)
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.errorLight)
                ),
                disabledBorder: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.all(12)
            ),

            // Card Theme
            cardTheme: CardThemeData(
                color: AppColors.surfaceLight,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                margin: EdgeInsets.zero
            ),

            // Dialog Theme
            dialogTheme: DialogThemeData(
                backgroundColor: AppColors.surfaceLight,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                )
            )

        );
    }
}
