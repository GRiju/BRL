#include <a_npc> // Az NPC f�ggv�nyk�nyvt�r be�gyaz�sa

new npcstarted = 0;

public OnRecordingPlaybackEnd()
{
	if(npcstarted == 0) npcstarted = 1, StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER, "metro12");
	else if(npcstarted == 1) npcstarted = 0, StartRecordingPlayback(PLAYER_RECORDING_TYPE_DRIVER, "metro11");
}

public OnNPCEnterVehicle (vehicleid, seatid)
{
	StartRecordingPlayback (PLAYER_RECORDING_TYPE_DRIVER, "metro11");
	return 0;
}

