import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Armazenamento simples com SharedPreferences.
/// Funciona em Web, Android e iOS sem configuração extra.
class DatabaseService {
  static const _keyAlunos = 'goschool_alunos';
  static const _keyVersao = 'goschool_versao';
  // Incremente esse número sempre que mudar os dados demo
  static const _versaoAtual = 3;
  static int _nextId = 100;

  // ── Alunos ──────────────────────────────────────────────────────────────────

  static Future<List<Aluno>> getAlunos() async {
    final prefs = await SharedPreferences.getInstance();

    // Se a versão dos dados mudou, limpa o cache e recarrega os dados demo
    final versaoSalva = prefs.getInt(_keyVersao) ?? 0;
    if (versaoSalva < _versaoAtual) {
      await prefs.remove(_keyAlunos);
      await prefs.setInt(_keyVersao, _versaoAtual);
    }

    final raw = prefs.getString(_keyAlunos);
    if (raw == null) {
      final demo = _dadosDemo();
      await _salvarTodos(demo);
      return demo;
    }
    final List decoded = jsonDecode(raw);
    return decoded.map((m) => Aluno.fromMap(Map<String, dynamic>.from(m))).toList();
  }

  static Future<int> insertAluno(Aluno a) async {
    final lista = await getAlunos();
    final id = ++_nextId;
    lista.add(Aluno(
      id: id,
      nome: a.nome,
      turma: a.turma,
      endereco: a.endereco,
      telefoneResponsavel: a.telefoneResponsavel,
      ativo: a.ativo,
      lat: a.lat,
      lng: a.lng,
    ));
    await _salvarTodos(lista);
    return id;
  }

  static Future<void> updateAluno(Aluno a) async {
    final lista = await getAlunos();
    final idx = lista.indexWhere((x) => x.id == a.id);
    if (idx >= 0) lista[idx] = a;
    await _salvarTodos(lista);
  }

  static Future<void> deleteAluno(int id) async {
    final lista = await getAlunos();
    lista.removeWhere((a) => a.id == id);
    await _salvarTodos(lista);
  }

  static Future<void> _salvarTodos(List<Aluno> lista) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAlunos, jsonEncode(lista.map((a) => a.toMap()).toList()));
  }

  // ── Dados demo ──────────────────────────────────────────────────────────────

  static List<Aluno> _dadosDemo() => [
        Aluno(id: 1, nome: 'Lucas Vieira',       turma: '5A', endereco: 'Rua das Palmeiras, 148, Bom Retiro',          telefoneResponsavel: '(47) 99123-4567', ativo: true,  lat: -26.3044, lng: -48.8487),
        Aluno(id: 2, nome: 'Ana Beatriz Costa',   turma: '3B', endereco: 'Rua Ministro Calógeras, 22, Centro',          telefoneResponsavel: '(47) 98765-1234', ativo: true,  lat: -26.3020, lng: -48.8456),
        Aluno(id: 3, nome: 'Pedro Henrique Lima', turma: '4A', endereco: 'Av. Juscelino Kubitschek, 310, Bucarein',     telefoneResponsavel: '(47) 99234-5678', ativo: true,  lat: -26.2985, lng: -48.8520),
        Aluno(id: 4, nome: 'Maria Fernanda',      turma: '2B', endereco: 'Rua Blumenau, 7, Atiradores',                 telefoneResponsavel: '(47) 99345-6789', ativo: true,  lat: -26.3080, lng: -48.8390),
        Aluno(id: 5, nome: 'João Guilherme',      turma: '6A', endereco: 'Rua do Príncipe, 55, Centro',                 telefoneResponsavel: '(47) 99456-7890', ativo: false, lat: -26.3060, lng: -48.8460),
      ];
}