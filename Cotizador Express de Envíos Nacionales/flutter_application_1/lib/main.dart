import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotizador Express',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const CotizadorScreen(),
    );
  }
}

class CotizadorScreen extends StatefulWidget {
  const CotizadorScreen({super.key});

  @override
  State<CotizadorScreen> createState() => _CotizadorScreenState();
}

class _CotizadorScreenState extends State<CotizadorScreen> {
  final TextEditingController _pesoController = TextEditingController();

  // Mapa de ciudades con su costo base
  final Map<String, int> _ciudades = {
    'Bogotá': 8000,
    'Medellín': 12000,
    'Cali': 14000,
  };

  String _ciudadSeleccionada = 'Bogotá';
  String _tipoEnvio = 'Estandar'; // Estandar, Express, SuperExpress
  bool _incluirSeguro = false;
  double _totalCotizado = 0;

  void _calcularTotal() {
    // Convertimos el peso (reemplazando coma por punto por si el usuario escribe "2,5")
    final String pesoTexto = _pesoController.text.replaceAll(',', '.');
    final double peso = double.tryParse(pesoTexto) ?? 0;

    final int costoCiudad = _ciudades[_ciudadSeleccionada] ?? 0;

    int costoVelocidad;
    switch (_tipoEnvio) {
      case 'Express':
        costoVelocidad = 5000;
        break;
      case 'SuperExpress':
        costoVelocidad = 10000;
        break;
      default:
        costoVelocidad = 0;
    }

    final int costoSeguro = _incluirSeguro ? 3000 : 0;

    setState(() {
      _totalCotizado =
          costoCiudad + (peso * 2000) + costoVelocidad + costoSeguro;
    });
  }

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

  // Decoración reutilizable para las cajas gris oscuro
  BoxDecoration _cajaOscura() {
    return BoxDecoration(
      color: const Color(0xFF1E1E1E), // gris oscuro
      borderRadius: BorderRadius.circular(8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // fondo negro
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B5BFF), // azul
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Cotizador de Envíos Express',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- TextField Peso ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _cajaOscura(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PESO EN KG',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B7CFA))), // azul claro
                    TextField(
                      controller: _pesoController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- Dropdown Ciudad ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _cajaOscura(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CIUDAD DE DESTINO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B7CFA))),
                    DropdownButtonFormField<String>(
                      value: _ciudadSeleccionada,
                      dropdownColor: const Color(0xFF1E1E1E),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(border: InputBorder.none),
                      items: _ciudades.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(
                              '${entry.key} (\$${entry.value})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _ciudadSeleccionada = val!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- RadioListTile tipo de envío ---
              Container(
                decoration: _cajaOscura(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Text('TIPO DE ENVÍO (RADIO)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5B7CFA))),
                    ),
                    RadioListTile<String>(
                      activeColor: const Color(0xFF5B7CFA),
                      title: const Text('Estándar (+ \$0)',
                          style: TextStyle(color: Colors.white)),
                      value: 'Estandar',
                      groupValue: _tipoEnvio,
                      onChanged: (val) => setState(() => _tipoEnvio = val!),
                    ),
                    RadioListTile<String>(
                      activeColor: const Color(0xFF5B7CFA),
                      title: const Text('Express (+ \$5.000)',
                          style: TextStyle(color: Colors.white)),
                      value: 'Express',
                      groupValue: _tipoEnvio,
                      onChanged: (val) => setState(() => _tipoEnvio = val!),
                    ),
                    RadioListTile<String>(
                      activeColor: const Color(0xFF5B7CFA),
                      title: const Text('Super Express (+ \$10.000)',
                          style: TextStyle(color: Colors.white)),
                      value: 'SuperExpress',
                      groupValue: _tipoEnvio,
                      onChanged: (val) => setState(() => _tipoEnvio = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // --- SwitchListTile seguro ---
              Container(
                decoration: _cajaOscura(),
                child: SwitchListTile(
                  activeColor: const Color(0xFF5B7CFA),
                  title: const Text('Incluir Seguro (+ \$3.000)',
                      style: TextStyle(color: Colors.white)),
                  value: _incluirSeguro,
                  onChanged: (val) => setState(() => _incluirSeguro = val),
                ),
              ),
              const SizedBox(height: 16),

              // --- Botón calcular ---
              ElevatedButton(
                onPressed: _calcularTotal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B5BFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Calcular Cotización',
                    style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),

              // --- Resultado ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cajaOscura(),
                child: Column(
                  children: [
                    const Text('VALOR TOTAL COTIZADO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5B7CFA))),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_totalCotizado.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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