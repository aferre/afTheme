// Load the node-router library by creationix
var express = require('express');
var app = express.createServer();

app.use(express.static(__dirname + '/themes'));

var root = "http://localhost:8000/";

var ThemesList = [
                   {'name':'DummyTheme'},
                   {'name':'G2Theme'}
                 ];

var DummyTheme = {'name':'DummyTheme',
		   		  'images':[
	                         {'name':'Pin Station Free',
							  'location':'/Map/Pin-PP-Free',
							  'url': root + 'DummyTheme/images/pin-station-free.png'},
							 {'name':'Pin Station Occupied',
							  'location':'/Map/Pin-PP-Occ',
							  'url': root + 'DummyTheme/images/pin-station-occupied.png'}
		                    ],
                  'strings':[
	                         {'name':'str1',
							   'location':'/Map/Pin-PP-Free-subtitle',
							   'content':'Pin-PP-Free-subtitle'},
							 {'name':'str2',
							   'location':'/Map/Pin-PP-Occ-subtitle',
							   'content':'Pin-PP-Occupied-subtitle'}
		                     ]
				  };

var G2Theme = {'name':'G2Theme',
			   'images':[
                         {'name':'Pin Station Free',
						   'location':'/Map/Pin-PP-Free',
						   'url':root + 'G2Theme/images/pin-station-free.png'},
						 {'name':'Pin Station Occupied',
						   'location':'/Map/Pin-PP-Occ',
						   'url':root + 'G2Theme/images/pin-station-occupied.png'}
	                    ],
              'strings':[
                         {'name':'str1',
						   'location':'/Map/Pin-PP-Free-subtitle',
						   'content':'Pin-PP-Free-subtitle'},
						 {'name':'str2',
						   'location':'/Map/Pin-PP-Occ-subtitle',
						   'content':'Pin-PP-Occupied-subtitle'}
	                     ]
			   };

var img = {'name':'img1',
		   'location':'/Map/Pin-PP-Free',
		   'url':'http://localhost/img1.png'};

var str = {'name':'str1',
		   'location':'/Map/Pin-PP-Free-Subtitle',
		   'content':'Pouetounet!'};	

//Configure our HTTP server to respond with Hello World the root request
app.get("/Themes", function (request, response) {
	response.writeHeader(200, {'Content-Type': 'application/json'});
	response.write(JSON.stringify(ThemesList));
	response.end();
});

app.get("/Themes/:theme", function (request, response) {
	response.writeHeader(200, {'Content-Type': 'application/json'});
	if (request.params.theme == "G2Theme") 
		response.write(JSON.stringify(G2Theme));
	else if (request.params.theme == "DummyTheme") 
		response.write(JSON.stringify(DummyTheme));
	else 
		response.write("Theme not found");
	response.end();
});

// Listen on port 8080 on localhost
app.listen(8000, "localhost");