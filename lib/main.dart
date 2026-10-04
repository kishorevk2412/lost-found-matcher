import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'firebase_options.dart';


// ============================================================
// APP COLORS
// ============================================================

class AppColors {
  static const black = Color(0xFF000000);
  static const darkBlack = Color(0xFF090909);
  static const card = Color(0xFF151515);
  static const card2 = Color(0xFF1C1C1C);

  static const green = Color(0xFF00E676);
  static const darkGreen = Color(0xFF00A152);
  static const lightGreen = Color(0xFF69F0AE);

  static const border = Color(0xFF292929);

  static const white = Colors.white;
  static const grey = Color(0xFF9E9E9E);
}


// ============================================================
// CLOUDINARY
// ============================================================

const String cloudName = 'e4jghpkh';
const String uploadPreset = 'lost_found_upload';


// ============================================================
// SAMPLE IMAGES
// ============================================================

const String phoneImage =
    'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9';

const String walletImage =
    'https://images.unsplash.com/photo-1627123424574-724758594e93';

const String bagImage =
    'https://images.unsplash.com/photo-1553062407-98eeb64c6a62';

const String watchImage =
    'https://images.unsplash.com/photo-1524805444758-089113d48a6d';


// ============================================================
// MAIN
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LostFoundApp());
}


// ============================================================
// APP
// ============================================================

class LostFoundApp extends StatelessWidget {
  const LostFoundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lost & Found Matcher',

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,

        scaffoldBackgroundColor: AppColors.black,

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.green,
          brightness: Brightness.dark,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        cardTheme: CardThemeData(
          color: AppColors.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: AppColors.border,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.card,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.border,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: AppColors.green,
              width: 2,
            ),
          ),

          prefixIconColor: AppColors.green,
          labelStyle: const TextStyle(
            color: AppColors.grey,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            foregroundColor: Colors.black,
            minimumSize: const Size(
              double.infinity,
              52,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkBlack,
          selectedItemColor: AppColors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}


// ============================================================
// SPLASH SCREEN
// ============================================================

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    controller.forward();

    Future.delayed(
      const Duration(seconds: 3),
          () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AuthGate(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: ScaleTransition(
          scale: animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.green,
                      AppColors.darkGreen,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withOpacity(0.3),
                      blurRadius: 35,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.search,
                  size: 60,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Lost & Found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                'AI Matcher',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const CircularProgressIndicator(
                color: AppColors.green,
                strokeWidth: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// AUTH GATE
// ============================================================

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const MainScreen();
        }

        return const LoginScreen();
      },
    );
  }
}


// ============================================================
// LOGIN SCREEN
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      showMessage(
        context,
        'Please enter email and password',
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showMessage(
        context,
        e.message ?? 'Login failed',
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const SizedBox(height: 50),

              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.green,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.green.withOpacity(0.25),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.search,
                  size: 50,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Find what was lost',
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 45),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),

              const SizedBox(height: 18),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon:
                  const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                        !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: loading ? null : login,
                  child: loading
                      ? const CircularProgressIndicator(
                    color: Colors.black,
                  )
                      : const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Create New Account',
                  style: TextStyle(
                    color: AppColors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// REGISTER SCREEN
// ============================================================

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool loading = false;

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      showMessage(
        context,
        'Please fill all fields',
      );
      return;
    }

    if (password != confirm) {
      showMessage(
        context,
        'Passwords do not match',
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'notificationsEnabled': true,
        });
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      showMessage(
        context,
        e.message ?? 'Registration failed',
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,

      appBar: AppBar(
        title: const Text('Create Account'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.person_add_alt_1,
              size: 70,
              color: AppColors.green,
            ),

            const SizedBox(height: 30),

            TextField(
              controller: emailController,
              keyboardType:
              TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon:
                Icon(Icons.email_outlined),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon:
                Icon(Icons.lock_outline),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon:
                Icon(Icons.lock_outline),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 54,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : register,
                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.black,
                )
                    : const Text(
                  'Create Account',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// MAIN SCREEN
// ============================================================

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;

  final pages = const [
    HomeScreen(),
    ReportsScreen(),
    ReportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),

      bottomNavigationBar:
      BottomNavigationBar(
        currentIndex: selectedIndex,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Reports',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              size: 30,
            ),
            activeIcon: Icon(
              Icons.add_circle,
              size: 30,
            ),
            label: 'Report',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}


// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello 👋',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          user?.email?.split('@').first ??
                              'User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Hero card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0D2B1C),
                      Color(0xFF07150D),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.green
                        .withOpacity(0.4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.green,
                      size: 30,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'AI Lost & Found Matcher',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Use AI to analyze your object '
                          'and find possible matches.',
                      style: TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const ReportScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                      ),
                      label: const Text(
                        'Report an Item',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        AppColors.green,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Popular Items',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                height: 185,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    popularCard(
                      'Phone',
                      phoneImage,
                      Icons.phone_android,
                    ),
                    popularCard(
                      'Wallet',
                      walletImage,
                      Icons.account_balance_wallet,
                    ),
                    popularCard(
                      'Bag',
                      bagImage,
                      Icons.shopping_bag,
                    ),
                    popularCard(
                      'Watch',
                      watchImage,
                      Icons.watch,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'How it works',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              stepCard(
                '1',
                Icons.camera_alt_outlined,
                'Upload Photo',
                'Take or select a photo of the item.',
              ),

              stepCard(
                '2',
                Icons.auto_awesome,
                'AI Analysis',
                'AI identifies the object category.',
              ),

              stepCard(
                '3',
                Icons.compare_arrows,
                'Find Matches',
                'The system compares lost and found reports.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget popularCard(
      String title,
      String image,
      IconData icon,
      ) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => Container(
                  color: AppColors.card,
                  child: Icon(
                    icon,
                    size: 50,
                    color: AppColors.green,
                  ),
                ),
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 14,
              left: 14,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepCard(
      String number,
      IconData icon,
      String title,
      String description,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: AppColors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          Icon(
            icon,
            color: AppColors.green,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
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


// ============================================================
// AI SERVICE
// ============================================================

class AIService {

  Interpreter? interpreter;

  final labels = [
    'bag',
    'keys',
    'phone',
    'wallet',
    'watch',
  ];

  Future<void> loadModel() async {
    if (interpreter != null) return;

    interpreter = await Interpreter.fromAsset(
      'assets/lost_found_model.tflite',
    );
  }

  Future<Map<String, dynamic>> analyzeImage(
      File file,
      ) async {

    await loadModel();

    final bytes = await file.readAsBytes();

    final decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw Exception(
        'Unable to read image',
      );
    }

    final resized = img.copyResize(
      decoded,
      width: 224,
      height: 224,
    );

    final input = List.generate(
      1,
          (_) => List.generate(
        224,
            (y) => List.generate(
          224,
              (x) {
            final pixel = resized.getPixel(x, y);

            return [
              pixel.r / 255.0,
              pixel.g / 255.0,
              pixel.b / 255.0,
            ];
          },
        ),
      ),
    );

    final output = List.generate(
      1,
          (_) => List.filled(
        labels.length,
        0.0,
      ),
    );

    interpreter!.run(
      input,
      output,
    );

    final probabilities =
    List<double>.from(output[0]);

    int bestIndex = 0;

    for (int i = 1;
    i < probabilities.length;
    i++) {
      if (probabilities[i] >
          probabilities[bestIndex]) {
        bestIndex = i;
      }
    }

    return {
      'category': labels[bestIndex],
      'confidence':
      probabilities[bestIndex],
      'probabilities': probabilities,
    };
  }
}


// ============================================================
// REPORT SCREEN
// ============================================================

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() =>
      _ReportScreenState();
}

class _ReportScreenState
    extends State<ReportScreen> {

  final nameController = TextEditingController();
  final descriptionController =
  TextEditingController();
  final locationController =
  TextEditingController();

  final picker = ImagePicker();

  File? selectedImage;

  String reportType = 'Lost';

  String aiCategory = 'Not analyzed';

  double aiConfidence = 0;

  bool analyzing = false;
  bool uploading = false;

  final AIService aiService = AIService();

  Future<void> pickImage() async {

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    final file = File(image.path);

    setState(() {
      selectedImage = file;
      analyzing = true;
    });

    try {
      final result =
      await aiService.analyzeImage(file);

      setState(() {
        aiCategory =
        result['category'];
        aiConfidence =
        result['confidence'];
      });
    } catch (e) {
      showMessage(
        context,
        'AI analysis failed: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          analyzing = false;
        });
      }
    }
  }

  Future<String> uploadToCloudinary(
      File file,
      ) async {

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/'
          '$cloudName/image/upload',
    );

    final request =
    http.MultipartRequest(
      'POST',
      uri,
    );

    request.fields['upload_preset'] =
        uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );

    final response =
    await request.send();

    final body =
    await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
        'Cloudinary upload failed: $body',
      );
    }

    final data =
    jsonDecode(body);

    return data['secure_url'];
  }

  Future<void> submitReport() async {

    if (selectedImage == null) {
      showMessage(
        context,
        'Please select an image',
      );
      return;
    }

    if (nameController.text.trim().isEmpty) {
      showMessage(
        context,
        'Please enter item name',
      );
      return;
    }

    if (locationController.text.trim().isEmpty) {
      showMessage(
        context,
        'Please enter location',
      );
      return;
    }

    setState(() {
      uploading = true;
    });

    try {

      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception(
          'User not logged in',
        );
      }

      final imageUrl =
      await uploadToCloudinary(
        selectedImage!,
      );

      await FirebaseFirestore.instance
          .collection('items')
          .add({
        'userId': user.uid,

        'itemName':
        nameController.text.trim(),

        'description':
        descriptionController.text.trim(),

        'location':
        locationController.text.trim(),

        'category':
        aiCategory,

        'type':
        reportType.toLowerCase(),

        'imageUrl':
        imageUrl,

        'aiCategory':
        aiCategory,

        'aiConfidence':
        aiConfidence,

        'aiProbabilities':
        [],

        'createdAt':
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showMessage(
        context,
        'Report submitted successfully',
        color: AppColors.green,
      );

      nameController.clear();
      descriptionController.clear();
      locationController.clear();

      setState(() {
        selectedImage = null;
        aiCategory = 'Not analyzed';
        aiConfidence = 0;
      });

    } catch (e) {

      if (!mounted) return;

      showMessage(
        context,
        'Error: $e',
      );

    } finally {

      if (mounted) {
        setState(() {
          uploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'Report Item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            // Type
            const Text(
              'Report Type',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: reportTypeButton(
                    'Lost',
                    Icons.search_off,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: reportTypeButton(
                    'Found',
                    Icons.search,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Image
            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: double.infinity,
                height: 230,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius:
                  BorderRadius.circular(20),
                  border: Border.all(
                    color: selectedImage != null
                        ? AppColors.green
                        : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: selectedImage == null
                    ? const Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons
                          .add_a_photo_outlined,
                      size: 55,
                      color:
                      AppColors.green,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Tap to select item photo',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'AI will analyze the object',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
                    : ClipRRect(
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                  child: Image.file(
                    selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            if (analyzing)
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2518),
                  borderRadius:
                  BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.green,
                  ),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.green,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'AI is analyzing the image...',
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            if (!analyzing &&
                aiCategory != 'Not analyzed')
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D2518),
                  borderRadius:
                  BorderRadius.circular(15),
                  border: Border.all(
                    color: AppColors.green,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: AppColors.green,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI Analysis Complete',
                            style: TextStyle(
                              color:
                              AppColors.green,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'Detected: '
                                '${aiCategory.toUpperCase()}',
                            style:
                            const TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          Text(
                            'Confidence: '
                                '${(aiConfidence * 100).toStringAsFixed(1)}%',
                            style:
                            const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                prefixIcon:
                Icon(Icons.inventory_2_outlined),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon:
                Icon(Icons.description_outlined),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon:
                Icon(Icons.location_on_outlined),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                uploading ? null : submitReport,
                icon: uploading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.cloud_upload_outlined,
                ),
                label: Text(
                  uploading
                      ? 'Uploading...'
                      : 'Submit Report',
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget reportTypeButton(
      String type,
      IconData icon,
      ) {
    final selected =
        reportType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          reportType = type;
        });
      },
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.green
              : AppColors.card,
          borderRadius:
          BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.green
                : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected
                  ? Colors.black
                  : AppColors.green,
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                color: selected
                    ? Colors.black
                    : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// REPORTS SCREEN
// ============================================================

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'My Reports',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where(
          'userId',
          isEqualTo: user.uid,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.green,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            );
          }

          final docs =
              snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 70,
                    color: AppColors.green,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'No reports yet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Report a lost or found item',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const ReportScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Report Item',
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,

            itemBuilder: (context, index) {

              final data =
              docs[index].data()
              as Map<String, dynamic>;

              final imageUrl =
                  data['imageUrl'] ?? '';

              final category =
                  data['category'] ??
                      'Unknown';

              final type =
                  data['type'] ?? '';

              final name =
                  data['itemName'] ??
                      'Unknown Item';

              return Container(
                margin:
                const EdgeInsets.only(
                  bottom: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius:
                  BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.all(12),

                  leading: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(12),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      width: 65,
                      height: 65,
                      color: AppColors.card2,
                      child: const Icon(
                        Icons.image,
                        color:
                        AppColors.green,
                      ),
                    ),
                  ),

                  title: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Padding(
                    padding:
                    const EdgeInsets.only(
                      top: 5,
                    ),
                    child: Text(
                      '${type.toUpperCase()} • '
                          '${category.toUpperCase()}',
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// ============================================================
// PROFILE SCREEN
// ============================================================

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  final auth = FirebaseAuth.instance;
  final firestore =
      FirebaseFirestore.instance;

  bool notificationsEnabled = true;
  bool loadingNotifications = true;

  @override
  void initState() {
    super.initState();
    loadNotificationSetting();
  }

  Future<void> loadNotificationSetting() async {

    final user = auth.currentUser;

    if (user == null) {
      setState(() {
        loadingNotifications = false;
      });
      return;
    }

    try {

      final doc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists &&
          doc.data() != null) {

        final data = doc.data()!;

        notificationsEnabled =
            data['notificationsEnabled'] ??
                true;
      }

    } catch (e) {
      debugPrint(
        'Notification error: $e',
      );
    }

    if (mounted) {
      setState(() {
        loadingNotifications = false;
      });
    }
  }

  Future<void> updateNotifications(
      bool value,
      ) async {

    final user = auth.currentUser;

    if (user == null) return;

    setState(() {
      notificationsEnabled = value;
    });

    try {

      await firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'notificationsEnabled':
          value,
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      showMessage(
        context,
        value
            ? 'Notifications enabled'
            : 'Notifications disabled',
        color: AppColors.green,
      );

    } catch (e) {

      showMessage(
        context,
        'Unable to update notifications',
      );
    }
  }

  Future<void> signOut() async {

    final result =
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
          AppColors.card,

          title: const Text(
            'Sign Out',
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                AppColors.green,
                foregroundColor:
                Colors.black,
              ),
              child:
              const Text('Sign Out'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = auth.currentUser;

    final email =
        user?.email ??
            'No email available';

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
          const EdgeInsets.fromLTRB(
            14,
            30,
            14,
            30,
          ),
          child: Column(
            children: [

              // Profile icon
              Container(
                width: 88,
                height: 88,
                decoration:
                const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                  LinearGradient(
                    colors: [
                      AppColors.green,
                      AppColors.darkGreen,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                email,
                textAlign:
                TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 35),

              profileOption(
                icon:
                Icons.person_outline,
                title: 'Account',
                subtitle:
                'View your account details',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AccountScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              profileOption(
                icon: Icons
                    .notifications_none,
                title: 'Notifications',
                subtitle:
                loadingNotifications
                    ? 'Loading...'
                    : notificationsEnabled
                    ? 'Notifications are enabled'
                    : 'Notifications are disabled',
                trailing:
                loadingNotifications
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                    AppColors.green,
                  ),
                )
                    : Switch(
                  value:
                  notificationsEnabled,
                  activeColor:
                  AppColors.green,
                  onChanged:
                  updateNotifications,
                ),
                onTap: () {
                  updateNotifications(
                    !notificationsEnabled,
                  );
                },
              ),

              const SizedBox(height: 10),

              profileOption(
                icon:
                Icons.shield_outlined,
                title:
                'Privacy & Security',
                subtitle:
                'Manage your account security',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const PrivacySecurityScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              profileOption(
                icon:
                Icons.info_outline,
                title: 'About',
                subtitle:
                'Lost & Found Matcher',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const AboutScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 80),

              SizedBox(
                width: double.infinity,
                height: 54,
                child:
                ElevatedButton.icon(
                  onPressed: signOut,
                  icon: const Icon(
                    Icons.logout,
                  ),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.green,
                    foregroundColor:
                    Colors.black,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {

    return Material(
      color: AppColors.card,
      borderRadius:
      BorderRadius.circular(16),

      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(16),

        child: Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),

          decoration:
          BoxDecoration(
            borderRadius:
            BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
            ),
          ),

          child: Row(
            children: [

              Container(
                width: 42,
                height: 42,
                decoration:
                BoxDecoration(
                  color:
                  const Color(0xFF0D2518),
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColors.green,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style:
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style:
                      const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              trailing ??
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// ACCOUNT SCREEN
// ============================================================

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final user =
        FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'Account',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            accountTile(
              Icons.email_outlined,
              'Email',
              user?.email ??
                  'Not available',
            ),

            const SizedBox(height: 12),

            accountTile(
              Icons.fingerprint,
              'User ID',
              user?.uid ??
                  'Not available',
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {

                  final email =
                      user?.email;

                  if (email == null) {
                    return;
                  }

                  try {

                    await FirebaseAuth
                        .instance
                        .sendPasswordResetEmail(
                      email: email,
                    );

                    if (!context.mounted) {
                      return;
                    }

                    showMessage(
                      context,
                      'Password reset email sent',
                      color:
                      AppColors.green,
                    );

                  } catch (e) {

                    showMessage(
                      context,
                      'Error: $e',
                    );
                  }
                },

                icon: const Icon(
                  Icons.lock_reset,
                ),

                label: const Text(
                  'Reset Password',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget accountTile(
      IconData icon,
      String title,
      String value,
      ) {

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(
        color: AppColors.card,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: AppColors.green,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style:
                  const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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


// ============================================================
// PRIVACY & SECURITY
// ============================================================

class PrivacySecurityScreen
    extends StatelessWidget {

  const PrivacySecurityScreen({
    super.key,
  });

  Future<void> resetPassword(
      BuildContext context,
      ) async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user?.email == null) return;

    try {

      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: user!.email!,
      );

      if (!context.mounted) return;

      showMessage(
        context,
        'Password reset email sent',
        color: AppColors.green,
      );

    } catch (e) {

      if (!context.mounted) return;

      showMessage(
        context,
        'Error: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'Privacy & Security',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            securityCard(
              Icons.lock_outline,
              'Password',
              'Keep your password secure',
            ),

            const SizedBox(height: 12),

            securityCard(
              Icons.cloud_outlined,
              'Cloud Data',
              'Your reports are securely stored in Firebase',
            ),

            const SizedBox(height: 12),

            securityCard(
              Icons.image_outlined,
              'Images',
              'Uploaded images are stored using Cloudinary',
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () =>
                    resetPassword(context),
                icon: const Icon(
                  Icons.lock_reset,
                ),
                label: const Text(
                  'Change Password',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget securityCard(
      IconData icon,
      String title,
      String description,
      ) {

    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(18),

      decoration:
      BoxDecoration(
        color: AppColors.card,
        borderRadius:
        BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),

      child: Row(
        children: [

          Container(
            padding:
            const EdgeInsets.all(12),

            decoration:
            BoxDecoration(
              color:
              const Color(0xFF0D2518),
              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Icon(
              icon,
              color: AppColors.green,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style:
                  const TextStyle(
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style:
                  const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
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


// ============================================================
// ABOUT SCREEN
// ============================================================

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text(
          'About',
        ),
      ),

      body: Center(
        child: Padding(
          padding:
          const EdgeInsets.all(25),

          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              Container(
                width: 100,
                height: 100,

                decoration:
                const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                  LinearGradient(
                    colors: [
                      AppColors.green,
                      AppColors.darkGreen,
                    ],
                  ),
                ),

                child: const Icon(
                  Icons.search,
                  size: 55,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Lost & Found Matcher',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'AI Powered Lost and Found '
                    'Object Matching',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              Container(
                padding:
                const EdgeInsets.all(18),

                decoration:
                BoxDecoration(
                  color: AppColors.card,
                  borderRadius:
                  BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.border,
                  ),
                ),

                child: const Column(
                  children: [

                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color:
                        AppColors.green,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      'This application uses Artificial '
                          'Intelligence to analyze lost and '
                          'found objects and help users identify '
                          'possible matches.',
                      textAlign:
                      TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Flutter • Firebase • Cloudinary • TensorFlow Lite',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// MATCHING FUNCTIONS
// ============================================================

double calculateTextSimilarity(
    String a,
    String b,
    ) {

  final wordsA = a
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((e) => e.isNotEmpty)
      .toSet();

  final wordsB = b
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((e) => e.isNotEmpty)
      .toSet();

  if (wordsA.isEmpty ||
      wordsB.isEmpty) {
    return 0;
  }

  final intersection =
  wordsA.intersection(wordsB);

  final union =
  wordsA.union(wordsB);

  return intersection.length /
      union.length;
}


// ============================================================
// MESSAGE
// ============================================================

void showMessage(
    BuildContext context,
    String message, {
      Color? color,
    }) {

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        color ?? Colors.red.shade800,
      ),
    );
}