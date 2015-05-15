var http = require("http");

setTimeout(function() {
    http.get("http://localhost:8080/notification/start", function(res) {});
}, 1000);

module.exports = function (robot) {
    return robot.router.get("/notification/start", function (req, res) {
        robot.messageRoom("ci", "起動したよ！");
    });
}
