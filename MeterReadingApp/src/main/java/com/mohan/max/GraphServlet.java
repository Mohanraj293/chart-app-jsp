package com.mohan.max;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/graphservlet")
public class GraphServlet extends HttpServlet {
	private static final long serialVereionUID = 1L;
  
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			Connection con = Connect.getDB2connection();
			String measurePoint = request.getParameter("point");
			String continuousMeter = request.getParameter("meter");
			HttpSession session = request.getSession();
			
			
			if(measurePoint!=null) {
			session.setAttribute("Point", measurePoint);
			}

			
			if(continuousMeter!=null) {
				List<Double> reading = new ArrayList<Double>();
				List<String> date = new ArrayList<String>();
				List<Double> limit = new ArrayList<Double>();
				try {
					ResultSet re = MeterQueries.getMeterReading(continuousMeter);
					
					while(re.next()) {
						reading.add(re.getDouble(1));
						Timestamp timeStamp = re.getTimestamp(2);
						Date startDate = timeStamp;
						SimpleDateFormat formatter = new SimpleDateFormat("dd-MMM-yyyy HH:MM");
						String strDate = formatter.format(startDate);
						date.add(strDate);
					}
				} catch (SQLException e) {
					e.printStackTrace();
				}
				limit.add(0.0);
				limit.add(0.0);
				limit.add(0.0);
				limit.add(0.0);
				session.setAttribute("reading", reading);
				session.setAttribute("date", date);
				session.setAttribute("limit", limit);
				session.setAttribute("meter", continuousMeter);
			}
			response.sendRedirect("MeterChart.jsp");
	}

}
