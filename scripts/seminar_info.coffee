# Descripion:
#   show today's seminar information
#
# Commands:
#   hubot Seminar

https = require "https"
url = "https://script.google.com/macros/s/AKfycbx8q9tw9WotXTRKQNjnb6BzlkyHBzDSpmgCQwt3yNepze4wpAU/exec"

module.exports = (robot) ->
  robot.respond /Seminar/i, (res) ->
    request res

request = (res) ->
  https.get url, (response) ->
    redirUrl = response.headers.location
    redir res, redirUrl

# GoogleAppScriptでデプロイしており，対象URLにアクセスすると
# status 302で戻ってきてリダイレクトしなくてはならない
redir = (res, redirUrl) ->
  https.get redirUrl, (response) ->
    response.setEncoding 'utf8'
    response.on 'data', (body) ->
      json = JSON.parse(body)
      createMsg res, json

createMsg = (res, json) ->
  msg = "本日のセミナー情報です\n" + json.title + "\n"
  msg += "場所:" + json.place + "\n"
  msg += "時間:" + json.start_time + "~" + json.end_time + "\n"
  res.send msg
