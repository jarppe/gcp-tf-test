require("http").createServer(function(req, res) {
  res.writeHead(200)
  res.end("Hello, World!\n")
}).listen(8080, "0.0.0.0", function() {
  console.log("listening on port 8080")
})
