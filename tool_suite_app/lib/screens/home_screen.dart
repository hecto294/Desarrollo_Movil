import 'package:flutter/material.dart';
import '../models/herramienta.dart';
import 'cotizador_screen.dart';
import 'encuesta_screen.dart';
import 'calculadora_screen.dart';
import 'citas_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Herramienta> _herramientas = [
    Herramienta(
      id: 'cotizador',
      titulo: 'Cotizador Express',
      descripcion: 'Calcula el valor de envíos nacionales',
      icono: Icons.local_shipping,
      color: const Color(0xFF3B5BFF),
      pantallaDestino: const CotizadorScreen(),
    ),
    Herramienta(
      id: 'encuesta',
      titulo: 'Encuesta de Satisfacción',
      descripcion: 'Califica un servicio de atención al cliente',
      icono: Icons.emoji_emotions,
      color: const Color(0xFF00996E),
      pantallaDestino: const EncuestaScreen(),
    ),
    Herramienta(
      id: 'calculadora',
      titulo: 'Propinas y Cuenta',
      descripcion: 'Divide la cuenta y calcula la propina',
      icono: Icons.receipt_long,
      color: const Color(0xFF8B5CF6),
      pantallaDestino: const CalculadoraScreen(),
    ),
    Herramienta(
      id: 'citas',
      titulo: 'Citas Médicas',
      descripcion: 'Agenda una cita según especialidad y fecha',
      icono: Icons.local_hospital,
      color: const Color(0xFF0891B2),
      pantallaDestino: const CitasScreen(),
    ),
  ];

  void _navegar(BuildContext context, Herramienta herramienta) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => herramienta.pantallaDestino),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suite de Herramientas'),
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,
        // El ícono ☰ para abrir el Drawer aparece automáticamente
        // porque el Scaffold detecta la propiedad "drawer" más abajo.
      ),
      backgroundColor: const Color(0xFFF3F4F6),

      // --- Drawer: panel lateral ADICIONAL, no reemplaza el contenido ---
      // Se abre con el ícono ☰ o deslizando desde el borde izquierdo,
      // y se cierra deslizando de vuelta o tocando fuera de él.
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B5BFF), Color(0xFF111827)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.apps, color: Colors.white, size: 40),
                    SizedBox(height: 12),
                    Text(
                      'Suite de Herramientas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Acceso rápido',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _herramientas.length,
                  itemBuilder: (context, index) {
                    final herramienta = _herramientas[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: herramienta.color,
                        child: Icon(herramienta.icono, color: Colors.white, size: 20),
                      ),
                      title: Text(
                        herramienta.titulo,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pop(context); // cierra el drawer
                        _navegar(context, herramienta);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // --- Contenido principal: SIEMPRE visible, las tarjetas del menú ---
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _herramientas.length,
          itemBuilder: (context, index) {
            final herramienta = _herramientas[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: CircleAvatar(
                  backgroundColor: herramienta.color,
                  radius: 26,
                  child: Icon(herramienta.icono, color: Colors.white),
                ),
                title: Text(
                  herramienta.titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(herramienta.descripcion),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _navegar(context, herramienta),
              ),
            );
          },
        ),
      ),
    );
  }
}