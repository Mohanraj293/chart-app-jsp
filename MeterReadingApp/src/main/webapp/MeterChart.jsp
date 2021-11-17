<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.Objects"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Arrays"%>
<%@page import="javax.print.attribute.HashAttributeSet"%>
<%@page import="com.mohan.max.GraphServlet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.mohan.max.MeterData"%>
<%@page import="com.mohan.max.MeterQueries"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="com.mohan.max.Connect"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC"
	crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.0.js"
	integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
	crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css"
	href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
<script type="text/javascript" charset="utf8"
	src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.js"></script>
<script type="text/javascript"
	src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/chartjs-plugin-datalabels/2.0.0/chartjs-plugin-datalabels.min.js"
	integrity="sha512-R/QOHLpV1Ggq22vfDAWYOaMd5RopHrJNMxi8/lJu8Oihwi4Ho4BRFeiMiCefn9rasajKjnx9/fTQ/xkWnkDACg=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/chartjs-plugin-annotation/1.0.2/chartjs-plugin-annotation.min.js"
	integrity="sha512-FuXN8O36qmtA+vRJyRoAxPcThh/1KJJp7WSRnjCpqA+13HYGrSWiyzrCHalCWi42L5qH1jt88lX5wy5JyFxhfQ=="
	crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/style.css">
<title>Meter Readings</title>
</head>
<body>
		
		
		<div id="carouselExampleControls" class="carousel carousel-dark slide" data-ride="carousel" data-bs-interval="false">
		  <div class="carousel-inner" id="inner">
		  </div>
		  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="prev">
		    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Previous</span>
		  </button>
		  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="next">
		    <span class="carousel-control-next-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Next</span>
		  </button>
		</div>
		<p id="pa"></p>

		
		
	<div class="chart-container">
		<div id="chart-gen" class="chart-div"></div>
	</div>

	<script>
		<%String str1 = (String) session.getAttribute("Point");
		String str2 = (String) session.getAttribute("meter");
		ArrayList<Double> reading = (ArrayList<Double>)session.getAttribute("reading");
		ArrayList<String> date = (ArrayList<String>)session.getAttribute("date");
		ArrayList<Double> limit = (ArrayList<Double>)session.getAttribute("limit");
		
		
		
String[] point = {};

String[] meter = {};

String newArray[] = {};

if(!str1.isEmpty()&&!str2.isEmpty()){
	point=str1.split(",");
	meter=str2.split(",");
	newArray =new String[point.length+meter.length];
	for(int i=0; i<point.length; i++) {
	    newArray[i]= point[i];
	 }
	for(int i=0, j=point.length; j<(point.length + meter.length); j++, i++) {
			newArray[j] = meter[i];
	}
}

else if(!str1.isEmpty()&&str2.isEmpty()){
	point=str1.split(",");
	newArray= new String[point.length];
	for(int i=0;i<point.length;i++){
		newArray[i]=point[i];
	}
}

else if(str1.isEmpty()&&!str2.isEmpty()){
	meter=str2.split(",");
	newArray= new String[meter.length];
	for(int i=0;i<meter.length;i++){
		newArray[i]=meter[i];
	}
}



ResultSet rs = null;
ResultSet rt = null;
try {
	List<String> readingDate[];
	List<Double> readings[];
	List<Double> limitValues[];
	
	readingDate = new ArrayList[point.length];	
	readings = new ArrayList[point.length];	
	limitValues = new ArrayList[point.length];
	
	if(!str1.isEmpty()&&str2.isEmpty()){
	for (int i = 0; i < point.length; i++) {
		rs = MeterQueries.getMeasurement(point[i]);
		rt = MeterQueries.getMeasurePoint(point[i]);
		readingDate[i] = new ArrayList<>();
		readings[i] = new ArrayList<>();
		limitValues[i] = new ArrayList<>();

		while (rs.next()) {
			readings[i].add(rs.getDouble(1));
			Timestamp timeStamp = rs.getTimestamp(2);
			Date startDate = timeStamp;
			SimpleDateFormat formatter = new SimpleDateFormat("dd-MMM-yyyy HH:MM");
			String strDate = formatter.format(startDate);
			readingDate[i].add(strDate);
			
		}
		while (rt.next()) {
			limitValues[i].add(rt.getDouble(1));
			limitValues[i].add(rt.getDouble(2));
			limitValues[i].add(rt.getDouble(3));
			limitValues[i].add(rt.getDouble(4));
			}
		 
	}
	}
	if(!str1.isEmpty()&&!str2.isEmpty()){
		for (int i = 0; i < point.length; i++) {
			rs = MeterQueries.getMeasurement(point[i]);
			rt = MeterQueries.getMeasurePoint(point[i]);
			readingDate[i] = new ArrayList<>();
			readings[i] = new ArrayList<>();
			limitValues[i] = new ArrayList<>();

			while (rs.next()) {
				readings[i].add(rs.getDouble(1));
				Timestamp timeStamp = rs.getTimestamp(2);
				Date startDate = timeStamp;
				SimpleDateFormat formatter = new SimpleDateFormat("dd-MMM-yyyy HH:MM");
				String strDate = formatter.format(startDate);
				readingDate[i].add(strDate);
				
			}
			while (rt.next()) {
				limitValues[i].add(rt.getDouble(1));
				limitValues[i].add(rt.getDouble(2));
				limitValues[i].add(rt.getDouble(3));
				limitValues[i].add(rt.getDouble(4));
				}
			 
		}
		readingDate = MeterQueries.addElement(readingDate, date);
		readings = MeterQueries.addElement(readings, reading);
		limitValues = MeterQueries.addElement(limitValues, limit);
		}

	if(!str2.isEmpty() && str1.isEmpty()){	
		readingDate = MeterQueries.addElement(readingDate, date);
		readings = MeterQueries.addElement(readings, reading);
		limitValues = MeterQueries.addElement(limitValues, limit);
	}
	if(str2.isEmpty() && str1.isEmpty()){	
		%>var p = document.getElementById("pa");
		var g = document.createElement("p");
		g.innerHTML="No values Selected, Please go back and select some values and try again...!";
		p.appendChild(g);<%
	}


	%>
	

		var chartData = [];
	     <%for (int i = 0; i < newArray.length; i++) {%>
	     var xValues = new Array(<%out.print("\"" + readingDate[i].get(0) + "\"");
			for (int j = 1; j < readingDate[i].size(); j++) {
				out.print(", \"" + readingDate[i].get(j) + "\"");
			}%>)
			var yValues = new Array(<%out.print("\"" + readings[i].get(0) + "\"");
			for (int j = 1; j < readings[i].size(); j++) {
				out.print(", \"" + readings[i].get(j) + "\"");
			}%>)
	 	var limitVal = new Array(<%out.print("\"" + limitValues[i].get(0) + "\"");
			for (int j = 1; j < limitValues[i].size(); j++) {
				out.print(", \"" + limitValues[i].get(j) + "\"");
			}%>)
			var valuesX = xValues.slice(-20);
			var valuesY = yValues.slice(-20);
	        chartData.push({
	          plugins: [ChartDataLabels],
	          code: "<%=newArray[i]%>",
	          type: "line",
	          data: {
	            labels: valuesX,
	            datasets: [
	              {
	                label: "<%=newArray[i]%>",
	                data: valuesY,
	                backgroundColor: "blue",
	                borderColor: "lightblue",
	                borderWidth: 1,
	                datalabels: {
	                  anchor: "end",
	                  align: "top",
	                  offset: 2,
	                },
	              },
	            ],
	          },
	          options: {
	            scales: {
	              y: {
	                beginAtZero: true,
	              },
	            },
	            plugins: {
	              autocolors: false,
	              annotation: {
	            	  annotations: {
					        line1: {
					          adjustScaleRange:true,
					          drawTime:'afterDatasetsDraw',
					          type: 'line',
					          scaleID:'y',
					          drawTime:'afterDatasetsDraw',
					          value:limitVal[0],
					          borderColor: 'rgb(255, 99, 132)',
					          borderWidth: 2,
					          label:{
					        	  enabled:true,
					        	  content:limitVal[0],
					        	  borderColor: 'rgb(255, 99, 132)',
					        	  backgroundColor:'rgb(255, 99, 132)'
					          }
					        },
					        line2: {
				        	  adjustScaleRange:true,
					          drawTime:'afterDatasetsDraw',
					          type: 'line',
					          scaleID:'y',
					          value:limitVal[1],
					          borderColor: 'rgb(255, 193, 5)',
					          borderWidth: 2,
					          label:{
					        	  enabled:true,
					        	  content:limitVal[1],
					        	  borderColor: 'rgb(255, 193, 5)',
					        	  backgroundColor:'rgb(255, 193, 5)'
					          }
			    		     },
			    		     line3: {
				        	  adjustScaleRange:true,
					          drawTime:'afterDatasetsDraw',
					          type: 'line',
					          scaleID:'y',
					          value:limitVal[2],
					          borderColor: 'rgb(255, 193, 5)',
					          borderWidth: 2,
					          label:{
					        	  enabled:true,
					        	  content:limitVal[2],
					        	  borderColor: 'rgb(255, 193, 5)',
					        	  backgroundColor:'rgb(255, 193, 5)'
					          }
			    		     },
					        line4: {
					        	  adjustScaleRange:true,
			    		          drawTime:'afterDatasetsDraw',
			    		          type: 'line',
			    		          scaleID:'y',
			    		          value:limitVal[3],
			    		          borderColor: 'rgb(255, 99, 132)',
			    		          borderWidth: 2,
			    		          label:{
			    		        	  enabled:true,
			    		        	  content:limitVal[3],
			    		        	  borderColor: 'rgb(255, 99, 132)',
			    		        	  backgroundColor:'rgb(255, 99, 132)'
			    		          }
				    		 }
					      },
	              },
	            },
	          },
	        });
	      <%}%>
	      chartData.forEach((config, index) => {
	    	  var innerDiv= document.createElement("div");
	    	  innerDiv.className="carousel-item";
	          var canvas = document.createElement("canvas"),
	            chartId = config.code;
	          canvas.id = chartId;
	          canvas.className="myChart";
	          innerDiv.append(canvas);
	    	  var he = document.getElementById("inner");
	    	  he.appendChild(innerDiv);
	          var context = document.getElementById(chartId).getContext("2d");
	          const myChart = new Chart(context, config);
	        });	
        <%} catch (Exception e) {
out.print("no values");
}%>
$('.carousel-item').first().addClass('active');
</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM"
		crossorigin="anonymous"></script>
</body>
</html>