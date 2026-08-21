import 'package:flutter/material.dart';

class CalculadoraScreen extends StatefulWidget {
  const CalculadoraScreen({super.key});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  static const Color acento = Color(0xFF8B5CF6);

  final TextEditingController _cuentaController = TextEditingController();
  int _propinaSeleccionada = 10;
  int _personas = 1;

  double get _montoPorPersona {
    final String texto = _cuentaController.text.replaceAll(',', '.');
    final double cuenta = double.tryParse(texto) ?? 0;
    final double total = cuenta * (1 + _propinaSeleccionada / 100);
    return _personas > 0 ? total / _personas : 0;
  }

  @override
  void dispose() {
    _cuentaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propinas y Cuenta'),
        backgroundColor: acento,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TOTAL DE LA CUENTA',
                        style: TextStyle(fontWeight: FontWeight.bold, color: acento)),
                    TextField(
                      controller: _cuentaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.attach_money, color: acento),
                        hintText: 'Ej: 120000',
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PROPINA SUGERIDA',
                        style: TextStyle(fontWeight: FontWeight.bold, color: acento)),
                    const SizedBox(height: 12),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 10, label: Text('10%')),
                        ButtonSegment(value: 15, label: Text('15%')),
                        ButtonSegment(value: 20, label: Text('20%')),
                      ],
                      selected: {_propinaSeleccionada},
                      onSelectionChanged: (nueva) =>
                          setState(() => _propinaSeleccionada = nueva.first),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('PERSONAS',
                        style: TextStyle(fontWeight: FontWeight.bold, color: acento)),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_personas > 1) setState(() => _personas--);
                          },
                          icon: const Icon(Icons.remove_circle, color: acento),
                        ),
                        Text('$_personas',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => setState(() => _personas++),
                          icon: const Icon(Icons.add_circle, color: acento),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: acento.withOpacity(0.08),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Text('PAGA CADA PERSONA',
                        style: TextStyle(fontWeight: FontWeight.bold, color: acento)),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_montoPorPersona.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}