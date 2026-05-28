import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class AlunosTab extends StatefulWidget {
  const AlunosTab({super.key});

  @override
  State<AlunosTab> createState() => _AlunosTabState();
}

class _AlunosTabState extends State<AlunosTab> {
  final _nomeCtrl = TextEditingController();
  final _turmaCtrl = TextEditingController();
  final _endCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  bool _expandForm = false;

  Future<void> _salvar() async {
    if (_nomeCtrl.text.trim().isEmpty || _endCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome e endereço são obrigatórios!'), backgroundColor: AppTheme.red),
      );
      return;
    }
    await context.read<AppState>().adicionarAluno(Aluno(
      id: 0,
      nome: _nomeCtrl.text.trim(),
      turma: _turmaCtrl.text.trim().isEmpty ? '—' : _turmaCtrl.text.trim(),
      endereco: _endCtrl.text.trim(),
      telefoneResponsavel: _telCtrl.text.trim().isEmpty ? '—' : _telCtrl.text.trim(),
    ));
    _nomeCtrl.clear(); _turmaCtrl.clear(); _endCtrl.clear(); _telCtrl.clear();
    setState(() => _expandForm = false);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Aluno cadastrado com sucesso!'), backgroundColor: AppTheme.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Formulário
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
              onTap: () => setState(() => _expandForm = !_expandForm),
              child: Row(children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(color: AppTheme.yellowLight, borderRadius: BorderRadius.circular(8)),
                  child: Icon(_expandForm ? Icons.remove : Icons.add, color: AppTheme.yellowDark, size: 20),
                ),
                const SizedBox(width: 10),
                const Text('Cadastrar novo aluno', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy)),
              ]),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: _expandForm ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Nome completo *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.gray600)),
                    const SizedBox(height: 6),
                    TextField(controller: _nomeCtrl, decoration: const InputDecoration(hintText: 'Nome do aluno', prefixIcon: Icon(Icons.person_outline))),
                  ])),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Turma', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.gray600)),
                    const SizedBox(height: 6),
                    TextField(controller: _turmaCtrl, decoration: const InputDecoration(hintText: '3A')),
                  ])),
                ]),
                const SizedBox(height: 12),
                const Text('Endereço de embarque *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.gray600)),
                const SizedBox(height: 6),
                TextField(controller: _endCtrl, decoration: const InputDecoration(hintText: 'Rua, número, bairro', prefixIcon: Icon(Icons.location_on_outlined))),
                const SizedBox(height: 12),
                const Text('Telefone do responsável', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.gray600)),
                const SizedBox(height: 6),
                TextField(controller: _telCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(hintText: '(49) 99999-9999', prefixIcon: Icon(Icons.phone_outlined))),
                const SizedBox(height: 16),
                SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _salvar, icon: const Icon(Icons.save_rounded), label: const Text('Cadastrar aluno'))),
              ]) : const SizedBox.shrink(),
            ),
          ]),
        )),
        const SizedBox(height: 14),

        // Lista
        SectionCard(
          title: '👥 Alunos cadastrados',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.blueLight, borderRadius: BorderRadius.circular(20)),
            child: Text('${state.alunos.length} alunos', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF))),
          ),
          child: state.loadingAlunos
              ? const Center(child: CircularProgressIndicator())
              : state.alunos.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Nenhum aluno cadastrado ainda.', style: TextStyle(color: AppTheme.gray400)),
                    )
                  : Column(children: state.alunos.map((a) => _AlunoCard(aluno: a)).toList()),
        ),
      ],
    );
  }
}

class _AlunoCard extends StatelessWidget {
  final Aluno aluno;
  const _AlunoCard({required this.aluno});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppTheme.gray100, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        AvatarCircle(iniciais: aluno.iniciais),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(aluno.nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.navy)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: aluno.ativo ? AppTheme.greenLight : AppTheme.gray200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(aluno.ativo ? 'Ativo' : 'Inativo', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: aluno.ativo ? const Color(0xFF166534) : AppTheme.gray600)),
            ),
          ]),
          const SizedBox(height: 2),
          Text('${aluno.turma}  •  📍 ${aluno.endereco}', style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
          Text('📞 ${aluno.telefoneResponsavel}', style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
        ])),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.red, size: 20),
          onPressed: () => _confirmRemove(context, aluno),
        ),
      ]),
    );
  }

  Future<void> _confirmRemove(BuildContext context, Aluno aluno) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remover aluno?'),
        content: Text('Deseja remover ${aluno.nome} da lista?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remover', style: TextStyle(color: AppTheme.red))),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<AppState>().removerAluno(aluno.id);
    }
  }
}
