import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'agendamento_controller.dart';
import '../main.dart'; // ou o caminho correto se seu LoginScreen estiver em outro arquivo
import 'package:firebase_auth/firebase_auth.dart';

class ManicurePage extends StatefulWidget {
  const ManicurePage({super.key});

  @override
  State<ManicurePage> createState() => _ManicurePageState();
}

class _ManicurePageState extends State<ManicurePage> {
  final List<String> horarios = [];
  final TextEditingController _horarioController = TextEditingController();

  static const Color rosaPastel = Color(0xFFFFD1DC);

  void _mostrarAdicionarHorarioModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Adicionar Horário Disponível',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: rosaPastel,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _horarioController,
                decoration: InputDecoration(
                  hintText: 'Ex: 14:00 - 15:00',
                  filled: true,
                  fillColor: rosaPastel.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_horarioController.text.isNotEmpty) {
                    setState(() {
                      horarios.add(_horarioController.text);
                    });
                    Navigator.pop(context);
                    _horarioController.clear();
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _horarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String nomeManicure = 'Manicure 1';
    List<Map<String, String>> agendamentos =
        AgendamentoController().buscarAgendamentosPorManicure(nomeManicure);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Área da Manicure'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Faz logout do Firebase
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false, // Remove todas as telas anteriores
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Horários Disponíveis:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: rosaPastel,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AnimationLimiter(
                child: ListView(
                  children: [
                    ...horarios
                        .map((horario) => AnimationConfiguration.staggeredList(
                              position: horarios.indexOf(horario),
                              delay: const Duration(milliseconds: 100),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.access_time,
                                        color: rosaPastel,
                                      ),
                                      title: Text(
                                        horario,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          setState(() {
                                            horarios.remove(horario);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                    if (agendamentos.isNotEmpty) ...[
                      const SizedBox(height: 30),
                      const Text(
                        'Horários Agendados:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: rosaPastel,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...agendamentos.map((a) => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              title: Text(a['horario']!),
                              subtitle: Text(
                                a['status'] == 'confirmado'
                                    ? 'Confirmado'
                                    : 'Pendente',
                                style: TextStyle(
                                  color: a['status'] == 'confirmado'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: a['status'] == 'pendente'
                                  ? ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          AgendamentoController()
                                              .confirmarAgendamento(
                                            a['manicure']!,
                                            a['horario']!,
                                          );
                                        });
                                      },
                                      child: const Text('Confirmar'),
                                    )
                                  : const Icon(Icons.check,
                                      color: Colors.green),
                            ),
                          ))
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
