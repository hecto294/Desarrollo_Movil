/// Modelo de datos (POO) que representa un médico/especialista
/// dentro del directorio de la clínica.
class Medico {
  final String id;
  final String nombre;
  final String especialidad;
  final int anosExperiencia;
  final double precioConsulta;
  final bool disponibleHoy;

  const Medico({
    required this.id,
    required this.nombre,
    required this.especialidad,
    required this.anosExperiencia,
    required this.precioConsulta,
    required this.disponibleHoy,
  });
}