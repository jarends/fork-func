// Generated by CoffeeScript 1.11.1
(function() {
  module.exports = function(delay, msg) {
    var start;
    start = Date.now();
    while (Date.now() - start < delay) {
      null;
    }
    return delay + 'ms later ... ' + msg;
  };

}).call(this);
