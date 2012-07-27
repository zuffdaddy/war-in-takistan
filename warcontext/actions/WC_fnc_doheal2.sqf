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
		_x setDamage 0;
	} foreach nearestObjects[player,["Man"], 5];
	
	//_unit = ((_this select 3) select 0);
	//diag_log _unit;
	//player playMove "AinvPknlMstpSlayWrflDnon_medic";
	//sleep 4;
	//_unit setDamage 0;