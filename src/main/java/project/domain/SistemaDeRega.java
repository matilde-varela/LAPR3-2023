package project.domain;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class SistemaDeRega {
    private static ControladorRega controladorRega = new ControladorRega();

    private static LocalDate inicioDoPlanoDeRega;

    private static List<Rega> planoDeRega;

    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);

    public SistemaDeRega() {
        planoDeRega = new ArrayList<>();
    }

    public static void setPlanoDeRega(List<Rega> planoDeRega) {
        SistemaDeRega.planoDeRega = planoDeRega;
    }

    public static List<Rega> getPlanoDeRegas() {
        return planoDeRega;
    }

    public static void setInicioDoPlanoDeRega(LocalDate dataInicio) {
        inicioDoPlanoDeRega = dataInicio;
    }

    public static ControladorRega getControladorRega() {
        return controladorRega;
    }

    public static LocalDate getInicioDoPlanoDeRega() {
        return inicioDoPlanoDeRega;
    }

    public static boolean generateWateringRegisters() {
        String dateString = inicioDoPlanoDeRega.format(DateTimeFormatter.ofPattern("dd-MM-yyyy")).trim();
        String fileName = "WateringRegisters" + dateString + ".csv";
        File directory = new File("files/watering-register");
        File file = new File(directory, fileName);
        if (!directory.exists()) {
            directory.mkdirs();
        }
        return writeWateringRegisterFile(file);
    }

    private static boolean writeWateringRegisterFile(File file) {
        LocalDate date = inicioDoPlanoDeRega;
        try {
            FileWriter fileWriter = new FileWriter(file);
            fileWriter.write("Dia,Sector,Duracao,Inicio,Final,Fertirrega\n");
            while (date.compareTo(inicioDoPlanoDeRega.plusDays(30)) <= 0) {
                String dateString = date.format(DateTimeFormatter.ofPattern("dd-MM-yyyy")).trim();
                for (Rega rega : planoDeRega) {
                    if (rega.getData().equals(date)) {
                        Duration duration = Duration.between(rega.getHoraInicio(), rega.getHoraFim());
                        String line;
                        if (rega.getMixDay()) {
                            line = String.format("%s,%s,%s,%s,%s,%s\n", dateString, rega.getIdSetor(), duration.toMinutes(), rega.getHoraInicio(), rega.getHoraFim(), rega.getReceita());
                        } else {
                            line = String.format("%s,%s,%s,%s,%s,%s\n", dateString, rega.getIdSetor(), duration.toMinutes(), rega.getHoraInicio(), rega.getHoraFim(), " -- ");
                        }
                        fileWriter.write(line);
                    }
                }
                date = date.plusDays(1);
            }
            fileWriter.close();
            return true;
        } catch (IOException e) {
            return false;
        }
    }

    public static void scheduleNextTask(int index) {
        if (index < planoDeRega.size()) {
            Rega atual = planoDeRega.get(index);
            LocalTime currentTime = LocalTime.now();
            LocalTime scheduledTime = atual.getHoraFim();


            long delay = calculateDelay(currentTime, scheduledTime);

            scheduler.schedule(() -> {

                try {
                    sendToExternalDatabase(atual);
                } catch (IOException | SQLException e) {
                    System.out.println(e.getMessage());
                    throw new RuntimeException(e);
                }

                scheduleNextTask(index + 1);
            }, delay, TimeUnit.MILLISECONDS);
        } else {

            scheduler.shutdown();
        }
    }

    private static void sendToExternalDatabase(Rega rega) throws IOException, SQLException {
        boolean success = controladorRega.sendRegisterToDataBase(rega);
        if (!success) {
            throw new SQLException("ERRO: Não foi possível registar a operação de rega na base de dados.");
        }
    }

    public static long calculateDelay(LocalTime currentTime, LocalTime scheduledTime) {
        long currentMillis = currentTime.toNanoOfDay() / 1_000_000;
        long scheduledMillis = scheduledTime.toNanoOfDay() / 1_000_000;

        if (scheduledMillis < currentMillis) {
            scheduledMillis += TimeUnit.DAYS.toMillis(1);
        }

        return scheduledMillis - currentMillis;
    }

}