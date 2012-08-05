handleDamage = {
	// _this select 0: Unit the EH is assigned to
	// _this select 1: Selection (=body part) that was hit
	// _this select 2: Damage to the above selection (sum of dealt and prior damage)
	// _this select 3: Source of damage (returns the unit if no source)
	// _this select 4: Ammo classname of the projectile that dealt the damage (returns "" if no projectile)
	_unit = _this select 0;
	_part = _this select 1;
	_damage = _this select 2;
	_damageSource = _this select 3;
	_damageProjectile = _this select 4;

	_vitalParts = ["","head_hit","body"];
	_vital = if (_part in _vitalParts) then { true } else { false };
	_unconscious = if (lifeState _unit == "UNCONSCIOUS") then { true } else { false };

	//diag_log "damage: ";
	//diag_log str(_damage);
	
	_returnDamage = _damage;

	if (_unconscious) then {
		_returnDamage = 0;
	};

	if (_vital && (_damage > 0.9) && !(_unconscious)) then {
		_unit setDamage 0.8;
		_unit allowDamage false;
		_unit setCaptive true;
		_unit setUnconscious true;
		_returnDamage = 0.0;
		//if (scriptDone wcHandleUnconsciousLoop) then {
			terminate wcHandleUnconsciousLoop;
			wcHandleUnconsciousLoop = [_unit] spawn unconcsciousLoop;
		//};
		//_unit playAction "GestureSpasm0";
		//_unit playAction "agonyStart";
		//diag_log "unconcscious state";
	};

	_returnDamage;
};

unconcsciousLoop = {
	_unit = _this select 0;
	//_unit spawn {
		_unit playAction "healedStart";
		waitUntil { (animationState _unit == "ainjppnemstpsnonwrfldnon_injuredhealed") or (lifeState _unit != "UNCONSCIOUS") };
		//_unit playAction ("GestureSpasm" + str floor random 7);
		[nil, _unit, rPLAYACTION, ("GestureSpasm" + str floor random 7)] call RE;

		waitUntil { (damage _unit < 0.7) or (lifeState _unit != "UNCONSCIOUS") };
		_unit setUnconscious false;
		_unit setCaptive false;
		_unit allowDamage true;
		//_unit setDamage 0;
		diag_log "healed";

		//_unit playAction "GestureNod";
		[nil, _unit, rPLAYACTION, "GestureNod"] call RE;
		_unit playAction "agonyStop";
	//};
	//_unit playAction "healedStart";
	//waitUntil { (animationState _unit == "ainjppnemstpsnonwrfldnon_injuredhealed") or (lifeState _unit != "UNCONSCIOUS") };
	//while { lifeState _unit == "UNCONSCIOUS" } do {
	//	_unit playAction ("GestureSpasm" + str floor random 7);
	//	//waitUntil { (animationState _unit != "ainjppnemstpsnonwrfldnon") or (lifeState _unit != "UNCONSCIOUS") };
	//	sleep 5;
	//};
	//_unit playAction "GestureNod";
	//_unit playAction "agonyStop";
};

//unconcsciousLoop = {
//	_unit = _this select 0;
//	_unit playAction "agonyStart";
//	_animState = animationState _unit;
//	diag_log ("start: agonyStart: " + (str _animState));
//	while { lifeState _unit == "UNCONSCIOUS" } do {
//		if (damage _unit < 0.8) then {
//			_unit setUnconscious false;
//			diag_log "damage less than 0.8";
//		};
//		diag_log "before waitUntil";
//		waitUntil { ((animationState _unit) != "ainjppnemstpsnonwrfldnon") or (lifeState _unit != "UNCONSCIOUS")};
//		diag_log "after waitUntil";
//		_unit playActionNow ("GestureSpasm" + str floor random 7);
//		_animState = animationState _unit;
//		diag_log ("GestureSpasm: " + (str _animState));
//	};
//	_unit switchMove "agonyStop";
//	diag_log "agonyStop";
//	_unit setCaptive false;
//	_unit allowDamage false;
//};
