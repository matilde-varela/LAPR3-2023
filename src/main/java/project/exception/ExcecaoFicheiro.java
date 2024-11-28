package project.exception;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class ExcecaoFicheiro extends Exception {

    public ExcecaoFicheiro(String s) {
        super(s);
    }

    public static void verificarFicheiro(String caminho, String extensao) throws ExcecaoFicheiro {
        File ficheiro = new File(caminho);

        if (!ficheiro.exists()) {
            throw new ExcecaoFicheiro("ERRO: Ficheiro não encontrado no caminho especificado.");
        }

        if (!ficheiro.isFile()) {
            throw new ExcecaoFicheiro("ERRO: Caminho especificado não é um ficheiro.");
        }

        if (!ficheiro.canRead()) {
            throw new ExcecaoFicheiro("ERRO: Não é possível ler o ficherio no caminho especificado devido a permissões insuficientes.");
        }

        if (!caminho.toLowerCase().endsWith(extensao)) {
            throw new ExcecaoFicheiro("ERRO: Ficheiro não possui a extensão correta.");
        }
    }

    public static void verificarEstruturaFicheiro(File ficheiro) throws ExcecaoFicheiro {
        try (BufferedReader br = new BufferedReader(new FileReader(ficheiro))) {
            String linhaHoras;
            String linha;
            linhaHoras = br.readLine();
            validarLinhaHoras(linhaHoras);
            while ((linha = br.readLine()) != null) {
                validarLinha(linha);
            }
        } catch (IOException e) {
            throw new ExcecaoFicheiro("ERRO: Problemas na verificação da estrutura do ficheiro.");
        }
    }

    private static void validarLinhaHoras(String linha) throws ExcecaoFicheiro {
        String[] arr = linha.trim().split(",");

        for (int i = 0; i < arr.length; i++) {
            String hora = arr[i].trim();
            try {
                ExcecaoHora.verificarHora(hora);
            } catch (ExcecaoHora e) {
                throw new ExcecaoFicheiro("ERRO: Conteúdo ficheiro não corresponde ao esperado.\nA primeira linha deve ter as horas de rega com o seguinte formato: hh:mm, hh:mm, etc.");
            }
        }
    }

    private static void validarLinha(String linha) throws ExcecaoFicheiro {
        if (!linha.matches("^[A-Za-z0-9]+,\\d{1,2},[TIP3](,[A-Za-z0-9]+,\\d{1,2})?$")) {
            throw new ExcecaoFicheiro("ERRO: Conteúdo ficheiro não corresponde ao esperado.\nAs linhas com os setores a serem regados devem ter o seguinte formato:\n <parcela: [A-Z], duração, regularidade: [T,I,P,3]>, por exemplo A,14,T, ou opcionalmente, com o campo adicional, por exemplo A,14,T,mix1,5.");
        }
    }

    public static void validarPlanoRega(File ficheiro) throws ExcecaoFicheiro, IOException {
        List<LocalTime> horasRega = new ArrayList<>();
        LocalTime tempoAtualP;
        LocalTime tempoAtualI;


        try (BufferedReader br = new BufferedReader(new FileReader(ficheiro))) {
            String linha = br.readLine();
            validarLinhaHoras(linha);
            getHorasRega(linha.split(","), horasRega);

            tempoAtualP = horasRega.get(0);
            tempoAtualI = horasRega.get(0);

            while ((linha = br.readLine()) != null) {
                validarLinha(linha);
                String[] info = linha.split(",");
                int duracao = Integer.parseInt(info[1]);

                if (!info[2].equals("P")) {
                    tempoAtualI = tempoAtualI.plusMinutes(duracao);
                }
                if (!info[2].equals("I")) {
                    tempoAtualP = tempoAtualP.plusMinutes(duracao);
                }
                if (horasRega.size() > 1) {
                    if (tempoAtualI.isAfter(horasRega.get(1)) || tempoAtualP.isAfter(horasRega.get(1))) {
                        throw new ExcecaoFicheiro("ERRO: Sobreposição de horas de rega.");
                    }
                }
                if (info.length == 5) {
                    validarFertirrega(info);
                }
            }
        } catch (IOException e) {
            throw new ExcecaoFicheiro("ERRO: Problemas na validação plano de rega.");
        }
    }

    public static void validarFertirrega(String[] info) throws ExcecaoFicheiro {
        int dayNumber = LocalDate.now().getDayOfMonth();
        String reg = info[2];
        int recorrencia = Integer.parseInt(info[4]);

        if (reg.equalsIgnoreCase("t")) {
            return;
        }

        int day = dayNumber;

        for (int i = 2; i < 29; i++) {
            day++;
            LocalDate dataPlano = LocalDate.now().withDayOfMonth(dayNumber).plusDays((day - dayNumber));

            if (dataPlano.getMonthValue() != LocalDate.now().getMonthValue()) {
                day = 1;
            }

            if ((i % recorrencia == 0) && ((day % 2 == 0 && reg.equalsIgnoreCase("i")) || (day % 2 != 0 && reg.equalsIgnoreCase("p")) || (day % 3 != 0 && reg.equalsIgnoreCase("3")))) {
                throw new ExcecaoFicheiro("ERRO: Inválida recorrência da fertirrega para a regularidade apresentada - " + String.join(", ", info));
            }
        }
    }

    private static void getHorasRega(String[] arrHorasRegas, List<LocalTime> horasRega) {
        for (int i = 0; i < arrHorasRegas.length; i++) {
            horasRega.add(LocalTime.parse(arrHorasRegas[i].trim()));
        }

    }

    public static void verificarFicheiroHorarios(File ficheiro) throws ExcecaoFicheiro, ExcecaoHora {
        try (BufferedReader br = new BufferedReader(new FileReader(ficheiro))) {
            String linha;
            while ((linha = br.readLine()) != null) {
                verificarLinhaHorarios(linha);
                String[] partes = linha.split(",");
                for (int i = 1; i < 3; i++) {
                    ExcecaoHora.verificarHora(partes[i].trim());
                }
            }
        } catch (IOException e) {
            throw new ExcecaoFicheiro("ERRO: Problemas na verificação da estrutura do ficheiro.");
        }
    }

    private static void verificarLinhaHorarios(String linha) throws ExcecaoFicheiro {
        if (!linha.matches("^CT\\d+,[0-9]{2}:[0-9]{2},[0-9]{2}:[0-9]{2}$")) {
            throw new ExcecaoFicheiro("ERRO: Conteúdo do ficheiro não corresponde ao esperado.\nAs linhas com os horários dos hubs devem ter o seguinte formato: CT[1-213],hh:mm,hh:mm.");
        }
    }
}