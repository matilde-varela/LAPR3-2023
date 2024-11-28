package project.data_access;

import oracle.jdbc.OracleTypes;
import project.domain.Planta;
import project.ui.console.utils.Utils;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class CultureRepository {
    public List<String> getCultures() throws SQLException {
        CallableStatement callStmt = null;
        ResultSet resultSet = null;
        List<String> list;

        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call obterIntroCulturas() }");

            callStmt.registerOutParameter(1, OracleTypes.CURSOR);

            callStmt.execute();
            resultSet = (ResultSet) callStmt.getObject(1);

            list = Utils.resultSetTypeToList(resultSet, "cultura");
        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
            if (!Objects.isNull(resultSet)) {
                resultSet.close();
            }
        }
        return list;
    }

    public  List<Planta> getCulturesByField(String nomeParcela) throws SQLException {
        CallableStatement callStmt = null;
        ResultSet resultSet = null;
        List<Planta> culturasInstaladas;

        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call obterCulturasValidasDeParcela(?) }");

            callStmt.registerOutParameter(1, OracleTypes.CURSOR);

            callStmt.setString(2, nomeParcela);

            callStmt.execute();

            resultSet = (ResultSet) callStmt.getObject(1);

            culturasInstaladas = resultSetTypeToCultureList(resultSet);
        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
            if (!Objects.isNull(resultSet)) {
                resultSet.close();
            }
        }
        return culturasInstaladas;
    }

    private List<Planta> resultSetTypeToCultureList(ResultSet resultSet) throws SQLException {
        List<Planta> culturasInstaladas = new ArrayList<>();
        while (true) {
            if (!resultSet.next()) break;
            Planta planta = new Planta(
                    resultSet.getString("nomeComum"),
                    resultSet.getString("variedade")
            );
            culturasInstaladas.add(planta);
        }
        return culturasInstaladas;
    }

    public List<String> getPlantGrowthStage() {
        throw new UnsupportedOperationException("Este método ainda não foi implementado.");
    }
}
