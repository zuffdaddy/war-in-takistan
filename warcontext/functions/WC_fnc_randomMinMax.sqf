// --- generate a random number from _min to _max
//
//	function randomMinToMax(min, max_v) {
//	  var range = max_v - min + 1;
//	  return Math.floor(Math.random()*range + min);
//	}

_min = _this select 0;
_max = _this select 1;
_range = _max - _min + 1;
_result = floor((random 1) * _range + _min);
_result
