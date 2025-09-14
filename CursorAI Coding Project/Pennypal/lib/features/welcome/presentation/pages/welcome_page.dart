import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/color_scheme.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

/// Welcome page matching Figma design
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the screen
        children: [
          // Layer 1: Background Image Layer (lowest visual layer)
          Positioned(
            left: MediaQuery.of(context).size.width * 0.05, // Moved to the left just a smidge more
            top: MediaQuery.of(context).size.height * 0.35, // Moved down just a smidge more
            child: Transform.rotate(
              angle: -0.2,
              // Removed alignment here as Positioned handles primary placement
              child: SizedBox( // Explicit size for the rotated image content
                width: MediaQuery.of(context).size.width * 1.2, // Zoomed out (less big)
                height: MediaQuery.of(context).size.height * 1.2, // Zoomed out (less big)
                child: Stack(
                  fit: StackFit.expand, // Innermost stack to layer image and gradient
                  children: [
                    Image.asset(
                      'assets/images/background_news.png',
                      fit: BoxFit.cover, // Ensures width spans, height can be cut off at bottom
                      // No explicit width/height here
                    ),
                    // Removed Container with LinearGradient here to remove the image's blur
                  ],
                ),
              ),
            ),
          ),
          // Layer 2: Blur Overlay (Applies to the entire screen, behind foreground content)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5), // Lessened blur further
              child: Container(color: Colors.transparent), // Ensure transparent container for blur effect
            ),
          ),
          // Layer 3: Foreground Content (Logo, Title, Buttons) - always on top
          Positioned.fill( // Ensures the foreground layer fills the screen and sits on top
            child: Column(
              children: [
                Expanded(
                  flex: 4, // Adjusted flex to give much more space to the logo/title
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.xxl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Removed SizedBox(height: AppTheme.lg) here to fix overflow
                          Image.asset(
                            'assets/images/pennypal_logo.png',
                            width: 150, // Made logo bigger
                            height: 150,
                          ),
                          // Removed SizedBox(height: AppTheme.lg) here to fix overflow
                          Text(
                            'PENNY PAL',
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 60, // Made title bigger
                              shadows: [
                                Shadow(
                                  blurRadius: 5.0,
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(3.0, 3.0),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6, // Adjusted flex to move background lower and accommodate bigger top section
                  child: SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.xxl), // Bottom margin
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Keep buttons grouped at bottom
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => context.go(RouteNames.register),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black, width: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  'Get Started',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppTheme.lg),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => context.go(RouteNames.login),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
