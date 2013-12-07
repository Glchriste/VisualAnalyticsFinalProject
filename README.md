Visual Analytics - Final Project
================================

If you make any big changes, please make a new branch! :)

Note: This project does not seem to want to work on Windows. It runs successfully on Ubuntu and Mac OS X.

## Requirements
Install these libaries on your computer! You need them to run this web app.

1. [Node.js](http://nodejs.org/dist/v0.10.20/node-v0.10.20.tar.gz)
2. [CoffeeScript](http://http://coffeescript.org/)
3. [PhantomJS](http://phantomjs.org/download.html)

If the node modules do not install correctly with `npm install`, you will have to install them yourself. Otherwise, `backend.coffee` will not compile! Scroll to the bottom of the page to see the list of required modules.

## Instructions
1. Run `npm install` in the directory
2. Run `coffee backend.coffee`
3. Go to `http://localhost:3000` in Chrome or another modern browser
4. Explore the data!

### Todo
1. Add a search bar, where the user can search for organisms by name (Done)
2. Convert the front-end JS to CS (Done)
3. Add visualizations dynamically every time a user searches for a new organism (Done)
4. Compare different organisms somehow with computation. (Done)
5. Add a timeline visualization
6. Add user interactive features that allow the user to explore the data

###Node.js Modules to Install
If you get an error compiling backend.coffee after running `npm install`, install these modules from the command line.
  
  1. node.io `npm install node.io`
  2. coffee-script `npm install coffee-script`
  3. d3 `npm install d3`
  4. express `npm install express`
  5. request `npm install request`
  6. node-phantom `npm install node-phantom`
  7. underscore `npm install underscore`
  8. socket.io `npm install socket.io`
  9. jade `npm install jade`
  10. xml2js `npm install xml2js`

Then run `coffee backend.coffee`, it should compile!
