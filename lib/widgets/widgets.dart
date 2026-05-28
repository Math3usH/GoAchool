import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ─── GoSchool AppBar ──────────────────────────────────────────────────────────
class GoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String nomeUsuario;
  final int notifCount;
  final VoidCallback onNotif;
  final VoidCallback onLogout;

  const GoAppBar({
    super.key,
    required this.nomeUsuario,
    required this.notifCount,
    required this.onNotif,
    required this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: AppTheme.yellow, borderRadius: BorderRadius.circular(8)),
          child: const Center(child: Text('🚌', style: TextStyle(fontSize: 16))),
        ),
        const SizedBox(width: 8),
        RichText(text: const TextSpan(
          style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w900),
          children: [
            TextSpan(text: 'go', style: TextStyle(color: Colors.white)),
            TextSpan(text: 'School', style: TextStyle(color: AppTheme.yellow)),
          ],
        )),
      ]),
      actions: [
        Stack(children: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded, color: Colors.white),
            onPressed: onNotif,
          ),
          if (notifCount > 0)
            Positioned(
              right: 6, top: 6,
              child: Container(
                width: 16, height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.red,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.navy, width: 1.5),
                ),
                child: Center(child: Text('$notifCount', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800))),
              ),
            ),
        ]),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextButton(
            onPressed: onLogout,
            child: Text(nomeUsuario, style: const TextStyle(color: AppTheme.gray300, fontFamily: 'Nunito', fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color iconBg;

  const StatCard({super.key, required this.icon, required this.value, required this.label, required this.iconBg});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.navy)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.gray400, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

// ─── Section Card ─────────────────────────────────────────────────────────────
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const SectionCard({super.key, required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy))),
            if (trailing != null) trailing!,
          ]),
          const SizedBox(height: 12),
          child,
        ]),
      ),
    );
  }
}

// ─── Avatar Circle ────────────────────────────────────────────────────────────
class AvatarCircle extends StatelessWidget {
  final String iniciais;
  final double size;
  final Color bg;
  final Color fg;

  const AvatarCircle({super.key, required this.iniciais, this.size = 44, this.bg = AppTheme.navyLight, this.fg = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(child: Text(iniciais, style: TextStyle(color: fg, fontSize: size * 0.35, fontWeight: FontWeight.w700))),
    );
  }
}

// ─── ETA Box ─────────────────────────────────────────────────────────────────
class EtaBox extends StatelessWidget {
  final String icon;
  final String label;
  final String hora;
  final String sub;
  final Color bg;

  const EtaBox({super.key, required this.icon, required this.label, required this.hora, required this.sub, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
          Text(hora, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.yellow)),
          Text(sub, style: const TextStyle(fontSize: 12, color: AppTheme.gray300)),
        ])),
      ]),
    );
  }
}

// ─── Notif Item ───────────────────────────────────────────────────────────────
class NotifItem extends StatelessWidget {
  final Notificacao notif;

  const NotifItem({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notif.lida ? AppTheme.gray100 : AppTheme.yellowLight,
        borderRadius: BorderRadius.circular(12),
        border: notif.lida ? null : const Border(left: BorderSide(color: AppTheme.yellowDark, width: 3)),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: notif.color.withOpacity(0.15), shape: BoxShape.circle),
          child: Icon(notif.icon, color: notif.color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(notif.titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.navy)),
          Text(notif.descricao, style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
        ])),
        if (!notif.lida)
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppTheme.yellow, shape: BoxShape.circle)),
      ]),
    );
  }
}

// ─── Alert Banner ─────────────────────────────────────────────────────────────
class AlertBanner extends StatelessWidget {
  final String message;
  final Color color;
  final Color bg;
  final IconData icon;

  const AlertBanner({super.key, required this.message, required this.color, required this.bg, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color))),
      ]),
    );
  }
}
