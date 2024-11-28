package project.domain;

import org.junit.Test;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.*;

public class SistemaDeRegaTest {


    @Test
    public void testGenerateDailyFileOfWateringPlan() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");
        SistemaDeRega.setInicioDoPlanoDeRega(LocalDate.parse("05-10-2022", formatter));

        List<Rega> setores = new ArrayList<>();

        setores.add(new Rega("35", LocalTime.of(7, 0), LocalTime.of(7, 15), LocalDate.parse("05-10-2022", formatter)));
        setores.add(new Rega("D", LocalTime.of(7, 15), LocalTime.of(7, 25), LocalDate.parse("05-10-2022", formatter)));
        setores.add(new Rega("35", LocalTime.of(18, 30), LocalTime.of(18, 45), LocalDate.parse("05-10-2022", formatter)));
        setores.add(new Rega("D", LocalTime.of(18, 45), LocalTime.of(18, 55), LocalDate.parse("05-10-2022", formatter)));


        setores.add(new Rega("35", LocalTime.of(7, 0), LocalTime.of(7, 15), LocalDate.parse("06-10-2022", formatter)));
        setores.add(new Rega("A", LocalTime.of(7, 15), LocalTime.of(7, 20), LocalDate.parse("06-10-2022", formatter)));
        setores.add(new Rega("41", LocalTime.of(7, 20), LocalTime.of(7, 48), LocalDate.parse("06-10-2022", formatter)));
        setores.add(new Rega("35", LocalTime.of(18, 30), LocalTime.of(18, 45), LocalDate.parse("06-10-2022", formatter)));
        setores.add(new Rega("A", LocalTime.of(18, 45), LocalTime.of(18, 50), LocalDate.parse("06-10-2022", formatter)));
        setores.add(new Rega("41", LocalTime.of(18, 50), LocalTime.of(19, 18), LocalDate.parse("06-10-2022", formatter)));


        setores.add(new Rega("35", LocalTime.of(7, 0), LocalTime.of(7, 15), LocalDate.parse("07-10-2022", formatter)));
        setores.add(new Rega("D", LocalTime.of(7, 15), LocalTime.of(7, 25), LocalDate.parse("07-10-2022", formatter)));
        setores.add(new Rega("35", LocalTime.of(18, 30), LocalTime.of(18, 45), LocalDate.parse("07-10-2022", formatter)));
        setores.add(new Rega("D", LocalTime.of(18, 45), LocalTime.of(18, 55), LocalDate.parse("07-10-2022", formatter)));


        setores.add(new Rega("35", LocalTime.of(7, 0), LocalTime.of(7, 15), LocalDate.parse("08-10-2022", formatter)));
        setores.add(new Rega("41", LocalTime.of(7, 15), LocalTime.of(7, 43), LocalDate.parse("08-10-2022", formatter)));
        setores.add(new Rega("35", LocalTime.of(18, 30), LocalTime.of(18, 45), LocalDate.parse("08-10-2022", formatter)));
        setores.add(new Rega("41", LocalTime.of(18, 45), LocalTime.of(19, 13), LocalDate.parse("08-10-2022", formatter)));


        setores.add(new Rega("35", LocalTime.of(7, 0), LocalTime.of(7, 15), LocalDate.parse("09-10-2022", formatter)));
        setores.add(new Rega("A", LocalTime.of(7, 15), LocalTime.of(7, 20), LocalDate.parse("09-10-2022", formatter)));
        setores.add(new Rega("D", LocalTime.of(7, 20), LocalTime.of(8, 48), LocalDate.parse("09-10-2022", formatter)));
        setores.add(new Rega("35", LocalTime.of(18, 30), LocalTime.of(18, 45), LocalDate.parse("09-10-2022", formatter)));
        setores.add(new Rega("A", LocalTime.of(18, 45), LocalTime.of(18, 50), LocalDate.parse("09-10-2022", formatter)));
        setores.add(new Rega("D", LocalTime.of(18, 50), LocalTime.of(19, 18), LocalDate.parse("09-10-2022", formatter)));

        SistemaDeRega.setPlanoDeRega(setores);

        boolean result = SistemaDeRega.generateWateringRegisters();

        assertTrue(result);

        String filepath = "files/watering-register/WateringRegisters05-10-2022.csv";

        File file = new File(filepath);

        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String header = reader.readLine();
            assertEquals("Dia,Sector,Duracao,Inicio,Final,Fertirrega", header);
            String line = reader.readLine();
            Rega rega;

            for (int j = 0; j < setores.size(); j++) {
                rega = setores.get(j);
                String lineFromRegaInfo;
                if (rega.getMixDay()) {
                    lineFromRegaInfo = String.format("%s,%s,%s,%s,%s,%s", rega.getData().format(formatter), rega.getIdSetor(), Duration.between(rega.getHoraInicio(), rega.getHoraFim()).toMinutes(), rega.getHoraInicio(), rega.getHoraFim(), rega.getReceita());
                } else {
                    lineFromRegaInfo = String.format("%s,%s,%s,%s,%s,%s", rega.getData().format(formatter), rega.getIdSetor(), Duration.between(rega.getHoraInicio(), rega.getHoraFim()).toMinutes(), rega.getHoraInicio(), rega.getHoraFim(), " -- ");
                }
                assertEquals(lineFromRegaInfo, line);
                line = reader.readLine();
            }

            reader.close();

        } catch (IOException e) {
            fail("IOException occurred when reading the file.");
        }
        if (file.exists()) {
            file.delete();
        }
    }

}