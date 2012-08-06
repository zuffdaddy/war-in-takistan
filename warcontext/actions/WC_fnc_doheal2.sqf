	// -----------------------------------------------
	// Author:  code34 nicolas_boiteux@yahoo.fr
	// warcontext : heal other player when not medic
	// -----------------------------------------------

	 private [
		"_unit"
	];

	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 4;
	{
		_x setVariable ["selections", []];
		_x setVariable ["gethit", []];
		_x setDamage 0;
	} foreach nearestObjects[player,["Man"], 5];
