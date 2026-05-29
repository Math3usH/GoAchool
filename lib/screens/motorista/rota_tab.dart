import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../services/directions_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class RotaTab extends StatefulWidget {
  const RotaTab({super.key});
  @override
  State<RotaTab> createState() => _RotaTabState();
}

class _RotaTabState extends State<RotaTab> {
  GoogleMapController? _mapController;
  bool _gerando = false;
  List<LatLng> _rotaPoints = [];
  bool _carregandoRota = false;

  // Guarda os IDs da última rota carregada para detectar mudanças
  List<int> _ultimaRotaIds = [];

  final LatLng _garagem = const LatLng(-26.3150, -48.8600); // Garagem — Joinville
  final LatLng _escola  = const LatLng(-26.2920, -48.8430); // Escola — Joinville

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregarRota());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recarrega a rota sempre que a lista de alunos ativos mudar
    final rota = context.read<AppState>().rotaOrdenada;
    final ids = rota.map((a) => a.id).toList();
    if (!_listasIguais(ids, _ultimaRotaIds)) {
      _ultimaRotaIds = ids;
      WidgetsBinding.instance.addPostFrameCallback((_) => _carregarRota());
    }
  }

  bool _listasIguais(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Future<void> _carregarRota() async {
    final state = context.read<AppState>();
    final rota = state.rotaOrdenada;

    if (rota.isEmpty) {
      if (mounted) setState(() { _rotaPoints = []; _carregandoRota = false; });
      return;
    }

    setState(() => _carregandoRota = true);

    final waypoints = rota.map((a) => LatLng(a.lat, a.lng)).toList();
    final points = await DirectionsService.getRoute(
      origin: _garagem,
      destination: _escola,
      waypoints: waypoints,
    );

    if (mounted) setState(() { _rotaPoints = points; _carregandoRota = false; });

    if (points.isNotEmpty && _mapController != null) {
      final bounds = _boundsFromLatLngList(points);
      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  Set<Marker> _buildMarkers(List alunos) {
    final markers = <Marker>{};
    markers.add(Marker(markerId: const MarkerId('garagem'), position: _garagem, infoWindow: const InfoWindow(title: '🏠 Garagem — Partida'), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
    markers.add(Marker(markerId: const MarkerId('escola'), position: _escola, infoWindow: const InfoWindow(title: '🏫 Escola Estadual Boa Vista'), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
    for (var i = 0; i < alunos.length; i++) {
      final a = alunos[i];
      markers.add(Marker(markerId: MarkerId('aluno_$i'), position: LatLng(a.lat, a.lng), infoWindow: InfoWindow(title: '${i + 1}. ${a.nome}', snippet: a.endereco), icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)));
    }
    return markers;
  }

  Set<Polyline> _buildRoute() {
    if (_rotaPoints.isEmpty) return {};
    return {
      Polyline(
        polylineId: const PolylineId('rota_motorista'),
        color: AppTheme.yellow,
        width: 5,
        points: _rotaPoints,
      ),
    };
  }

  Future<void> _gerarRota() async {
    setState(() => _gerando = true);
    await _carregarRota();
    if (mounted) {
      setState(() => _gerando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Rota otimizada gerada!'), backgroundColor: AppTheme.green, behavior: SnackBarBehavior.floating),
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
        GridView.count(
          crossAxisCount: 3, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
          children: [
            StatCard(icon: '👦', value: '$ativos', label: 'Confirmados', iconBg: AppTheme.yellowLight),
            const StatCard(icon: '📏', value: '12,4 km', label: 'Distância total', iconBg: AppTheme.greenLight),
            const StatCard(icon: '⏱️', value: '32 min', label: 'Tempo estimado', iconBg: AppTheme.blueLight),
          ],
        ),
        const SizedBox(height: 14),

        Card(child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text('🗺️ Rota otimizada', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.greenLight, borderRadius: BorderRadius.circular(20)),
                child: const Text('Modo carro ✓', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF166534))),
              ),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 280,
                child: Stack(children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(target: _garagem, zoom: 13),
                    onMapCreated: (c) async {
                      _mapController = c;
                      await _carregarRota();
                    },
                    markers: _buildMarkers(rota),
                    polylines: _buildRoute(),
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: true,
                    mapToolbarEnabled: false,
                  ),
                  if (_carregandoRota)
                    Container(
                      color: Colors.black26,
                      child: const Center(child: CircularProgressIndicator(color: AppTheme.yellow)),
                    ),
                ]),
              ),
            ),
          ]),
        )),
        const SizedBox(height: 14),

        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📍 Ordem de paradas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy)),
            const SizedBox(height: 14),
            _RotaStep(numero: '🏠', titulo: 'Partida — Garagem', subtitulo: 'Início da rota', isLast: false, cor: AppTheme.blue),
            ...List.generate(rota.length, (i) => _RotaStep(
              numero: '${i + 1}',
              titulo: rota[i].nome,
              subtitulo: rota[i].endereco,
              isLast: false,
              cor: const Color(0xFF8B5CF6),
            )),
            _RotaStep(numero: '🏫', titulo: 'Escola Estadual Boa Vista', subtitulo: 'Destino final', isLast: true, cor: AppTheme.red),
          ]),
        )),
        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _gerando ? null : _gerarRota,
            icon: _gerando
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.navy))
                : const Icon(Icons.refresh_rounded),
            label: Text(_gerando ? 'Calculando rota...' : '🔄 Regenerar rota otimizada'),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.navy, foregroundColor: AppTheme.yellow, padding: const EdgeInsets.symmetric(vertical: 14)),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double minLat = list[0].latitude, maxLat = list[0].latitude;
    double minLng = list[0].longitude, maxLng = list[0].longitude;
    for (final p in list) {
      if (p.latitude < minLat) minLat = p.latitude;
      if (p.latitude > maxLat) maxLat = p.latitude;
      if (p.longitude < minLng) minLng = p.longitude;
      if (p.longitude > maxLng) maxLng = p.longitude;
    }
    return LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng));
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