// Generated by CoffeeScript 1.11.1
(function() {
  module.exports = function(delay, msg, done) {
    return setTimeout(function() {
      return done(null, delay + 'ms later ... ' + msg);
    }, delay);
  };

}).call(this);
