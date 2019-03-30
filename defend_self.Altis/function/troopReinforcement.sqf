/* ----- */
/* [ player, west , ["B_T_Recon_F","B_T_Recon_JTAC_F","B_T_Soldier_F"] ,1 , true ] call FUNmission_fnc_troopReinforcement; */


/* -----*/
/* [ player, east , ["O_Soldier_F","O_Soldier_LAT_F","O_Soldier_GL_F"] , 1 , false ] call FUNmission_fnc_troopReinforcement; */



/* ----- */

null = _this spawn { 

	params[ "_caller","_side","_list_troop","_troop_count","_will_join_the_caller" ];

	

	_random_gears = [true] call FUNMission_fnc_randomGears;
	waitUntil { !(count _random_gears == 0) };

	_marker_spawn = [[[position _caller, 170]],[[position _caller, 45],["water"],["building"]]] call BIS_fnc_randomPos;
	_marker_troop_to_secure = _caller;

	private _troop_group_attacker = createGroup [_side, true];

	for [{_i=0}, {_i<_troop_count}, {_i=_i+1}] do {
	 	(_list_troop call BIS_fnc_selectRandom) createUnit [[[[position _caller, 170]],[[position _caller, 45],["water"],["building"]]] call BIS_fnc_randomPos, _troop_group_attacker];
	};

	

	{
		_pos_unit = getPos _x;
		_pos_unit set [2,150];
		_x setpos _pos_unit;

		_x allowFleeing 0;
		_x setSkill 0.1;
		_x addRating -3000;

		removeAllItems _x;

		_x addEventHandler["Killed",{
			_chance = ([1,2,3,4,5] call BIS_fnc_selectRandom);
			(_this select 1) setSkill ((skill (_this select 1)) + 0.1);
			(_this select 1) addRating -3000;

			if (_chance == 3) then {
				(_this select 1) addItem "FirstAidkit";
			};
			if (_chance == 2 or _chance == 5) then {
			_grenade = "DemoCharge_Remote_Ammo_Scripted" createVehicle (position (_this select 0));
				0 = _grenade spawn {
					_this setDamage 1;
				};
			};
		}];

		
		_x addHeadgear ((_random_gears select 0) call BIS_fnc_selectRandom);
		_x addGoggles ((_random_gears select 1) call BIS_fnc_selectRandom);
		_x addUniform ((_random_gears select 2) call BIS_fnc_selectRandom);
		_x addVest ((_random_gears select 3) call BIS_fnc_selectRandom);
		_x addBackpack "B_Parachute";
		_x addWeapon ((_random_gears select 5) call BIS_fnc_selectRandom);
		[_x,1] call FUNMission_fnc_fillUnitAmmo;
		_x addPrimaryWeaponItem ((_random_gears select 7) call BIS_fnc_selectRandom);
		_x addItem ((_random_gears select 7) call BIS_fnc_selectRandom);

		if (_will_join_the_caller) then {

			_x disableAI "COVER";
			_x disableAI "TARGET";
			_x disableAI "AUTOTARGET";
			_x disableAI "AUTOCOMBAT";
			_x disableAI "SUPPRESSION";
			_x setCaptive 1;
		};



	

	} forEach (units  _troop_group_attacker);


	_wp_troop = _troop_group_attacker addWaypoint [position _marker_troop_to_secure, 1];
	_troop_group_attacker setSpeedMode "full";
	_wp_troop setWaypointType "MOVE";
	_wp_troop waypointAttachVehicle vehicle _marker_troop_to_secure;
	_wp_troop doMove (position _marker_troop_to_secure);

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

