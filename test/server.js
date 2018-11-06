var expect  = require("chai").expect;
var request = require("request");

describe("Color Code Converter API", function() {
  describe("Echo check", function() {
    var url = "http://localhost:3000/echo?text=hello";
    it("echoes back what you send in the text query string parameter", function(done) {
      request(url, function(error, response, body) {
        expect(response.statusCode).to.equal(200);
        expect(body).to.equal("<p>You sent this: hello</p>");
        done();
      });
    });
  });

  describe("Redirected echo check", function() {
    var url = "http://localhost:3000/redirect?text=hello";
    it("echoes back what you send in the text query string parameter via a redirect", function(done) {
      request(url, function(error, response, body) {
        expect(response.statusCode).to.equal(200);
        expect(body).to.equal("<p>You sent this: hello (Redirected)</p>");
        done();
      });
    });
  });

  describe("RGB to Hex conversion", function() {
    var url = "http://localhost:3000/rgbToHex?red=255&green=255&blue=255";
    it("returns status 200", function(done) {
      request(url, function(error, response, body) {
        expect(response.statusCode).to.equal(200);
        done();
      });
    });
    it("returns the color in hex", function(done) {
      request(url, function(error, response, body) {
        expect(body).to.equal("ffffff");
        done();
      });
    });
  });

  describe("Hex to RGB conversion", function() {
    var url = "http://localhost:3000/hexToRgb?hex=00ff00";
    it("returns status 200", function(done) {
      request(url, function(error, response, body) {
        expect(response.statusCode).to.equal(200);
        done();
      });
    });
    it("returns the color in RGB", function(done) {
      request(url, function(error, response, body) {
        expect(body).to.equal("[0,255,0]");
        done();
      });
    });
  });
});
