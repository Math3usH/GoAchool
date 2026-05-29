import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../services/directions_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class RastreamentoTab extends StatefulWidget {
  const RastreamentoTab({super.key});
  @override
  State<RastreamentoTab> createState() => _RastreamentoTabState();
}

class _RastreamentoTabState extends State<RastreamentoTab> {
  GoogleMapController? _mapController;
  List<LatLng> _rotaPoints = [];

  final _schoolPos = const LatLng(-26.2920, -48.8430); // Escola — Joinville
  final List<LatLng> _paradas = const [
    LatLng(-26.3044, -48.8487), // Lucas — Bom Retiro
    LatLng(-26.3020, -48.8456), // Ana Beatriz — Centro
    LatLng(-26.2985, -48.8520), // Pedro — Bucarein
    LatLng(-26.3080, -48.8390), // Maria — Atiradores
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregarRota());
  }

  Future<void> _carregarRota() async {
    final state = context.read<AppState>();
    final origin = LatLng(state.vanLat, state.vanLng);
    final points = await DirectionsService.getRoute(
      origin: origin,
      destination: _schoolPos,
      waypoints: _paradas,
    );
    if (mounted) setState(() => _rotaPoints = points);
  }

  Set<Marker> _buildMarkers(AppState state) {
    final markers = <Marker>{};
    markers.add(Marker(
      markerId: const MarkerId('van'),
      position: LatLng(state.vanLat, state.vanLng),
      infoWindow: InfoWindow(title: '🚐 Van — Carlos Fernandes', snippet: '${state.vanVelocidade.round()} km/h'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    ));
    markers.add(Marker(
      markerId: const MarkerId('escola'),
      position: _schoolPos,
      infoWindow: const InfoWindow(title: '🏫 Escola Estadual Boa Vista'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
    final nomes = ['Lucas Vieira', 'Ana Beatriz', 'Pedro Henrique', 'Maria Fernanda'];
    for (var i = 0; i < _paradas.length; i++) {
      markers.add(Marker(
        markerId: MarkerId('parada_$i'),
        position: _paradas[i],
        infoWindow: InfoWindow(title: '📍 ${nomes[i]}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ));
    }
    return markers;
  }

  Set<Polyline> _buildRoute() {
    if (_rotaPoints.isEmpty) return {};
    return {
      Polyline(
        polylineId: const PolylineId('rota_van'),
        color: AppTheme.orange,
        width: 4,
        points: _rotaPoints,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    // Mover câmera quando van se move
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(state.vanLat, state.vanLng)),
      );
    });

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.count(
          crossAxisCount: 3, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.1,
          children: const [
            StatCard(icon: '🚌', value: '3,2 km', label: 'Distância hoje', iconBg: AppTheme.yellowLight),
            StatCard(icon: '✅', value: '18', label: 'Dias no mês', iconBg: AppTheme.greenLight),
            StatCard(icon: '⏰', value: '96%', label: 'Pontualidade', iconBg: AppTheme.blueLight),
          ],
        ),
        const SizedBox(height: 14),

        Row(children: [
          Expanded(child: EtaBox(icon: '🏫', label: 'Chegada na escola', hora: state.etaEscola, sub: 'Previsão estimada', bg: AppTheme.navy)),
          const SizedBox(width: 10),
          Expanded(child: EtaBox(icon: '🏠', label: 'Busca à tarde', hora: state.etaVolta, sub: 'Previsão estimada', bg: AppTheme.navyMid)),
        ]),
        const SizedBox(height: 14),

        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('📍 Status atual de Lucas', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy)),
            const SizedBox(height: 12),
            Row(children: [
              _StatusPill(status: state.statusFilho, emRota: state.vanEmRota),
              const Spacer(),
              Text('${(state.progressoRota * 100).round()}% da rota', style: const TextStyle(fontSize: 13, color: AppTheme.gray400, fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: state.progressoRota, minHeight: 8,
                backgroundColor: AppTheme.gray200,
                valueColor: AlwaysStoppedAnimation<Color>(state.vanEmRota ? AppTheme.yellow : AppTheme.orange),
              ),
            ),
            const SizedBox(height: 8),
            Text('Velocidade: ${state.vanVelocidade.round()} km/h', style: const TextStyle(fontSize: 12, color: AppTheme.gray400)),
          ]),
        )),
        const SizedBox(height: 14),

        Card(child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text('🗺️ Localização em tempo real', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.navy))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.greenLight, borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppTheme.green, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  const Text('AO VIVO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF166534))),
                ]),
              ),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 300,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(state.vanLat, state.vanLng), zoom: 14),
                  onMapCreated: (c) => _mapController = c,
                  markers: _buildMarkers(state),
                  polylines: _buildRoute(),
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
          ]),
        )),
        const SizedBox(height: 14),

        AlertBanner(
          message: '✅ Lucas entrou na van às 07:20 — Rua das Palmeiras, 148',
          color: const Color(0xFF166534), bg: AppTheme.greenLight,
          icon: Icons.check_circle_rounded,
        ),
        if (!state.vanEmRota) ...[
          const SizedBox(height: 10),
          AlertBanner(
            message: '⚠️ Atenção! A van saiu do trajeto padrão.',
            color: const Color(0xFF9A3412), bg: AppTheme.orangeLight,
            icon: Icons.warning_amber_rounded,
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;
  final bool emRota;
  const _StatusPill({required this.status, required this.emRota});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: emRota ? AppTheme.greenLight : AppTheme.orangeLight, borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: emRota ? AppTheme.green : AppTheme.orange, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(status, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: emRota ? const Color(0xFF166534) : const Color(0xFF9A3412))),
      ]),
    );
  }
}