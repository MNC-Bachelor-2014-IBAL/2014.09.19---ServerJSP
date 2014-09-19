<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="mnc.beacon.beacon.*"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.parser.ParseException"%>




<%

	String URL = "jdbc:mysql://localhost:3306/dbtest";
	String USER = "root";
	String PASS = "";
	
	String test = "";
	
	Connection conn = null;
	Statement stat = null;
	PreparedStatement pre = null;
	ResultSet i_rs = null;
	ResultSet m_rs = null;
	
	String txPower=null;
	String rssi=null;
	int compId;
	int advertise;
	String major=null;
	String minor=null;
	String uuid = null;
	String tStamp=null;
		
	JSONObject jsonMain = new JSONObject(); //객체
	JSONArray jArray = new JSONArray(); //배열
	JSONObject jObject = new JSONObject(); //JSON 내용 담는 객체
	JSONParser parser = new JSONParser(); //파서
	Object obj;
	JSONObject beaconObj = new JSONObject();

	
	BufferedWriter bw = new BufferedWriter(new FileWriter("D:\\log5.txt"));
	//request.setCharacterEncoding("8859_1");
	
	String rdata = request.getParameter("abc");
	String str = null;

/*
	try {
		str = "request: "+rdata;
		bw.write(str);
		bw.flush();
	} catch(IOException e) {
		
	}
	*/
	
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(URL, USER, PASS);
		stat = conn.createStatement();
		
		String sql = "DROP TABLE IF EXISTS currentBeacon";
		stat.execute(sql);
		
		String sql = "CREATE TABLE IF NOT EXISTS currentBeacon( MAJOR VARCHAR(20) NOT NULL PRIMARY KEY, "+
		"MINOR VARCHAR(20) NOT NULL, UUID VARCHAR(150) NOT NULL, TXPOWER VARCHAR(20) NOT NULL, "+
		"RSSI VARCHAR(20) NOT NULL, TIMESTAMP VARCHAR(20) NOT NULL)";
		
		stat.execute(sql);

	} catch(SQLException e){
		
	}
	

	
	try {
		
		//pre = conn.prepareStatement("INSERT INTO currentBeacon VALUES (?, ?, ?, ?, ?, ?)");

		
		obj = parser.parse(rdata);
		
		beaconObj = (JSONObject) obj;

		jArray = (JSONArray) beaconObj.get("sendData");
		
		JSONObject j = new JSONObject();
		
		/*
		for (int i=0; i<jArray.size(); i++) {
			j = (JSONObject) jArray.get(i);
		
			minor = j.get("MINOR").toString();
			major = j.get("MAJOR").toString();
			uuid = j.get("UUID").toString();
			txPower = j.get("TXPOWER").toString();
			rssi = j.get("RSSI").toString();
			tStamp = j.get("TIMESTAMP").toString();
		
			pre.setString(1, major);
			pre.setString(2, minor);
			pre.setString(3, uuid);
			pre.setString(4, txPower);
			pre.setString(5, rssi);
			pre.setString(6, tStamp);
	
			pre.executeUpdate();
		
			bw.write(minor);
			bw.write(major);
			bw.write(uuid);
			bw.write(txPower);
			bw.write(rssi);
			bw.write(tStamp);
			bw.flush();
		
		}
		*/
		
		for (int i=0; i<jArray.size(); i++) {
		
			j = (JSONObject) jArray.get(i);
			
			minor = j.get("MINOR").toString();
			major = j.get("MAJOR").toString();
			uuid = j.get("UUID").toString();
			txPower = j.get("TXPOWER").toString();
			rssi = j.get("RSSI").toString();
			tStamp = j.get("TIMESTAMP").toString();
			
			pre = conn.prepareStatement("DELETE FROM currentBeacon WHERE MAJOR=?");
			pre.setString(1,major);
			pre.executeUpdate();
			
			pre = conn.prepareStatement("INSERT INTO currentBeacon VALUES (?, ?, ?, ?, ?, ?)");
		
			bw.write(major);
			bw.write(rssi);
			bw.write(tStamp);
			bw.flush();
		
			pre.setString(1, major);
			pre.setString(2, minor);
			pre.setString(3, uuid);
			pre.setString(4, txPower);
			pre.setString(5, rssi);
			pre.setString(6, tStamp);
			
			pre.executeUpdate();
		
		}
		

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
		//pre.close();
		
		bw.close();
		stat.close();
		
		conn.close();
	} catch (SQLException e) {

	}
	
	
	
	%>

