import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// --- Paleta de colores ---
class AppColors {
  static const Color fondo = Color(0xFF0D1117);
  static const Color card = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF2A2F3A);
  static const Color acento = Color(0xFF00C896); // verde esmeralda
  static const Color acentoOscuro = Color(0xFF00996E);
  static const Color texto = Colors.white;
  static const Color textoSecundario = Color(0xFF9AA4B2);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encuesta de Satisfacción',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.fondo,
        colorScheme: ColorScheme.dark(
          primary: AppColors.acento,
          secondary: AppColors.acentoOscuro,
        ),
      ),
      home: const EncuestaScreen(),
    );
  }
}

class EncuestaScreen extends StatefulWidget {
  const EncuestaScreen({super.key});

  @override
  State<EncuestaScreen> createState() => _EncuestaScreenState();
}

class _EncuestaScreenState extends State<EncuestaScreen> {
  double _calificacion = 8.0;

  final Map<String, bool> _aspectos = {
    'Velocidad': false,
    'Amabilidad': false,
    'Calidad del producto': false,
  };

  String? _canalSeleccionado;
  final List<String> _canales = ['Presencial', 'Virtual', 'Telefónico'];

  BoxDecoration _cajaDecoracion() {
    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.cardBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.35),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: AppColors.acento, size: 18),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.acento,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  List<String> get _aspectosSeleccionados =>
      _aspectos.entries.where((e) => e.value).map((e) => e.key).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Header con gradiente ---
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.acento, AppColors.acentoOscuro],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.emoji_emotions, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Encuesta de Satisfacción',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Slider calificación ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cajaDecoracion(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('CALIFICACIÓN (1 - 10)', icon: Icons.star),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.acento.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _calificacion.toStringAsFixed(1),
                            style: const TextStyle(
                              color: AppColors.acento,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: AppColors.acento,
                        inactiveTrackColor: Colors.grey[800],
                        thumbColor: AppColors.acento,
                        overlayColor: AppColors.acento.withOpacity(0.2),
                        valueIndicatorColor: AppColors.acento,
                      ),
                      child: Slider(
                        value: _calificacion,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        label: _calificacion.round().toString(),
                        onChanged: (val) {
                          setState(() => _calificacion = val);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- CheckboxListTile aspectos ---
              Container(
                decoration: _cajaDecoracion(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: _buildLabel('ASPECTOS DESTACADOS',
                          icon: Icons.checklist),
                    ),
                    ..._aspectos.keys.map((aspecto) {
                      return CheckboxListTile(
                        activeColor: AppColors.acento,
                        checkColor: Colors.black,
                        title: Text(aspecto,
                            style: const TextStyle(color: AppColors.texto)),
                        value: _aspectos[aspecto],
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (val) {
                          setState(() => _aspectos[aspecto] = val ?? false);
                        },
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- ChoiceChip canal de atención ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cajaDecoracion(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('CANAL DE ATENCIÓN', icon: Icons.support_agent),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _canales.map((canal) {
                        final seleccionado = _canalSeleccionado == canal;
                        return ChoiceChip(
                          label: Text(canal),
                          selected: seleccionado,
                          onSelected: (_) {
                            setState(() => _canalSeleccionado = canal);
                          },
                          selectedColor: AppColors.acento,
                          backgroundColor: const Color(0xFF2A2F3A),
                          labelStyle: TextStyle(
                            color: seleccionado
                                ? Colors.black
                                : AppColors.textoSecundario,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Resumen final (Card) ---
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.acento.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.acento, width: 1.2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'RESUMEN REGISTRADO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.acento,
                        letterSpacing: 0.5,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calificación: ${_calificacion.round()}/10',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _aspectosSeleccionados.isEmpty
                          ? 'Sin aspectos seleccionados'
                          : _aspectosSeleccionados.join(', '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _canalSeleccionado == null
                          ? 'Canal: sin seleccionar'
                          : 'Canal: $_canalSeleccionado',
                      style: const TextStyle(
                        color: AppColors.textoSecundario,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}