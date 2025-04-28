class AgendamentoController {
  static final AgendamentoController _instance =
      AgendamentoController._internal();
  factory AgendamentoController() => _instance;
  AgendamentoController._internal();

  final List<Map<String, String>> agendamentos = [];

  void adicionarAgendamento(String manicure, String horario) {
    agendamentos.add({
      'manicure': manicure,
      'horario': horario,
      'status': 'pendente', // 👈 Começa como pendente
    });
  }

  List<Map<String, String>> buscarAgendamentosPorManicure(String manicure) {
    return agendamentos.where((a) => a['manicure'] == manicure).toList();
  }

  void confirmarAgendamento(String manicure, String horario) {
    for (var agendamento in agendamentos) {
      if (agendamento['manicure'] == manicure &&
          agendamento['horario'] == horario) {
        agendamento['status'] = 'confirmado'; // 👈 Atualiza para confirmado
      }
    }
  }
}
