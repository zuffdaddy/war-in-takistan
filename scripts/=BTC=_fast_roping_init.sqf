#include "=BTC=_functions.sqf"
BTC_fast_rope_h = 20;
BTC_AI_fast_rope_on_deploy = 0;
BTC_roping_chopper = ["MH60S","UH60M_EP1"];
{
	_rope = _x addaction [("<t color=""#ED2744"">") + ("Deploy rope") + "</t>","scripts\=BTC=_addAction.sqf",[[],BTC_deploy_rope],7,true,false,"","player == driver _target && format [""%1"",_target getVariable ""BTC_rope""] != ""1"" && ((getPos _target) select 2) < BTC_fast_rope_h && speed _target < 2"];
	_rope = _x addaction [("<t color=""#ED2744"">") + ("Cut rope") + "</t>","scripts\=BTC=_addAction.sqf",[[],BTC_cut_rope],7,true,false,"","player == driver _target && format [""%1"",_target getVariable ""BTC_rope""] == ""1"""];
	_out  = _x addaction [("<t color=""#ED2744"">") + ("Fast rope") + "</t>","scripts\=BTC=_addAction.sqf",[[player],BTC_fast_rope],7,true,false,"","player in (assignedCargo _target) && format [""%1"",_target getVariable ""BTC_rope""] == ""1"""];
} foreach (nearestObjects [player, BTC_roping_chopper, 50000]);