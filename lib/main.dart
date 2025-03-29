import 'package:flutter/material.dart';
import 'package:appmolecule/app_colors.dart';
import 'package:appmolecule/app_styles.dart';
import 'package:appmolecule/org/molecule.dart';
import 'package:appmolecule/responsive_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isDarkMode = false;
  bool _isSplashCompleted = false;

  @override
  void initState() {
    super.initState();
    _startSplashScreen();
    _checkLoginStatus();
  }

  void _startSplashScreen() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSplashCompleted = true;
      });
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isDarkMode = isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _isSplashCompleted
          ? (_isLoggedIn ? const MolecularAnalyzerScreen() : const LoginScreen())
          : const SplashScreen(), // Show splash first
    );
  }
}


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   const Scaffold(
      backgroundColor: AppColors.mainBlueColor,
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child:  Image(image: AssetImage("assets/logo.webp")),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedEmail = prefs.getString('email') ?? "";
    String savedPassword = prefs.getString('password') ?? "";
    if (_emailController.text == savedEmail && _passwordController.text == savedPassword) {
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MolecularAnalyzerScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(

      body: Row(
        children: [
          ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      height: height,
                      color: AppColors.mainBlueColor,
                      child: Center(
                        child: Text(
                          'AdminExpress',
                          style: ralewayStyle.copyWith(
                            fontSize: 48.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
          Expanded(
            child: Container( height: height,
                      margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveWidget.isSmallScreen(context)
                              ? height * 0.032
                              : height * 0.12),
                      color: AppColors.backColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.2),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Let’s',
                                    style: ralewayStyle.copyWith(
                                      fontSize: 25.0,
                                      color: AppColors.blueDarkColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Login 👇',
                                    style: ralewayStyle.copyWith(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.blueDarkColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.02),
                            Text(
                              'Enter your details to login.',
                              style: ralewayStyle.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor,
                              ),
                            ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInputField(controller: _emailController, label: "Email", hint: "Enter your email"),
                          _buildInputField(controller: _passwordController, label: "Password", hint: "Enter your password", isPassword: true),
                          const SizedBox(height: 20),
                           Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _login,
                          borderRadius: BorderRadius.circular(16.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: AppColors.mainBlueColor,
                            ),
                            child: Text(
                              'Login',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => SignupScreen()));
                            },
                            child: const Text("Don't have an account? Sign up"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SignupScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignupScreen({super.key});

  Future<void> _signup(BuildContext context) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setBool('isLoggedIn', true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MolecularAnalyzerScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                    child: Container(
                      height: height,
                      color: AppColors.mainBlueColor,
                      child: Center(
                        child: Text(
                          'AdminExpress',
                          style: ralewayStyle.copyWith(
                            fontSize: 48.0,
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
          Expanded(
            child: Container(
              height: height,
                      margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveWidget.isSmallScreen(context)
                              ? height * 0.032
                              : height * 0.12),
              child: SingleChildScrollView(
                 padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.2),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Let’s',
                                        style: ralewayStyle.copyWith(
                                          fontSize: 25.0,
                                          color: AppColors.blueDarkColor,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' signup 👇',
                                        style: ralewayStyle.copyWith(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.blueDarkColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.02),
                                Text(
                                  'Enter your details to signup.',
                                  style: ralewayStyle.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textColor,
                                  ),
                                ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInputField(controller: _emailController, label: "Email", hint: "Enter your email"),
                          _buildInputField(controller: _passwordController, label: "Password", hint: "Enter your password", isPassword: true),
                          const SizedBox(height: 20),
                           Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: ()=>_signup(context),
                          borderRadius: BorderRadius.circular(16.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: AppColors.mainBlueColor,
                            ),
                            child: Text(
                              'sign up',
                              style: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.whiteColor,
                                fontSize: 16.0,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildInputField({
  required TextEditingController controller,
  required String label,
  required String hint,
  bool isPassword = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
            hintText: hint,
          ),
        ),
      ],
    ),
  );
}
