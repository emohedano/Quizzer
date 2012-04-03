
#Variable que guarda cada quiz como un atributo
quizzes = {} 
currentQuiz = []
currentCuestion = 0
rightAnswers = 0

generateQuiz = (quizName, quiz) ->
	
	quizHTML = ''

	$(quiz).each((key, quizElement) ->

		quizHTML += '<div id="quizElement'+key+'"><div class="question">'+quizElement.question+'</div>'

		if(quizElement.correctAnswers.length > 1)
			quizHTML += '<ol id="'+"question"+key+quizName+'" data-question-checked="false" data-multiple-answers="true">'
		else
			quizHTML += '<ol id="'+"question"+key+quizName+'" data-question-checked="false" data-multiple-answers="false">'

		$(quizElement.options).each((key, optionText) ->

			quizHTML += '<li>'+optionText+'</li>'
		)

		quizHTML += '</ol></div>'
	)
	
	$('#quizContainer').append(quizHTML)

	elements = $('#quizContainer').find(" ol li")

	elements.mousedown((event) ->
		
		if($(this).parent().data("questionChecked") == false)
			if($(this).parent().data("multipleAnswers") == true)
				$(this).toggleClass("selected")	
			else
				$(this).siblings().attr("class","");
				$(this).attr("class","selected");		
	)

	elements.hover(
		-> $(this).addClass("activo"),
		-> $(this).removeClass("activo")
	)

validate = ->

	correctOptions = 0
	incorrectOptions = 0

	currentQuizElement = currentQuiz[currentCuestion]
	correctAnswers = currentQuizElement.correctAnswers
	evaluationMode = currentQuizElement.mode

	score = 0

	elements = $('#quizElement'+currentCuestion+' li')

	if(elements.filter(".selected").length == 0)
		return

	elements.each((index, Element) ->

		if($(this).hasClass("selected"))

			if(correctAnswers.indexOf(index) > -1)
				correctOptions += 1
				$(this).attr("class","good")
			else
				incorrectOptions += 1
				$(this).attr("class","bad")	
	)

	

	if(correctOptions == correctAnswers.length and incorrectOptions == 0)
		rightAnswers += 1
	else
		if( evaluationMode == "permisive")
			elements.filter(".good").attr("class","almostGood")
			rightAnswers += Math.round((correctOptions - incorrectOptions)*10/correctAnswers.length)/10
				
	
	document.getElementById("txtAciertos").value = rightAnswers

	$('#quizElement'+currentCuestion+" ol").data("questionChecked",true)

validateQuiz = ->

	nQuestions = currentQuiz.length
	currentCuestion = 0

	while currentCuestion < nQuestions
	  validate()
	  currentCuestion += 1


resetQuiz = ->
	resetScore()
	$('#quizContainer').find(" ol").data("questionChecked",false)
	$('#quizContainer').find(" ol li").attr("class","")
	
resetScore = ->
	rightAnswers = 0
	document.getElementById("txtAciertos").value = rightAnswers


loadQuiz = (quizName) ->

	if (quizName == "-1")
		return

	fileref = document.createElement('script')
	fileref.setAttribute("type","text/javascript")
	fileref.setAttribute("src", "quizzes/"+quizName+".json")

	document.getElementsByTagName("head")[0].appendChild(fileref)

	resetScore()
	$("#quizContainer").empty()

	#Se retrasa la carga del quiz para que pueda carcgr el JSON
	window.setTimeout(
		->
			currentQuiz = quizzes[quizName]
			generateQuiz(quizName,currentQuiz)

	, 500)
	