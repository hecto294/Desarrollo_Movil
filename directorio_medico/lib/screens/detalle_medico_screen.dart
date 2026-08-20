import 'package:flutter/material.dart';
import '../models/medico.dart';

class DetalleMedicoScreen extends StatelessWidget {
  // Recibe el objeto Medico que fue seleccionado en DirectorioScreen.
  final Medico medico;

  const DetalleMedicoScreen({super.key, required this.medico});

  void _reservarCita(BuildContext context) {
    // Si el médico NO está disponible hoy, no se permite reservar:
    // mostramos una advertencia y detenemos la función con "return".
    if (!medico.disponibleHoy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${medico.nombre} no está disponible hoy. Intenta otro día.',
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      return; // corta la ejecución aquí, no sigue hacia la confirmación
    }

    // Si SÍ está disponible, confirmamos la cita normalmente.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cita reservada con ${medico.nombre} ✅'),
        backgroundColor: const Color(0xFF0891B2),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Médico'),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF0891B2),
                child: const Icon(Icons.medical_services, color: Colors.white, size: 48),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              medico.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              medico.especialidad,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // --- Tarjeta con la información detallada ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _filaInfo(
                      icono: Icons.work_history,
                      etiqueta: 'Experiencia',
                      valor: '${medico.anosExperiencia} años',
                    ),
                    const Divider(),
                    _filaInfo(
                      icono: Icons.attach_money,
                      etiqueta: 'Precio consulta',
                      valor: '\$${medico.precioConsulta.toStringAsFixed(0)}',
                    ),
                    const Divider(),
                    _filaInfo(
                      icono: Icons.event_available,
                      etiqueta: 'Disponibilidad',
                      valor: medico.disponibleHoy
                          ? 'Disponible hoy'
                          : 'No disponible hoy',
                      colorValor:
                          medico.disponibleHoy ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Aviso extra si no está disponible ---
            if (!medico.disponibleHoy)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Este médico no tiene citas disponibles hoy.',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            // --- Botón Reservar Cita ---
            // Si NO está disponible: onPressed queda en "null", lo cual
            // Flutter interpreta automáticamente como botón DESHABILITADO
            // (se ve gris y no responde a toques).
            ElevatedButton.icon(
              onPressed:
                  medico.disponibleHoy ? () => _reservarCita(context) : null,
              icon: Icon(
                medico.disponibleHoy ? Icons.calendar_month : Icons.block,
              ),
              label: Text(
                medico.disponibleHoy ? 'Reservar Cita' : 'No disponible hoy',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0891B2),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaInfo({
    required IconData icono,
    required String etiqueta,
    required String valor,
    Color? colorValor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icono, size: 20, color: const Color(0xFF0891B2)),
              const SizedBox(width: 10),
              Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            valor,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorValor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}