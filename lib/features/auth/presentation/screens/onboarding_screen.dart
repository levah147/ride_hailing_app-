import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      title: 'Welcome to Ride Hailing',
      description: 'The easiest way to get a ride at your fingertips',
      image: 'assets/images/onboarding_1.svg',
      imageIcon: Icons.directions_car,
    ),
    OnboardingItem(
      title: 'Quick & Easy Booking',
      description: 'Book a ride in seconds and get picked up by top-rated drivers',
      image: 'assets/images/onboarding_2.svg',
      imageIcon: Icons.timer,
    ),
    OnboardingItem(
      title: 'Track Your Ride',
      description: 'Know exactly where your driver is and share your trip with friends',
      image: 'assets/images/onboarding_3.svg',
      imageIcon: Icons.location_on,
    ),
    OnboardingItem(
      title: 'Safe & Reliable',
      description: 'All drivers are verified and rated by other passengers',
      image: 'assets/images/onboarding_4.svg',
      imageIcon: Icons.verified_user,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    debugPrint('Next button pressed. Current page: $_currentPage');
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    debugPrint('Completing onboarding');
    // Save onboarding completion status
    _saveOnboardingCompleted();
    // Navigate to login screen
    context.go(RouteConstants.login);
  }
  
  Future<void> _saveOnboardingCompleted() async {
    // Using shared preferences to save onboarding status
    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setBool('onboarding_completed', true);
    } catch (e) {
      debugPrint('Error saving onboarding status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _onboardingItems.length,
                itemBuilder: (context, index) {
                  debugPrint('Building page at index: $index');
                  return OnboardingPage(item: _onboardingItems[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _onboardingItems.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  // Next button - Fixed infinite width constraint issue
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(0),
                        backgroundColor: AppColors.primary,
                      ),
                      child: Icon(
                        _currentPage < _onboardingItems.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;
  final IconData imageIcon; // Fallback icon if image is not available

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.imageIcon,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // Add debugging information
    debugPrint('Building OnboardingPage with title: ${item.title}');
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image or fallback icon with explicit dimensions
                SizedBox(
                  height: 240,
                  width: constraints.maxWidth * 0.8, // 80% of available width
                  child: Center(child: _buildImage()),
                ),
                const SizedBox(height: 48),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
    );
  }
  
  Widget _buildImage() {
    // Check if the image file exists first
    debugPrint('Attempting to build image: ${item.image}');
    
    try {
      if (item.image.endsWith('.svg')) {
        return SvgPicture.asset(
          item.image,
          fit: BoxFit.contain,
          placeholderBuilder: (context) => _buildFallbackIcon(),
        );
      } else {
        return Image.asset(
          item.image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Error loading image: $error');
            return _buildFallbackIcon();
          },
        );
      }
    } catch (e) {
      debugPrint('Exception while loading image: $e');
      return _buildFallbackIcon();
    }
  }
  
  Widget _buildFallbackIcon() {
    return Icon(
      item.imageIcon,
      size: 100,
      color: AppColors.primary.withOpacity(0.7),
    );
  }
}