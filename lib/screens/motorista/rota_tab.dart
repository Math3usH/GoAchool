import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class RotaTab extends StatefulWidget {
  const RotaTab({super.key});

  @override
  State<RotaTab> createState() => _RotaTabState();
}

class _RotaTabState extends State<RotaTab> {
  bool _gerando = false;

  Future<void> _gerarRota() async {
    setState(() => _gerando = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      setState(() => _gerando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Rota otimizada gerada com sucesso!'),
          backgroundColor: AppTheme.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final rota = state.rotaOrdenada;
    final ativos = state.alunos.where((a) => a.ativo).length;

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
          children: [
            StatCard(icon: '👦', value: '$ativos', label: 'Confirmados', iconBg: AppTheme.yellowLight),
            const StatCard(icon: '📏', value: '12,4 km', label: 'Distância total', iconBg: AppTheme.greenLight),
            const StatCard(icon: '⏱️', value: '32 min', label: 'Tempo estimado', iconBg: AppTheme.blueLight),
          ],
        ),
        const SizedBox(height: 14),

        // Mapa
        Card(child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text('🗺️ Rota otimizada', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.greenLight, borderRadius: BorderRadius.circular(20)),
                child: const Text('Otimizada ✓', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF166534))),
              ),
            ]),
            const SizedBox(height: 12),
            MapaPlaceholder(height: 240, velocidade: '0', motorista: 'Carlos Fernandes'),
          ]),
        )),
        const SizedBox(height: 14),

        // Ordem de paradas
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📍 Ordem de paradas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy)),
            const SizedBox(height: 14),

            // Partida
            _RotaStep(numero: '🏠', titulo: 'Partida — Garagem', subtitulo: 'Início da rota', isLast: false, cor: AppTheme.blue),
            ...List.generate(rota.length, (i) {
              final aluno = rota[i];
              return _RotaStep(
                numero: '${i + 1}',
                titulo: aluno.nome,
                subtitulo: aluno.endereco,
                isLast: false,
                cor: const Color(0xFF8B5CF6),
              );
            }),
            _RotaStep(numero: '🏫', titulo: 'Escola Estadual Boa Vista', subtitulo: 'Destino final', isLast: true, cor: AppTheme.red),
          ]),
        )),
        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _gerando ? null : _gerarRota,
            icon: _gerando ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.navy)) : const Icon(Icons.refresh_rounded),
            label: Text(_gerando ? 'Calculando rota...' : '🔄 Regenerar rota otimizada'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.navy, foregroundColor: AppTheme.yellow, padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '* Algoritmo: menor distância total entre paradas. Na versão completa usa Google Maps Directions API.',
          style: TextStyle(fontSize: 11, color: AppTheme.gray400),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _RotaStep extends StatelessWidget {
  final String numero;
  final String titulo;
  final String subtitulo;
  final bool isLast;
  final Color cor;

  const _RotaStep({required this.numero, required this.titulo, required this.subtitulo, required this.isLast, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(color: cor.withOpacity(0.15), shape: BoxShape.circle),
          child: Center(child: Text(numero, style: TextStyle(fontSize: numero.length > 1 ? 14 : 13, fontWeight: FontWeight.w700, color: cor))),
        ),
        if (!isLast) Container(width: 2, height: 30, color: AppTheme.gray200),
      ]),
      const SizedBox(width: 12),
      Expanded(child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.navy)),
          Text(subtitulo, style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
          SizedBox(height: isLast ? 0 : 16),
        ]),
      )),
    ]);
  }
}
