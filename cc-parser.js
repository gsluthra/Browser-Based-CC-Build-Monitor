 
	function displayStatus(buildnameStr, displayString){
		$('body').append('<br></br>');
		$.get('cc.xml', function(xmldoc){
			$(xmldoc).find('Project').each(function(){

			    var $project = $(this);
			    var nameOfProject = $project.attr("name");
			    var lastBuildTime = $project.attr("lastBuildTime");
			    var lastBuildStatus = $project.attr("lastBuildStatus");
			    var currentActivity = $project.attr("activity");

			    
			    if(nameOfProject==buildnameStr){
				    if(lastBuildStatus=="Success"){
					$('body').append('<h1>'+displayString+': OK </h1>');
					$('body').css("background-color", "green");
				    } else {
					$('body').append('<font color="yellow"> <h1>'+displayString+': BROKEN!</h1> </font>');
					$('body').css("background-color", "maroon");
				    }
					
				    var split = lastBuildTime.split('T');
				    var times = split[1].split(':');

				    $('body').append('<b> Last Build: </b>'+ split[0]);
			            $('body').append('<b> Time: </b> '+ times[0] + ':' + times[1]);

				    if(currentActivity == "Building"){
					$('body').append('<font color="yellow"> <h3> NEW BUILD IN PROGRESS ..... </h3></font>');
				    }
			    }
			
			});
	    	 });

       }

