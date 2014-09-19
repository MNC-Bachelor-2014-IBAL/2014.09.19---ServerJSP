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
	
	String test = "";
	
	Connection conn = null;
	Statement stat = null;
	PreparedStatement pre = null;
	ResultSet beaconResult = null;
	ResultSet eventResult = null;
	ResultSet useBeaconResult = null;

	String txPower=null;
	double rssi;
	String major=null;
	String sql=null;
	String preService=null;
	
	String eventName=null;

	
	String startMajor=null;
	double startRssi;
	
	ResultSet startResult=null;
	ResultSet majorResult=null;


		
	JSONObject jsonMain = new JSONObject();
	JSONArray jArray = new JSONArray();
	JSONObject jObject = new JSONObject();
	JSONParser parser = new JSONParser();
	Object obj;
	JSONObject beaconObj = new JSONObject();
	
	ArrayList<String> majorList = new ArrayList<String>();
	ArrayList<Double> rssiList = new ArrayList<Double>();
	
	BufferedWriter bw = new BufferedWriter(new FileWriter("D:\\eventCheckLog.txt"));
	
	
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(URL, USER, PASS);
		stat = conn.createStatement();
	
	
	while(true){		
	

			startResult=stat.executeQuery("SELECT * FROM usebeacon WHERE useid='startbeacon'");
			startResult.next();
			startMajor=startResult.getString(3);
			
			majorResult=stat.executeQuery("SELECT * FROM serviceinfo");
			
			while(majorResult.next()) {
				majorList.add(majorResult.getString(5));
			}
			
		// Start 비콘 읽어 와서 저장
		
		
		
			pre = conn.prepareStatement("SELECT * FROM currentBeacon WHERE major=?");
			pre.setString(1,startMajor);
			beaconResult = pre.executeQuery();
			beaconResult.next();
			
			startRssi=beaconResult.getDouble(5);
			
			bw.write("OKOKOK"+startRssi);
			bw.flush();
			
			if (startRssi > -55){
				
				stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'true' WHERE EVENTID='startservice'");
			}	
	
		// Start 비콘 읽어와서 -55 이상이면 스타트 이벤트 플래그에 트루 설정
	
		
		
		
		
		
		
		
		
		
		
		
					/* 서비스 1인지 2인지 3인지 구분하는것 미사용.
		/*
			for (int i=0; i<majorList.size(); i++)
			{
				
				pre = conn.prepareStatement("SELECT * FROM currentBeacon WHERE major=?");
				pre.setString(1,majorList.get(i));
				beaconResult = pre.executeQuery();
				beaconResult.next();
				rssiList.add(beaconResult.getDouble(5));
			}
	
			*/
	
			
			/* 서비스 1인지 2인지 3인지 구분하는것 미사용.
		
			if (rssiList.get(0)>-65) {
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'true' WHERE EVENTID='service1'");
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'false' WHERE EVENTID='service2'");
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'false' WHERE EVENTID='service3'");
				}
				else if (rssiList.get(1)>-65){
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'true' WHERE EVENTID='service2'");
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'false' WHERE EVENTID='service1'");
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'false' WHERE EVENTID='service3'");
				}
				else if (rssiList.get(2)>-65) {
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'true' WHERE EVENTID='service3'");
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'false' WHERE EVENTID='service1'");
					stat.executeUpdate("UPDATE eventflag SET EVENTVALUE = 'false' WHERE EVENTID='service2'");
				}
			
			
			*/
			
		}
	
	} catch(SQLException e){
	bw.write(e.toString());
	bw.flush();
	}
	 catch(IndexOutOfBoundsException e) {
	bw.write(e.toString());
	bw.flush();
	}



	
	try {
		
		bw.close();
		stat.close();
		
		conn.close();
	} catch (SQLException e) {

	}

	
	%>

