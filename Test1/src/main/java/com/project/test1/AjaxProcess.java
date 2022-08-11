package com.project.test1;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.project.dbConnect.DBDao;
import com.project.dbConnect.DBDto;

public class AjaxProcess {
	PrintWriter out;
	DBDto dto = new DBDto();
	DBDao dao = DBDao.getInstance();
	Calculate calculate = new Calculate();
	
	public void ajaxInsert(HttpServletRequest request, HttpServletResponse response, String data) throws IOException {	
		request.setCharacterEncoding("utf-8");
        response.setContentType("text/html; charset=utf-8");

		data = calculate.calculate(data);
        dto.setResult(data);
        dao.insertCal(dto.getResult());
	}
	
	
	
	public void ajaxSelect(HttpServletRequest request, HttpServletResponse response) throws IOException {
		out = response.getWriter();
		out.print(dao.SelectAll());
		System.out.println(dao.SelectAll());
	}
	
	
	
	public void ajaxDelete(HttpServletRequest request, HttpServletResponse response, long data) {
		dto.setInTime(data);
		dao.deleteCal(dto.getInTime());
	}
	
	
	public void ajaxUpdate(HttpServletRequest request, HttpServletResponse response, String data, long inTime) throws IOException {		
		dto.setResult(data);
		dto.setInTime(inTime);
		dao.updateCal(dto.getResult(), dto.getInTime());
	}
}
