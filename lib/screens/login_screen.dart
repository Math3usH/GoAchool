import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/app_theme.dart';
import 'responsavel/responsavel_screen.dart';
import 'motorista/motorista_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _role = 'responsavel';
  final _emailCtrl = TextEditingController(text: 'responsavel@demo.com');
  final _senhaCtrl = TextEditingController(text: '123456');
  bool _loading = false;
  bool _obscure = true;

  Future<void> _login() async {
    if (_emailCtrl.text.isEmpty || _senhaCtrl.text.isEmpty) {
      _showError('Preencha e-mail e senha!');
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    await context.read<AppState>().login(_emailCtrl.text, _senhaCtrl.text, _role);
    setState(() => _loading = false);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => _role == 'responsavel'
            ? const ResponsavelScreen()
            : const MotoristaScreen(),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppTheme.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: Stack(children: [
        // Decoração de fundo
        Positioned(top: -100, right: -80, child: Container(width: 350, height: 350, decoration: BoxDecoration(color: AppTheme.yellow.withOpacity(0.07), shape: BoxShape.circle))),
        Positioned(bottom: -60, left: -60, child: Container(width: 250, height: 250, decoration: BoxDecoration(color: AppTheme.yellow.withOpacity(0.05), shape: BoxShape.circle))),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // Logo
                      Row(children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(color: AppTheme.yellow, borderRadius: BorderRadius.circular(12)),
                          child: const Center(child: Text('🚌', style: TextStyle(fontSize: 24))),
                        ),
                        const SizedBox(width: 12),
                        RichText(text: const TextSpan(
                          style: TextStyle(fontFamily: 'Nunito', fontSize: 28, fontWeight: FontWeight.w900),
                          children: [
                            TextSpan(text: 'go', style: TextStyle(color: AppTheme.navy)),
                            TextSpan(text: 'School', style: TextStyle(color: AppTheme.yellowDark)),
                          ],
                        )),
                      ]),
                      const SizedBox(height: 24),
                      const Text('Bem-vindo de volta!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.navy)),
                      const SizedBox(height: 4),
                      const Text('Selecione seu perfil para continuar.', style: TextStyle(fontSize: 14, color: AppTheme.gray400)),
                      const SizedBox(height: 24),

                      // Role tabs
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: AppTheme.gray200, borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [
                          _RoleTab(label: '👨‍👩‍👧 Responsável', value: 'responsavel', selected: _role == 'responsavel', onTap: () { setState(() { _role = 'responsavel'; _emailCtrl.text = 'responsavel@demo.com'; }); }),
                          const SizedBox(width: 4),
                          _RoleTab(label: '🚐 Motorista', value: 'motorista', selected: _role == 'motorista', onTap: () { setState(() { _role = 'motorista'; _emailCtrl.text = 'motorista@demo.com'; }); }),
                        ]),
                      ),
                      const SizedBox(height: 22),

                      // E-mail
                      const Text('E-mail', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.gray600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(hintText: 'seu@email.com', prefixIcon: Icon(Icons.email_outlined)),
                      ),
                      const SizedBox(height: 14),

                      // Senha
                      const Text('Senha', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.gray600)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _senhaCtrl,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          child: _loading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.navy))
                              : const Text('Entrar'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppTheme.gray100, borderRadius: BorderRadius.circular(10)),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: AppTheme.gray400),
                            children: [
                              TextSpan(text: 'Demo: '),
                              TextSpan(text: 'responsavel@demo.com', style: TextStyle(color: AppTheme.navy, fontWeight: FontWeight.w700)),
                              TextSpan(text: ' ou '),
                              TextSpan(text: 'motorista@demo.com', style: TextStyle(color: AppTheme.navy, fontWeight: FontWeight.w700)),
                              TextSpan(text: ' — senha: '),
                              TextSpan(text: '123456', style: TextStyle(color: AppTheme.navy, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _RoleTab extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _RoleTab({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected ? [BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
            border: selected ? Border.all(color: AppTheme.yellowDark.withOpacity(0.3)) : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? AppTheme.navy : AppTheme.gray600,
            ),
          ),
        ),
      ),
    );
  }
}
