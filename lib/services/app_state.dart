import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'database_service.dart';

class AppState extends ChangeNotifier {
  // ── Auth ────────────────────────────────────────────────────────────────────
  String? perfil; // 'responsavel' | 'motorista'
  String nomeUsuario = '';

  // ── Alunos ──────────────────────────────────────────────────────────────────
  List<Aluno> alunos = [];
  bool loadingAlunos = false;

  // ── Confirmação do dia ───────────────────────────────────────────────────────
  bool filhoConfirmado = false;

  // ID do Lucas (filho da Ana Silva — responsável demo).
  // Ele só aparece na rota do motorista se a Ana confirmar no painel dela.
  static const int _idLucas = 1;

  // ── Checklist ───────────────────────────────────────────────────────────────
  Map<int, CheckStatus> embarqueStatus = {};
  Map<int, CheckStatus> desembarqueStatus = {};

  // ── Van simulada ─────────────────────────────────────────────────────────────
  double vanLat = -26.3044;
  double vanLng = -48.8487;
  double vanVelocidade = 42;
  bool vanEmRota = true;
  Timer? _vanTimer;
  int _vanStep = 0;

  final List<List<double>> _rotaSimulada = [
    [-26.3044, -48.8487], // Lucas — Bom Retiro
    [-26.3020, -48.8456], // Ana Beatriz — Centro
    [-26.2985, -48.8520], // Pedro — Bucarein
    [-26.3080, -48.8390], // Maria — Atiradores
    [-26.2920, -48.8430], // Escola
  ];

  // ── Notificações ─────────────────────────────────────────────────────────────
  List<Notificacao> notificacoes = [];
  int get notifNaoLidas => notificacoes.where((n) => !n.lida).length;

  // ── ETA ──────────────────────────────────────────────────────────────────────
  String etaEscola = '07:38';
  String etaVolta = '17:12';
  String statusFilho = 'A bordo da van';
  double progressoRota = 0.6;

  // ── Histórico ────────────────────────────────────────────────────────────────
  final List<RegistroViagem> historico = [
    RegistroViagem(data: DateTime(2025, 5, 26), horarioEmbarque: '07:20', horarioChegadaEscola: '07:41', horarioVolta: '17:35', status: 'Normal'),
    RegistroViagem(data: DateTime(2025, 5, 23), horarioEmbarque: '07:18', horarioChegadaEscola: '07:39', horarioVolta: '17:42', status: 'Normal'),
    RegistroViagem(data: DateTime(2025, 5, 22), horarioEmbarque: '07:25', horarioChegadaEscola: '08:02', horarioVolta: '18:00', status: 'Atraso'),
    RegistroViagem(data: DateTime(2025, 5, 21), horarioEmbarque: '07:19', horarioChegadaEscola: '07:38', horarioVolta: '17:30', status: 'Normal'),
    RegistroViagem(data: DateTime(2025, 5, 20), status: 'Faltou'),
  ];

  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> login(String email, String senha, String role) async {
    perfil = role;
    nomeUsuario = role == 'responsavel' ? 'Ana Silva' : 'Carlos Fernandes';
    await _carregarConfirmacao(); // lê o toggle salvo antes de montar a rota
    await carregarAlunos();
    _iniciarSimulacaoVan();
    _carregarNotificacoesDemo();
    notifyListeners();
  }

  Future<void> _carregarConfirmacao() async {
    final prefs = await SharedPreferences.getInstance();
    filhoConfirmado = prefs.getBool('lucas_confirmado') ?? false;
  }

  Future<void> _salvarConfirmacao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lucas_confirmado', filhoConfirmado);
  }

  void logout() {
    perfil = null;
    _vanTimer?.cancel();
    notifyListeners();
  }

  Future<void> carregarAlunos() async {
    loadingAlunos = true;
    notifyListeners();
    alunos = await DatabaseService.getAlunos();

    // Lucas: ativo = o que a Ana confirmou (lido do SharedPreferences antes desta chamada)
    final idxLucas = alunos.indexWhere((a) => a.id == _idLucas);
    if (idxLucas >= 0) {
      final a = alunos[idxLucas];
      alunos[idxLucas] = Aluno(
        id: a.id, nome: a.nome, turma: a.turma,
        endereco: a.endereco, telefoneResponsavel: a.telefoneResponsavel,
        ativo: filhoConfirmado, lat: a.lat, lng: a.lng,
      );
    }

    for (final a in alunos) {
      embarqueStatus.putIfAbsent(a.id, () => CheckStatus.pendente);
      desembarqueStatus.putIfAbsent(a.id, () => CheckStatus.pendente);
    }
    // Demo: alunos 2, 3 e 4 já embarcaram
    if (alunos.length > 1) embarqueStatus[alunos[1].id] = CheckStatus.presente;
    if (alunos.length > 2) embarqueStatus[alunos[2].id] = CheckStatus.presente;
    if (alunos.length > 3) embarqueStatus[alunos[3].id] = CheckStatus.presente;

    loadingAlunos = false;
    notifyListeners();
  }

  Future<void> adicionarAluno(Aluno a) async {
    final id = await DatabaseService.insertAluno(a);
    alunos.add(Aluno(
      id: id, nome: a.nome, turma: a.turma,
      endereco: a.endereco, telefoneResponsavel: a.telefoneResponsavel,
      ativo: a.ativo, lat: a.lat, lng: a.lng,
    ));
    embarqueStatus[id] = CheckStatus.pendente;
    desembarqueStatus[id] = CheckStatus.pendente;
    notifyListeners();
  }

  Future<void> removerAluno(int id) async {
    await DatabaseService.deleteAluno(id);
    alunos.removeWhere((a) => a.id == id);
    embarqueStatus.remove(id);
    desembarqueStatus.remove(id);
    notifyListeners();
  }

  void setEmbarque(int alunoId, CheckStatus status) {
    embarqueStatus[alunoId] = status;
    final nomeAluno = alunos.firstWhere((a) => a.id == alunoId).nome;
    if (status == CheckStatus.presente) {
      adicionarNotificacao(Notificacao(
        titulo: '$nomeAluno embarcou na van',
        descricao: 'Confirmado pelo motorista às ${_horaAtual()}',
        hora: DateTime.now(),
        tipo: NotifTipo.embarque,
      ));
    } else if (status == CheckStatus.ausente) {
      adicionarNotificacao(Notificacao(
        titulo: '$nomeAluno não embarcou',
        descricao: 'Marcado como ausente pelo motorista',
        hora: DateTime.now(),
        tipo: NotifTipo.desembarque,
      ));
    }
    notifyListeners();
  }

  void setDesembarque(int alunoId, CheckStatus status) {
    desembarqueStatus[alunoId] = status;
    final nomeAluno = alunos.firstWhere((a) => a.id == alunoId).nome;
    if (status == CheckStatus.presente) {
      adicionarNotificacao(Notificacao(
        titulo: '$nomeAluno desembarcou',
        descricao: 'Saiu da van às ${_horaAtual()}',
        hora: DateTime.now(),
        tipo: NotifTipo.saiuEscola,
      ));
    }
    notifyListeners();
  }

  /// Toggle da Ana Silva — liga/desliga Lucas na rota do motorista
  void toggleConfirmacao() {
    filhoConfirmado = !filhoConfirmado;
    _salvarConfirmacao(); // persiste para o próximo login

    final idx = alunos.indexWhere((a) => a.id == _idLucas);
    if (idx >= 0) {
      final a = alunos[idx];
      alunos[idx] = Aluno(
        id: a.id, nome: a.nome, turma: a.turma,
        endereco: a.endereco, telefoneResponsavel: a.telefoneResponsavel,
        ativo: filhoConfirmado,
        lat: a.lat, lng: a.lng,
      );
    }
    notifyListeners();
  }

  int get totalPresentes =>
      embarqueStatus.values.where((s) => s == CheckStatus.presente).length;
  int get totalAusentes =>
      embarqueStatus.values.where((s) => s == CheckStatus.ausente).length;
  int get totalPendentes =>
      embarqueStatus.values.where((s) => s == CheckStatus.pendente).length;

  /// Retorna apenas alunos ativos ordenados por longitude.
  /// Lucas só aparece aqui se a Ana tiver confirmado (ativo = true).
  List<Aluno> get rotaOrdenada {
    final ativos = alunos.where((a) => a.ativo).toList();
    if (ativos.isEmpty) return [];
    final sorted = List<Aluno>.from(ativos);
    sorted.sort((a, b) => a.lng.compareTo(b.lng));
    return sorted;
  }

  void _iniciarSimulacaoVan() {
    _vanTimer?.cancel();
    _vanTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_rotaSimulada.isEmpty) return;
      _vanStep = (_vanStep + 1) % _rotaSimulada.length;
      vanLat = _rotaSimulada[_vanStep][0];
      vanLng = _rotaSimulada[_vanStep][1];
      vanVelocidade = 35 + (_vanStep * 4 % 20).toDouble();
      progressoRota = (_vanStep + 1) / _rotaSimulada.length;
      notifyListeners();
    });
  }

  void _carregarNotificacoesDemo() {
    notificacoes = [
      Notificacao(titulo: 'Lucas entrou na van', descricao: 'Rua das Palmeiras, 148 — 07:20', hora: DateTime.now().subtract(const Duration(minutes: 30)), tipo: NotifTipo.embarque),
      Notificacao(titulo: 'Lucas chegou na escola', descricao: 'Escola Estadual Boa Vista — 07:41', hora: DateTime.now().subtract(const Duration(minutes: 10)), tipo: NotifTipo.chegouEscola),
      Notificacao(titulo: 'Previsão de busca atualizada', descricao: 'Chegada estimada às 17:12', hora: DateTime.now().subtract(const Duration(minutes: 8)), tipo: NotifTipo.eta, lida: true),
      Notificacao(titulo: 'Lucas saiu da escola', descricao: 'Embarcou na van — ontem 17:08', hora: DateTime.now().subtract(const Duration(hours: 22)), tipo: NotifTipo.saiuEscola, lida: true),
      Notificacao(titulo: 'Lucas chegou em casa', descricao: 'Rua das Palmeiras, 148 — ontem 17:35', hora: DateTime.now().subtract(const Duration(hours: 22, minutes: 27)), tipo: NotifTipo.chegouCasa, lida: true),
    ];
  }

  void adicionarNotificacao(Notificacao n) {
    notificacoes.insert(0, n);
    notifyListeners();
  }

  void simularNotificacao() {
    final demos = [
      Notificacao(titulo: '⚠️ Desvio de rota detectado!', descricao: 'A van saiu do trajeto padrão às ${_horaAtual()}', hora: DateTime.now(), tipo: NotifTipo.desvio),
      Notificacao(titulo: 'Lucas chegou na escola', descricao: 'Desembarcou às ${_horaAtual()}', hora: DateTime.now(), tipo: NotifTipo.chegouEscola),
      Notificacao(titulo: 'Lucas está a bordo', descricao: 'Embarcou na van às ${_horaAtual()}', hora: DateTime.now(), tipo: NotifTipo.embarque),
    ];
    final n = demos[notificacoes.length % demos.length];
    adicionarNotificacao(n);
    if (n.tipo == NotifTipo.desvio) {
      vanEmRota = false;
      statusFilho = '⚠️ Rota desviada';
    }
    notifyListeners();
  }

  void marcarTodasLidas() {
    for (final n in notificacoes) { n.lida = true; }
    notifyListeners();
  }

  String _horaAtual() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}