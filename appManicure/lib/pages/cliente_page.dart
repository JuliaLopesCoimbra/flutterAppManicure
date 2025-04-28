import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'agendamento_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';

class ClientePage extends StatelessWidget {
  const ClientePage({super.key});

  static const Color rosaPastel = Color(0xFFFFD1DC);

  void _mostrarAgendamentoModal(BuildContext context, String manicure) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (_) {
        final TextEditingController _horarioController =
            TextEditingController();

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Agendar com $manicure',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: rosaPastel,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _horarioController,
                decoration: InputDecoration(
                  hintText: 'Digite o horário desejado',
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
                    AgendamentoController().adicionarAgendamento(
                        manicure, _horarioController.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Horário reservado com $manicure!'),
                        backgroundColor: rosaPastel,
                      ),
                    );
                  }
                },
                child: const Text('Confirmar Horário'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String nomeManicure =
        'Manicure 1'; // 👈 ou o nome certo que você quiser buscar
    List<Map<String, String>> agendamentos =
        AgendamentoController().buscarAgendamentosPorManicure(nomeManicure);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Encontre sua Manicure'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
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
              'Manicures próximas:',
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
                    // Lista de manicures
                    ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // 👈 importante para não quebrar
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
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
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        rosaPastel.withOpacity(0.7),
                                    child: const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    'Manicure ${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle:
                                      const Text('Disponível para agendamento'),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      _mostrarAgendamentoModal(
                                          context, 'Manicure ${index + 1}');
                                    },
                                    child: const Text('Reservar'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                    if (agendamentos.isNotEmpty) ...[
                      const Text(
                        'Seus agendamentos:',
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
                              leading: const Icon(Icons.access_time,
                                  color: rosaPastel),
                              title: Text(a['horario']!),
                              subtitle: Text(
                                a['status'] == 'confirmado'
                                    ? '✅ Confirmado'
                                    : '⏳ Pendente',
                                style: TextStyle(
                                  color: a['status'] == 'confirmado'
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
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
