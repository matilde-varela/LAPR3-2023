package project.data_access;

import oracle.jdbc.OracleTypes;
import project.ui.console.utils.Utils;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Objects;

public class ProductsRepository {
    public List<String> getProductsByField(String variedade, String nomeComum) throws SQLException {
        CallableStatement callStmt = null;
        ResultSet resultSet = null;
        List<String> list;

        try {
            Connection connection = DatabaseConnection.getInstance().getConnection();
            callStmt = connection.prepareCall("{ ? = call obterIntroProdutos(?,?) }");

            callStmt.registerOutParameter(1, OracleTypes.CURSOR);

            callStmt.setString(2, variedade);
            callStmt.setString(3, nomeComum);

            callStmt.execute();
            resultSet = (ResultSet) callStmt.getObject(1);

            list = Utils.resultSetTypeToList(resultSet, "nomeProduto");
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
