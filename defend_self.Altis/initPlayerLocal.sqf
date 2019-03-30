player setVariable["Saved_Loadout",([true] call FUNMission_fnc_randomGears)];
player addRating -3000;
[player] join (createGroup [west, true]);
