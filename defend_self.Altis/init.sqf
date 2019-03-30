if (IsDedicated) exitWith {};



null = [] spawn {

	
	
	_twnlist = [];
	_random_pos = [nil,["water"]] call BIS_fnc_randomPos;
 	_random_town = nearestLocations [_random_pos, ["NameCity", "NameVillage", "NameCityCapital"], 50000];

	_pos_royal_fight = getPos (_random_town call BIS_fnc_selectRandom);
	respawn setPos _pos_royal_fight;
	_pos_respawn = getPos respawn;
	_pos_respawn set [2,150];
	respawn setpos _pos_respawn;

	waitUntil {{(alive _x)} count allPlayers > 0};


	[respawn] spawn  {
		params ["_pos"];
		while {true} do {
		if ({(alive _x) and (side _x == resistance )} count allUnits < 3) then {

			[ _pos, resistance , ["I_Survivor_F"] , 15 , false ] call FUNMission_fnc_troopReinforcement;

			{
				deleteVehicle _x;

			} forEach allDead;
			{
				if(side _x == resistance) then {
					deletevehicle _x
				};

			} forEach allUnits;

		};
		sleep 35;
		};
	};



	[respawn] spawn  {
		params ["_target"];

		while {true} do {
		sleep 100;
			[ _target, resistance , ["B_APC_Wheeled_01_cannon_F","O_APC_Wheeled_02_rcws_v2_F","I_C_Offroad_02_LMG_F","B_MRAP_01_gmg_F","I_G_Offroad_01_armed_F"], false, "NONE" ] call FUNMission_fnc_vehicleReinforcement;
		};
	};



	[respawn] spawn  {
		params ["_target"];

		while {true} do {
		sleep 160;
		[_target ,resistance ,["I_G_Offroad_01_armed_F","I_C_Offroad_02_LMG_F","B_Quadbike_01_F","B_LSV_01_armed_F","O_LSV_02_armed_F"],["C_IDAP_Heli_Transport_02_F"],[false,true] call BIS_fnc_selectRandom]  call FUNMission_fnc_vehicleDrop;
		

		};
	};

	[respawn] spawn  {
		params ["_target"];
		while {true} do {
		sleep 130;
			[_target , ["B_CargoNet_01_ammo_F"],["C_IDAP_Heli_Transport_02_F"]] call FUNMission_fnc_supplyDrop;
		};
	};


	
	[_pos_royal_fight] spawn  {
		params ["_pos"];

		while {true} do {
		sleep 5;	
			_grenade = "DemoCharge_Remote_Ammo_Scripted" createVehicle ([[[_pos, 250]],[]] call BIS_fnc_randomPos);
			0 = _grenade spawn {
				_this setDamage 1;
			};
		};
	};

	{

	_pos = _pos_royal_fight;
	_pos set [2,0];
	_x setPos _pos;

	} forEach allUnits;
};

