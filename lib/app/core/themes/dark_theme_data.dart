import 'package:flutter/material.dart';
import 'app_colors.dart';

class DarkThemeData
{

    static ThemeData get theme 
    {
        return ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primary,
            // scaffoldBackgroundColor: AppColors.backgroundDark,
            fontFamily: "Poppins",

            // Color Scheme
            colorScheme: const ColorScheme.dark(
                primary: AppColors.primary,
                secondary: AppColors.secondary,
                surface: AppColors.surfaceDark,
                error: AppColors.errorDark,
                onPrimary: AppColors.white,
                onSecondary: AppColors.white,
                onSurface: AppColors.textPrimaryDark,
                onError: AppColors.white,
                surfaceContainerHighest: AppColors.darkCard100,
            ),

            // Scaffold Background
            // scaffoldBackgroundColor: AppColors.backgroundDark,

            // App Bar Theme
            appBarTheme: const AppBarTheme(
                // backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: AppColors.white),
                titleTextStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                )
            ),

            // Text Themes
            textTheme: const TextTheme(
                displayLarge: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                ),
                displayMedium: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),
                displaySmall: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
                headlineMedium: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                ),
                headlineSmall: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                ),
                titleLarge: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),
                bodyLarge: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 16,
                    fontWeight: FontWeight.normal
                ),
                bodyMedium: TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.normal
                ),
                bodySmall: TextStyle(
                    color: AppColors.textDisabledDark,
                    fontSize: 12,
                    fontWeight: FontWeight.normal
                )
            ),

            // Button Themes
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
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
                    backgroundColor: AppColors.greyDark,
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
                trackOutlineColor: WidgetStateProperty.all(AppColors.onBackground),
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
                cursorColor: AppColors.primaryDark,
                selectionColor: AppColors.primaryDark.withValues(alpha: 0.25),
                selectionHandleColor: AppColors.primaryDark
            ),

            // Input Decoration Theme
            inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderDark)
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.borderDark)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary)
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.errorDark)
                ),
                disabledBorder: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.surfaceDark,
                contentPadding: const EdgeInsets.all(12.0)
            ),

            // Card Theme
            cardTheme: CardThemeData(
                color: AppColors.surfaceDark,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                ),
                margin: EdgeInsets.zero
            ),

            // Dialog Theme
            dialogTheme: DialogThemeData(
                backgroundColor: AppColors.surfaceDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                )
            )
        );
    }
}
