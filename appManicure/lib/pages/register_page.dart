import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isManicure = false;
  bool isCliente = false;

  final TextEditingController cpfController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();

  // Novos campos de endereço
  final TextEditingController cepController = TextEditingController();
  final TextEditingController ruaController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();

  Future<void> buscarEndereco(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['erro'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CEP não encontrado.')),
        );
      } else {
        setState(() {
          ruaController.text = data['logradouro'] ?? '';
          bairroController.text = data['bairro'] ?? '';
          cidadeController.text = data['localidade'] ?? '';
          estadoController.text = data['uf'] ?? '';
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao buscar endereço.')),
      );
    }
  }

  Future<void> register() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      // Salvar informações extras no Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'cpf': cpfController.text.trim(),
        'nome': nomeController.text.trim(),
        'email': emailController.text.trim(),
        'tipo': isManicure ? 'manicure' : 'cliente',
        'sexo': sexoController.text.trim(),
        'idade': idadeController.text.trim(),
        'cep': cepController.text.trim(),
        'rua': ruaController.text.trim(),
        'bairro': bairroController.text.trim(),
        'cidade': cidadeController.text.trim(),
        'estado': estadoController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    cpfController.dispose();
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    sexoController.dispose();
    idadeController.dispose();
    cepController.dispose();
    ruaController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CheckboxListTile(
                title: const Text('Manicure'),
                value: isManicure,
                onChanged: (value) {
                  setState(() {
                    isManicure = value!;
                    isCliente = !value;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Cliente'),
                value: isCliente,
                onChanged: (value) {
                  setState(() {
                    isCliente = value!;
                    isManicure = !value;
                  });
                },
              ),
              if (isManicure || isCliente) ...[
                TextField(
                  controller: cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: sexoController,
                  decoration: const InputDecoration(
                    labelText: 'Sexo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: idadeController,
                  decoration: const InputDecoration(
                    labelText: 'Idade',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Endereço com busca automática de CEP
                TextField(
                  controller: cepController,
                  decoration: const InputDecoration(
                    labelText: 'CEP',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    if (value.length == 8) {
                      buscarEndereco(value);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('CEP inválido!')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: ruaController,
                  decoration: const InputDecoration(
                    labelText: 'Rua',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: bairroController,
                  decoration: const InputDecoration(
                    labelText: 'Bairro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: cidadeController,
                  decoration: const InputDecoration(
                    labelText: 'Cidade',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: estadoController,
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: register,
                  child: const Text('Registrar'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
