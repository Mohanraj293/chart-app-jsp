package com.mohan.max;

import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Connect {
	public static Connection getDB2connection() {
		Connection conn = null;
		try {
		FileReader reader=new FileReader("D:\\Workspace\\ChartApp\\src\\main\\webapp\\Sample.properties");
		
		Properties prop=new Properties();  
		prop.load(reader);
		Class.forName(prop.getProperty("jsp.db.driver"));
		String connectionString = prop.getProperty("jsp.db.connectionString");
		conn = DriverManager.getConnection(connectionString,prop.getProperty("jsp.db.username"),prop.getProperty("jsp.db.password"));
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return conn;
		
	}
}
