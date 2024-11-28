package project.data_access;

import oracle.jdbc.OracleTypes;
import project.domain.Rega;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Objects;

public class OperacaoRepository {

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

    public OperacaoRepository() {
    }

    public boolean registerSemeaduraOperation(String nomeParcela , String nomeComum, Double quantidadeCultura, String variedade, Date dataOperacao, String tipoUnidadeCultura, Double quantidadeOperacao) throws SQLException {
        CallableStatement callStmt = null;
        boolean success = false;
        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call registarOperacaoSemeadura(?,?,?,?,?,?,?,?,?) }");

            callStmt.registerOutParameter(1, OracleTypes.NUMBER);

            callStmt.setString(2, "Semeadura");
            callStmt.setString(3, tipoUnidadeCultura);
            callStmt.setDouble(4, quantidadeCultura);

            callStmt.setString(5, "kg");
            callStmt.setDouble(6, quantidadeOperacao);

            java.sql.Date sqlDataOp = new java.sql.Date(dataOperacao.getTime());
            callStmt.setDate(7, sqlDataOp);

            callStmt.setString(8, nomeParcela);
            callStmt.setString(9, nomeComum);
            callStmt.setString(10, variedade);

            callStmt.execute();

            int opStatus = callStmt.getInt(1);

            if (opStatus == 1) {
                success = true;
            }

            connection.commit();

        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
        }
        return success;
    }


    public boolean registerFertirregaOperation(Rega rega) throws SQLException {
        CallableStatement callStmt = null;
        boolean success = false;
        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call registarFertirrega(?,?,?,?) }");

            callStmt.registerOutParameter(1, OracleTypes.NUMBER);

            Duration duration = Duration.between(rega.getHoraInicio(), rega.getHoraFim());
            callStmt.setDouble(2, duration.toMinutes());

            LocalDate localDate = LocalDate.parse(rega.getData().toString(), dateFormatter);
            LocalTime localTime = LocalTime.parse(rega.getHoraInicio().toString(), timeFormatter);

            LocalDateTime localDateTime = LocalDateTime.of(localDate, localTime);
            java.util.Date date = java.util.Date.from(localDateTime.atZone(java.time.ZoneId.systemDefault()).toInstant());
            java.sql.Date sqlDate = new java.sql.Date(date.getTime());

            callStmt.setDate(3, sqlDate);

            callStmt.setInt(4, Integer.parseInt(rega.getIdSetor()));

            callStmt.setInt(5, Integer.parseInt(rega.getReceita()));

            callStmt.execute();

            BigDecimal bigDecimalValue = (BigDecimal) callStmt.getObject(1);
            int opStatus = bigDecimalValue.intValue();

            if (opStatus == 0) {
                success = true;
            }

            connection.commit();

        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
        }
        return success;
    }

    public boolean registerRegaOperation(Rega rega) throws SQLException {
        CallableStatement callStmt = null;
        boolean success = false;
        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call registarOperacaoRega(?,?,?,?,?) }");

            callStmt.registerOutParameter(1, OracleTypes.NUMBER);

            callStmt.setString(2, "Rega");
            callStmt.setString(3, "min");

            //Quantidade (minutos de rega)
            Duration duration = Duration.between(rega.getHoraInicio(), rega.getHoraFim());
            callStmt.setDouble(4, duration.toMinutes());

            LocalDate localDate = LocalDate.parse(rega.getData().toString(), dateFormatter);
            LocalTime localTime = LocalTime.parse(rega.getHoraInicio().toString(), timeFormatter);

            LocalDateTime localDateTime = LocalDateTime.of(localDate, localTime);
            java.util.Date date = java.util.Date.from(localDateTime.atZone(java.time.ZoneId.systemDefault()).toInstant());
            java.sql.Date sqlDate = new java.sql.Date(date.getTime());

            callStmt.setDate(5, sqlDate);

            callStmt.setInt(6, Integer.parseInt(rega.getIdSetor()));

            callStmt.execute();

            BigDecimal bigDecimalValue = (BigDecimal) callStmt.getObject(1);
            int opStatus = bigDecimalValue.intValue();

            if (opStatus == 1) {
                success = true;
            }

            connection.commit();

        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
        }
        return success;
    }

    public boolean registerColheitaOperation(String nomeParcela, String nomeComum, String variedade, String nomeProduto, Date dataOperacao, String tipoUnidade, Double quantidade, Date dataFim) throws SQLException {
        CallableStatement callStmt = null;
        boolean success = false;
        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{? = call registarOperacaoColheita(?,?,?,?,?,?,?,?,?) }");

//            int idOperacao = Utils.getNewIdOperation();

            callStmt.registerOutParameter(1, OracleTypes.NUMBER);
//            callStmt.setInt(1, idOperacao);
            callStmt.setString(2, "Colheita");
            callStmt.setString(3, tipoUnidade);
            callStmt.setDouble(4, quantidade);

            java.sql.Date sqlDataOp = new java.sql.Date(dataOperacao.getTime());
            callStmt.setDate(5, sqlDataOp);

            callStmt.setString(6, nomeParcela);
            callStmt.setString(7, nomeComum);
            callStmt.setString(8, variedade);
            callStmt.setString(9, nomeProduto);

            //java.sql.Date sqlDataFinal = new java.sql.Date(dataFim.getTime());
            //callStmt.setDate(9, sqlDataFinal);
            callStmt.setNull(10, java.sql.Types.DATE);

            callStmt.execute();

            BigDecimal bigDecimalValue = (BigDecimal) callStmt.getObject(1);
            int opStatus = bigDecimalValue.intValue();

            if (opStatus == 0) {
                success = true;
            }

            connection.commit();

        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
        }

        return success;
    }



    public boolean registarOperacaoMonda(String nomeParcela, String nomeComum, String variedade, Date dataOperacao, Double quantidade) throws SQLException {
        CallableStatement callStmt = null;
        boolean success = false;
        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call registarOperacaoMonda(?,?,?,?,?,?) }");

            callStmt.registerOutParameter(1, OracleTypes.NUMBER);

            callStmt.setString(2, "Monda");
            callStmt.setDouble(3, quantidade);

            java.sql.Date sqlDataOp = new java.sql.Date(dataOperacao.getTime());
            callStmt.setDate(4, sqlDataOp);

            callStmt.setString(5, nomeParcela);
            callStmt.setString(6, nomeComum);
            callStmt.setString(7, variedade);

            callStmt.execute();

            BigDecimal bigDecimalValue = (BigDecimal) callStmt.getObject(1);
            int opStatus = bigDecimalValue.intValue();

            if (opStatus == 0) {
                success = true;
            }

            connection.commit();

        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
        }
        return success;
    }

    public boolean registarAplicacaoFatorProducao(String designacaoOperacao, String designacaoUnidade, Integer qtd, Date dataOperacao, String nomeFator, String nomeParcela, Date dataInicial, String nomeComum, String variedade) throws SQLException {
        CallableStatement callStmt = null;
        boolean success = false;
        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call RegistoAplicacaoFatorProducao(?,?,?,?,?,?,?,?,?) }");

            callStmt.registerOutParameter(1, OracleTypes.NUMBER);

            callStmt.setString(2, designacaoOperacao);
            callStmt.setString(3, designacaoUnidade);
            callStmt.setDouble(4, qtd);

            java.sql.Date sqlDataOp = new java.sql.Date(dataOperacao.getTime());
            callStmt.setDate(5, sqlDataOp);

            callStmt.setString(6, nomeFator);

            callStmt.setString(7, nomeParcela);

            java.sql.Date sqlDataInicial = new java.sql.Date(dataInicial.getTime());
            callStmt.setDate(8, sqlDataInicial);

            callStmt.setString(9, nomeComum);

            callStmt.setString(10, variedade);

            callStmt.execute();

            BigDecimal bigDecimalValue = (BigDecimal) callStmt.getObject(1);
            int opStatus = bigDecimalValue.intValue();

            if (opStatus == 0) {
                success = true;
            }

            connection.commit();

        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
        }
        return success;
    }

    public boolean verifyIfAplicationOperationExists(String desigOp, String desigUnidade, Integer qtd, Date dataOp, String nmFator) throws SQLException {
        CallableStatement callStmt = null;
        boolean exists = false;
        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call verificarSeOperacaoExiste(?,?,?,?,?) }");

            callStmt.registerOutParameter(1, OracleTypes.NUMBER);

            callStmt.setString(2, desigOp);
            callStmt.setString(3, desigUnidade);
            callStmt.setDouble(4, qtd);

            java.sql.Date sqlDataOp = new java.sql.Date(dataOp.getTime());
            callStmt.setDate(5, sqlDataOp);

            callStmt.setString(6, nmFator);

            callStmt.execute();

            BigDecimal bigDecimalValue = (BigDecimal) callStmt.getObject(1);
            int foundOp = bigDecimalValue.intValue();

            if (foundOp == 0) {
                exists = true;
            }

            connection.commit();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
        }
        return exists;
    }
}