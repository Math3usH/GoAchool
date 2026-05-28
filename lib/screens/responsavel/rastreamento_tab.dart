import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class RastreamentoTab extends StatelessWidget {
  const RastreamentoTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stats
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.1,
          children: const [
            StatCard(icon: '🚌', value: '3,2 km', label: 'Distância hoje', iconBg: AppTheme.yellowLight),
            StatCard(icon: '✅', value: '18', label: 'Dias no mês', iconBg: AppTheme.greenLight),
            StatCard(icon: '⏰', value: '96%', label: 'Pontualidade', iconBg: AppTheme.blueLight),
          ],
        ),
        const SizedBox(height: 14),

        // ETAs
        Row(children: [
          Expanded(child: EtaBox(icon: '🏫', label: 'Chegada na escola', hora: state.etaEscola, sub: 'Previsão estimada', bg: AppTheme.navy)),
          const SizedBox(width: 10),
          Expanded(child: EtaBox(icon: '🏠', label: 'Busca à tarde', hora: state.etaVolta, sub: 'Previsão estimada', bg: AppTheme.navyMid)),
        ]),
        const SizedBox(height: 14),

        // Status Lucas
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📍 Status atual de Lucas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy)),
            const SizedBox(height: 12),
            Row(children: [
              _StatusPill(status: state.statusFilho, emRota: state.vanEmRota),
              const Spacer(),
              Text('${(state.progressoRota * 100).round()}% da rota', style: const TextStyle(fontSize: 13, color: AppTheme.gray400, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.progressoRota,
                minHeight: 8,
                backgroundColor: AppTheme.gray200,
                valueColor: AlwaysStoppedAnimation<Color>(state.vanEmRota ? AppTheme.yellow : AppTheme.orange),
              ),
            ),
            const SizedBox(height: 8),
            Text('Última atualização: ${_horaAtual()}', style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
          ]),
        )),
        const SizedBox(height: 14),

        // Mapa
        Card(child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('🗺️ Localização em tempo real', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy)),
            const SizedBox(height: 12),
            MapaPlaceholder(
              height: 280,
              velocidade: state.vanVelocidade.round().toString(),
              motorista: 'Carlos Fernandes',
            ),
          ]),
        )),
        const SizedBox(height: 14),

        // Alertas
        AlertBanner(
          message: '✅ Lucas entrou na van às 07:20 — Rua das Flores, 148',
          color: const Color(0xFF166534),
          bg: AppTheme.greenLight,
          icon: Icons.check_circle_rounded,
        ),
        if (!state.vanEmRota) ...[
          const SizedBox(height: 10),
          AlertBanner(
            message: '⚠️ Atenção! A van saiu do trajeto padrão.',
            color: const Color(0xFF9A3412),
            bg: AppTheme.orangeLight,
            icon: Icons.warning_amber_rounded,
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  String _horaAtual() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  final bool emRota;
  const _StatusPill({required this.status, required this.emRota});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: emRota ? AppTheme.greenLight : AppTheme.orangeLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: emRota ? AppTheme.green : AppTheme.orange,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          status,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: emRota ? const Color(0xFF166534) : const Color(0xFF9A3412),
          ),
        ),
      ]),
    );
  }
}
