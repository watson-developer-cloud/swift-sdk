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
var request     = require('request');


var app = express();

function readConfigFile() {

  var obj = plist.parse(fs.readFileSync('Credentials.plist', 'utf8'));
  // console.log(JSON.stringify(obj));

  return obj;
}

function getWatsonToken(tokenURL, serviceURL, username, password) {

  var deferred = when.defer();

  var url = tokenURL + "?url=" + serviceURL;

  request.get(url, function (error, response, body) {

    if (error) { deferred.reject(error); }
    deferred.resolve(body);

  }).auth(username, password, false)


  // callback = function(response)
  return deferred.promise;
}

function handleError(e) {
  return "No token"
}

app.get('/', function (req, res) {

  res.send('Watson Token Gateway');

});

app.get('/auth', function (req, res) {

  var url_parts = url.parse(req.url, true);
  var query = url_parts.query;
  console.log(query);

  var keys = readConfigFile();

  var username = keys["TextToSpeechUsername"];
  var password = keys["TextToSpeechPassword"];

  getWatsonToken(
    "https://stream.watsonplatform.net/authorization/api/v1/token",
    "https://stream.watsonplatform.net/text-to-speech/api",
    username, password
    )
    .done(function(tokenResponse) {
      res.send(tokenResponse)
    });

    /**
    username = keys[query["service"] + "Username"]
    **/

});


var server = app.listen(3000, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
