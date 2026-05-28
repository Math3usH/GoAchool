import 'package:flutter/material.dart';

// ─── Aluno ───────────────────────────────────────────────────────────────────
class Aluno {
  final int id;
  String nome;
  String turma;
  String endereco;
  String telefoneResponsavel;
  bool ativo;
  double lat;
  double lng;

  Aluno({
    required this.id,
    required this.nome,
    required this.turma,
    required this.endereco,
    required this.telefoneResponsavel,
    this.ativo = true,
    this.lat = 0,
    this.lng = 0,
  });

  String get iniciais =>
      nome.trim().split(' ').take(2).map((e) => e[0].toUpperCase()).join();

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'turma': turma,
        'endereco': endereco,
        'telefone': telefoneResponsavel,
        'ativo': ativo ? 1 : 0,
        'lat': lat,
        'lng': lng,
      };

  factory Aluno.fromMap(Map<String, dynamic> m) => Aluno(
        id: m['id'],
        nome: m['nome'],
        turma: m['turma'],
        endereco: m['endereco'],
        telefoneResponsavel: m['telefone'],
        ativo: m['ativo'] == 1,
        lat: m['lat'] ?? 0,
        lng: m['lng'] ?? 0,
      );
}

// ─── Status checklist ────────────────────────────────────────────────────────
enum CheckStatus { pendente, presente, ausente }

extension CheckStatusExt on CheckStatus {
  String get label {
    switch (this) {
      case CheckStatus.pendente:
        return 'Pendente';
      case CheckStatus.presente:
        return 'Presente';
      case CheckStatus.ausente:
        return 'Ausente';
    }
  }

  Color get color {
    switch (this) {
      case CheckStatus.pendente:
        return const Color(0xFF8A92A3);
      case CheckStatus.presente:
        return const Color(0xFF22C55E);
      case CheckStatus.ausente:
        return const Color(0xFFEF4444);
    }
  }

  Color get bgColor {
    switch (this) {
      case CheckStatus.pendente:
        return const Color(0xFFE8EAF0);
      case CheckStatus.presente:
        return const Color(0xFFDCFCE7);
      case CheckStatus.ausente:
        return const Color(0xFFFEE2E2);
    }
  }

  IconData get icon {
    switch (this) {
      case CheckStatus.pendente:
        return Icons.help_outline_rounded;
      case CheckStatus.presente:
        return Icons.check_circle_rounded;
      case CheckStatus.ausente:
        return Icons.cancel_rounded;
    }
  }
}

// ─── Checklist item ──────────────────────────────────────────────────────────
class ChecklistItem {
  final Aluno aluno;
  CheckStatus embarque;
  CheckStatus desembarque;

  ChecklistItem({
    required this.aluno,
    this.embarque = CheckStatus.pendente,
    this.desembarque = CheckStatus.pendente,
  });
}

// ─── Notificação ─────────────────────────────────────────────────────────────
enum NotifTipo { embarque, desembarque, chegouEscola, saiuEscola, desvio, eta, chegouCasa }

class Notificacao {
  final String titulo;
  final String descricao;
  final DateTime hora;
  final NotifTipo tipo;
  bool lida;

  Notificacao({
    required this.titulo,
    required this.descricao,
    required this.hora,
    required this.tipo,
    this.lida = false,
  });

  IconData get icon {
    switch (tipo) {
      case NotifTipo.embarque:
        return Icons.directions_bus_rounded;
      case NotifTipo.desembarque:
        return Icons.person_pin_circle_rounded;
      case NotifTipo.chegouEscola:
        return Icons.school_rounded;
      case NotifTipo.saiuEscola:
        return Icons.exit_to_app_rounded;
      case NotifTipo.desvio:
        return Icons.warning_amber_rounded;
      case NotifTipo.eta:
        return Icons.access_time_rounded;
      case NotifTipo.chegouCasa:
        return Icons.home_rounded;
    }
  }

  Color get color {
    switch (tipo) {
      case NotifTipo.desvio:
        return const Color(0xFFF97316);
      case NotifTipo.embarque:
      case NotifTipo.chegouEscola:
      case NotifTipo.saiuEscola:
      case NotifTipo.chegouCasa:
        return const Color(0xFF22C55E);
      case NotifTipo.desembarque:
        return const Color(0xFF3B82F6);
      case NotifTipo.eta:
        return const Color(0xFFFFD000);
    }
  }
}

// ─── Viagem histórico ────────────────────────────────────────────────────────
class RegistroViagem {
  final DateTime data;
  final String? horarioEmbarque;
  final String? horarioChegadaEscola;
  final String? horarioVolta;
  final String status;

  RegistroViagem({
    required this.data,
    this.horarioEmbarque,
    this.horarioChegadaEscola,
    this.horarioVolta,
    required this.status,
  });
}

// ─── Posição van ─────────────────────────────────────────────────────────────
class VanPosition {
  final double lat;
  final double lng;
  final double velocidade;
  final String motorista;
  final bool emRota;

  VanPosition({
    required this.lat,
    required this.lng,
    required this.velocidade,
    required this.motorista,
    this.emRota = true,
  });
}
