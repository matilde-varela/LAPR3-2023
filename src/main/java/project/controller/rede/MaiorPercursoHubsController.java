package project.controller.rede;

import project.domain.Local;
import project.domain.RedeHub;
import project.structure.Path;

import java.time.LocalTime;

public class MaiorPercursoHubsController {

    public static Path calculateBestDeliveryRoute(Local localInicio, LocalTime hora, int autonomia, double averageVelocity, int tempoRecarga, int tempoDescarga) {
        return RedeHub.calculateBestDeliveryRoute(localInicio,hora,autonomia,averageVelocity,tempoRecarga,tempoDescarga);
    }

    public static LocalTime getFinishingTimeRoute(Path path, LocalTime horaComeco, int autonomia, double averageVelocity, int tempoRecarga, int tempoDescarga){
        return RedeHub.getFinishingTimeRoute(path.getDistanciaTotal() ,averageVelocity, horaComeco);
    }
}
