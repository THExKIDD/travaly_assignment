import 'package:assignment_travaly/core/services/dio/dio_client.dart';
import 'package:assignment_travaly/presentation/auth/bloc/login_bloc.dart';
import 'package:assignment_travaly/presentation/auth/bloc/login_event.dart';
import 'package:assignment_travaly/presentation/auth/bloc/login_state.dart';
import 'package:assignment_travaly/presentation/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(dioClient: DioClient()),
      child: const GoogleSignInView(),
    );
  }
}

class GoogleSignInView extends StatelessWidget {
  const GoogleSignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Sign in failed'),
                backgroundColor: const Color(0xFFFF6F61),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF5F4),
                  Color(0xFFFFF0EE),
                  Color(0xFFFFE8E5),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Compact Hero Logo
                    Hero(
                      tag: 'hotel_logo',
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF6F61).withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/myTravaly.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFF6F61),
                                        Color(0xFFFF8F84),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.apartment_rounded,
                                    size: 45,
                                    color: Colors.white,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // App Title
                    const Text(
                      'My Travaly',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF6F61),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'Find your perfect stay',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatItem('10K+', 'Hotels'),
                        Container(
                          width: 1,
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: const Color(0xFFFF6F61).withOpacity(0.3),
                        ),
                        _buildStatItem('50K+', 'Reviews'),
                        Container(
                          width: 1,
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          color: const Color(0xFFFF6F61).withOpacity(0.3),
                        ),
                        _buildStatItem('4.8★', 'Rating'),
                      ],
                    ),

                    const Spacer(flex: 2),

                    // Google Sign In Button
                    state.status == LoginStatus.loading ||
                            state.status == LoginStatus.deviceRegistering
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFF6F61,
                                  ).withOpacity(0.15),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                          Color(0xFFFF6F61),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Text(
                                  state.status == LoginStatus.deviceRegistering
                                      ? 'Setting up...'
                                      : 'Signing in...',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2C2C2C),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              context.read<LoginBloc>().add(
                                const GoogleSignInRequested(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF2C2C2C),
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                              shadowColor: const Color(
                                0xFFFF6F61,
                              ).withOpacity(0.15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/google_logo.svg',
                                  height: 24,
                                  width: 24,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFF6F61),
                                            Color(0xFFFF8F84),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.g_mobiledata_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'Continue with Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 16),

                    // Divider with text
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: const Color(0xFFFF6F61).withOpacity(0.2),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Trusted by travelers worldwide',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF6B6B6B).withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: const Color(0xFFFF6F61).withOpacity(0.2),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Features in compact grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeature(Icons.shield_outlined, 'Secure'),
                        _buildFeature(Icons.discount_outlined, 'Best Deals'),
                        _buildFeature(
                          Icons.support_agent_outlined,
                          '24/7 Support',
                        ),
                      ],
                    ),

                    const Spacer(flex: 1),

                    // Terms and Privacy - Compact
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'By continuing, you agree to our ',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFF6B6B6B).withOpacity(0.8),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Terms',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFFF6F61),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          ' and ',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFF6B6B6B).withOpacity(0.8),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFFF6F61),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFF6F61),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: const Color(0xFF6B6B6B).withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFeature(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6F61).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFFFF6F61), size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF6B6B6B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
