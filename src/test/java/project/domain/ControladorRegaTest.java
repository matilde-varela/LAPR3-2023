package project.domain;

import org.junit.Before;
import org.junit.Test;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;

import java.time.LocalDate;
import java.time.LocalTime;

public class ControladorRegaTest {

    private static LocalDate dataInicio;

    @Before
    public void setUp() {
        ImportarFicheiro.importWateringPlan("src/test/java/project/testFiles/ficheiroCorretoV2.txt");
        dataInicio = LocalDate.now();
        SistemaDeRega.setInicioDoPlanoDeRega(dataInicio);
    }

    @Test
    public void checkIsWateringHour() {

        LocalDate data = dataInicio.plusDays(4);
        LocalDate dataFora = dataInicio.plusDays(31);

        LocalTime tempo1715 = LocalTime.of(17, 13);
        LocalTime tempoFora = LocalTime.of(1, 0);

        Assertions.assertEquals(SistemaDeRega.getControladorRega().checkIsWateringHour(tempo1715, data), "Parcela a ser regada neste momento: A | Tempo restante: 1 minutos.\n");

        Assertions.assertEquals(SistemaDeRega.getControladorRega().checkIsWateringHour(tempo1715, dataFora), "Não há parcelas a serem regadas agora.");

        Assertions.assertEquals(SistemaDeRega.getControladorRega().checkIsWateringHour(tempoFora, data), "Não há parcelas a serem regadas agora.");

    }

    @AfterEach
    void teardown() {
        SistemaDeRega.setPlanoDeRega(null);
        SistemaDeRega.setInicioDoPlanoDeRega(null);
    }


}