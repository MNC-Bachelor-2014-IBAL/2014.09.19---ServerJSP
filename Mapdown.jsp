<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "org.json.simple.JSONObject" %>
<%@ page import = "org.json.simple.JSONArray" %>

<%
	String URL = "jdbc:mysql://localhost:3306/dbtest";
	String USER = "root";
	String PASS = "";
	
	Connection conn = null;
	Statement stat = null;
	ResultSet i_rs = null;
	ResultSet m_rs = null;
	
	request.setCharacterEncoding("utf-8");
	
	String id = request.getParameter("id");
	//String location = request.getParameter("location");
	String location = "CSE";
	
	JSONObject jsonMain = new JSONObject(); //객체
	JSONArray jArray = new JSONArray(); //배열
	JSONObject jObject = new JSONObject(); //JSON 내용 담는 객체
	
	//Vector vecList = new Vector();



	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(URL, USER, PASS);
		stat = conn.createStatement();
		
		String sql = "DROP TABLE IBeacon_info";
		stat.execute(sql);
		
		/*
		sql = "DROP TABLE Map_info";
		stat.execute(sql);
		*/
		
		/*
		sql = "CREATE TABLE IBeacon_info( ID VARCHAR(12) NOT NULL PRIMARY KEY, "+
		"NAME VARCHAR(12) NOT NULL, LOCATION VARCHAR(20) NOT NULL, MAP MEDIUMBLOB NOT NULL )";
		*/
		
		sql = "CREATE TABLE IBeacon_info( ID VARCHAR(12) NOT NULL PRIMARY KEY, "+
		"NAME VARCHAR(12) NOT NULL, LOCATION VARCHAR(20) NOT NULL)";
		
		stat.execute(sql);
		
		stat.execute("INSERT INTO IBeacon_info VALUES (1, 'TEST', 'CSE')");
		
	} catch(SQLException e){
		
	}
	
	
	// image 저장
	try {
		/*	image를 DB에 BLOB으로 저장(byte)
		String sql = "CREATE TABLE Map_info ( LOCATION VARCHAR(20) NOT NULL, MAP MEDIUMBLOB NOT NULL) ";
		stat.execute(sql);
		
		File imgfile = new File("C:\\Users\\Administrator\\Desktop\\image.jpg");
        FileInputStream fin = new FileInputStream(imgfile);
		
		PreparedStatement pre = conn.prepareStatement("INSERT INTO Map_info VALUES ('CSE', ?)");
		pre.setBinaryStream(1, fin, (int)imgfile.length());
		
		pre.executeUpdate();
		*/
		
		
		String sql = "CREATE TABLE Map_info ( LOCATION VARCHAR(20) NOT NULL, MAP VARCHAR(50) NOT NULL) ";
		stat.execute(sql);
		
		PreparedStatement pre = conn.prepareStatement("INSERT INTO Map_info VALUES ('CSE', ?)");
		//pre.setBinaryStream(1, fin, (int)imgfile.length());
		
		pre.setString(1, "http://192.168.1.23:8088/image.gif");
		pre.executeUpdate();
		
				
	} catch(SQLException e) {

	}
	
	
	
	try {

		
		
		
		
		String sql = "SELECT * FROM IBeacon_info WHERE ID=?";
		PreparedStatement pre = conn.prepareStatement(sql);
		
		pre.setString(1,id);
		
		i_rs=pre.executeQuery();
		
		
		//Image
		sql = "SELECT Map FROM Map_info WHERE LOCATION=?";
		pre = conn.prepareStatement(sql);
		
		pre.setString(1,location);
		
		m_rs = pre.executeQuery();
		
		
		/* 	BLOB image 처리
		InputStream input = null;
		
		out.clear();
		out=pageContext.pushBody();
		
		OutputStream output = response.getOutputStream();
		
		while(m_rs.next()) {
			input = m_rs.getBinaryStream("Map");
			int byteRead;
			while ((byteRead = input.read()) != -1) {
				output.write(byteRead);
			}
			input.close();
		}
		
		*/
			
			
		/*
		while (rs.next()) {
	out.println(rs.getString(1));
	out.println(rs.getString(2));
	out.println(rs.getString(3));
		}
		*/

		ResultSetMetaData rsmd = i_rs.getMetaData();
		int numberOfColumns = rsmd.getColumnCount();

		String json=null;
		
		while (i_rs.next()) {
			for (int i=1; i<=numberOfColumns; i++) {
				
				jObject.put(rsmd.getColumnName(i),i_rs.getString(i));
				
				//json=rsmd.getColumnName(i)+":"+rs.getString(i);
				//out.println(json);
				
			}
			
			jObject.put("map", "http://192.168.1.23:8088/image.gif");
			
			

		}
		
		jArray.add(0, jObject);
		//jArray.add(jObject);
		jsonMain.put("datasend", jArray);

		out.print(jsonMain);
		//out.flush();


	} catch (SQLException e) {

	}

	try {
		stat.close();
		conn.close();
	} catch (SQLException e) {

	}
	


%>
