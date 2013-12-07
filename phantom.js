// var page = require('webpage').create();
// page.open('http://www.timetree.org/index.php', function () {
//     page.render('github.png');
//     var arr = document.getElementsByName("query_frm");
//     for(var i = 0; i < arr.length; i++) {
//     	console.log(arr[i]);
//     }
//     phantom.exit();
// });

var page = new WebPage();

page.open("http://www.timetree.org/index.php",
function(status){
if(status != "success")
	{
		console.log('Failed loading the page.');
	}
	else {
		console.log('Loaded the web page...')
	}
 //    page.evaluate(function(){
 //        var arr = document.getElementsByName("query_frm");
 //        arr[0].elements["taxon_a"].value="cat";
 //        arr[0].elements["taxon_b"].value="dog";
 //        page.onLoadFinished = function(status){
 //  			console.log(window.frames[1].document.getElementById('status').innerHTML);
	// 	}
 //    	arr[0].elements["submit"].click();
 //        return;
 //    }
    phantom.exit();
});