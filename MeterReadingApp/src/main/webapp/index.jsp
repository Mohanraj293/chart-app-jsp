<%@page import="com.mohan.max.GraphServlet"%>
<%@page import="com.mohan.max.MeterData"%>
<%@page import="com.ibm.db2.jcc.am.re"%>
<%@page import="com.mohan.max.MeterQueries"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.mohan.max.Connect"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html> 
<html>
<head>
<meta charset="ISO-8859-1">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
	<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.3/css/jquery.dataTables.css">
  	<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.js"></script>
  	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
<title>Meter App</title>
</head>
<body class="py-5">
<%String asset = request.getParameter("asset");

List<String> assetNum = new ArrayList<>();
List<String> assetDesc = new ArrayList<>();
List<String> serialNum = new ArrayList<>();
List<String> meter = new ArrayList<>();
List<String> point = new ArrayList<>();
List<String> desc = new ArrayList<>();
List<String> contMeterName = new ArrayList<>();
List<String> contDesc = new ArrayList<>();
List<String> contMeterType = new ArrayList<>();

ResultSet ru = MeterQueries.getAsssets();
ResultSet re = MeterQueries.getMeters(asset);
ResultSet rs = MeterQueries.geConttMeters(asset);

%>
		<div class="assets">
			<div class="card" style="width:800px;margin-left: auto;margin-right: auto;height: 250px; margin-top: 100px;">
			<h5>Asset Performance/Predictive Analysis</h5>
				<div class="container">
				  <div class="row">
				    <div class="col">
						<div class="card-body" style="margin-top: 20px;">
							<form id="form">
								<label for="assets">Asset:  </label> 
								<input class="input" type="text" name="asset" id="assetVal" data-bs-toggle="modal" data-bs-target="#assetModal" required>
							</form>
						</div>
					</div>
					<div class="col">
				 		<div class="card-body" style="margin-top: 20px;">
							<form id="form1" action="graphservlet" method="POST">
								<label for="meter">MeasurePoint:  </label>
								<input class="input" type="text" name="point" id="pointVal" data-bs-toggle="modal" data-bs-target="#meterModal">
						</div>
					</div>
					<div class="col">
				 		<div class="card-body" style="margin-top: 20px;">
								<label for="measurePoint">Meter:  </label>
								<input class="input" type="text" name="meter" id="meterVal" data-bs-toggle="modal" data-bs-target="#pointModal">
						</div>
					</div> 
				</div>
				<input class="meterBtn" type="submit" value="Submit" onclick="">
				<input class="meterBtn" id="configreset" type="reset" value="reset">
				</form>
			</div>
		</div>
					<%
					while(ru.next()){
						assetNum.add(ru.getString(1));
						assetDesc.add(ru.getString(2));
						serialNum.add(ru.getString(3));
					}while(re.next()){
						meter.add(re.getString(1));
						point.add(re.getString(2)); 
						desc.add(re.getString(3));
					}
					while(rs.next()){
						contMeterName.add(rs.getString(1));
						contDesc.add(rs.getString(2)); 
						contMeterType.add(rs.getString(3));
					}
					%>				
		

		<div class="modal fade" id="assetModal" tabindex="-1" aria-labelledby="exampleModalLabel1" aria-hidden="true">
		  <div class="modal-dialog modal-lg">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLabel1">Select Asset</h5>
		        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		      </div>
		      <div class="modal-body">
		      	<table class="table" id="myTable">
				  <thead>
				    <tr>
				      <th scope="col">Asset</th>
				      <th scope="col">Description</th>
				      <th scope="col">Serial No</th>
				    </tr>
				  </thead>
				  <tbody>
				        <%
				    	for(int i=0, j=0,k=0;i<assetNum.size() && j<assetDesc.size() && j<serialNum.size();i++,j++,k++){
				    		out.println("<tr><td onclick=\"submitButton()\" class=\"point\" id=\"asset\" value="+assetNum.get(i)+" data-bs-dismiss=\"modal\" aria-label=\"Close\">"+assetNum.get(i)+"</td><td data-bs-dismiss=\"modal\" aria-label=\"Close\">"+assetDesc.get(j)+"</td><td data-bs-dismiss=\"modal\" aria-label=\"Close\">"+serialNum.get(k)+"</td></tr>");
					    }
					    %>
				  </tbody>
				</table>
		      </div>
		    </div>
		  </div>
		</div>
	
	<div class="modal fade" id="meterModal" tabindex="-1" aria-labelledby="exampleModalLabel1" aria-hidden="true">
		  <div class="modal-dialog modal-lg">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLabel1">Select Measure point</h5>
		        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		      </div>
		      <div class="modal-body">
		      	<table class="table" id="measureTable">
				  <thead>
				    <tr>
				      <th scope="col">Select</th>
				      <th scope="col">Point</th>
				      <th scope="col">Description</th>
				      <th scope="col">Meter Name</th>
				    </tr>
				  </thead>
				  <tbody>
				        <%
				    	for(int i=0, j=0,k=0;i<point.size() && j<meter.size() && k<desc.size();i++,j++,k++){
				    		out.println("<tr><td><input type=\"checkbox\" name=\"measurePointName\" onClick=\"measureCheck();\" value="+point.get(i)+" /></td><td>"+point.get(i)+"</td><td>"+desc.get(k)+"</td><td>"+meter.get(j)+"</td></tr>");
					    }
					    %>
				  </tbody>
				</table>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="meterBtn" data-bs-dismiss="modal">OK</button>
		      </div>
		    </div>
		  </div>
		</div>
		
		<div class="modal fade" id="pointModal" tabindex="-1" aria-labelledby="exampleModalLabel1" aria-hidden="true">
		  <div class="modal-dialog modal-lg">
		    <div class="modal-content">
		      <div class="modal-header">
		        <h5 class="modal-title" id="exampleModalLabel1">Select Meter</h5>
		        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		      </div>
		      <div class="modal-body">
		      	<table class="table" id="meterTable">
				  <thead>
				    <tr>
				    <th scope="col">Select</th>
				      <th scope="col">Meter</th>
				      <th scope="col">Description</th>
				      <th scope="col">Meter Type</th>
				    </tr>
				  </thead>
				  <tbody>
				        <%
				    	for(int i=0, j=0,k=0;i<contMeterName.size() && j<contDesc.size() && k<contMeterType.size();i++,j++,k++){
				    		out.println("<tr><td><input type=\"checkbox\" name=\"meterName\" onClick=\"meterCheck();\" value="+contMeterName.get(i)+" /></td><td data-bs-dismiss=\"modal\" aria-label=\"Close\">"+contMeterName.get(i)+"</td><td data-bs-dismiss=\"modal\" aria-label=\"Close\">"+contDesc.get(j)+"</td></td><td data-bs-dismiss=\"modal\" aria-label=\"Close\">"+contMeterType.get(k)+"</td></tr>");
					    }
					    %>
				  </tbody>
				</table>
		      </div>
		      <div class="modal-footer">
		        <button type="button" class="meterBtn" data-bs-dismiss="modal">OK</button>
		      </div>
		    </div>
		  </div>
		</div>
		
		
		
		
		<!-- Java Scripts -->
		<script type="text/javascript">
		 $(document).ready( function () {
		        $('#myTable').DataTable();
		        $('#measureTable').DataTable();
		        $('#meterTable').DataTable();
		    } );
		 
		 //select table value to set input
		 var table = document.getElementById('myTable');
         
         for(var i = 1; i < table.rows.length; i++)
         {
             table.rows[i].onclick = function()
             {
             	document.getElementById("assetVal").value = this.cells[0].innerHTML;
             };
         }

        //-------------------------------------------------------------------------------------
       //keep form data
         $(document).ready(function(){
             document.getElementById("assetVal").value = localStorage.getItem("item1");
         });
     
         $(window).on('beforeunload', function() {
             localStorage.setItem("item1",document.getElementById("assetVal").value);
         });
     	//-------------------------------------------------------------------------------------	
        //reset from data
         $('#configreset').click(function(){
        	    $('#form')[0].reset();
        	    $('#form1')[0].reset();
         });		
		//---------------------------------------------------------------------------------------
		//submit form with ajax call
		function submitButton(){
			var valu=event.target
			$("#assetVal").val(valu.textContent);
			$("#form").submit().append(valu.textContent);
		}
		
		//pass a selected value to servlet
		function measureCheck(){
		  var measureBox = document.getElementsByName('measurePointName');
		  var measureBoxChecked = [];
		  for (var i=0; i<measureBox.length; i++) {
		     if (measureBox[i].checked) {
		    	 measureBoxChecked.push(measureBox[i].value);
		     }
		  }
		  document.getElementById("pointVal").value = measureBoxChecked;
		
		}
		//pass a selected value to servlet
		function meterCheck(){
		  var meterBox = document.getElementsByName('meterName');
		  var meterBoxChecked = [];
		  for (var i=0; i<meterBox.length; i++) {
		     if (meterBox[i].checked) {
		    	 meterBoxChecked.push(meterBox[i].value);
		     }
		  }
		  document.getElementById("meterVal").value = meterBoxChecked;
		
		}
		function uncheckAll() {
			  document.querySelectorAll('input[type="checkbox"]')
			    .forEach(el => el.checked = false);
			}
		document.querySelector('#configreset').addEventListener('click', uncheckAll)
		</script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/chartjs-plugin-datalabels/2.0.0/chartjs-plugin-datalabels.min.js" integrity="sha512-R/QOHLpV1Ggq22vfDAWYOaMd5RopHrJNMxi8/lJu8Oihwi4Ho4BRFeiMiCefn9rasajKjnx9/fTQ/xkWnkDACg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</body>
</html>