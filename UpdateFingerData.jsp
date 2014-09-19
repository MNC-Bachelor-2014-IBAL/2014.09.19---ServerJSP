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
	
	String pnum = null;
	String major = null;
	String rssi = null;
	
	JSONObject jsonMain = new JSONObject(); //객체
	JSONArray jArray = new JSONArray(); //배열
	JSONObject jObject = new JSONObject(); //JSON 내용 담는 객체
	JSONParser parser = new JSONParser(); //파서
	Object obj;
	JSONObject beaconObj = new JSONObject();

	
	BufferedWriter bw = new BufferedWriter(new FileWriter("D:\\fingerDBLog.txt"));
	
	
	String rdata = request.getParameter("fingerdata");

	
	try {
		String str = "request: "+rdata;
		bw.write(str);
		bw.flush();
	} catch(IOException e) {
		
	}
	
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(URL, USER, PASS);
		stat = conn.createStatement();
		/*
		String sql = "DROP TABLE IF EXISTS fingerData";
		stat.execute(sql);
		*/
		
		String sql = "CREATE TABLE IF NOT EXISTS fingerData( PNUM VARCHAR(20) NOT NULL PRIMARY KEY, "+
		"MAJOR VARCHAR(20) NOT NULL, RSSI VARCHAR(20) NOT NULL)";
		
		stat.execute(sql);
		/*
		sql = "INSERT INTO fingerData VALUES ('a','b','c','d')";
		stat.execute(sql);
		*/
		

	} catch(SQLException e){
		bw.write(e.toString());
		bw.flush();
	}
	
	
	try {
		pre = conn.prepareStatement("INSERT INTO fingerData VALUES (?, ?, ?)");

		
		obj = parser.parse(rdata);
		
		beaconObj = (JSONObject) obj;
		
			pnum = beaconObj.get("PNUM").toString();
			major = beaconObj.get("MAJOR").toString();
			rssi = beaconObj.get("RSSI").toString();

			pre.setString(1, pnum);
			pre.setString(2, major);
			pre.setString(3, rssi);

	
			pre.executeUpdate();
		
			bw.write(pnum);
			bw.write(major);
			bw.write(rssi);
			bw.flush();
				

		} catch(ParseException e) {
			bw.write(e.toString());
			bw.flush();
		} catch(NullPointerException e) {
			bw.write(e.toString());
			bw.flush();

		} catch(SQLException e) {
			bw.write(e.toString());
			bw.flush();
		}
	
	
	
	
	try {
		
		String sql = "SELECT * FROM fingerData";
		
		eventResult=stat.executeQuery(sql);
		
		ResultSetMetaData rsmd = eventResult.getMetaData();
		int numberOfColumns = rsmd.getColumnCount();
		
		String json=null;
		
		while (eventResult.next()) {
			for (int i=1; i<=numberOfColumns; i++) {
				
				jObject.put(rsmd.getColumnName(i),eventResult.getString(i));
				
				bw.write(rsmd.getColumnName(i)+":"+eventResult.getString(i));
				bw.flush();
				
			}
	

		}
		
		jArray.add(0, jObject);
		//jArray.add(jObject);
		jsonMain.put("fingerArray", jArray);
	
		out.print(jsonMain);
	} catch (SQLException e) {
		bw.write(e.toString());
		bw.flush();
	}
	
	
	
	
	try {
		//pre.close();
		
		bw.close();
		stat.close();
		
		conn.close();
	} catch (SQLException e) {

	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	%>