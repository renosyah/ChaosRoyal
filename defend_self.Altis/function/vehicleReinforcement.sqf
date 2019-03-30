/* ----- */
/* [ player, west , ["B_MRAP_01_gmg_F"], true, "NONE" ] call FUNMission_fnc_vehicleReinforcement; */


/* ----- */

null = _this spawn { 

	params[ "_caller","_side","_list_vehicle","_will_join_the_caller","_special_status" ];

	_random_pos = [[[position _caller, 1000]],[[position _caller, 900]]] call BIS_fnc_randomPos;
	_marker_spawn = [_random_pos, 1500] call BIS_fnc_nearestRoad;
	_marker_troop_to_secure = [[[position _caller, 90]],[[position _caller, 80]]] call BIS_fnc_randomPos;

	private _troop_group_attacker = createGroup [_side, true];
	
	_vehicle = createVehicle [(_list_vehicle call BIS_fnc_selectRandom), _marker_spawn, [], 0, _special_status];
	createVehicleCrew _vehicle;

	(crew _vehicle) join _troop_group_attacker;

	{
		_x allowFleeing 0;
		_x addRating -3000;

		if (_will_join_the_caller) then {

			_x disableAI "COVER";
			_x disableAI "TARGET";
			_x disableAI "AUTOTARGET";
			_x disableAI "AUTOCOMBAT";
			_x disableAI "SUPPRESSION";
			_x setCaptive 1;
		};

	} forEach (units  _troop_group_attacker);


	_wp_troop = _troop_group_attacker addWaypoint [_marker_troop_to_secure, 1];
	_troop_group_attacker setSpeedMode "full";
	_wp_troop setWaypointType "MOVE";

	if (!(_will_join_the_caller)) then {
		_troop_group_attacker setBehaviour "COMBAT";
		_wp_troop setWaypointType "SAD";
		_troop_group_attacker setSpeedMode "NORMAL";
	};

	waitUntil { (currentWaypoint (_wp_troop select 0)) > (_wp_troop select 1) };

	{
		_x allowFleeing 0;
		_x enableAI "COVER";
		_x enableAI "TARGET";
		_x enableAI "AUTOTARGET";
		_x enableAI "AUTOCOMBAT";
		_x enableAI "SUPPRESSION";
		_x setCaptive 0;

	} forEach (units  _troop_group_attacker);

	if (_will_join_the_caller) then {
		(units _troop_group_attacker) join _caller;
	};

};

