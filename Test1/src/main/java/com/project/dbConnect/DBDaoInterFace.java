package com.project.dbConnect;

import java.sql.Connection;
import java.sql.SQLException;

public interface DBDaoInterFace {
	public Connection getConnection() throws ClassNotFoundException, SQLException;
	public int insertCal(String data);
	public int deleteCal(long data);
	public int updateCal(String data, long inTime);
	public String SelectAll();
	
}
