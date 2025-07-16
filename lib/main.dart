import 'dart:convert'; // Add this import for JSON handling
import 'dart:io'; // Add this for platform detection
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'screens/product_query_screen.dart';

void main() {
  runApp(const ProductQueryApp());

  // Only initialize custom window on desktop platforms
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    doWhenWindowReady(() {
      final win = appWindow;
      const initialSize = Size(1200, 800);
      win.minSize = const Size(800, 600);
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = "Product Query App - JSON Edition";
      win.show();
    });
  }
}

// Main app widget with conditional custom window frame
class ProductQueryApp extends StatelessWidget {
  const ProductQueryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Query App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Professional green
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 4,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.25,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
          titleMedium: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            letterSpacing: 0.25,
          ),
          bodySmall: TextStyle(
            letterSpacing: 0.4,
          ),
        ),
        // Custom color extensions for better theming
        extensions: <ThemeExtension<dynamic>>[
          CustomColors(
            success: Colors.green.shade600,
            warning: Colors.orange.shade600,
            info: Colors.blue.shade600,
            successContainer: Colors.green.shade50,
            warningContainer: Colors.orange.shade50,
            infoContainer: Colors.blue.shade50,
          ),
        ],
      ),
      // Dark theme support (optional)
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 4,
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      themeMode: ThemeMode.system, // Respects system theme preference
      home: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    // Only use custom window frame on desktop platforms
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      return Scaffold(
        body: Column(
          children: [
            // Custom Title Bar for desktop
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(child: MoveWindow()), // Draggable area
                  const WindowButtons(), // Custom window buttons
                ],
              ),
            ),
            // The rest of your app
            const Expanded(
              child: ProductQueryScreen(),
            ),
          ],
        ),
      );
    } else {
      // Standard layout for mobile/web
      return const ProductQueryScreen();
    }
  }
}

// Custom window buttons widget with only a close button (desktop only)
class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final closeButtonColors = WindowButtonColors(
      mouseOver: const Color(0xFFD32F2F),
      mouseDown: const Color(0xFFB71C1C),
      iconNormal: Theme.of(context).colorScheme.onSurface,
      iconMouseOver: Colors.white,
    );

    return CloseWindowButton(colors: closeButtonColors);
  }
}

// Custom colors extension for additional theming
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.successContainer,
    required this.warningContainer,
    required this.infoContainer,
  });

  final Color success;
  final Color warning;
  final Color info;
  final Color successContainer;
  final Color warningContainer;
  final Color infoContainer;

  @override
  CustomColors copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? successContainer,
    Color? warningContainer,
    Color? infoContainer,
  }) {
    return CustomColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      successContainer: successContainer ?? this.successContainer,
      warningContainer: warningContainer ?? this.warningContainer,
      infoContainer: infoContainer ?? this.infoContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
    );
  }
}