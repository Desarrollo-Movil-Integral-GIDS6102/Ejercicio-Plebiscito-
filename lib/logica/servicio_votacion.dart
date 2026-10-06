import '../modelos/votacion.dart';
import '../modelos/opcion_votacion.dart';
import '../modelos/resultado_opcion.dart';
import 'resultado_voto.dart';

class ServicioVotacion {
  final Votacion votacion;

  ServicioVotacion(this.votacion);

  bool get estaCerrada => !DateTime.now().isBefore(votacion.fechaCierre);

  ResultadoVoto registrarVoto({
    required String idUsuario,
    required String idOpcion,
  }) {
    if (estaCerrada) return ResultadoVoto.votacionCerrada;
    if (votacion.votantes.contains(idUsuario)) {
      return ResultadoVoto.usuarioYaVoto;
    }

    final opcion = _buscarOpcion(idOpcion);
    if (opcion == null) return ResultadoVoto.opcionInvalida;

    opcion.votos++;
    votacion.votantes.add(idUsuario);
    return ResultadoVoto.exitoso;
  }

  List<ResultadoOpcion> obtenerResultados() {
    final totalVotos = votacion.opciones.fold<int>(
      0,
      (total, opcion) => total + opcion.votos,
    );

    return votacion.opciones
        .map(
          (opcion) => ResultadoOpcion(
            opcion,
            totalVotos == 0 ? 0 : opcion.votos * 100 / totalVotos,
          ),
        )
        .toList();
  }

  List<OpcionVotacion> determinarGanador() {
    if (votacion.opciones.isEmpty) return [];

    final maximoVotos = votacion.opciones.fold<int>(
      0,
      (maximo, opcion) => opcion.votos > maximo ? opcion.votos : maximo,
    );
    if (maximoVotos == 0) return [];

    return votacion.opciones
        .where((opcion) => opcion.votos == maximoVotos)
        .toList();
  }

  OpcionVotacion? _buscarOpcion(String id) {
    for (final o in votacion.opciones) {
      if (o.id == id) return o;
    }
    return null;
  }
}