import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class NotificacoesTab extends StatelessWidget {
  const NotificacoesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Row(children: [
          Expanded(child: Text(
            '${state.notifNaoLidas} não lidas',
            style: const TextStyle(fontSize: 13, color: AppTheme.gray400, fontWeight: FontWeight.w600),
          )),
          if (state.notifNaoLidas > 0)
            TextButton(
              onPressed: state.marcarTodasLidas,
              child: const Text('Marcar todas como lidas', style: TextStyle(fontSize: 13, color: AppTheme.yellowDark, fontWeight: FontWeight.w700)),
            ),
        ]),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.notificacoes.length,
          itemBuilder: (_, i) => NotifItem(notif: state.notificacoes[i]),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state.simularNotificacao,
            icon: const Icon(Icons.add_alert_rounded),
            label: const Text('Simular nova notificação'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.navy, foregroundColor: AppTheme.yellow),
          ),
        ),
      ),
    ]);
  }
}
