/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

'use strict';

var express     = require('express');
var fs          = require('fs');
var plist       = require('plist');
var url         = require('url');
var http        = require('http');
var when        = require('when');

var app = express();

function readConfigFile() {
  var obj = plist.parse(fs.readFileSync('Credentials.plist', 'utf8'));
  // console.log(JSON.stringify(obj));

  return obj
}

function getWatsonToken(tokenURL, serviceURL, username, password) {

  var options = {
    host: tokenURL,
    path: "?url=" + serviceURL
  }

  console.log("Making a call to " + JSON.stringify(options));

  return "token"
  // callback = function(response)

}

app.get('/', function (req, res) {

  readConfigFile();

  res.send('Hello World!');

});

app.get('/auth', function (req, res) {

  var url_parts = url.parse(req.url, true);
  var query = url_parts.query;
  console.log(query);

  keys = readConfigFile();

  username = keys[query["service"] + "Username"]

  getWatsonToken(
    "https://stream.watsonplatform.net/authorization/api/v1/token",
    "https://stream.watsonplatform.net/text-to-speech/api",
    "username", "password"
  )

  res.send(username)

});


var server = app.listen(3000, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
