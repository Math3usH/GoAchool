import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';
import '../login_screen.dart';
import 'alunos_tab.dart';
import 'rota_tab.dart';
import 'checklist_tab.dart';

class MotoristaScreen extends StatefulWidget {
  const MotoristaScreen({super.key});

  @override
  State<MotoristaScreen> createState() => _MotoristaScreenState();
}

class _MotoristaScreenState extends State<MotoristaScreen> {
  int _tab = 0;

  void _logout() {
    context.read<AppState>().logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: GoAppBar(
        nomeUsuario: state.nomeUsuario,
        notifCount: 0,
        onNotif: () {},
        onLogout: _logout,
      ),
      body: Column(children: [
        _buildTabs(),
        Expanded(child: _buildTabContent()),
      ]),
    );
  }

  Widget _buildTabs() {
    final tabs = [
      (Icons.people_rounded, 'Alunos'),
      (Icons.map_rounded, 'Rota do Dia'),
      (Icons.checklist_rounded, 'Checklist'),
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppTheme.gray200, borderRadius: BorderRadius.circular(12)),
      child: Row(children: List.generate(tabs.length, (i) {
        final selected = _tab == i;
        return Expanded(child: GestureDetector(
          onTap: () => setState(() => _tab = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selected ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(tabs[i].$1, size: 16, color: selected ? AppTheme.navy : AppTheme.gray400),
              const SizedBox(width: 5),
              Text(tabs[i].$2, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: selected ? AppTheme.navy : AppTheme.gray400)),
            ]),
          ),
        ));
      })),
    );
  }

  Widget _buildTabContent() {
    switch (_tab) {
      case 0: return const AlunosTab();
      case 1: return const RotaTab();
      case 2: return const ChecklistTab();
      default: return const SizedBox();
    }
  }
}
