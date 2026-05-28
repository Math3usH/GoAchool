import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Armazenamento simples com SharedPreferences.
/// Funciona em Web, Android e iOS sem configuração extra.
class DatabaseService {
  static const _keyAlunos = 'goschool_alunos';
  static int _nextId = 100;

  // ── Alunos ──────────────────────────────────────────────────────────────────

  static Future<List<Aluno>> getAlunos() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyAlunos);
    if (raw == null) {
      // Primeira execução: grava os dados demo e retorna
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
        Aluno(id: 1, nome: 'Lucas Vieira', turma: '5A', endereco: 'Rua das Flores, 148', telefoneResponsavel: '(49) 99123-4567', ativo: true, lat: -27.1731, lng: -51.5069),
        Aluno(id: 2, nome: 'Ana Beatriz Costa', turma: '3B', endereco: 'Rua do Cedro, 22', telefoneResponsavel: '(49) 98765-1234', ativo: true, lat: -27.1745, lng: -51.5080),
        Aluno(id: 3, nome: 'Pedro Henrique Lima', turma: '4A', endereco: 'Av. das Palmeiras, 310', telefoneResponsavel: '(49) 99234-5678', ativo: true, lat: -27.1720, lng: -51.5055),
        Aluno(id: 4, nome: 'Maria Fernanda', turma: '2B', endereco: 'Rua Ipê, 7', telefoneResponsavel: '(49) 99345-6789', ativo: true, lat: -27.1760, lng: -51.5090),
        Aluno(id: 5, nome: 'João Guilherme', turma: '6A', endereco: 'Rua do Sol, 55', telefoneResponsavel: '(49) 99456-7890', ativo: false, lat: -27.1710, lng: -51.5040),
      ];
}
