package project.controller;

import project.data_access.DatabaseConnection;

import java.sql.SQLException;

public class DatabaseConnectionTestController {

    public DatabaseConnectionTestController() {
    }

    public int DatabaseConnectionTest() throws SQLException {
        int testResult = DatabaseConnection.getInstance().testConnection();
        return testResult;
    }
}
