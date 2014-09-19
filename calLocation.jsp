<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
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
	
	String pnum = null;
	String major = null;
	
	JSONObject jsonMain = new JSONObject(); //객체
	JSONArray jArray = new JSONArray(); //배열
	JSONObject jObject = new JSONObject(); //JSON 내용 담는 객체
	JSONParser parser = new JSONParser(); //파서
	Object obj;
	JSONObject beaconObj = new JSONObject();
	ArrayList<String> beaconList = new ArrayList<String>();
	ArrayList<String> usebeaconList = new ArrayList<String>();
	String sql;
	String str;
	calweight calweight;
	
	double[][] cell;
	
	int[] calcell;
	
	

	int beaconnum=0;
	int cellnum=0;
	int startcellnum=0;
	
	ResultSet rrssi=null;
	ResultSet crssi=null;
	ResultSet flag=null;
	ResultSet serviceinfo=null;
	ResultSet currentbeacon=null;
	ResultSet usebeacon=null;

	
	BufferedWriter bw = new BufferedWriter(new FileWriter("D:\\calDBLog.txt"));
	
	
	String rdata = request.getParameter("request");

	

		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(URL, USER, PASS);
			stat = conn.createStatement();
	
			
			 sql = "CREATE TABLE IF NOT EXISTS fingerData( PNUM VARCHAR(20) NOT NULL PRIMARY KEY, "+
			"MAJOR VARCHAR(20) NOT NULL, RSSI VARCHAR(20) NOT NULL)";
			
			stat.execute(sql);
			
			sql = "DROP TABLE IF EXISTS calWeight";
			stat.execute(sql);
			
			
			sql = "CREATE TABLE IF NOT EXISTS calWeight( CELLNUM VARCHAR(20) NOT NULL PRIMARY KEY, WEIGHT VARCHAR(20) NOT NULL)";
			stat.execute(sql);
	
	
		} catch(SQLException e){
			bw.write(e.toString());
			bw.flush();
		}
	
	

		try {
	
			while(true){
			pre=null;
			flag=null;
		
				
					sql = "SELECT * FROM usebeacon WHERE useid=?";
					pre = conn.prepareStatement(sql);
					pre.setString(1,"service1");
					usebeacon=pre.executeQuery();
				
					while(usebeacon.next()){
						
							beaconList.add(usebeacon.getString(3));
					}
			
	
					
					for(int i =0; i<beaconList.size();++i){
						sql ="SELECT * FROM currentbeacon WHERE major=?";
				
						pre = conn.prepareStatement(sql);
						pre.setString(1,beaconList.get(i));
						currentbeacon=pre.executeQuery();
						if (currentbeacon!=null) {
							
							usebeaconList.add(beaconList.get(i));
							
							
						}
					
					}
					
					
					cell=new double[cellnum][usebeaconList.size()];
					calcell = new int[cellnum];
					calweight = new calweight();
					
					for (int i=0; i<cellnum; i++) {
						for (int j=0; j<usebeaconList.size(); j++) {
						
							pnum = Integer.toString(i+startcellnum) + usebeaconList.get(j);
							
							sql = "SELECT * FROM fingerData WHERE PNUM=?";
							pre = conn.prepareStatement(sql);
							pre.setString(1,pnum);
							rrssi=pre.executeQuery();
							rrssi.next();
							
						
							sql = "SELECT * FROM currentBeacon WHERE MAJOR=?";
							pre = conn.prepareStatement(sql);
							pre.setString(1,usebeaconList.get(j));
							crssi=pre.executeQuery();
							crssi.next();
										
							cell[i][j]=rrssi.getDouble(3);		
							calcell[i]+=calweight.retweight(cell[i][j], crssi.getDouble(5));
							
						}
						pre = conn.prepareStatement("INSERT INTO calWeight VALUES (?, ?)");
						pre.setString(1,Integer.toString(i+startcellnum));
						pre.setString(2,Integer.toString(calcell[i]));
						
						pre.executeUpdate();
					}
		
			
			}
			
		}	
	} catch (SQLException e) {
		bw.write(e.toString());
		bw.flush();
	} catch (ArrayIndexOutOfBoundsException e) {
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