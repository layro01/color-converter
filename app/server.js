var express = require("express");
var app = express();

var converter = require("./converter");

// This function is called when you want the server to end gracefully
// (i.e. wait for existing connections to close).
var gracefulShutdown = function() {
  console.log("Received shutdown command, shutting down gracefully.");
  process.exit();
}

// listen for TERM signal (e.g. kill command issued by forever).
process.on('SIGTERM', gracefulShutdown);

// listen for INT signal (e.g. Ctrl+C).
process.on('SIGINT', gracefulShutdown);

app.get("/rgbToHex", function(req, res) {
  // To fix these security vulnerabilities, 
  // Replace the three eval() statements with their parseInt() versions.
  var red = eval(req.query.red);
  var green = eval(req.query.green, 10);
  var blue  = eval(req.query.blue, 10);
  // var red   = parseInt(req.query.red, 10);
  // var green = parseInt(req.query.green, 10);
  // var blue  = parseInt(req.query.blue, 10);
  var hex = converter.rgbToHex(red, green, blue);
  res.send(hex);
});

app.get("/hexToRgb", function(req, res) {
  var hex = req.query.hex;
  var rgb = converter.hexToRgb(hex);
  res.send(JSON.stringify(rgb));
});

app.listen(3000);