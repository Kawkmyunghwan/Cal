package com.project.test1;

public class Calculate {

	public String calculate(String data) {
//		MakeTextFile makeTextFile;
		if(data.contains("-") || data.contains("*") || data.contains("/")) {
			System.out.println(data);
//			makeTextFile = new MakeTextFile(data);
			return data;
		}else {
			//jsp에서 parameter를 받아올 때 "+" 부호를 누락해서 받아오기 때문에 따로 처리.
			String dataArr[] = data.split(" ");
			dataArr[1] = " + ";
			dataArr[dataArr.length - 2] = " = ";
			data = String.join("", dataArr);
			
			System.out.println(data);
//			makeTextFile = new MakeTextFile(data);
			return data;
		}
	}
}
