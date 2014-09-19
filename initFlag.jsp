<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="mnc.beacon.beacon.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.parser.ParseException"%>




<%

	String URL = "jdbc:mysql://localhost:3306/dbtest";
	String USER = "root";
	String PASS = "";
	
	
	
	Connection conn = null;
	Statement stat = null;



	
	BufferedWriter bw = new BufferedWriter(new FileWriter("D:\\initFlagLog.txt"));
	

	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(URL, USER, PASS);
		stat = conn.createStatement();
	} catch(SQLException e){
		bw.write(e.toString());
		bw.flush();
	}
	
	
	try {
		stat.executeUpdate("UPDATE eventflag set EVENTVALUE='false'");
	
	}
	
	catch(SQLException e){
		bw.write(e.toString());
		bw.flush();
	}
	
	
	%>
	