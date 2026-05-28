import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';

class ChecklistTab extends StatelessWidget {
  const ChecklistTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final pendentes = state.totalPendentes;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Alerta
        AlertBanner(
          message: pendentes > 0
              ? '⚠️ $pendentes aluno(s) ainda não verificados no embarque.'
              : '✅ Todos os alunos foram verificados!',
          color: pendentes > 0 ? const Color(0xFF9A3412) : const Color(0xFF166534),
          bg: pendentes > 0 ? AppTheme.orangeLight : AppTheme.greenLight,
          icon: pendentes > 0 ? Icons.warning_amber_rounded : Icons.check_circle_rounded,
        ),
        const SizedBox(height: 14),

        // Embarque
        SectionCard(
          title: '🚌 Embarque — Manhã',
          child: Column(children: state.alunos.map((a) => _CheckRow(
            aluno: a,
            status: state.embarqueStatus[a.id] ?? CheckStatus.pendente,
            onChanged: (s) => state.setEmbarque(a.id, s),
          )).toList()),
        ),
        const SizedBox(height: 14),

        // Desembarque
        SectionCard(
          title: '🏫 Desembarque na escola',
          child: Column(children: state.alunos.map((a) => _CheckRow(
            aluno: a,
            status: state.desembarqueStatus[a.id] ?? CheckStatus.pendente,
            onChanged: (s) => state.setDesembarque(a.id, s),
          )).toList()),
        ),
        const SizedBox(height: 14),

        // Resumo
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(16)),
          child: Column(children: [
            const Text('📊 Resumo do dia', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.yellow)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _ResumoNum(valor: state.totalPresentes, label: 'Embarcaram', cor: AppTheme.green),
              _ResumoNum(valor: state.totalAusentes, label: 'Não vieram', cor: AppTheme.red),
              _ResumoNum(valor: state.totalPendentes, label: 'Pendente', cor: AppTheme.yellow),
            ]),
          ]),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  final Aluno aluno;
  final CheckStatus status;
  final ValueChanged<CheckStatus> onChanged;

  const _CheckRow({required this.aluno, required this.status, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        AvatarCircle(iniciais: aluno.iniciais, size: 40),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(aluno.nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.navy)),
          Text('${aluno.turma}  •  ${aluno.endereco}', style: const TextStyle(fontSize: 11, color: AppTheme.gray400)),
        ])),
        Row(children: [
          _CheckBtn(icon: Icons.check_rounded, selected: status == CheckStatus.presente, activeColor: AppTheme.green, activeBg: AppTheme.greenLight, onTap: () => onChanged(CheckStatus.presente)),
          const SizedBox(width: 6),
          _CheckBtn(icon: Icons.close_rounded, selected: status == CheckStatus.ausente, activeColor: AppTheme.red, activeBg: AppTheme.redLight, onTap: () => onChanged(CheckStatus.ausente)),
        ]),
      ]),
    );
  }
}

class _CheckBtn extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Color activeColor;
  final Color activeBg;
  final VoidCallback onTap;

  const _CheckBtn({required this.icon, required this.selected, required this.activeColor, required this.activeBg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38, height: 38,
        decoration: BoxDecoration(
          color: selected ? activeBg : AppTheme.gray100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? activeColor : AppTheme.gray200, width: 1.5),
        ),
        child: Icon(icon, size: 20, color: selected ? activeColor : AppTheme.gray300),
      ),
    );
  }
}

class _ResumoNum extends StatelessWidget {
  final int valor;
  final String label;
  final Color cor;
  const _ResumoNum({required this.valor, required this.label, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('$valor', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: cor)),
      Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
    ]);
  }
}
