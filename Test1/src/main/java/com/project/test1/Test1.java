package com.project.test1;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.project.dbConnect.DBDao;

@WebServlet("/hello.do")
public class Test1 extends HttpServlet {
	
	
	private static final long serialVersionUID = 1L;

	
	
	
	public void init(ServletConfig config) throws ServletException {
		System.out.println("init() 실행");
	}
	
	
	

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		RequestDispatcher rd = request.getRequestDispatcher("hello.jsp");

		DBDao dao = DBDao.getInstance();
	
		request.setAttribute("line", dao.SelectAll());
		rd.forward(request, response);

	}
	
	
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
        
        AjaxProcess ajaxProcess = new AjaxProcess();

        if(request.getParameter("delData") != null) {
        	long data = Long.parseLong(request.getParameter("delData"));
        	ajaxProcess.ajaxDelete(request, response, data);
        }
        
        if(request.getParameter("ajaxData") != null) {
        	String data = request.getParameter("ajaxData");
        	ajaxProcess.ajaxInsert(request, response, data);
        }
        if(request.getParameter("dummy") != null) {
        	ajaxProcess.ajaxSelect(request, response);
        }
        
        if(request.getParameter("updateData") != null) {
        	String data = request.getParameter("updateData");
        	long inTime = Long.parseLong(request.getParameter("inTime"));
        	
        	ajaxProcess.ajaxUpdate(request, response, data, inTime);
        }
        //********** GET방식으로 할 땐 requestDispatcher 때문에 ajax 통신이 제대로 안된 것 같음. ***********
	}
}
