player enableStamina false;
player addeventhandler ["Fired"," _this execVM 'function\reload_auto.sqf'"];

removeAllWeapons player;
removeGoggles player;
removeHeadgear player;
removeVest player;
removeUniform player;
removeAllAssignedItems player;
clearAllItemsFromBackpack player;
removeBackpack player;

_random_gears = player getVariable["Saved_Loadout",[]];
waitUntil {(count _random_gears) != 0};

player addHeadgear (selectRandom (_random_gears select 0));
player addGoggles  (selectRandom(_random_gears select 1));
player addUniform (selectRandom (_random_gears select 2));
player addVest (selectRandom (_random_gears select 3));
player addBackpack (selectRandom (_random_gears select 4));
player addWeapon (selectRandom (_random_gears select 5));
[player,1] call FUNMission_fnc_fillUnitAmmo;
player addPrimaryWeaponItem (selectRandom (_random_gears select 7));
player addItem (selectRandom (_random_gears select 7));


