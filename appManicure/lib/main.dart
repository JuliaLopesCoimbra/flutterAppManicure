import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importação obrigatória!
import 'pages/register_page.dart'; // Tela de registro
import 'pages/manicure_page.dart'; // Tela da manicure
import 'pages/cliente_page.dart'; // Tela do cliente

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyALoObzbrKmrlNxX8kWB-nQW-hNG8XJoR0",
      authDomain: "appmanicure-cdd73.firebaseapp.com",
      projectId: "appmanicure-cdd73",
      storageBucket: "appmanicure-cdd73.appspot.com",
      messagingSenderId: "590407645047",
      appId: "1:590407645047:web:2e53f73ddfec16d41c5372",
      measurementId: "G-JD5KK28TGF",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Login Flutter',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showFields = false;
  String userType = '';

  bool isLoading = false; // 👈 NOVO: Variável para controlar o loading

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void selectUserType(String type) {
    setState(() {
      userType = type;
      showFields = true;
    });
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      setState(() {
        isLoading = false;
      });

      // Aqui vamos verificar o tipo de usuário
      if (userType == 'Manicure') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ManicurePage()),
        );
      } else if (userType == 'Cliente') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ClientePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tipo de usuário não reconhecido!')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator() // 👈 Mostra loading se estiver carregando
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/nails.png',
                        width: 150, // 👈 ajuste o tamanho conforme sua logo
                        height: 150,
                      ),
                      const SizedBox(height: 40),
                      if (!showFields) ...[
                        ElevatedButton(
                          onPressed: () => selectUserType('Manicure'),
                          child: const Text('Manicure'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => selectUserType('Cliente'),
                          child: const Text('Cliente'),
                        ),
                      ],
                      if (showFields) ...[
                        Text(
                          'Login',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: emailController,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: login,
                          child: const Text('Entrar'),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegistrationScreen()),
                            );
                          },
                          child: const Text('Registrar-se'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
