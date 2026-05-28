import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';
import '../login_screen.dart';
import 'rastreamento_tab.dart';
import 'notificacoes_tab.dart';
import 'historico_tab.dart';

class ResponsavelScreen extends StatefulWidget {
  const ResponsavelScreen({super.key});

  @override
  State<ResponsavelScreen> createState() => _ResponsavelScreenState();
}

class _ResponsavelScreenState extends State<ResponsavelScreen> {
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
        notifCount: state.notifNaoLidas,
        onNotif: () => setState(() => _tab = 1),
        onLogout: _logout,
      ),
      body: Column(children: [
        _buildConfirmBanner(state),
        _buildTabs(),
        Expanded(child: _buildTabContent(state)),
      ]),
    );
  }

  Widget _buildConfirmBanner(AppState state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: state.filhoConfirmado ? AppTheme.greenLight : AppTheme.yellowLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: state.filhoConfirmado ? AppTheme.green : AppTheme.yellow, width: 1.5),
      ),
      child: Row(children: [
        Text(state.filhoConfirmado ? '✅' : '📋', style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Lucas vai à escola hoje?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppTheme.navy)),
          Text(
            state.filhoConfirmado ? 'Confirmado! O motorista será notificado.' : 'Confirme para garantir a vaga na van.',
            style: const TextStyle(fontSize: 12, color: AppTheme.gray600),
          ),
        ])),
        GestureDetector(
          onTap: state.toggleConfirmacao,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 52, height: 28,
            decoration: BoxDecoration(
              color: state.filhoConfirmado ? AppTheme.green : AppTheme.gray300,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                left: state.filhoConfirmado ? 26 : 4, top: 4,
                child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildTabs() {
    final tabs = [
      (Icons.map_rounded, 'Rastreamento'),
      (Icons.notifications_rounded, 'Notificações'),
      (Icons.calendar_month_rounded, 'Histórico'),
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

  Widget _buildTabContent(AppState state) {
    switch (_tab) {
      case 0: return const RastreamentoTab();
      case 1: return const NotificacoesTab();
      case 2: return const HistoricoTab();
      default: return const SizedBox();
    }
  }
}
