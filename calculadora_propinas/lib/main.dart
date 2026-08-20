import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// --- Paleta de colores (tema claro) ---
class AppColors {
  static const Color fondo = Color(0xFFF3F4F6); // gris muy claro
  static const Color card = Colors.white;
  static const Color cardBorder = Color(0xFFE5E7EB);
  static const Color acento = Color(0xFF8B5CF6); // morado
  static const Color acentoOscuro = Color(0xFF7C3AED);
  static const Color texto = Color(0xFF111827); // casi negro
  static const Color textoSecundario = Color(0xFF6B7280);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Propinas',
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
      home: const CalculadoraScreen(),
    );
  }
}

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  final TextEditingController _cuentaController = TextEditingController();

  int _propinaSeleccionada = 10; // 10, 15, 20
  int _personas = 1;

  double get _montoPorPersona {
    final String texto = _cuentaController.text.replaceAll(',', '.');
    final double cuenta = double.tryParse(texto) ?? 0;
    final double total = cuenta * (1 + _propinaSeleccionada / 100);
    return _personas > 0 ? total / _personas : 0;
  }

  void _incrementarPersonas() {
    setState(() => _personas++);
  }

  void _decrementarPersonas() {
    if (_personas > 1) {
      setState(() => _personas--);
    }
  }

  @override
  void dispose() {
    _cuentaController.dispose();
    super.dispose();
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
                    Icon(Icons.receipt_long, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'División de Cuenta & Propina',
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

              // --- TextField total de la cuenta ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cajaDecoracion(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('TOTAL DE LA CUENTA', icon: Icons.attach_money),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _cuentaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: AppColors.texto, fontSize: 18),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.monetization_on,
                            color: AppColors.acento),
                        hintText: 'Ej: 120000',
                        hintStyle: const TextStyle(color: AppColors.textoSecundario),
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- SegmentedButton propina ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cajaDecoracion(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('PROPINA SUGERIDA', icon: Icons.percent),
                    const SizedBox(height: 12),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 10, label: Text('10%')),
                        ButtonSegment(value: 15, label: Text('15%')),
                        ButtonSegment(value: 20, label: Text('20%')),
                      ],
                      selected: {_propinaSeleccionada},
                      onSelectionChanged: (nuevaSeleccion) {
                        setState(() {
                          _propinaSeleccionada = nuevaSeleccion.first;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.acento;
                          }
                          return const Color(0xFFE5E7EB);
                        }),
                        foregroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return AppColors.textoSecundario;
                        }),
                        side: const WidgetStatePropertyAll(BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // --- IconButton personas ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: _cajaDecoracion(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('PERSONAS', icon: Icons.people),
                    Row(
                      children: [
                        _botonCirculo(
                          icon: Icons.remove,
                          onTap: _decrementarPersonas,
                        ),
                        Container(
                          width: 40,
                          alignment: Alignment.center,
                          child: Text(
                            '$_personas',
                            style: const TextStyle(
                              color: AppColors.texto,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _botonCirculo(
                          icon: Icons.add,
                          onTap: _incrementarPersonas,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Resultado ---
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
                      'PAGA CADA PERSONA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.acento,
                        letterSpacing: 0.5,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_montoPorPersona.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
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

  Widget _botonCirculo({required IconData icon, required VoidCallback onTap}) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.acento,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}