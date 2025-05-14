// Fixed splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _animationController.forward();
    _checkNavigationStatus();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkNavigationStatus() async {
    // Wait for animation to complete - FIXED: reduced from 20 seconds to 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    
    if (!mounted) return;
    
    // Check if onboarding is complete using SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final isOnboardingComplete = prefs.getBool('onboarding_completed') ?? false;
    
    if (isOnboardingComplete) {
      // Check if user is logged in
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      if (isLoggedIn) {
        context.go(RouteConstants.home);
      } else {
        context.go(RouteConstants.login);
      }
    } else {
      context.go(RouteConstants.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo with animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animationController.value,
                  child: child,
                );
              },
              child: _buildLogo(),
            ),
            const SizedBox(height: 24),
            // App name with fade-in animation
            FadeTransition(
              opacity: _animationController,
              child: const Text(
                'Ride Hailing App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLogo() {
    // Try to load Lottie animation first
    return Lottie.asset(
      'assets/animations/car_animation.json',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // If Lottie fails, try to load static image
        return Image.asset(
          'assets/images/app_logo.png',
          width: 150,
          height: 150,
          errorBuilder: (context, error, stackTrace) {
            // If image fails, show icon
            return const Icon(
              Icons.directions_car,
              size: 150,
              color: AppColors.primary,
            );
          },
        );
      },
    );
  }
}