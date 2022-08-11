package com.project.dbConnect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.google.gson.Gson;

public class DBDao implements DBDaoInterFace {

	//싱글턴 패턴 생성 후 하나의 인스턴스만 계속 사용
	public static DBDao instance = new DBDao();
	public static DBDao getInstance() {
		return instance;
	}
	
	//Mysql 연결
	@Override
	public Connection getConnection() throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.cj.jdbc.Driver");
		String url = "jdbc:mysql://localhost/sql_db?serverTimezone=UTC";
		String dbId = "root";
		String dbPasswd = "1234";
		return DriverManager.getConnection(url, dbId, dbPasswd); 
		
	}
	
	//Insert Query
	@Override
	public int insertCal(String data) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "INSERT INTO CALCULATOR VALUES(?, date_format(now(6), '%d%H%i%s%f'))";
			//2022 08 03 System.currentTimeMillis() 넣기
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, data);
			result = pstmt.executeUpdate();
		}catch(ClassNotFoundException e){
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	//SelectAll Query
	@Override
	public String SelectAll() {
		
		ArrayList<DBDto> list = new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = getConnection();
			String sql = "SELECT * FROM sql_db.calculator ORDER BY inTime DESC";
			pstmt = conn.prepareStatement(sql);
			
			rs = pstmt.executeQuery();
			DBDto dto = null;
			while(rs.next()) {
				dto = new DBDto();
				dto.setResult(rs.getString("result"));
				dto.setInTime(rs.getLong("inTime"));
				list.add(dto);
			}
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		String json = new Gson().toJson(list);
		return json;
	}

	@Override
	public int deleteCal(long data) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "DELETE FROM sql_db.calculator WHERE inTime = ?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setLong(1, data);
			result = pstmt.executeUpdate();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

	@Override
	public int updateCal(String data, long inTime) {
		int result = 0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = getConnection();
			String sql = "UPDATE sql_db.calculator SET result = ? WHERE inTime = ?";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setString(1, data);
			pstmt.setLong(2, inTime);
			result = pstmt.executeUpdate();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}
		return result;
	}

}
