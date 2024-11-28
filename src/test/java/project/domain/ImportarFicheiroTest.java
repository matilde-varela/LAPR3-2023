package project.domain;

import org.junit.Test;
import org.junit.jupiter.api.AfterEach;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.Map;

import static org.junit.Assert.*;

public class ImportarFicheiroTest {

private static boolean result;

    @Test
    public void testImportWateringPlanSuccess() {
        String rightFile = "src/test/java/project/testFiles/ficheiroCorreto.txt";
        result = ImportarFicheiro.importWateringPlan(rightFile);
        assertTrue(result);
    }

    @Test
    public void testImportWateringPlanFailureWrongLines() {
        String exceptionMessage = """
                ERRO: Conteúdo ficheiro não corresponde ao esperado.
                As linhas com os setores a serem regados deve ter o seguinte formato:
                 <parcela: [A-Z], duração, regularidade: [T,I,P,3]>, por exemplo A,14,T.""";
        String wrongLinesFile = "src/test/java/project/testFiles/ficheiroLinhasErrada.txt";
        result = ImportarFicheiro.importWateringPlan(wrongLinesFile);
        assertFalse(result);
    }

    @Test
    public void testImportWateringPlanFailureWrongHours() {
        String exceptionMessage = "ERRO: Conteúdo ficheiro não corresponde ao esperado.\n" +
                "A primeira linha deve ter as horas de rega com o seguinte formato: hh:mm, hh:mm, etc.";
        String wrongHoursFile = "src/test/java/project/testFiles/ficheiroHoraErrada.txt";
        result = ImportarFicheiro.importWateringPlan(wrongHoursFile);
        assertFalse(result);
    }

    @Test
    public void testImportFicheiroHorariosValid(){
        String filePath = "files/horariosTESTE.csv";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        Map<String, Horario> result = new LinkedHashMap<>();
        Map<String, Horario> expected = new LinkedHashMap<>();
        Horario horario1 = new Horario(LocalTime.parse("14:00", formatter), LocalTime.parse("17:00", formatter));
        Horario horario2 = new Horario(LocalTime.parse("11:00", formatter), LocalTime.parse("15:30", formatter));
        Horario horario3 = new Horario(LocalTime.parse("16:00", formatter), LocalTime.parse("18:20", formatter));
        Horario horario4 = new Horario(LocalTime.parse("09:00", formatter), LocalTime.parse("12:30", formatter));

        expected.put("CT1", horario1);
        expected.put("CT9", horario2);
        expected.put("CT6", horario3);
        expected.put("CT12", horario4);

//        assertEquals(true, ImportarFicheiro.importarFicheiroHorarios(filePath, result));
        assertTrue(ImportarFicheiro.importarFicheiroHorarios(filePath, result));
    }

    @Test
    public void testImportFicheiroHorariosFails(){
        String filePath = "src/test/java/project/testFiles/horariosErrados.csv";
//        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");
        Map<String, Horario> result = new LinkedHashMap<>();
//        Map<String, Horario> expected = new LinkedHashMap<>();
//        Horario horario1 = new Horario(LocalTime.parse("15:00", formatter), LocalTime.parse("17:00", formatter));
//        Horario horario2 = new Horario(LocalTime.parse("11:00", formatter), LocalTime.parse("15:30", formatter));
//
//        expected.put("CT14", horario1);
//        expected.put("CT9", horario2);

//        assertNotEquals(false, ImportarFicheiro.importarFicheiroHorarios(filePath, result));
        assertFalse(ImportarFicheiro.importarFicheiroHorarios(filePath, result));
    }

    @AfterEach
    void teardown(){
        SistemaDeRega.setPlanoDeRega(null);
        SistemaDeRega.setInicioDoPlanoDeRega(null);
    }
}