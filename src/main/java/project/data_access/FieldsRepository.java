package project.data_access;

import oracle.jdbc.OracleTypes;
import project.ui.console.utils.Utils;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class FieldsRepository {
    public List<String> getFieldsNames() throws SQLException {
        CallableStatement callStmt = null;
        ResultSet resultSet = null;
        List<String> list;

        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call obterIntroParcelas() }");

            callStmt.registerOutParameter(1, OracleTypes.CURSOR);

            callStmt.execute();
            resultSet = (ResultSet) callStmt.getObject(1);

            list = Utils.resultSetTypeToList(resultSet, "nomeParcela");
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

}
