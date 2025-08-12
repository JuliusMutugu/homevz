import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/user_type_provider.dart';
import 'auth_page.dart';

// Provider for temporary user type selection
final tempUserTypeProvider = StateProvider<UserType?>((ref) => null);

class UserTypeSelectionPage extends ConsumerWidget {
  const UserTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Logo and welcome text
              Icon(
                Icons.home_outlined,
                size: 80,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(height: 24),
              
              Text(
                'Welcome to HomeVZ',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              Text(
                'Your trusted housing solution in Kenya',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              
              Text(
                'I want to:',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // User type selection cards
              Expanded(
                child: Column(
                  children: [
                    _buildUserTypeCard(
                      context: context,
                      ref: ref,
                      userType: UserType.tenant,
                      title: 'Find a Home',
                      subtitle: 'Search for rental properties, view listings, and connect with landlords',
                      icon: Icons.search_outlined,
                      features: [
                        'Browse property listings',
                        'Schedule property tours',
                        'Chat with landlords',
                        'Apply for properties',
                        'Pay rent via M-Pesa'
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    _buildUserTypeCard(
                      context: context,
                      ref: ref,
                      userType: UserType.landlord,
                      title: 'List My Property',
                      subtitle: 'Manage properties, find tenants, and grow your real estate business',
                      icon: Icons.business_outlined,
                      features: [
                        'List properties for rent/sale',
                        'Manage tenant applications',
                        'Collect rent payments',
                        'Property analytics',
                        'Tenant communication'
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Continue button
              Consumer(
                builder: (context, ref, child) {
                  final selectedUserType = ref.watch(tempUserTypeProvider);
                  
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: selectedUserType != null 
                        ? () => _continueWithUserType(context, ref, selectedUserType)
                        : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard({
    required BuildContext context,
    required WidgetRef ref,
    required UserType userType,
    required String title,
    required String subtitle,
    required IconData icon,
    required List<String> features,
  }) {
    final theme = Theme.of(context);
    final selectedUserType = ref.watch(tempUserTypeProvider);
    final isSelected = selectedUserType == userType;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(tempUserTypeProvider.notifier).state = userType,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primaryGreen : AppColors.grey300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected 
                        ? AppColors.primaryGreen 
                        : AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : AppColors.primaryGreen,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected 
                              ? AppColors.primaryGreen 
                              : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primaryGreen,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Features list
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: isSelected 
                        ? AppColors.primaryGreen 
                        : AppColors.grey400,
                      size: 16,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _continueWithUserType(BuildContext context, WidgetRef ref, UserType userType) {
    // Set the user type in the main provider
    ref.read(userTypeProvider.notifier).setUserType(userType);
    
    // Navigate to auth page with the selected user type
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthPage(),
      ),
    );
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          userType == UserType.tenant 
            ? 'Welcome future tenant! Let\'s find your perfect home.'
            : 'Welcome property owner! Let\'s grow your business.',
        ),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}
