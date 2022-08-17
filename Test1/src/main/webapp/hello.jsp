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
  	font-size: 30px;
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
	
	function cal(operator) {
		let display = document.getElementById("display");
		display.value += " " + operator + " ";
		return display.value;
	}
	
	function isOper(operator){
		if(operator == '+' || operator == '-' || operator == '*' || operator == '/'){
			return true
		}else{
			return false
		}
	}


	
	
	function calculate() {
		let inputVal = document.getElementById('display').value;
		let dbVal = document.getElementById('display').value;
		inputVal = inputVal.split(' ');
		
		let list = [];
		let operStack = [];
	
		//계산식에서, *나 / 뒤에 '-'가 있을 때 -와 -뒤의 숫자를 합쳐줘야함.
		//마찬가지로 괄호 뒤에 -가 있을 경우에는, -와 -뒤의 숫자를 합쳐줘야함.
		
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
			if(inputVal[i] == '(' && inputVal[i+1] == '-'){
				inputVal[i+1] = inputVal[i+1] + inputVal[i+2];
				inputVal[i+2] = '';
			}
		}
		
		console.log(inputVal);
		//**중위표기법 -> 후위표기법 으로 변환시키는 과정**
		// ( 1 + 1 )  +  ( 2 + 1 )  / 3
		
		//중위표기법 -> 후위표기법 변환 renew
		//inputVal에서 요소를 하나 꺼내서, list에 넣든 operStack에 넣든
		//inputVal을 하나씩 없애기

		const change = inputVal.forEach((elem, i) => {
			if(isOper(elem) == false){
				if(list[0] == '-'){
					list[0] = list[0] + elem
				}else{
					list.push(elem);
				}
			//처음으로 들어온 연산자일 경우, operStack에 쌓아줌.		
			//!!but, i가 0일때 '-'가 들어온다면, 그 후에 들어올 숫자와 합쳐줘야함.(음수표현)
			}else {
				if(isOper(elem) == true){
					if(i == 0 && elem == '-' && inputVal[1] != '('){
						list.push(elem);
					}else if(operStack.length == 0){
						operStack.push(elem);
					}
				}
			}
			if(elem == '(' || elem == ')'){
				operStack.push(elem);
			}
			
			
			
			// operStack에 '('는 있고 ')'는 없는 상황일 때
			if(operStack.includes('(') == true && operStack.includes(')') == false){
				if(isOper(elem) == true){
					operStack.push(elem);
				}
				
				//')'가 나올때 까지 연산자를 조건없이 추가해줘야 하기 때문에, return을 통해 뒷 코드를 생략하고 forEach문으로 돌아간다.
				return
			}
			
			//해결방안3.. inputVal에서 닫힌괄호를 찾고, 닫힌괄호 + 1 이 만약 연산자일 때,
			//operStack[operStack.length - 2]과 inputVal[i+1]을 비교해서 스택에 추가할지, 다 pop 시키고 스택에 추가할지 판단하는
			//코드를 작성해야함.
			
			//기존 연산자스택의 마지막 인덱스와, 새로 들어오는 연산자의 우위를 비교해야함.
			if(operStack[operStack.length - 1] == '+' || operStack[operStack.length - 1] == '-'){
				if(inputVal[i+1] == '+' || inputVal[i+1] == '-'){
					//동등하거나 하위순위의 연산자가 들어온다면, operStack의 모든 요소를 pop 시켜줘서 list에 push 해주어야함.
					for(let index of operStack){
						list.push(operStack.pop());
					}
					//그리고 새롭게 들어온 연산자를 operStack에 push 해줌.
					operStack.push(inputVal[i+1]);
				//우위연산자가 들어오게 될 경우, operStack에 계속해서 쌓아줌.
				}else if(inputVal[i+1] == '*' || inputVal[i+1] == '/'){
					operStack.push(inputVal[i+1]);
				}
				//문제점. 괄호를 다 처리한 후, 연산자 스택에 연산자가 남아있을 때
				//inputVal에서 그 다음 요소와 맞지않아서 비교가 불가, 즉 operStack에 쌓을 수 없게되어 inputVal에서 연산자가 하나 남게됨
				
				//해결방안.. list, operStack에 값을 넣을 때 마다 inputVal을 하나씩 없애주기.
				//내일 한번 ↑ 해보기
				//해결방안2.. inputVal과 list를 비교해서, 
				
				
			//연산자 스택에서 *, / 뒤에는 어떤 연산자가 와도 모든 요소를 pop 시켜줘야함.
			}else if(operStack[operStack.length - 1] == '*' || operStack[operStack.length - 1] == '/'){
				if(isOper(inputVal[i+1]) == true){
					for(let index of operStack){
						list.push(operStack.pop());
					}
					//그리고 새롭게 들어온 연산자를 operStack에 push 해줌.
					operStack.push(inputVal[i+1]);
				}
			//연산자스택에서 닫힌 괄호를 찾는다면, 여는 괄호를 찾을 때 까지 모든 연산자를 list에 추가해준다.
			}else if(operStack[operStack.length - 1] == ')'){
					//스택 : *
					//48+65-
					//스택에 *는 확실하게 존재, inputVal에서 ) 뒤에 연산자가 있으면 스택과 비교, 처리하게 끔
					for(let i = operStack.length - 1; i >= 0; i--){
						if(operStack[i] != '('){
							list.push(operStack.pop());
						}else if(operStack[i] == '(') {
							list.push(operStack.pop());
							break;
						}
					}
					//여기있는 operStack과 inputVal에 남아있는 연산자와 비교해서 넣어줘야함.
				}
		})
		
		
		//혹시나 operStack에 남아있는 연산자가 있을 수 있기 때문에,
		//배열에 요소가 전부 없어질 때 까지 반복문을 돌려서 list에 push해줌.
		while(true){
			list.push(operStack.pop());
			if(operStack.length == 0){
				break;
			}
		}
		
		//list가 가지고있는 쓸데없는 요소들을 제거해준다.
		for(let i=0; i<list.length; i++){
			if(list[i] === '(' || list[i] === ')' || list[i] === undefined){
				list.splice(i, 1);
				i--;
			}
		}
		
		console.log(list);
		
		
		
		
		
		
		
		
		
		
		//후위표기식을 연산하기.
		
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
		
		console.log(dbVal);	
		callAjax("ajaxData=" + dbVal + " = " + postfixList)
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