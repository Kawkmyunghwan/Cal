<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<style>
#container {
	float : left;
}

#table th:hover {
	background-color: #ccc;
}

#table  {
	width: 400px;
	border: 1px solid;
	border-collapse : collapse;
	font-size : 35px;
	
}

#table th, td{
	border: 1px solid;
	height: 70px;
	color: white;
}

.cal{
	background-color : orange;
}

.num{
	background-color : #828284;
}

.keydown {
	background-color: #ccc;
}

input[type=text] {
	color : white;
	border : none;
	width: 384px;
  	height: 50px;
  	font-size: 40px;
 	outline: none;
 	padding-left : 5px;
 	padding-right: 10px;
 	
 	background-color : #59595B;
}

#list {
	float : left;
	width : 398px;
	background-color : #828284;
	color : white;
	display : inline-block;
	margin-left : 30px;
}

</style>
</head>
<body>
<div id="container">
	<input id="display" type=text width=50px>
	<br>
	<input id="result" type=text width=50px style="text-align:right;">
	<table id="table">
		<thead>
			<tr>
				<th width=40px class="num">%</th>
				<th width=40px class="num">CE</th>
				<th width=40px class="num">C</th>
				<th onclick="record()" width=40px class="cal">기록</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th class="num"></th>
				<th class="num"></th>
				<th class="num"></th>
				<th onclick="addOutPut('/')" class="cal">/</th>
			</tr>
			<tr>
				<th onclick="addOutPut(7)" class="num">7</th>
				<th onclick="addOutPut(8)" class="num">8</th>
				<th onclick="addOutPut(9)" class="num">9</th>
				<th onclick="cal('*')" class="cal">*</th>
			</tr>
			<tr>
				<th onclick="addOutPut(4)" class="num">4</th>
				<th onclick="addOutPut(5)" class="num">5</th>
				<th onclick="addOutPut(6)" class="num">6</th>
				<th onclick="cal('-')" class="cal">-</th>
			</tr>
			<tr>
				<th onclick="addOutPut(1)" class="num">1</th>
				<th onclick="addOutPut(2)" class="num">2</th>
				<th onclick="addOutPut(3)" class="num">3</th>
				<th onclick="cal('+')" class="cal">+</th>
			</tr>
			<tr>
				<th class="num"></th>
				<th onclick="addOutPut(0)" class="num">0</th>
				<th onclick="addOutPut('.')" class="num">.</th>
				<th onclick="calculate()" class="cal">=</th>
			</tr>
		</tbody>
	</table>
</div>
	<div id='record'></div>
	
	<div id='secList'>
		<div id='list'></div>
	</div>
	
</body>

<script>
	let num = 0;
	let symbol;
	let h4;
	
	var xhr = new XMLHttpRequest();
	
	
	//숫자를 입력받아 input박스에 띄워줌
	function addOutPut(num) {
		let display = document.getElementById("display");
		display.value += num;
		return display.value;
	}
	
	
	//부호를 입력받아서 symbol 이라는 변수에 저장함.
	//곱하기, 나누기 부호 뒤에 -가 온다면, 띄워쓰지 않게 끔 하기.
	//더하기, 빼기 뒤에 다른 부호가 온다면 해당하는 부호로 대체,
	//곱하기, 나누기 부호 뒤에 -가 아닌 다른 부호가 온다면 해당하는 부호로 대체.
	
	function cal(operator) {
		let display = document.getElementById("display");
		display.value += " " + operator + " ";
		return display.value;
	}


	function calculate() {
		let inputVal = document.getElementById('display').value;
		inputVal = inputVal.split(' ');
		
		//중위연산자 -> 후위연산자로 변환하는 형식으로 계산해줘야함.
		//배열에서, 숫자는 바로 list에 넣어주고, 연산자의 경우에는 stack에 push를 해줌.
		//연산자의 경우는 우선순위를 정해줘야 하는데, *, /가 + - 보다 우선순위가 높음.
		//첫번째 연산자는 그냥 넣어줌.
		//두번째 연산자가 들어올 때 부터, 만약에 들어오는 연산자가 높은 우선순위를 가지고 있다면 그대로 push를 통해 stack에 쌓아줌.
		//만약, 들어오는 연산자가 우선순위가 같거나 낮다면, stack에서 pop을 통해 '기존에 있는' 연산자를 꺼내주고, 새로운 연산자를 push 한 후에,
		//'기존에 있던 연산자들'은 list에 push를 해준다.
		//식이 끝나서, 더이상 push 할 연산자가 없다면, stack에서 pop을 통해 모든 연산자를 꺼내주고, list에 push 해준다.
		
		
		//inputVal 이라는 리스트를 반복해서 돌면서, 첫 번째 숫자를 list에 넣는다.
		//후에 나오는 연산자는 일단 operatorList에 push 한다.
		//후에 나오는 index를 숫자 or 연산자인지 판단하여, 숫자라면 list에 넣는다.
		//연산자라면, operatorList에 있는 연산자를 불러온다.
		//불러온 연산자가 * or / 일때, pop을 통해 빼준 값을 list에 넣어준 후, 새로 들어온 연산자를 operatorList에 넣어준다.
		//불러온 연산자가 + or / 일때, 후에 들어온 연산자도 + or / 라면 pop을 통해 빼준 값을 list에 넣어준다. 그리고 새로 들어온 연산자를 operatorList에 넣어준다.
		//inputVal 리스트의 반복문이 끝났을 때, operatorList를 pop 해서 list에 push해준다.
		
		let list = [];
		let operatorList = [];
	
		//inputVal에서, *나 / 뒤에 '-'가 있을 때 -와 -뒤의 숫자를 합쳐줘야함.
		// *나 /뒤에 0이 있으면 계산이 안되게 해야함.
		for(let i=0; i<inputVal.length; i++){
			while(true){
				if(inputVal[i] === '')  {
					inputVal.splice(i, 1);
				    i--;
				}
				if(inputVal[i] != ''){
					break;
				}
			}
			if((inputVal[i] == '*' || inputVal[i] == '/') && inputVal[i+1] == '-'){
				inputVal[i+1] = inputVal[i+1] + inputVal[i+2]; 
				inputVal[i+2] = '';
			}
		}
		
		console.log(inputVal);
		
		for(let i = 0; i < inputVal.length; i++){
			//inputVal[i]가 숫자일 경우에는 계속해서 쌓음.
			if(inputVal[i] != '+' && inputVal[i] != '-' && inputVal[i] != '*' && inputVal[i] != '/'){
				if(list[0] == '-'){
					list[0] = list[0] + inputVal[i]
				}else{
					list.push(inputVal[i]);
				}
			//처음으로 들어온 연산자일 경우, operatorList에 쌓아줌.
			//!!but, i가 0일때 '-'가 들어온다면, 그 후에 들어올 숫자와 합쳐줘야함.(음수표현)
			}else if(inputVal[i] == '+' || inputVal[i] == '-' || inputVal[i] == '*' || inputVal[i] == '/'){
				if(i == 0 && inputVal[i] == '-'){
					list.push(inputVal[i]);
				}else if(operatorList.length == 0){
					operatorList.push(inputVal[i]);
				}
			}
			//연산자 스택에 제일 최근에 들어간 연산자와, 새로 들어오는 연산자를 비교해야함.
			if(operatorList[operatorList.length - 1] == '+' || operatorList[operatorList.length - 1] == '-'){	
				if(inputVal[i+1] == '+' || inputVal[i+1] == '-'){
					//동등하거나 하위순위의 연산자가 들어온다면, operatorList의 모든 요소를 pop 시켜줘서 list에 push 해주어야함.
					while(true){
						//list에 넣을때, 배열의 첫번째부터 꺼내야함.
						list.push(operatorList.pop());
						if(operatorList.length == 0){
							break;
						}
					}
					//그리고 새롭게 들어온 연산자를 operatorList에 push 해줌.
					operatorList.push(inputVal[i+1]);
				//우위연산자가 들어오게 될 경우, operatorList에 계속해서 쌓아줌.
				}else if(inputVal[i+1] == '*' || inputVal[i+1] == '/'){
					operatorList.push(inputVal[i+1]);
				}
			}else if(operatorList[operatorList.length - 1] == '*' || operatorList[operatorList.length - 1] == '/'){
				if(inputVal[i+1] == '+' || inputVal[i+1] == '-'){
					while(true){
						list.push(operatorList.pop());
						if(operatorList.length == 0){
							break;
						}
					}
					operatorList.push(inputVal[i+1]);
				}else if(inputVal[i+1] == '*' || inputVal[i+1] == '/'){
					while(true){
						list.push(operatorList.pop());
						if(operatorList.length == 0){
							break;
						}
					}
					operatorList.push(inputVal[i+1]);
				}
			}
		}

		//혹시나 operatorList에 남아있는 연산자가 있을 수 있기 때문에,
		//배열에 요소가 전부 없어질 때 까지 반복문을 돌려서 list에 push해줌.
		while(true){
			list.push(operatorList.pop());
			if(operatorList.length == 0){
				break;
			}
		}
		
		console.log(list);
		//후위표기식을 사칙연산하기.
		
		//숫자는 스택에 추가하기.
		//연산자가 나오면 숫자 2개를 pop 해서 계산한다.
		//이 때 먼저 pop 되는 숫자가 두번째 값, 나중에 pop 되는 숫자가 첫번째 값이 되도록 하여 계산해야한다.
		//계산한 값은 다시 스택에 넣는다.
		
		let postfixList = [];
		let tempNum1 = 0;
		let tempNum2 = 0;
		
		while(true){
			for(let i=0; ; i=i){
				//list에 있는 숫자는 전부다 postfixList에 push해주면서 동시에, list의 숫자 요소를 차레차례 삭제해줌.
				if(list[i] != '+' && list[i] != '-' && list[i] != '*' && list[i] != '/'){
					postfixList.push(list[i]);
					list.shift();
				}
				//연산자가 나왔을 경우에, symbol 변수에 연산자를 저장해 준 후에 list의 연산자 요소를 삭제하고, 안쪽 반복문을 종료시킴.
				if(list[i] == '+' || list[i] == '-' || list[i] == '*' || list[i] == '/'){
					symbol = list[i];
					list.shift();
					break;
				}
			}
			
			//먼저 pop되는 숫자가 두번째 값, 나중에 pop 되는 숫자가 첫번째 값이 되도록 저장.
			tempNum2 = postfixList.pop(); // 3
			tempNum1 = postfixList.pop(); // 4
			
			//계산
			if(symbol == '+'){
				postfixList.push(Number(tempNum1) + Number(tempNum2));
			}else if(symbol == '-'){
				postfixList.push(Number(tempNum1) - Number(tempNum2));
			}else if(symbol == '*'){
				postfixList.push(Number(tempNum1) * Number(tempNum2));		
			}else if(symbol == '/'){
				postfixList.push(Number(tempNum1) / Number(tempNum2));
			}
			
			//list에 더이상 남아있는 요소가 없을때, 바깥쪽 반복문도 종료시킴.
			if(list.length == 0){
				break;
			}
		}
		
		//result input박스에 값을 표시
		document.getElementById('result').value = postfixList;
	}


	//키보드로 값을 입력 받았을 때 실행하는 함수
	window.addEventListener('keydown', function(e){

		let regexp = /^[0-9.]*$/;
		let val = e.key;
		
		if(val != 'Shift'){
			//숫자, Enter를 제외한 값을 입력 받았을 때 cal() 함수를 호출
			if(!regexp.test(val) && val != 'Enter'){
		 		cal(val);
		 	//Enter를 입력 받았을 때 calculate() 함수 호출,
			}else if(val == 'Enter'){
				calculate();
				document.getElementById('display').value = '';
				
				//calculate() 함수 호출 후, 0.01초 후에 bringAjax() 함수 호출
				setTimeout(function() {
					if(document.getElementsByClassName('h4').length == 0){
						bringAjax();
					}else{
						let h = document.getElementsByClassName("h4");

						h[0].parentElement.remove();
						let list = document.createElement('div');		
						list.setAttribute('id', 'list');
						document.getElementById('secList').append(list);

						bringAjax();
					}
				}, 10);

				//그 외의 값(숫자)를 입력 받았을 때 addOutput()함수 호출.
			}else {
				addOutPut(val);
				document.getElementById('result').value = '';
			}
		}
	})

	//keydown을 통해 입력할 때 마다, 입력하는 값에 해당하는 td태그의 innerText를 확인해서 같다면 class 추가 후에, 키를 떼면 class를 제거
	let tableList = document.getElementById('table').children[1].children;
	
	window.addEventListener('keydown', function(e){
		
		let val = e.key;

		for(let i=0; i<tableList.length; i++){

			for(let j=0; j<tableList[0].children.length; j++){

				if(tableList[i].children[j].innerText == val){

					tableList[i].children[j].setAttribute('class', 'keydown');
				}

				window.addEventListener('keyup', function(e){
					let cal = tableList[i].children[j].innerText;
					
					tableList[i].children[j].classList.remove('keydown');
					
					if(tableList[i].children[j].getAttribute('class') == '' && cal != '/' && cal != '*' && cal != '-' && cal != '+'){
						tableList[i].children[j].setAttribute('class', 'num');
					}else if(cal == '/' || cal == '*' || cal == '-' || cal == '+'){
						tableList[i].children[j].setAttribute('class', 'cal');
					}
				})
			}
		}
	})
	
	
	//비동기통신 후 계산결과를 만들어주는 function.
	function bringAjax(){
		
		callAjax("dummy=dummy");
	    xhr.onload = function () {
	        if (xhr.status == 200) {
	            //success

	           	let count = JSON.parse(xhr.response);
	           	
				for(l of count){
					var text = document.createTextNode("\u00a0\u00a0\u00a0");
		           	var text2 = document.createTextNode("\u00a0\u00a0\u00a0");
		 
					//계산 결과를 나타내는 h4태그를 만들어줌.
					h4 = document.createElement('h2');
					h4.setAttribute('class', 'h4')
					h4.innerText = l.result;
					h4.style.paddingLeft = '30px';
					
					//계산 결과를 지울 수 있는 a태그를 만들어줌.
					a = document.createElement('a');
					a.innerText = ' ✖ '
					a.setAttribute('href', '#');
					a.setAttribute('onclick', 'javascript:delFnc(this)');					
					a.setAttribute('id', l.inTime);
					a.style.textDecoration = 'none';
					a.style.color = 'white';
					
					//계산 결과를 수정할 수 있는 a태그를 만들어줌.
					a2 = document.createElement('a');
					a2.innerText = ' 수정 ';
					a2.setAttribute('href', '#');
					a2.setAttribute('onclick', 'javascript:updateFnc(this)');
					a2.setAttribute('class', l.inTime);
					a2.style.textDecoration = 'none';
					a2.style.color = 'white';
					
					document.getElementById('list').append(h4);
					h4.append(a);
					h4.append(a2);
					
					a.prepend(text);
					a2.prepend(text2);
				}
				
	        }
	    }
	}
	
	//계산결과가 없을 때 버튼을 누르면 비동기통신을 통해 최신화된 DB 데이터를 가져옴.
	 
	/* document.getElementById('btn').addEventListener('click', function(event){ 
		if(document.getElementsByClassName('h4').length == 0){
			bringAjax();
		}
	})  */
	
	function record(){
		if(document.getElementsByClassName('h4').length == 0){
			bringAjax();
		}
	}
	
	
	//계산결과를 수정하는 function
	function updateFnc(obj){
		
		let input = document.createElement('input');
		input.style.border = 'none';
		input.style.outline = 'none';
		
		if(obj.nextSibling != null){
			if(obj.nextSibling.value != ''){
				//2. 생성된 input 박스에 값을 넣은 후, 해당 값을 ajax로 데이터를 보내고 통신함.
				callAjax("updateData="+obj.nextSibling.value+"&&inTime="+obj.getAttribute('class'))
			    xhr.onload = function () {
			        if (xhr.status == 200) {
			        	//3. 기존에 있던 계산결과들을 모두 삭제한 후, 최신화된 결과를 다시 불러옴.
			        	obj.parentElement.parentElement.remove();
			        	
			        	let list = document.createElement('div');
			        	list.setAttribute('id', 'list');
			        	document.getElementById('secList').append(list);
			        	
			        	bringAjax(); 	
			        }
			    }
			}else{
				//4. input 박스에 값이 없을 때, 수정버튼을 클릭하게 되면, input 박스가 사라짐.
				obj.nextSibling.remove();
			}
		//1. 처음에 수정하기 버튼을 클릭하게 되면, input 박스가 생성 됨.
		}else{
			obj.parentElement.append(input);
		}
	}



	//계산결과를 삭제하는 function
	function delFnc(obj){
		//매개변수로 가져온 obj 변수의 ID값을 Data로 전송해줌.
		callAjax("delData=" + obj.getAttribute('id'))
	    xhr.onload = function () {
	        if (xhr.status == 200) {
	           //해당 id를 가진 a 태그의 부모요소를 삭제
	           obj.parentElement.remove()
			}
	    }
	}
	
	function callAjax(sendData){
	    xhr.open('POST', 'hello.do', true);
	    xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
	    xhr.send(sendData);
	}
</script>
</html>