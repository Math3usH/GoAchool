import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class HistoricoTab extends StatelessWidget {
  const HistoricoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final fmt = DateFormat('dd/MM', 'pt_BR');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📅 Histórico de viagens', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy)),
            const SizedBox(height: 14),
            // Header
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Expanded(flex: 2, child: Text('Data', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.gray400))),
                Expanded(flex: 2, child: Text('Embarque', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.gray400))),
                Expanded(flex: 2, child: Text('Escola', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.gray400))),
                Expanded(flex: 2, child: Text('Volta', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.gray400))),
                Expanded(flex: 3, child: Text('Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.gray400))),
              ]),
            ),
            const Divider(color: AppTheme.gray200, thickness: 1.5),
            ...state.historico.map((v) => _HistRow(viagem: v, fmt: fmt)),
          ]),
        )),
        const SizedBox(height: 14),

        // Resumo
        const Card(
          color: AppTheme.navy,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('📊 Resumo do mês', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.yellow)),
              SizedBox(height: 14),
              Row(children: [
                _ResumoItem(valor: '18', label: 'Dias presentes', cor: AppTheme.green),
                _ResumoItem(valor: '1', label: 'Faltas', cor: AppTheme.red),
                _ResumoItem(valor: '1', label: 'Atrasos', cor: AppTheme.orange),
                _ResumoItem(valor: '96%', label: 'Pontualidade', cor: AppTheme.yellow),
              ]),
            ]),
          ),
        ),
      ],
    );
  }
}

class _HistRow extends StatelessWidget {
  final RegistroViagem viagem;
  final dynamic fmt;
  const _HistRow({required this.viagem, required this.fmt});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBg;
    switch (viagem.status) {
      case 'Normal': statusColor = const Color(0xFF166534); statusBg = AppTheme.greenLight; break;
      case 'Atraso': statusColor = const Color(0xFF9A3412); statusBg = AppTheme.orangeLight; break;
      case 'Faltou': statusColor = AppTheme.gray600; statusBg = AppTheme.gray200; break;
      default: statusColor = AppTheme.gray600; statusBg = AppTheme.gray200;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Expanded(flex: 2, child: Text(fmt.format(viagem.data), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.navy))),
        Expanded(flex: 2, child: Text(viagem.horarioEmbarque ?? '—', style: const TextStyle(fontSize: 13, color: AppTheme.gray600))),
        Expanded(flex: 2, child: Text(viagem.horarioChegadaEscola ?? '—', style: const TextStyle(fontSize: 13, color: AppTheme.gray600))),
        Expanded(flex: 2, child: Text(viagem.horarioVolta ?? '—', style: const TextStyle(fontSize: 13, color: AppTheme.gray600))),
        Expanded(flex: 3, child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10)),
          child: Text(viagem.status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: statusColor)),
        )),
      ]),
    );
  }
}

class _ResumoItem extends StatelessWidget {
  final String valor;
  final String label;
  final Color cor;
  const _ResumoItem({required this.valor, required this.label, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(children: [
      Text(valor, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: cor)),
      Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.gray400), textAlign: TextAlign.center),
    ]));
  }
}
