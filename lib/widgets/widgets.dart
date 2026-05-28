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
                decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.navy, width: 1.5)),
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
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppTheme.navy)),
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.gray400, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const StatusBadge({super.key, required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.gray400)),
          Text(hora, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: AppTheme.yellow)),
          Text(sub, style: const TextStyle(fontSize: 13, color: AppTheme.gray300)),
        ]),
      ]),
    );
  }
}

// ─── Mapa Placeholder ─────────────────────────────────────────────────────────
class MapaPlaceholder extends StatelessWidget {
  final double height;
  final String velocidade;
  final String motorista;

  const MapaPlaceholder({super.key, this.height = 300, required this.velocidade, required this.motorista});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFD4E8D4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(children: [
        // Grid lines
        CustomPaint(painter: _GridPainter(), size: Size.infinite),
        // Centros
        Positioned(left: 40, top: height * 0.55, child: _pin('🏠', 'Casa')),
        Positioned(left: 140, top: height * 0.38, child: _pin('👦', 'P.2')),
        Positioned(left: 260, top: height * 0.32, child: _pin('👧', 'P.3')),
        Positioned(right: 60, bottom: height * 0.38, child: _pin('🏫', 'Escola', color: Colors.red)),
        // Van animada
        _AnimatedVan(height: height),
        // Info overlay
        Positioned(
          bottom: 12, left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Motorista', style: TextStyle(fontSize: 11, color: AppTheme.gray400)),
              Text(motorista, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.navy)),
              Text('$velocidade km/h', style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
            ]),
          ),
        ),
        Positioned(
          top: 12, right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: AppTheme.green, shape: BoxShape.circle)),
              const SizedBox(width: 5),
              const Text('AO VIVO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.navy)),
            ]),
          ),
        ),
        Positioned(
          bottom: 8, right: 12,
          child: Text('* Google Maps disponível com chave API', style: TextStyle(fontSize: 10, color: Colors.black38)),
        ),
      ]),
    );
  }

  Widget _pin(String emoji, String label, {Color color = const Color(0xFF8B5CF6)}) {
    return Column(children: [
      Container(
        width: 28, height: 28,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)]),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 13))),
      ),
      const SizedBox(height: 3),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
        child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.navy)),
      ),
    ]);
  }
}

class _AnimatedVan extends StatefulWidget {
  final double height;
  const _AnimatedVan({required this.height});
  @override
  State<_AnimatedVan> createState() => _AnimatedVanState();
}

class _AnimatedVanState extends State<_AnimatedVan> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    _anim = TweenSequence<Offset>([
      TweenSequenceItem(tween: Tween(begin: const Offset(0.05, 0.5), end: const Offset(0.2, 0.4)), weight: 20),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.2, 0.4), end: const Offset(0.4, 0.3)), weight: 25),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.4, 0.3), end: const Offset(0.6, 0.4)), weight: 25),
      TweenSequenceItem(tween: Tween(begin: const Offset(0.6, 0.4), end: const Offset(0.82, 0.45)), weight: 30),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        return Positioned(
          left: _anim.value.dx * (MediaQuery.of(context).size.width - 100),
          top: _anim.value.dy * widget.height,
          child: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: AppTheme.yellow, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)]),
            child: const Center(child: Text('🚐', style: TextStyle(fontSize: 18))),
          ),
        );
      },
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 10;
    for (double y = 0; y < size.height; y += size.height / 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += size.width / 4) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
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
        border: notif.lida ? null : Border(left: BorderSide(color: AppTheme.yellowDark, width: 3)),
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
          Container(width: 8, height: 8, decoration: BoxDecoration(color: AppTheme.yellow, shape: BoxShape.circle)),
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
