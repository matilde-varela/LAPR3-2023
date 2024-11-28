package project.data_access;

import oracle.jdbc.OracleTypes;
import project.ui.console.utils.Utils;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Objects;

public class UnitsRepository {
    public List<String> getUnitDesignations() throws SQLException {
        CallableStatement callStmt = null;
        ResultSet resultSet = null;
        List<String> unidades;

        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call obterListaUnidade() }");

            callStmt.registerOutParameter(1, OracleTypes.CURSOR);

            callStmt.execute();
            resultSet = (ResultSet) callStmt.getObject(1);

            unidades = Utils.resultSetTypeToList(resultSet, "designacaoUnidade");
        } finally {
            if (!Objects.isNull(callStmt)) {
                callStmt.close();
            }
            if (!Objects.isNull(resultSet)) {
                resultSet.close();
            }
        }
        return unidades;
    }


}
