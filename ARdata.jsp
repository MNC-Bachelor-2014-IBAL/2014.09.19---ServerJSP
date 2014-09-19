<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
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
	PreparedStatement pre = null;
	ResultSet eventResult = null;
	
	JSONObject jsonMain = new JSONObject(); //°´Ã¼
	JSONArray jArray = new JSONArray(); //¹è¿­
	JSONObject jObject = new JSONObject(); //JSON ³»¿ë ´ã´Â °´Ã¼

	int rowcount = 0;
	
	
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(URL, USER, PASS);
		stat = conn.createStatement();
		

	
	
	try {
		
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(URL, USER, PASS);
		stat = conn.createStatement();
		
		
		String sql = "SELECT * FROM AR";
		
		eventResult=stat.executeQuery(sql);
		
		ResultSetMetaData rsmd = eventResult.getMetaData();
		int numberOfColumns = rsmd.getColumnCount();
		
		String json=null;
		
		while (eventResult.next()) {
			for (int i=1; i<=numberOfColumns; i++) {
				
				jObject.put(rsmd.getColumnName(i),eventResult.getString(i));
						
			}
			jArray.add((rowcount),jObject);
			jObject=new JSONObject();
			++rowcount;
		}
		
		//jArray.add(0, jObject);
		//jArray.add(jObject);
		jsonMain.put("ARdata", jArray);
	
		out.print(jsonMain);
	} catch (SQLException e) {
	
	}
	
	
	
	
	try {

		stat.close();
		
		conn.close();
	} catch (SQLException e) {

	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	%>