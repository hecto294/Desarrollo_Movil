import 'package:flutter/material.dart';

// --- Paleta de colores propia de esta pantalla ---
class _AppColorsEncuesta {
  static const Color fondo = Color(0xFF0D1117);
  static const Color card = Color(0xFF1E1E1E);
  static const Color cardBorder = Color(0xFF2A2F3A);
  static const Color acento = Color(0xFF00C896); // verde esmeralda
  static const Color acentoOscuro = Color(0xFF00996E);
  static const Color texto = Colors.white;
  static const Color textoSecundario = Color(0xFF9AA4B2);
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
      color: _AppColorsEncuesta.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _AppColorsEncuesta.cardBorder),
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
          Icon(icon, color: _AppColorsEncuesta.acento, size: 18),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: _AppColorsEncuesta.acento,
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
      appBar: AppBar(
        title: const Text('Encuesta de Satisfacción'),
        backgroundColor: _AppColorsEncuesta.acento,
        foregroundColor: Colors.white,
      ),
      backgroundColor: _AppColorsEncuesta.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                            color: _AppColorsEncuesta.acento.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _calificacion.toStringAsFixed(1),
                            style: const TextStyle(
                              color: _AppColorsEncuesta.acento,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderThemeData(
                        activeTrackColor: _AppColorsEncuesta.acento,
                        inactiveTrackColor: Colors.grey[800],
                        thumbColor: _AppColorsEncuesta.acento,
                        overlayColor: _AppColorsEncuesta.acento.withOpacity(0.2),
                        valueIndicatorColor: _AppColorsEncuesta.acento,
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
                        activeColor: _AppColorsEncuesta.acento,
                        checkColor: Colors.black,
                        title: Text(aspecto,
                            style: const TextStyle(color: _AppColorsEncuesta.texto)),
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
                          selectedColor: _AppColorsEncuesta.acento,
                          backgroundColor: const Color(0xFF2A2F3A),
                          labelStyle: TextStyle(
                            color: seleccionado
                                ? Colors.black
                                : _AppColorsEncuesta.textoSecundario,
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

              // --- Resumen final ---
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _AppColorsEncuesta.acento.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _AppColorsEncuesta.acento, width: 1.2),
                ),
                child: Column(
                  children: [
                    const Text(
                      'RESUMEN REGISTRADO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _AppColorsEncuesta.acento,
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
                        color: _AppColorsEncuesta.textoSecundario,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _canalSeleccionado == null
                          ? 'Canal: sin seleccionar'
                          : 'Canal: $_canalSeleccionado',
                      style: const TextStyle(
                        color: _AppColorsEncuesta.textoSecundario,
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