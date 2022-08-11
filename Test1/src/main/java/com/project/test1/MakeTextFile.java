package com.project.test1;

import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import com.google.gson.Gson;

public class MakeTextFile {

	public MakeTextFile() {
		
	}
	
	public MakeTextFile(String data) {
		String fileName = "D:/workspace/Test1/src/main/webapp/output.txt";
		
		try {
			PrintWriter pw = new PrintWriter(new FileOutputStream(fileName, true));
			pw.println(data);
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void makeFile(String data) {
		String fileName = "D:/workspace/Test1/src/main/webapp/output.txt";
		
		try {
			PrintWriter pw = new PrintWriter(new FileOutputStream(fileName, true));
			pw.println(data);
			pw.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	//ArrayList를 만들어 반복문을 통해 line의 값을 읽을 때 마다 list에 추가. list를 Gson을 통해 Json타입으로 만들어 return
	public String readFile() throws IOException {
		ArrayList<String> list = new ArrayList<>();	
		BufferedReader br = new BufferedReader(new FileReader("D:/workspace/Test1/src/main/webapp/output.txt"));
		while(true) {
			String line = br.readLine();
			list.add(line);
			if(line == null) {
				break;
			}
		}
		br.close();
		String json = new Gson().toJson(list);
		return json;
	}

}
