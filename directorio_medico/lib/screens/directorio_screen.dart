import 'package:flutter/material.dart';
import '../models/medico.dart';
import 'detalle_medico_screen.dart';

class DirectorioScreen extends StatelessWidget {
  const DirectorioScreen({super.key});

  // Lista de objetos Medico (al menos 5, según el requerimiento).
  static final List<Medico> _medicos = [
    const Medico(
      id: '1',
      nombre: 'Dra. Laura Gómez',
      especialidad: 'Medicina General',
      anosExperiencia: 8,
      precioConsulta: 60000,
      disponibleHoy: true,
    ),
    const Medico(
      id: '2',
      nombre: 'Dr. Carlos Ramírez',
      especialidad: 'Cardiología',
      anosExperiencia: 15,
      precioConsulta: 120000,
      disponibleHoy: false,
    ),
    const Medico(
      id: '3',
      nombre: 'Dra. Ana Martínez',
      especialidad: 'Pediatría',
      anosExperiencia: 10,
      precioConsulta: 90000,
      disponibleHoy: true,
    ),
    const Medico(
      id: '4',
      nombre: 'Dr. Jorge Salazar',
      especialidad: 'Odontología',
      anosExperiencia: 6,
      precioConsulta: 70000,
      disponibleHoy: true,
    ),
    const Medico(
      id: '5',
      nombre: 'Dra. Paula Herrera',
      especialidad: 'Dermatología',
      anosExperiencia: 12,
      precioConsulta: 110000,
      disponibleHoy: false,
    ),
    const Medico(
      id: '6',
      nombre: 'Dr. Andrés Torres',
      especialidad: 'Ortopedia',
      anosExperiencia: 20,
      precioConsulta: 130000,
      disponibleHoy: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directorio Médico'),
        backgroundColor: const Color(0xFF0891B2),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _medicos.length,
        itemBuilder: (context, index) {
          final medico = _medicos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF0891B2),
                radius: 26,
                child: const Icon(Icons.medical_services, color: Colors.white),
              ),
              title: Text(
                medico.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                '${medico.especialidad} • ${medico.anosExperiencia} años de experiencia',
              ),
              trailing: Icon(
                Icons.circle,
                size: 12,
                color: medico.disponibleHoy ? Colors.green : Colors.grey,
              ),
              onTap: () {
                // Navigator.push pasando el objeto Medico seleccionado
                // a la pantalla de detalle, a través de su constructor.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleMedicoScreen(medico: medico)
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}