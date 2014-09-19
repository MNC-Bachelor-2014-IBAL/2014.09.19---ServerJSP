<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="mnc.beacon.survey.*"%>
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
	
	ResultSet locResult = null;
	
	int beaconnumber=6;
	int cellnumber=8;
	
	
	JSONObject jsonMain = new JSONObject(); //객체
	JSONArray jArray = new JSONArray(); //배열
	JSONObject jObject = new JSONObject(); //JSON 내용 담는 객체
	JSONParser parser = new JSONParser(); //파서
	Object obj;
	JSONObject beaconObj = new JSONObject();
	String sql;

	double[][] cell;
	
	int[] calcell;
	
	ResultSet rrssi=null;
	ResultSet crssi=null;
	ResultSet serviceinfo;
	int cellnum;
	int startcellnum=0;
	ResultSet flag=null;

	
	BufferedWriter bw = new BufferedWriter(new FileWriter("D:\\returnLocDBLog.txt"));
	

	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(URL, USER, PASS);
		stat = conn.createStatement();

	} catch(SQLException e){
		bw.write(e.toString());
		bw.flush();
	}
	

	try {
		
	
	
		pre=null;
		flag=null;
		sql = "SELECT * FROM serviceinfo WHERE servicename=?";
		pre = conn.prepareStatement(sql);
		pre.setString(1,"service1");
		flag=pre.executeQuery();
		flag.next();

		startcellnum=flag.getInt(4);


		pre=null;
		flag=null;	
		sql = "SELECT * FROM eventflag WHERE eventid=?";
		pre = conn.prepareStatement(sql);
		pre.setString(1,"service1");
		flag=pre.executeQuery();
		flag.next();
		
		
		
				
				sql = "SELECT * FROM serviceinfo WHERE servicename=?";
				pre = conn.prepareStatement(sql);
				pre.setString(1,"service1");
				serviceinfo=pre.executeQuery();
				serviceinfo.next();
				cellnum=serviceinfo.getInt(3);
		
				
			
			 sql = "SELECT * FROM calWeight WHERE CELLNUM=?";
			 
				calcell = new int[cellnum];
			
				for (int i=0; i<(cellnum); i++) {
					pre = conn.prepareStatement(sql);	
					pre.setString(1,Integer.toString(startcellnum+i));
					locResult=pre.executeQuery();
					
					if (locResult.next()) {
					calcell[i]=locResult.getInt(2);
					
				//	bw.write(Integer.toString(i)+":"+locResult.getString(2));
			//		bw.flush();
					}
					pre=null;
					flag=null;
				}
			
			
		
		
				int highindex=0;
				int highnum=0;
				highnum=calcell[0];
				for(int i=0;i<cellnum;++i){
					if (highnum<calcell[i]) {
						highnum = calcell[i];
						highindex=i;
						
					}
					jObject.put("calcell"+Integer.toString(i+startcellnum),calcell[i]);
				}
				
		
				jObject.put("index",highindex+startcellnum);
				jObject.put("rssi",highnum);
				jObject.put("startcellnum",startcellnum);
				jObject.put("cellnum",cellnum);
				out.print(jObject);
		
		

	} catch (SQLException e) {
		bw.write(e.toString());
		bw.flush();
	} catch (ArrayIndexOutOfBoundsException e) {
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