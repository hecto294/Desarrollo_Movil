import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// --- Paleta de colores (tema claro) ---
class AppColors {
  static const Color fondo = Color(0xFFF3F4F6);
  static const Color card = Colors.white;
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color acento = Color(0xFF0891B2); // turquesa
  static const Color acentoOscuro = Color(0xFF0E7490);
  static const Color texto = Color(0xFF111827);
  static const Color textoSecundario = Color(0xFF6B7280);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Citas Médicas Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.fondo,
        colorScheme: ColorScheme.light(
          primary: AppColors.acento,
          secondary: AppColors.acentoOscuro,
        ),
      ),
      home: const CitasScreen(),
    );
  }
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
              primary: AppColors.acento,
              onPrimary: Colors.white,
              onSurface: AppColors.texto,
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
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.cardBorder),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Header ---
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
                    Icon(Icons.local_hospital, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Citas Médicas Pro',
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
                      style: const TextStyle(color: AppColors.texto, fontSize: 15),
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
                          size: 18, color: AppColors.acento),
                      label: Text(
                        _fechaSeleccionada == null
                            ? 'Elegir fecha'
                            : _formatearFecha(_fechaSeleccionada!),
                        style: const TextStyle(
                          color: AppColors.acento,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.acento),
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
                  backgroundColor: AppColors.acento,
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
                    color: AppColors.acento.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.acento, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.verified, color: AppColors.acento, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'TICKET VIRTUAL GENERADO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.acento,
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
                          color: AppColors.texto,
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