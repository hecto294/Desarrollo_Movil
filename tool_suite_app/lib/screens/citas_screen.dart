import 'package:flutter/material.dart';

// --- Paleta de colores propia de esta pantalla ---
class _AppColorsCitas {
  static const Color fondo = Color(0xFFF3F4F6);
  static const Color card = Colors.white;
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color acento = Color(0xFF0891B2); // turquesa
  static const Color acentoOscuro = Color(0xFF0E7490);
  static const Color texto = Color(0xFF111827);
  static const Color textoSecundario = Color(0xFF6B7280);
}

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  final List<String> _especialidades = [
    'Medicina General',
    'Odontología',
    'Pediatría',
  ];

  String _especialidadSeleccionada = 'Medicina General';
  DateTime? _fechaSeleccionada;
  String? _ticketGenerado;

  Future<void> _seleccionarFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _AppColorsCitas.acento,
              onPrimary: Colors.white,
              onSurface: _AppColorsCitas.texto,
            ),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
        _ticketGenerado = null; // se resetea el ticket si cambia la fecha
      });
    }
  }

  String _formatearFecha(DateTime fecha) {
    final String mes = fecha.month.toString().padLeft(2, '0');
    final String dia = fecha.day.toString().padLeft(2, '0');
    return '${fecha.year}-$mes-$dia';
  }

  void _confirmarReserva() {
    if (_fechaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una fecha primero')),
      );
      return;
    }

    setState(() {
      _ticketGenerado =
          'Cita confirmada para $_especialidadSeleccionada el ${_formatearFecha(_fechaSeleccionada!)}';
    });
  }

  BoxDecoration _cajaDecoracion() {
    return BoxDecoration(
      color: _AppColorsCitas.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _AppColorsCitas.cardBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, {IconData? icon}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: _AppColorsCitas.acento, size: 18),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: _AppColorsCitas.acento,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas Médicas Pro'),
        backgroundColor: _AppColorsCitas.acento,
        foregroundColor: Colors.white,
      ),
      backgroundColor: _AppColorsCitas.fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Dropdown especialidad ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cajaDecoracion(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('ESPECIALIDAD', icon: Icons.medical_services),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _especialidadSeleccionada,
                      style: const TextStyle(color: _AppColorsCitas.texto, fontSize: 15),
                      decoration: const InputDecoration(border: InputBorder.none),
                      items: _especialidades.map((esp) {
                        return DropdownMenuItem(
                          value: esp,
                          child: Text(esp),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _especialidadSeleccionada = val!;
                          _ticketGenerado = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- Selector de fecha ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cajaDecoracion(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('FECHA CITA', icon: Icons.calendar_today),
                    OutlinedButton.icon(
                      onPressed: _seleccionarFecha,
                      icon: const Icon(Icons.calendar_month,
                          size: 18, color: _AppColorsCitas.acento),
                      label: Text(
                        _fechaSeleccionada == null
                            ? 'Elegir fecha'
                            : _formatearFecha(_fechaSeleccionada!),
                        style: const TextStyle(
                          color: _AppColorsCitas.acento,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _AppColorsCitas.acento),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Botón confirmar reserva ---
              ElevatedButton(
                onPressed: _confirmarReserva,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _AppColorsCitas.acento,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'CONFIRMAR RESERVA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const SizedBox(height: 16),

              // --- Ticket de confirmación ---
              if (_ticketGenerado != null)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _AppColorsCitas.acento.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _AppColorsCitas.acento, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified, color: _AppColorsCitas.acento, size: 18),
                          const SizedBox(width: 6),
                          const Text(
                            'TICKET VIRTUAL GENERADO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _AppColorsCitas.acento,
                              letterSpacing: 0.5,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _ticketGenerado!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _AppColorsCitas.texto,
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