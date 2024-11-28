package project.ui.console.sistema_rega;

import project.data_access.OperacaoRepository;
import project.domain.Rega;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;

public class RegaTesteUI implements Runnable {
    @Override
    public void run() {
        Rega teste = new Rega("21", LocalTime.of(22, 15), LocalTime.of(22, 16), LocalDate.now());

        OperacaoRepository operacaoRepository = new OperacaoRepository();

        try {
            boolean success = operacaoRepository.registerRegaOperation(teste);

            if (success){
                System.out.println("success");
            }else {
                System.out.println("failure");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
