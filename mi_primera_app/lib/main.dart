import 'package:flutter/material.dart';

void main() {
  runApp(const MiCalculadoraApp());
}

class MiCalculadoraApp extends StatelessWidget {
  const MiCalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de UI Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const PantallaCalculadora(),
    );
  }
}

class PantallaCalculadora extends StatefulWidget {
  const PantallaCalculadora({super.key});

  @override
  State<PantallaCalculadora> createState() => _PantallaCalculadoraState();
}

class _PantallaCalculadoraState extends State<PantallaCalculadora> {
  final TextEditingController _num1Controller = TextEditingController();
  final TextEditingController _num2Controller = TextEditingController();

  // Color "azul rey" oscuro reutilizado en varios lugares
  static const Color _azulRey = Color.fromARGB(255, 15, 37, 146);

  String _resultado = "0.0";
  bool _huboError = false;

  // Operación seleccionada actualmente: '+', '-', '×' o '÷'
  String _operacion = '+';

  void _seleccionarOperacion(String op) {
    setState(() {
      _operacion = op;
    });
  }

  void _realizarCalculo() {
    final t1 = _num1Controller.text.trim();
    final t2 = _num2Controller.text.trim();

    if (t1.isEmpty || t2.isEmpty) {
      setState(() {
        _resultado = "Por favor ingresa ambos números";
        _huboError = true;
      });
      return;
    }

    final double? n1 = double.tryParse(t1);
    final double? n2 = double.tryParse(t2);

    if (n1 == null || n2 == null) {
      setState(() {
        _resultado = "Valores numéricos inválidos";
        _huboError = true;
      });
      return;
    }

    double resultado;

    switch (_operacion) {
      case '+':
        resultado = n1 + n2;
        break;
      case '-':
        resultado = n1 - n2;
        break;
      case '×':
        resultado = n1 * n2;
        break;
      case '÷':
        if (n2 == 0) {
          setState(() {
            _resultado = "No se puede dividir entre cero";
            _huboError = true;
          });
          return;
        }
        resultado = n1 / n2;
        break;
      default:
        resultado = 0;
    }

    setState(() {
      _resultado = "$resultado";
      _huboError = false;
    });
  }

  void _limpiar() {
    _num1Controller.clear();
    _num2Controller.clear();
    setState(() {
      _resultado = "0.0";
      _huboError = false;
    });
  }

  // Construye un botón de operación (+, -, ×, ÷) que se resalta si está seleccionado
  Widget _botonOperacion(String op) {
    final bool seleccionado = _operacion == op;
    return Expanded(
      child: GestureDetector(
        onTap: () => _seleccionarOperacion(op),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: seleccionado ? _azulRey : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              op,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: seleccionado ? Colors.white : _azulRey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Anatomía de UI Flutter'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              color: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          backgroundColor: Colors.indigoAccent,
                          child: Icon(Icons.calculate, color: Colors.white),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título de la tarjeta, ahora "Operación" en blanco sobre fondo negro
                            Text(
                              'Operación',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text('Elige una operación', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Botones de operaciones: +, -, ×, ÷
                    Row(
                      children: [
                        _botonOperacion('+'),
                        const SizedBox(width: 8),
                        _botonOperacion('-'),
                        const SizedBox(width: 8),
                        _botonOperacion('×'),
                        const SizedBox(width: 8),
                        _botonOperacion('÷'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Caja nueva que dice "Calcular"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _azulRey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Calcular',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Campo del primer número con fondo gris
            TextField(
              controller: _num1Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Primer Número',
                hintText: 'Ej. 15.4',
                prefixIcon: const Icon(Icons.looks_one, color: _azulRey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Campo del segundo número con fondo gris
            TextField(
              controller: _num2Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Segundo Número',
                hintText: 'Ej. 10.6',
                prefixIcon: const Icon(Icons.looks_two, color: Colors.indigo),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _realizarCalculo,
                    child: const Text('RESULTADO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _limpiar,
                  icon: const Icon(Icons.refresh),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.all(14),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),

            // 5. Tarjeta de resultado: solo se muestra el resultado
            Card(
              color: _huboError ? Colors.red[50] : Colors.indigo[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: _huboError ? Colors.red : Colors.indigo, width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _resultado,
                  style: TextStyle(
                    fontSize: _huboError ? 14 : 28,
                    fontWeight: FontWeight.bold,
                    color: _huboError ? Colors.red[800] : Colors.indigo[900],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}