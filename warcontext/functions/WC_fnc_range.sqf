// --- generate an array of numbers from min to max

_min = _this select 0;
_max = _this select 1;

_result = [];

for "_i" from _min to _max do {
	_result = _result + [_i];
};

_result
