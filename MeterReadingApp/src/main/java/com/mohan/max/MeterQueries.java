package com.mohan.max;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.List;

public class MeterQueries {
	static Connection con = Connect.getDB2connection();
	public static ResultSet getAsssets() throws SQLException {
		String asset = "select assetnum,description,serialnum from maximo.asset where assetnum in(select assetnum from maximo.measurement)";
		Statement st = con.createStatement();   
		ResultSet ru = st.executeQuery(asset);
		return ru;
	}
	public static ResultSet getMeters(String asset) throws SQLException {
		String meter = "select metername,pointnum,description from maximo.measurepoint where assetnum is not null and assetnum=?";
		PreparedStatement st1 = con.prepareStatement(meter);
		st1.setString(1, asset);
		ResultSet re = st1.executeQuery();
		return re;
	}
	public static ResultSet geConttMeters(String asset) throws SQLException {
		String cont = "SELECT maximo.meter.metername,maximo.meter.description,maximo.meter.metertype FROM maximo.meter LEFT OUTER JOIN maximo.assetmeter ON maximo.meter.metername = maximo.assetmeter.metername where metertype='CONTINUOUS' and maximo.assetmeter.assetnum=?";
		PreparedStatement st2 = con.prepareStatement(cont); 
		st2.setString(1, asset);
		ResultSet ru = st2.executeQuery();
		return ru;
	}
	
	public static ResultSet getMeasurement(String point) throws SQLException {
		String measurement = "select measurementvalue,measuredate from maximo.measurement where pointnum=?";
		PreparedStatement st2 = con.prepareStatement(measurement); 
		st2.setString(1, point);
		ResultSet rs = st2.executeQuery();
		return rs;
	}
	public static ResultSet getMeasurePoint(String point) throws SQLException {
		String measurement = "select UPPERACTION,UPPERWARNING,LOWERWARNING,LOWERACTION from maximo.measurepoint where pointnum=?";
		PreparedStatement st3 = con.prepareStatement(measurement); 
		st3.setString(1, point);
		ResultSet rt = st3.executeQuery();
		return rt;
	}
	public static ResultSet getMeterReading(String continuousMeter) throws SQLException{
		String meterReading = "select reading,readingdate from maximo.meterreading where metername = ?";
		PreparedStatement st4 = con.prepareStatement(meterReading); 
		st4.setString(1, continuousMeter);
		ResultSet rv = st4.executeQuery();
		return rv;
	}
	public static List[] addElement(List[] a, List e) {
	    a  = Arrays.copyOf(a, a.length + 1);
	    a[a.length - 1] = e;
	    return a;
	}	
}
