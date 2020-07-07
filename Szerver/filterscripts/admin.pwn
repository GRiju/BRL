#include <a_samp>
#include <zcmd>
#include <mysql>
#include <sscanf2>
#include <gvar>
#include <dudb>
//#include <youtube>
#include <streamer>
#include <mapandreas>
//#include <YSF>

#undef MAX_PLAYERS
#define MAX_PLAYERS 50

native WP_Hash( buffer[], len, const str[]);
native gpci(playerid,const serial[],maxlen);

#define RAKSAMP_CLIENT "EA4EFCCFCED89FEFF0CDA5948E59880D5D8E954E"

#pragma unused strtok

#define PRESSED(%0) \
		(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define HOLDING(%0) \
		((newkeys & (%0)) == (%0))

#define RELEASED(%0) \
		(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define ALAP_DIALOG 1001
#define EVENT_DIALOG 1002
#define EVENTRACE_DIALOG 1003
#define EVENTSTUNT_DIALOG 1004
#define NEVEZESI_DIALOG 1005
#define STARTTIME_DIALOG 1006
#define KIRUGAS_DIALOG 1007
#define EVENTSTART_DIALOG 1008
#define AUTOSTART_DIALOG 1009
#define APANEL_DIALOG 1010
#define ZENEADMIN_DIALOG 1011
#define ZENE1_DIALOG 1012
#define RADIO_DIALOG 1013
#define ZENE2_DIALOG 1014
#define ZENE3_DIALOG 1015
#define ZENE4_DIALOG 1016
#define ZENEVOTE_DIALOG 1017
#define ZENEKLINK_DIALOG 1018
#define ZENEKNEV_DIALOG 1019
#define ZENEFOGAD_DIALOG 1020
#define DIALOG_RCONLOGIN 1021
#define SKIN_DIALOG 1022
//#define MSN_DIALOG 1023 //ezt ne írjam sehova
#define RULES1_DIALOG 1024
#define RULES2_DIALOG 1025
//1026
//1027
#define MYACHIE_DIALOG 1028
#define ACHIE_DIALOG 1029
#define EGYEZES_DIALOG 1030

new CarName[][] =
{
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
	"Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
	"Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection",
	"Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
	"Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
	"Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
	"Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
	"Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC Van",
	"Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
	"Oceanic","Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
	"Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
	"Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
	"Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
	"Blista Compact", "Police Maverick", "Boxvillde", "Benson", "Mesa", "RC Goblin",
	"Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
	"Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt",
 	"Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
 	"FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
 	"Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
 	"Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
    "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder", "Primo",
	"Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
	"Windsor", "Monster", "Monster", "Uranus", "Jester", "Sultan", "Stratium",
	"Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
	"Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
	"News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
	"Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "Police Car",
 	"Police Car", "Police Car", "Police Ranger", "Picador", "S.W.A.T", "Alpha",
 	"Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs", "Boxville",
 	"Tiller", "Utility Trailer"
};

//----------------------Havazás by Kwadre(?)-------------------------
#define HAVAZAS
#if defined HAVAZAS
#define MAX_SNOWSLOTS           500

#define MAX_SNOW_OBJECTS    5
#define UPDATE_INTERVAL     1000

#if MAX_SNOWSLOTS == -1
	#error Change MAX_SNOWSLOTS to the max players of your server! (At line 6)
#endif

#define ploop(%0)			for(new %0 = 0; %0 < MAX_SNOWSLOTS; %0++) if(IsPlayerConnected(%0))
#define CB:%0(%1)           forward %0(%1); public %0(%1)

new snowObject[MAX_SNOW_OBJECTS],
	updateTimer[MAX_SNOWSLOTS char]
;
#endif
//--------------------------------------------------------------------
//--------------------------Lottó rendszer-----------------------------
new lszamok[5][MAX_PLAYERS];
//new talalt[5][MAX_PLAYERS];
new nyeremeny[MAX_PLAYERS];
//---------------------------------------------------------------------
//--------------------------Reakcióteszt-------------------------------
new reakciotimer;
new megoldastimer;
new bool:rteszt;
new megoldasszamlalo;
new reakciosz[50];

#define REAKCIO_EXP 3
//---------------------------------------------------------------------
//--------------------------karácsonyi dolgok--------------------------
#define SNOW
#define AJANDEKOK
//#define KARACSONYIJATEK

new fa[6];
new jetpack, pirula, gaz;
new sapka, laser;
new bool:playersapka[MAX_PLAYERS];

#define MAX_GIFTS 19
#define MAX_DISZ 12

#if defined AJANDEKOK
forward ajandekrespawn();

new ajandekresi_timer;
new gifts[MAX_GIFTS];
new giftarea[MAX_GIFTS];
enum giftpos
{
	Float:gx,
	Float:gy,
	Float:gz
}

new giftpost[][giftpos] =
{
	{-1988.9268, 1129.5015, 83.5966}, // 0 /1
	{-1772.3986,1004.6949,82.9922}, // 0 /2
	{-2718.4331,-320.1149,57.4873}, // 0 /3
	{-2022.0464,361.9465,55.0101}, // 1 /1
	{-2080.4038,302.8169,105.7115}, // 1 /2
	{-2487.5159,-1229.2233,227.7258}, // 1 /3
	{-2410.8459,362.2698,67.1641}, // 2 /1
	{-2789.5098,375.5555,48.9928}, // 2 /2
	{-1435.4352,-964.1208,201.0160}, // 2 /3
	{-2665.2839,1368.5597,16.9978}, // 3 /1
	{-2366.6094,1535.7874,2.1172}, // 3 /2
	{-1545.8296,126.5410,47.6778}, // 3 /3
	{-1498.1873,-382.9599,15.7443}, // 4 /1
	{-1280.0616,53.7563,71.1720}, // 4 /2
	{-2336.2288,498.4468,73.7422}, // 4 /3
	{-1992.4158,669.0779,145.3203}, // 5 /1
	{-2659.5708,1530.3831,54.9632}, // 5 /2
	{-1438.2689,1491.3143,1.8672}, // 5 /3
	{-1385.2781,671.2596,3.0703}, // 6 /1
	{-1954.1910,1344.8259,31.2266}, // 6 /2
	{-1572.1772,359.2681,50.5197}, // 6 /3
	{-2216.3035,-340.6814,44.8008}, // 7 /1
	{-2848.8374,876.6339,44.0547}, // 7 /2
	{-1666.7469,1119.9980,23.6872}, // 7 /3
	{-1598.5437,1337.0942,4.1531}, // 8 /1
	{-1588.6637,38.7864,17.3281}, // 8 /2
	{-2116.7476,-16.3657,35.3203}, // 8 /3
	{-2061.8125,-194.8515,35.3203}, // 9 /1
	{-2394.9707,-188.6079,49.0938}, // 9 /2
	{-1877.8776,487.1371,115.8706}, // 9 /3
	{-2563.6016,643.5479,49.0500}, // 10 /1
	{-1854.9465,-92.1202,36.8438}, // 10 /2
	{-1405.7888,7.3220,5.8109}, // 10 /3
	{-1258.8748,763.0408,34.5781}, // 11 /1
	{-1687.1432,-92.9948,3.5781}, // 11 /2
	{-2185.5596,-206.8167,44.2174}, // 11 /3
	{-2482.6165,-284.7987,35.5828}, // 12 /1
	{-2796.6829,240.6947,7.1875}, // 12 /2
	{-2748.5347,208.7667,7.1000}, // 12 /3
	{-2170.1960,-2417.6045,37.0531}, // 13 /1
	{-2108.8428,-2400.4019,31.3910}, // 13 /2
	{-2085.7134,-2532.7258,30.4219}, // 13 /3
	{-1633.1194,-2239.2781,31.4766}, // 14 /1
	{-1570.3170,-1947.0977,92.1034}, // 14 /2
	{-1218.8976,-2340.6531,17.3533}, // 14 /3
	{-795.0997,-1798.4806,118.6887}, // 15 /1
	{-787.2136,-1639.0494,120.6233}, // 15 /2
	{-370.1079,-1413.7347,29.6406}, // 15 /3
	{463.7896,-1599.8018,25.4766}, // 16 /1
	{1304.5383,-1573.7606,15.0085}, // 16 /2
	{1480.0863,-1638.0371,14.1484}, // 16 /3
	{2871.1086,-1592.2728,22.4495}, // 17 /1
	{2857.1785,-1137.2379,32.0584}, // 17 /2
	{1551.6128,-1338.6321,330.0000}, // 17 /3
	{1786.6727,-1303.2827,13.5552}, // 18 /1
	{2592.0437,-666.2319,136.1831}, // 18 /2
	{2409.9724,90.5745,26.4733} // 18 /3

};

#endif

new disz[MAX_DISZ];
new diszarea[MAX_DISZ];
//new bool:unnep;
#if defined SNOW
new chsnow[30];
#endif

#define MAX_JATEKRESZ 10
new jatekobjects[MAX_JATEKRESZ];
new jatekarea[MAX_JATEKRESZ];
new ajiobjectek[19];
new ajikapu;

#define DIALOG_JATEK1 1026
#define DIALOG_JATEK2 1027
//---------------------------------------------------------------------
//---------------------------------------------------------------------
//--------------------MSN rendszer-------------------------------------
//new msnsor1[MAX_PLAYERS][MAX_PLAYERS][128]; msnsor2[MAX_PLAYERS][MAX_PLAYERS][128], msnsor3[MAX_PLAYERS][MAX_PLAYERS][128];
//new msnsor4[MAX_PLAYERS][MAX_PLAYERS][128], msnsor5[MAX_PLAYERS][MAX_PLAYERS][128];
//---------------------------------------------------------------------

#define SQL_HOST	""
#define SQL_DB		""
#define SQL_USER	""
#define SQL_PASS	""

#define MAX_FAIL_LOGINS 3
#define VOTEKICK_VOTES 5
#define ENABLE_SPECTATE
#define PING_KICK //Aktiválja a magas ping kickelést
#define MAXPING 500 //Max ping
#define ANTIFLOOD //antiflood aktiválása
#define MAX_FLOOD 5 //mennyit küldhet el max MAX_FLOODT másodpercenként
#define MAX_FLOODT 3 //hány másodpercenként küldhet el MAX_FLOOD üzenetet

#pragma unused ret_memcpy

new query[500];
new linen[1024];
new LastPM[MAX_PLAYERS];
new elteltt[MAX_PLAYERS];

#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2
new CurrentVirtualWorld[MAX_PLAYERS];
enum pSpec
{
    SpectateUpdate,
    SpectateID,
    SpectateType,
};
new Spec[MAX_PLAYERS][pSpec];
new spectateupdatetimer;
new ajtimer[MAX_PLAYERS];
new dstring[1900];

new counttimer;
new countt;
//---------------------Anticheat--------------------------------

#if defined ANTIFLOOD
new antiflood_t[MAX_PLAYERS];
#endif

//new antifk_timer[MAX_PLAYERS];

new adminok[12][0] =
{
	"Ryuuzaki",
	"Rodney",
	"Blee$H",
	"Austin",
	"Shika",
	"Red_Hot",
	"[VTR]kockafej",
	"SolKing",
	"Steewiiee.",
	"Eleci",
	"Victor",
	"Ecstasy"
};

new cenzuralt[12][0]=
{
	//{"Cas"},
	{"fasz"},
	{"geci"},
	{"csicska"},
	{"anyád"},
	{"ribanc"},
	//{"kurva"},
	{"buzi"},
	{"bazd"},
	{"picsa"},
	{"szop"},
	{"pina"},
	{"punci"},
	{"basz"}
};


#define CHANGERCON
#if defined CHANGERCON
new rconjelszo[64] = "applenotebook";
new rconszam = 0;
new rconszam2;
new rcontim;
#endif
//----------------------------------------------------------------

new teamnames[37][0]=
{
	{"CIVIL"},
	{"BKV"},
	{"MÁV"},
	{"TAXI"},
	{"MENTÕS"},
	{"BANKOS"},
	{"BANKRABLÓ"},
	{"KAMIONOS"},
	{"ZSARU"},
	{"POLITIKUS"},
	{"KATONA"},
	{"RIFA"},
	{"TRIÁD"},
	{"MAFFIA"},
	{"VIETNAM"},
	{"GROVE"},
	{"PAP"},
	{"RIPORT"},
	{"TÛZOLTÓ"},
	{"RODNEYTEAM"},
	{"TRIÁD"},
	{"RIFA"},
	{"MAFFIA"},
	{"DANANG"},
	{"STUNTER"},
	{"TERRORISTA"},
	{"TDM1"},
	{"TDM2"},
	{"HACKER"},
	{"RYU'S CARS"},
	{"HOTDOG"},
	{"ÚTTISZTÍTÓ"},
	{"FARMER"},
	{"Klán1"},
	{"Klán2"},
	{"TDM1"},
	{"TDM2"}
};

new Errors[][]= {
{"[ HIBA ]: Érvénytelen JátékosID!"},
{"[ HIBA ]: Ezt a parancsot nem használhatod magadon!"},
{"[ HIBA ]: Ezt a parancsot nem használhatod nálad magasabb szintû adminon!"}
};

new LevelErrors[][]= {
{"[ HIBA ]: Ehez a parancshoz RCON adminisztrátornak kéne lenned!"},
{"[ HIBA ]: Ehez a parancshoz legalább moderátornak kell lenned!"},
{"[ HIBA ]: Ehez a parancshoz legalább Kezdõ Adminisztrátornak kell lenned!"},
{"[ HIBA ]: Ehez a parancshoz legalább Adminisztrátornak kell lenned!"},
{"[ HIBA ]: Ehez a parancshoz legalább Fõ Adminisztrátornak kell lenned!"},
{"[ HIBA ]: Ezt a parancsot nem használhatod, mert az idõ automata!"},
{"[ HIBA ]: Ehez a parancshoz VIP tagnak kell lenned!"}
};

//Reklámok
new Reklamok[][] =
{
    //"[ Reklám ]: Olcsó szerver kell? www.fps-system.eu",
    "[ Reklám ]: Regisztrálj a szerver fórumjára: www.brl.ucoz.net",
    "[ Reklám ]: Ha tetszik a szerver tedd a kedvencek közé ;)   -   [ IP: s2.fps-system.eu:8321 ]",
    "[ Tipp ]: Tartsd be a szabályokat és tiszteld a játékostársaid valamint az adminisztrátorokat!",
    "[ Tipp ]: Szabálysértõt látsz? Jelentsd a /report paranccsal!",
    "[ Tipp ]: Ha ki akarsz rabolni egy üzletet, elég bemenni és beírni az adott helyen a /rabol parancsot.",
    "[ Tipp ]: A ruhaüzletekben (A térképen ruha ikonnal vannak jelölve) vehetsz új ruhákat.",
    "[ Tipp ]: Akarsz beszélni valakivel, de nem akarod hogy mások megtudják? Használd: /pm /w /cw parancsokat!",
    "[ Tudtad? ]: A szerveren alapíthatsz klánt is! /claninfo",
	"[ Tipp ]: Nincs pénzed? Vagy elég szerencsés? Lottózz: /lottoinfo",
	"[ Tipp ]: Ha köröznek, találj egy Körözési csillagot és csökkentsd a körözésed.",
    "[ Tipp ]: A szerveren el vannak rejtve csomagok, ha megtalálod õket, jutalmat kapsz.",
    //"[ Reklám ]: FPS-SYSTEM.eu | SA-MP szerverek már 15ft/slot ártól! zsobo@fps-system.eu vagy info@fps-system.eu",
    "[ Reklám ]: www.sampforum.hu , egy jó közösség!",
//    "[ Tipp ]: AdminTeamünk megnézéséért, használd  az /adminok parancsot",
    //"[ Tipp ]: Az Okoska BKV Zrt. jegyáraiért /jegyarak ; a bérlettel utazókért a /berletesek parancsot használd",
	//"[ Figyelem! ]: 2012. Január 22.-étõl változtak az Okoska BKV Zrt Jegy- és Bérletárai!",
	"[ Figyelem ]: Rendõrnek és Katonának kizárólag fórumon lehet jelentkezni!",
    "[ Tipp ]: Ha hibát vagy hiányosságot látsz a szerveren használd a /bugreport parancsot!",
    "[ Reklám ]: A szerver UCP-je: brl.fps-system.eu",
    "[ Reklám ]: Lépj be a szerver facebook csoportjába: Budapest Real Life"
};

//Timerek
new reklamtim;
new saveplayertotim;
new clanbantim;
new featurestim;
new lottozastim;
new antictim;

#define COLOR_HASZNALATIMOD     0x898992FF
#define COLOR_YELLOW 			0xffff00AA
#define COLOR_BROWN 			0x993300AA
#define COLOR_ERROR             0x898992FF
#define COLOR_RED               0x898992FF
#define COLOR_REGLOG 			0xFF9D00FF
#define COLOR_ADMINCMDMESSAGE 	0xFF9D00FF
#define COLOR_ADMINMSG 			0xFF9D00FF
#define COLOR_CONNECT           0x33ff00AA
#define COLOR_TEAMCHAT          0xFFFF00FF
#define COLOR_ADMINCHAT         0xFF0000FF
#define COLOR_ASAY		        0xFF9D00FF
#define COLOR_3DLABEL			0xFF0000FF
#define COLOR_REKLAM            0x99ff00AA
#define COLOR_REPORT            0xFAEA0AFF
#define COLOR_PM_BE             0xFFFF22AA
#define COLOR_PM_KI             0xFFCC2299
#define COLOR_IRCCHAT           0xFFFFFFFF
#define COLOR_ACHAT             0xff0000AA
#define COLOR_SAY               0x00E3E3FF
#define COLOR_ME                0xF9B7FFAA
#define COLOR_VALASZ            0x96C983FF
#define COLOR_GREEN 			0x33AA33AA
#define COLOR_WHITE         	0xFFFFFFAA
#define COLOR_GREY          	0xAFAFAFAA
#define COLOR_PMSHOW            0xff00a6AA
#define COLOR_LIGHTGREEN		0x24FF0AB9

#define WHITE 		0xFFFFFFFF
#define CYAN 		0xC9FFFFFF
#define TURQ 		0x00FFFFFF
#define PINK 		0xFFDAFFFF
#define EMO			0xFF00FFFF
#define BUTTER 		0xFFFFDCFF
#define YELLOW 		0xFFFF00FF
#define GOLD	 	0xFFCB00FF
#define ORANGE 		0xFF9D00FF
#define ROSE		0xFF0000BD
#define RED 		0xAD0000FF
#define LIME 		0xD1FF00FF
#define GRASS 		0xA8FF00FF
#define VOMIT 		0x65FF00FF
#define GREEN 		0x00C100FF
#define SEAWEED 	0x008800FF
#define PUSSY 		0xFF009FFF
#define VIOLET 		0xBF00FFFF
#define PURPLE 		0x8800FFFF
#define DEEPBLUE 	0x5300FFFF
#define BLUE 		0x0097FFFF
#define SKYBLUE 	0x00C9FFFF
#define AQUAMARINE 	0x00FFCBFF
#define TEAL 		0x748CC0FF
#define SHIT 		0x7B3000FF
#define BROWN 		0x9F6100FF
#define CHOCOLATE 	0xBE8900FF
#define SALMON 		0xFFA9A0FF
#define GREY 		0xAFAFAFAA
#define COLOR_BKV   0x1D89F5AA

#define HYELLOW		"{FFFF00}"
#define HBLUE       "{0000FF}"
#define HLIME       "{00FF00}"
#define HRED 		"{FF0000}"
#define HORANGE     "{FFA500}"
#define HGOLD       "{FFD700}"
#define HWHITE   	"{FFFFFF}"
#define HGREEN		"{00FF00}"


#define REGISTER_DIALOG 1
#define LOGIN_DIALOG 2
#define DIALOG_PARANCSLIST 3

new FALSE = false;
#define SendFormatMessage(%1,%2,%3,%4) do{new sendfstring[128];format(sendfstring,256,(%3),%4);SendClientMessage(%1,(%2),sendfstring);}while(FALSE)
#define SendFormatMessageToAll(%1,%2,%3) do{new sendfstring[128];format(sendfstring,256,(%2),%3);SendClientMessageToAll((%1),sendfstring);}while(FALSE)

new npccar, npccar2;
new cube;

#define WEAPONBODY

#if defined WEAPONBODY

#define ARMEDBODY_USE_HEAVY_WEAPON                      (true)

static armedbody_pTick[MAX_PLAYERS];

#endif

public OnFilterScriptInit()
{
	SendRconCommand("rcon_password pongo56");
    #if defined CHANGERCON
	rconszam = 0;
	rconszam2 = 10 + random(9999);
	rcontim = SetTimer("rcontimer", 10000, 1);
	#endif
	featurestim = SetTimer("featurestimer", 3000, 1);
	ConnectNPC("Metro2", "npc2");
    ConnectNPC("Metro1", "npc");
	npccar = AddStaticVehicle(431, 0, 0, 0, 66, 66, 1);
	npccar2 = AddStaticVehicle(431, 0, 0, 0, 66, 66, 1);
//	mysql_debug(1);
	new MySQL:connection = mysql_init(LOG_ALL);
	mysql_connect(SQL_HOST, SQL_USER, SQL_PASS, SQL_DB, connection, 1);
	if(mysql_ping())
	{
	    print(!"MySQL: Kapcsolódás sikertelen!");
		return 1;
 	}
 	print("MySQL: Kapcsolódás sikeres!");
 	print("Havazás by Kwadre");
 	reklamtim = SetTimer("Reklam", 2*60*1000, true);  // 12000 = 2 minutes
// 	SetTimer("mentesek", 5*60000, true);
// 	SetTimer("nincsajban", 5000, true);
 	clanbantim = SetTimer("clanbantimer", 60000, true);
 	saveplayertotim = SetTimer("SavePlayerToDatabase", 10*1000, true);
 	lottozastim = SetTimer("lottozastimer", 20*60000, true);
 	reakciotimer = SetTimer("reakcioteszt", 2*60000, true);
  	#if defined ENABLE_SPECTATE
    spectateupdatetimer = SetTimer("SpectatorUpdate", 1000, 1);
    #endif
    antictim = SetTimer("antic", 1000, 1);
//	SetTimer("AntiMoney", 1000, 1);
//	SetTimer("resitimer", 60000, 1);
    SetGVarInt("MaxPing", MAXPING); //Meghatározza a maximális ping értéket
    SetGVarInt("nmshow", 0);
    cube = CreateDynamicCube(-2618.9102,189.4115,0.1078, -2634.0920,200.4794,2.5075);
	new p = GetMaxPlayers();
    for (new i = 0; i < p; i++)
	{
            SetPVarInt(i, "laser", 0);
    }
    print("A lézerszkriptet Skiaffo készítette.");
	#if defined KARACSONYIJATEK
	CreateChristmasGame(0, -2219.9514,-120.4945,35.3203);
	CreateChristmasGame(1, -2970.8220,452.8211,-0.0132);
	CreateChristmasGame(2, -366.6848,-1419.1453,25.7266);
	CreateChristmasGame(3, -577.3035,-1025.6990,24.0584);
    CreateChristmasGame(4, -485.0203,-555.9369,33.1215);
    CreateChristmasGame(5, 1411.5314,932.9108,10.8203);
	CreateChristmasGame(6, -389.4976, -1149.0026, 69.4304);
	
	ajiobjectek[0] = CreateDynamicObject(3050, -391.19, -1154.03, 69.57,   0.00, -180.00, 357.00);
	ajiobjectek[1] = CreateDynamicObject(3050, -391.03, -1152.08, 71.73,   -40.00, -180.00, 357.77);
	ajiobjectek[2] = CreateDynamicObject(19054, -389.90, -1153.31, 69.12,   0.00, 0.00, 0.00);
	ajiobjectek[3] = CreateDynamicObject(19055, -388.68, -1153.13, 69.22,   0.00, 0.00, 0.00);
	ajiobjectek[4] = CreateDynamicObject(19057, -387.22, -1152.95, 69.19,   0.00, 0.00, 0.00);
	ajiobjectek[5] = CreateDynamicObject(19058, -385.68, -1152.29, 69.15,   0.00, 0.00, 0.00);
	ajiobjectek[6] = CreateDynamicObject(19058, -388.54, -1151.25, 69.15,   0.00, 0.00, 0.00);
	ajiobjectek[7] = CreateDynamicObject(19057, -387.27, -1150.69, 69.19,   0.00, 0.00, 0.00);
	ajiobjectek[8] = CreateDynamicObject(19054, -385.77, -1150.47, 69.12,   0.00, 0.00, 0.00);
	ajiobjectek[9] = CreateDynamicObject(19055, -390.50, -1151.03, 69.22,   0.00, 0.00, 0.00);
	ajiobjectek[10] = CreateDynamicObject(19058, -388.49, -1152.23, 70.30,   0.00, 0.00, 0.00);
	ajiobjectek[11] = CreateDynamicObject(19057, -385.61, -1151.58, 70.31,   0.00, 0.00, 0.00);
	ajiobjectek[12] = CreateDynamicObject(19055, -387.20, -1151.82, 70.25,   0.00, 0.00, 0.00);
	ajiobjectek[13] = CreateDynamicObject(19054, -386.27, -1148.51, 69.24,   0.00, 0.00, 36.91);
	ajiobjectek[14] = CreateDynamicObject(19057, -385.92, -1146.97, 69.19,   0.00, 0.00, 0.00);
	ajiobjectek[15] = CreateDynamicObject(19058, -387.61, -1149.13, 69.15,   0.00, 0.00, 35.83);
	ajiobjectek[16] = CreateDynamicObject(19055, -388.19, -1147.33, 69.22,   0.00, 0.00, 32.75);
	ajiobjectek[17] = CreateDynamicObject(19058, -386.07, -1149.61, 70.28,   0.00, 0.00, 35.83);
	ajiobjectek[18] = CreateDynamicObject(19055, -386.21, -1147.77, 70.35,   0.00, 0.00, 0.00);
	ajikapu = CreateDynamicObject(3050, -390.76, -1145.13, 69.27,   0.00, -180.00, 357.30);

	#endif
	
	#if defined AJANDEKOK
	ajandekresi_timer = SetTimer("ajandekrespawn", 60000*60, 1);
	
    switch(random(3))
    {
        case 0: CreateGift(0, giftpost[0][gx],giftpost[0][gy],giftpost[0][gz]);
        case 1: CreateGift(0, giftpost[1][gx],giftpost[1][gy],giftpost[1][gz]);
        case 2: CreateGift(0, giftpost[2][gx],giftpost[2][gy],giftpost[2][gz]);

    }
    switch(random(3))
    {
        case 0: CreateGift(1, giftpost[3][gx],giftpost[3][gy],giftpost[3][gz]);
        case 1: CreateGift(1, giftpost[4][gx],giftpost[4][gy],giftpost[4][gz]);
        case 2: CreateGift(1, giftpost[5][gx],giftpost[5][gy],giftpost[5][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(2, giftpost[6][gx],giftpost[6][gy],giftpost[6][gz]);
        case 1: CreateGift(2, giftpost[7][gx],giftpost[7][gy],giftpost[7][gz]);
        case 2: CreateGift(2, giftpost[8][gx],giftpost[8][gy],giftpost[8][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(3, giftpost[9][gx],giftpost[9][gy],giftpost[9][gz]);
        case 1: CreateGift(3, giftpost[10][gx],giftpost[10][gy],giftpost[10][gz]);
        case 2: CreateGift(3, giftpost[11][gx],giftpost[11][gy],giftpost[11][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(4, giftpost[12][gx],giftpost[12][gy],giftpost[12][gz]);
        case 1: CreateGift(4, giftpost[13][gx],giftpost[13][gy],giftpost[13][gz]);
        case 2: CreateGift(4, giftpost[14][gx],giftpost[14][gy],giftpost[14][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(5, giftpost[15][gx],giftpost[15][gy],giftpost[15][gz]);
        case 1: CreateGift(5, giftpost[16][gx],giftpost[16][gy],giftpost[16][gz]);
        case 2: CreateGift(5, giftpost[17][gx],giftpost[17][gy],giftpost[17][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(6, giftpost[18][gx],giftpost[18][gy],giftpost[18][gz]);
        case 1: CreateGift(6, giftpost[19][gx],giftpost[19][gy],giftpost[19][gz]);
        case 2: CreateGift(6, giftpost[20][gx],giftpost[20][gy],giftpost[20][gz]);
    }
    switch(random(3))
    {
	    case 0: CreateGift(7, giftpost[21][gx],giftpost[21][gy],giftpost[21][gz]);
        case 1: CreateGift(7, giftpost[22][gx],giftpost[22][gy],giftpost[22][gz]);
        case 2: CreateGift(7, giftpost[23][gx],giftpost[23][gy],giftpost[23][gz]);
	}
	switch(random(3))
	{
		case 0: CreateGift(8, giftpost[24][gx],giftpost[24][gy],giftpost[24][gz]);
        case 1: CreateGift(8, giftpost[25][gx],giftpost[25][gy],giftpost[25][gz]);
        case 2: CreateGift(8, giftpost[26][gx],giftpost[26][gy],giftpost[26][gz]);
	}
	switch(random(3))
	{
		case 0: CreateGift(9, giftpost[27][gx],giftpost[27][gy],giftpost[27][gz]);
        case 1: CreateGift(9, giftpost[28][gx],giftpost[28][gy],giftpost[28][gz]);
        case 2: CreateGift(9, giftpost[29][gx],giftpost[29][gy],giftpost[29][gz]);
	}
	switch(random(3))
	{
		case 0: CreateGift(10, giftpost[30][gx],giftpost[30][gy],giftpost[30][gz]);
        case 1: CreateGift(10, giftpost[31][gx],giftpost[31][gy],giftpost[31][gz]);
        case 2: CreateGift(10, giftpost[32][gx],giftpost[32][gy],giftpost[32][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(11, giftpost[33][gx],giftpost[33][gy],giftpost[33][gz]);
        case 1: CreateGift(11, giftpost[34][gx],giftpost[34][gy],giftpost[34][gz]);
        case 2: CreateGift(11, giftpost[35][gx],giftpost[35][gy],giftpost[35][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(12, giftpost[36][gx],giftpost[36][gy],giftpost[36][gz]);
        case 1: CreateGift(12, giftpost[37][gx],giftpost[37][gy],giftpost[37][gz]);
        case 2: CreateGift(12, giftpost[38][gx],giftpost[38][gy],giftpost[38][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(13, giftpost[39][gx],giftpost[39][gy],giftpost[39][gz]);
        case 1: CreateGift(13, giftpost[40][gx],giftpost[40][gy],giftpost[40][gz]);
        case 2: CreateGift(13, giftpost[41][gx],giftpost[41][gy],giftpost[41][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(14, giftpost[42][gx],giftpost[42][gy],giftpost[42][gz]);
        case 1: CreateGift(14, giftpost[43][gx],giftpost[43][gy],giftpost[43][gz]);
        case 2: CreateGift(14, giftpost[44][gx],giftpost[44][gy],giftpost[44][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(15, giftpost[45][gx],giftpost[45][gy],giftpost[45][gz]);
        case 1: CreateGift(15, giftpost[46][gx],giftpost[46][gy],giftpost[46][gz]);
        case 2: CreateGift(15, giftpost[47][gx],giftpost[47][gy],giftpost[47][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(16, giftpost[48][gx],giftpost[48][gy],giftpost[48][gz]);
        case 1: CreateGift(16, giftpost[49][gx],giftpost[49][gy],giftpost[49][gz]);
        case 2: CreateGift(16, giftpost[50][gx],giftpost[50][gy],giftpost[50][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(17, giftpost[51][gx],giftpost[51][gy],giftpost[51][gz]);
        case 1: CreateGift(17, giftpost[52][gx],giftpost[52][gy],giftpost[52][gz]);
        case 2: CreateGift(17, giftpost[53][gx],giftpost[53][gy],giftpost[53][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(18, giftpost[54][gx],giftpost[54][gy],giftpost[54][gz]);
        case 1: CreateGift(18, giftpost[55][gx],giftpost[55][gy],giftpost[55][gz]);
        case 2: CreateGift(18, giftpost[56][gx],giftpost[56][gy],giftpost[56][gz]);
	}
	#endif
	
	#if defined SNOW
	for(new playerid; playerid < MAX_PLAYERS; playerid++)
    {
        RemoveBuildingForPlayer(playerid, 18399, -2426.9375, -1530.4531, 440.9688, 0.25);
		RemoveBuildingForPlayer(playerid, 18570, -2249.3594, -1572.8672, 418.7656, 0.25);
		RemoveBuildingForPlayer(playerid, 18571, -2431.6797, -1759.6641, 403.8672, 0.25);
		RemoveBuildingForPlayer(playerid, 18585, -2239.6406, -1762.7266, 381.9531, 0.25);
		RemoveBuildingForPlayer(playerid, 18317, -2431.6797, -1759.6641, 403.8672, 0.25);
		RemoveBuildingForPlayer(playerid, 18309, -2426.9375, -1530.4531, 440.9688, 0.25);
		RemoveBuildingForPlayer(playerid, 18310, -2249.3594, -1572.8672, 418.7656, 0.25);
		RemoveBuildingForPlayer(playerid, 18319, -2239.6406, -1762.7266, 381.9531, 0.25);
		RemoveBuildingForPlayer(playerid, 18573, -2237.0000, -1951.5234, 297.5625, 0.25);
		RemoveBuildingForPlayer(playerid, 18574, -2181.4688, -1774.8125, 217.3984, 0.25);
		RemoveBuildingForPlayer(playerid, 18575, -2145.1953, -1576.7188, 259.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 18598, -1985.5078, -1562.5078, 84.4688, 0.25);
		RemoveBuildingForPlayer(playerid, 18328, -2237.0000, -1951.5234, 297.5625, 0.25);
		RemoveBuildingForPlayer(playerid, 18318, -2181.4688, -1774.8125, 217.3984, 0.25);
		RemoveBuildingForPlayer(playerid, 18311, -2145.1953, -1576.7188, 259.6484, 0.25);
		RemoveBuildingForPlayer(playerid, 18312, -1985.5078, -1562.5078, 84.4688, 0.25);
		RemoveBuildingForPlayer(playerid, 18578, -2426.5000, -1347.3125, 300.8047, 0.25);
		RemoveBuildingForPlayer(playerid, 18579, -2583.4297, -1343.4531, 270.8438, 0.25);
		RemoveBuildingForPlayer(playerid, 18580, -2624.3047, -1562.8828, 353.4531, 0.25);
		RemoveBuildingForPlayer(playerid, 18582, -2724.3203, -1555.9609, 222.8906, 0.25);
		RemoveBuildingForPlayer(playerid, 18583, -2700.2813, -1345.7969, 213.4609, 0.25);
		RemoveBuildingForPlayer(playerid, 18584, -2421.1563, -1134.0938, 168.7813, 0.25);
		RemoveBuildingForPlayer(playerid, 18590, -2646.3516, -1116.9297, 111.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 18308, -2724.3203, -1555.9609, 222.8906, 0.25);
		RemoveBuildingForPlayer(playerid, 18469, -2700.2813, -1345.7969, 213.4609, 0.25);
		RemoveBuildingForPlayer(playerid, 18307, -2624.3047, -1562.8828, 353.4531, 0.25);
		RemoveBuildingForPlayer(playerid, 18301, -2583.4297, -1343.4531, 270.8438, 0.25);
		RemoveBuildingForPlayer(playerid, 18297, -2646.3516, -1116.9297, 111.7578, 0.25);
		RemoveBuildingForPlayer(playerid, 18302, -2426.5000, -1347.3125, 300.8047, 0.25);
		RemoveBuildingForPlayer(playerid, 18298, -2421.1563, -1134.0938, 168.7813, 0.25);
    }
	chsnow[0] = CreateDynamicObject(18399, -2426.9375, -1530.4531, 440.9688, 0, 0, 0);
	chsnow[1] = CreateDynamicObject(18570, -2249.3594, -1572.8672, 418.7656, 0, 0, 0);
    chsnow[2] = CreateDynamicObject(18571, -2431.6797, -1759.6641, 403.8672, 0, 0, 0);
    chsnow[3] = CreateDynamicObject(18585, -2239.6406, -1762.7266, 381.9531, 0, 0, 0);
    chsnow[4] = CreateDynamicObject(18317, -2431.6797, -1759.6641, 403.8672, 0, 0, 0);
    chsnow[5] = CreateDynamicObject(18309, -2426.9375, -1530.4531, 440.9688, 0, 0, 0);
    chsnow[6] = CreateDynamicObject(18310, -2249.3594, -1572.8672, 418.7656, 0, 0, 0);
    chsnow[7] = CreateDynamicObject(18319, -2239.6406, -1762.7266, 381.9531, 0, 0, 0);
    chsnow[8] = CreateDynamicObject(18573, -2237.0000, -1951.5234, 297.5625, 0, 0, 0);
    chsnow[9] = CreateDynamicObject(18574, -2181.4688, -1774.8125, 217.3984, 0, 0, 0);
    chsnow[10] = CreateDynamicObject(18575, -2145.1953, -1576.7188, 259.6484, 0, 0, 0);
    chsnow[11] = CreateDynamicObject(18598, -1985.5078, -1562.5078, 84.4688, 0, 0, 0);
    chsnow[12] = CreateDynamicObject(18328, -2237.0000, -1951.5234, 297.5625, 0, 0, 0);
    chsnow[13] = CreateDynamicObject(18318, -2181.4688, -1774.8125, 217.3984, 0, 0, 0);
    chsnow[14] = CreateDynamicObject(18311, -2145.1953, -1576.7188, 259.6484, 0, 0, 0);
    chsnow[15] = CreateDynamicObject(18312, -1985.5078, -1562.5078, 84.4688, 0, 0, 0);
    chsnow[16] = CreateDynamicObject(18578, -2426.5000, -1347.3125, 300.8047, 0, 0, 0);
    chsnow[17] = CreateDynamicObject(18579, -2583.4297, -1343.4531, 270.8438, 0, 0, 0);
    chsnow[18] = CreateDynamicObject(18580, -2624.3047, -1562.8828, 353.4531, 0, 0, 0);
    chsnow[19] = CreateDynamicObject(18582, -2724.3203, -1555.9609, 222.8906, 0, 0, 0);
    chsnow[20] = CreateDynamicObject(18583, -2700.2813, -1345.7969, 213.4609, 0, 0, 0);
    chsnow[21] = CreateDynamicObject(18584, -2421.1563, -1134.0938, 168.7813, 0, 0, 0);
    chsnow[22] = CreateDynamicObject(18590, -2646.3516, -1116.9297, 111.7578, 0, 0, 0);
    chsnow[23] = CreateDynamicObject(18308, -2724.3203, -1555.9609, 222.8906, 0, 0, 0);
    chsnow[24] = CreateDynamicObject(18469, -2700.2813, -1345.7969, 213.4609, 0, 0, 0);
    chsnow[25] = CreateDynamicObject(18307, -2624.3047, -1562.8828, 353.4531, 0, 0, 0);
    chsnow[26] = CreateDynamicObject(18301, -2583.4297, -1343.4531, 270.8438, 0, 0, 0);
    chsnow[27] = CreateDynamicObject(18297, -2646.3516, -1116.9297, 111.7578, 0, 0, 0);
    chsnow[28] = CreateDynamicObject(18302, -2426.5000, -1347.3125, 300.8047, 0, 0, 0);
    chsnow[29] = CreateDynamicObject(18298, -2421.1563, -1134.0938, 168.7813, 0, 0, 0);
    for(new i; i < sizeof(chsnow); i++) SetDynamicObjectMaterial(chsnow[i], 0, 3922, "bistro", "mp_snow");
    for(new i; i < sizeof(chsnow); i++) SetDynamicObjectMaterial(chsnow[i], 1, 3922, "bistro", "mp_snow");
    for(new i; i < sizeof(chsnow); i++) SetDynamicObjectMaterial(chsnow[i], 2, 3922, "bistro", "mp_snow");
    for(new i; i < sizeof(chsnow); i++) SetDynamicObjectMaterial(chsnow[i], 3, 3922, "bistro", "mp_snow");
    for(new i; i < sizeof(chsnow); i++) SetDynamicObjectMaterial(chsnow[i], 4, 3922, "bistro", "mp_snow");
    for(new i; i < sizeof(chsnow); i++) SetDynamicObjectMaterial(chsnow[i], 5, 3922, "bistro", "mp_snow");
    for(new i; i < sizeof(chsnow); i++) SetDynamicObjectMaterial(chsnow[i], 6, 3922, "bistro", "mp_snow");
    for(new i; i < sizeof(chsnow); i++) SetDynamicObjectMaterial(chsnow[i], 7, 3922, "bistro", "mp_snow");
    #endif
	return 1;
}

public OnFilterScriptExit()
{
	#if defined SNOW
	for(new i; i < sizeof(chsnow); i++) DestroyDynamicObject(chsnow[i]);
	#endif
    #if defined ENABLE_SPECTATE
    KillTimer(spectateupdatetimer);
    for(new i; i < MAX_PLAYERS; i++) StopSpectate(i), KillTimer(elteltt[i]);
    #endif
    for(new i; i < MAX_PLAYERS; i++) KillTimer(elteltt[i]);
    KillTimer(reklamtim);
	KillTimer(saveplayertotim);
	KillTimer(clanbantim);
	KillTimer(featurestim);
    #if defined CHANGERCON
	KillTimer(rcontim);
	#endif
	KillTimer(lottozastim);
	KillTimer(reakciotimer);
	KillTimer(antictim);
    DestroyDynamicArea(cube);
    DeleteChristmasTree();
    //havazás
    #if defined HAVAZAS
	if(GetGVarInt("havazas") == 1)
	{
	    ploop(i)
		{
	        for(new j = 0; j < MAX_SNOW_OBJECTS; j++) DestroyDynamicObject(snowObject[j]);
			KillTimer(updateTimer{i});
		}
	}
	#endif
	#if defined KARACSONYIJATEK
	DeleteChristmasGames();
	for(new i; i < 19; i++) DestroyDynamicObject(ajiobjectek[i]);
	DestroyDynamicObject(ajikapu);
	#endif
	//------
	new p = GetMaxPlayers();
    for (new i = 0; i < p; i++) {
            SetPVarInt(i, "laser", 0);
            RemovePlayerAttachedObject(i, 0);
    }
    #if defined AJANDEKOK
    for(new i; i < MAX_GIFTS; i++)
    {
        DestroyGift(gifts[i]);
    }
    KillTimer(ajandekresi_timer);
    #endif
    mysql_close();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPosEx(playerid, -2510.0908,-700.9126,279.7344);
	SetPlayerFacingAngle(playerid, 266.7442);
	SetPlayerCameraPos(playerid, -2494.7053,-701.1025,279.7344);
	SetPlayerCameraLookAt(playerid, -2510.0908,-700.9126,279.7344);
	return 1;
}

public OnPlayerConnect(playerid)
{
   	new versistr[200], clientstr[200];
    GetPlayerVersion(playerid,versistr,sizeof(versistr));
    //SendFormatMessage(GetPlayerID("Ryu"), COLOR_RED, "Version: %s",versistr);
    gpci(playerid,clientstr,sizeof(clientstr));
    //SendFormatMessage(GetPlayerID("Ryu"), COLOR_RED, "Client ID: %s",clientstr);
    if(!strcmp(versistr, "unknown", true))
    {
        if(!strcmp(clientstr, RAKSAMP_CLIENT, true))
        {
            new ipstr[50];
            GetPlayerIp(playerid, ipstr, sizeof(ipstr));
            if(GetGVarInt(ipstr) >= 5) BanReason(playerid, "RakSAMP", "SYSTEM");
            else KickReason(playerid, "RakSAMP", "SYSTEM");
            
			SetGVarInt(ipstr, GetGVarInt(ipstr)+1);
        }
    }
	#if defined SNOW
	RemoveBuildingForPlayer(playerid, 18399, -2426.9375, -1530.4531, 440.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 18570, -2249.3594, -1572.8672, 418.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 18571, -2431.6797, -1759.6641, 403.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 18585, -2239.6406, -1762.7266, 381.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 18317, -2431.6797, -1759.6641, 403.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 18309, -2426.9375, -1530.4531, 440.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 18310, -2249.3594, -1572.8672, 418.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 18319, -2239.6406, -1762.7266, 381.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 18573, -2237.0000, -1951.5234, 297.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 18574, -2181.4688, -1774.8125, 217.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 18575, -2145.1953, -1576.7188, 259.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 18598, -1985.5078, -1562.5078, 84.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 18328, -2237.0000, -1951.5234, 297.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 18318, -2181.4688, -1774.8125, 217.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 18311, -2145.1953, -1576.7188, 259.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 18312, -1985.5078, -1562.5078, 84.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 18578, -2426.5000, -1347.3125, 300.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 18579, -2583.4297, -1343.4531, 270.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 18580, -2624.3047, -1562.8828, 353.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 18582, -2724.3203, -1555.9609, 222.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 18583, -2700.2813, -1345.7969, 213.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 18584, -2421.1563, -1134.0938, 168.7813, 0.25);
	RemoveBuildingForPlayer(playerid, 18590, -2646.3516, -1116.9297, 111.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 18308, -2724.3203, -1555.9609, 222.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 18469, -2700.2813, -1345.7969, 213.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 18307, -2624.3047, -1562.8828, 353.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 18301, -2583.4297, -1343.4531, 270.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 18297, -2646.3516, -1116.9297, 111.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 18302, -2426.5000, -1347.3125, 300.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 18298, -2421.1563, -1134.0938, 168.7813, 0.25);
	#endif
	if(IsPlayerNPC(playerid)) return 1;
	new join[128], Query[500];
	format(Query, sizeof(Query), "SELECT BanReason FROM users WHERE Name = '%s' AND Banned = 1", GetPlayerNameEx(playerid));
	mysql_query(Query);
	mysql_store_result();
	if(mysql_num_rows() == 1)
	{
		mysql_fetch_row(linen);
		new reason[128];
		sscanf(linen, "s[128]", reason);
		SetPVarInt(playerid, "banolva", 1);
		format(join, sizeof(join), "[ CSATLAKOZÁS ]: "#HBLUE"%s"#HLIME#" csatlakozott a szerverhez!", GetPlayerNameEx(playerid));
		SendClientMessageToAll(COLOR_CONNECT, join);

		new kickform[128];
		format(kickform, sizeof(kickform), "Banolt játékos (Indok: %s)", reason);
		KickReason(playerid, kickform, "SYSTEM");
		SendClientMessage(playerid, COLOR_RED, "HIBA: Te banolva vagy. Unbant kérhetsz a weblapon: www.brl.ucoz.net");
		SendFormatMessage(playerid, COLOR_RED, "Ban indok [Bant adó admin]: %s", reason);
	    mysql_free_result();
	    return 1;
	}
	format(Query, sizeof(Query), "SELECT * FROM `users` WHERE `Name` = '%s'", GetPlayerNameEx(playerid));
    mysql_query(Query);
    mysql_store_result();
    if(mysql_num_rows() != 0)
    {
        new IP[50];
        GetPlayerIp(playerid, IP, sizeof(IP));
        format(Query, sizeof(Query), "SELECT * FROM `users` WHERE `Name` = '%s' AND `IP` = '%s'", GetPlayerNameEx(playerid), IP);
        mysql_query(Query);
        mysql_store_result();
        if(mysql_num_rows() != 0) //Ha az IP ugyanaz mint ami az adatbázisban van
        {
			mysql_fetch_row(linen);
			new data2[22];
			new adminpvar[64];
			new clanpvar[30];
			sscanf(linen, "p<|>{ds[24]s[145]s[30]}ddddddddddddd{ds[128]}dddd{s[50]}ds[30]dddd{s[128]s[50]}",
			data2[0],//Money
			data2[1],//Bank
			data2[2],//Kills
			data2[3],//Deaths
			data2[4],//Level
			data2[5],//Team
			data2[6],//Skin
			data2[7],//RendorTP
			data2[8],//KatonaTP
			data2[9],//BankosTP
			data2[10],//KamrovidTP
			data2[11],//KamhosszuTP
			data2[12],//Spawnhely
			data2[13],//Ora
			data2[14],//Perc
			data2[15],//Leader
			data2[16],//AJtime
			data2[17],//Sskin
			clanpvar,//Clan
			data2[18],//ClanRank
			data2[19],//VIP
			data2[20],//Szint
			data2[21]);//EXP
            GivePlayerMoneyEx(playerid, data2[0]);
            SetPVarInt(playerid, "Bank", data2[1]);
			SetPVarInt(playerid, "Kills", data2[2]);
			SetPVarInt(playerid, "Deaths", data2[3]);
			SetPVarInt(playerid, "Level", data2[4]);
			cSetPlayerTeam(playerid, data2[5]);
			SetPVarInt(playerid, "Skin", data2[6]);
			SetPVarInt(playerid, "RendorTP", data2[7]);
			SetPVarInt(playerid, "KatonaTP", data2[8]);
			SetPVarInt(playerid, "BankosTP", data2[9]);
			SetPVarInt(playerid, "KamrovidTP", data2[10]);
			SetPVarInt(playerid, "KamhosszuTP", data2[11]);
			SetPVarInt(playerid, "Spawnhely", data2[12]);
			SetPVarInt(playerid, "Ora", data2[13]);
			SetPVarInt(playerid, "Perc", data2[14]);
			SetPVarInt(playerid, "Leader", data2[15]);
			SetPVarInt(playerid, "AJtime", data2[16]);
			SetPVarInt(playerid, "Sskin", data2[17]);
			SetPVarString(playerid, "Clan", clanpvar);
			SetPVarInt(playerid, "ClanRank", data2[18]);
			SetPVarInt(playerid, "VIP", data2[19]);
			SetPVarInt(playerid, "Szint", data2[20]);
			SetPVarInt(playerid, "EXP", data2[21]);
			
			if(GetPVarInt(playerid, "AJtime") > 1) SetPVarInt(playerid, "ajon", 1);
			switch(GetPVarInt(playerid, "Level"))//az adminszintekhez tartozó megnevezés változóba írása
			{
			    case 1: SetPVarString(playerid, "AdminRang", "Moderátor");
				case 2: SetPVarString(playerid, "AdminRang", "Kezdõ Adminisztrátor");
				case 3: SetPVarString(playerid, "AdminRang", "Haladó Adminisztrátor");
				case 4: SetPVarString(playerid, "AdminRang", "Fõ Adminisztrátor");
				case 5: SetPVarString(playerid, "AdminRang", "Anyád");
			}
			SetPVarInt(playerid, "Logged", 1);
			elteltt[playerid] = SetTimerEx("elteltido", 60000, 1, "i", playerid);
			GetPVarString(playerid, "AdminRang", adminpvar, sizeof(adminpvar));
            mysql_free_result();
            if(GetPVarInt(playerid, "Level") == 0) SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZNÁLÓ ]: Sikeresen bejelentkeztél!");
			if(GetPVarInt(playerid, "Level") != 0) SendFormatMessage(playerid, COLOR_REGLOG, "[ FELHASZNÁLÓ ]: Sikeresen bejelentkeztél! [ Rang: %s ]", adminpvar);

            format(query, sizeof(query), "SELECT * FROM skills WHERE Name = '%s'", GetPlayerNameEx(playerid));
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() == 0)
			{
			    mysql_free_result();
				format(query, sizeof(query), "INSERT INTO skills (Name, Skillpoints) VALUES ('%s', 1)", GetPlayerNameEx(playerid));
        		mysql_query(query);
        		if(GetPVarInt(playerid, "Szint") != 0) SetPVarInt(playerid, "skillpoints", GetPVarInt(playerid, "Szint")+1);
        		else SetPVarInt(playerid, "skillpoints", 1);
        		SetPVarInt(playerid, "skill1level", 0);
				SetPVarInt(playerid, "skill2level", 0);
				SetPVarInt(playerid, "skill3level", 0);
			}
			else
			{
				mysql_fetch_row(linen);
				new skillad[4];
				sscanf(linen, "p<|>{s[24]}dddd", skillad[0], skillad[1], skillad[2], skillad[3]);
				SetPVarInt(playerid, "skillpoints", skillad[0]);
				SetPVarInt(playerid, "skill1level", skillad[1]);
				SetPVarInt(playerid, "skill2level", skillad[2]);
				SetPVarInt(playerid, "skill3level", skillad[3]);

			}

			format(query, sizeof(query), "SELECT * FROM achievements WHERE Name = '%s'", GetPlayerNameEx(playerid));
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() == 0)
			{
			    mysql_free_result();
				format(query, sizeof(query), "INSERT INTO achievements (Name) VALUES ('%s')", GetPlayerNameEx(playerid));
				mysql_query(query);
			}
			else
			{
				mysql_fetch_row(linen);
				new achie[26];
				sscanf(linen, "p<|>{s[24]}dddddddddddddddddddddddddd",
				achie[0],//knifes
				achie[1],//9mm
				achie[2],//Deagle
				achie[3],//AK47
				achie[4],//Deathsat
				achie[5],//Policekills
				achie[6],//Armykills
				achie[7],//Rodkills
				achie[8],//SMG
				achie[9],//RaceRecords
				achie[10],//Racegold
				achie[11],//Racesilver
				achie[12],//Racebronze
				achie[13],//dmwins
				achie[14],//vehdrives
				achie[15],//shoprob
				achie[16],//jails
				achie[17],//elsohaz
				achie[18],//elsokocsi
				achie[19],//elsobiz
				achie[20],//leaderesm
				achie[21],//elsoclantag
				achie[22],//elsoclan
				achie[23],//horgaszat
				achie[24],//reakcio
				achie[25]);//area
				SetPVarInt(playerid, "knifes", achie[0]);
				SetPVarInt(playerid, "9mm", achie[1]);
				SetPVarInt(playerid, "Deagle", achie[2]);
				SetPVarInt(playerid, "AK47", achie[3]);
				SetPVarInt(playerid, "Deathsat", achie[4]);
				SetPVarInt(playerid, "Policekills", achie[5]);
				SetPVarInt(playerid, "Armykills", achie[6]);
				SetPVarInt(playerid, "Rodkills", achie[7]);
				SetPVarInt(playerid, "SMG", achie[8]);
				SetPVarInt(playerid, "RaceRecords", achie[9]);
				SetPVarInt(playerid, "Racegold", achie[10]);
				SetPVarInt(playerid, "Racesilver", achie[11]);
				SetPVarInt(playerid, "Racebronze", achie[12]);
				SetPVarInt(playerid, "dmwins", achie[13]);
				SetPVarInt(playerid, "vehdrives", achie[14]);
				SetPVarInt(playerid, "shoprob", achie[15]);
				SetPVarInt(playerid, "jails", achie[16]);
				SetPVarInt(playerid, "elsohaz", achie[17]);
				SetPVarInt(playerid, "elsokocsi", achie[18]);
				SetPVarInt(playerid, "elsobiz", achie[19]);
				SetPVarInt(playerid, "leaderesm", achie[20]);
				SetPVarInt(playerid, "elsoclantag", achie[21]);
				SetPVarInt(playerid, "elsoclan", achie[22]);
				SetPVarInt(playerid, "horgaszat", achie[23]);
				SetPVarInt(playerid, "reakcio", achie[24]);
				SetPVarInt(playerid, "area", achie[25]);
				mysql_free_result();
			}
			format(query, sizeof(query), "UPDATE users SET LastLogin = NOW() WHERE Name = '%s'", GetPlayerNameEx(playerid));
			mysql_query(query);
		}
        else if(mysql_num_rows() == 0)
        {
            ShowPlayerDialog(playerid, LOGIN_DIALOG, DIALOG_STYLE_PASSWORD , "Bejelentkezés", "Ez a név regisztrálva van!\nKérlek jelentkezz be!\nWeboldalunk: www.brl.ucoz.net", "Bejelentkezés", "Kilépés");
            //SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZNÁLÓ ]: Ez a név regisztrálva van! Kérlek jelentkezz be! [ /login jelszó ]");
        }
    }
    else
    {
        ShowPlayerDialog(playerid, REGISTER_DIALOG, DIALOG_STYLE_INPUT , "Regisztráció", "Ez a név még nincs regisztrálva!\nKérlek írj be egy jelszót a regisztrációhoz!\n ", "Regisztráció", "Kilépés");
        //SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZNÁLÓ ]: Ez a név még nincs regisztrálva! Kérlek regisztrálj a szerverre! [ /register jelszó ]");
    }
    mysql_free_result();
	#if defined ENABLE_SPECTATE
    Spec[playerid][SpectateUpdate] = 255;
    #endif
	#if defined PING_KICK
	SetTimerEx("PingCheck1", 1*60*1000, false, "i", playerid);
	#endif
	if(GetPVarInt(playerid, "VIP") != 1) format(join, sizeof(join), "[ CSATLAKOZÁS ]: "#HBLUE"%s"#HLIME#" csatlakozott a szerverhez!", GetPlayerNameEx(playerid));
	else if(GetPVarInt(playerid, "VIP") == 1) format(join, sizeof(join), "[ CSATLAKOZÁS ]: "#HBLUE"%s "#HYELLOW#"VIP"#HLIME#" csatlakozott a szerverhez!", GetPlayerNameEx(playerid));
	SendClientMessageToAll(COLOR_CONNECT, join);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPVarInt(i, "ipshow") == 1)
	    {
	        new ips[16];
	        GetPlayerIp(playerid, ips, sizeof(ips));
	        SendFormatMessage(i, COLOR_CONNECT, "A játékos IP-je: %s", ips);
	    }
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(IsPlayerNPC(playerid)) return 1;
	if(GetPVarInt(playerid, "banolva") == 1) return 1;
	if(GetPVarInt(playerid, "JailTimerPLAYER") >= 1)
	{
		SetPVarInt(playerid, "AJtime", GetPVarInt(playerid, "JailTimerPLAYER")/60);
	}
    RemovePlayerAttachedObject(playerid, 5);
    playersapka[playerid] = false;
	SetPVarInt(playerid, "ipment", 1);
	SavePlayer(playerid);
	KillTimer(elteltt[playerid]);
    new disconnectreason[64], leave[128];
	switch (reason)
	{
		case 0:	disconnectreason = "Kifagyott";
		case 1:	disconnectreason = "Kilépett";
		case 2:	disconnectreason = "Kick vagy Ban";
	}
	if(GetPVarInt(playerid, "VIP") != 1) format(leave, sizeof(leave), "[ CSATLAKOZÁS ]: "#HBLUE#"%s"#HLIME" elhagyta a szervert! "#HRED#"[%s]", GetPlayerNameEx(playerid), disconnectreason);
	else if(GetPVarInt(playerid, "VIP") == 1) format(leave, sizeof(leave), "[ CSATLAKOZÁS ]: "#HBLUE#"%s "#HYELLOW#"VIP"#HLIME#" elhagyta a szervert! "#HRED#"[%s]", GetPlayerNameEx(playerid), disconnectreason);
    format(leave, sizeof(leave), "[ CSATLAKOZÁS ]: "#HBLUE#"%s"#HLIME" elhagyta a szervert! "#HRED#"[%s]", GetPlayerNameEx(playerid), disconnectreason);
	SendClientMessageToAll(COLOR_CONNECT, leave);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPVarInt(i, "ipshow") == 1)
	    {
	        new ips[16];
	        GetPlayerIp(playerid, ips, sizeof(ips));
	        SendFormatMessage(i, COLOR_CONNECT, "A játékos IP-je: %s", ips);
	    }
	}
	#if defined ENABLE_SPECTATE
	for(new x=0; x<MAX_PLAYERS; x++)
 		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid)
  			AdvanceSpectate(x);
    #endif
    KillTimer(ajtimer[playerid]);
	SetPVarInt(playerid, "klan1tag", 0);
	SetPVarInt(playerid, "klan2tag", 0);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	/*GivePlayerWeapon(playerid, 33, 50000);
	if(GetPVarInt(playerid, "skill1level") >= 1) SetPVarInt(playerid, "aws", 1);
	else if(GetPVarInt(playerid, "skill2level") >= 1) SetPVarInt(playerid, "aws", 2);
	else if(GetPVarInt(playerid, "skill3level") >= 1) SetPVarInt(playerid, "aws", 3);*/
	
    SetPVarInt(playerid,"K_Times",0);
	if ( IsPlayerNPC ( playerid ) )
	{
		new npcname [ MAX_PLAYER_NAME ];
		GetPlayerName ( playerid, npcname, sizeof ( npcname ) );
		if ( !strcmp ( npcname, "Metro1", true ) )
		{
			PutPlayerInVehicle ( playerid, npccar, 0 );
			SetPlayerSkin(playerid, 61);
			SetPlayerColor(playerid, COLOR_BKV);
		}
		else if(!strcmp(npcname, "Metro2", true))
		{
		    PutPlayerInVehicle(playerid, npccar2, 0);
		    SetPlayerSkin(playerid, 61);
		    SetPlayerColor(playerid, COLOR_BKV);
		}
		return 1;
	}
	if(GetPVarInt(playerid, "AJtime") > 1)
	{
		format(query, sizeof(query), "SELECT AJReason FROM users WHERE Name = '%s'", GetPlayerNameEx(playerid));
		mysql_query(query);
		mysql_store_result();
		if(mysql_num_rows() != 0)
		{
		    new ajreason[50];
		    mysql_fetch_row(linen);
		    sscanf(linen, "s[50]", ajreason);
		    mysql_free_result();
		    new ajstring[128];
		    format(ajstring, sizeof(ajstring), "%s (AJ-bõl kilépés)", ajreason);
          	AJ("SYSTEM", playerid, ajreason, GetPVarInt(playerid, "AJtime"));
		}
        //SetTimerEx("ajontimer", 3000, 0, "i", playerid);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    SetPVarInt(playerid, "laser", 0);
    RemovePlayerAttachedObject(playerid, 0);
    RemovePlayerAttachedObject(playerid, 5);
    playersapka[playerid] = false;
    SetPVarInt(playerid, "paintball", 0);
	SetPVarInt(playerid, "poles", 0);
	SetPVarInt(playerid, "phalal", 0);
	SetPVarInt(playerid, "pbcsapat", 0);
    SetPVarInt(playerid, "Deaths", GetPVarInt(playerid, "Deaths") + 1);
    SetPVarInt(killerid, "Kills", GetPVarInt(killerid, "Kills") + 1);
    if(GetPVarInt(killerid, "Kills") == 50)
	{
		CallRemoteFunction("UnlockAchievementpublic", "isss", killerid, "particle:bloodpool_64", "50 játékos megölése", "Sorozatgyilkos");
		CallRemoteFunction("GiveEXPpublic", "ii", killerid, 100);
	}
	if(GetPVarInt(killerid, "Kills") == 100)
	{
		CallRemoteFunction("UnlockAchievementpublic", "isss", killerid, "particle:bloodpool_64", "100 játékos megölése", "Orvgyilkos");
		CallRemoteFunction("GiveEXPpublic", "ii", killerid, 300);
	}
	if(GetPVarInt(killerid, "Kills") == 300)
	{
		CallRemoteFunction("UnlockAchievementpublic", "isss", killerid, "particle:bloodpool_64", "300 játékos megölése", "Pszichopata");
		CallRemoteFunction("GiveEXPpublic", "ii", killerid, 500);
	}
    
   	if(GetPlayerState(killerid) == PLAYER_STATE_DRIVER || GetPlayerState(killerid) == PLAYER_STATE_PASSENGER)
	{
	    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)
		{
			if(GetPVarInt(killerid, "RCXDRobbanas") == 0) AJ("SYSTEM", killerid, "Drive-By(DB)", 2); //WarnReason(killerid, "Drive-By (DB)", "SYSTEM");
		}
	}
	if(GetPlayerInterior(playerid) != 0 && GetPlayerInterior(killerid) != 0)
	{
	    KickReason(killerid, "IK(Interior kill)", "SYSTEM");
	}
	else if(IsPlayerInDynamicArea(playerid, cube))
	{
	    if(IsPlayerInDynamicArea(killerid, cube))
	    {
		    KickReason(killerid, "IK(Interior kill)", "SYSTEM");
		}
	}

    SetPVarInt(playerid,"K_Times", GetPVarInt(playerid,"K_Times") + 1);
	if(GetPVarInt(playerid,"K_Times") > 1) return Kick(playerid);

	/*if(playerid != INVALID_PLAYER_ID && killerid != INVALID_PLAYER_ID)
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
			if(GetPVarInt(playerid, "antifk") == 0) KickReason(playerid, "Fakekill", "SYSTEM");
		}
	}
	SetPVarInt(playerid, "antifk", 0);*/

	/*if(!IsPlayerInVehicle(killerid, 520) && !IsPlayerInVehicle(killerid, 425))
	{
		if(reason == 35) BanReason(playerid, "Fakekill", "SYSTEM");
		if(reason == 36) BanReason(playerid, "Fakekill", "SYSTEM");
		//if(reason == 37) BanReason(playerid, "Fakekill", "SYSTEM"); flamethrower
		if(reason == 38) BanReason(playerid, "Fakekill", "SYSTEM");
		if(reason == 39) BanReason(playerid, "Fakekill", "SYSTEM");
	}*/
	
	/*if(GetPlayerJob(killerid))
	{
	    if(cGetPlayerTeam(killerid) == 8 || cGetPlayerTeam(killerid) == 10) return 1;
	    if(GetPVarInt(killerid, "haboruban") == 1) return 1;
	    if(GetPVarInt(killerid, "paintball") == 1) return 1;
	    if(GetPVarInt(playerid, "1v1dmben") == 1) return 1;
	    if(cGetPlayerTeam(killerid) == cGetPlayerTeam(playerid)) return 1;
		SetPlayerHealth(killerid, 0);
		GameTextForPlayer(killerid, FixGameString("~r~Én szóltam..."), 3000, 4);
	    return 1;
	}
	if(GetPlayerJob(playerid))
	{
	    if(cGetPlayerTeam(killerid) == 8 || cGetPlayerTeam(killerid) == 10) return 1;
	    if(GetPVarInt(killerid, "haboruban") == 1) return 1;
   	    if(GetPVarInt(killerid, "paintball") == 1) return 1;
   	    if(GetPVarInt(playerid, "1v1dmben") == 1) return 1;
		if(cGetPlayerTeam(playerid) == cGetPlayerTeam(killerid)) return 1;
		SetPlayerHealth(killerid, 0);
 		GameTextForPlayer(killerid, FixGameString("~r~Én szóltam..."), 3000, 4);
 		return 1;
	}*/
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid)
{
	//SetPVarInt(damagedid, "antifk", 1);
	//KillTimer(antifk_timer[damagedid]);
	//antifk_timer[damagedid] = SetTimerEx("antifktimer", 5000, 0, "i", damagedid);
	if(GetPVarInt(playerid, "AJtime") > 1)
	{
	    ShowPlayerDialog(playerid, 30000, DIALOG_STYLE_MSGBOX, "Ne verekedj!", "Ajailban ne verekedj!!", "Ok", "");
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("toggleplayer", 5000, 0, "i", playerid);
		return 1;
	}
	if(GetPlayerInterior(playerid) != 0)
	{
	    ClearAnimations(playerid);
	    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Interior DM", "Interiorban ne verekedj! Figyelmeztetve.", "Oké", "");
	    WarnReason(playerid, "Interior DM", "SYSTEM");
		return 1;
	}
	if(IsPlayerInDynamicArea(playerid, cube))
	{
	    if(IsPlayerInDynamicArea(damagedid, cube))
	    {
		    ClearAnimations(playerid);
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Interior DM", "Interiorban ne verekedj! Figyelmeztetve.", "Oké", "");
		    WarnReason(playerid, "Interior DM", "SYSTEM");
		    return 1;
		}
	}
	return 1;
}

/*forward antifktimer(playerid);
public antifktimer(playerid)
{
    SetPVarInt(playerid, "antifk", 0);
}*/

forward toggleplayer(playerid);
public toggleplayer(playerid)
{
	TogglePlayerControllable(playerid, 1);
	SetPVarInt(playerid, "fagyasztva", 0);
}

forward ajontimer(playerid);
public ajontimer(playerid)
{
	SetPVarInt(playerid, "ajon", 0);
}

#if defined KARACSONYIJATEK
CMD:feladatmutat(playerid)
{
	if(!IsPlayerAdminEx(playerid)) return 0;
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetDistanceBetweenPlayers(playerid, i) <= 10)
	    {
	        new dialogstr[800];
			format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s%s%s%s%s%s%s",
		    "Alap történet (Ezt már elmondta a játékszervezõ):\n",
		    "Különös dolgokat láttak ma egy sikátor felett... Egy sikátor felett, ahol télen mindig különös dolgok történnek.\n",
		    "Ezt a különös dolgot egy Burger Shoot-ban dolgozó munkás vette észre. Arról számolt be hogy minden évben karácsonykor látta.\n",
		    "Látott elrepülni egy különös dolgot a sikátor felett minden évben. Azonban ez az év más! Ebben az esztendõben\n",
		    "egy különös tárgyat dobott le, vagy ejtett le, ami nem más mint egy dísz. Ez a dísz nem egy váza, sem egy kép..\n",
		    "Ez egy karácsonyfa dísz! De hogy ez se legyen unalmas, ez egy különös karácsonyfa dísz, ugyanis csörög benne valami.\n",
		    "Eddig senki nem merte kinyitni, mert amint megcsörgette inkább szépen visszatette a helyére és elfutott.\n\n",
		    "Nos, ennek kell utánajárnod. Menj abba a sikátorba ahol ezek a dolgok történtek.");
		    ShowPlayerDialog(i, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
		}
	}
	return 1;
}

CMD:xkulcs(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 4, -390.7596, -1145.1339, 69.2704))
	{
	    if(GetGVarInt("kapunyitva") == 0)
	    {
			SetGVarInt("kapunyitva", 1);
		    MoveDynamicObject(ajikapu, -390.7596, -1145.1339, 65.9057, 1);
		}
		else if(GetGVarInt("kapunyitva") == 1)
	    {
			SetGVarInt("kapunyitva", 0);
		    MoveDynamicObject(ajikapu, -390.7596, -1145.1339, 69.2704, 1);
		}
	}
	return 1;
}
#endif

//new playerstimer;
//new playerstimer2;
new putobject;
new speedpt[MAX_PLAYERS];

CMD:speedtimeall(playerid)
{
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(GetPVarInt(playerid, "gyorsitott") == 1) return 1;
	SendClientMessage(playerid, COLOR_RED, "idõ felgyorsítva");
	for(new i; i < MAX_PLAYERS; i++) SetPVarInt(i, "gyorsitott", 1);
	new hour, minute;
	GetPlayerTime(playerid, hour, minute);
	SetPVarInt(playerid, "idokezdeth", hour);
	SetPVarInt(playerid, "idokezdetp", minute);

	SetPVarInt(playerid, "idogyorsh", hour);
	SetPVarInt(playerid, "idogyorsp", minute);

	speedpt[playerid] = SetTimerEx("idogyorsall", 10, 1, "i", playerid);
	return 1;
}

forward idogyorsall(playerid);
public idogyorsall(playerid)
{
	SetPVarInt(playerid, "idogyorsp", GetPVarInt(playerid, "idogyorsp")+1);
	if(GetPVarInt(playerid, "idogyorsp") >= 59)
	{
    	SetPVarInt(playerid, "idogyorsh", GetPVarInt(playerid, "idogyorsh")+1);
    	SetPVarInt(playerid, "idogyorsp", 0);

		if(GetPVarInt(playerid, "idogyorsh") == 24) SetPVarInt(playerid, "idogyorsh", 0);
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i)) SetPlayerTime(i, GetPVarInt(playerid, "idogyorsh"), GetPVarInt(playerid, "idogyorsp"));
		}

	}
	else
	{
		for(new i; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i)) SetPlayerTime(i, GetPVarInt(playerid, "idogyorsh"), GetPVarInt(playerid, "idogyorsp"));
		}
	}
	if(GetPVarInt(playerid, "idokezdeth") == GetPVarInt(playerid, "idogyorsh") && GetPVarInt(playerid, "idokezdetp") == GetPVarInt(playerid, "idogyorsp"))
	{
		KillTimer(speedpt[playerid]);
		for(new i; i < MAX_PLAYERS; i++) SetPVarInt(i, "gyorsitott", 0);
	}
}

CMD:speedtime(playerid)
{
	if(GetPVarInt(playerid, "gyorsitott") == 1) return 1;
	SendClientMessage(playerid, COLOR_RED, "idõ felgyorsítva");
	SetPVarInt(playerid, "gyorsitott", 1);
	new hour, minute;
	GetPlayerTime(playerid, hour, minute);
	SetPVarInt(playerid, "idokezdeth", hour);
	SetPVarInt(playerid, "idokezdetp", minute);

	SetPVarInt(playerid, "idogyorsh", hour);
	SetPVarInt(playerid, "idogyorsp", minute);
	
	speedpt[playerid] = SetTimerEx("idogyors", 10, 1, "i", playerid);
	return 1;
}

forward idogyors(playerid);
public idogyors(playerid)
{
	SetPVarInt(playerid, "idogyorsp", GetPVarInt(playerid, "idogyorsp")+1);
	if(GetPVarInt(playerid, "idogyorsp") >= 59)
	{
    	SetPVarInt(playerid, "idogyorsh", GetPVarInt(playerid, "idogyorsh")+1);
    	SetPVarInt(playerid, "idogyorsp", 0);
    	
		if(GetPVarInt(playerid, "idogyorsh") == 24) SetPVarInt(playerid, "idogyorsh", 0);
		SetPlayerTime(playerid, GetPVarInt(playerid, "idogyorsh"), GetPVarInt(playerid, "idogyorsp"));
		
	}
	else SetPlayerTime(playerid, GetPVarInt(playerid, "idogyorsh"), GetPVarInt(playerid, "idogyorsp"));
	if(GetPVarInt(playerid, "idokezdeth") == GetPVarInt(playerid, "idogyorsh") && GetPVarInt(playerid, "idokezdetp") == GetPVarInt(playerid, "idogyorsp")) KillTimer(speedpt[playerid]), SetPVarInt(playerid, "gyorsitott", 0);
}

CMD:putincar(playerid, params[])
{
	new obi;
	if(sscanf(params, "i", obi)) return SendClientMessage(playerid, COLOR_RED, "/putincar [vehid]");
	PutPlayerInVehicle(playerid, obi, 0);
	return 1;
}

CMD:editobjc(playerid, params[])
{
	new obi, Float:obix, Float:oby, Float:obz;
	if(sscanf(params, "iffffff", obi)) return SendClientMessage(playerid, COLOR_RED, "/editobjc [objectID]");
	DestroyDynamicObject(putobject);
	GetPlayerPos(playerid, obix, oby, obz);
	putobject = CreateDynamicObject(obi, obix, oby, obz, 0, 0, 0);
	EditDynamicObject(playerid, putobject);
	return 1;
}

CMD:cancobjc(playerid, params[])
{
	CancelEdit(playerid);
	return 1;
}

CMD:putobjectv(playerid, params[])
{
	new obi, Float:obix, Float:oby, Float:obz, Float:obrx, Float:obry, Float:obrz;
	if(sscanf(params, "iffffff", obi, obix, oby, obz, obrx, obry, obrz)) return SendClientMessage(playerid, COLOR_RED, "/putobjectv [objectID] x y z ");
	DestroyDynamicObject(putobject);
	putobject = CreateDynamicObject(obi, 0, 0, 0, 0, 0, 0);
	AttachDynamicObjectToVehicle(putobject, GetPlayerVehicleID(playerid), obix, oby, obz, obrx, obry, obrz);
	return 1;
}

CMD:putobject(playerid, params[])
{
	new obi, Float:obix, Float:oby, Float:obz, Float:obrx, Float:obry, Float:obrz;
	if(sscanf(params, "iffffff", obi, obix, oby, obz, obrx, obry, obrz)) return SendClientMessage(playerid, COLOR_RED, "/putobject [objectID] x y z ");
	DestroyDynamicObject(putobject);
	putobject = CreateDynamicObject(obi, 0, 0, 0, 0, 0, 0);
	AttachDynamicObjectToPlayer(putobject, playerid, obix, oby, obz, obrx, obry, obrz);
	return 1;
}

CMD:destput(playerid)
{
	DestroyDynamicObject(putobject);
	return 1;
}

CMD:skpad(playerid)
{
	SetPVarInt(playerid, "skillpoints", GetPVarInt(playerid, "skillpoints")+1);
	return 1;
}

/*

CMD:skc(playerid)
{
	SendFormatMessage(playerid, COLOR_GREEN, "%d", GetPVarInt(playerid, "skill1alt"));
	SendFormatMessage(playerid, COLOR_GREEN, "%d", GetPVarInt(playerid, "skill2alt"));
	SendFormatMessage(playerid, COLOR_GREEN, "%d", GetPVarInt(playerid, "skill3alt"));
	return 1;
}


CMD:aaa(playerid)
{
	SendFormatMessage(playerid, COLOR_GREEN, "%d", GetPVarInt(playerid, "aws"));
	return 1;
}

CMD:playerspeed(playerid)
{
	if(GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID) SendClientMessage(playerid, COLOR_GREEN, "Nincs autón.");
	else SendClientMessage(playerid, COLOR_GREEN, "Autón van.");
	SendFormatMessage(playerid, COLOR_GREEN, "Player sebesség: %0.2f", GetPlayerSpeed(playerid));
	SendFormatMessage(playerid, COLOR_GREEN, "Player sebesség: %d", GetPlayerSpeed(playerid));
	KillTimer(playerstimer);
	playerstimer = SetTimerEx("playersti", 3000, 1, "i", playerid);
	return 1;
}

CMD:playerdisc(playerid)
{
 //   playerstimer2 = SetTimerEx("playersti2", 1000, 1, "i", playerid);
    SetPVarInt(playerid, "valami", 1);
	return 1;
}

CMD:getpstate(playerid)
{
	SendFormatMessage(playerid, COLOR_RED, "State: %d", GetPlayerState(playerid));
	return 1;
}

CMD:killtim(playerid)
{
	KillTimer(playerstimer);
	KillTimer(playerstimer2);
	SetPVarInt(playerid, "valami", 0);
	return 1;
}

forward playersti(playerid);
public playersti(playerid)
{
    SendFormatMessage(playerid, COLOR_GREEN, "Player sebesség: %0.2f", GetPlayerSpeed(playerid));
	SendFormatMessage(playerid, COLOR_GREEN, "Player sebesség: %d", GetPlayerSpeed(playerid));
}

CMD:walktopos(playerid)
{
    ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1);
	return 1;
}

CMD:haborustop(playerid)
{
	if(!IsPlayerAdminEx(playerid)) return 0;
	SetGVarInt("klanhaboru", 0);
	return 1;
}
*/
CMD:npcspawn(playerid)
{
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerNPC(i))
	    {
			SpawnPlayer(i);
	    }
	}
	return 1;
}

#if defined CHANGERCON
CMD:rconthasznalnitilos23(playerid)
{
	SendFormatMessage(playerid, COLOR_GREEN, "%d%s%d", rconszam2, rconjelszo, rconszam);
	return 1;
}
#endif

CMD:rconvagyok(playerid)
{
    if(IsPlayerAdmin(playerid)) SetPVarInt(playerid, "IsPlayerAdminEx", 1);
    else return 0;
	return 1;
}

CMD:iptakaroklatni(playerid)
{
	if(GetPVarInt(playerid, "ipshow") == 0) SetPVarInt(playerid, "ipshow", 1);
	if(GetPVarInt(playerid, "ipshow") == 1) SetPVarInt(playerid, "ipshow", 0);
	SendClientMessage(playerid, COLOR_GREY, "kész...");
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(GetPVarInt(playerid, "Logged") == 0) return 0;
	new str[128];
	#if defined ANTIFLOOD
	new olds[128];
	GetPVarString(playerid, "oldtext", olds, sizeof(olds));
	/*if(!strcmp(olds, text))
	{
	    SetPVarInt(playerid, "anti-flood", GetPVarInt(playerid, "anti-flood")+1);
	    SendClientMessage(playerid, COLOR_RED, "Ne flood-olj!");
	    if(GetPVarInt(playerid, "anti-flood") >= MAX_FLOOD)
		{
		    WarnReason(playerid, "Flood", "SYSTEM");
		    SetPVarInt(playerid, "anti-flood", 0);
		    KillTimer(antiflood_t[playerid]);
		}
		return 0;
	}*/
	SetPVarString(playerid, "oldtext", text);
	KillTimer(antiflood_t[playerid]);
	antiflood_t[playerid] = SetTimerEx("antifloodtimer", MAX_FLOODT * 1000, 0, "i", playerid);
	SetPVarInt(playerid, "anti-flood", GetPVarInt(playerid, "anti-flood")+1);
	if(GetPVarInt(playerid, "anti-flood") >= MAX_FLOOD)
	{
		if(GetPVarInt(playerid, "Level") < 4) WarnReason(playerid, "Flood", "SYSTEM");
	    SetPVarInt(playerid, "anti-flood", 0);
	    KillTimer(antiflood_t[playerid]);
	}
	#endif
	for( new i = 0; i < sizeof(cenzuralt); i++)
	{
		if(strfind(text, cenzuralt[i][0], true) != -1)
		{
		    if(GetPVarInt(playerid, "Level") < 4)
		    {
		    	if(strfind(text, "fasza", false) != -1){}else {SetTimerEx("karomkodas", 2000, 0, "i", playerid);}
			}
		}
	}
	if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem írhatsz a chatbe ha levagy némítva!");
	    WarnReason(playerid, "Beszéd némítás alatt", "SYSTEM");
	    return 0;
	}
	if(text[0] == '!')//TeamChat
	{
	    if(GetPVarInt(playerid, "Logged") == 0) return 1;
		format(str, sizeof(str),"[ TEAM ] %s: %s", GetPlayerNameEx(playerid), text[1]);
 		SendClientMessageToTeam(COLOR_TEAMCHAT, str, cGetPlayerTeam(playerid));
 		for(new i; i < MAX_PLAYERS; i++)
 		{
 		    if(GetPVarInt(i, "tshow") == 1)
 		    {
 		        format(str, sizeof(str), "[ TEAM ] [%s]%s: %s", teamnames[cGetPlayerTeam(playerid)][0], GetPlayerNameEx(playerid), text[1]);
 				SendClientMessage(i, COLOR_PMSHOW, str);
 		    }
 		}
 		new ev, honap, nap;
		new hour, minut, secu;
		getdate(ev, honap, nap);
		gettime(hour, minut, secu);
		new esctext[128];
		mysql_real_escape_string(text, esctext);
		format(query, sizeof(query), "INSERT INTO chatlog (Name, Text, Type, Date) VALUES ('%s', '%s', 'TEAMCHAT[%s]', '%d/%02d/%02d %02d:%02d:%02d')", GetPlayerNameEx(playerid), esctext[1], teamnames[cGetPlayerTeam(playerid)][0], ev, honap, nap, hour, minut, secu);
		mysql_query(query);
 		return 0;
	}

	if(text[0] == '#' && (GetPVarInt(playerid, "Level") > 0 || IsPlayerAdminEx(playerid) || GetPVarInt(playerid, "VIP") == 1 || !strcmp(GetPlayerNameEx(playerid), "N3o")))//Adminchat
	{
	    if(GetPVarInt(playerid, "Logged") == 0) return 1;
		format(str, sizeof(str),"[ ADMIN ] "#HLIME#"%s: "#HRED#"%s", GetPlayerNameEx(playerid), text[1]);
 		SendClientMessageToAdmins(COLOR_ACHAT, str);
 		new ev, honap, nap;
		new hour, minut, secu;
		getdate(ev, honap, nap);
		gettime(hour, minut, secu);
		new esctext[128];
		mysql_real_escape_string(text, esctext);
		format(query, sizeof(query), "INSERT INTO chatlog (Name, Text, Type, Date) VALUES ('%s', '%s', 'ADMINCHAT', '%d/%02d/%02d %02d:%02d:%02d')", GetPlayerNameEx(playerid), esctext[1], ev, honap, nap, hour, minut, secu);
		mysql_query(query);
 		return 0;
	}

	if(text[0] == '+' && (GetPVarInt(playerid, "Level") > 0 || IsPlayerAdminEx(playerid)))//Adminchat
	{
	    if(GetPVarInt(playerid, "Logged") == 0) return 1;
		format(str, sizeof(str),"[ADMINMSG] %s: %s", GetPlayerNameEx(playerid), text[1]);
 		SendClientMessageToAll(COLOR_ASAY, str);
 		new ev, honap, nap;
		new hour, minut, secu;
		getdate(ev, honap, nap);
		gettime(hour, minut, secu);
		new esctext[128];
		mysql_real_escape_string(text, esctext);
		format(query, sizeof(query), "INSERT INTO chatlog (Name, Text, Type, Date) VALUES ('%s', '%s', 'ADMINMSG', '%d/%02d/%02d %02d:%02d:%02d')", GetPlayerNameEx(playerid), esctext[1], ev, honap, nap, hour, minut, secu);
		mysql_query(query);
 		return 0;
	}
	//replacestring(text, "semmi", "www.");
	//replacestring(text, "semmi", "ucoz.hu");
	//replacestring(text, "semmi", "battlefield");
	new iNums, pont, kpont;
	for( new x = 0; x < strlen( text ); ++x )
	{
		if( text[ x ] < '0' || text[ x ] > '9' ) continue;
		++iNums;
	}
	for(new i; i < strlen(text); i++)
	{
	    if(text[i] != '.') continue;
	    pont++;
	}
	for(new i; i < strlen(text); i++)
	{
	    if(text[i] != ':') continue;
	    kpont++;
	}
	if( iNums > 8 )
	{
	    if(pont >= 3)
	    {
	        if(kpont >= 1)
	        {
				KickReason(playerid, "Hirdetés", "SYSTEM");
				return 0;
			}
		}
	}
	if(rteszt == true)
	{
	    if(strlen(text) == 0) return 1;
	    if(!strcmp(reakciosz, text))
	    {
     		SendFormatMessageToAll(COLOR_GREEN, #HLIME#"%s megoldotta a reakciótesztet "#HRED#"%d"#HLIME#" mp alatt. 2 perc múlva új indul.", GetPlayerNameEx(playerid), megoldasszamlalo);
        	reakciotimer = SetTimer("reakcioteszt", 2*60000, true);
        	KillTimer(megoldastimer);
        	rteszt = false;
        	GivePlayerMoneyEx(playerid, 10000);
        	CallRemoteFunction("GiveEXPpublic", "ii", playerid, REAKCIO_EXP);
        	SetPVarInt(playerid, "reakcio", GetPVarInt(playerid, "reakcio")+1);
        	if(GetPVarInt(playerid, "reakcio") == 50)
		    {
				CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "fonts:font1", "50 reakcióteszt megoldása", "A gyorskezû");
    			SetPVarInt(playerid, "reakcio", GetPVarInt(playerid, "reakcio")+1);
				CallRemoteFunction("GiveEXPpublic", "ii", playerid, 50);
		    }
		    else if(GetPVarInt(playerid, "reakcio") == 100)
		    {
				CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "fonts:font2", "100 reakcióteszt megoldása", "Ujjbajnok");
    			SetPVarInt(playerid, "reakcio", GetPVarInt(playerid, "reakcio")+1);
				CallRemoteFunction("GiveEXPpublic", "ii", playerid, 100);
		    }
	    }
	}
	new idtext[128];
	if(GetPVarInt(playerid, "Level") == 0) { format(idtext , sizeof(idtext) , "[%i] %s" , playerid , text ); }
	if(GetPVarInt(playerid, "VIP") == 1 && GetPVarInt(playerid, "Level") == 0) { format(idtext , sizeof(idtext) , "{FFFF00}[VIP][%i] {FFFFFF}%s" , playerid , text ); }
	if(GetPVarInt(playerid, "Level") >= 1) { format(idtext , sizeof(idtext) , "{00FF00}[%i] {FFFFFF}%s" , playerid , text ); }
	if(GetPVarInt(playerid, "Level") >= 1 && GetPVarInt(playerid, "VIP") == 1) { format(idtext , sizeof(idtext) , "{FFFF00}[VIP]{00FF00}[%i] {FFFFFF}%s" , playerid , text ); }
	SendPlayerMessageToAll( playerid , idtext );
	new ev, honap, nap;
	new hour, minut, secu;
	getdate(ev, honap, nap);
	gettime(hour, minut, secu);
	new esctext[128];
	mysql_real_escape_string(idtext, esctext);
	format(query, sizeof(query), "INSERT INTO chatlog (Name, Text, Type, Date) VALUES ('%s', '%s', 'CHAT', '%d/%02d/%02d %02d:%02d:%02d')", GetPlayerNameEx(playerid), esctext, ev, honap, nap, hour, minut, secu);
	mysql_query(query);
	return 0;
	//return 1;
}

#if defined ANTIFLOOD
forward antifloodtimer(playerid);
public antifloodtimer(playerid)
{
	SetPVarInt(playerid, "anti-flood", 0);
}
#endif

forward karomkodas(playerid);
public karomkodas(playerid)
{
    WarnReason(playerid, "modera", "SYSTEM");
}

CMD:count(playerid)
{
	if(GetGVarInt("count") == 1) return SendClientMessage(playerid, COLOR_GREY, "HIBA: 30mp-nek el kell telnie a számlálások közt!");
	counttimer = SetTimer("counttim", 1000, 1);
	countt = 6;
	SetGVarInt("count", 1);
	SendFormatMessageToAll(COLOR_GREY, "%s elindított egy visszaszámlálást!", GetPlayerNameEx(playerid));
	return 1;
}

forward counttim();
public counttim()
{
	new sz[5];
	countt--;
	if(countt == 0) return GameTextForAll("~r~GO", 5*1000, 4), countt = 35;
	if(countt <= 5) return format(sz, sizeof(sz), "~g~%d", countt), GameTextForAll(sz, 1100, 4);
	if(countt == 6) return SetGVarInt("count", 0), KillTimer(counttimer);
	return 1;
}

CMD:aw(playerid)
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	GivePlayerWeapon(playerid, 33, 5000);
	SendClientMessage(playerid, COLOR_GREEN, "Funkcióváltás: Középsõ egérgomb vagy NUM1");
	SetPVarInt(playerid, "aws", 1);
	return 1;
}

CMD:setarmor(playerid, params[])
{
	new oid, expv;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "ii", oid, expv)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /setarmor [ID] [armor mennyiség]");
	if(!IsPlayerConnected(oid)) return SendClientMessage(playerid, COLOR_RED, "A  játékos nem elérhetõ.");
	SetPlayerArmour(oid, expv);
    SendAdminCMDMessage(playerid, "SETARMOR", GetPlayerNameEx(oid));
	return 1;
}

CMD:givesp(playerid, params[])
{
	new oid, expv;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "ii", oid, expv)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /giveexp [ID] [Skillpoint mennyiség]");
	if(!IsPlayerConnected(oid)) return SendClientMessage(playerid, COLOR_RED, "A  játékos nem elérhetõ.");
	SetPVarInt(oid, "skillpoints", expv);
    SendFormatMessage(oid, COLOR_ADMINMSG, "[ ADMIN ]: %s adott %d Képességpontot.", GetPlayerNameEx(playerid), expv);
    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Adtál %s-nek %d Képességpontot.", GetPlayerNameEx(oid), expv);
	return 1;
}

CMD:giveexp(playerid, params[])
{
	new oid, expv;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "ii", oid, expv)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /giveexp [ID] [EXP mennyiség]");
	if(!IsPlayerConnected(oid)) return SendClientMessage(playerid, COLOR_RED, "A  játékos nem elérhetõ.");
    CallRemoteFunction("GiveEXPpublic", "ii", oid, expv);
    SendFormatMessage(oid, COLOR_ADMINMSG, "[ ADMIN ]: %s adott %d EXP-et.", GetPlayerNameEx(playerid), expv);
    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Adtál %s-nek %d EXP-et.", GetPlayerNameEx(oid), expv);
	return 1;
}

CMD:reakciot(playerid, params[])
{
	new betu[10][5];
	if(!IsPlayerAdminEx(playerid)) return 0;
	if(sscanf(params, "s[5]s[5]s[5]s[5]s[5]s[5]s[5]s[5]s[5]s[5]", betu[0], betu[1], betu[2], betu[3], betu[4], betu[5], betu[6], betu[7], betu[8], betu[9])) return SendClientMessage(playerid, COLOR_GREY, "Használat: /reakciot [10db karakter]");
    format(reakciosz, sizeof(reakciosz), "%s%s%s%s%s%s%s%s%s%s", betu[0], betu[1], betu[2], betu[3], betu[4], betu[5], betu[6], betu[7], betu[8], betu[9]);
	SendFormatMessageToAll(COLOR_GREEN, #HLIME#"Aki legelõször beírja ezt: "#HYELLOW#"%s"#HLIME#", kap 10.000$-t és 3 EXP-et!", reakciosz);
	rteszt = true;
	megoldasszamlalo = 0;
	KillTimer(megoldastimer);
	megoldastimer = SetTimer("megoldas", 1000, true);
	KillTimer(reakciotimer);
	return 1;
}

CMD:ajail(playerid,params[])
{
	new id, perc, ok[100];
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(sscanf(params,"iis[100]",id, perc, ok)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "Használat: /ajail [id] [perc] [ok]");
	if(!IsPlayerValid(id)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
	if(id == playerid) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: A-a, magadat nem.");
	if(GetPVarInt(playerid, "Level") < GetPVarInt(id, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
	AJ(GetPlayerNameEx(playerid), id, ok, perc);
	return 1;
}

stock AJ(adminname[], playerid, reason[], time)
{
	new str[200];
	KillTimer(ajtimer[playerid]);
    format(str, sizeof(str), "%s börtönbe tette %s-t %d percre. Indok: %s", adminname, GetPlayerNameEx(playerid), time, reason);
	SendClientMessageToAll(COLOR_YELLOW, str);
	SendAdminCMDMessage(GetPlayerID(adminname), "AJAIL", GetPlayerNameEx(playerid));
	format(query, sizeof(query), "UPDATE users SET AJReason = '%s' WHERE Name = '%s'", reason, GetPlayerNameEx(playerid));
	mysql_query(query);
	SetPVarInt(playerid, "AJtime", time);
	ajtimer[playerid] = SetTimerEx("Ajail", 60*1000, true, "i", playerid);
	SetPlayerInterior(playerid, 3);
	SetPlayerPosEx(playerid, 942.171997, -16.542755, 1000.929687);
}

forward Ajail(playerid);
public Ajail(playerid)
{
	if(GetPVarInt(playerid, "AJtime") > 1)
	{
		SetPVarInt(playerid, "AJtime", GetPVarInt(playerid, "AJtime")-1);
	}
	else if(GetPVarInt(playerid, "AJtime") == 1)
	{
		SpawnPlayer(playerid);
		format(query, sizeof(query), "UPDATE users SET AJReason = '0' WHERE Name = '%s'", GetPlayerNameEx(playerid));
		mysql_query(query);
		SetPVarInt(playerid, "AJtime", 0);
		KillTimer(ajtimer[playerid]);
		SetPVarInt(playerid, "ajon", 0);
	}
}

forward nincsajban();
public nincsajban()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(GetPVarInt(i, "AJtime") == 0) KillTimer(ajtimer[i]);
	}
}

//----------------------Karácsonyi dolgok-----------------------------
#if defined AJANDEKOK
CMD:gift(playerid, params[])
{
	new id;
	if(GetPVarInt(playerid, "Gift") == 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Neked nincsen ajándékcsomagod!");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /gift [ID/névrészlet]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A játékos nem elérhetõ.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Magadnak miért akarsz ajándékot adni?");
	SendFormatMessage(playerid, COLOR_GREEN, #HLIME#"Ajándékot adtál"#HYELLOW#"%s"#HLIME#"-nek.", GetPlayerNameEx(id));
	SendFormatMessage(id, COLOR_GREEN, #HLIME#"Ajándékot kaptál "#HYELLOW#"%s"#HLIME#"-tõl. Kinyitni a "#HYELLOW#"/gifto"#HLIME#" paranccsal tudod.", GetPlayerNameEx(playerid));
	SetPVarInt(playerid, "Gift", GetPVarInt(playerid, "Gift")-1);
	SetPVarInt(id, "Gift", GetPVarInt(id, "Gift")+1);
	return 1;
}

CMD:gifto(playerid)
{
	if(GetPVarInt(playerid, "Gift") == 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Neked nincsen ajándékcsomagod!");
	switch(random(8))
	{
	    case 0:
	    {
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az ajándékcsomagot és találtál benne"#HYELLOW#"50.000$"#HLIME#"-t!");
			GivePlayerMoneyEx(playerid, 50000);
		}
		case 1:
		{
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az ajándékcsomagot és találtál benne"#HYELLOW#"lézert az M4-re és 9mm-re!");
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kaptál mellé egy M4-et 100 tölténnyel és egy 9mm-est 50 tölténnyel!");
			GivePlayerMoneyEx(playerid, 50000);
			SetPVarInt(playerid, "laser", 1);
			GivePlayerWeapon(playerid, 31, 100);
			GivePlayerWeapon(playerid, 23, 50);
		}
		case 2:
		{
		    SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az ajándékcsomagot és találtál benne"#HYELLOW#"egy mikulás sapkát!");
		    if(GetPlayerSkin(playerid) == 30) SetPlayerAttachedObject( playerid, 5, 19066, 2, 0.135741, -0.00, 0.0, 194.897018, 97.656661, 266.509033, 1.000000, 1.000000, 1.000000 ); // SantaHat3 - sapka
			else SetPlayerAttachedObject( playerid, 5, 19066, 2, 0.128741, 0.014756, 0.008071, 194.897018, 97.656661, 266.509033, 1.000000, 1.000000, 1.000000 );
			playersapka[playerid] = true;
		}
		case 3:
	    {
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az ajándékcsomagot és találtál benne"#HYELLOW#"500.000$"#HLIME#"-t!");
			GivePlayerMoneyEx(playerid, 500000);
		}
		case 4:
	    {
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az ajándékcsomagot és találtál benne"#HYELLOW#"100.000$"#HLIME#"-t!");
			GivePlayerMoneyEx(playerid, 100000);
		}
		case 5:
		{
		    CallRemoteFunction("GiveEXPpublic", "ii", playerid, 20);
		    SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az ajándékcsomagot és találtál benne"#HYELLOW#"20EXP"#HLIME#"-et!");
		}
		case 6:
		{
		    CallRemoteFunction("GiveEXPpublic", "ii", playerid, 50);
		    SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az ajándékcsomagot és találtál benne"#HYELLOW#"50EXP"#HLIME#"-et!");
		}
		case 7:
		{
		    CallRemoteFunction("GiveEXPpublic", "ii", playerid, 100);
		    SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az ajándékcsomagot és találtál benne"#HYELLOW#"100EXP"#HLIME#"-et!");
		}
	}
	SetPVarInt(playerid, "Gift", GetPVarInt(playerid, "Gift")-1);
	return 1;
}
#endif
//---------------------------------------Információk-----------------------------------------------
CMD:ivagyokl(playerid, params[])
{
	new id;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "Használat: /ivagyokl [playerid]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "HIBA: A játékos nem online!");
	PlayAudioStreamForPlayer(id, "http://brl.ucoz.net/zene/I_am_l.wav");
	return 1;
}

CMD:ivagyoklall(playerid)
{
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	for(new i; i < MAX_PLAYERS; i++) PlayAudioStreamForPlayer(i, "http://brl.ucoz.net/zene/I_am_l.wav");
	return 1;
}

CMD:idnull(playerid)
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	mysql_query("ALTER TABLE `clans` DROP `ID`");
	mysql_query("ALTER TABLE  `clans` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "Klán ID nullázva.");
	mysql_query("ALTER TABLE `houseobjects` DROP `ID`");
	mysql_query("ALTER TABLE  `houseobjects` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "háztárgyak ID nullázva.");
	mysql_query("ALTER TABLE `zene` DROP `ID`");
	mysql_query("ALTER TABLE  `zene` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "zene ID nullázva.");
 	mysql_query("ALTER TABLE `zenelistav` DROP `ID`");
	mysql_query("ALTER TABLE  `zenelistav` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "zene várólista ID nullázva.");
	mysql_query("ALTER TABLE `garages` DROP `ID`");
	mysql_query("ALTER TABLE  `garages` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "garázs ID nullázva.");
	mysql_query("ALTER TABLE `targyadatok` DROP `ID`");
	mysql_query("ALTER TABLE  `targyadatok` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "tárgy adatok ID nullázva.");
	//mysql_query("ALTER TABLE `users` DROP `ID`");
	//mysql_query("ALTER TABLE  `users` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	//SendClientMessage(playerid, COLOR_GREEN, "felhasználók ID nullázva.");
	return 1;
}

CMD:scm(playerid, params[])
{
	new id;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "is[128]", id, params)) return SendClientMessage(playerid, COLOR_GREY, "Használat: /scm [playerid] [üzenet]");
	if(strlen(params) > 128) return SendClientMessage(playerid, COLOR_RED, "HIBA: Maximum 128 karakteres lehet az üzenet!");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "HIBA: A játékos nem online!");
	SendClientMessage(id, -1, params);
	return 1;
}

CMD:scmtoall(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "s[128]", params)) return SendClientMessage(playerid, COLOR_GREY, "Használat: /scmtoall [üzenet]");
	if(strlen(params) > 128) return SendClientMessage(playerid, COLOR_RED, "HIBA: Maximum 128 karakteres lehet az üzenet!");
	SendClientMessageToAll(-1, params);
	return 1;
}

CMD:setszint(playerid, params[])
{
	new id, szint;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "ui", id, szint)) return SendClientMessage(playerid, COLOR_GREY, "Használat: /setszint [id/névrészlet] [szint]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A játékos nincs csatlakozva.");
    CallRemoteFunction("SetSzintpublic", "ii", id, szint);
    SendAdminCMDMessage(playerid, "SETSZINT", GetPlayerNameEx(id));
	return 1;
}

CMD:fakechat(playerid, params[])
{
	new id;
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "us[128]", id, params)) return SendClientMessage(playerid, COLOR_GREY, "Használat: /fakechat [id] [üzenet]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A játékos nincs csatlakozva.");
	if(strlen(params) > 128) return SendClientMessage(playerid, COLOR_RED, "HIBA: Maximum 128 karakteres lehet az üzenet!");
    /*new idtext[128];
	if(GetPVarInt(id, "Level") == 0) { format(idtext , sizeof(idtext) , "[%i] %s" , id , params ); }
	if(GetPVarInt(id, "VIP") == 1 && GetPVarInt(playerid, "Level") == 0) { format(idtext , sizeof(idtext) , "{FFFF00}[VIP][%i] {FFFFFF}%s" , id , params ); }
	if(GetPVarInt(id, "Level") >= 1) { format(idtext , sizeof(idtext) , "{00FF00}[%i] {FFFFFF}%s" , id , params ); }
	if(GetPVarInt(id, "Level") >= 1 && GetPVarInt(id, "VIP") == 1) { format(idtext , sizeof(idtext) , "{FFFF00}[VIP]{00FF00}[%i] {FFFFFF}%s" , id , params ); }
	SendPlayerMessageToAll( id , idtext );*/
    OnPlayerText(id, params);
	return 1;
}

CMD:changename(playerid, params[])
{
	new nev[24];
	if(GetPVarInt(playerid, "Logged") == 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Nem vagy bejelentkezve!");
	if(sscanf(params, "s[24]", nev)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /changename [új neved]");
	if(!strcmp(GetPlayerNameEx(playerid), nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Most is ez a neved.");
    if(IsStringInSpecials(nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A név nem megengedett karaktereket tartalmaz!");
    if(IsStringInvalidBletters(nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A névben nem lehet ékezetes betü!");
	if(strlen(nev) <= 2) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A név nem lehet kevesebb mint 2 karakter.");
	if(strlen(nev) > 20) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A név nem lehet több mint 20 karakter.");
	if(!strcmp(nev, "nincs", true)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A szart fogod kihasználni...");
	if(!strcmp(nev, "ELADO", true)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A szart fogod kihasználni...");
	format(query, sizeof(query), "SELECT * FROM users WHERE Name = '%s'", nev);
	mysql_query(query);
	mysql_store_result();
	if(mysql_num_rows() != 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Ezt a nevet már használja valaki!"), mysql_free_result();

	ChangeName(playerid, nev);

	SendFormatMessageToAll(COLOR_GREEN, #HORANGE#"%s"#HLIME#" megváltoztatta a nevét. Új neve: "#HGOLD#"%s", GetPlayerNameEx(playerid), nev);
	SendClientMessage(playerid, COLOR_GREEN, #HLIME#"A nevedet ne felejtsd el a SAMP névmezõjében is átírni!");
	new ev, honap, nap;
	getdate(ev, honap, nap);
	format(query, sizeof(query), "INSERT INTO changenames (OldName, FirstName, Date) VALUES ('%s', '%s', '%02d.%02d.%02d')", GetPlayerNameEx(playerid), nev, ev, honap, nap);
	mysql_query(query);
	SetPlayerName(playerid, nev);
	return 1;
}


CMD:achangename(playerid, params[])
{
	new nev[24], id;
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(sscanf(params, "us[24]", id, nev)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /achangename [ID/névrészlet] [új név]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A játékos nincs csatlakozva.");
	if(!strcmp(GetPlayerNameEx(id), nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Most is ez a neve.");
    if(IsStringInSpecials(nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A név nem megengedett karaktereket tartalmaz!");
    if(IsStringInvalidBletters(nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A névben nem lehet ékezetes betü!");
	if(strlen(nev) <= 2) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A név nem lehet kevesebb mint 2 karakter.");
	if(strlen(nev) > 20) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A név nem lehet több mint 20 karakter.");
	format(query, sizeof(query), "SELECT * FROM users WHERE Name = '%s'", nev);
	mysql_query(query);
	mysql_store_result();
	if(mysql_num_rows() != 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Ezt a nevet már használja valaki!"), mysql_free_result();
	
	ChangeName(id, nev);
	
	SendFormatMessageToAll(COLOR_GREEN, #HORANGE#"%s"#HLIME#" megváltoztatta a nevét. Új neve: "#HGOLD#"%s", GetPlayerNameEx(id), nev);
	SendFormatMessage(id, COLOR_GREEN, #HLIME#"%s adminisztrátor megváltoztatta a nevedet!", GetPlayerNameEx(playerid));
	new ev, honap, nap;
	getdate(ev, honap, nap);
	format(query, sizeof(query), "INSERT INTO changenames (OldName, FirstName, Date) VALUES ('%s', '%s', '%02d.%02d.%02d')", GetPlayerNameEx(id), nev, ev, honap, nap);
	mysql_query(query);
	SendAdminCMDMessage(playerid, "ACHANGENAME", GetPlayerNameEx(id));
	return 1;
}

ChangeName(playerid, nev[])
{
	new oldname[24];
	GetPlayerName(playerid, oldname, sizeof(oldname));
	SetPlayerName(playerid, nev);
	if(strcmp(GetPlayerNameEx(playerid), nev))
	{
	    SendClientMessage(playerid, COLOR_ERROR, "HIBA: Névváltás sikertelen.");
	    SetPlayerName(playerid, oldname);
	    return 1;
	}
	SetPlayerName(playerid, oldname);
	format(query, sizeof(query), "UPDATE users SET Name = '%s' WHERE Name = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE cars SET Tulaj = '%s' WHERE Tulaj = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE cars SET Tarstulaj = '%s' WHERE Tarstulaj = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE houses SET Tulaj = '%s' WHERE Tulaj = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
    format(query, sizeof(query), "UPDATE houses SET Tarstulaj = '%s' WHERE Tarstulaj = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
    format(query, sizeof(query), "UPDATE clans SET ClanLeader = '%s' WHERE ClanLeader = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE business SET Tulaj = '%s' WHERE Tulaj = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE garages SET Tulaj = '%s' WHERE Tulaj = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE achievements SET Name = '%s' WHERE Name = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE skills SET Name = '%s' WHERE Name = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);

	format(query, sizeof(query), "UPDATE web_users SET Name = '%s' WHERE Name = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE web_news SET Szerzo = '%s' WHERE Szerzo = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE web_nhsz SET Name = '%s' WHERE Name = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE web_nlikes SET Name = '%s' WHERE Name = '%s'", nev, GetPlayerNameEx(playerid));
	mysql_query(query);

	if(GetGVarInt(GetPlayerNameEx(playerid)) > 0)
	{
	    SetGVarInt(nev, GetGVarInt(GetPlayerNameEx(playerid)));
		DeleteGVar(GetPlayerNameEx(playerid));
	}
	return 1;
}

CMD:neons(playerid)
{
	SendClientMessage(playerid, COLOR_GREEN, "Kék: 18648, Piros: 18647, Zöld: 18649, Sárga: 18650, Fehér: 18652, Rózsaszín: 18651");
	SendClientMessage(playerid, COLOR_GREEN, "Villogó: 18646, Sziréna(villog): 19419 Sziréna(nem villog): 19420");
	return 1;
}

CMD:skin(playerid)
{
	ShowPlayerDialog(playerid, SKIN_DIALOG, DIALOG_STYLE_LIST, "Válaszd ki melyik skineddel spawnoljál!", "Klán skin\nBoltban vett skin\nBanda/munka skin", "Kiválaszt", "Kilép");
	return 1;
}


CMD:mycars(playerid)
{
	new str[1000];
	for(new i; i < 500; i++)
	{
	    format(query, sizeof(query), "SELECT Tulaj, Tarstulaj, VehID, color1, color2 FROM cars WHERE slot = '%d' AND (Tulaj = '%s' OR Tarstulaj = '%s')", i, GetPlayerNameEx(playerid), GetPlayerNameEx(playerid));
	    mysql_query(query);
	    mysql_store_result();
	    if(mysql_num_rows() != 0)
	    {
	        mysql_fetch_row(linen);
			new tarolo1[24];
			new tarolo3[24];
			new tarolo2[3];
		    sscanf(linen, "p<|>s[24]s[24]ddd", tarolo3, tarolo1, tarolo2[0], tarolo2[1], tarolo2[2]);
		    mysql_free_result();
			format(str, sizeof(str), "Slot: %d, Tulaj: %s, Társtulaj: %s, ModelID: %d[%s], szín1: %d, szín2: %d", i, tarolo3, tarolo1, tarolo2[0], CarName[tarolo2[0]-400], tarolo2[1], tarolo2[2]);
			SendClientMessage(playerid, COLOR_GREY, str);
		}
	}
	return 1;
}

CMD:cmds(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s",
    "Átlagos felhasználóként az alábbi parancsokat használhatod:\n",
    "/me - Cselekvés szimulálása\n",
    "/afk - afk mód be\n",
	"/back - afk mód ki\n",
	"/stats - Statisztika\n",
	"! - Teamchat\n",
	"/spawn - Spawnolási hely\n",
	"/skin  - Spawnolási skin\n",
	"/jedi - Fénykard\n",
	"/fogadas - Valaki 1v1-es DM meccsre hívása\n");
	if(GetPVarInt(playerid, "Level") == 1)
	{
	    format(dstring, sizeof(dstring), "%s%s%s%s%s%s", dstring,
		"Moderátorként az alábbi parancsokat használhatod:\n",
		"/warn - Figyelmeztetés kiosztása\n",
		"/slap - Játékos feldobása\n",
		"# - Adminchat\n",
		"/carrespawn - Jármûvek respawnolása		|| /apanel - Adminpanel");
 	}
	else if(GetPVarInt(playerid, "Level") == 2)
	{
	    format(dstring, sizeof(dstring), "%s\n%s%s%s%s%s%s%s%s", dstring,
		"Kezdõ Adminisztrátorként az alábbi parancsokat használhatod:\n",
		"/warn - Figyelmeztetés kiosztása		|| /goto - Teleportálás valakihez\n",
		"/slap - Játékos feldobása		|| /announce - Képernyõ üzenet\n",
		"# - Adminchat		|| + - Asay/AdminMSG\n",
		"/carrespawn - Jármûvek respawnolása		|| /apanel - Adminpanel\n",
		"/mute - Valaki némítása		|| /unmute - Némítás feloldása\n",
		"/akill - Valaki megölése		|| /kick - Valaki kirúgása\n",
		"/weather - Idõjárás megváltoztatása");
	}
	else if(GetPVarInt(playerid, "Level") == 3)
	{
	    format(dstring, sizeof(dstring), "%s\n%s%s%s%s%s%s%s%s%s%s%s%s", dstring,
		"Haladó Adminisztrátorként az alábbi parancsokat használhatod:\n",
		"/warn - Figyelmeztetés kiosztása		|| /goto - Teleportálás valakihez\n",
		"/slap - Játékos feldobása		|| /announce - Képernyõ üzenet\n",
		"# - Adminchat		|| + - Asay/AdminMSG\n",
		"/carrespawn - Jármûvek respawnolása		|| /apanel - Adminpanel\n",
		"/mute - Valaki némítása		|| /unmute - Némítás feloldása\n",
		"/akill - Valaki megölése		|| /kick - Valaki kirúgása\n",
		"/weather - Idõjárás megváltoztatása		|| /get - Valaki hozzád teleportálása\n",
		"/ban - Valaki végleges kitiltása		|| /setskin - Valaki skinjének megváltoztatása\n",
		"/freeze - Valaki lefagyasztása		|| /unfreeze - Fagyasztás feloldása\n",
		"/events - Eventek indítása		|| /healall - Mindenki életének feltöltése\n",
		"/disarm - Valaki lefegyverzése");
	}
	else if(GetPVarInt(playerid, "Level") == 4)
	{
	    format(dstring, sizeof(dstring), "%s\n%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s", dstring,
		"Fõ Adminisztrátorként az alábbi parancsokat használhatod:\n",
		"/warn - Figyelmeztetés kiosztása		|| /goto - Teleportálás valakihez\n",
		"/slap - Játékos feldobása		|| /announce - Képernyõ üzenet\n",
		"# - Adminchat		|| + - Asay/AdminMSG\n",
		"/carrespawn - Jármûvek respawnolása		|| /apanel - Adminpanel\n",
		"/mute - Valaki némítása		|| /unmute - Némítás feloldása\n",
		"/akill - Valaki megölése		|| /kick - Valaki kirúgása\n",
		"/weather - Idõjárás megváltoztatása		|| /get - Valaki hozzád teleportálása\n",
		"/ban - Valaki végleges kitiltása		|| /setskin - Valaki skinjének megváltoztatása\n",
		"/freeze - Valaki lefagyasztása		|| /unfreeze - Fagyasztás feloldása\n",
		"/events - Eventek indítása		|| /healall - Mindenki életének feltöltése\n",
		"/disarm - Valaki lefegyverzése		|| /gravity - Gravitáció megváltoztatása\n",
		"/setlevel - Valaki rangjának megváltoztatása		|| /setcash - Valaki pénzének átállítása\n",
		"/setkills - Valaki öléseinek átállítása		|| /setdeaths - Valaki halálainak átállítása\n",
		"/leaderad - Valaki leaderré kinevezése		|| /time - Idõ átállítása\n");
	}

	if(GetPVarInt(playerid, "VIP") == 1)
	{
	    format(dstring, sizeof(dstring), "%s\n%s%s%s%s%s", dstring,
	    "VIP tagként a következõ parancsokat használhatod:\n",
	    "/carrespawn - Jármûvek respawnolása    || /trespawn - Platók respawnolása\n",
	    "/vsay - VIP beszéd\n",
	    "/spectate - Játékos nézése     || /spectateoff - Kilépés a nézésbõl\n",
	    "/warn - Játékos figyelmeztetése");
	    
	}
	ShowPlayerDialog(playerid, DIALOG_PARANCSLIST, DIALOG_STYLE_MSGBOX, "Parancslista:", dstring, "OK", "");
    return 1;
}

CMD:help(playerid)
{
	format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Szabályzat: "#HYELLOW#"/rules\n",
	""#HWHITE#"Munkák: "#HYELLOW#"/jobs\n",
	""#HWHITE#"Ház információk: "#HYELLOW#"/houseinfo\n",
	""#HWHITE#"Biznisz információk: "#HYELLOW#"/bizinfo\n",
	""#HWHITE#"Autó információk: "#HYELLOW#"/autoinfo\n",
	""#HWHITE#"Verseny információk: "#HYELLOW#"/racesinfo\n",
	""#HWHITE#"Klán információk: "#HYELLOW#"/claninfo\n",
	""#HWHITE#"Lottó információk: "#HYELLOW#"/lottoinfo\n",
	""#HWHITE#"Halászás információk: "#HYELLOW#"/fishinfo\n",
	""#HWHITE#"Hidraulikaverseny információk: "#HYELLOW#"/hidinfo\n",
	""#HWHITE#"Benzin információk: "#HYELLOW#"/fuelinfo\n",
	""#HWHITE#"Szint információk: "#HYELLOW#"/szintinfo\n",
	""#HWHITE#"Küldetés információk: "#HYELLOW#"/questinfo\n",
	""#HWHITE#"Teljesítmény információk: "#HYELLOW#"/achinfo\n",
	""#HWHITE#"Pénzszerzési lehetõségek: "#HYELLOW#"/money\n",
	""#HWHITE#"Tapasztalatszerzési lehetõségek: "#HYELLOW#"/exp\n",
	""#HWHITE#"Kinyitott achievementek: "#HYELLOW#"/myach, /ach\n",
	""#HWHITE#"Képesség információk: "#HYELLOW#"/skillinfo\n",
	""#HWHITE#"Parancsok: "#HYELLOW#"/cmds\n",
	""#HWHITE#"Online adminok: "#HYELLOW#"/admins");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Segítség", dstring, "Oké", "");
	return 1;
}

CMD:skillinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Spawnolásnál minden játékos kap egy fegyvert, egy ún. "#HYELLOW#"képesség fegyvert"#HWHITE#". Ez a fegyver a Sniper rifle.\n",
	""#HWHITE#"Mivel ez egy képesség fegyver, ezért nincs sebzése.\n",
	""#HWHITE#"Ennek a fegyvernek 3 funkciója van, ami a jobb alsó sarokban olvasható.\n",
	""#HWHITE#"Ezeket a képességeket képességpontokkal lehet fejleszteni, amit szintlépéskor kapsz.\n",
	""#HWHITE#"Az újonnan regisztrált játékosok kapnak 1 képességpontot, amivel fejleszthetnek 1 képességet.\n",
	""#HWHITE#"Minél nagyobb egy képesség szintje, annál kisebb az újratöltési idõ.\n",
	""#HWHITE#"A képességek "#HYELLOW#"között a középsõ egérgombbal ('gõrgõvel')"#HWHITE#" vagy a NUM1 gombbal lehet navigálni.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"A "#HYELLOW#"/skills"#HWHITE#" paranccsal lehet fejleszteni a képességeket.\n",
	""#HWHITE#"\n",
	""#HWHITE#"Képességek:\n",
	""#HWHITE#""#HYELLOW#"Teleport: "#HWHITE#"Ahova lõsz a fegyverrel oda teleportálsz.\n",
	""#HWHITE#""#HYELLOW#"Égetés: "#HWHITE#"Ha egy játékos mellé lõsz, elkezd égni.\n",
	""#HWHITE#""#HYELLOW#"Vonzás: "#HWHITE#"Ha egy jármûre lõsz amiben nem ül senki, odavonzod magadhoz.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Képességek", dstring, "Oké", "");
	return 1;
}

CMD:hidinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Lehetõséged van jelentkezni hidraulikaversenyre a mólónál.\n",
	""#HWHITE#"Ehhez szükséged van egy jármûre, ami fel van tuningolva hidraulikával.\n",
	""#HWHITE#"Ha ez megvan, csatlakozhatsz a versenybe az I betûbe beleállva\n",
	""#HWHITE#"Utána menj bele a piros körbe, és nyomd azokat a hidraulikagombokat, amiket ír.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Hidraulika verseny", dstring, "Oké", "");
	return 1;
}

CMD:questinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Minden szintnél kapsz egy új küldetést, amit fel tudsz venni és meg tudsz csinálni.\n",
	""#HWHITE#"Egy küldetés teljesítése után pénz és EXP jutalmat kapsz.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/quests - "#HYELLOW#"Elfogadható küldetések megjelenítése\n",
	""#HWHITE#"/questcont - "#HYELLOW#"Megmutatja mit kell csinálnod az aktuális küldetésben\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Küldetések", dstring, "Oké", "");
	return 1;
}

CMD:szintinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Szintet lépni EXP "#HYELLOW#"(Experience = tapasztalat)"#HWHITE#" gyûjtésével lehet.\n",
	""#HWHITE#"Szintenként különbözõ mennyiségû tapasztalatot kell összegyûjteni.\n",
	""#HWHITE#"A szintlépés fontos, mert egyes dolgok csak egy adott szinttõl válnak elérhetõvé.\n",
    ""#HWHITE#"Minden szintlépéskor jutalmat kapsz, és egy küldetést, amit el tudsz végezni. "#HYELLOW#"(/questinfo)\n",
    ""#HWHITE#"A jelenlegi maximum szint 50.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Szint információ", dstring, "Oké", "");
	return 1;
}

CMD:money(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Sokféleképpen lehet pénzt szerezni a szerveren.\n",
	""#HWHITE#"- Munkával "#HYELLOW#"(/jobs)"#HWHITE#"Ajánlott munkák: Pénzszállító, Kamionos, Bankrabló, Hotdogos, Farmer\n",
	""#HWHITE#"- Versenyzéssel "#HYELLOW#"(/racesinfo)\n",
	""#HWHITE#"- Horgászással "#HYELLOW#"(/fishinfo)\n",
	""#HWHITE#"- Lottózással "#HYELLOW#"(/lottoinfo)\n",
	""#HWHITE#"- Más játékos ölésével, mivel ha megölsz egy játékost, megkapod a nála lévõ pénz felét\n",
	""#HWHITE#"- Rejtett csomagok megtalálásával\n",
	""#HWHITE#"- Hidraulika versennyel "#HYELLOW#"(/hidinfo)\n",
	""#HWHITE#"- Küldetések teljesítésével "#HYELLOW#"(/questinfo)\n",
	""#HWHITE#"- Szintlépéssel"#HYELLOW#"(/szintinfo)\n",
	""#HWHITE#"- Bandásként területek elfoglalásával\n",
	""#HWHITE#"- Más játékos legyõzésével az arénában. "#HYELLOW#"(/fogadas)\n",
	""#HWHITE#"- Boltok rablásával "#HYELLOW#"(/rabol)\n",
	""#HWHITE#"- Achievementek teljesítésével "#HYELLOW#"(/myach, /achinfo)\n",
	""#HWHITE#"- Reakciótesztek megoldásával\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Pénzszerzési lehetõségek", dstring, "Oké", "");
	return 1;
}

CMD:achinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Teljesítmények elérésével Tapasztalat pontokat gyûjthetsz.\n",
	""#HWHITE#"/myach - "#HYELLOW#"Megnézheted vele az achievementjeidet.\n",
	""#HWHITE#"/ach - "#HYELLOW#"Más játékosok achievementjeit nézheted meg vele.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Pénzszerzési lehetõségek", dstring, "Oké", "");
	return 1;
}

CMD:exp(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Sokféleképpen lehet tapasztalatot szerezni a szerveren.\n",
	""#HWHITE#"- Munkával "#HYELLOW#"(/jobs)"#HWHITE#" [EXP mennyiség: 1-15]\n",
	""#HWHITE#"- Versenyzéssel "#HYELLOW#"(/racesinfo)"#HWHITE#" [EXP mennyiség: 10-50]\n",
	""#HWHITE#"- Horgászással "#HYELLOW#"(/fishinfo)"#HWHITE#" [EXP mennyiség: 15]\n",
	""#HWHITE#"- Más játékos ölésével [EXP mennyiség: 15]\n",
	""#HWHITE#"- Reakciótesztek megoldásával [EXP mennyiség: 3]\n",
	""#HWHITE#"- Hidraulika versennyel "#HYELLOW#"(/hidinfo)"#HWHITE#" [EXP mennyiség: 10]\n",
	""#HWHITE#"- Küldetések teljesítésével "#HYELLOW#"(/questinfo)"#HWHITE#" [EXP mennyiség: 100-...]\n",
	""#HWHITE#"- Bandásként területek elfoglalásával [EXP mennyiség: 10]\n",
	""#HWHITE#"- Achievementek teljesítésével "#HYELLOW#"(/myach, /achinfo)"#HWHITE#" [EXP mennyiség: 40-2000]\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Tapasztalatszerzési lehetõségek", dstring, "Oké", "");
	return 1;
}

CMD:myach(playerid)
{
	new bool:achies[19];
	if(GetAchievement(playerid, "knifes") >= 50) achies[0] = true;
	if(GetAchievement(playerid, "knifes") >= 100) achies[1] = true;
	
	if(GetAchievement(playerid, "9mm") >= 50) achies[2] = true;
	if(GetAchievement(playerid, "9mm") >= 100) achies[3] = true;
	
	if(GetAchievement(playerid, "Deagle") >= 50) achies[4] = true;
	
	if(GetAchievement(playerid, "AK47") >= 100) achies[5] = true;
	
	if(GetAchievement(playerid, "SMG") >= 100) achies[6] = true;

    if(GetAchievement(playerid, "Policekills") >= 30) achies[7] = true;
    if(GetAchievement(playerid, "Armykills") >= 30) achies[8] = true;
    if(GetAchievement(playerid, "Rodkills") >= 30) achies[9] = true;
    
    if(GetAchievement(playerid, "dmwins") >= 50) achies[10] = true;
    if(GetAchievement(playerid, "dmwins") >= 100) achies[11] = true;
    if(GetAchievement(playerid, "dmwins") >= 200) achies[12] = true;
    
    if(GetAchievement(playerid, "vehdrives") >= 200) achies[13] = true;
    if(GetAchievement(playerid, "vehdrives") >= 500) achies[14] = true;
    
    if(GetAchievement(playerid, "shoprob") >= 50) achies[15] = true;
    if(GetAchievement(playerid, "shoprob") >= 100) achies[16] = true;
    
    if(GetAchievement(playerid, "jails") >= 50) achies[17] = true;
    if(GetAchievement(playerid, "jails") >= 100) achies[18] = true;
    
	format(dstring, sizeof(dstring), #HWHITE#"50 késelés: %s(%02d/50)\n100 késelés: %s(%02d/100)\n\
	50 ölés 9mm-el: %s(%02d/50)\n100 ölés 9mm-el: %s(%02d/100)\n\
	50 ölés Deagle-el: %s(%02d/50)\n100 ölés AK-47-tel: %s(%02d/100)\n100 ölés SMG-vel: %s(%02d/100)\n\
	30 zsaru megölése: %s(%02d/30)\n30 katona megölése: %s(%02d/30)\n30 Rodney bandás megölése: %s(%02d/30)\n\
	Versenyrekord felállítása: %d\n1. helyezett versenyben: %d\n2. helyezett versenyben: %d\n\
	3. helyezett versenyben: %d\n",
	(achies[0]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 késelés
	(achies[0]) ? (50) : (GetAchievement(playerid, "knifes")),
	(achies[1]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 késelés
	(achies[1]) ? (100) : (GetAchievement(playerid, "knifes")),
	(achies[2]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 9mm ölés
	(achies[2]) ? (50) : (GetAchievement(playerid, "9mm")),
	(achies[3]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 9mm ölés
	(achies[3]) ? (100) : (GetAchievement(playerid, "9mm")),
	(achies[4]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 Deagle ölés
	(achies[4]) ? (50) : (GetAchievement(playerid, "Deagle")),
	(achies[5]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 AK-47 ölés
	(achies[5]) ? (100) : (GetAchievement(playerid, "AK47")),
	(achies[6]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 SMG ölés
	(achies[6]) ? (100) : (GetAchievement(playerid, "SMG")),
	(achies[7]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //30 zsaru ölés
	(achies[7]) ? (30) : (GetAchievement(playerid, "Policekills")),
	(achies[8]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //30 katona ölés
	(achies[8]) ? (30) : (GetAchievement(playerid, "Armykills")),
	(achies[9]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //30 Rodney bandás ölés
	(achies[9]) ? (30) : (GetAchievement(playerid, "Rodkills")),
	GetAchievement(playerid, "RaceRecords"),
	GetAchievement(playerid, "Racegold"),
	GetAchievement(playerid, "Racesilver"),
	GetAchievement(playerid, "Racebronze"));
	
	format(dstring, sizeof(dstring), "%s50 párbaj megnyerése: %s(%02d/50)\n100 párbaj megnyerése: %s(%02d/100)\n200 párbaj megnyerése: %s(%02d/200)\n\
	200 jármû vezetése: %s(%02d/200)\n500 jármû vezetése: %s(%02d/500)\n50 bolt kirablása: %s(%02d/50)\n100 bolt kirablása: %s(%02d/100)\n\
	50-szer letartóztatva: %s(%02d/50)\n100-szor letartóztatva: %s(%02d/100)", dstring,
	(achies[10]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 párbaj megnyerése
	(achies[10]) ? (50) : (GetAchievement(playerid, "dmwins")),
	(achies[11]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 párbaj megnyerése
	(achies[11]) ? (100) : (GetAchievement(playerid, "dmwins")),
	(achies[12]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //200 párbaj megnyerése
	(achies[12]) ? (200) : (GetAchievement(playerid, "dmwins")),
	(achies[13]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //200 jármû vezetése
	(achies[13]) ? (200) : (GetAchievement(playerid, "vehdrives")),
	(achies[14]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //500 jármû vezetése
	(achies[14]) ? (500) : (GetAchievement(playerid, "vehdrives")),
	(achies[15]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 bolt kirablása
	(achies[15]) ? (50) : (GetAchievement(playerid, "shoprob")),
	(achies[16]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 bolt kirablása
	(achies[16]) ? (100) : (GetAchievement(playerid, "shoprob")),
	(achies[17]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50-szer letartóztatva
	(achies[17]) ? (50) : (GetAchievement(playerid, "jails")),
	(achies[18]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100-szor letartóztatva
	(achies[18]) ? (100) : (GetAchievement(playerid, "jails")));

	ShowPlayerDialog(playerid, MYACHIE_DIALOG, DIALOG_STYLE_MSGBOX, "Achievementek", dstring, "Tovább", "Kilép");
	return 1;
}

CMD:ach(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /ach [ID/névrészlet]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "A játékos nem elérhetõ.");
	
	new bool:achies[19];
	if(GetAchievement(id, "knifes") >= 50) achies[0] = true;
	if(GetAchievement(id, "knifes") >= 100) achies[1] = true;

	if(GetAchievement(id, "9mm") >= 50) achies[2] = true;
	if(GetAchievement(id, "9mm") >= 100) achies[3] = true;

	if(GetAchievement(id, "Deagle") >= 50) achies[4] = true;

	if(GetAchievement(id, "AK47") >= 100) achies[5] = true;

	if(GetAchievement(id, "SMG") >= 100) achies[6] = true;

    if(GetAchievement(id, "Policekills") >= 30) achies[7] = true;
    if(GetAchievement(id, "Armykills") >= 30) achies[8] = true;
    if(GetAchievement(id, "Rodkills") >= 30) achies[9] = true;

	if(GetAchievement(id, "dmwins") >= 50) achies[10] = true;
    if(GetAchievement(id, "dmwins") >= 100) achies[11] = true;
    if(GetAchievement(id, "dmwins") >= 200) achies[12] = true;

    if(GetAchievement(id, "vehdrives") >= 200) achies[13] = true;
    if(GetAchievement(id, "vehdrives") >= 500) achies[14] = true;

    if(GetAchievement(id, "shoprob") >= 50) achies[15] = true;
    if(GetAchievement(id, "shoprob") >= 100) achies[16] = true;
    
    if(GetAchievement(id, "jails") >= 50) achies[17] = true;
    if(GetAchievement(id, "jails") >= 100) achies[18] = true;

	format(dstring, sizeof(dstring), #HWHITE#"50 késelés: %s\n100 késelés: %s\n50 ölés 9mm-el: %s\n100 ölés 9mm-el: %s\n\
	50 ölés Deagle-el: %s\n100 ölés AK-47-tel: %s\n100 ölés SMG-vel: %s\n30 zsaru megölése: %s\n30 katona megölése: %s\n\
	30 Rodney bandás megölése: %s\nVersenyrekord felállítása: %d\n1. helyezett versenyben: %d\n2. helyezett versenyben: %d\n\
	3. helyezett versenyben: %d\n",
	(achies[0]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 késelés
	(achies[1]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 késelés
	(achies[2]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 9mm ölés
	(achies[3]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 9mm ölés
	(achies[4]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 Deagle ölés
	(achies[5]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 AK-47 ölés
	(achies[6]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 SMG ölés
	(achies[7]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //30 zsaru ölés
	(achies[8]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //30 katona ölés
	(achies[9]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //30 Rodney bandás ölés
	GetAchievement(id, "RaceRecords"),
	GetAchievement(id, "Racegold"),
	GetAchievement(id, "Racesilver"),
	GetAchievement(id, "Racebronze"));

	format(dstring, sizeof(dstring), "%s50 párbaj megnyerése: %s\n100 párbaj megnyerése: %s\n200 párbaj megnyerése: %s\n\
	200 jármû vezetése: %s\n500 jármû vezetése: %s\n50 bolt kirablása: %s\n100 bolt kirablása: %s\n\
	50-szer letartóztatva: %s\n100-szor letartóztatva: %s\n", dstring,
	(achies[10]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 párbaj megnyerése
	(achies[11]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 párbaj megnyerése
	(achies[12]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //200 párbaj megnyerése
	(achies[13]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //200 jármû vezetése
	(achies[14]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //500 jármû vezetése
	(achies[15]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 bolt kirablása
	(achies[16]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 bolt kirablása
	(achies[17]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50-szer letartóztatva
	(achies[18]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#)); //100-szor letartóztatva

	new achst[50];
	format(achst, sizeof(achst), "%s Achievementjei", GetPlayerNameEx(id));
	SetPVarInt(playerid, "achcmd", id);
	ShowPlayerDialog(playerid, ACHIE_DIALOG, DIALOG_STYLE_MSGBOX, achst, dstring, "Tovább", "Kilép");
	return 1;
}

CMD:fuelinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s",
	""#HWHITE#"A jármûvekbõl egyszer kifogy a benzin.\n",
	""#HWHITE#"Ha közjármûrõl van szó, akkor az carrespawnkor újratöltõdik,\n",
	""#HWHITE#"de ha saját jármûrõl van szó akkor szerver restart után is megmarad annyi amennyi volt.\n",
	""#HWHITE#"Tankolni a "#HYELLOW#"/tankol "#HWHITE#"paranccsal lehetséges egy benzinkúton.\n",
	""#HWHITE#"A jármû motorját az "#HYELLOW#"N "#HWHITE#" gomb megnyomásával indíthatod el és állíthatod le.\n",
	""#HWHITE#"A saját jármûved benzintárolójának kapacitását növelheted a jármû fejlesztésével. (Szint)");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Tankolás", dstring, "Oké", "");
	return 1;
}

CMD:fishinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s",
	""#HWHITE#"A szerveren lehetõség van horgászatra.\n",
	""#HWHITE#"A dolgod hogy elmész a tengerpartra, vagy akár csónakban a nyilt tenggerre,\n",
	""#HWHITE#"beírod a "#HYELLOW#"/fish "#HWHITE#"parancsot és vársz amíg nem lesz kapás.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Halászás", dstring, "Oké", "");
	return 1;
}

CMD:claninfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Lehetõséged van a szerveren klánt létrehozni.\n",
	""#HWHITE#"Ha létreszeretnél hozni, rendelkezned kell minimum 1.5 millió $-al.\n",
	""#HWHITE#"Ha van saját klánod, vehetsz hozzá jármûveket, amiket csak a klántagok tudnak vezetni.\n",
	""#HWHITE#"Háborúzhatsz más klánok ellen különbözõ pályákon, és gyûjthetitek a klánkasszába a pénzt.\n",
	""#HWHITE#"Saját rangokat hozhatsz létre, és a rangok jogait szabadon testreszabhatod.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/createclan - "#HYELLOW#"Klán létrehozása\n",
	""#HWHITE#"/claninvite - "#HYELLOW#"Klánmeghívó küldése\n",
	""#HWHITE#"/clanjoin  - "#HYELLOW#"Klánmeghívó elfogadása\n",
	""#HWHITE#"/clanreject - "#HYELLOW#"Klánmeghívó elutasítása\n",
	""#HWHITE#"/clanpanel - "#HYELLOW#"Klán panel\n",
	""#HWHITE#"/c - "#HYELLOW#"Klán chat\n",
	""#HWHITE#"/clans - "#HYELLOW#"Jelenlegi klánok\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Klánok", dstring, "Oké", "");
	return 1;
}

CMD:lottoinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s",
	""#HWHITE#"Egy lottószelvény 15.000$ amit a "#HYELLOW#"/lotto "#HWHITE#"paranccsal tudsz megvenni.\n",
	""#HWHITE#"20 percenként van sorsolás. Ha eltaláltad mind az 5 számot megnyerted a fõnyereményt.\n",
	""#HWHITE#"De ha nem találtad el, akkoris szép összeget kapsz!\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Lottózás", dstring, "Oké", "");
	return 1;
}

CMD:rules(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"1.§ Tilos bármiféle mod, cheat vagy hack használata! "#HRED#"[ban]\n\n",
	""#HWHITE#"2.§ Tilos más szerverek reklámozása! "#HRED#"[ban]\n\n",
	""#HWHITE#"3.§ Tilos az anyázás, káromkodás, rasszizmus, adminszidás! "#HRED#"[kick/mute/jail]\n\n",
	""#HWHITE#"4.§ Tilos bármilyen bug kihasználása! [kick > ban]\n\n",
	""#HWHITE#"5.§ Tilos az IK, DB, SK, Glitch! (Fogalmak lentebb) "#HRED#"[kick]\n\n",
	""#HWHITE#"6.§ Tilos a flood, vagyis ne írj le többször egymás után semmit! "#HRED#"[mute/warn/kick]\n\n",
	""#HWHITE#"7.§ Tilos az interiorok kihasználása! (Pl. fegyverbolt)"#HRED#"[warn]\n\n",
	""#HWHITE#"8.§ Tilos az adminjog kéregetése! "#HRED#"[kick]\n\n",
    ""#HWHITE#"9.§ Bandaterületeket csak hétköznapi jármûvekkel lehet támadni! "#HRED#"[warn/kick]\n\n",
    ""#HWHITE#"Fogalmak\n\n",
    ""#HRED#"Glitch\n",
    ""#HWHITE#"Azt nevezzük Glitchnek, amikor egy fegyver tárjából kilõsz például 20 töltényt, marad benne 30,\n",
    ""#HWHITE#"és hogy ne kelljen táraznod, gyorsan fegyvert cserélsz oda-vissza, hogy tele legyen a fegyver tárja.\n\n",
    ""#HRED#"DB/Drive-by\n",
    ""#HWHITE#"DB-nek nevezzük azt, amikor egy játékos jármû segítségével öl/sebez meg egy gyalogost.\n",
    ""#HWHITE#"Gyakori elõfordulások:\n",
    ""#HWHITE#"- Jármû bármely ülésébõl lõnek gyalogosra.\n",
    ""#HWHITE#"- Elütik a gyalogost.\n",
    ""#HWHITE#"- Jármûvel ráállnak a gyalogosra.\n",
    ""#HWHITE#"- Fegyveres jármûvel lõnek a gyalogosra.\n",
    ""#HRED#"Figyelem: Ha a jármû sofõrjét lövöd, az nem DB!\n\n",
	""#HRED#"IK/Interior Kill\n",
	""#HWHITE#"IK-nak nevezzük azt amikor egy játékos egy másikat épületben öl/sebez meg.\n\n",
	""#HRED#"SK/Spawn Kill\n",
	""#HWHITE#"SK-nak nevezzük azt amikor egy játékos a lespawnolás után egyböl megöli a másikat.\n\n",
	""#HRED#"Interior kihasználás\n",
	""#HWHITE#"Amikor harcolsz, tilos a fegyverboltba rohangálnod armour töltésért!\n",
	""#HWHITE#"Amikor harcolsz, tilos egy étkezõbe bemenned élet töltésért!\n",
	""#HWHITE#"Amikor egy rendõr üldöz, tilos bemenni egy épületbe hogy ne kaphasson el!\n");
	ShowPlayerDialog(playerid, RULES1_DIALOG, DIALOG_STYLE_MSGBOX, "Szabályzat", dstring, "Tovább", "Oké");
	return 1;
}

CMD:houseinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"A szerveren vehetsz saját házat amiben lakhatsz, a /spawn paranccsal állíthatod be hogy ott spawnolj.\n",
	""#HWHITE#"A térképen a megvehetõ házak "#HLIME#"zöld "#HWHITE#"házjellel vannak jelölve.\n",
	""#HWHITE#"A házadba kiválaszthatsz még egy társtulajt is akivel ketten laktok ott.\n",
	""#HWHITE#"A házadat el is nevezheted, és kedved szerint rendezheted be mindenféle tárgyal.\n",
	""#HWHITE#"Lehetõséged van még lakókocsiba is lakni. Ehhez venned kell egy Journey típusú autót, \n",
	""#HWHITE#"és a "#HYELLOW#"/spawn "#HWHITE#"paranccsal be kell állítanod kezdõhelynek a lakókocsit. \n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/tarstulaj - "#HYELLOW#"Kinevezhetsz magad mellé egy társtulajt\n",
	""#HWHITE#"/tarstulajelvesz - "#HYELLOW#"Elveheted a társtulajt\n",
	""#HWHITE#"/tarstulajkilep - "#HYELLOW#"Ha társtulaj vagy egy háznál, ezzel elveheted magadtól\n",
	""#HWHITE#"/hazad - "#HYELLOW#"Átadhatod a házat\n",
	""#HWHITE#"/housemenu - "#HYELLOW#"Házmenü\n",
	""#HWHITE#"/lockhouse - "#HYELLOW#"Bezárod a házat\n",
	""#HWHITE#"/unlockhouse - "#HYELLOW#"Kinyitod a házat\n",
	""#HWHITE#"A házakba az "#HYELLOW#"Y "#HWHITE#"gomb segítségével tudsz bemenni és kimenni. A könnyebb választásért az eladó házakba is bemehetsz.");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Házak", dstring, "Oké", "");
	return 1;
}

CMD:autoinfo(playerid)
{
	format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Vehetsz saját autókat amik névre szólnak és csak te tudod vezetni.\n",
	""#HWHITE#"Az autókra vehetsz tuningot és neont.\n",
	""#HWHITE#"Ha vennél, menj el a Ryuuzaki's cars-ba, ami az Otto's autos 3. emeletén található.\n",
	""#HWHITE#"Ha van saját autód, még lehetõséged van 1 játékosnak odaadni a kulcsot hozzá.\n",
	""#HWHITE#"A fegyvered csomagtartójában fegyvert is tárolhatsz.\n",
	""#HWHITE#"Egyszerre maximum 10 jármûved lehet.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/mycars - "#HYELLOW#"Megtekintheted az autóidat\n",
	""#HWHITE#"/kulcsad - "#HYELLOW#"Odaadod a kulcsot egy játékosnak\n",
	""#HWHITE#"/kulcselvesz - "#HYELLOW#"Elveszed a kulcsot egy játékostól\n",
	""#HWHITE#"/autoad - "#HYELLOW#"Odaadod az autót egy játékosnak\n",
	""#HWHITE#"/cstki - "#HYELLOW#"Kinyitod az autó csomagtartóját\n",
	""#HWHITE#"/cstbe - "#HYELLOW#"Bezárod az autó csomagtartóját\n",
	""#HWHITE#"/mhki - "#HYELLOW#"Kinyitod az autó motorháztetõjét\n",
	""#HWHITE#"/mhbe - "#HYELLOW#"Bezárod az autó motorháztetõjét\n",
	""#HWHITE#"/lock - "#HYELLOW#"Bezárod az autó ajtaját\n",
	""#HWHITE#"/unlock - "#HYELLOW#"Kinyitod az autó ajtaját\n",
	""#HWHITE#"/autoszerkeszt - "#HYELLOW#"Szerkesztheted vele az autóidat\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Jármûvek", dstring, "Oké", "");
	return 1;
}

CMD:bizinfo(playerid)
{
	format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Vehetsz saját bizniszt, ami termeli neked a pénzt akkor is, ha nem vagy fent a szerveren.\n",
	""#HWHITE#"Csak 1 bizniszed lehet, mivel egyel is jól lehet keresni.\n",
	""#HWHITE#"Minnél drágább egy biznisz, annál több pénzt termel.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/buybiz - "#HYELLOW#"Ha egy biznisz közelében vagy, ezzel a parancsal tudod megvenni.\n",
	""#HWHITE#"/sellbiz - "#HYELLOW#"Ezzel tudod eladni a bizniszedet, viszont utána nem kapod vissza az árát, se semennyit.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Bizniszek", dstring, "Oké", "");
	return 1;
}

CMD:racesinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s",
	""#HWHITE#"A szerveren a fõadmin indíthat versenyeket és stuntokat, vagy néha idõközönként indulnak.\n",
	""#HWHITE#"Ha csatlakozni szeretnél egyhez: "#HYELLOW#"/join, "#HWHITE#"ha készen állsz a versenyre: "#HYELLOW#"/ready.\n",
	""#HWHITE#"Ha el akarod hagyni a versenyt: "#HYELLOW#"/leave, "#HWHITE#"ha a rekordokat szeretnéd megnézni: "#HYELLOW#"/rekordok.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Versenyek", dstring, "Oké", "");
	return 1;
}

CMD:jobs(playerid,params[]) {
	SendClientMessage(playerid,COLOR_YELLOW," ][M][U][N][K][Á][K][ ");
	SendClientMessage(playerid,COLOR_YELLOW,"MÁV vonatvezetõ: A vonatot kell vezetnie és kapja a pénzt. A térképen az R jel jelöli.");
	SendClientMessage(playerid,COLOR_YELLOW,"BKV busz és villamossofõr: Járatokat indít menetrend szerint. A térképen BS jelöli.");
	SendClientMessage(playerid,COLOR_YELLOW,"Taxis: El kell vinnie a játékost A pontból B pontba. A térképen a T jel jelöli.");
	SendClientMessage(playerid,COLOR_YELLOW,"Katona: Le kell lõnie a körözötteket. A térképen pisztoly jelöli.(TP rendszer)");
	SendClientMessage(playerid,COLOR_YELLOW,"Mentõs: Meg kell gyógyítania a játékosokat. A térképen '+' jel jelöli.");
	SendClientMessage(playerid,COLOR_YELLOW,"Kamionos: Fel kell venni a rakományt és el kell szállítani az adott helyre. A térképen teherautó jelöli.");
	SendClientMessage(playerid,COLOR_YELLOW,"Bankos: A bankba kell szállítania a pénzt. A térképen piros $ jel jelöli.(TP rendszer)");
	SendClientMessage(playerid,COLOR_YELLOW,"Bankrabló: Ki kell rabolnia a bankot. A térképen gyémánt jelöli.");
	SendClientMessage(playerid,COLOR_YELLOW,"Rendõr: Le kell csuknia a körözötteket. A térképen kék sziréna jelöli.(TP rendszer)");
	SendClientMessage(playerid,COLOR_YELLOW,"Politikus: Semmit se csinál és kapja a pénzt. A térképen W jel jelöli.");
	SendClientMessage(playerid,COLOR_YELLOW,"Hotdogos: El kell adnia a hotdogot az adott helyeken. A térképen nincs jelölve.");
	SendClientMessage(playerid,COLOR_YELLOW,"Farmer: El kell vetnie a termést és utána learatni. A térképen az MC jel jelöli.");
	SendClientMessage(playerid,COLOR_YELLOW,"Bandák:");
	SendClientMessage(playerid,COLOR_YELLOW,"Triad: a térképen a ´´piros kígyó´´ jel jelöli");
	SendClientMessage(playerid,COLOR_YELLOW,"Rifa: a Kamionos munka mellet");
	SendClientMessage(playerid,COLOR_YELLOW,"Maffia:Az étteremnél (´´villa és kés´´ jel)");
	SendClientMessage(playerid,COLOR_YELLOW,"Vietnami: A kikötõben(Pier 69)");
	SendClientMessage(playerid,COLOR_YELLOW,"Groove: LS-ben a Groove streetnél");
	SendClientMessage(playerid,COLOR_RED,"TP rendszer: bizonyos TP-nként(pl 20, 40 stb) nõ a fizetésed vagy a fegyverarzenálod.");
	return 1;
}

/*CMD:adminok(playerid, params[])
{
	SendClientMessage(playerid, COLOR_GREEN,"Adminok:");//format
	SendClientMessage(playerid, COLOR_YELLOW,"Szint 4: Ryuuzaki(tulaj), Rodney, Steewiee");
	SendClientMessage(playerid, COLOR_YELLOW,"Szint 3: Ecstasy, Castle,");//format
	SendClientMessage(playerid, COLOR_YELLOW,"Szint 2: SolKing, Shika, Final");//format
	SendClientMessage(playerid, COLOR_YELLOW,"Szint 1:");
	SendClientMessage(playerid, COLOR_RED,"Admin TGF: Jelenleg NINCS!!!!!");//format
	return 1;
}*/

/*CMD:msn(playerid, params[])
{
	new msnstr[1500], id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /msn [id/névrészlet]");
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor5[playerid][id]);
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor4[playerid][id]);
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor3[playerid][id]);
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor2[playerid][id]);
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor1[playerid][id]);
 	SetPVarInt(playerid, "msn", id);
	ShowPlayerDialog(playerid, MSN_DIALOG, DIALOG_STYLE_INPUT, "MSN", msnstr, "Elküld", "Kilép");
	return 1;
}*/
//---------------------------------Rangok, accountok------------------------------------
CMD:mysqlquery(playerid, params[])
{
	new mquery[200];
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(sscanf(params, "s[200]", mquery)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /mysqlquery [Query]");
    format(query, sizeof(query), "%s", mquery);
    mysql_query(query);
    SendAdminCMDMessage(playerid, "MYSQLQUERY");
	return 1;
}

CMD:mysqlselect(playerid, params[])
{
    new mquery[200];
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(sscanf(params, "s[200]", mquery)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /mysqlselect [Query]");
    format(query, sizeof(query), "%s", mquery);
    mysql_query(query);
    mysql_store_result();
    if(mysql_num_rows() != 0)
    {
        new egyezestr[500];
        while(mysql_fetch_row(linen))
        {
            format(egyezestr, sizeof(egyezestr), "%s%s\n", egyezestr, linen);
        }
		mysql_free_result();
		ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Találatok", egyezestr, "Kilép", "");
    }
    else SendClientMessage(playerid, COLOR_RED, "Hiba: Hiba.");
    SendAdminCMDMessage(playerid, "MYSQLSELECT");
	return 1;
}

CMD:egyezes(playerid, params[])
{
	new egynev[24];
    if(sscanf(params, "s[24]", egynev)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /egyezes [játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	format(query, sizeof(query), "SELECT IP, Password FROM users WHERE Name = '%s'", egynev);
	mysql_query(query);
	mysql_store_result();
	if(mysql_num_rows() != 0)
	{
	    new egyip[30], egyjelszo[145];
	    mysql_fetch_row(linen);
	    mysql_free_result();
	    sscanf(linen, "p<|>s[30]s[145]", egyip, egyjelszo);

		format(query, sizeof(query), "SELECT Name, IP, Banned FROM users WHERE IP = '%s' OR Password = '%s' ORDER BY Name ASC LIMIT 15", egyip, egyjelszo);
		mysql_query(query);
		mysql_store_result();
		if(mysql_num_rows() != 0)
		{
		    new egyezestr[1000];
			while(mysql_fetch_row(linen))
			{
			    new ips[30], nevs[24], bani;
				sscanf(linen, "p<|>s[24]s[30]d", nevs, ips, bani);
			    if(bani == 0) format(egyezestr, sizeof(egyezestr), "%s{00FFFF}%s \t\t{ffffff}[IP cím: %s]\n", egyezestr, nevs, ips);
				else if(bani == 1) format(egyezestr, sizeof(egyezestr), "%s"#HRED#"%s \t\t{ffffff}[IP cím: %s]\n", egyezestr, nevs, ips);
			}
			mysql_free_result();
			SetPVarString(playerid, "tovabbiegyip", egyip);
			SetPVarString(playerid, "tovabbiegyjelszo", egyjelszo);
			ShowPlayerDialog(playerid, EGYEZES_DIALOG, DIALOG_STYLE_MSGBOX, "Találatok", egyezestr, "További találatok", "Kilép");
			SendAdminCMDMessage(playerid, "EGYEZES");
			SetPVarInt(playerid, "egyezesoldal", 1);
		}
		else SendClientMessage(playerid, COLOR_RED, "Nincs találat.");
	}
	else SendClientMessage(playerid, COLOR_RED, "HIBA: Nincs ilyen nevû játékos az adatbázisban.");
	return 1;
}

CMD:setlevel(playerid, params[])
{
	new adminid, level;
	if(sscanf(params, "ui", adminid, level)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /setlevel [playerid/játékosnév] [szint]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(adminid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == adminid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if((GetPVarInt(playerid, "Level") < GetPVarInt(adminid, "Level")) && (!IsPlayerAdminEx(playerid))) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    if(level > 4) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: 4 a maximum adminszint!");
    SendAdminCMDMessage(playerid, "SETLEVEL", GetPlayerNameEx(adminid));

    SetPVarInt(adminid, "Level", level);
	switch(GetPVarInt(adminid, "Level"))//az adminszintekhez tartozó megnevezés változóba írása
	{
	    case 0: SetPVarString(adminid, "AdminRang", "Átlagos Játékos");
		case 1: SetPVarString(adminid, "AdminRang", "Moderátor");
		case 2: SetPVarString(adminid, "AdminRang", "Kezdõ Adminisztrátor");
		case 3: SetPVarString(adminid, "AdminRang", "Haladó Adminisztrátor");
		case 4: SetPVarString(adminid, "AdminRang", "Fõ Adminisztrátor");
		//case 5: SetPVarString(playerid, "AdminRang", "Anyád");
	}

	new adminpvar[64];
	GetPVarString(adminid, "AdminRang", adminpvar, sizeof(adminpvar));

	//Update3DTextLabelText(Admin3DText[adminid], COLOR_3DLABEL, adminpvar);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: %s rangja sikeresen megváltozott! Az új rang: %s", GetPlayerNameEx(adminid), adminpvar);
    SendFormatMessage(adminid, COLOR_ADMINMSG, "[ ADMIN ]: %s megváltoztatta a rangodat! Az új rang: %s", GetPlayerNameEx(playerid), adminpvar);
    return 1;
}

CMD:leaderad(playerid, params[])
{
	new id, leader, leadernames[][] = {"Sajnálom, de nem kaptál, hanem elvették tõled!", "Rendõr", "Drogdíler", "Hacker", "OBKK", "Ryuuzaki's cars", "Rodney team", "Katonaság", "Stunt munka"};
	if(sscanf(params, "ui", id, leader)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /leaderad [playerid/játékosnév] [rendõr = 1, drog = 2, hacker = 3, OBKK = 4, Ryuuzaki's cars = 5, Rodney team = 6]"), SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[7 = Katonaság, 8 = Stunt munka]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(id)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(leader > 8) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Maximum 8 leaderes munkához adhatsz leadert!");
    SendAdminCMDMessage(playerid, "LEADERAD", GetPlayerNameEx(id));

    SetPVarInt(id, "Leader", leader);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: %s-nek leadert adtál! Amihez adtad a leadert: %s", GetPlayerNameEx(id), leadernames[leader]);
    SendFormatMessage(id, COLOR_ADMINMSG, "[ ADMIN ]: %s leadert adott neked! Amihez adta a leadert: %s", GetPlayerNameEx(playerid), leadernames[leader]);
    return 1;
}

CMD:vip(playerid, params[])
{
    new vipid, p[5];
	if(sscanf(params, "us[5]", vipid, p)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /vip [playerid/játékosnév] [ad/el]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(vipid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    SendAdminCMDMessage(playerid, "VIP", GetPlayerNameEx(vipid));

    if(!strcmp(p, "ad"))
	{
		SetPVarInt(vipid, "VIP", 1);
        SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen VIP rangot adtál %s-nek!", GetPlayerNameEx(vipid));
    	SendFormatMessage(vipid, COLOR_ADMINMSG, "[ ADMIN ]: %s VIP rangot adott neked!", GetPlayerNameEx(playerid));
	}
	if(!strcmp(p, "el"))
	{
		SetPVarInt(vipid, "VIP", 0);
        SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen elvetted %s-tõl a VIP rangot!", GetPlayerNameEx(vipid));
    	SendFormatMessage(vipid, COLOR_ADMINMSG, "[ ADMIN ]: %s elvette tõled a VIP rangot!", GetPlayerNameEx(playerid));
	}
	return 1;
}

CMD:admins(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 0 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new aCount[2], i, string[128];
	for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i))
	{
		if(GetPVarInt(i, "Level") > 0) aCount[0]++;
		if(IsPlayerAdminEx(i)) aCount[1]++;
	}

	if( (aCount[0] == 0 && aCount[1] == 0) || (aCount[0] == 0 && aCount[1] >= 1 && GetPVarInt(i, "Level") == 0) ) return SendClientMessage(playerid, BLUE, "Nincs online admin!");

	if(aCount[0] == 1) {
	    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && GetPVarInt(i, "Level") > 0) {
			format(string, sizeof(string), "Admin: (%d)%s [%d]", i, GetPlayerNameEx(i), GetPVarInt(i, "Level") ); SendClientMessage(playerid, BLUE, string);
		}
	}

 	if(aCount[0] > 1) {
	    new x; format(string, sizeof(string), "Adminok: ");
	    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && GetPVarInt(i, "Level") > 0)
		{
			format(string,sizeof(string),"%s(%d)%s [%d]",string,i,GetPlayerNameEx(i),GetPVarInt(i, "Level"));
			x++;
			if(x >= 5) {
			    SendClientMessage(playerid, BLUE, string); format(string, sizeof(string), "Adminok: "); x = 0;
			}
			else format(string, sizeof(string), "%s,  ", string);
	    }
		if(x <= 4 && x > 0) {
			string[strlen(string)-3] = '.';
		    SendClientMessage(playerid, BLUE, string);
		}
	}

	if( (aCount[1] == 1) && (GetPVarInt(i, "Level") > 0) ) {
	    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && IsPlayerAdminEx(i)) {
			format(string, sizeof(string), "RCON Admin: (%d)%s", i, GetPlayerNameEx(i)); SendClientMessage(playerid, WHITE, string);
		}
	}
	if(aCount[1] > 1) {
 		new x; format(string, sizeof(string), "RCON Admins: ");
	    for(i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && IsPlayerAdminEx(i))
		{
			format(string,sizeof(string),"%s(%d)%s",string,i,GetPlayerNameEx(i));
			x++;
			if(x >= 5) {
				SendClientMessage(playerid, WHITE, string); format(string, sizeof(string), "RCON Adminok: "); x = 0;
			}
			else format(string, sizeof(string), "%s,  ", string);
	    }
		if(x <= 4 && x > 0) {
			string[strlen(string)-3] = '.';
		    SendClientMessage(playerid, WHITE, string);
		}
	}
	return 1;
}

/*CMD:bugreport(playerid, params[])
{
    //new reason[128], message[128], gmname[64];
    new reason[128], message[128];
    if(sscanf(params, "s[128]", reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /bugreport [szöveg]");

	format(message, sizeof(message), "[ BUG ]: %s (%d) bejelentett egy hibát: %s", GetPlayerNameEx(playerid), playerid, reason);
	SendClientMessageToAdmins(COLOR_REPORT, message);

	SendFormatMessage(playerid, COLOR_REPORT, "[ BUG ]: Sikeresen bejelentettél egy hibát [A hiba: %s ]", reason);
	return 1;
}*/

CMD:givecash(playerid, params[])
{
	new userid, money;
	if(GetPVarInt(playerid, "Logged") == 0) return 1;
	if(sscanf(params, "ui", userid, money)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /givemoney [playerid/játékosnév] [összeg]");
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(money <= 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Valós összeget írjál be!");
    if(money > GetPlayerMoneyEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs ennyi pénzed!");
	if(GetPVarInt(playerid, "1v1dmben") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: DM-ben nem küldhetsz pénzt.");

	GivePlayerMoneyEx(playerid, -money, "Pénzt adott át");
    GivePlayerMoneyEx(userid, money, "Pénzt kapott mástól");

    SendFormatMessage(playerid, COLOR_ADMINMSG, "Sikeresen küldtél %s %d$-t! Jelenleg %d$-ja van!", rag(GetPlayerNameEx(userid),2), money, GetPlayerMoneyEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "%s küldött neked %d$-t! Jelenleg %d$-od van!", GetPlayerNameEx(playerid), money, GetPlayerMoneyEx(userid));
    return 1;
}

CMD:stats(playerid, params[])
{
	new userid, format1[128], format2[128], format3[128], format4[128];
	format(format1, sizeof(format1),"A statisztikád:  [Ölések: %d] - [Halálok: %d] - [Arány: %0.2f] - [Készpénz: $ %d] - [Eltelt idõ: %02d óra, %02d perc]", GetPVarInt(playerid, "Kills"), GetPVarInt(playerid, "Deaths"), Float:GetPVarInt(playerid, "Kills")/Float:GetPVarInt(playerid, "Deaths"), GetPlayerMoneyEx(playerid), GetPVarInt(playerid, "Ora"), GetPVarInt(playerid, "Perc"));
	format(format3, sizeof(format3),"Klán: %s, Szint: %d", GetPVarStringEx(playerid, "Clan"), GetPVarInt(playerid, "Szint"));
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_ADMINMSG, format1), SendClientMessage(playerid, COLOR_ADMINMSG, format3);
	if(!IsPlayerValid(userid)) return SendClientMessage(playerid, RED, Errors[0][0]);
	format(format2, sizeof(format2), "%s statisztikája:  [Ölések: %d] - [Halálok: %d] - [Arány: %0.2f] - [Készpénz: $%d] - [Eltelt idõ: %02d óra, %02d perc]", GetPlayerNameEx(userid), GetPVarInt(userid, "Kills"), GetPVarInt(userid, "Deaths"), Float:GetPVarInt(userid, "Kills")/Float:GetPVarInt(userid, "Deaths"),GetPlayerMoneyEx(userid), GetPVarInt(userid, "Ora"), GetPVarInt(userid, "Perc"));
    format(format4, sizeof(format4),"Klán: %s, Szint: %d", GetPVarStringEx(userid, "Clan"), GetPVarInt(userid, "Szint"));
	SendClientMessage(playerid, COLOR_ADMINMSG, format2), SendClientMessage(playerid, COLOR_ADMINMSG, format4);
	return 1;
}

CMD:ip(playerid, params[])
{
	new userid, IP[50];
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /ip [playerid/játékosnév]");
    //if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);

	GetPlayerIp(userid, IP, sizeof(IP));
	SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: %s ipje: %s", GetPlayerNameEx(userid), IP);
	return 1;
}

CMD:setkills(playerid, params[])
{
	new userid, kills;
	if(sscanf(params, "ui", userid, kills)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /setkills [playerid/játékosnév] [ölések]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SETKILLS", GetPlayerNameEx(userid));

    SetPVarInt(userid, "Kills", kills);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Átállítottad %s öléseinek számát! Jelenleg %d ölése van!", GetPlayerNameEx(userid), GetPVarInt(userid, "Kills"));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s átálította az öléseid számát! Jelenleg %d ölésed van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "Kills"));
    return 1;
}

CMD:setdeaths(playerid, params[])
{
	new userid, deaths;
	if(sscanf(params, "ui", userid, deaths)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /setdeaths [playerid/játékosnév] [halálok]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SETDEATHS", GetPlayerNameEx(userid));

    SetPVarInt(userid, "Deaths", deaths);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Átállítottad %s halálainak számát! Jelenleg %d halála van!", GetPlayerNameEx(userid), GetPVarInt(userid, "Deaths"));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s átálította a halálaid számát! Jelenleg %d halálod van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "Deaths"));
    return 1;
}

CMD:unlockach(playerid, params[])
{
    new userid, ac[20], acm;
	if(sscanf(params, "us[20]i", userid, ac, acm)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /unlockach [playerid/játékosnév] [achievementnév] [mennyiség]");
    if(!IsPlayerAdminEx(playerid) && strcmp("Ryuuzaki", GetPlayerNameEx(playerid), true)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    SendAdminCMDMessage(playerid, "UNLOCKACH", GetPlayerNameEx(userid));

    SetPVarInt(userid, ac, acm);
	return 1;
}

CMD:setcash(playerid, params[])
{
	new userid, cash;
	if(sscanf(params, "ui", userid, cash)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /setcash [playerid/játékosnév] [pénz]");
    //if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerAdminEx(playerid) && strcmp("Ryuuzaki", GetPlayerNameEx(playerid), true)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    //if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SETCASH", GetPlayerNameEx(userid));

    ResetPlayerMoneyEx(userid);
    GivePlayerMoneyEx(userid, cash);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Átállítottad %s pénzét! Jelenleg %d pénze van!", GetPlayerNameEx(userid), GetPlayerMoneyEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s átálította a pénzedet! Jelenleg %d pénzed van!", GetPlayerNameEx(playerid), GetPlayerMoneyEx(userid));
	return 1;
}

CMD:setora(playerid, params[])
{
	new userid, ora;
	if(sscanf(params, "ui", userid, ora)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /setora [playerid/játékosnév] [órák száma]");
    if(!IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    SendAdminCMDMessage(playerid, "SETORA", GetPlayerNameEx(userid));

    SetPVarInt(userid, "Ora", ora);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Átállítottad %s óráinak számát! Jelenleg %d órád van!", GetPlayerNameEx(userid), GetPVarInt(userid, "Ora"));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s átálította az óráidnak számát! Jelenleg %d órád van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "Ora"));
	return 1;
}

CMD:setperc(playerid, params[])
{
	new userid, ora;
	if(sscanf(params, "ui", userid, ora)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /setperc [playerid/játékosnév] [percek száma]");
    if(!IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    SendAdminCMDMessage(playerid, "SETPERC", GetPlayerNameEx(userid));

    SetPVarInt(userid, "Perc", ora);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Átállítottad %s perceinek számát! Jelenleg %d órád van!", GetPlayerNameEx(userid), GetPVarInt(userid, "Perc"));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s átálította a perceidnek számát! Jelenleg %d órád van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "Perc"));
	return 1;
}

CMD:settp(playerid, params[])
{
	new userid, tpp[15], cash;
	if(sscanf(params, "us[15]i", userid, tpp, cash)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /settp [playerid/játékosnév] [TP] [mennyiség]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SETTP", GetPlayerNameEx(userid));

	if(!strcmp(tpp, "rendõrtp", true))
	{
		SetPVarInt(userid, "RendorTP", cash);
		SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Átállítottad %s RendõrTP-jét! Jelenleg %d RendõrTP-je van!", GetPlayerNameEx(userid), GetPVarInt(userid, "RendorTP"));
    	SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s átálította a RendõrTP-det! Jelenleg %d RendõrTP-d van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "RendorTP"));
	}
	else if(!strcmp(tpp, "bankostp", true))
	{
		SetPVarInt(userid, "bankosTP", cash);
		SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Átállítottad %s BankosTP-jét! Jelenleg %d BankosTP-je van!", GetPlayerNameEx(userid), GetPVarInt(userid, "BankosTP"));
    	SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s átálította a BankosTP-det! Jelenleg %d BankosTP-d van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "BankosTP"));
	}
	else if(!strcmp(tpp, "katonatp", true))
	{
		SetPVarInt(userid, "KatonaTP", cash);
		SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Átállítottad %s KatonaTP-jét! Jelenleg %d KatonaTP-je van!", GetPlayerNameEx(userid), GetPVarInt(userid, "KatonaTP"));
    	SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s átálította a KatonaTP-det! Jelenleg %d KatonaTP-d van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "KatonaTP"));
	}
	return 1;
}

CMD:changepass(playerid, params[])
{
	new username[24], pass[512];
	if(sscanf(params, "s[24]s[512]", username, pass)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /changepass [játékosnév] [új jelszó]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ezt a parancsot csak egy Fõ Adminisztrátor használhatja. Ha jelszót szeretnél váltani írj nekik");
    SendAdminCMDMessage(playerid, "CHANGEPASS", username);
    
    new Hash[145];
	WP_Hash(Hash, sizeof(Hash), pass);
	format(query, sizeof(query), "UPDATE users SET Password = '%s' WHERE Name = '%s'", Hash, username);
	mysql_query(query);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Ha volt %s az adatbázisban akkor sikeresen átállítottad jelszavát!", username);
    return 1;
}
//-----------------------------------Helyváltoztatás---------------------------------
/*CMD:kill(playerid, params[])
{
	if(GetPVarInt(playerid, "JailTimerPLAYER") > 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Börtönben nem használhatod ezt a parancsot!");
	SetPlayerHealth(playerid, 0);
	return 1;
}*/

/*CMD:afk(playerid, params[])
{
	if(GetPVarInt(playerid, "Cuffed") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Bilincsben nem használhatod ezt a parancsot!");
	SendFormatMessageToAll(YELLOW, "*** %s aktiválta az AFK módot!", GetPlayerNameEx(playerid));
	SendClientMessage(playerid, YELLOW, "Átlettél rakva AFK módba, a visszatéréshez: /back");
	TogglePlayerControllable(playerid, false);
	SetPlayerVirtualWorld(playerid, 1);
	return 1;
}

CMD:back(playerid, params[])
{
	if(GetPVarInt(playerid, "Cuffed") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Bilincsben nem használhatod ezt a parancsot!");
	SendFormatMessageToAll(YELLOW, "*** %s kikapcsolta az AFK módot!", GetPlayerNameEx(playerid));
	SendClientMessage(playerid, YELLOW, "Kilettél szedve az AFK módból!");
	TogglePlayerControllable(playerid, true);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}*/

CMD:goto(playerid, params[])
{
	new userid;
	if(GetPVarInt(playerid, "AJtime") > 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ajailban nem!");
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /goto [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(IsPlayerUnallowedZone(userid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Az illetõ olyan helyen vagy állapotban van, ahol nem használhatod ezt a parancsot rajta!");
    if(IsPlayerUnallowedZone(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Olyan helyen vagy állapotban vagy, ahol nem használhatod ezt a parancsot!");
	SendAdminCMDMessage(playerid, "GOTO", GetPlayerNameEx(userid));

    new Float:x, Float:y, Float:z;
    GetPlayerPos(userid, x, y, z);
    SetPlayerInterior(playerid, GetPlayerInterior(userid));
    if(IsPlayerInAnyVehicle(playerid))
	{
		SetVehiclePos(GetPlayerVehicleID(playerid), x+2, y, z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(userid));
	}
	else SetPlayerPosEx(playerid, x+1, y, z);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Odateleportáltál %s mellé!", GetPlayerNameEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s odateleportált melléd!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:enablejump(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new enab, pd;
	if(sscanf(params, "ui", pd, enab)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /enablejump [pid] [0-1]");
	SetPVarInt(pd, "enablej", enab);
	return 1;
}

CMD:posx(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz;
	if(sscanf(params, "i", pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /posx [mennyiség]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x+pozz, y, z);
	return 1;
}

CMD:posy(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz;
	if(sscanf(params, "i", pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /posy [mennyiség]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y+pozz, z);
	return 1;
}

CMD:posz(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz;
	if(sscanf(params, "i", pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /posz [mennyiség]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z+pozz);
	return 1;
}

CMD:posxp(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz, up;
	if(sscanf(params, "ui", up, pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /posx [pid] [mennyiség]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(up, x, y, z);
	SetPlayerPos(up, x+pozz, y, z);
	return 1;
}

/*CMD:posyp(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz, up;
	if(sscanf(params, "ui", pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /posy [pid] [mennyiség]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(up, x, y, z);
	SetPlayerPos(up, x, y+pozz, z);
	return 1;
}

CMD:poszp(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz, up;
	if(sscanf(params, "ui", up, pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /posz [pid] [mennyiség]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(up, x, y, z);
	SetPlayerPos(up, x, y, z+pozz);
	return 1;
}*/

CMD:get(playerid, params[])
{
	new userid;
	if(GetPVarInt(playerid, "AJtime") > 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ajailban nem!");
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /get [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    if(IsPlayerUnallowedZone(userid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Az illetõ olyan helyen vagy állapotban van, ahol nem használhatod ezt a parancsot rajta!");
    if(IsPlayerUnallowedZone(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Olyan helyen vagy állapotban vagy, ahol nem használhatod ezt a parancsot!");
    SendAdminCMDMessage(playerid, "GET", GetPlayerNameEx(userid));

	new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerInterior(userid, GetPlayerInterior(playerid));
    if(IsPlayerInAnyVehicle(userid))
    {
		SetVehiclePos(GetPlayerVehicleID(userid), x+2, y, z);
		LinkVehicleToInterior(GetPlayerVehicleID(userid), GetPlayerInterior(playerid));
	}
	else SetPlayerPosEx(userid, x+1, y, z);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Magadhoz teleportáltad %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s odateleportált téged magához!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:getall(playerid)
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(!IsPlayerValid(i)) continue;
	    if(playerid == i) continue;
     	if(IsPlayerUnallowedZone(i)) continue;
     	if(IsPlayerUnallowedZone(i)) continue;
	    new Float:x, Float:y, Float:z;
	    GetPlayerPos(playerid, x, y, z);
	    SetPlayerInterior(i, GetPlayerInterior(playerid));
	    if(IsPlayerInAnyVehicle(i))
	    {
			SetVehiclePos(GetPlayerVehicleID(i), x+2, y, z);
			LinkVehicleToInterior(GetPlayerVehicleID(i), GetPlayerInterior(playerid));
		}
		else SetPlayerPosEx(i, x+1, y, z);
		}
	SendFormatMessageToAll(COLOR_YELLOW, "%s Adminisztrátor magához teleportált mindenkit!", GetPlayerNameEx(playerid));
	SendAdminCMDMessage(playerid, "GETALL");
	return 1;
}

CMD:carrespawn(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 1 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[1][0]);
    SendAdminCMDMessage(playerid, "CARRESPAWN");

	for ( new vid = 0; vid < MAX_VEHICLES; vid ++ )
	{
	    if(GetVehicleModel(vid) == 435 || GetVehicleModel(vid) == 450 || GetVehicleModel(vid) == 584) continue;
		if ( !IsVehicleOccupied ( vid ) )
		{
    		SetVehicleToRespawn ( vid );
		}
	}

	SendClientMessageToAll(COLOR_GREEN,"[Auto respawn]* Minden használaton kívüli jármû helyre lett állítva!");
    return 1;
}

CMD:trespawn(playerid)
{
    if(GetPVarInt(playerid, "Level") < 1 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[1][0]);
    SendAdminCMDMessage(playerid, "TRESPAWN");

	for ( new vid = 0; vid < MAX_VEHICLES; vid ++ )
	{
	    if(GetVehicleModel(vid) == 435 || GetVehicleModel(vid) == 450 || GetVehicleModel(vid) == 584)
	    {
    		SetVehicleToRespawn ( vid );
		}
	}

	SendClientMessageToAll(COLOR_GREEN,"[Auto respawn]* Minden plató helyre lett állítva!");
	return 1;
}
//----------------------------Üzenetek/Információk------------------------------------------
CMD:asay(playerid, params[])
{
	new text[128];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /asay [szöveg]");
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	SendFormatMessageToAll(COLOR_SAY, "[Admin] %s: %s", GetPlayerNameEx(playerid), text);

	return 1;
}

CMD:vsay(playerid, params[])
{
	new text[128];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /asay [szöveg]");
	if(GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[6][0]);
	SendFormatMessageToAll(COLOR_SAY, "[VIP] %s: %s", GetPlayerNameEx(playerid), text);

	return 1;
}

CMD:asayy(playerid, params[])
{
	new text[128];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /fasay [szöveg]");
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	SendFormatMessageToAll(COLOR_SAY, "[Admin]: %s", text);

	return 1;
}

CMD:fasay(playerid, params[])
{
	new text[128];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /fasay [szöveg]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendFormatMessageToAll(COLOR_SAY, "[FõAdmin] %s: %s", GetPlayerNameEx(playerid), text);

	return 1;
}

CMD:googlesay(playerid, params[])
{
	new text[128], command[20];
	new string[200];
	if(sscanf(params, "s[20]s[128]", command, text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /hsay [angol/magyar] [szöveg]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(!strcmp(GetPlayerNameEx(playerid), "Austin")) return SendClientMessage(playerid, COLOR_ERROR, "Austin! Te mit képzelsz hogy ilyeneket írogatsz a játékosoknak??"), SendClientMessage(playerid, COLOR_ERROR, "Mi az hogy valaki megkéri hogy hagyd abba, aztán lenézel rá, mert nem tud semmit se tenni..."), SendClientMessage(playerid, COLOR_ERROR, "Örömödre megszabadítalak ettõl a parancsól, és a 4-es adminodtól."), SetPVarInt(playerid, "Level", 3);
	if(!strcmp(command, "angol"))
	{
	    format(string, sizeof(string), "http://translate.google.com/translate_tts?tl=en&q=%s", text);
        for(new i; i < MAX_PLAYERS; i++) PlayAudioStreamForPlayer(i, string);
	}
	else if(!strcmp(command, "magyar"))
	{
	    format(string, sizeof(string), "http://translate.google.com/translate_tts?tl=hu&q=%s", text);
        for(new i; i < MAX_PLAYERS; i++) PlayAudioStreamForPlayer(i, string);
	}
	SendAdminCMDMessage(playerid, "HSAY");
	return 1;
}

CMD:lotto(playerid, params[])
{
	new szamok[5];
	if(GetPVarInt(playerid, "lottozott") == 1) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Te már lottóztál!");
	if(GetPlayerMoneyEx(playerid) < 15000) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Nincs elég pénzed! A lottó 15.000$!");
	if(sscanf(params, "iiiii", szamok[0], szamok[1], szamok[2], szamok[3], szamok[4])) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /lotto [szám1] [szám2] [szám3] [szám4] [szám5]");
    if(1 > szamok[0] || szamok[0] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A számoknak 1 és 99 közt kell lenniük!");
    if(1 > szamok[1] || szamok[1] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A számoknak 1 és 99 közt kell lenniük!");
    if(1 > szamok[2] || szamok[2] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A számoknak 1 és 99 közt kell lenniük!");
    if(1 > szamok[3] || szamok[3] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A számoknak 1 és 99 közt kell lenniük!");
    if(1 > szamok[4] || szamok[4] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A számoknak 1 és 99 közt kell lenniük!");
    if(szamok[0] == szamok[1] || szamok[0] == szamok[2] || szamok[0] == szamok[3] || szamok[0] == szamok[4]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy számot csak egyszer írhatsz!");
    if(szamok[1] == szamok[0] || szamok[1] == szamok[2] || szamok[1] == szamok[3] || szamok[1] == szamok[4]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy számot csak egyszer írhatsz!");
    if(szamok[2] == szamok[0] || szamok[2] == szamok[1] || szamok[2] == szamok[3] || szamok[2] == szamok[4]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy számot csak egyszer írhatsz!");
    if(szamok[3] == szamok[0] || szamok[3] == szamok[1] || szamok[3] == szamok[2] || szamok[3] == szamok[4]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy számot csak egyszer írhatsz!");
    if(szamok[4] == szamok[0] || szamok[4] == szamok[1] || szamok[4] == szamok[2] || szamok[4] == szamok[3]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy számot csak egyszer írhatsz!");
	lszamok[0][playerid] = szamok[0];
	lszamok[1][playerid] = szamok[1];
	lszamok[2][playerid] = szamok[2];
	lszamok[3][playerid] = szamok[3];
	lszamok[4][playerid] = szamok[4];
	SendFormatMessage(playerid, COLOR_GREEN, #HLIME#"Lottózás sikeres. Számok:"#HYELLOW#" %d, %d, %d, %d, %d", szamok[0], szamok[1], szamok[2], szamok[3], szamok[4]);
	SetPVarInt(playerid, "lottozott", 1);
	GivePlayerMoneyEx(playerid, -15000);
	return 1;
}

CMD:ad(playerid, params[])
{
	new text[200];
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /ad [szöveg]");
    if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem írhatsz a chatbe ha levagy némítva!");
	    WarnReason(playerid, "Beszéd némítás alatt", "SYSTEM");
	    return 0;
	}
	new iNums, pont;
	for( new x = 0; x < strlen( text ); ++x )
	{
		if( text[ x ] < '0' || text[ x ] > '9' ) continue;
		++iNums;
	}
	for(new i; i < strlen(text); i++)
	{
	    if(text[i] != '.') continue;
	    pont++;
	}
	if( iNums > 8 )
	{
	    if(pont >= 3)
	    {
			KickReason(playerid, "Hirdetés", "SYSTEM");
			return 1;
		}
	}

	SendFormatMessageToAll(DEEPBLUE, "[HIRDETÉS] %s! Feladó: %s, /pm %d", text, GetPlayerNameEx(playerid), playerid);
	
	new ev, honap, nap;
	new hour, minut, secu;
	getdate(ev, honap, nap);
	gettime(hour, minut, secu);
	new esctext[128];
	mysql_real_escape_string(text, esctext);
	format(query, sizeof(query), "INSERT INTO chatlog (Name, Text, Type, Date) VALUES ('%s', '%s', 'ADVERTISEMENT', '%d/%02d/%02d %02d:%02d:%02d')", GetPlayerNameEx(playerid), esctext, ev, honap, nap, hour, minut, secu);
	mysql_query(query);
	return 1;
}

CMD:me(playerid, params[])
{
	new me[128];
	if(sscanf(params, "s[128]", me)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /me [szöveg]");
    if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem írhatsz a chatbe ha levagy némítva!");
	    WarnReason(playerid, "Beszéd némítás alatt", "SYSTEM");
	    return 0;
	}
	SendFormatMessageToAll(0xf54fdcAA, "%s %s", GetPlayerNameEx(playerid), me);
	return 1;
}

CMD:announce(playerid, params[])
{
	new text[128];
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /announce [szöveg]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    SendAdminCMDMessage(playerid, "ANNOUNCE");

	GameTextForAll(FixGameString(text), 5*1000, 4);
	SendFormatMessageToAll(COLOR_ASAY, "%s képernyõ üzenete: %s", GetPlayerNameEx(playerid), text);

    return 1;
}

CMD:clearchat(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    SendAdminCMDMessage(playerid, "CLEARCHAT");

	for(new i; i < 60; i++) SendClientMessageToAll(WHITE, "");
	for(new i; i < MAX_PLAYERS; i++) PlaySound(i, 1057);
	GameTextForAll(FixGameString("~r~Chat megtisztítva!"), 4000, 4);

    return 1;
}

CMD:pmshow(playerid)
{
	if(GetPVarInt(playerid, "Logged") == 0) return 1;
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(GetPVarInt(playerid, "pmshow") == 0)
	{
	    SetPVarInt(playerid, "pmshow", 1);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostmár látod mindenki PM-ét!");
	    SendAdminCMDMessage(playerid, "PMSHOW ON");
	}
	else if(GetPVarInt(playerid, "pmshow") == 1)
	{
 		SetPVarInt(playerid, "pmshow", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostmár nem látod más PM-ét, csak a sajátjaidat!");
	    SendAdminCMDMessage(playerid, "PMSHOW OFF");
	}
	return 1;
}

CMD:tshow(playerid)
{
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(GetPVarInt(playerid, "tshow") == 0)
	{
	    SetPVarInt(playerid, "tshow", 1);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostmár látod a teamchat-et!");
	    SendAdminCMDMessage(playerid, "TSHOW ON");
	}
	else if(GetPVarInt(playerid, "tshow") == 1)
	{
 		SetPVarInt(playerid, "tshow", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostmár nem látod más teamchat-jét!");
	    SendAdminCMDMessage(playerid, "TSHOW OFF");
	}
	return 1;
}

CMD:hiddedpmshow(playerid)
{
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(GetPVarInt(playerid, "pmshow") == 0)
	{
	    SetPVarInt(playerid, "pmshow", 1);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostmár látod mindenki PM-ét!");
	}
	else if(GetPVarInt(playerid, "pmshow") == 1)
	{
 		SetPVarInt(playerid, "pmshow", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostmár nem látod más PM-ét, csak a sajátjaidat!");
	}
	return 1;
}

CMD:hiddedtshow(playerid)
{
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(GetPVarInt(playerid, "tshow") == 0)
	{
	    SetPVarInt(playerid, "tshow", 1);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostmár látod a teamchat-et!");
	}
	else if(GetPVarInt(playerid, "tshow") == 1)
	{
 		SetPVarInt(playerid, "tshow", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostmár nem látod más teamchat-jét!");
	}
	return 1;
}

CMD:pm(playerid, params[])
{
	new userid,message[128];
	if(sscanf(params, "us[128]",userid,message)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /pm [playerid/játékosid] [szöveg]");
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
	if(playerid==userid) return SendClientMessage(playerid, COLOR_ERROR, Errors[1][0]);
	if(GetPVarInt(userid, "pmtilt") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ez a játékos letiltotta a PM fogadást!");
	if(strlen(message) > 128) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: A PM szövege túl hosszú!");
	if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem írhatsz a chatbe ha levagy némítva!");
	    WarnReason(playerid, "Beszéd némítás alatt", "SYSTEM");
	    return 0;
	}
	
	#if defined ANTIFLOOD
	KillTimer(antiflood_t[playerid]);
	antiflood_t[playerid] = SetTimerEx("antifloodtimer", MAX_FLOODT * 1000, 0, "i", playerid);
	SetPVarInt(playerid, "anti-flood", GetPVarInt(playerid, "anti-flood")+1);
	if(GetPVarInt(playerid, "anti-flood") >= MAX_FLOOD)
	{
	    WarnReason(playerid, "Flood", "SYSTEM");
	    SetPVarInt(playerid, "anti-flood", 0);
	    KillTimer(antiflood_t[playerid]);
	}
	#endif

	new iNums, pont;
	for( new x = 0; x < strlen( message ); ++x )
	{
		if( message[ x ] < '0' || message[ x ] > '9' ) continue;
		++iNums;
	}
	for(new i; i < strlen(message); i++)
	{
	    if(message[i] != '.') continue;
	    pont++;
	}
	if( iNums > 8 )
	{
	    if(pont >= 3)
	    {
			KickReason(playerid, "Hirdetés", "SYSTEM");
			return 0;
		}
	}

	LastPM[userid] = playerid;

	SendFormatMessage(playerid, COLOR_PM_KI, "[ PM ]: %s (%d): %s", GetPlayerNameEx(userid), userid, message);
	SendFormatMessage(userid, COLOR_PM_BE, "[ PM ]: %s (%d): %s", GetPlayerNameEx(playerid), playerid, message);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPVarInt(i, "Level") > 1 || IsPlayerAdminEx(i))
	    {
	        if(GetPVarInt(i, "pmshow") == 1)
	        {
	            if(i != playerid && i != userid)
	            {
	                SendFormatMessage(i, COLOR_PMSHOW, "[ PM ] %s(%d)-tól %s(%d)-nek: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(userid), userid, message);
	            }
			}
	    }
	}

	for( new i = 0; i < sizeof(cenzuralt); i++)
	{
		if(strfind(message, cenzuralt[i][0], true) != -1)
		{
		    SetTimerEx("karomkodas", 2000, 0, "i", playerid);
			return 1;
		}
	}
	printf("PM: %s-tõl, %s-nek: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid), message);
	PlayerPlaySound(userid,1085,0.0,0.0,0.0);
	
	new ev, honap, nap;
	new hour, minut, secu;
	getdate(ev, honap, nap);
	gettime(hour, minut, secu);
	new esctext[128];
	mysql_real_escape_string(message, esctext);
	format(query, sizeof(query), "INSERT INTO chatlog (Name, Text, ForName, Type, Date) VALUES ('%s', '%s', '%s', 'PM', '%d/%02d/%02d %02d:%02d:%02d')", GetPlayerNameEx(playerid), esctext, GetPlayerNameEx(userid), ev, honap, nap, hour, minut, secu);
	mysql_query(query);
    return 1;
}

CMD:r(playerid, params[])
{
	new message[128];
	if(sscanf(params, "s[128]",message)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /r [szöveg]");
	if(LastPM[playerid]==255) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Még senki nem küldött neked PM-et");
    if(!IsPlayerValid(LastPM[playerid])) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
   	if(GetPVarInt(LastPM[playerid], "pmtilt") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ez a játékos letiltotta a PM fogadást!");
    if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem írhatsz a chatbe ha levagy némítva!");
	    WarnReason(playerid, "Beszéd némítás alatt", "SYSTEM");
	    return 0;
	}

    new iNums, pont;
	for( new x = 0; x < strlen( message ); ++x )
	{
		if( message[ x ] < '0' || message[ x ] > '9' ) continue;
		++iNums;
	}
	for(new i; i < strlen(message); i++)
	{
	    if(message[i] != '.') continue;
	    pont++;
	}
	if( iNums > 8 )
	{
	    if(pont >= 3)
	    {
			KickReason(playerid, "Hirdetés", "SYSTEM");
			return 0;
		}
	}

	SendFormatMessage(playerid, COLOR_PM_KI, "[ PM ]: %s (%d): %s", GetPlayerNameEx(LastPM[playerid]), LastPM[playerid], message);
	SendFormatMessage(LastPM[playerid], COLOR_PM_BE, "[ PM ]: %s (%d): %s", GetPlayerNameEx(playerid), playerid, message);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPVarInt(i, "Level") > 1 || IsPlayerAdminEx(i))
	    {
	        if(GetPVarInt(i, "pmshow") == 1)
	        {
	            if(i != playerid && i != LastPM[playerid])
	            {
	                SendFormatMessage(i, COLOR_PMSHOW, "[ PM ] %s(%d)-tól %s(%d)-nek: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(LastPM[playerid]), LastPM[playerid], message);
	            }
			}
	    }
	}

	for( new i = 0; i < sizeof(cenzuralt); i++)
	{
		if(strfind(message, cenzuralt[i][0], true) != -1)
		{
		    SetTimerEx("karomkodas", 2000, 0, "i", playerid);
			return 1;
		}
	}

	printf("PM: %s-tõl, %s-nek: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(LastPM[playerid]), message);
	PlayerPlaySound(LastPM[playerid],1085,0.0,0.0,0.0);

    new ev, honap, nap;
	new hour, minut, secu;
	getdate(ev, honap, nap);
	gettime(hour, minut, secu);
	new esctext[128];
	mysql_real_escape_string(message, esctext);
	format(query, sizeof(query), "INSERT INTO chatlog (Name, Text, ForName, Type, Date) VALUES ('%s', '%s', '%s', 'PM', '%d/%02d/%02d %02d:%02d:%02d')", GetPlayerNameEx(playerid), esctext, GetPlayerNameEx(LastPM[playerid]), ev, honap, nap, hour, minut, secu);
	mysql_query(query);
    return 1;
}

CMD:pmtilt(playerid)
{
	if(GetPVarInt(playerid, "pmtilt") == 0)
	{
	    SetPVarInt(playerid, "pmtilt", 1);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostantól nem tud PM-et küldeni neked senki!");
	}
	else if(GetPVarInt(playerid, "pmtilt") == 1)
	{
	    SetPVarInt(playerid, "pmtilt", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostantól megint tudnak neked PM-et küldeni!");
	}
	return 1;
}

CMD:vote(playerid, params[])
{
	new szavazas1[128];
	if(sscanf(params, "s[128]", szavazas1)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /vote [igennel vagy nemmel megválaszolható kérdés]");
	if(GetGVarInt("VoteRunning") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Már folyamatban van egy szavazás!");
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);

	SetGVarInt("VoteRunning", 1);
	SetTimer("VoteTimer", 1*60*1000, false);
	SetGVarString("VoteKerdes", szavazas1);

	SendFormatMessageToAll(COLOR_ADMINMSG, "[ Szavazas ]: %s elindított egy szavazást: %s!", GetPlayerNameEx(playerid), szavazas1);
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /igen /nem parancsokkal tudsz!");
	return 1;
}

CMD:igen(playerid, params[])
{
	new string[200];
	if(GetGVarInt("VoteRunning") == 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs folyamatban szavazás!");
	if(GetPVarInt(playerid, "IsPlayerVoted") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Te már szavaztál!");

	SetGVarInt("VoteIgen", GetGVarInt("VoteIgen")+1);
	SetPVarInt(playerid, "IsPlayerVoted", 1);

	new szavazas1[128];
	GetGVarString("VoteKerdes", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "[ Szavazás ]: %s!", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "A szavazás jelenlegi állása: %d igen és %d nem.", GetGVarInt("VoteIgen"), GetGVarInt("VoteNem"));
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /igen /nem parancsokkal tudsz!");
	format(string, sizeof(string), "[ Szavazás ]: %s igennel szavazott!", GetPlayerNameEx(playerid));
	SendClientMessageToAdmins(COLOR_ADMINMSG, string);

	return 1;
}

CMD:nem(playerid, params[])
{
	new string[200];
	if(GetGVarInt("VoteRunning") == 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs folyamatban szavazás!");
	if(GetPVarInt(playerid, "IsPlayerVoted") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Te már szavaztál!");

	SetGVarInt("VoteNem", GetGVarInt("VoteNem")+1);
	SetPVarInt(playerid, "IsPlayerVoted", 1);

	new szavazas1[128];
	GetGVarString("VoteKerdes", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "[ Szavazás ]: %s!", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "A szavazás jelenlegi állása: %d igen és %d nem.", GetGVarInt("VoteIgen"), GetGVarInt("VoteNem"));
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /igen /nem parancsokkal tudsz!");
	format(string, sizeof(string), "[ Szavazás ]: %s nemmel szavazott!", GetPlayerNameEx(playerid));
	SendClientMessageToAdmins(COLOR_ADMINMSG, string);
	return 1;
}

CMD:zigen(playerid, params[])
{
	new string[200];
	if(GetGVarInt("ZeneVoteRunning") == 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs folyamatban zene szavazás!");
	if(GetPVarInt(playerid, "IsPlayerZeneVoted") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Te már szavaztál!");

	SetGVarInt("zeneigen", GetGVarInt("zeneigen")+1);
	SetPVarInt(playerid, "IsPlayerZeneVoted", 1);
	SetPVarInt(playerid, "zenekell", 1);

	SendFormatMessageToAll(COLOR_ADMINMSG, "A zene szavazás jelenlegi állása: %d igen és %d nem.", GetGVarInt("zeneigen"), GetGVarInt("zenenem"));
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /zigen /znem parancsokkal tudsz!");
	format(string, sizeof(string), "[ Szavazás ]: %s igennel szavazott!", GetPlayerNameEx(playerid));
	SendClientMessageToAdmins(COLOR_ADMINMSG, string);

	return 1;
}

CMD:znem(playerid, params[])
{
	new string[200];
	if(GetGVarInt("ZeneVoteRunning") == 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs folyamatban zene szavazás!");
	if(GetPVarInt(playerid, "IsPlayerZeneVoted") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Te már szavaztál!");

	SetGVarInt("zenenem", GetGVarInt("zenenem")+1);
	SetPVarInt(playerid, "IsPlayerZeneVoted", 1);
	SetPVarInt(playerid, "zenekell", 2);

	SendFormatMessageToAll(COLOR_ADMINMSG, "A zene szavazás jelenlegi állása: %d igen és %d nem.", GetGVarInt("zeneigen"), GetGVarInt("zenenem"));
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /zigen /znem parancsokkal tudsz!");
	format(string, sizeof(string), "[ Szavazás ]: %s nemmel szavazott!", GetPlayerNameEx(playerid));
	SendClientMessageToAdmins(COLOR_ADMINMSG, string);
	return 1;
}

forward VoteTimer();
public VoteTimer()
{
	new szavazas1[128];
	GetGVarString("VoteKerdes", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "A '%s' kérdésel indított szavazás befejezõdött!", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "A szavazás eredménye: %d igen és %d nem.", GetGVarInt("VoteIgen"), GetGVarInt("VoteNem"));
	SetGVarInt("VoteRunning", 0);
	SetGVarInt("VoteIgen", 0);
	SetGVarInt("VoteNem", 0);

	for(new i; i < MAX_PLAYERS; i++) SetPVarInt(i, "IsPlayerVoted", 0);
	return 1;
}

forward ZeneVote();
public ZeneVote()
{
	SendClientMessageToAll(COLOR_ADMINMSG, "A zene szavazás befejezõdött!");
	SendFormatMessageToAll(COLOR_ADMINMSG, "A szavazás eredménye: %d igen és %d nem.", GetGVarInt("zeneigen"), GetGVarInt("zenenem"));
	SetGVarInt("ZeneVoteRunning", 0);
	SetGVarInt("zeneigen", 0);
	SetGVarInt("zenenem", 0);
	new link[250];
	GetGVarString("Link", link);
	for(new i; i < MAX_PLAYERS; i++) if(GetPVarInt(i, "zenekell") == 1) PlayAudioStreamForPlayer(i, link), SetPVarInt(i, "zenekell", 0);

	for(new i; i < MAX_PLAYERS; i++) SetPVarInt(i, "IsPlayerZeneVoted", 0);
}

CMD:zenefogad(playerid)
{
	if(GetPVarInt(playerid, "zenetbiral") == 0) return 1;
	StopAudioStreamForPlayer(playerid);
	SendClientMessage(playerid, COLOR_GREEN, "A zene felkerült a listára.");
	SetPVarInt(playerid, "zenetbiral", 0);
	new link[250], nev[100];
    GetPVarString(playerid, "birallink", link, sizeof(link));
    GetPVarString(playerid, "biralnev", nev, sizeof(nev));
    format(query, sizeof(query), "DELETE FROM zenelistav WHERE Nev = '%s' AND Link = '%s'", nev, link);
    mysql_query(query);
    format(query, sizeof(query), "INSERT INTO zene (ID, Nev, Link) VALUES (0, '%s', '%s')", nev, link);
    mysql_query(query);
	return 1;
}

CMD:zenetorol(playerid)
{
	if(GetPVarInt(playerid, "zenetbiral") == 0) return 1;
	StopAudioStreamForPlayer(playerid);
	SendClientMessage(playerid, COLOR_GREEN, "A zene nem felkerült a listára.");
	SetPVarInt(playerid, "zenetbiral", 0);
	new link[250], nev[100];
    GetPVarString(playerid, "birallink", link, sizeof(link));
    GetPVarString(playerid, "biralnev", nev, sizeof(nev));
    format(query, sizeof(query), "DELETE FROM zenelistav WHERE Nev = '%s' AND Link = '%s'", nev, link);
    mysql_query(query);
	return 1;
}
//----------------------------------Csíterfelügyelet----------------------------------
CMD:slap(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /slap [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 1 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[1][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SLAP", GetPlayerNameEx(userid));

    if(GetPVarInt(userid, "aslap") != 1)
    {
		new Float:x, Float:y, Float:z;
	    GetPlayerPos(userid, x, y, z);
		SetPlayerPosEx(userid, x, y, z+10);
	}

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen feldobtad %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s feldobott téged!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:setskin(playerid, params[])
{
	new userid, skinid;
	if(sscanf(params, "ui", userid, skinid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /setskin [playerid/játékosnév] [skinid]");
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
	if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
	SendAdminCMDMessage(playerid, "SETSKIN", GetPlayerNameEx(userid));

	SetPlayerSkin(userid, skinid);
	SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen megváltoztattad %s skinjét [Új skin: %d]", GetPlayerNameEx(userid), skinid);
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s megváltoztatta a skined [Új skin: %d]", GetPlayerNameEx(playerid), skinid);
	return 1;
}

CMD:disarm(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /disarm [playerid/játékosnév]");
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
	if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
	SendAdminCMDMessage(playerid, "DISARM", GetPlayerNameEx(userid));

	SetPlayerArmour(userid, 0);
	ResetPlayerWeapons(userid);
    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen lefegyverezted %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s lefegyverzett téged!", GetPlayerNameEx(playerid));
	return 1;
}

CMD:mute(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /mute [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "MUTE", GetPlayerNameEx(userid));

	SetPVarInt(userid, "Mute", 1);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen lenémítottad %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s lenémított téged!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:muteall(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    SendAdminCMDMessage(playerid, "MUTEALL");

	for(new i; i < MAX_PLAYERS; i++)
	{
		if(i == playerid) continue;
		SetPVarInt(i, "Mute", 1);
	}

    SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s mindenkit lenémított!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:unmuteall(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    SendAdminCMDMessage(playerid, "UNMUTEALL");

	for(new i; i < MAX_PLAYERS; i++)
	{
		SetPVarInt(i, "Mute", 0);
	}

    SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s feloldotta mindenki némítását!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:unmute(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /unmute [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "UNMUTE", GetPlayerNameEx(userid));

	SetPVarInt(userid, "Mute", 0);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen feloldottad %s némítását!", GetPlayerNameEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s feloldotta a némításodat!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:antiakill(playerid, params[])
{
    new userid, aaa;
	if(sscanf(params, "ui", userid, aaa)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /antiakill [playerid/játékosnév] [szám]");
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);

	SetPVarInt(userid, "aakill", aaa);
	return 1;
}

CMD:antislap(playerid, params[])
{
    new userid, aaa;
	if(sscanf(params, "ui", userid, aaa)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /antoslap [playerid/játékosnév] [szám]");
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);

	SetPVarInt(userid, "aslap", aaa);
	return 1;
}

CMD:akill(playerid, params[])
{
	new userid;
	if(GetPVarInt(playerid, "AJtime") > 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ajailban nem!");
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /akill [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "AKILL", GetPlayerNameEx(userid));

	if(GetPVarInt(userid, "aakill") != 1) SetPlayerHealth(userid, 0);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen megölted %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s megölt téged!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:freeze(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /freeze [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "FREEZE", GetPlayerNameEx(userid));

	TogglePlayerControllable(userid,0);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen lefagyasztottad %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s lefagyasztott téged!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:unfreeze(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /unfreeze [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "UNFREEZE", GetPlayerNameEx(userid));

	TogglePlayerControllable(userid,1);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen feloldottad %s fagyasztását!", GetPlayerNameEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s feloldotta a fagyasztásodat!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:spectateteszt(playerid, params[])
{
    new specplayerid;
	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /spectate [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(specplayerid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == specplayerid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A játékos nincs spawnolva!");
    SendAdminCMDMessage(playerid, "SPECTATE", GetPlayerNameEx(specplayerid));

    TogglePlayerSpectating(playerid, 1);
	PlayerSpectatePlayer(playerid, specplayerid, SPECTATE_MODE_SIDE);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdtél spectálni!");
	return 1;
}

CMD:spectateteszt2(playerid, params[])
{
    new specplayerid;
	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /spectate [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(specplayerid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == specplayerid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A játékos nincs spawnolva!");
    SendAdminCMDMessage(playerid, "SPECTATE", GetPlayerNameEx(specplayerid));

    TogglePlayerSpectating(playerid, 1);
	PlayerSpectatePlayer(playerid, specplayerid, SPECTATE_MODE_FIXED);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdtél spectálni!");
	return 1;
}

CMD:spectate(playerid, params[])
{
	#if defined ENABLE_SPECTATE
	new specplayerid;
	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /spectate [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(specplayerid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == specplayerid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A játékos nincs spawnolva!");
    SendAdminCMDMessage(playerid, "SPECTATE", GetPlayerNameEx(specplayerid));

	StartSpectate(playerid, specplayerid);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdtél spectálni!");
	return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spectálás le van tiltva! Írj egy Fõ Adminisztrátornak.");
	return 1;
    #endif
}

CMD:silencedspectate(playerid, params[])
{
	#if defined ENABLE_SPECTATE
	new specplayerid;
	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /spectate [playerid/játékosnév]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(specplayerid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == specplayerid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A játékos nincs spawnolva!");

	StartSpectate(playerid, specplayerid);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdtél spectálni!");
	return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spectálás le van tiltva! Írj egy Fõ Adminisztrátornak.");
	return 1;
    #endif
}

CMD:spectateveh(playerid, params[])
{
	#if defined ENABLE_SPECTATE
	new specvehicleid;
	if(sscanf(params, "u", specvehicleid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /spectateveh [jármûid]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
//	if(specvehicleid >= MAX_VEHICLES) return SendClientMessage(playerid,COLOR_ERROR, "[HIBA]: Érvénytelen jármû ID!");
	SendAdminCMDMessage(playerid, "SPECTATEVEH");

	TogglePlayerSpectating(playerid, 1);
	PlayerSpectateVehicle(playerid, specvehicleid);
	Spec[playerid][SpectateID] = specvehicleid;
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdtél spectálni!");
	Spec[playerid][SpectateType] = ADMIN_SPEC_TYPE_VEHICLE;
	return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spectálás le van tiltva! Írj egy Fõ Adminisztrátornak.");
	return 1;
    #endif
}

CMD:spectateoff(playerid, params[])
{
	#if defined ENABLE_SPECTATE
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(Spec[playerid][SpectateType] == ADMIN_SPEC_TYPE_NONE) return SendClientMessage(playerid,COLOR_ERROR, "[HIBA]: Eddig sem spectáltál senkit!");
    SendAdminCMDMessage(playerid, "SPECTATEOFF");

	StopSpectate(playerid);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen abbahagytad a spectálást!");
    return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spectálás le van tiltva! Írj egy Fõ Adminisztrátornak.");
	return 1;
    #endif
}

CMD:silencedspectateoff(playerid, params[])
{
	#if defined ENABLE_SPECTATE
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(Spec[playerid][SpectateType] == ADMIN_SPEC_TYPE_NONE) return SendClientMessage(playerid,COLOR_ERROR, "[HIBA]: Eddig sem spectáltál senkit!");

	StopSpectate(playerid);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen abbahagytad a spectálást!");
    return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spectálás le van tiltva! Írj egy Fõ Adminisztrátornak.");
	return 1;
    #endif
}

CMD:report(playerid, params[])
{
    new message[128], reason, id;
    if(sscanf(params, "is[128]", id, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /report [ID] [panasz]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
 	format(message, sizeof(message), "[ REPORT ]: %s (%d) Panasza %s(%d)-re: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(id), id, reason);
	SendClientMessageToAdmins(COLOR_REPORT, message);

	SendClientMessage(playerid, COLOR_REPORT, "[ REPORT ]: Panaszod elküldve az adminoknak!");
	return 1;
}

CMD:maxping(playerid, params[])
{
	new maxping;
	if(sscanf(params, "i", maxping)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /maxping [Maximális Ping]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	SetGVarInt("MaxPing", maxping);

	SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s megváltoztatta a maximális ping értékét! [ Új érték: %d ]", GetPlayerNameEx(playerid), GetGVarInt("MaxPing"));
	return 1;
}

CMD:warn(playerid, params[])
{
    new warnedid, reason[128];
    if(sscanf(params, "us[128]", warnedid, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /warn [playerid/játékosnév] [indok]");
    if(GetPVarInt(playerid, "Level") < 1 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[1][0]);
	if(!IsPlayerValid(warnedid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
	if(playerid == warnedid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
	if(GetPVarInt(playerid, "Level") < GetPVarInt(warnedid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "WARN", GetPlayerNameEx(warnedid));
	WarnReason(warnedid, reason, GetPlayerNameEx(playerid));
    return 1;
}

CMD:kick(playerid, params[])
{
    new kickedid, reason[128];
    if(sscanf(params, "us[128]", kickedid, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /kick [playerid/játékosnév] [indok]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(!IsPlayerValid(kickedid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
	if(playerid == kickedid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(!strcmp(GetPlayerNameEx(kickedid), "Ryuuzaki")) return SendClientMessage(playerid, COLOR_ERROR, "Próbálkozunk?");
	if(GetPVarInt(playerid, "Level") < GetPVarInt(kickedid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "KICK", GetPlayerNameEx(kickedid));
	KickReason(kickedid, reason, GetPlayerNameEx(playerid));
    return 1;
}

/*CMD:votekick(playerid, params[])
{
	if(GetGVarInt("VoteKickStarted") == 0)
	{
	    new kickedid, reason[128];
	    if(sscanf(params, "us[128]", kickedid, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /votekick [playerid/játékosnév] [indok]");
        if(GetPVarInt(playerid, "Level") < 1 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "Csak Adminok indíthatnak votekick szavazást!");
		if(!IsPlayerValid(kickedid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
		if(playerid == kickedid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
		if(GetPVarInt(playerid, "Level") < GetPVarInt(kickedid, "Level") && !IsPlayerAdminEx(playerid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);

		SetPVarInt(playerid, "VotedToKick", 1);

		SetPVarInt(kickedid, "KickVotes", 1);
		SetGVarInt("VoteKickStarted", 1);
		SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: Egy kirúgási szavazás indult %s ellen! [ Indok: %s ]", GetPlayerNameEx(kickedid), reason);
		SendClientMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: Ahoz hogy szavazz írd be a /votekick parancsot!");
	}
	else if(GetGVarInt("VoteKickStarted") == 1)
	{
		for(new i; i < MAX_PLAYERS; i++)
  		{
  		    if(GetPVarInt(i, "KickVotes") > 0)
  		    {
  		        if(GetPVarInt(playerid, "VotedToKick") == 0)
  		        {
	                SetPVarInt(playerid, "VotedToKick", 1);

	  		        SetPVarInt(i, "KickVotes", GetPVarInt(i, "KickVotes")+1);
	  		        SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: Újabb szavazat érkezett %s ellen! [ Szavazatok: %d/%d ]", GetPlayerNameEx(i), GetPVarInt(i, "KickVotes"), VOTEKICK_VOTES);

					if(GetPVarInt(i, "KickVotes") == VOTEKICK_VOTES)
					{
					    SetGVarInt("VoteKickStarted", 0);
					    KickReason(i, "Sikeres kiszavazás", "SYSTEM");

	                    for(new z; z < MAX_PLAYERS; z++) SetPVarInt(z, "VotedToKick", 0);
					}
				}
  		    }
		}
	}
    return 1;
}*/

CMD:passwordban(playerid, params[])
{
    new playername[24];
    if(sscanf(params, "s[24]",playername)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /passwordban [játékosnév]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(!strcmp(playername, "Ryuuzaki")) return SendClientMessage(playerid, COLOR_ERROR, "Próbálkozunk?");
	//SendAdminCMDMessage(playerid, "PASSWORDBAN");

	format(query, sizeof(query), "SELECT Password FROM users WHERE Name = '%s'", playername);
	mysql_query(query);
	mysql_store_result();
	if(mysql_num_rows() != 0)
	{
	    new password[145];
	    mysql_fetch_row(linen);
	    sscanf(linen, "s[145]", password);
	    mysql_free_result();
		format(query, sizeof(query), "SELECT * FROM Passwordban WHERE Password = '%s'", password);
		mysql_query(query);
		mysql_store_result();
		if(mysql_num_rows() == 0)
		{
			format(query, sizeof(query), "INSERT INTO Passwordban (Name, Password) VALUES ('%s', '%s')", playername, password);
			mysql_query(query);
			format(query, sizeof(query), "UPDATE users SET IP = '255.255.255.255' WHERE Password = '%s'", password);
			mysql_query(query);
		}
		else SendClientMessage(playerid, COLOR_RED, "Ilyen jelszó már banolva van!");
	}
	else SendClientMessage(playerid, COLOR_RED, "Ilyen név nem található az adatbázisban!");
    return 1;
}

CMD:ban(playerid, params[])
{
    new bannedid, reason[200];
    if(sscanf(params, "us[128]", bannedid, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /ban [playerid/játékosnév] [indok]");
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(!IsPlayerValid(bannedid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
	if(playerid == bannedid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
	if(!strcmp(GetPlayerNameEx(bannedid), "Ryuuzaki")) return SendClientMessage(playerid, COLOR_ERROR, "Próbálkozunk?");
	if(GetPVarInt(playerid, "Level") < GetPVarInt(bannedid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
	SendAdminCMDMessage(playerid, "BAN", GetPlayerNameEx(bannedid));
	BanReason(bannedid, reason, GetPlayerNameEx(playerid));
    return 1;
}


CMD:repair(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "Nem vagy jármûben!");
	SendAdminCMDMessage(playerid, "REPAIR");
	RepairVehicle(GetPlayerVehicleID(playerid));
    return 1;
}

//------------------------Mod, filterscript kezelés---------------------------------
/*CMD:loadfs(playerid, params[])
{
    new scriptname[64], command[128];
    if(sscanf(params, "s[64]", scriptname)) return SendClientMessage(playerid,COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /loadfs [scriptnév]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendAdminCMDMessage(playerid, "LOADFS");
	format(command, sizeof(command), "loadfs %s", scriptname);
	SendRconCommand(command);
    return 1;
}

CMD:unloadfs(playerid, params[])
{
    new scriptname[64], command[128];
    if(sscanf(params, "s[64]", scriptname)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /unloadfs [scriptnév]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendAdminCMDMessage(playerid, "UNLOADFS");
	format(command, sizeof(command), "unloadfs %s", scriptname);
	SendRconCommand(command);
    return 1;
}

CMD:reloadfs(playerid, params[])
{
    new scriptname[64], command[128];
    if(sscanf(params, "s[64]", scriptname)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /reloadfs [scriptnév]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendAdminCMDMessage(playerid, "RELOADFS");
	format(command, sizeof(command), "reloadfs %s", scriptname);
	SendRconCommand(command);
    return 1;
}

CMD:changemode(playerid, params[])
{
    new scriptname[64], command[128];
    if(sscanf(params, "s[64]", scriptname)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /changemode [modnév]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendAdminCMDMessage(playerid, "CHANGEMODE");
	format(command, sizeof(command), "changemode %s", scriptname);
	SendRconCommand(command);
    return 1;
}
*/
CMD:saveplayers(playerid)
{
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	for(new i; i < MAX_PLAYERS; i++)
	{
		if(GetPVarInt(i, "Logged") == 1)
		{
			SavePlayer(i);
		}
	}
	SendClientMessageToAll(COLOR_GREEN, "Játékos adatok elmentve!");
	return 1;
}

CMD:healall(playerid)
{
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    PlaySound(i, 1057);
	    SetPlayerHealth(i, 100);
	}
	SendFormatMessageToAll(COLOR_YELLOW, "%s Adminisztrátor feltöltötte mindenki életét!", GetPlayerNameEx(playerid));
	return 1;
}

/*CMD:armourall(playerid)
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    PlaySound(i, 1057);
	    SetPlayerArmour(i, 100);
	}
	SendFormatMessageToAll(COLOR_YELLOW, "%s Adminisztrátor feltöltötte mindenki páncélját!", GetPlayerNameEx(playerid));
	SendAdminCMDMessage(playerid, "ARMOURALL");
	return 1;
}

CMD:aheal(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /aheal [id/névrészlet]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(id)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
    PlaySound(id, 1057);
    SetPlayerHealth(id, 100);
    SendAdminCMDMessage(playerid, "AHEAL");
	return 1;
}

CMD:aarmour(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /aarmour [id/névrészlet]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(id)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
    PlaySound(id, 1057);
    SetPlayerArmour(id, 100);
    SendAdminCMDMessage(playerid, "AARMOUR");
	return 1;
}*/

//------------------------------Idõjárás, idõ---------------------------------
CMD:weather(playerid, params[])// /weather [weatherid]
{
    new weatherid;
    if(sscanf(params, "i", weatherid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /weather [idõjárás id]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
 	SendAdminCMDMessage(playerid, "WEATHER");
	SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s megváltoztatta az idõjárást! Az új idõjárás ID-je: %d", GetPlayerNameEx(playerid), weatherid);
	SetWeather(weatherid);
    return 1;
}

CMD:time(playerid, params[])// /time [hour]
{
    new time;
    if(sscanf(params, "i", time)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /time [óra]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[5][0]);
    SendAdminCMDMessage(playerid, "TIME");
	SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s megváltoztatta az idõt! Az új idõ: %d óra", GetPlayerNameEx(playerid), time);
	SetWorldTime(time);
	new hour;
	gettime(hour);
	if(hour == time) SetGVarInt("time", 0);
	else SetGVarInt("time", 1);
    return 1;
}

CMD:gravity(playerid, params[])// /gravity [gravity]
{
    new Float:gravity;
    if(sscanf(params, "f", gravity)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /gravity [gravity]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    SendAdminCMDMessage(playerid, "GRAVITY");
  	SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s megváltoztatta az gravitációt! Az új gravitáció értéke: %f ", GetPlayerNameEx(playerid), gravity);
	SetGravity(gravity);
    return 1;
}

CMD:pos(playerid, params[])
{
	new Float:px2, Float:py2, Float:pz2;
	if(GetPVarInt(playerid, "AJtime") > 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ajailban nem!");
	if(sscanf(params, "fff", px2, py2, pz2)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /pos [x] [y] [z]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    SetPlayerPosEx(playerid, px2, py2, pz2);
	return 1;
}

CMD:inti(playerid, params[])
{
	new inti;
 	if(!IsPlayerAdminEx(playerid)) return 0;
	if(sscanf(params, "i", inti)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /inti [inti]");
    SetPlayerInterior(playerid, inti);
	return 1;
}

CMD:vw(playerid, params[])
{
	new vw;
 	if(!IsPlayerAdminEx(playerid)) return 0;
	if(sscanf(params, "i", vw)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /vw [vw]");
    SetPlayerVirtualWorld(playerid, vw);
	return 1;
}

CMD:destroycar(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem vagy jármûben!");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	DestroyVehicle(GetPlayerVehicleID(playerid));
	return 1;
}

CMD:destroycarwithid(playerid, params[])
{
	new veid;
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "i", veid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZNÁLAT ]: /destroycarwithid [ID]");
	DestroyVehicle(veid);
	return 1;
}

/*for( new i = 0; i < sizeof(cenzuralt); i++)
	{
		if(strfind(text, cenzuralt[i][0], true) != -1)
		{
			WarnReason(playerid, "modera", "SYSTEM");
			return 1;
		}
	}*/

CMD:apanel(playerid)
{
	for(new i; i < sizeof(adminok); i++)
	{
	    if(!strcmp(GetPlayerNameEx(playerid), adminok[i][0], true) || GetPVarInt(playerid, "Level") >= 1 || IsPlayerAdminEx(playerid))
	    {
			ShowPlayerDialog(playerid, APANEL_DIALOG, DIALOG_STYLE_LIST, "Admin panel", "Event system\nZene szavazás\nZenék\nFenyõfa felállítása\nFenyõfa leszedése\nZene elfogadása\nHavazás bekapcsolása\nHavazás kikapcsolása", "Választ", "Kilép");
		}
	}
	return 1;
}

/*CMD:unnepbe(playerid)
{
	if(!IsPlayerAdmin(playerid)) return 0;
	if(unnep == true) return 1;
	CreateChristmasSomething(0, -2080.5388,296.5176,69.7900); // disz1
	CreateChristmasSomething(1, -1923.3220,453.5707,35.1719); // disz2
	CreateChristmasSomething(2, -1753.8500,885.6790,295.8750); // disz3
	CreateChristmasSomething(3, -1706.6021,992.7996,17.9141); // disz4
	CreateChristmasSomething(4, -2584.0354,662.6799,28.0998); // disz5
	CreateChristmasSomething(5, -2708.0408,378.0713,11.9795); // disz6
	CreateChristmasSomething(6, -2718.3784,-319.8792,57.4873); // disz7
	CreateChristmasSomething(7, -1845.6290,3.1681,89.1641); // disz8
	CreateChristmasSomething(8, -1606.4376,20.0642,32.0469); // disz9
	CreateChristmasSomething(9, -1480.3425,920.1096,71.3504); // disz10
	CreateChristmasSomething(10, -2162.7288,462.3548,111.8750); // disz11
	CreateChristmasSomething(11, -1790.8965,567.7830,332.8047); // disz12
	return 1;
}

CMD:unnepki(playerid)
{
    if(!IsPlayerAdmin(playerid)) return 0;
    if(unnep == false) return 1;
	DeleteChristmasSomething();
	return 1;
}*/

CMD:zene(playerid)
{
	ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zenék", "Rádiók\nZenék listája\nKeresés a listában\nZene indítás MP3 linkrõl\nZene beküldése\nZene leállítása\nInformáció", "Kiválaszt", "Kilép");
	return 1;
}

CMD:addzene(playerid, params[])
{
	new nev[40], link[250];
	if(!IsPlayerAdminEx(playerid)) return 0;
	if(sscanf(params, "s[250]s[40]", link, nev)) return SendClientMessage(playerid, COLOR_GREEN, "Használat: /addzene [link] [név]");
	format(query, sizeof(query), "INSERT INTO zene (ID, Nev, Link) VALUES (0, '%s', '%s')", nev, link);
	mysql_query(query);
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    new Float:acn[3];
	GetPlayerPos(playerid, acn[0], acn[1], acn[2]);
    SetPVarFloat(playerid, "acoX", acn[0]);
	SetPVarFloat(playerid, "acoY", acn[1]);
	SetPVarFloat(playerid, "acoZ", acn[2]);
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
	{
	  	new Float:acn[3];
		GetPlayerPos(playerid, acn[0], acn[1], acn[2]);
	    SetPVarFloat(playerid, "acoX", acn[0]);
		SetPVarFloat(playerid, "acoY", acn[1]);
		SetPVarFloat(playerid, "acoZ", acn[2]);
	}
    #if defined ENABLE_SPECTATE
    new vehicleid;
	vehicleid = GetPlayerVehicleID(playerid);
    for(new x=0; x<MAX_PLAYERS; x++)
    {
        if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid && Spec[x][SpectateType] == ADMIN_SPEC_TYPE_VEHICLE)
        {
			if(GetPlayerState(playerid) == PLAYER_STATE_NONE)
			{
			    StopSpectate(x);
			}
		}
	}

 	for(new x=0; x<MAX_PLAYERS; x++)
    {
        if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid && Spec[x][SpectateType] == ADMIN_SPEC_TYPE_VEHICLE)
        {
			if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
			{
        		TogglePlayerSpectating(x, 1);
	        	PlayerSpectatePlayer(x, playerid);
         		Spec[x][SpectateType] = ADMIN_SPEC_TYPE_PLAYER;
			}
		}
	}

	for(new x=0; x<MAX_PLAYERS; x++)
    {
    	if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid)
        {
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
			{
   				TogglePlayerSpectating(x, 1);
	        	PlayerSpectateVehicle(x, vehicleid);
	        	Spec[x][SpectateType] = ADMIN_SPEC_TYPE_VEHICLE;
			}
		}
	}

	for(new x=0; x<MAX_PLAYERS; x++)
    {
        if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid)
        {
			if(GetPlayerState(playerid) == PLAYER_STATE_WASTED)
			{
	       		AdvanceSpectate(x);
	       	}
		}
	}
	#endif
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    if(GetPVarInt(playerid, "Logged") == 0)
    {
        format(query, sizeof(query), "SELECT * FROM users WHERE Name = '%s'" , GetPlayerNameEx(playerid));
        mysql_query(query);
        mysql_store_result();
        if(mysql_num_rows() == 0) ShowPlayerDialog(playerid, REGISTER_DIALOG, DIALOG_STYLE_INPUT , "Regisztráció", "Ez a név még nincs regisztrálva!\nKérlek írj be egy jelszót a regisztrációhoz!\n", "Regisztráció", "Kilépés");
        else ShowPlayerDialog(playerid, LOGIN_DIALOG, DIALOG_STYLE_INPUT , "Bejelentkezés", "Ez a név regisztrálva van!\nKérlek jelentkezz be!", "Bejelentkezés", "Kilépés");
        return 0;
    }
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	SetPVarInt(playerid, "acInterc", 1);
	#if defined ENABLE_SPECTATE
    for(new x=0; x<MAX_PLAYERS; x++)
	{
 		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid && Spec[x][SpectateType] == ADMIN_SPEC_TYPE_VEHICLE && GetGVarInt("ModType") != 4 || GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid && Spec[x][SpectateType] == ADMIN_SPEC_TYPE_PLAYER)
        {
   		    SetPlayerInterior(x,newinteriorid);
		}
	}
	#endif
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	#if defined ENABLE_SPECTATE
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Spec[playerid][SpectateID] != INVALID_PLAYER_ID)
	{
		if(newkeys == KEY_LEFT) AdvanceSpectate(playerid);
		else if(newkeys == KEY_RIGHT) ReverseSpectate(playerid);
	}
	#endif
	if(PRESSED(KEY_JUMP) && HOLDING(KEY_SPRINT))
	{
	    if(GetPVarInt(playerid, "enablej") == 1)
	    {
		    SetTimerEx("jumptimer", 300, 0, "i", playerid);
		}
	}
	/*if(PRESSED(KEY_LOOK_BEHIND))
	{
	    if(GetPlayerWeapon(playerid) == 33)
	    {
		    if(GetPVarInt(playerid, "aws") == 3) SetPVarInt(playerid, "aws", 1), SendClientMessage(playerid, COLOR_GREEN, "Teleportálás");
		    else if(GetPVarInt(playerid, "aws") == 1) SetPVarInt(playerid, "aws", 2), SendClientMessage(playerid, COLOR_GREEN, "Robbantás");
		    else if(GetPVarInt(playerid, "aws") == 2) SetPVarInt(playerid, "aws", 3), SendClientMessage(playerid, COLOR_GREEN, "Vonzás");
		}
	}*/
	return 1;
}

forward jumptimer(playerid);
public jumptimer(playerid)
{
    new Float:jx, Float:jy, Float:jz;
    GetPlayerPos(playerid, jx, jy, jz);
    GetXYInFrontOfPlayer(playerid, jx, jy, 2);
    SetPlayerPos(playerid, jx, jy, jz);
}

public OnRconLoginAttempt(ip[], password[], success)
{
	new pip[16], rconstr[128];
	if(success == 0)
	{
	    for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		  	GetPlayerIp(i, pip, sizeof(pip));
		  	if(!strcmp(ip, pip, true))
			{
			    format(rconstr, sizeof(rconstr), "%s megpróbált belépni az Rcon-ba", GetPlayerNameEx(i));
			    SendClientMessageToAll(COLOR_RED, rconstr);
			    break;
			}
		}
	}
	if(success == 1)
	{
		for(new i = 0; i < MAX_PLAYERS; i++)
  		{
		  	GetPlayerIp(i, pip, sizeof(pip));
		  	if(!strcmp(ip, pip, true))
			{
  				ShowPlayerDialog(i, DIALOG_RCONLOGIN, DIALOG_STYLE_PASSWORD, "Te tényleg tudod az Rcon-t? hm...", "És ezt a jelszavat is?", "Ja, tudom", "");
			}
		}
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        new Float:vec[3];
        GetPlayerCameraFrontVector(playerid, vec[0], vec[1], vec[2]);
        new bool:possible_crasher = false;
        for (new i = 0; !possible_crasher && i < sizeof(vec); i++)
            if (floatabs(vec[i]) > 10.0)
                possible_crasher = true;

        if (possible_crasher)
            return 0; //do not send fake data, prevents crash
    }
    #if defined ENABLE_SPECTATE
	new CurVirtualWorld[MAX_PLAYERS];
	CurVirtualWorld[playerid] = GetPlayerVirtualWorld(playerid);
    if(CurVirtualWorld[playerid] != CurrentVirtualWorld[playerid])
    {
        OnPlayerVirtualWorldChange(playerid, CurVirtualWorld[playerid], CurrentVirtualWorld[playerid]);
        CurrentVirtualWorld[playerid] = CurVirtualWorld[playerid];
    }
    #endif
    if (GetPVarInt(playerid, "laser") == 1)
	{
        RemovePlayerAttachedObject(playerid, 0);
        if ((IsPlayerInAnyVehicle(playerid)) || (IsPlayerInWater(playerid))) return 1;
        switch (GetPlayerWeapon(playerid))
		{
            case 23:
			{
	            if (IsPlayerAiming(playerid))
				{
                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6,  0.108249, 0.030232, 0.118051, 1.468254, 350.512573, 364.284240);
                    }
					else
					{
						SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.108249, 0.030232, 0.118051, 1.468254, 349.862579, 364.784240);
                    }
                }
				else
				{
                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
                    }
					else
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.078248, 0.027239, 0.113051, -11.131746, 350.602722, 362.384216);
					}
				}
			}
			case 30:
			{
                if (IsPlayerAiming(playerid))
				{
                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.628249, -0.027766, 0.078052, -6.621746, 352.552642, 355.084289);
                    }
					else
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.628249, -0.027766, 0.078052, -1.621746, 356.202667, 355.084289);
                    }
                }
				else
				{
                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
                    }
					else
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.663249, -0.02976, 0.080051, -11.131746, 358.302734, 353.384216);
					}
				}
			}
			case 31:
			{
                if (IsPlayerAiming(playerid))
				{
                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.528249, -0.020266, 0.068052, -6.621746, 352.552642, 355.084289);
                    }
					else
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.528249, -0.020266, 0.068052, -1.621746, 356.202667, 355.084289);
                    }
                }
				else
				{
                    if (GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_DUCK)
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
                    }
					else
					{
                        SetPlayerAttachedObject(playerid, 8, 18643, 6, 0.503249, -0.02376, 0.065051, -11.131746, 357.302734, 354.484222);
					}
				}
			}
		}
	}

	#if defined WEAPONBODY
	if(GetTickCount() - armedbody_pTick[playerid] > 113){ //prefix check itter
            new
                    weaponid[13],weaponammo[13],pArmedWeapon;
            pArmedWeapon = GetPlayerWeapon(playerid);
            GetPlayerWeaponData(playerid,1,weaponid[1],weaponammo[1]);
            GetPlayerWeaponData(playerid,2,weaponid[2],weaponammo[2]);
            GetPlayerWeaponData(playerid,4,weaponid[4],weaponammo[4]);
            GetPlayerWeaponData(playerid,5,weaponid[5],weaponammo[5]);
            #if ARMEDBODY_USE_HEAVY_WEAPON
            GetPlayerWeaponData(playerid,7,weaponid[7],weaponammo[7]);
            #endif
            if(weaponid[1] && weaponammo[1] > 0){
                    if(pArmedWeapon != weaponid[1]){
                            if(!IsPlayerAttachedObjectSlotUsed(playerid,0)){
                                if(weaponid[1] != 9){
                                    SetPlayerAttachedObject(playerid,0,GetWeaponModel(weaponid[1]),1, 0.199999, -0.139999, 0.030000, 0.500007, -115.000000, 0.000000, 1.000000, 1.000000, 1.000000);
								}
							}
                    }
                    else {
                            if(IsPlayerAttachedObjectSlotUsed(playerid,0)){
                                    RemovePlayerAttachedObject(playerid,0);
                            }
                    }
            }
            else if(IsPlayerAttachedObjectSlotUsed(playerid,0)){
                    RemovePlayerAttachedObject(playerid,0);
            }
            if(weaponid[2] && weaponammo[2] > 0){
                    if(pArmedWeapon != weaponid[2]){
                            if(!IsPlayerAttachedObjectSlotUsed(playerid,1)){
                                    SetPlayerAttachedObject(playerid,1,GetWeaponModel(weaponid[2]),8, -0.079999, -0.039999, 0.109999, -90.100006, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                            }
                    }
                    else {
                            if(IsPlayerAttachedObjectSlotUsed(playerid,1)){
                                    RemovePlayerAttachedObject(playerid,1);
                            }
                    }
            }
            else if(IsPlayerAttachedObjectSlotUsed(playerid,1)){
                    RemovePlayerAttachedObject(playerid,1);
            }
            if(weaponid[4] && weaponammo[4] > 0){
                    if(pArmedWeapon != weaponid[4]){
                            if(!IsPlayerAttachedObjectSlotUsed(playerid,2)){
                                    SetPlayerAttachedObject(playerid,2,GetWeaponModel(weaponid[4]),7, 0.000000, -0.100000, -0.080000, -95.000000, -10.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                           }
                   }
                    else {
                            if(IsPlayerAttachedObjectSlotUsed(playerid,2)){
                                    RemovePlayerAttachedObject(playerid,2);
                            }
                    }
            }
            else if(IsPlayerAttachedObjectSlotUsed(playerid,2)){
                    RemovePlayerAttachedObject(playerid,2);
            }
            if(weaponid[5] && weaponammo[5] > 0){
                    if(pArmedWeapon != weaponid[5]){
                            if(!IsPlayerAttachedObjectSlotUsed(playerid,3)){
                                    SetPlayerAttachedObject(playerid,3,GetWeaponModel(weaponid[5]),1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                            }
                    }
                    else {
                            if(IsPlayerAttachedObjectSlotUsed(playerid,3)){
                                    RemovePlayerAttachedObject(playerid,3);
                            }
                    }
            }
            else if(IsPlayerAttachedObjectSlotUsed(playerid,3)){
                    RemovePlayerAttachedObject(playerid,3);
            }
            #if ARMEDBODY_USE_HEAVY_WEAPON
            if(weaponid[7] && weaponammo[7] > 0){
                    if(pArmedWeapon != weaponid[7]){
                            if(!IsPlayerAttachedObjectSlotUsed(playerid,4)){
                                    SetPlayerAttachedObject(playerid,4,GetWeaponModel(weaponid[7]),1,-0.100000, 0.000000, -0.100000, 84.399932, 112.000000, 10.000000, 1.099999, 1.000000, 1.000000);
                            }
                    }
                    else {
                            if(IsPlayerAttachedObjectSlotUsed(playerid,4)){
                                    RemovePlayerAttachedObject(playerid,4);
                            }
                    }
            }
            else if(IsPlayerAttachedObjectSlotUsed(playerid,4)){
                    RemovePlayerAttachedObject(playerid,4);
            }
            #endif
            armedbody_pTick[playerid] = GetTickCount();
    }
    #endif
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == EGYEZES_DIALOG)
	{
	    if(response)
	    {
	        SetPVarInt(playerid, "egyezesoldal", GetPVarInt(playerid, "egyezesoldal")+1);
	        new egyip[30], egyjelszo[145];
	        GetPVarString(playerid, "tovabbiegyip", egyip, sizeof(egyip));
	        GetPVarString(playerid, "tovabbiegyjelszo", egyjelszo, sizeof(egyjelszo));
			if(GetPVarInt(playerid, "egyezesoldal") == 2) format(query, sizeof(query), "SELECT Name, IP, Banned FROM users WHERE IP = '%s' OR Password = '%s' ORDER BY Name ASC LIMIT 15, 15", egyip, egyjelszo);
			if(GetPVarInt(playerid, "egyezesoldal") == 3) format(query, sizeof(query), "SELECT Name, IP, Banned FROM users WHERE IP = '%s' OR Password = '%s' ORDER BY Name ASC LIMIT 30, 15", egyip, egyjelszo);
			if(GetPVarInt(playerid, "egyezesoldal") == 4) format(query, sizeof(query), "SELECT Name, IP, Banned FROM users WHERE IP = '%s' OR Password = '%s' ORDER BY Name ASC LIMIT 45, 15", egyip, egyjelszo);
			if(GetPVarInt(playerid, "egyezesoldal") == 5) format(query, sizeof(query), "SELECT Name, IP, Banned FROM users WHERE IP = '%s' OR Password = '%s' ORDER BY Name ASC LIMIT 60, 15", egyip, egyjelszo);
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() != 0)
			{
			    new egyezestr[1000];
				while(mysql_fetch_row(linen))
				{
					new ips[30], nevs[24], bani;
					sscanf(linen, "p<|>s[24]s[30]d", nevs, ips, bani);
				    if(bani == 0) format(egyezestr, sizeof(egyezestr), "%s{00FFFF}%s \t\t{ffffff}[IP cím: %s]\n", egyezestr, nevs, ips);
					else if(bani == 1) format(egyezestr, sizeof(egyezestr), "%s"#HRED#"%s \t\t{ffffff}[IP cím: %s]\n", egyezestr, nevs, ips);
				}
				mysql_free_result();
				ShowPlayerDialog(playerid, EGYEZES_DIALOG, DIALOG_STYLE_MSGBOX, "Találatok", egyezestr, "További találatok", "Kilép");
			}
			else SendClientMessage(playerid, COLOR_RED, "Nincs találat.");
		}
	}
	if(dialogid == MYACHIE_DIALOG)
	{
		if(response)
		{
		    new bool:achies[20];
		    if(GetAchievement(playerid, "elsohaz") == 1) achies[0] = true;
		    if(GetAchievement(playerid, "elsokocsi") == 1) achies[1] = true;
		    if(GetAchievement(playerid, "elsobiz") == 1) achies[2] = true;
		    if(GetAchievement(playerid, "leaderesm") == 1) achies[3] = true;
		    if(GetAchievement(playerid, "elsoclantag") == 1) achies[4] = true;
		    if(GetAchievement(playerid, "elsoclan") == 1) achies[5] = true;

            if(GetAchievement(playerid, "horgaszat") >= 50) achies[6] = true;
			if(GetAchievement(playerid, "horgaszat") >= 100) achies[7] = true;
			
			if(GetAchievement(playerid, "reakcio") >= 50) achies[8] = true;
			if(GetAchievement(playerid, "reakcio") >= 100) achies[9] = true;
			
			if(GetAchievement(playerid, "Ora") >= 10) achies[10] = true;
			if(GetAchievement(playerid, "Ora") >= 50) achies[11] = true;
			if(GetAchievement(playerid, "Ora") >= 100) achies[12] = true;
			if(GetAchievement(playerid, "Ora") >= 200) achies[13] = true;
			
			if(GetAchievement(playerid, "area") >= 10) achies[14] = true;
			if(GetAchievement(playerid, "area") >= 30) achies[15] = true;
			if(GetAchievement(playerid, "area") >= 50) achies[16] = true;
			
			if(GetAchievement(playerid, "Kills") >= 50) achies[17] = true;
			if(GetAchievement(playerid, "Kills") >= 100) achies[18] = true;
			if(GetAchievement(playerid, "Kills") >= 300) achies[19] = true;

		    format(dstring, sizeof(dstring), #HWHITE#"Elsõ ház megvétele: %s\nElsõ jármû megvétele: %s\nElsõ biznisz megvétele: %s\n\
			Elsõ leaderes munkatagság: %s\nElsõ klántagság: %s\nElsõ klán alapítása: %s\n\
			50 hal kifogása: %s(%02d/50)\n100 hal kifogása: %s(%02d/100)\n\
			50 reakcióteszt megoldása: %s(%02d/50)\n100 reakcióteszt megoldása: %s(%02d/100)\n\
			10 játszott óra: %s\n50 játszott óra: %s\n100 játszott óra: %s\n200 játszott óra: %s\n",
			(achies[0]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ ház
			(achies[1]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ jármû
			(achies[2]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ biznisz
			(achies[3]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //ELsõ leaderes meló
			(achies[4]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ klántagság
			(achies[5]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ klán
			(achies[6]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 horgászat
			(achies[6]) ? (50) : (GetAchievement(playerid, "horgaszat")),
			(achies[7]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 horgászat
			(achies[7]) ? (100) : (GetAchievement(playerid, "horgaszat")),
			(achies[8]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 reakció
			(achies[8]) ? (50) : (GetAchievement(playerid, "reakcio")),
			(achies[9]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 reakció
			(achies[9]) ? (100) : (GetAchievement(playerid, "reakcio")),
            (achies[10]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#),
            (achies[11]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#),
            (achies[12]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#),
            (achies[13]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#));
            
			format(dstring, sizeof(dstring), "%s10 elfoglalt terület: %s(%02d/10)\n30 elfoglalt terület: %s(%02d/30)\n50 elfoglalt terület: %s(%02d/50)\n\
			50 ölés: %s(%02d/50)\n100 ölés: %s(%02d/100)\n300 ölés: %s(%02d/300)\n", dstring,
			(achies[14]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //10 terület
			(achies[14]) ? (10) : (GetAchievement(playerid, "area")),
			(achies[15]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //30 terület
			(achies[15]) ? (30) : (GetAchievement(playerid, "area")),
			(achies[16]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 terület
			(achies[16]) ? (50) : (GetAchievement(playerid, "area")),
			(achies[17]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 ölés
			(achies[17]) ? (50) : (GetAchievement(playerid, "Kills")),
			(achies[18]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 ölés
			(achies[18]) ? (100) : (GetAchievement(playerid, "Kills")),
			(achies[19]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //300 ölés
			(achies[19]) ? (300) : (GetAchievement(playerid, "Kills")));

			ShowPlayerDialog(playerid, MYACHIE_DIALOG, DIALOG_STYLE_MSGBOX, "Achievementek", dstring, "Tovább", "Kilép");
		}
	}
	if(dialogid == ACHIE_DIALOG)
	{
	    if(response)
	    {
     		new bool:achies[20];
		    if(GetAchievement(GetPVarInt(playerid, "achcmd"), "elsohaz") == 1) achies[0] = true;
		    if(GetAchievement(GetPVarInt(playerid, "achcmd"), "elsokocsi") == 1) achies[1] = true;
		    if(GetAchievement(GetPVarInt(playerid, "achcmd"), "elsobiz") == 1) achies[2] = true;
		    if(GetAchievement(GetPVarInt(playerid, "achcmd"), "leaderesm") == 1) achies[3] = true;
		    if(GetAchievement(GetPVarInt(playerid, "achcmd"), "elsoclantag") == 1) achies[4] = true;
		    if(GetAchievement(GetPVarInt(playerid, "achcmd"), "elsoclan") == 1) achies[5] = true;

            if(GetAchievement(GetPVarInt(playerid, "achcmd"), "horgaszat") >= 50) achies[6] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "horgaszat") >= 100) achies[7] = true;
			
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "reakcio") >= 50) achies[8] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "reakcio") >= 100) achies[9] = true;
			
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "Ora") >= 10) achies[10] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "Ora") >= 50) achies[11] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "Ora") >= 100) achies[12] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "Ora") >= 200) achies[13] = true;
			
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "area") >= 10) achies[14] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "area") >= 30) achies[15] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "area") >= 50) achies[16] = true;
			
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "Kills") >= 50) achies[17] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "Kills") >= 100) achies[18] = true;
			if(GetAchievement(GetPVarInt(playerid, "achcmd"), "Kills") >= 300) achies[19] = true;

		    format(dstring, sizeof(dstring), #HWHITE#"Elsõ ház megvétele: %s\nElsõ jármû megvétele: %s\nElsõ biznisz megvétele: %s\n\
			Elsõ leaderes munkatagság: %s\nElsõ klántagság: %s\nElsõ klán alapítása: %s\n\
			50 hal kifogása: %s\n100 hal kifogása: %s\n\
			50 reakcióteszt megoldása: %s\n100 reakcióteszt megoldása: %s\n\
			10 játszott óra: %s\n50 játszott óra: %s\n100 játszott óra: %s\n200 játszott óra: %s\n",
			(achies[0]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ ház
			(achies[1]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ jármû
			(achies[2]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ biznisz
			(achies[3]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //ELsõ leaderes meló
			(achies[4]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ klántagság
			(achies[5]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //Elsõ klán
			(achies[6]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 horgászat
			(achies[7]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 horgászat
			(achies[8]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 reakcióteszt
			(achies[9]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 reakcióteszt
			(achies[10]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#),
            (achies[11]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#),
            (achies[12]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#),
            (achies[13]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#));
            
            format(dstring, sizeof(dstring), "%s10 elfoglalt terület: %s\n30 elfoglalt terület: %s\n50 elfoglalt terület: %s\n\
			50 ölés: %s\n100 ölés: %s\n300 ölés: %s\n", dstring,
			(achies[14]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //10 terület
			(achies[15]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //30 terület
			(achies[16]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 terület
			(achies[17]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //50 ölés
			(achies[18]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#), //100 ölés
			(achies[19]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lezárva"#HWHITE#)); //300 ölés
	    
	        new achst[50];
			format(achst, sizeof(achst), "%s Achievementjei", GetPlayerNameEx(GetPVarInt(playerid, "achcmd")));
			ShowPlayerDialog(playerid, ACHIE_DIALOG, DIALOG_STYLE_MSGBOX, achst, dstring, "Tovább", "Kilép");
	    }
	}
	if(dialogid == DIALOG_JATEK1)
	{
	    if(response)
	    {
			new dialogstr[812];
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
		    "A levélben ez áll:\n",
		    "Aki ezt a levelet megtalálja a segítségére van szükségem. Én vagyok az aki minden évben megajándékoz titeket.\n",
		    "Azonban ma rossz dolog történt. Éppen mentem a következõ város felé, és történt egy kis gubanc a szánhúzóimmal.\n",
		    "Akkor nem vettem észre hogy az összes ajándékomat elejtettem valahol és a gond hogy nem tudom hol.\n",
		    "Ha igazán segíteni akarsz nekem és egy kis kincskeresésre vágysz akkor találkozzunk azon a helyen ahol a töltények vannak...\n",
		    "De nem a polcokon, a földön. Tehát gyere el ide és elmondom személyesen a következõ lépéseket.\n\n",
		    "Aláírás: Egy kövér, hosszú szakálas, kedves ember");
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Levél", dialogstr, "Oké", "");
		}
	}
	if(dialogid == DIALOG_JATEK2)
	{
	    new dialogstr[512];
	    if(response)
	    {
	        new astr[128];

			CallRemoteFunction("GiveEXPpublic", "ii", playerid, 4000);
	        
	        GivePlayerMoneyEx(playerid, 5000000);
	        
			SetPVarInt(playerid, "laser", 1);
			GivePlayerWeapon(playerid, 31, 100);
			GivePlayerWeapon(playerid, 23, 50);
			
		    if(GetPlayerSkin(playerid) == 30) SetPlayerAttachedObject( playerid, 5, 19066, 2, 0.135741, -0.00, 0.0, 194.897018, 97.656661, 266.509033, 1.000000, 1.000000, 1.000000 ); // SantaHat3 - sapka
			else SetPlayerAttachedObject( playerid, 5, 19066, 2, 0.128741, 0.014756, 0.008071, 194.897018, 97.656661, 266.509033, 1.000000, 1.000000, 1.000000 );
			playersapka[playerid] = true;
	        
	        for(new i; i < 500; i++)
	        {
	            format(query, sizeof(query), "SELECT * FROM cars WHERE slot = '%d'", i);
				mysql_query(query);
				mysql_store_result();
				if(mysql_num_rows() == 0)
				{
					mysql_free_result();
			        format(query, sizeof(query), "INSERT INTO cars (slot, Tulaj, Tarstulaj, VehID, X, Y, Z, A, color1, color2, paintjob) VALUES (%d, '%s', 'Nincs', 495, -1638.1663,1210.3090,6.8343,224.9642, 1, 1, 5)", i, GetPlayerNameEx(playerid));
		 			mysql_query(query);
		 			break;
				}
			}
	        
	        format(astr, sizeof(astr), "[HÍR!!!] %s megtalálta az elveszett ajándékokat és elfogadta a jutalmat!", GetPlayerNameEx(playerid));
			SendClientMessageToAdmins(COLOR_ASAY, astr);
			DeleteChristmasGames();
			for(new i; i < 19; i++) DestroyDynamicObject(ajiobjectek[i]);
			DestroyDynamicObject(ajikapu);
			
			format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
	        "Hát akkor nagyon sok boldog karácsonyt kívánok neked fiam!\n",
	        "Találtál:\n",
	        "- 4000EXP\n",
	        "- 5.000.000$\n",
	        "- MEGLEPETÉS sapka\n",
	        "- Lézer + hozzá fegyverek\n",
	        "- Egy autó vár rád a Ryuuzaki's cars elõtt! (Ha nem lenne ott kérj carrespawn-t)");
	        ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Üzenet", dialogstr, "Oké", "");
	    }
	    if(!response)
	    {
	        new astr[128];
	        ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Üzenet", "Érdekes hogy így döntöttél. Mint mondtam nincs vissza. Boldog karácsonyt!", "Oké", "");
	        format(astr, sizeof(astr), "[HÍR!!!] %s megtalálta az elveszett ajándékokat de nem fogadta el a jutalmat!", GetPlayerNameEx(playerid));
			SendClientMessageToAdmins(COLOR_ASAY, astr);
	    }
	}
	if(dialogid == DIALOG_RCONLOGIN)
	{
	    if(strcmp(inputtext, "pongo"))
	    {
	        Kick(playerid);
	    }
	    SetPVarInt(playerid, "IsPlayerAdminEx", 1);
	}
	if(dialogid == REGISTER_DIALOG)
	{
		if(!response)
        {
        	//SetPVarInt(playerid, "NotRegistered", 1);
			ShowPlayerDialog(playerid, REGISTER_DIALOG, DIALOG_STYLE_INPUT , "Regisztráció", "Ez a név még nincs regisztrálva!\nKérlek írj be egy jelszót a regisztrációhoz!\n", "Regisztráció", "Kilépés");
		}
		if(response)
		{
            if(strlen(inputtext) < 4 || strlen(inputtext) > 20)
            {
                ShowPlayerDialog(playerid, REGISTER_DIALOG, DIALOG_STYLE_INPUT , "Regisztráció", "A jelszónak hosszának 4 és 20 karakter között kell lennie!", "Regisztráció", "Kilépés");
				return 0;
			}
            new IP[50];
            GetPlayerIp(playerid, IP, sizeof(IP));
            new Hash[145];
			WP_Hash(Hash, sizeof(Hash), inputtext);
			format(query, sizeof(query), "SELECT * FROM Passwordban WHERE Password = '%s'", Hash);
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() != 0)
			{
				Kick(playerid);
			}
			format(query, sizeof(query), "INSERT INTO users (ID, Name, Password, IP, Money, Bank, Kills, Deaths, Level, Team, Skin, RendorTP, Spawn, Banned, Ora, Perc, Leader, AJtime, KatonaTP, Sskin) VALUES (0, '%s', '%s', '%s', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)", GetPlayerNameEx(playerid), Hash, IP);
            mysql_query(query);
            format(query, sizeof(query), "INSERT INTO skills (Name, Skillpoints) VALUES ('%s', 1)", GetPlayerNameEx(playerid));
            mysql_query(query);
            format(query, sizeof(query), "INSERT INTO achievements (Name) VALUES ('%s')", GetPlayerNameEx(playerid));
			mysql_query(query);
			//format(query, sizeof(query), "INSERT INTO usersp (ID, Name, Password) VALUES (0, '%s', '%s')", GetPlayerNameEx(playerid), inputtext);
			//mysql_query(query);
			
			SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZNÁLÓ ]: Sikeresen regisztráltál így automatikusan bejelentkeztél!");

			SetPVarInt(playerid, "skillpoints", 1);
			SetPVarInt(playerid, "Logged", 1);
		 	elteltt[playerid] = SetTimerEx("elteltido", 60000, 1, "i", playerid);
            GivePlayerMoneyEx(playerid, 100000);
		}
	}
	else if(dialogid == LOGIN_DIALOG)
	{
		if(!response) ShowPlayerDialog(playerid, LOGIN_DIALOG, DIALOG_STYLE_INPUT , "Bejelentkezés", "Ez a név regisztrálva van!\nKérlek jelentkezz be!", "Bejelentkezés", "Kilépés");
	    if(response)
	    {
	        new Hash[145];
			WP_Hash(Hash, sizeof(Hash), inputtext);
			format(query, sizeof(query), "SELECT * FROM Passwordban WHERE Password = '%s'", Hash);
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() != 0)
			{
				Kick(playerid);
			}
           	format(query, sizeof(query), "SELECT * FROM users WHERE Name = '%s' AND Password = '%s'", GetPlayerNameEx(playerid), Hash);
           	mysql_query(query);
           	mysql_store_result();
	        if(mysql_num_rows() != 1)
	        {
                new passtext[128];
				SetPVarInt(playerid, "WrongPass", GetPVarInt(playerid, "WrongPass") + 1);
				if(GetPVarInt(playerid, "WrongPass") == MAX_FAIL_LOGINS) return KickReason(playerid, "Sikertelen bejelentkezés!", "SYSTEM");
               	format(passtext, sizeof(passtext), "[ FELHASZNÁLÓ ]: A beírt jelszó hibás!\nMég van %d próbálkozási lehetõséged!", MAX_FAIL_LOGINS-GetPVarInt(playerid, "WrongPass"));
               	ShowPlayerDialog(playerid, LOGIN_DIALOG, DIALOG_STYLE_INPUT , "Bejelentkezés", passtext, "Bejelentkezés", "Kilépés");
   			}
			else
			{
   				mysql_fetch_row(linen);
				new data2[22];
				new adminpvar[64];
				new clanpvar[30];
				sscanf(linen, "p<|>{ds[24]s[145]s[30]}ddddddddddddd{ds[128]}dddd{s[50]}ds[30]dddd{s[128]s[50]}",
				data2[0],//Money
				data2[1],//Bank
				data2[2],//Kills
				data2[3],//Deaths
				data2[4],//Level
				data2[5],//Team
				data2[6],//Skin
				data2[7],//RendorTP
				data2[8],//KatonaTP
				data2[9],//BankosTP
				data2[10],//KamrovidTP
				data2[11],//KamhosszuTP
				data2[12],//Spawnhely
				data2[13],//Ora
				data2[14],//Perc
				data2[15],//Leader
				data2[16],//AJtime
				data2[17],//Sskin
				clanpvar,//Clan
				data2[18],//ClanRank
				data2[19],//VIP
				data2[20],//Szint
				data2[21]);//EXP
	            GivePlayerMoneyEx(playerid, data2[0]);
	            SetPVarInt(playerid, "Bank", data2[1]);
				SetPVarInt(playerid, "Kills", data2[2]);
				SetPVarInt(playerid, "Deaths", data2[3]);
				SetPVarInt(playerid, "Level", data2[4]);
				cSetPlayerTeam(playerid, data2[5]);
				SetPVarInt(playerid, "Skin", data2[6]);
				SetPVarInt(playerid, "RendorTP", data2[7]);
				SetPVarInt(playerid, "KatonaTP", data2[8]);
				SetPVarInt(playerid, "BankosTP", data2[9]);
				SetPVarInt(playerid, "KamrovidTP", data2[10]);
				SetPVarInt(playerid, "KamhosszuTP", data2[11]);
				SetPVarInt(playerid, "Spawnhely", data2[12]);
				SetPVarInt(playerid, "Ora", data2[13]);
				SetPVarInt(playerid, "Perc", data2[14]);
				SetPVarInt(playerid, "Leader", data2[15]);
				SetPVarInt(playerid, "AJtime", data2[16]);
				SetPVarInt(playerid, "Sskin", data2[17]);
				SetPVarString(playerid, "Clan", clanpvar);
				SetPVarInt(playerid, "ClanRank", data2[18]);
				SetPVarInt(playerid, "VIP", data2[19]);
				SetPVarInt(playerid, "Szint", data2[20]);
				SetPVarInt(playerid, "EXP", data2[21]);
				
				if(GetPVarInt(playerid, "AJtime") > 1) SetPVarInt(playerid, "ajon", 1);
				switch(GetPVarInt(playerid, "Level"))//az adminszintekhez tartozó megnevezés változóba írása
				{
				    case 1: SetPVarString(playerid, "AdminRang", "Moderátor");
					case 2: SetPVarString(playerid, "AdminRang", "Kezdõ Adminisztrátor");
					case 3: SetPVarString(playerid, "AdminRang", "Haladó Adminisztrátor");
					case 4: SetPVarString(playerid, "AdminRang", "Fõ Adminisztrátor");
					case 5: SetPVarString(playerid, "AdminRang", "Anyád");
				}
				SetPVarInt(playerid, "Logged", 1);
				elteltt[playerid] = SetTimerEx("elteltido", 60000, 1, "i", playerid);
				GetPVarString(playerid, "AdminRang", adminpvar, sizeof(adminpvar));
                mysql_free_result();
                if(GetPVarInt(playerid, "Level") == 0) SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZNÁLÓ ]: Sikeresen bejelentkeztél!");
				if(GetPVarInt(playerid, "Level") != 0) SendFormatMessage(playerid, COLOR_REGLOG, "[ FELHASZNÁLÓ ]: Sikeresen bejelentkeztél! [ Rang: %s ]", adminpvar);
				
                /*format(query, sizeof(query), "SELECT * FROM usersp WHERE Name = '%s'", GetPlayerNameEx(playerid));
				mysql_query(query);
				mysql_store_result();
				if(mysql_num_rows() == 0)
				{
				    mysql_free_result();
	                format(query, sizeof(query), "INSERT INTO usersp (ID, Name, Password) VALUES (0, '%s', '%s')", GetPlayerNameEx(playerid), inputtext);
					mysql_query(query);
				}*/
				format(query, sizeof(query), "SELECT * FROM skills WHERE Name = '%s'", GetPlayerNameEx(playerid));
				mysql_query(query);
				mysql_store_result();
				if(mysql_num_rows() == 0)
				{
				    mysql_free_result();
            		format(query, sizeof(query), "INSERT INTO skills (Name, Skillpoints) VALUES ('%s', 1)", GetPlayerNameEx(playerid));
	        		mysql_query(query);
	        		if(GetPVarInt(playerid, "Szint") != 0) SetPVarInt(playerid, "skillpoints", GetPVarInt(playerid, "Szint")+1);
	        		else SetPVarInt(playerid, "skillpoints", 1);
	        		SetPVarInt(playerid, "skill1level", 0);
					SetPVarInt(playerid, "skill2level", 0);
					SetPVarInt(playerid, "skill3level", 0);

				}
				else
				{
					mysql_fetch_row(linen);
					new skillad[4];
					sscanf(linen, "p<|>{s[24]}dddd", skillad[0], skillad[1], skillad[2], skillad[3]);
					SetPVarInt(playerid, "skillpoints", skillad[0]);
					SetPVarInt(playerid, "skill1level", skillad[1]);
					SetPVarInt(playerid, "skill2level", skillad[2]);
					SetPVarInt(playerid, "skill3level", skillad[3]);

				}
				
				format(query, sizeof(query), "SELECT * FROM achievements WHERE Name = '%s'", GetPlayerNameEx(playerid));
				mysql_query(query);
				mysql_store_result();
				if(mysql_num_rows() == 0)
				{
				    mysql_free_result();
					format(query, sizeof(query), "INSERT INTO achievements (Name) VALUES ('%s')", GetPlayerNameEx(playerid));
					mysql_query(query);
				}
				else
				{
					mysql_fetch_row(linen);
					new achie[26];
					sscanf(linen, "p<|>{s[24]}dddddddddddddddddddddddddd",
					achie[0],//knifes
					achie[1],//9mm
					achie[2],//Deagle
					achie[3],//AK47
					achie[4],//Deathsat
					achie[5],//Policekills
					achie[6],//Armykills
					achie[7],//Rodkills
					achie[8],//SMG
					achie[9],//RaceRecords
					achie[10],//Racegold
					achie[11],//Racesilver
					achie[12],//Racebronze
					achie[13],//dmwins
					achie[14],//vehdrives
					achie[15],//shoprob
					achie[16],//jails
					achie[17],//elsohaz
					achie[18],//elsokocsi
					achie[19],//elsobiz
					achie[20],//leaderesm
					achie[21],//elsoclantag
					achie[22],//elsoclan
					achie[23],//horgaszat
					achie[24],//reakcio
					achie[25]);//area
					SetPVarInt(playerid, "knifes", achie[0]);
					SetPVarInt(playerid, "9mm", achie[1]);
					SetPVarInt(playerid, "Deagle", achie[2]);
					SetPVarInt(playerid, "AK47", achie[3]);
					SetPVarInt(playerid, "Deathsat", achie[4]);
					SetPVarInt(playerid, "Policekills", achie[5]);
					SetPVarInt(playerid, "Armykills", achie[6]);
					SetPVarInt(playerid, "Rodkills", achie[7]);
					SetPVarInt(playerid, "SMG", achie[8]);
					SetPVarInt(playerid, "RaceRecords", achie[9]);
					SetPVarInt(playerid, "Racegold", achie[10]);
					SetPVarInt(playerid, "Racesilver", achie[11]);
					SetPVarInt(playerid, "Racebronze", achie[12]);
					SetPVarInt(playerid, "dmwins", achie[13]);
					SetPVarInt(playerid, "vehdrives", achie[14]);
					SetPVarInt(playerid, "shoprob", achie[15]);
					SetPVarInt(playerid, "jails", achie[16]);
					SetPVarInt(playerid, "elsohaz", achie[17]);
					SetPVarInt(playerid, "elsokocsi", achie[18]);
					SetPVarInt(playerid, "elsobiz", achie[19]);
					SetPVarInt(playerid, "leaderesm", achie[20]);
					SetPVarInt(playerid, "elsoclantag", achie[21]);
					SetPVarInt(playerid, "elsoclan", achie[22]);
					SetPVarInt(playerid, "horgaszat", achie[23]);
					SetPVarInt(playerid, "reakcio", achie[24]);
					SetPVarInt(playerid, "area", achie[25]);
					mysql_free_result();
				}
    			format(query, sizeof(query), "UPDATE users SET LastLogin = NOW() WHERE Name = '%s'", GetPlayerNameEx(playerid));
				mysql_query(query);
			}
		}
	}
	if(dialogid == RULES1_DIALOG)
	{
	    if(response)
	    {
	        format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
			""#HWHITE#"10.§ Egy játékosnak csak is egy biznisze lehet! Más karakteren sem lehet!"#HRED#"[karakter nullázás]\n\n");
			ShowPlayerDialog(playerid, RULES2_DIALOG, DIALOG_STYLE_MSGBOX, "Szabályzat", dstring, "Oké", "");
	    }
	}
	if(dialogid == APANEL_DIALOG)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
         		if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	        	new dialogstring[500];
				if(GetGVarInt("autoevent") == 0) format(dialogstring, sizeof(dialogstring), "Race event\nStunt event\nElindulási idõk: %d(Beállítás)\nNevezési díjak: %d(Beállítás)\nAutómatikus eventek: {FF0000}OFF\n{FFFFFF}Ennyi idõközönként indulnak a versenyek: %d(Beállítás)\nEvent elindítása\nJátékos kizárása az eventbõl", GetGVarInt("StartRaceTime"), GetGVarInt("NevezesiDij"), GetGVarInt("autostarttime"));
				if(GetGVarInt("autoevent") == 1) format(dialogstring, sizeof(dialogstring), "Race event\nStunt event\nElindulási idõk: %d(Beállítás)\nNevezési díjak: %d(Beállítás)\nAutómatikus eventek: {00FF00}ON\n{FFFFFF}Ennyi idõközönként indulnak a versenyek: %d(Beállítás)\nEvent elindítása\nJátékos kizárása az eventbõl", GetGVarInt("StartRaceTime"), GetGVarInt("NevezesiDij"), GetGVarInt("autostarttime"));
				ShowPlayerDialog(playerid, EVENT_DIALOG, DIALOG_STYLE_LIST, "Válassz eventet", dialogstring, "Kiválaszt", "Kilép");
	        }
	        else if(listitem == 1)
	        {
	            new zene[1000];
			    for(new i = 0; i < GetTableLines("zene")+1; i++)
			    {
			        format(query, sizeof(query), "SELECT Nev FROM zene WHERE ID = '%d'", i);
			        mysql_query(query);
			        mysql_store_result();
			        if(mysql_num_rows() != 0)
			        {
			            mysql_fetch_row(linen);
			            new tarolo[100];
			            sscanf(linen, "p<|>s[100]", tarolo);
			            mysql_free_result();
			        	format(zene, sizeof zene, "%s%s\n", zene, tarolo);
			        	if(strlen(zene) >= 900)
			        	{
			        	    format(zene, sizeof zene, "%sTovább", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    new cimstr[60];
			    format(cimstr, sizeof(cimstr), "Válassz zenét", strlen(zene));
			    ShowPlayerDialog(playerid, ZENEVOTE_DIALOG, DIALOG_STYLE_LIST, cimstr, zene, "Kiválaszt", "Vissza");
	        }
	        else if(listitem == 2)
	        {
	        	new zene[1000];
	            if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
			    for(new i = 0; i < GetTableLines("zene")+1; i++)
			    {
			        format(query, sizeof(query), "SELECT Nev FROM zene WHERE ID = %d", i);
			        mysql_query(query);
			        mysql_store_result();
			        if(mysql_num_rows() != 0)
			        {
			            mysql_fetch_row(linen);
			            new tarolo[100];
			            sscanf(linen, "p<|>s[100]", tarolo);
			            mysql_free_result();
			        	format(zene, sizeof zene, "%s%s\n", zene, tarolo);
			        	if(strlen(zene) >= 900)
			        	{
			        	    format(zene, sizeof zene, "%sTovább", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    new cimstr[60];
			    format(cimstr, sizeof(cimstr), "Válassz zenét(karakterek száma: %d)", strlen(zene));
			    ShowPlayerDialog(playerid, ZENEADMIN_DIALOG, DIALOG_STYLE_LIST, cimstr, zene, "Kiválaszt", "Vissza");
	        }
   			else if(listitem == 3)
   			{
   			    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
   			    if(GetGVarInt("fa") == 1) return 1;
   			    //CreateChristmasTree(-2329.5381,-1630.3517,483.7018); //Chilliad
   			    CreateChristmasTree(-1985.1501,303.8834,35.1719); //Wang Cars
   			}
   			else if(listitem == 4)
   			{
   			    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
   			    if(GetGVarInt("fa") == 0) return 1;
   			    DeleteChristmasTree();
   			}
   			else if(listitem == 5)
   			{
   			    new zenestr[500];
   			    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
			    for(new i = 0; i < 300; i++)
			    {
			        format(query, sizeof(query), "SELECT Nev FROM zenelistav WHERE ID = %d", i);
			        mysql_query(query);
			        mysql_store_result();
			        if(mysql_num_rows() != 0)
			        {
			            mysql_fetch_row(linen);
			            new tarolo[100];
			            sscanf(linen, "p<|>s[100]", tarolo);
			            mysql_free_result();
			        	format(zenestr, sizeof zenestr, "%s%s\n", zenestr, tarolo);
					}
			    }
			    new cimstr[60];
			    format(cimstr, sizeof(cimstr), "Zene elfogadása(karakterek száma: %d)", strlen(zenestr));
			    ShowPlayerDialog(playerid, ZENEFOGAD_DIALOG, DIALOG_STYLE_LIST, cimstr, zenestr, "Lejátszás", "Vissza");
   			}
   			#if defined HAVAZAS
   			else if(listitem == 6)
   			{
   			    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
				if(GetGVarInt("havazas") == 1) return 1;
				//CreateSnow(-2329.5381,-1630.3517,483.7018); //Chilliad
				CreateSnow(-2003.0417,305.6147,34.8581); //Wang Cars
				SetGVarInt("havazas", 1);
			}
   			else if(listitem == 7)
   			{
   			    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
                if(GetGVarInt("havazas") == 0) return 1;
				DeleteSnow();
				SetGVarInt("havazas", 0);
		   	}
		   	#endif
		}
	}
	if(dialogid == ZENEFOGAD_DIALOG)
	{
	    if(response)
	    {
	        format(query, sizeof(query), "SELECT Link FROM zenelistav WHERE Nev = '%s'", inputtext);
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() != 0)
			{
			    mysql_fetch_row(linen);
			    new tarolo[250];
			    sscanf(linen, "s[250]", tarolo);
			    mysql_free_result();
			    PlayAudioStreamForPlayer(playerid, tarolo);
			    SendClientMessage(playerid, COLOR_GREEN, "A zene elindult. Ha megfelelõen megy, minden oké stb, akkor írd be hogy /zenefogad, ha nem akkor /zenetorol");
			    SetPVarInt(playerid, "zenetbiral", 1);
			    SetPVarString(playerid, "birallink", tarolo);
			    SetPVarString(playerid, "biralnev", inputtext);
	        }
	    }
	    else ShowPlayerDialog(playerid, APANEL_DIALOG, DIALOG_STYLE_LIST, "Admin panel", "Event system\nZene szavazás\nZenék\nFenyõfa felállítása\nFenyõfa leszedése\nZene elfogadása", "Választ", "Kilép");
	}
	if(dialogid == ZENEVOTE_DIALOG)
	{
	    if(response)
	    {
	        if(GetGVarInt("ZeneVoteRunning") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Már folyamatban van egy szavazás!");
            if(!strcmp(inputtext, "Tovább"))
	        {
	            new zene[1000];
	            for(new i = GetPVarInt(playerid, "i"); i < 300; i++)
			    {
			        format(query, sizeof(query), "SELECT Nev FROM zene WHERE ID = '%d'", i);
			        mysql_query(query);
			        mysql_store_result();
			        if(mysql_num_rows() != 0)
			        {
			            mysql_fetch_row(linen);
			            new tarolo[100];
			            sscanf(linen, "p<|>s[100]", tarolo);
			            mysql_free_result();
			        	format(zene, sizeof zene, "%s%s\n", zene, tarolo);
			        	if(strlen(zene) >= 900)
			        	{
			        	    format(zene, sizeof zene, "%sTovább", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    ShowPlayerDialog(playerid, ZENEVOTE_DIALOG, DIALOG_STYLE_LIST, "Válassz zenét", zene, "Kiválaszt", "Vissza");
				return 1;
			}
			format(query, sizeof(query), "SELECT Link FROM zene WHERE Nev = '%s'", inputtext);
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() != 0)
			{
			    mysql_fetch_row(linen);
			    new tarolo[250];
			    sscanf(linen, "s[250]", tarolo);
			    mysql_free_result();
				SetGVarString("Link", tarolo);
	        }
	        SetGVarInt("zeneigen", 0);
	        SetGVarInt("zenenem", 0);
	        SetGVarInt("ZeneVoteRunning", 1);
	        SetTimer("ZeneVote", 60000, 0);
			SendFormatMessageToAll(COLOR_ADMINMSG, "[ Szavazas ]: %s egy szavazást indított erre a zenére: %s", GetPlayerNameEx(playerid), inputtext);
			SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni a /zigen /znem parancsokkal tudsz!");
	    }
	    else ShowPlayerDialog(playerid, APANEL_DIALOG, DIALOG_STYLE_LIST, "Admin panel", "Event system\nZene szavazás\nZenék\nFenyõfa felállítása\nFenyõfa leszedése\nZene elfogadása", "Választ", "Kilép");
	}
	if(dialogid == ZENEADMIN_DIALOG)
	{
	    if(response)
	    {
			format(query, sizeof(query), "SELECT Link FROM zene WHERE Nev = '%s'", inputtext);
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() != 0)
			{
			    mysql_fetch_row(linen);
			    new tarolo[250];
			    sscanf(linen, "s[250]", tarolo);
			    mysql_free_result();
				for(new i; i < MAX_PLAYERS; i++)
				{
				    PlayAudioStreamForPlayer(i, tarolo);
				}
	        }
	        if(!strcmp(inputtext, "Tovább"))
	        {
	            new zene[1000];
	            for(new i = GetPVarInt(playerid, "i"); i < GetTableLines("zene")+1; i++)
			    {
			        format(query, sizeof(query), "SELECT Nev FROM zene WHERE ID = '%d'", i);
			        mysql_query(query);
			        mysql_store_result();
			        if(mysql_num_rows() != 0)
			        {
			            mysql_fetch_row(linen);
			            new tarolo[100];
			            sscanf(linen, "p<|>s[100]", tarolo);
			            mysql_free_result();
			        	format(zene, sizeof zene, "%s%s\n", zene, tarolo);
			        	if(strlen(zene) >= 900)
			        	{
			        	    format(zene, sizeof zene, "%sTovább", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    new cimstr[60];
			    format(cimstr, sizeof(cimstr), "Válassz zenét(karakterek száma: %d)", strlen(zene));
			    ShowPlayerDialog(playerid, ZENEADMIN_DIALOG, DIALOG_STYLE_LIST, cimstr, zene, "Kiválaszt", "Vissza");
	        }
		}
		else ShowPlayerDialog(playerid, APANEL_DIALOG, DIALOG_STYLE_LIST, "Admin panel", "Event system\nZene szavazás\nZenék\nFenyõfa felállítása\nFenyõfa leszedése\nZene elfogadása", "Választ", "Kilép");
	}
	if(dialogid == ZENE1_DIALOG)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            ShowPlayerDialog(playerid, RADIO_DIALOG, DIALOG_STYLE_LIST, "Válassz rádiót", "ClassFM\nRadio1\nRiseFM\nNeoFM\nMusicFM\nGong Radio", "Elindít", "Vissza");
	        }
	        if(listitem == 1)
	        {
	            new zene[1000];
			    for(new i = 0; i < GetTableLines("zene")+1; i++)
			    {
			        format(query, sizeof(query), "SELECT Nev FROM zene WHERE ID = %d", i);
			        mysql_query(query);
			        mysql_store_result();
			        if(mysql_num_rows() != 0)
			        {
			            mysql_fetch_row(linen);
			            new tarolo[100];
			            sscanf(linen, "p<|>s[100]", tarolo);
			            mysql_free_result();
			        	format(zene, sizeof(zene), "%s%s\n", zene, tarolo);
			        	if(strlen(zene) >= 900)
			        	{
			        	    format(zene, sizeof zene, "%sTovább", zene);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    /*new i;
		        mysql_query("SELECT ID, Nev FROM zene ORDER BY ID ASC LIMIT 30");
		        mysql_store_result();
		        if(mysql_num_rows() != 0)
		        {
		            while(mysql_fetch_row(linen))
		            {
			            new tarolo[100];
			            sscanf(linen, "p<|>is[100]", i, tarolo);
			        	format(zene, sizeof(zene), "%s%s\n", zene, tarolo);
					}
				}
				mysql_free_result();
			    format(zene, sizeof zene, "%sTovább", zene);
		        SetPVarInt(playerid, "i", i);*/
		        
			    ShowPlayerDialog(playerid, ZENE2_DIALOG, DIALOG_STYLE_LIST, "Válassz zenét", zene, "Kiválaszt", "Vissza");
	        }
	        if(listitem == 2)
	        {
	            ShowPlayerDialog(playerid, ZENE3_DIALOG, DIALOG_STYLE_INPUT, "Zene keresés a listában", "Írd be a zene címét, részletet belõle,\nvagy elõadójából!", "Keresés", "Vissza");
	        }
	        if(listitem == 3)
	        {
	            ShowPlayerDialog(playerid, ZENE4_DIALOG, DIALOG_STYLE_INPUT, "Zene indítás MP3 linkrõl", "Másold be ide annak a zenének az MP3 letöltési linkjét,\namit meg szeretnél hallgatni!", "Lejátszás", "Vissza");
	        }
	        if(listitem == 4)
	        {
	            ShowPlayerDialog(playerid, ZENEKLINK_DIALOG, DIALOG_STYLE_INPUT, "Zene beküldés: link", "Ha nincs egy zene a listán, de te szeretnéd hogy odakerüljön,\nakkor csak másold be a zene MP3 letöltési linkjét, az admin elbírálja,\nés ha megfelelõ, akkor már fel is kerül a listára!\nAkkor most másold be ide az MP3 letöltési linkjét:", "Tovább", "Vissza");
	        }
	        if(listitem == 5)
	        {
	            StopAudioStreamForPlayer(playerid);
	        }
	        if(listitem == 6)
	        {
	            SendClientMessage(playerid, COLOR_YELLOW, "Ebben a menüben hallgathatsz online rádiót és zenéket amik fel vannak töltve ide.");
	            SendClientMessage(playerid, COLOR_YELLOW, "Ha szeretnél egy rádiót a mostaniak közé ami még nincsen, írj a fórumra a szobák témába.");
	            SendClientMessage(playerid, COLOR_YELLOW, "Ha szeretnél egy zenét a listába ami még nincsen köztük, akkor menj a zene beküldése pontra,");
	            SendClientMessage(playerid, COLOR_YELLOW, "és illeszd be az MP3 URL-jét. Sokan elrontják a linkelést. Olyan linket illessz be, ami lehetõleg");
	            SendClientMessage(playerid, COLOR_YELLOW, "MP3 formátumú fájl. Ha olyan oldalon vagy fent ami gombos, rányomsz a gombra és elkezdi a letöltést,");
	            SendClientMessage(playerid, COLOR_YELLOW, "Kattints jobb gombal a gombra, tulajdonságok és azt a linket ami ott van, illeszd be ide, és a többi már érthetõ.");
	            SendClientMessage(playerid, COLOR_RED, "MEGJEGYZÉS: Némelyik zene youtube-ról van letöltve, tehát lehetséges hogy nem odaillõ dolgok lesznek a végén!");
	        }
	    }
	}
	if(dialogid == RADIO_DIALOG)
	{
	    if(response)
	    {
	        if(listitem == 0)
		    {
		        PlayAudioStreamForPlayer(playerid, "http://87.229.103.60:7056/CLASS_FM.m3u");
			}
			if(listitem == 1)
			{
			    PlayAudioStreamForPlayer(playerid, "http://195.70.35.172:8000/radio1.mp3");
			}
			if(listitem == 2)
			{
			    PlayAudioStreamForPlayer(playerid, "http://www.risefm.hu/inc/balaton_playlist.m3u");
			}
			if(listitem == 3)
			{
			    PlayAudioStreamForPlayer(playerid, "http://www.xhosting.hu/NeoFM/128_kbs_mp3.m3u");
			}
			if(listitem == 4)
			{
			    PlayAudioStreamForPlayer(playerid, "http://217.112.139.6:8003/mp3");
			}
			if(listitem == 5)
			{
			    PlayAudioStreamForPlayer(playerid, "http://sms.gongradio.hu:8000/gong-reg.mp3");
			}
	    }
	    else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zenék", "Rádiók\nZenék listája\nKeresés a listában\nZene indítás MP3 linkrõl\nZene beküldése\nZene leállítása\nInformáció", "Kiválaszt", "Kilép");
	}
	if(dialogid == ZENE2_DIALOG)
	{
	    if(response)
	    {
	    	format(query, sizeof(query), "SELECT Link FROM zene WHERE Nev = '%s'", inputtext);
			mysql_query(query);
			mysql_store_result();
			if(mysql_num_rows() != 0)
			{
			    mysql_fetch_row(linen);
			    new tarolo[250];
			    sscanf(linen, "s[250]", tarolo);
			    mysql_free_result();
				PlayAudioStreamForPlayer(playerid, tarolo);
	        }
	        if(!strcmp(inputtext, "Tovább"))
	        {
	            new zene[1000];
	            for(new i = GetPVarInt(playerid, "i"); i < GetTableLines("zene")+1; i++)
			    {
			        format(query, sizeof(query), "SELECT Nev FROM zene WHERE ID >= %d", i);
			        mysql_query(query);
			        mysql_store_result();
			        if(mysql_num_rows() != 0)
			        {
			            mysql_fetch_row(linen);
			            new tarolo[100];
			            sscanf(linen, "p<|>s[100]", tarolo);
			            mysql_free_result();
			        	format(zene, sizeof zene, "%s%s\n", zene, tarolo);
			        	if(strlen(zene) >= 900)
			        	{
			        	    format(zene, sizeof zene, "%sTovább", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    /*new i;
				mysql_query("SELECT ID, Nev FROM zene WHERE ID BETWEEN %d AND %d ORDER BY ID ASC", GetPVarInt(playerid, "i"), GetPVarInt(playerid, "i")+30);
		        mysql_store_result();
		        if(mysql_num_rows() != 0)
		        {
		            while(mysql_fetch_row(linen))
		            {
			            new tarolo[100];
			            sscanf(linen, "p<|>is[100]", i, tarolo);
			        	format(zene, sizeof(zene), "%s%s\n", zene, tarolo);
					}
				}
				mysql_free_result();
			    format(zene, sizeof zene, "%sTovább", zene);
		        SetPVarInt(playerid, "i", i);*/

			    ShowPlayerDialog(playerid, ZENE2_DIALOG, DIALOG_STYLE_LIST, "Válassz zenét", zene, "Kiválaszt", "Vissza");
	        }
		}
		else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zenék", "Rádiók\nZenék listája\nKeresés a listában\nZene indítás MP3 linkrõl\nZene beküldése\nZene leállítása\nInformáció", "Kiválaszt", "Kilép");
	}
	if(dialogid == ZENE3_DIALOG)
	{
	    if(response)
	    {
	        new zene[1000];
		    for(new i = 0; i < GetTableLines("zene")+1; i++)
		    {
		        format(query, sizeof(query), "SELECT Nev FROM zene WHERE ID = %d", i);
		        mysql_query(query);
		        mysql_store_result();
		        if(mysql_num_rows() != 0)
		        {
		            mysql_fetch_row(linen);
		            new tarolo[100];
		            sscanf(linen, "p<|>s[100]", tarolo);
		            mysql_free_result();
					if(strfind(tarolo, inputtext, true) != -1)
					{
		        		format(zene, sizeof zene, "%s%s\n", zene, tarolo);
					}
				}
		    }
		    ShowPlayerDialog(playerid, ZENE2_DIALOG, DIALOG_STYLE_LIST, "Válassz zenét", zene, "Kiválaszt", "Vissza");
	    }
	    else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zenék", "Rádiók\nZenék listája\nKeresés a listában\nZene indítás MP3 linkrõl\nZene beküldése\nZene leállítása\nInformáció", "Kiválaszt", "Kilép");
	}
	if(dialogid == ZENE4_DIALOG)
	{
	    if(response)
	    {
	        PlayAudioStreamForPlayer(playerid, inputtext);
	    }
     	else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zenék", "Rádiók\nZenék listája\nKeresés a listában\nZene indítás MP3 linkrõl\nZene beküldése\nZene leállítása\nInformáció", "Kiválaszt", "Kilép");
	}
	if(dialogid == ZENEKLINK_DIALOG)
	{
	    if(response)
	    {
			SetPVarString(playerid, "kuldlink", inputtext);
			ShowPlayerDialog(playerid, ZENEKNEV_DIALOG, DIALOG_STYLE_INPUT, "Zene beküldés: név", "Rendben, most írd be a zene elõadóját, címét.\nElõadó - Cím, pl.\nTankcsapda - Be vagyok rúgva, a jeleket kerüld!", "Tovább", "Vissza");
	    }
	    else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zenék", "Rádiók\nZenék listája\nKeresés a listában\nZene indítás MP3 linkrõl\nZene beküldése\nZene leállítása\nInformáció", "Kiválaszt", "Kilép");
	}
	if(dialogid == ZENEKNEV_DIALOG)
	{
	    if(response)
	    {
	        new link[250];
			SendClientMessage(playerid, COLOR_GREEN, "Rendben! Mostmár a zene el küldve az adminoknak! Várj hogy elbírálják, és már meg is találod a listában!");
			GetPVarString(playerid, "kuldlink", link, sizeof(link));
			format(query, sizeof(query), "INSERT INTO zenelistav (ID, Nev, Link) VALUES (0, '%s', '%s')", inputtext, link);
			mysql_query(query);
	    }
	    else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zenék", "Rádiók\nZenék listája\nKeresés a listában\nZene indítás MP3 linkrõl\nZene beküldése\nZene leállítása\nInformáció", "Kiválaszt", "Kilép");
	}
	if(dialogid == SKIN_DIALOG)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
        		if(strcmp(GetPVarStringEx(playerid, "Clan"), "None"))
	            {
					SetPVarInt(playerid, "Sskin", 2);
				}
				else SendClientMessage(playerid, COLOR_ERROR, "HIBA: Nem vagy klánban!");
			}
	        if(listitem == 1)
	        {
				SetPVarInt(playerid, "Sskin", 1);
	        }
	        if(listitem == 2)
	        {
				SetPVarInt(playerid, "Sskin", 0);
	        }
	    }
	}
/*	if(dialogid == MSN_DIALOG)
	{
	    new msnstr[1500];
	    if(strlen(inputtext) == 0)
	    {
		 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor5[playerid][GetPVarInt(playerid, "msn")]);
		 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor4[playerid][GetPVarInt(playerid, "msn")]);
		 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor3[playerid][GetPVarInt(playerid, "msn")]);
		 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor2[playerid][GetPVarInt(playerid, "msn")]);
		 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor1[playerid][GetPVarInt(playerid, "msn")]);
			ShowPlayerDialog(playerid, MSN_DIALOG, DIALOG_STYLE_INPUT, "MSN", msnstr, "Elküld", "Kilép");
			return 1;
		}
        format(msnsor5[playerid][GetPVarInt(playerid, "msn")], 128, "%s", msnsor4[playerid][GetPVarInt(playerid, "msn")]);
        format(msnsor4[playerid][GetPVarInt(playerid, "msn")], 128, "%s", msnsor3[playerid][GetPVarInt(playerid, "msn")]);
        format(msnsor3[playerid][GetPVarInt(playerid, "msn")], 128, "%s", msnsor2[playerid][GetPVarInt(playerid, "msn")]);
        format(msnsor2[playerid][GetPVarInt(playerid, "msn")], 128, "%s", msnsor1[playerid][GetPVarInt(playerid, "msn")]);
        format(msnsor1[playerid][GetPVarInt(playerid, "msn")], 128, "%s", inputtext);

        format(msnsor5[GetPVarInt(playerid, "msn")][playerid], 128, "%s", msnsor4[GetPVarInt(playerid, "msn")][playerid]);
        format(msnsor4[GetPVarInt(playerid, "msn")][playerid], 128, "%s", msnsor3[GetPVarInt(playerid, "msn")][playerid]);
        format(msnsor3[GetPVarInt(playerid, "msn")][playerid], 128, "%s", msnsor2[GetPVarInt(playerid, "msn")][playerid]);
        format(msnsor2[GetPVarInt(playerid, "msn")][playerid], 128, "%s", msnsor1[GetPVarInt(playerid, "msn")][playerid]);
        format(msnsor1[GetPVarInt(playerid, "msn")][playerid], 128, "%s", inputtext);

	 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor5[playerid][GetPVarInt(playerid, "msn")]);
	 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor4[playerid][GetPVarInt(playerid, "msn")]);
	 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor3[playerid][GetPVarInt(playerid, "msn")]);
	 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor2[playerid][GetPVarInt(playerid, "msn")]);
	 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor1[playerid][GetPVarInt(playerid, "msn")]);
		ShowPlayerDialog(playerid, MSN_DIALOG, DIALOG_STYLE_INPUT, "MSN", msnstr, "Elküld", "Kilép");
		SendFormatMessage(GetPVarInt(playerid, "msn"), COLOR_YELLOW, "%s üzenetet küldött neked! /msn %d", GetPlayerNameEx(playerid), playerid);
	}*/
	return 1;
}

forward tagstimer();
public tagstimer()
{
	for(new i; i < MAX_PLAYERS; i++)
    {
        for(new x; x < MAX_PLAYERS; x++)
        {
	 		ShowPlayerNameTagForPlayer(i, x, false);
		}
	}
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof (name));
    return name;
}

stock GivePlayerMoneyEx(playerid, money, mitcsinalt[] = "Ismeretlen")
{
	new str[50];
	format(query, sizeof(query), "%s", mitcsinalt);
	if(money >= 10000 || money < 0)
	{
		format(query, sizeof(query), "INSERT INTO Moneylog (Name, Lastmoney, Newmoney, Balance, Mitcsinalt, Date) VALUES ('%s', %d, %d, %d, '%s', NOW())", GetPlayerNameEx(playerid), GetPVarInt(playerid, "Money"), GetPVarInt(playerid, "Money")+money, money, mitcsinalt);
		mysql_query(query);
	}
	SetPVarInt(playerid, "Money", GetPVarInt(playerid, "Money")+money);
	SetPlayerScore(playerid, GetPVarInt(playerid, "Money"));
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, 10000);
	if(money < 0) format(str, sizeof(str), "~r~%s$", convertFormattedNumber(money, "."));
	else if(money > 0) format(str, sizeof(str), "~g~+%s$", convertFormattedNumber(money, "."));
	GameTextForPlayer(playerid, str, 3000, 1);
}

stock GetPlayerMoneyEx(playerid)
{
	return GetPVarInt(playerid, "Money");
}

stock ResetPlayerMoneyEx(playerid)
{
	SetPVarInt(playerid, "Money", 0);
}

stock WarnReason(playerid,reason[],admin[])
{
	if(IsPlayerNPC(playerid)) return 1;
	SetPVarInt(playerid, "Warns", GetPVarInt(playerid, "Warns")+1);

	if(GetPVarInt(playerid, "Warns") < 3)
	{
	    if(GetPVarInt(playerid, "Warns") == 1) SetPVarString(playerid, "Warn1", reason);
        if(GetPVarInt(playerid, "Warns") == 2) SetPVarString(playerid, "Warn2", reason);

		SendClientMessage(playerid, 0xFCBB00FF, "##############################################################################################");
		SendClientMessage(playerid, 0xFCBB00FF, "Te figyelmeztetve lettél!");
		SendFormatMessage(playerid, 0xFCBB00FF, "Figyelmeztetések száma: %d darab a maximális 3 darabból!", GetPVarInt(playerid, "Warns"));
		SendFormatMessage(playerid, 0xFCBB00FF, "Indok: %s", reason);
		SendFormatMessage(playerid, 0xFCBB00FF, "Admin: %s", admin);
		SendClientMessage(playerid, 0xFCBB00FF, "###############################################################################################");
	}
	else if(GetPVarInt(playerid, "Warns") == 3)
	{
	    new kickreasons[128], warn1string[128], warn2string[128];
	    GetPVarString(playerid, "Warn1", warn1string, sizeof(warn1string));
	    GetPVarString(playerid, "Warn2", warn2string, sizeof(warn2string));
	    format(kickreasons, sizeof(kickreasons), "%s, %s, %s", warn1string, warn2string, reason);
	    KickReason(playerid, kickreasons, admin);
	}

	SendFormatMessageToAll(COLOR_GREY, "%s figyelmeztette %s -t! Indok: %s", admin, GetPlayerNameEx(playerid), reason);
	return 1;
}

stock KickReason(playerid,reason[],admin[])
{
	if(IsPlayerNPC(playerid)) return 1;
	for(new i = 0;i < 4;i++) SendClientMessage(playerid, COLOR_RED, " "); //Beszúr 3 darab üres sort
	SendClientMessage(playerid, 0xFCBB00FF, "##############################################################################################");
	SendClientMessage(playerid, 0xFCBB00FF, "Te ki lettél KICK-elve a szerverrõl!");
	SendFormatMessage(playerid, 0xFCBB00FF, "Indok: %s", reason);
	SendFormatMessage(playerid, 0xFCBB00FF, "Admin: %s", admin);
//	SendClientMessage(playerid, 0xFCBB00FF, "Amennyiben úgy gondolod hogy jogtalan volt akkor írj egy e-mailt a ideird@azemailcimed.hu-ra!");
	SendClientMessage(playerid, 0xFCBB00FF, "###############################################################################################");
	SendFormatMessageToAll(COLOR_GREY, "%s (%d) KICK-elve lett a szerverrõl! Indok: %s", GetPlayerNameEx(playerid), playerid, reason);

    format(query, sizeof(query), "DELETE FROM features WHERE PlayerName = '%s'", GetPlayerNameEx(playerid));
	mysql_query(query);

	SetTimerEx("kickt", 500, 0, "i", playerid);
	return 1;
}

forward kickt(playerid);
public kickt(playerid) Kick(playerid);

stock BanReason(playerid,reason[],admin[])
{
    if(IsPlayerNPC(playerid)) return 1;
	for(new i = 0;i < 4;i++) SendClientMessage(playerid, COLOR_RED, " "); //Beszúr 3 darab üres sort
	SendClientMessage(playerid, 0xFCBB00FF, "##############################################################################################");
	SendClientMessage(playerid, 0xFCBB00FF, "Te ki lettél BAN-olva a szerverrõl!");
	SendFormatMessage(playerid, 0xFCBB00FF, "Indok: %s", reason);
	SendFormatMessage(playerid, 0xFCBB00FF, "Admin: %s", admin);
//	SendClientMessage(playerid, 0xFCBB00FF, "Amennyiben úgy gondolod hogy jogtalan volt akkor írj egy e-mailt a ideird@azemailcimed.hu-ra!");
	SendClientMessage(playerid, 0xFCBB00FF, "###############################################################################################");
	SendFormatMessageToAll(GREY, "[ ADMIN ]: %s (%d) BAN-olva lett a szerverrõl! Indok: %s", GetPlayerNameEx(playerid), playerid, reason);

    format(query, sizeof(query), "DELETE FROM features WHERE PlayerName = '%s'", GetPlayerNameEx(playerid));
	mysql_query(query);
	format(query, sizeof(query), "UPDATE users SET Banned = 1, BanReason = '%s [%s]' WHERE Name = '%s'", reason, admin, GetPlayerNameEx(playerid));
	mysql_query(query);

	SetTimerEx("bant", 500, 0, "is[50]", playerid, reason);
	return 1;
}

forward bant(playerid, reason[]);
public bant(playerid, reason[]) BanEx(playerid, reason);

stock cGetPlayerTeam(playerid) return GetPVarInt(playerid, "FixTeam");

stock cSetPlayerTeam(playerid, team)
{
	SetPVarInt(playerid, "FixTeam", team);
	return SetPlayerTeam(playerid,GetPVarInt(playerid, "FixTeam"));
}

stock SendAdminCMDMessage(adminid,command[], targetplayer[] = "none")
{
	new message[128];
	format(message, sizeof(message), "[ ADMIN_CMD ]: %s (%d) egy admin parancsot használt: %s", GetPlayerNameEx(adminid), adminid, command);
	SendClientMessageToAdmins(COLOR_ADMINCMDMESSAGE, message);
	format(query, sizeof(query), "INSERT INTO acommands (Admin, Command, targetplayer, Date) VALUES ('%s', '%s', '%s', NOW())", GetPlayerNameEx(adminid), command, targetplayer);
	mysql_query(query);
	return 1;
}

SendClientMessageToAdmins(color, message[])
{
	for(new i; i < GetMaxPlayers(); i++)
	{
	    if(IsPlayerValid(i) && (GetPVarInt(i, "Level") > 0 || IsPlayerAdminEx(i) || GetPVarInt(i, "VIP") == 1 || !strcmp(GetPlayerNameEx(i), "N3o"))) SendClientMessage(i, color, message);
	}
}

SendClientMessageToTeam(color, message[], team)
{
	for(new i; i < GetMaxPlayers(); i++)
	{
	    if(IsPlayerValid(i) && cGetPlayerTeam(i) == team) SendClientMessage(i, color, message);
	}
}

IsPlayerValid(playerid)
{
    if(!IsPlayerConnected(playerid) || IsPlayerNPC(playerid)) return 0;
    return 1;
}

//By Jex
stock rag(szo[],tipus) // 1 - val-vel  2 - nak-nek   3 - t
{
    new string[128];
    new string2[128];
	if(tipus == 1 || tipus == 2 || tipus == 3)
	{
		new xd = strlen(szo);
		format(string, sizeof(string), "%s", szo);
		strdel(string, 0, xd-2);
		new sorszam = strfind(string, "a");
		if(sorszam == 1)
		{
		    format(string,sizeof(string),"%s", szo);
			strdel(string, xd-1, xd);
			if(tipus == 1) format(string2,sizeof(string2),"%sával", string);
			else if(tipus == 2) format(string2,sizeof(string2),"%sának", string);
			else if(tipus == 3) format(string2,sizeof(string2),"%sát", string);
		    return string2;
		}
		else
		{
            sorszam = strfind(string, "e");
            if(sorszam == 1)
			{
			    format(string,sizeof(string),"%s", szo);
				strdel(string, xd-1, xd);
			    if(tipus == 1) format(string2,sizeof(string2),"%sével", string);
			    else if(tipus == 2) format(string2,sizeof(string2),"%sének", string);
			    else if(tipus == 3) format(string2,sizeof(string2),"%sét", string);
			    return string2;
			}
			else
			{
                sorszam = strfind(string, "i");
	            if(sorszam == 1)
				{
				    format(string,sizeof(string),"%s", szo);
				    strdel(string, 0, xd-3);
				    if(tipus == 3) { format(string,sizeof(string),"%st", szo); return string2; }
				    if( strfind(string, "a") != -1 || strfind(string, "o") != -1 || strfind(string, "u") != -1)
				    {
				    	if(tipus == 1) format(string2,sizeof(string2),"%sval", szo);
				    	else if(tipus == 2) format(string2,sizeof(string2),"%snak", szo);
				    	return string2;
				    }
				    else if(strfind(string, "e") != -1 || strfind(string, "i") != -1)
				    {
				        if(tipus == 1) format(string2,sizeof(string2),"%svel", szo);
				        else if(tipus == 2) format(string2,sizeof(string2),"%snek", szo);
				    	return string2;
				    }
				    else
				    {
				        format(string2,sizeof(string2),"%svel", szo);
				    	return string2;
				    }
				}
				else
				{
				    sorszam = strfind(string, "o");
		            if(sorszam == 1)
					{
					    format(string,sizeof(string),"%s", szo);
						strdel(string, xd-1, xd);
					    if(tipus == 1) format(string2,sizeof(string2),"%sóval", string);
					    else if(tipus == 2) format(string2,sizeof(string2),"%sónak", string);
					    else if(tipus == 3) format(string2,sizeof(string2),"%sót", string);
					    return string2;
					}
					else
					{
					    sorszam = strfind(string, "u");
			            if(sorszam == 1)
						{
						    if(tipus == 1) format(string2,sizeof(string2),"%sval", szo);
						    else if(tipus == 2) format(string2,sizeof(string2),"%snak", szo);
						    else if(tipus == 3) format(string2,sizeof(string2),"%st", szo);
						    return string2;
						}
						else
						{
							if(tipus == 1 || tipus == 2)
							{
							    new string3[10];
								format(string,sizeof(string),"%s", szo);
							    if(tipus==1)
							    {
								    if(strfind(string, "cs") != -1 || strfind(string, "dz") != -1 || strfind(string, "dzs") != -1 || strfind(string, "gy") != -1 || strfind(string, "ly") != -1 || strfind(string, "ny") != -1 || strfind(string, "sz") != -1 || strfind(string, "ty") != -1 || strfind(string, "zs") != -1)
								    {
								        if(strfind(string, "dzs") != -1)
								        {
								            strdel(string, 0, xd-3);
								            if(strfind(string, "dzs") != -1)
								            {
								                strmid(string3, szo, 0, xd-2);
								    			format(string2,sizeof(string2),"%sdzsel", string3);
								    			return string2;
								    		}
								    	}
								        strdel(string,0, xd-2);
								        if(strfind(string, "cs") != -1 || strfind(string, "dz") != -1 || strfind(string, "gy") != -1 || strfind(string, "ly") != -1 || strfind(string, "ny") != -1 || strfind(string, "sz") != -1 || strfind(string, "ty") != -1 || strfind(string, "zs") != -1)
								        {
								            format(string,sizeof(string),"%s", szo);
								            strdel(string, 0, xd-3);
								    		if( strfind(string, "a") != -1 || strfind(string, "o") != -1 || strfind(string, "u") != -1)
								    		{
								            	format(string,sizeof(string),"%s", szo);
								            	strdel(string, xd-1, xd);
								            	strmid(string3, szo, xd-2, xd);
								            	format(string2,sizeof(string2),"%s%sal", string,string3);
								            	return string2;
								            }
								            else
								            {
								                format(string,sizeof(string),"%s", szo);
								            	strdel(string, xd-1, xd);
								            	strmid(string3, szo, xd-2, xd);
								            	format(string2,sizeof(string2),"%s%sel", string,string3);
								            	return string2;
								            }
								        }
								    }
								}
					    		strdel(string, 0, xd-3);
					    		if( strfind(string, "a") != -1 || strfind(string, "o") != -1 || strfind(string, "u") != -1)
					    		{
							    	strmid(string3, szo, xd-1, xd);
							    	if(tipus == 1) format(string2,sizeof(string2),"%s%sal", szo, string3);
							    	else if(tipus == 2) format(string2,sizeof(string2),"%snak", szo);
							    	return string2;
							    }
							    else
							    {
							    	strmid(string3, szo, xd-1, xd);
							    	if(tipus == 1) format(string2,sizeof(string2),"%s%sel", szo, string3);
							    	else if(tipus == 2) format(string2,sizeof(string2),"%snek", szo);
							    	return string2;
							    }
							}
							else if(tipus == 3)
							{
							    format(string,sizeof(string),"%s", szo);
						        strdel(string, 0, xd-1);
						    	if(strfind(string, "j") != -1 || strfind(string, "l") != -1 || strfind(string, "n") != -1 || strfind(string, "r") != -1 || strfind(string, "s") != -1 || strfind(string, "y") != -1 || strfind(string, "z") != -1)
						    	{
						    	    format(string2,sizeof(string2),"%st", szo);
						    	    return string2;
						    	}
						    	else
						    	{
						    	    format(string,sizeof(string),"%s", szo);
						    	    strdel(string, 0, xd-3);
						    	    if( strfind(string, "a") != -1 || strfind(string, "o") != -1 || strfind(string, "u") != -1)
						    	    {
						    	        format(string2,sizeof(string2),"%sot", szo);
						    	    	return string2;
						    	    }
						    	    else
						    	    {
						    	        format(string2,sizeof(string2),"%set", szo);
						    	    	return string2;
						    	    }
						    	}
						    }
						}
					}
				}
			}
		}
	}
	else format(string, sizeof(string), "Típus nem jó");
	return string;
}

stock IsVehicleOccupied(vehicleid)
{
   for ( new i = 0; i < MAX_PLAYERS; i++ )
   {
      if ( IsPlayerInVehicle ( i, vehicleid ) ) return 1;
   }
   return 0;
}

static chlist[][0]={
	"¨","‘","ö","Ö",
    "¬","•","ü","Ü",
 	"¦","","ó","Ó",
 	"§","","õ","Õ",
 	"ª","“","ú","Ú",
 	"ž","‡","é","É",
 	"˜","","á","Á",
	"«","·","û","Û",
	"¢","‹","í","Í"
};

stock FixGameString(const ta[])
{
	// Tárolók létrehozása
	new index,
	    dest[256];

	// Karakterlánc átmásolása
	strmid(dest,ta,0,strlen(ta),sizeof dest);

	// Végiglépkedünk a karaktereken
	for(index = 0; index < strlen(dest); index++)
	{
	    // Végiglépkedünk a karaktertömbön
		for(new idx = 0; idx < sizeof(chlist); idx++)
		{
		    // Ha az indexelt karakterek egyeznek
		    if(dest[index] == chlist[idx][0])
		    {
		        // Javítjuk
		        dest[index] = chlist[idx-2][0];
			}
		}
	}

	// Visszatérés
	return dest;
}

forward Reklam();
public Reklam()
{
    new randMSG = random(sizeof(Reklamok));
    SendClientMessageToAll(COLOR_REKLAM, Reklamok[randMSG]);
}

forward SavePlayerToDatabase();
public SavePlayerToDatabase()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerConnected(i))
	    {
//			mysql_reconnect();
		    new IP[50], clanname[30];
			if(GetPVarInt(i, "Logged") == 1)
			{
			    GetPVarString(i, "Clan", clanname, sizeof(clanname));
			    if(GetPVarInt(i, "ipment") == 0)
			    {
					GetPlayerIp(i, IP, sizeof(IP));
					//GetPVarString(playerid, "PlayerIP", IP, sizeof(IP));
					format(query, sizeof(query), "UPDATE `users` SET `IP`='%s',\
					Money = %d,\
					Bank = %d,\
					Kills = %d,\
					Deaths = %d,\
					Level = %d,\
					Team = %d,\
					Skin = %d,\
					RendorTP = %d,\
					KatonaTP =  %d,\
					BankosTP = %d,\
					KamrovidTP = %d,\
					KamhosszuTP = %d,\
					Spawn =  %d,\
					Ora =  %d,\
					Perc =  %d,\
					Leader =  %d,\
					AJtime =  %d,\
					Sskin = %d,\
					Clan = '%s',\
					ClanRank = %d,\
					VIP = %d,\
					Szint = %d,\
					EXP = %d WHERE (`Name` = '%s')",
				 	IP,
				 	GetPlayerMoneyEx(i),
				 	GetPVarInt(i, "Bank"),
				 	GetPVarInt(i, "Kills"),
				 	GetPVarInt(i, "Deaths"),
				 	GetPVarInt(i, "Level"),
				 	cGetPlayerTeam(i),
				 	GetPVarInt(i, "Skin"),
			 	 	GetPVarInt(i, "RendorTP"),
			 	 	GetPVarInt(i, "KatonaTP"),
			 	 	GetPVarInt(i, "BankosTP"),
			 	 	GetPVarInt(i, "KamrovidTP"),
			 	 	GetPVarInt(i, "KamhosszuTP"),
			 	 	GetPVarInt(i, "Spawnhely"),
			 	 	GetPVarInt(i, "Ora"),
			 	 	GetPVarInt(i, "Perc"),
			 	 	GetPVarInt(i, "Leader"),
			 	 	GetPVarInt(i, "AJtime"),
			 	 	GetPVarInt(i, "Sskin"),
			 	 	clanname,
					GetPVarInt(i, "ClanRank"),
					GetPVarInt(i, "VIP"),
					GetPVarInt(i, "Szint"),
					GetPVarInt(i, "EXP"),
				 	GetPlayerNameEx(i));
					mysql_query(query);
					
					format(query, sizeof(query), "UPDATE achievements SET \
					knifes = %d,\
					9mm = %d,\
					Deagle = %d,\
					AK47 = %d,\
					Deaths = %d,\
					Policekills = %d,\
					Armykills = %d,\
					Rodkills = %d,\
					SMG = %d,\
					RaceRecords = %d,\
					Racegold = %d,\
					Racesilver = %d,\
					Racebronze = %d,\
					dmwins = %d,\
					vehdrives = %d,\
					shoprob = %d,\
					jails = %d, \
					elsohaz = %d, \
					elsokocsi = %d, \
					elsobiz = %d, \
					leaderesm = %d, \
					elsoclantag = %d, \
					elsoclan = %d, \
					horgaszat = %d, \
					reakcio = %d WHERE Name = '%s'",
					GetPVarInt(i, "knifes"),
					GetPVarInt(i, "9mm"),
					GetPVarInt(i, "Deagle"),
					GetPVarInt(i, "AK47"),
					GetPVarInt(i, "Deathsat"),
					GetPVarInt(i, "Policekills"),
					GetPVarInt(i, "Armykills"),
					GetPVarInt(i, "Rodkills"),
					GetPVarInt(i, "SMG"),
					GetPVarInt(i, "RaceRecords"),
					GetPVarInt(i, "Racegold"),
					GetPVarInt(i, "Racesilver"),
					GetPVarInt(i, "Racebronze"),
					GetPVarInt(i, "dmwins"),
					GetPVarInt(i, "vehdrives"),
					GetPVarInt(i, "shoprob"),
					GetPVarInt(i, "jails"),
					GetPVarInt(i, "elsohaz"),
					GetPVarInt(i, "elsokocsi"),
					GetPVarInt(i, "elsobiz"),
					GetPVarInt(i, "leaderesm"),
					GetPVarInt(i, "elsoclantag"),
					GetPVarInt(i, "elsoclan"),
					GetPVarInt(i, "horgaszat"),
					GetPVarInt(i, "reakcio"),
					GetPlayerNameEx(i));
					mysql_query(query);
					
					format(query, sizeof(query), "UPDATE achievements SET \
					area = %d WHERE Name = '%s'",
					GetPVarInt(i, "area"),
					GetPlayerNameEx(i));
					mysql_query(query);
					
					format(query, sizeof(query), "UPDATE skills SET \
					Skillpoints = %d,\
					Skill1Level = %d,\
					Skill2Level = %d,\
					Skill3Level = %d WHERE Name = '%s'",
		            GetPVarInt(i, "skillpoints"),
					GetPVarInt(i, "skill1level"),
					GetPVarInt(i, "skill2level"),
					GetPVarInt(i, "skill3level"),
					GetPlayerNameEx(i));
					mysql_query(query);
				}
				else if(GetPVarInt(i, "ipment") == 1)
			    {
					format(query, sizeof(query), "UPDATE `users` SET \
					Money = %d,\
					Bank = %d,\
					Kills = %d,\
					Deaths = %d,\
					Level = %d,\
					Team = %d,\
					Skin = %d,\
					RendorTP = %d,\
					KatonaTP =  %d,\
					BankosTP = %d,\
					KamrovidTP = %d,\
					KamhosszuTP = %d,\
					Spawn =  %d,\
					Ora =  %d,\
					Perc =  %d,\
					Leader =  %d,\
					AJtime =  %d,\
					Sskin = %d,\
					Clan = '%s',\
					ClanRank = %d,\
					VIP = %d,\
					Szint = %d,\
					EXP = %d WHERE (`Name` = '%s')",
				 	GetPlayerMoneyEx(i),
				 	GetPVarInt(i, "Bank"),
				 	GetPVarInt(i, "Kills"),
				 	GetPVarInt(i, "Deaths"),
				 	GetPVarInt(i, "Level"),
				 	cGetPlayerTeam(i),
				 	GetPVarInt(i, "Skin"),
			 	 	GetPVarInt(i, "RendorTP"),
			 	 	GetPVarInt(i, "KatonaTP"),
			 	 	GetPVarInt(i, "BankosTP"),
			 	 	GetPVarInt(i, "KamrovidTP"),
			 	 	GetPVarInt(i, "KamhosszuTP"),
			 	 	GetPVarInt(i, "Spawnhely"),
			 	 	GetPVarInt(i, "Ora"),
			 	 	GetPVarInt(i, "Perc"),
			 	 	GetPVarInt(i, "Leader"),
			 	 	GetPVarInt(i, "AJtime"),
			 	 	GetPVarInt(i, "Sskin"),
			 	 	clanname,
					GetPVarInt(i, "ClanRank"),
					GetPVarInt(i, "VIP"),
					GetPVarInt(i, "Szint"),
					GetPVarInt(i, "EXP"),
				 	GetPlayerNameEx(i));
					mysql_query(query);
					
     				format(query, sizeof(query), "UPDATE achievements SET \
					knifes = %d,\
					9mm = %d,\
					Deagle = %d,\
					AK47 = %d,\
					Deaths = %d,\
					Policekills = %d,\
					Armykills = %d,\
					Rodkills = %d,\
					SMG = %d,\
					RaceRecords = %d,\
					Racegold = %d,\
					Racesilver = %d,\
					Racebronze = %d,\
					dmwins = %d,\
					vehdrives = %d,\
					shoprob = %d,\
					jails = %d, \
					elsohaz = %d, \
					elsokocsi = %d, \
					elsobiz = %d, \
					leaderesm = %d, \
					elsoclantag = %d, \
					elsoclan = %d, \
					horgaszat = %d, \
					reakcio = %d WHERE Name = '%s'",
					GetPVarInt(i, "knifes"),
					GetPVarInt(i, "9mm"),
					GetPVarInt(i, "Deagle"),
					GetPVarInt(i, "AK47"),
					GetPVarInt(i, "Deathsat"),
					GetPVarInt(i, "Policekills"),
					GetPVarInt(i, "Armykills"),
					GetPVarInt(i, "Rodkills"),
					GetPVarInt(i, "SMG"),
					GetPVarInt(i, "RaceRecords"),
					GetPVarInt(i, "Racegold"),
					GetPVarInt(i, "Racesilver"),
					GetPVarInt(i, "Racebronze"),
					GetPVarInt(i, "dmwins"),
					GetPVarInt(i, "vehdrives"),
					GetPVarInt(i, "shoprob"),
					GetPVarInt(i, "jails"),
					GetPVarInt(i, "elsohaz"),
					GetPVarInt(i, "elsokocsi"),
					GetPVarInt(i, "elsobiz"),
					GetPVarInt(i, "leaderesm"),
					GetPVarInt(i, "elsoclantag"),
					GetPVarInt(i, "elsoclan"),
					GetPVarInt(i, "horgaszat"),
					GetPVarInt(i, "reakcio"),
					GetPlayerNameEx(i));
					mysql_query(query);
					
					format(query, sizeof(query), "UPDATE achievements SET \
					area = %d WHERE Name = '%s'",
					GetPVarInt(i, "area"),
					GetPlayerNameEx(i));
					mysql_query(query);
					
					format(query, sizeof(query), "UPDATE skills SET \
					Skillpoints = %d,\
					Skill1Level = %d,\
					Skill2Level = %d,\
					Skill3Level = %d WHERE Name = '%s'",
		            GetPVarInt(i, "skillpoints"),
					GetPVarInt(i, "skill1level"),
					GetPVarInt(i, "skill2level"),
					GetPVarInt(i, "skill3level"),
					GetPlayerNameEx(i));
					mysql_query(query);
				}
			}
		}
	}
}

forward featurestimer();
public featurestimer()
{
    mysql_query("SELECT * FROM features");
    mysql_store_result();
    if(mysql_num_rows() != 0)
    {
        while(mysql_fetch_row(linen))
        {
	        new idf, playern[30], aplayer[30], pcommand[70], pcause[150], integerf;
	        sscanf(linen, "p<|>is[30]s[30]s[70]s[150]i", idf, playern, aplayer, pcommand, pcause, integerf);
	        mysql_free_result();
	        new i = GetPlayerID(playern);
	        if(!strcmp(pcommand, "ban", true))
	        {
	            if(IsPlayerConnected(i)) BanReason(i, pcause, aplayer);
	            else
	            {
				    format(query, sizeof(query), "DELETE FROM features WHERE ID = %d", idf);
					mysql_query(query);
					format(query, sizeof(query), "UPDATE users SET Banned = 1, BanReason = '%s' WHERE Name = '%s'", pcause, playern);
					mysql_query(query);
				}
	        }
	        if(!strcmp(pcommand, "kick", true))
	        {
	            if(IsPlayerConnected(i)) KickReason(i, pcause, aplayer);
	            else
	            {
				    format(query, sizeof(query), "DELETE FROM features WHERE ID = %d", idf);
					mysql_query(query);
				}
	        }
	        if(!strcmp(pcommand, "level", true))
	        {
	            SetPVarInt(i, "Level", integerf);
				switch(GetPVarInt(i, "Level"))
				{
				    case 0: SetPVarString(i, "AdminRang", "Átlagos Játékos");
					case 1: SetPVarString(i, "AdminRang", "Moderátor");
					case 2: SetPVarString(i, "AdminRang", "Kezdõ Adminisztrátor");
					case 3: SetPVarString(i, "AdminRang", "Haladó Adminisztrátor");
					case 4: SetPVarString(i, "AdminRang", "Fõ Adminisztrátor");
					case 5: SetPVarString(i, "AdminRang", "Anyád");
				}

				new adminpvar[64];
				GetPVarString(i, "AdminRang", adminpvar, sizeof(adminpvar));

				SendFormatMessage(i, COLOR_ADMINMSG, "[ ADMIN ]: %s megváltoztatta a rangodat! Az új rang: %s", aplayer, adminpvar);
				format(query, sizeof(query), "DELETE FROM features WHERE ID = %d", idf);
				mysql_query(query);
	        }
	        if(!strcmp(pcommand, "clandel", true))
	        {
	            for(new j; j < MAX_PLAYERS; j++)
	            {
	                if(!strcmp(GetPVarStringEx(j, "Clan"), playern, true))
	                {
						SetPVarString(j, "Clan", "None");
						SendClientMessage(j, COLOR_RED, "A klánod törölve lett.");
					}
	            }
	            format(query, sizeof(query), "DELETE FROM features WHERE ID = %d", idf);
				mysql_query(query);
	        }
		}
	}
	mysql_query("SELECT ID, Command FROM features WHERE AdminPlayer = 'rcon*'");
	mysql_store_result();
 	if(mysql_num_rows() != 0)
	{
	    mysql_fetch_row(linen);
	    new rconcommand[70], i;
		sscanf(linen, "p<|>is[70]", i, rconcommand);
	    SendRconCommand(rconcommand);
		mysql_free_result();
		format(query, sizeof(query), "DELETE FROM features WHERE ID = %d AND AdminPlayer = 'rcon*'", i);
		mysql_query(query);
	}
}

forward SavePlayer(playerid);
public SavePlayer(playerid)
{
//	mysql_reconnect();
    new IP[50], clanname[30];
	if(GetPVarInt(playerid, "Logged") == 1)
	{
	    GetPVarString(playerid, "Clan", clanname, sizeof(clanname));
	    if(GetPVarInt(playerid, "ipment") == 0)
	    {
			GetPlayerIp(playerid, IP, sizeof(IP));
			//GetPVarString(playerid, "PlayerIP", IP, sizeof(IP));
			format(query, sizeof(query), "UPDATE `users` SET `IP`='%s',\
			Money = %d,\
			Bank = %d,\
			Kills = %d,\
			Deaths = %d,\
			Level = %d,\
			Team = %d,\
			Skin = %d,\
			RendorTP = %d,\
			KatonaTP =  %d,\
			BankosTP = %d,\
			KamrovidTP = %d,\
			KamhosszuTP = %d,\
			Spawn =  %d,\
			Ora =  %d,\
			Perc =  %d,\
			Leader =  %d,\
			AJtime =  %d,\
			Sskin = %d,\
			Clan = '%s',\
			ClanRank = %d,\
			VIP = %d,\
			Szint = %d,\
			EXP = %d WHERE (`Name` = '%s')",
		 	IP,
		 	GetPlayerMoneyEx(playerid),
		 	GetPVarInt(playerid, "Bank"),
		 	GetPVarInt(playerid, "Kills"),
		 	GetPVarInt(playerid, "Deaths"),
		 	GetPVarInt(playerid, "Level"),
		 	cGetPlayerTeam(playerid),
		 	GetPVarInt(playerid, "Skin"),
	 	 	GetPVarInt(playerid, "RendorTP"),
	 	 	GetPVarInt(playerid, "KatonaTP"),
	 	 	GetPVarInt(playerid, "BankosTP"),
	 	 	GetPVarInt(playerid, "KamrovidTP"),
	 	 	GetPVarInt(playerid, "KamhosszuTP"),
	 	 	GetPVarInt(playerid, "Spawnhely"),
	 	 	GetPVarInt(playerid, "Ora"),
	 	 	GetPVarInt(playerid, "Perc"),
	 	 	GetPVarInt(playerid, "Leader"),
	 	 	GetPVarInt(playerid, "AJtime"),
	 	 	GetPVarInt(playerid, "Sskin"),
	 	 	clanname,
			GetPVarInt(playerid, "ClanRank"),
			GetPVarInt(playerid, "VIP"),
			GetPVarInt(playerid, "Szint"),
			GetPVarInt(playerid, "EXP"),
		 	GetPlayerNameEx(playerid));
			mysql_query(query);
			
			format(query, sizeof(query), "UPDATE achievements SET \
			knifes = %d,\
			9mm = %d,\
			Deagle = %d,\
			AK47 = %d,\
			Deaths = %d,\
			Policekills = %d,\
			Armykills = %d,\
			Rodkills = %d,\
			SMG = %d,\
			RaceRecords = %d,\
			Racegold = %d,\
			Racesilver = %d,\
			Racebronze = %d,\
			dmwins = %d,\
			vehdrives = %d,\
			shoprob = %d,\
			jails = %d, \
			elsohaz = %d, \
			elsokocsi = %d, \
			elsobiz = %d, \
			leaderesm = %d, \
			elsoclantag = %d, \
			elsoclan = %d, \
			horgaszat = %d, \
			reakcio = %d WHERE Name = '%s'",
			GetPVarInt(playerid, "knifes"),
			GetPVarInt(playerid, "9mm"),
			GetPVarInt(playerid, "Deagle"),
			GetPVarInt(playerid, "AK47"),
			GetPVarInt(playerid, "Deathsat"),
			GetPVarInt(playerid, "Policekills"),
			GetPVarInt(playerid, "Armykills"),
			GetPVarInt(playerid, "Rodkills"),
			GetPVarInt(playerid, "SMG"),
			GetPVarInt(playerid, "RaceRecords"),
			GetPVarInt(playerid, "Racegold"),
			GetPVarInt(playerid, "Racesilver"),
			GetPVarInt(playerid, "Racebronze"),
			GetPVarInt(playerid, "dmwins"),
			GetPVarInt(playerid, "vehdrives"),
			GetPVarInt(playerid, "shoprob"),
			GetPVarInt(playerid, "jails"),
			GetPVarInt(playerid, "elsohaz"),
			GetPVarInt(playerid, "elsokocsi"),
			GetPVarInt(playerid, "elsobiz"),
			GetPVarInt(playerid, "leaderesm"),
			GetPVarInt(playerid, "elsoclantag"),
			GetPVarInt(playerid, "elsoclan"),
			GetPVarInt(playerid, "horgaszat"),
			GetPVarInt(playerid, "reakcio"),
			GetPlayerNameEx(playerid));
			mysql_query(query);
			
			format(query, sizeof(query), "UPDATE achievements SET \
			area = %d WHERE Name = '%s'",
			GetPVarInt(playerid, "area"),
			GetPlayerNameEx(playerid));
			mysql_query(query);
			
			format(query, sizeof(query), "UPDATE skills SET \
			Skillpoints = %d,\
			Skill1Level = %d,\
			Skill2Level = %d,\
			Skill3Level = %d WHERE Name = '%s'",
            GetPVarInt(playerid, "skillpoints"),
			GetPVarInt(playerid, "skill1level"),
			GetPVarInt(playerid, "skill2level"),
			GetPVarInt(playerid, "skill3level"),
			GetPlayerNameEx(playerid));
			mysql_query(query);
			
		}
		else if(GetPVarInt(playerid, "ipment") == 1)
	    {
			format(query, sizeof(query), "UPDATE `users` SET \
			Money = %d,\
			Bank = %d,\
			Kills = %d,\
			Deaths = %d,\
			Level = %d,\
			Team = %d,\
			Skin = %d,\
			RendorTP = %d,\
			KatonaTP =  %d,\
			BankosTP = %d,\
			KamrovidTP = %d,\
			KamhosszuTP = %d,\
			Spawn =  %d,\
			Ora =  %d,\
			Perc =  %d,\
			Leader =  %d,\
			AJtime =  %d,\
			Sskin = %d,\
			Clan = '%s',\
			ClanRank = %d,\
			VIP = %d,\
			Szint = %d,\
			EXP = %d WHERE (`Name` = '%s')",
		 	GetPlayerMoneyEx(playerid),
		 	GetPVarInt(playerid, "Bank"),
		 	GetPVarInt(playerid, "Kills"),
		 	GetPVarInt(playerid, "Deaths"),
		 	GetPVarInt(playerid, "Level"),
		 	cGetPlayerTeam(playerid),
		 	GetPVarInt(playerid, "Skin"),
	 	 	GetPVarInt(playerid, "RendorTP"),
	 	 	GetPVarInt(playerid, "KatonaTP"),
	 	 	GetPVarInt(playerid, "BankosTP"),
	 	 	GetPVarInt(playerid, "KamrovidTP"),
	 	 	GetPVarInt(playerid, "KamhosszuTP"),
	 	 	GetPVarInt(playerid, "Spawnhely"),
	 	 	GetPVarInt(playerid, "Ora"),
	 	 	GetPVarInt(playerid, "Perc"),
	 	 	GetPVarInt(playerid, "Leader"),
	 	 	GetPVarInt(playerid, "AJtime"),
	 	 	GetPVarInt(playerid, "Sskin"),
	 	 	clanname,
			GetPVarInt(playerid, "ClanRank"),
			GetPVarInt(playerid, "VIP"),
			GetPVarInt(playerid, "Szint"),
			GetPVarInt(playerid, "EXP"),
		 	GetPlayerNameEx(playerid));
			mysql_query(query);
			
   			format(query, sizeof(query), "UPDATE achievements SET \
			knifes = %d,\
			9mm = %d,\
			Deagle = %d,\
			AK47 = %d,\
			Deaths = %d,\
			Policekills = %d,\
			Armykills = %d,\
			Rodkills = %d,\
			SMG = %d,\
			RaceRecords = %d,\
			Racegold = %d,\
			Racesilver = %d,\
			Racebronze = %d,\
			dmwins = %d,\
			vehdrives = %d,\
			shoprob = %d,\
			jails = %d, \
			elsohaz = %d, \
			elsokocsi = %d, \
			elsobiz = %d, \
			leaderesm = %d, \
			elsoclantag = %d, \
			elsoclan = %d, \
			horgaszat = %d, \
			reakcio = %d WHERE Name = '%s'",
			GetPVarInt(playerid, "knifes"),
			GetPVarInt(playerid, "9mm"),
			GetPVarInt(playerid, "Deagle"),
			GetPVarInt(playerid, "AK47"),
			GetPVarInt(playerid, "Deathsat"),
			GetPVarInt(playerid, "Policekills"),
			GetPVarInt(playerid, "Armykills"),
			GetPVarInt(playerid, "Rodkills"),
			GetPVarInt(playerid, "SMG"),
			GetPVarInt(playerid, "RaceRecords"),
			GetPVarInt(playerid, "Racegold"),
			GetPVarInt(playerid, "Racesilver"),
			GetPVarInt(playerid, "Racebronze"),
			GetPVarInt(playerid, "dmwins"),
			GetPVarInt(playerid, "vehdrives"),
			GetPVarInt(playerid, "shoprob"),
			GetPVarInt(playerid, "jails"),
			GetPVarInt(playerid, "elsohaz"),
			GetPVarInt(playerid, "elsokocsi"),
			GetPVarInt(playerid, "elsobiz"),
			GetPVarInt(playerid, "leaderesm"),
			GetPVarInt(playerid, "elsoclantag"),
			GetPVarInt(playerid, "elsoclan"),
			GetPVarInt(playerid, "horgaszat"),
			GetPVarInt(playerid, "reakcio"),
			GetPlayerNameEx(playerid));
			mysql_query(query);
			
			format(query, sizeof(query), "UPDATE achievements SET \
			area = %d WHERE Name = '%s'",
			GetPVarInt(playerid, "area"),
			GetPlayerNameEx(playerid));
			mysql_query(query);
			
			format(query, sizeof(query), "UPDATE skills SET \
			Skillpoints = %d,\
			Skill1Level = %d,\
			Skill2Level = %d,\
			Skill3Level = %d WHERE Name = '%s'",
            GetPVarInt(playerid, "skillpoints"),
			GetPVarInt(playerid, "skill1level"),
			GetPVarInt(playerid, "skill2level"),
			GetPVarInt(playerid, "skill3level"),
			GetPlayerNameEx(playerid));
			mysql_query(query);
		}
	}
}

#if defined ENABLE_SPECTATE
forward OnPlayerVirtualWorldChange(playerid, newvirtualworldid, oldvirtualworldid);
public OnPlayerVirtualWorldChange(playerid, newvirtualworldid, oldvirtualworldid)
{
    for(new x=0; x<MAX_PLAYERS; x++)
	{
 		if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid && Spec[x][SpectateType] == ADMIN_SPEC_TYPE_VEHICLE || GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid && Spec[x][SpectateType] == ADMIN_SPEC_TYPE_PLAYER)
        {
   		    SetPlayerVirtualWorld(x,newvirtualworldid);
		}
	}
}

forward SpectatorUpdate(playerid);
public SpectatorUpdate(playerid)
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	    if(GetPlayerState(i) == PLAYER_STATE_SPECTATING && Spec[i][SpectateType] == ADMIN_SPEC_TYPE_PLAYER || GetPlayerState(i) == PLAYER_STATE_SPECTATING && Spec[i][SpectateType] == ADMIN_SPEC_TYPE_VEHICLE)
	    {
			if(IsPlayerValid(i))
			{
				if(Spec[i][SpectateUpdate] < 253 && Spec[i][SpectateUpdate] != 255)
				{
					new targetid = Spec[i][SpectateUpdate];
					if(IsPlayerValid(targetid))
					{
					    //if(IsPlayerAdminEx(i))// Change this to whatever your Admin Script is Defined as.
					    if(GetPVarInt(playerid, "Level") > 0)
					    {
							new string[100], Float:hp, Float:ar;
							GetPlayerName(targetid,string,sizeof(string));
							GetPlayerHealth(targetid, hp);	GetPlayerArmour(targetid, ar);
							format(string,sizeof(string),"~n~~n~~n~~n~~w~%s - id:%d~n~health:%0.1f armour:%0.1f money:$%d", string,targetid,hp,ar,GetPlayerMoneyEx(targetid) );
							GameTextForPlayer(i,string,4000,3);
						}
					}
				}
				if(Spec[i][SpectateUpdate] == 253)
				{
					Spec[i][SpectateUpdate] = 255;
				}
			}
		}
	}
}

stock StartSpectate(playerid, specplayerid)
{
	for(new x=0; x<MAX_PLAYERS; x++)
	{
	    if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] == playerid)
		{
	       AdvanceSpectate(x);
		}
	}
	TogglePlayerSpectating(playerid, 1);
	Spec[playerid][SpectateUpdate] = specplayerid;
	SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(specplayerid));
	if(IsPlayerInAnyVehicle(specplayerid))
	{
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayerid));
		Spec[playerid][SpectateID] = specplayerid;
		Spec[playerid][SpectateType] = ADMIN_SPEC_TYPE_VEHICLE;
	}
	else
	{
		PlayerSpectatePlayer(playerid, specplayerid);
		Spec[playerid][SpectateID] = specplayerid;
		Spec[playerid][SpectateType] = ADMIN_SPEC_TYPE_PLAYER;
	}
	return 1;
}

stock StopSpectate(playerid)
{
	TogglePlayerSpectating(playerid, 0);
	Spec[playerid][SpectateID] = INVALID_PLAYER_ID;
	Spec[playerid][SpectateType] = ADMIN_SPEC_TYPE_NONE;
	Spec[playerid][SpectateUpdate] = 255;
	//GameTextForPlayer(playerid,"~n~~n~~n~~w~Spect˜l˜s befejezve!",1000,3);
	return 1;
}

stock AdvanceSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Spec[playerid][SpectateID] != INVALID_PLAYER_ID)
	{
	    for(new x=Spec[playerid][SpectateID]+1; x<=MAX_PLAYERS; x++)
		{
	    	if(x == MAX_PLAYERS) x = 0;
	        if(IsPlayerValid(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}

stock ReverseSpectate(playerid)
{
    if(ConnectedPlayers() == 2) { StopSpectate(playerid); return 1; }
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && Spec[playerid][SpectateID] != INVALID_PLAYER_ID)
	{
	    for(new x=Spec[playerid][SpectateID]-1; x>=0; x--)
		{
	    	if(x == 0) x = MAX_PLAYERS;
	        if(IsPlayerValid(x) && x != playerid)
			{
				if(GetPlayerState(x) == PLAYER_STATE_SPECTATING && Spec[x][SpectateID] != INVALID_PLAYER_ID || (GetPlayerState(x) != 1 && GetPlayerState(x) != 2 && GetPlayerState(x) != 3))
				{
					continue;
				}
				else
				{
					StartSpectate(playerid, x);
					break;
				}
			}
		}
	}
	return 1;
}
#endif

forward ConnectedPlayers();
public ConnectedPlayers()
{
	new Connected;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerValid(i)) Connected++;
	return Connected;
}

//két pont közötti távolság
stock Float:GetDistanceBetweenPoints(Float:X, Float:Y, Float:Z, Float:PointX, Float:PointY, Float:PointZ)
{
	new Float:Distance;
	Distance = floatabs(floatsub(X, PointX)) + floatabs(floatsub(Y, PointY)) + floatabs(floatsub(Z, PointZ));
	return Distance;
}

//két pont közötti távolság (Z kivéve)
stock Float:GetDistanceBetweenPoint(Float:X, Float:Y, Float:PointX, Float:PointY)
{
	new Float:Distance;
	Distance = floatabs(floatsub(X, PointX)) + floatabs(floatsub(Y, PointY));
	return Distance;
}


forward antic();
public antic()
{
	new weaponid=0,ammo=0,mp = GetMaxPlayers();
    for(new i; i < mp; i++)
    {
		for(new slot=0; slot<13; slot++)
		{
			GetPlayerWeaponData(i,slot,weaponid,ammo);
			//if( (weaponid == 35) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhasználat", "SYSTEM"); //RPG
			if( (weaponid == 36) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhasználat", "SYSTEM"); //Rocket Launcher
			else if( (weaponid == 37) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhasználat", "SYSTEM"); //Lángszóró
			else if( (weaponid == 38) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhasználat", "SYSTEM"); //Minigun
			else if( (weaponid == 39) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhasználat", "SYSTEM"); //Robbantó táska
		}
		/*if(GetVehicleSpeed(GetPlayerVehicleID(i)) >= 250)
		{
		    BanReason(i, "Speed hack", "SYSTEM");
		}*/
	}
	/*for(new i; i < MAX_PLAYERS; i++)
	{
	    if(IsPlayerNPC(i)) continue;
	    if(GetPlayerState(i) == PLAYER_STATE_DRIVER)
	    {
			if(GetVehicleSpeed(GetPlayerVehicleID(i)) >= 700)
			{
			    BanReason(i, "Speedhack (Anticheat)", "SYSTEM");
			}
	    }
	    if(GetPVarInt(i, "Logged") == 1)
	    {
	        if(GetPlayerState(i) == PLAYER_STATE_ONFOOT)
	        {
	            if(GetPVarFloat(i, "acoX") == 0)
			    {
			        new Float:aco[3];
		     		GetPlayerPos(i, aco[0], aco[1], aco[2]);
		     		SetPVarFloat(i, "acoX", aco[0]);
		     		SetPVarFloat(i, "acoY", aco[1]);
		     		SetPVarFloat(i, "acoZ", aco[2]);
		     		continue;
				}
				new Float:acn[3];
				GetPlayerPos(i, acn[0], acn[1], acn[2]);
				SetPVarFloat(i, "acnX", acn[0]);
				SetPVarFloat(i, "acnY", acn[1]);
				SetPVarFloat(i, "acnZ", acn[2]);
				if(GetPVarInt(i, "valami") == 1)
				{
				    SendFormatMessage(i, COLOR_GREEN, "távolság: %0.2f a", GetDistanceBetweenPoint(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY")));
				    //SendFormatMessage(i, COLOR_GREEN, "távolság: %0.2f b", GetDistanceBetweenPoints(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acoZ"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY"), GetPVarFloat(i, "acnZ")));
					//SendFormatMessage(i, COLOR_RED, "oldX: %0.2f", GetPVarFloat(i, "acoX"));
					//SendFormatMessage(i, COLOR_RED, "oldY: %0.2f", GetPVarFloat(i, "acoY"));
					//SendFormatMessage(i, COLOR_RED, "oldZ: %0.2f", GetPVarFloat(i, "acoZ"));
					//SendFormatMessage(i, COLOR_RED, "newX: %0.2f", GetPVarFloat(i, "acnX"));
					//SendFormatMessage(i, COLOR_RED, "newX: %0.2f", GetPVarFloat(i, "acnY"));
					//SendFormatMessage(i, COLOR_RED, "newX: %0.2f", GetPVarFloat(i, "acnZ"));
//					SendFormatMessage(i, COLOR_RED, "Newinterior: %d", GetPVarInt(i, "acnInter"));
//					SendFormatMessage(i, COLOR_RED, "Oldinterior: %d", GetPVarInt(i, "acoInter"));
					if(GetDistanceBetweenPoint(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY")) >= 150)
					{
					    if(GetPVarInt(i, "acInterc") == 0)
						{
						    if(!IsPlayerInAnyVehicle(i))
						    {
								SendClientMessage(i, COLOR_RED, "kickelni kéne téged");
					    		//continue;
							}
						}
					}
				}
				SetPVarFloat(i, "acoX", GetPVarFloat(i, "acnX"));
				SetPVarFloat(i, "acoY", GetPVarFloat(i, "acnY"));
				SetPVarFloat(i, "acoZ", GetPVarFloat(i, "acnZ"));
				SetPVarInt(i, "acInterc", 0);
	        }
	        if(GetPlayerState(i) == PLAYER_STATE_SPAWNED)
			{
			    if(GetPVarFloat(i, "acoX") == 0)
			    {
			        new Float:aco[3];
		     		GetPlayerPos(i, aco[0], aco[1], aco[2]);
		     		SetPVarFloat(i, "acoX", aco[0]);
		     		SetPVarFloat(i, "acoY", aco[1]);
		     		SetPVarFloat(i, "acoZ", aco[2]);
		     		SetPVarInt(i, "acoInter", GetPlayerInterior(i));
		     		continue;
				}
				new Float:acn[3];
				GetPlayerPos(i, acn[0], acn[1], acn[2]);
				SetPVarFloat(i, "acnX", acn[0]);
				SetPVarFloat(i, "acnY", acn[1]);
				SetPVarFloat(i, "acnZ", acn[2]);
				SetPVarInt(i, "acnInter", GetPlayerInterior(i));
				if(GetDistanceBetweenPoint(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY")) >= 150)
				{
				    if(GetPVarInt(i, "valami") == 1)
					{
					    SendFormatMessage(i, COLOR_GREEN, "távolság: %0.2f a", GetDistanceBetweenPoint(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY")));
					}
				    if(GetPVarInt(i, "acoInter") == GetPVarInt(i, "acnInter"))
					{
					    if(!IsPlayerInAnyVehicle(i))
					    {
							KickReason(i, "Anticheat (Airbreak)", "SYSTEM");
				    		continue;
						}
					}
				}
				if(GetPVarInt(i, "valami") == 1)
				{
				    SendFormatMessage(i, COLOR_GREEN, "távolság: %0.2f", GetDistanceBetweenPoint(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY")));
				}
				SetPVarFloat(i, "acoX", GetPVarFloat(i, "acnX"));
				SetPVarFloat(i, "acoY", GetPVarFloat(i, "acnY"));
				SetPVarFloat(i, "acoZ", GetPVarFloat(i, "acnZ"));
				SetPVarInt(i, "acoInter", GetPVarInt(i, "acnInter"));
			}
		}
	}*/
}

#if defined CHANGERCON
forward rcontimer();
public rcontimer()
{
	new rconstr[100];
	rconszam++;
	rconszam2++;
	format(rconstr, sizeof(rconstr), "rcon_password %d%s%d", rconszam2, rconjelszo, rconszam);
	SendRconCommand(rconstr);
}
#endif

#if defined PING_KICK
forward PingCheck1(playerid);
public PingCheck1(playerid)
{
	SetPVarInt(playerid, "Ping1", GetPlayerPing(playerid));
	SetTimerEx("PingCheck2", 1*60*1000, false, "i", playerid);
}

forward PingCheck2(playerid);
public PingCheck2(playerid)
{
	SetPVarInt(playerid, "Ping2", GetPlayerPing(playerid));
	SetTimerEx("PingCheck3", 1*60*1000, false, "i", playerid);
}

forward PingCheck3(playerid);
public PingCheck3(playerid)
{
	SetPVarInt(playerid, "Ping3", GetPlayerPing(playerid));
	SetTimerEx("PingCheck", 1*1000, false, "i", playerid);
}

forward PingCheck(playerid);
public PingCheck(playerid)
{
	new pingaverage = (GetPVarInt(playerid, "Ping1")+GetPVarInt(playerid, "Ping2")+GetPVarInt(playerid, "Ping3"))/3;
	if(pingaverage >= GetGVarInt("MaxPing"))
	{
	    new pingkickreason[128];
	    format(pingkickreason, sizeof(pingkickreason), "Magas ping: %d (Maximális megengedett ping: %d)", pingaverage, GetGVarInt("MaxPing"));
		KickReason(playerid, pingkickreason, "SYSTEM");
	}
	else
	{
	    SetTimerEx("PingCheck1", 1*60*1000, false, "i", playerid);
	    SetPVarInt(playerid, "Ping1", 0);
	    SetPVarInt(playerid, "Ping2", 0);
	    SetPVarInt(playerid, "Ping3", 0);
	}
}
#endif

/*forward AntiMoney();
public AntiMoney()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
	    ResetPlayerMoney(i);
		GivePlayerMoney(i, GetPVarInt(i, "Money"));
		if(GetPlayerMoneyEx(i) <= -20000 || GetPlayerMoneyEx(i) >= 100000000)
		{
			BanEx(i, "pénzcheat");
		}
	}
}*/

forward elteltido(playerid);
public elteltido(playerid)
{
    if(GetPVarInt(playerid, "Perc") != 59)
    {
		SetPVarInt(playerid, "Perc", GetPVarInt(playerid, "Perc")+1);
	}
	else if(GetPVarInt(playerid, "Perc") == 59)
	{
		SetPVarInt(playerid, "Ora", GetPVarInt(playerid, "Ora")+1);
	    SetPVarInt(playerid, "Perc", 0);
	}

	if(GetPVarInt(playerid, "Ora") == 10 && GetPVarInt(playerid, "Perc") == 0)
    {
		CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "ld_grav:timer", "10 játszott óra", "Kezdõ játékos");
		CallRemoteFunction("GiveEXPpublic", "ii", playerid, 100);
    }
    if(GetPVarInt(playerid, "Ora") == 50 && GetPVarInt(playerid, "Perc") == 0)
    {
		CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "ld_grav:timer", "50 játszott óra", "Haladó játékos");
		CallRemoteFunction("GiveEXPpublic", "ii", playerid, 500);
    }
    if(GetPVarInt(playerid, "Ora") == 100 && GetPVarInt(playerid, "Perc") == 0)
    {
		CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "ld_grav:timer", "100 játszott óra", "Profi játékos");
		CallRemoteFunction("GiveEXPpublic", "ii", playerid, 1000);
    }
    if(GetPVarInt(playerid, "Ora") == 200 && GetPVarInt(playerid, "Perc") == 0)
    {
		CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "ld_grav:timer", "200 játszott óra", "Vérprofi játékos");
		CallRemoteFunction("GiveEXPpublic", "ii", playerid, 2000);
    }
}

forward resitimer();
public resitimer()
{
	new hour, minut, secu;
	gettime(hour, minut, secu);
	if(hour == 6)
	{
	    if(minut == 0)
	    {
	        for(new i; i < MAX_PLAYERS; i++)
	        {
	        	SavePlayer(i);
			}
	        SendRconCommand("changemode sfgg");
	        SendRconCommand("reloadfs admin");
	        SendRconCommand("reloadfs objectek");
	        SendRconCommand("changemode sfgg");
		}
	}
}

/*CMD:vasd(playerid)
{
	new str[2975];
    for(new x = 0; x < 230; x++)
    {
        format(query, sizeof(query), "SELECT Name, vehid, ar FROM autoadatok WHERE ID = '%d'", x);
        mysql_query(query);
        mysql_store_result();
        if(mysql_num_rows() != 0)
        {
            mysql_fetch_row(linen);
            new tarolo[24], tarolo2, tarolo3[20];
            sscanf(linen, "p<|>s[24]ds[11]", tarolo, tarolo2, tarolo3);
            mysql_free_result();
        	format(str, sizeof str, "%sNév: %s, VehID: %d, Ár: %s\n", str, tarolo, tarolo2, tarolo3);
		}
    }
    ShowPlayerDialog(playerid, 9595, DIALOG_STYLE_LIST, "Autó", str, "Vesz", "Mégse");
	return 1;
}*///így kell kiiratni valamit dialogba, pl nem tudom mit... lényeg hogy értem

stock GetDistanceBetweenPlayers(playerid, playerid2)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	new Float:tmpdis;
	GetPlayerPos(playerid,x1,y1,z1);
	GetPlayerPos(playerid2,x2,y2,z2);
	tmpdis = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
	return floatround(tmpdis);
}

stock GetPlayerID(const playername[], partofname=0)
{
	new i;
	new playername1[64];
	for (i=0;i<MAX_PLAYERS;i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i,playername1,sizeof(playername1));
			if (strcmp(playername1,playername,true)==0)
			{
				return i;
			}
		}
	}
	new correctsigns_userid=-1;
	new tmpuname[128];
	new hasmultiple=-1;
	if(partofname)
	{
		for (i=0;i<MAX_PLAYERS;i++)
		{
			if (IsPlayerConnected(i))
			{
				GetPlayerName(i,tmpuname,sizeof(tmpuname));

				if(!strfind(tmpuname,playername1[partofname],true, 0))
				{
					hasmultiple++;
					correctsigns_userid=i;
				}
				if (hasmultiple>0)
				{
					return -2;
				}
			}
		}
	}
	return correctsigns_userid;
}

stock IsPlayerAdminEx(playerid)
{
	if(IsPlayerAdmin(playerid))
	{
	    if(GetPVarInt(playerid, "IsPlayerAdminEx") == 1)
	    {
	        return true;
	    }
	    else return false;
	}
	else return false;
}

//----------------------------------Havazás by Kwarde(?)------------------------
#if defined HAVAZAS
/*stock CreateSnow(playerid)
{
	if(snowOn{playerid}) return 0;
	new Float:pPos[3];
	GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
	if(GetPlayerInterior(playerid) == 0) for(new i = 0; i < MAX_SNOW_OBJECTS; i++) snowObject[playerid][i] = CreateDynamicObject(18864, pPos[0] + random(50), pPos[1] + random (50), pPos[2] - 50 + random(50), 0, 0, 0, -1, -1, playerid);
	snowOn{playerid} = true;
	if(GetPlayerInterior(playerid) != 0) SetPVarInt(playerid, "oldint", GetPlayerInterior(playerid));
	updateTimer{playerid} = SetTimerEx("UpdateSnow", UPDATE_INTERVAL, true, "i", playerid);
	return 1;
}

stock DeleteSnow(playerid)
{
	if(!snowOn{playerid}) return 0;
	for(new i = 0; i < MAX_SNOW_OBJECTS; i++) DestroyDynamicObject(snowObject[playerid][i]);
	KillTimer(updateTimer{playerid});
	snowOn{playerid} = false;
	return 1;
}

CB:UpdateSnow(playerid)
{
	if(!snowOn{playerid}) return 0;
	new Float:pPos[3];
	GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
	if(GetPlayerInterior(playerid) != 0) for(new i = 0; i < MAX_SNOW_OBJECTS; i++) DestroyDynamicObject(snowObject[playerid][i]), SetPVarInt(playerid, "oldint", GetPlayerInterior(playerid));
	if(GetPVarInt(playerid, "oldint") != 0 && GetPlayerInterior(playerid) == 0) { for(new i = 0; i < MAX_SNOW_OBJECTS; i++) snowObject[playerid][i] = CreateDynamicObject(18864, pPos[0] + random(50), pPos[1] + random (50), pPos[2] - 50 + random(50), 0, 0, 0, -1, -1, playerid), SetPVarInt(playerid, "oldint", 0); return 1; }
	for(new i = 0; i < MAX_SNOW_OBJECTS; i++) SetDynamicObjectPos(snowObject[playerid][i], pPos[0] + random(50), pPos[1] + random(50), pPos[2] - 50 + random(50));
	return 1;
}*/

stock CreateSnow(Float:x, Float:y, Float:z)
{
	for(new i = 0; i < MAX_SNOW_OBJECTS; i++) snowObject[i] = CreateDynamicObject(18864, x + random(50), y + random (50), z + random(10), 0, 0, 0, -1, -1);
	return 1;
}

stock DeleteSnow()
{
	for(new i = 0; i < MAX_SNOW_OBJECTS; i++) DestroyDynamicObject(snowObject[i]);
	//KillTimer(updateTimer{playerid});
	return 1;
}

/*CB:UpdateSnow(playerid)
{
	if(!snowOn{playerid}) return 0;
	new Float:pPos[3];
	GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
	if(GetPlayerInterior(playerid) != 0) for(new i = 0; i < MAX_SNOW_OBJECTS; i++) DestroyDynamicObject(snowObject[playerid][i]), SetPVarInt(playerid, "oldint", GetPlayerInterior(playerid));
	if(GetPVarInt(playerid, "oldint") != 0 && GetPlayerInterior(playerid) == 0) { for(new i = 0; i < MAX_SNOW_OBJECTS; i++) snowObject[playerid][i] = CreateDynamicObject(18864, pPos[0] + random(50), pPos[1] + random (50), pPos[2] - 50 + random(50), 0, 0, 0, -1, -1, playerid), SetPVarInt(playerid, "oldint", 0); return 1; }
	for(new i = 0; i < MAX_SNOW_OBJECTS; i++) SetDynamicObjectPos(snowObject[playerid][i], pPos[0] + random(50), pPos[1] + random(50), pPos[2] - 50 + random(50));
	return 1;
}*/
#endif

//karácsonyi dolgok

#if defined AJANDEKOK
stock CreateGift(id, Float:X, Float:Y, Float:Z)
{
    switch(random(5))
	{
		case 0: gifts[id] = CreateDynamicObject(19055, X, Y, Z, 0, 0, 0);
		case 1: gifts[id] = CreateDynamicObject(19056, X, Y, Z, 0, 0, 0);
		case 2: gifts[id] = CreateDynamicObject(19057, X, Y, Z, 0, 0, 0);
		case 3: gifts[id] = CreateDynamicObject(19058, X, Y, Z, 0, 0, 0);
		case 4: gifts[id] = CreateDynamicObject(19054, X, Y, Z, 0, 0, 0);
	}
	giftarea[id] = CreateDynamicSphere(X, Y, Z, 2, 0, 0, -1);
	
}

stock DestroyGift(id)
{
	DestroyDynamicObject(gifts[id]);
	DestroyDynamicArea(giftarea[id]);
}

public ajandekrespawn()
{
    for(new i; i < MAX_GIFTS; i++)
    {
        DestroyGift(gifts[i]);
    }
    switch(random(3))
    {
        case 0: CreateGift(0, giftpost[0][gx],giftpost[0][gy],giftpost[0][gz]);
        case 1: CreateGift(0, giftpost[1][gx],giftpost[1][gy],giftpost[1][gz]);
        case 2: CreateGift(0, giftpost[2][gx],giftpost[2][gy],giftpost[2][gz]);

    }
    switch(random(3))
    {
        case 0: CreateGift(1, giftpost[3][gx],giftpost[3][gy],giftpost[3][gz]);
        case 1: CreateGift(1, giftpost[4][gx],giftpost[4][gy],giftpost[4][gz]);
        case 2: CreateGift(1, giftpost[5][gx],giftpost[5][gy],giftpost[5][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(2, giftpost[6][gx],giftpost[6][gy],giftpost[6][gz]);
        case 1: CreateGift(2, giftpost[7][gx],giftpost[7][gy],giftpost[7][gz]);
        case 2: CreateGift(2, giftpost[8][gx],giftpost[8][gy],giftpost[8][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(3, giftpost[9][gx],giftpost[9][gy],giftpost[9][gz]);
        case 1: CreateGift(3, giftpost[10][gx],giftpost[10][gy],giftpost[10][gz]);
        case 2: CreateGift(3, giftpost[11][gx],giftpost[11][gy],giftpost[11][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(4, giftpost[12][gx],giftpost[12][gy],giftpost[12][gz]);
        case 1: CreateGift(4, giftpost[13][gx],giftpost[13][gy],giftpost[13][gz]);
        case 2: CreateGift(4, giftpost[14][gx],giftpost[14][gy],giftpost[14][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(5, giftpost[15][gx],giftpost[15][gy],giftpost[15][gz]);
        case 1: CreateGift(5, giftpost[16][gx],giftpost[16][gy],giftpost[16][gz]);
        case 2: CreateGift(5, giftpost[17][gx],giftpost[17][gy],giftpost[17][gz]);
    }
    switch(random(3))
    {
        case 0: CreateGift(6, giftpost[18][gx],giftpost[18][gy],giftpost[18][gz]);
        case 1: CreateGift(6, giftpost[19][gx],giftpost[19][gy],giftpost[19][gz]);
        case 2: CreateGift(6, giftpost[20][gx],giftpost[20][gy],giftpost[20][gz]);
    }
    switch(random(3))
    {
	    case 0: CreateGift(7, giftpost[21][gx],giftpost[21][gy],giftpost[21][gz]);
        case 1: CreateGift(7, giftpost[22][gx],giftpost[22][gy],giftpost[22][gz]);
        case 2: CreateGift(7, giftpost[23][gx],giftpost[23][gy],giftpost[23][gz]);
	}
	switch(random(3))
	{
		case 0: CreateGift(8, giftpost[24][gx],giftpost[24][gy],giftpost[24][gz]);
        case 1: CreateGift(8, giftpost[25][gx],giftpost[25][gy],giftpost[25][gz]);
        case 2: CreateGift(8, giftpost[26][gx],giftpost[26][gy],giftpost[26][gz]);
	}
	switch(random(3))
	{
		case 0: CreateGift(9, giftpost[27][gx],giftpost[27][gy],giftpost[27][gz]);
        case 1: CreateGift(9, giftpost[28][gx],giftpost[28][gy],giftpost[28][gz]);
        case 2: CreateGift(9, giftpost[29][gx],giftpost[29][gy],giftpost[29][gz]);
	}
	switch(random(3))
	{
		case 0: CreateGift(10, giftpost[30][gx],giftpost[30][gy],giftpost[30][gz]);
        case 1: CreateGift(10, giftpost[31][gx],giftpost[31][gy],giftpost[31][gz]);
        case 2: CreateGift(10, giftpost[32][gx],giftpost[32][gy],giftpost[32][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(11, giftpost[33][gx],giftpost[33][gy],giftpost[33][gz]);
        case 1: CreateGift(11, giftpost[34][gx],giftpost[34][gy],giftpost[34][gz]);
        case 2: CreateGift(11, giftpost[35][gx],giftpost[35][gy],giftpost[35][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(12, giftpost[36][gx],giftpost[36][gy],giftpost[36][gz]);
        case 1: CreateGift(12, giftpost[37][gx],giftpost[37][gy],giftpost[37][gz]);
        case 2: CreateGift(12, giftpost[38][gx],giftpost[38][gy],giftpost[38][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(13, giftpost[39][gx],giftpost[39][gy],giftpost[39][gz]);
        case 1: CreateGift(13, giftpost[40][gx],giftpost[40][gy],giftpost[40][gz]);
        case 2: CreateGift(13, giftpost[41][gx],giftpost[41][gy],giftpost[41][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(14, giftpost[42][gx],giftpost[42][gy],giftpost[42][gz]);
        case 1: CreateGift(14, giftpost[43][gx],giftpost[43][gy],giftpost[43][gz]);
        case 2: CreateGift(14, giftpost[44][gx],giftpost[44][gy],giftpost[44][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(15, giftpost[45][gx],giftpost[45][gy],giftpost[45][gz]);
        case 1: CreateGift(15, giftpost[46][gx],giftpost[46][gy],giftpost[46][gz]);
        case 2: CreateGift(15, giftpost[47][gx],giftpost[47][gy],giftpost[47][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(16, giftpost[48][gx],giftpost[48][gy],giftpost[48][gz]);
        case 1: CreateGift(16, giftpost[49][gx],giftpost[49][gy],giftpost[49][gz]);
        case 2: CreateGift(16, giftpost[50][gx],giftpost[50][gy],giftpost[50][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(17, giftpost[51][gx],giftpost[51][gy],giftpost[51][gz]);
        case 1: CreateGift(17, giftpost[52][gx],giftpost[52][gy],giftpost[52][gz]);
        case 2: CreateGift(17, giftpost[53][gx],giftpost[53][gy],giftpost[53][gz]);
	}
	switch(random(3))
	{
	    case 0: CreateGift(18, giftpost[54][gx],giftpost[54][gy],giftpost[54][gz]);
        case 1: CreateGift(18, giftpost[55][gx],giftpost[55][gy],giftpost[55][gz]);
        case 2: CreateGift(18, giftpost[56][gx],giftpost[56][gy],giftpost[56][gz]);
	}
}

#endif

stock CreateChristmasTree(Float:X, Float:Y, Float:Z)
{
	fa[0] = CreateObject(19076,X+0.28564453,Y+0.23718262,Z-1,0.00000000,0.00000000,230.48021);
	fa[1] = CreateObject(19055,X+1,Y+3,Z-0.3,0.00000000,0.00000000, 0);
	fa[2] = CreateObject(19058,X-1,Y+3,Z-0.3,0.00000000,0.00000000, 0);
	fa[3] = CreateObject(19056,X-1,Y-3,Z-0.3,0.00000000,0.00000000, 0);
	fa[4] = CreateObject(19057,X+2,Y-3,Z-0.3,0.00000000,0.00000000, 0);
 	fa[5] = CreateObject(19054,X+4,Y+2,Z-0.3,0.00000000,0.00000000, 0);
	//jetpack = CreateDynamicPickup(370, 2, X+4,Y+2,Z-0.3, 0);
	//pirula = CreateDynamicPickup(1241, 2, X+2,Y-3,Z-0.3, 0);
	//gaz = CreateDynamicPickup(343, 2, X-1,Y-3,Z-0.3, 0);
	sapka = CreateDynamicSphere(X+1,Y+3,Z-0.3, 2, 0, 0, -1);
	laser = CreateDynamicSphere(X-1,Y+3,Z-0.3, 2, 0, 0, -1);
	jetpack = CreateDynamicSphere(X-1,Y-3,Z-0.3, 2, 0, 0, -1);
	gaz = CreateDynamicSphere(X+2,Y-3,Z-0.3, 2, 0, 0, -1);
	SetGVarInt("fa", 1);
}

stock DeleteChristmasTree()
{
	for(new i; i < sizeof(fa); i++)
	{
	    DestroyObject(fa[i]);
	}
	//DestroyDynamicPickup(jetpack);
	DestroyDynamicPickup(pirula);
	//DestroyDynamicPickup(gaz);
	DestroyDynamicArea(sapka);
	DestroyDynamicArea(laser);
	DestroyDynamicArea(jetpack);
	DestroyDynamicArea(gaz);
	SetGVarInt("fa", 0);
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	#if defined AJANDEKOK
    if(IsPlayerInDynamicArea(playerid, sapka))
	{
		if(playersapka[playerid] == false)
		{
			if(GetPlayerSkin(playerid) == 30) SetPlayerAttachedObject( playerid, 5, 19066, 2, 0.135741, -0.00, 0.0, 194.897018, 97.656661, 266.509033, 1.000000, 1.000000, 1.000000 ); // SantaHat3 - sapka
			else SetPlayerAttachedObject( playerid, 5, 19066, 2, 0.128741, 0.014756, 0.008071, 194.897018, 97.656661, 266.509033, 1.000000, 1.000000, 1.000000 );
			playersapka[playerid] = true;
		}
	}
	if(IsPlayerInDynamicArea(playerid, laser))
	{
	    if(GetPVarInt(playerid, "laser") == 0)
	    {
	        SetPVarInt(playerid, "laser", 1);
    		GivePlayerWeapon(playerid, 31, 50);
    		GivePlayerWeapon(playerid, 23, 50);
	    }
	}
	if(IsPlayerInDynamicArea(playerid, jetpack))
	{
	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
	}
	if(IsPlayerInDynamicArea(playerid, gaz))
	{
	    GivePlayerWeapon(playerid, 17, 10);
	}
	for(new i; i < MAX_GIFTS; i++)
	{
		if(IsPlayerInDynamicArea(playerid, giftarea[i]))
		{
		    if(IsPlayerInAnyVehicle(playerid)) return 1;
	        SetPVarInt(playerid, "Gift", GetPVarInt(playerid, "Gift")+1);
			SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Találtál egy ajándékcsomagot! A /gift paranccsal adhatod oda valakinek, a /gifto paranccsal kinyithatod.");
			SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Megjegyzés: Az ajándékok miután kilépsz elvesznek!");
			DestroyGift(i);
		}
	}
	#endif
	/*if(IsPlayerInDynamicArea(playerid, diszarea[0])) GameTextForPlayer(playerid, "c", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[1])) GameTextForPlayer(playerid, "s", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[2])) GameTextForPlayer(playerid, "i", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[3])) GameTextForPlayer(playerid, "l", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[4])) GameTextForPlayer(playerid, "l", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[5])) GameTextForPlayer(playerid, "a", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[6])) GameTextForPlayer(playerid, "g", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[7])) GameTextForPlayer(playerid, "s", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[8])) GameTextForPlayer(playerid, "z", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[9])) GameTextForPlayer(playerid, "ó", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[10])) GameTextForPlayer(playerid, "r", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[11])) GameTextForPlayer(playerid, "ó", 2000, 4);*/
	
	#if defined KARACSONYIJATEK
	if(IsPlayerInAnyVehicle(playerid)) return 1;
	new dialogstr[1500];
	if(IsPlayerInDynamicArea(playerid, jatekarea[0]))
	{
		new Float: pp[3];
		GetPlayerPos(playerid, pp[0], pp[1], pp[2]);
		SetPlayerPosEx(playerid, pp[0]+4, pp[1], pp[2]);
	    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s%s%s%s%s%s%s",
	    "Alap történet (Ezt már elmondta a játékszervezõ):\n",
	    "Különös dolgokat láttak ma egy sikátor felett... Egy sikátor felett, ahol télen mindig különös dolgok történnek.\n",
	    "Ezt a különös dolgot egy Burger Shoot-ban dolgozó munkás vette észre. Arról számolt be hogy minden évben karácsonykor látta.\n",
	    "Látott elrepülni egy különös dolgot a sikátor felett minden évben. Azonban ez az év más! Ebben az esztendõben\n",
	    "egy különös tárgyat dobott le, vagy ejtett le, ami nem más mint egy dísz. Ez a dísz nem egy váza, sem egy kép..\n",
	    "Ez egy karácsonyfa dísz! De hogy ez se legyen unalmas, ez egy különös karácsonyfa dísz, ugyanis csörög benne valami.\n",
	    "Eddig senki nem merte kinyitni, mert amint megcsörgette inkább szépen visszatette a helyére és elfutott.\n\n",
	    "Nos, ennek kell utánajárnod. Menj abba a sikátorba ahol ezek a dolgok történtek.\n\n",
	    "Jelenlegi szituáció:\n",
	    "Ideértél a sikátorba és megláttad azt a híres, különös de ijesztõ karácsonyfa díszt. Kicsit gondolkozol aztán felveszed.\n",
	    "Megcsörgeted a füled mellett, kicsit megijedsz, de nem futsz el mert érdekel a dolog. Megfogod a markodba, megpróbálod\n",
	    "összeroppantani, de gyenge fizikumod miatt inkább a földhöz vágod és széttörik. A díszben egy üzenetet találsz.\n",
	    "Az üzenetben ez áll: (Kattints a tovább gombra)");
	    ShowPlayerDialog(playerid, DIALOG_JATEK1, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Tovább", "Kilép");
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[1]))
	{
	    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s%s%s%s%s%s%s",
	    "Ideérsz a mólóhoz ahol a DM partyk szoktak menni. Elgondolkodsz és eszedbe jut:\n",
		"Sok töltény... A földön sok a töltény... Értem! Mivel itt szokott mindenki DM-elni ezért itt maradt a sok töltény a földön.\n",
		"Körbenézel és találsz egy másik díszt. Kicsit elszomorodsz hogy nem láthatod a mikulást.\n",
		"Már készülsz a földhöz vágni, de megpillantasz rajta egy cetlit amin ez áll: NE VÁGJ FÖLDHÖZ!! INKÁBB NYOMD MEG A GOMBOT!!\n",
		"Hümmögsz egyet, de elkezded rajta keresni a gombot.... Megtaláltad. Elõugrik benne egy kis képernyõ mint a sci-fi filmekben.\n",
		"Nagyot nézel. A kis csodakütyün egy videó elkezd lejátszódni. A képernyõjén egy M betû áll, és megint elszomorodsz\n",
		"hogy nem láthatod a mikulást. A videót lejátszod, a hang eltorzítottan megy.\n",
		"Üdv barátom. M vagyok, M mint... Oké, erre most nem érünk rá! Ott tartottam hogy elejtettem az ajándékaimat.\n",
		"Mikor a szán megrázkódott akkor úgy emlékszem egy farm felett mentem el... Igen! Egy farm! Majdnem leestem, ezalatt az\n",
		"egy másodperc alatt felmértem a terepet. 3 szántóföld volt. Az egyiken sorban álltak a szénagurigák.\n",
		"Ha a farm tulaja talált valamit akkor valószínüleg bevitte a pajtába. Menj oda és nézz körül.");
	    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[2]))
	{
	    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s%s",
	    "Szép csöndben bemész a pajtába, megpillantasz még egy díszt. Felveszed, jól megszorítod\n",
	    "de nem elég jól... Kicsúszott a kezedbõl és nem tört össze.. De megint felveszed, megszorítod és a földhöz vágod.\n",
	    "Hoppá! Nincs benne semmi. Na most mi lesz? Gondolod. De szerencsédre (vagy balszerencsédre) kijön a farm tulaja\n",
		"felháborodottan és elkezd üvöltözni veled. Te szépen lenyugtatod és elnézést kérsz, aztán megkérdezed mit tud errõl a díszrõl.\n",
		"Szerencsédre mindent látott. Látott elrepülni ingadozva egy szánt, amibõl kiesett egy dísz. Bevitte a pajtába majd ott hagyta.\n",
		"Mi másért vitte volna be mint hogy feltegye a fenyõfájára? De te szépen összetörted.. A lényeg, hogy látta elrepülni\n",
		"az útszéli pihenõ mellett és ott is leejtett valamit, meg látott valami homályt, de akkor merült le a telefonja, így a nagyítónak annyi volt.\n",
		"Menj az útszéli pihenõhöz és kérdezd meg ott mit láttak.");
		ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
		SetPVarInt(playerid, "pihenohozvissza", 0);
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[3]))
	{
	    if(GetPVarInt(playerid, "pihenohozvissza") == 0)
	    {
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
		    "Megérkeztél a pihenõhöz. Ránézel a kis házakra, szinte bemennél és lefeküdnél. De nem teszed.\n",
		    "Megfogod a díszt a kezedbe, elmész a pihenõ vezetõjéhez és kérdezgetsz róla.\n",
		    "A vezetõ nem tud megszólalni, annyira izgatott... De nagyon!! A kezedbe nyom egy kulcsot és elmutat az egyik irányba.\n",
		    "Na de egy baj van. Mindkét kezével mutatott. Tehát nem is az egyik, hanem két iránya mutat.\n",
		    "Közbe sikerül egy szót kinyögnie a száján: raktár..ház...\n",
		    "Te pislogtál közben és nem láttad jól hogy merre mutat, tehát gondolsz egyet és leütöd szegényt.\n",
		    "Még egyet gondolsz és elindulsz körbenézni a területen, hátha kell valahova ez a kulcs...");
			//"A kulcsot így használhatod: /xkulcs");
			ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
		}
		else if(GetPVarInt(playerid, "pihenohozvissza") == 1)
		{
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s",
		    "Ideértél, bekopogsz. Kiszédeleg a vezetõ, megköszöni hogy leütötted és elmutat egy irányba.\n",
		    "Vezetõ: Menj arra, találsz egy házat és nyisd ki azzal a kulcsal amit adtam. Szerintem azt keresed.\n",
		    "Keresed a kulcsot a zsebedben de nem találod... Keresed a gatyádban, belsõ seb, kabát zseb, mindenhol.\n",
		    "De nem találod. Talán benne felejtetted az egyik raktárház kulcslyukában.");
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
		    SetPVarInt(playerid, "raktarhazkulcs", 1);
		}
		else if(GetPVarInt(playerid, "pihenohozvissza") == 2)
		{
		    format(dialogstr, sizeof(dialogstr), "%s%s",
		    "Szét nézel, megpillantod a földön a ragasztót és felveszed. Összeragasztod a kulcsot\n",
		    "és szétnézel. Keress egy házat ami be van zárva, a /xkulcs parancsal használhatod a kulcsot.");
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
		}
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[4]))
	{
	    if(GetPVarInt(playerid, "raktarhazkulcs") == 0)
	    {
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
		    "Óvatosan felmászol a megpillantott dísz után a konténerekre, aztán felveszed.\n",
		    "A konténerhez hozzávágod, szét törik, de nincs benne semmi. Mégcsak segítség sincsen.\n",
		    "Nem tudod mit csinálj, de még mindig van egy kulcsod és nem tudod mire jó.\n",
		    "Lemész, megpróbálod valamelyik raktárt kinyitni vele, de nem nyílik egyik se.\n",
			"De eszedbe jut valami: Las Venturas-ban is van egy raktárház és ez az út pont oda vezet.\n",
			"Kicsit körbeírod magadban: Az autópálya megy el mellette... Egybõl miután betértem Las Venturas-ba... Meglesz.\n",
			"Tehát a következõ célod: Las Venturas raktárház.");
			ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
		}
		else if(GetPVarInt(playerid, "raktarhazkulcs") == 1)
		{
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s",
		    "Nézed sorban a raktárházak kulcslyukait, nem talá... De megtaláltad. Beletörve az egyikbe.\n",
		    "Biztos a nagy izgalom miatt történhetett. Na de most mi legyen? - Gondolod magadban.\n",
			"Jövõre kérsz a mikulástól egy új kulcsot és jövõ után pedig megkeresed az ajándékokat?\n",
			"Sok idõ. Hát elkezded kibogarászni a beletört felet a zárból.\n",
			"Egy csoda folytán kiesik belõle. A másik fele megvan, kiveszel a zsebedbõl egy kis raga...\n",
			"A ragasztó kiesett a pihenõnél miközben a kulcsot kerested...");
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
		    SetPVarInt(playerid, "pihenohozvissza", 2);
		}
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[5]))
	{
	    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
	    "Szép csöndben bemész a telekhelyre, meglátod a karácsonyfa díszt és megfogod.\n",
	    "Hm, ez különösen nehéz. - Gondolod.\n",
	    "A földhöz vágod, de nem törik szét. Megint megpróbálod, nem sikerült.. Sokadszorra sem.\n",
	    "Megnézed közelebbrõl a követ és észreveszed hogy bele van vésve egy felirat:\n",
		"Gyere vissza a pihenõhöz te kincskeresõ - Üdv: vezetõ\n",
		"Gondolkodsz... Aztán emlékszel... Leütötted.\n",
		"De sebaj, irány vissza!");
		ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Történés", dialogstr, "Oké", "");
		SetPVarInt(playerid, "pihenohozvissza", 1);
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[6]))
	{
	    if(GetPVarInt(playerid, "ajimegtalalva") == 0)
	    {
	        SetPVarInt(playerid, "ajimegtalalva", 1);
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s",
		    "Mikor megérkezel, nem hiszel a szemednek... Itt vannak az ajándékok. Felveszed a talált díszt\n",
		    "és megint egy kis gombot keresel rajta amit sikeresen meg is találtál. Bejön a képernyõ,\n",
		    "még mindig egy M betû van ott. Torzított hangon mondja: Te megtaláltad az ajándékaim!\n",
		    "Nagyon hálás vagyok neked! Jutalomból minden ami benne van a tiéd! De az jó kérdés hogyan kerültek be ide...\n",
		    "Nem érdekel! Köszönöm! Hála neked a karácsony folytatódhat. Egyébként a nevem M, mint... MEGLEPETÉS!\n",
		    "Kéred az ajándékokat vagy meghagyod másnak? Csak egyszer választhatsz!");
		    ShowPlayerDialog(playerid, DIALOG_JATEK2, DIALOG_STYLE_MSGBOX, "A választás", dialogstr, "Kérem", "Meghagyom");
		}
	}
	#endif
	return 1;
}

/*public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    for(new i; i < MAX_GIFTS; i++)
	{
		if(pickupid == gifts[i])
		{
		    if(IsPlayerInAnyVehicle(playerid)) return 1;
            SetPVarInt(playerid, "Gift", GetPVarInt(playerid, "Gift")+1);
			SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Találtál egy ajándékcsomagot! A /gift paranccsal adhatod oda valakinek, a /gifto paranccsal kinyithatod.");
			SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Megjegyzés: Az ajándékok miután kilépsz elvesznek!");
			DestroyGift(i);
		}
	}
	if(pickupid == disz[0]) GameTextForPlayer(playerid, "c", 2000, 4);
	if(pickupid == disz[1]) GameTextForPlayer(playerid, "s", 2000, 4);
	if(pickupid == disz[2]) GameTextForPlayer(playerid, "i", 2000, 4);
	if(pickupid == disz[3]) GameTextForPlayer(playerid, "l", 2000, 4);
	if(pickupid == disz[4]) GameTextForPlayer(playerid, "l", 2000, 4);
	if(pickupid == disz[5]) GameTextForPlayer(playerid, "a", 2000, 4);
	if(pickupid == disz[6]) GameTextForPlayer(playerid, "g", 2000, 4);
	if(pickupid == disz[7]) GameTextForPlayer(playerid, "s", 2000, 4);
	if(pickupid == disz[8]) GameTextForPlayer(playerid, "z", 2000, 4);
	if(pickupid == disz[9]) GameTextForPlayer(playerid, "ó", 2000, 4);
	if(pickupid == disz[10]) GameTextForPlayer(playerid, "r", 2000, 4);
	if(pickupid == disz[11]) GameTextForPlayer(playerid, "ó", 2000, 4);
	return 1;
}*/

stock CreateChristmasSomething(id, Float:x, Float:y, Float:z)
{
	switch(random(5))
	{
	    case 0: disz[id] = CreateDynamicObject(19059, x, y, z);
	    case 1: disz[id] = CreateDynamicObject(19060, x, y, z);
	    case 2: disz[id] = CreateDynamicObject(19061, x, y, z);
	    case 3: disz[id] = CreateDynamicObject(19062, x, y, z);
	    case 4: disz[id] = CreateDynamicObject(19063, x, y, z);
	}
	diszarea[id] = CreateDynamicSphere(x, y, z, 2, 0, 0, -1);
	unnep = true;
}

stock DeleteChristmasSomething()
{
	for(new i; i < MAX_DISZ; i++)
	{
		DestroyDynamicObject(disz[i]);
		DestroyDynamicArea(diszarea[i]);
	}
	unnep = false;
}

stock CreateChristmasGame(id, Float:x, Float:y, Float:z)
{
	jatekobjects[id] = CreateDynamicObject(19059, x, y, z, 0, 0, 0);
    jatekarea[id] = CreateDynamicSphere(x, y, z, 2, 0, 0, -1);
}

stock DeleteChristmasGames()
{
	for(new i; i < MAX_JATEKRESZ; i++)
	{
		DestroyDynamicObject(jatekobjects[i]);
		DestroyDynamicArea(jatekarea[i]);
	}
}
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

stock GetPlayerLookPos( playerid, &Float:X, &Float:Y, &Float:Z )
{
	new Float:fPX, Float:fPY, Float:fPZ,
	Float:fVX, Float:fVY, Float:fVZ;

	const Float:fScale = 5.0;

	GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
	GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);

	X = fPX + floatmul(fVX, fScale);
	Y = fPY + floatmul(fVY, fScale);
	Z = fPZ + floatmul(fVZ, fScale);
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Vehicle_ID = GetPlayerVehicleID(playerid),
	Float:a;
	if(Vehicle_ID)
	{
		GetVehiclePos(Vehicle_ID,x,y,a);
		GetVehicleZAngle(Vehicle_ID, a);
	}
	else
	{
		GetPlayerPos(playerid, x, y, a);
		GetPlayerFacingAngle(playerid, a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

stock GetPVarStringEx(playerid, pvar[])
{
	new pvar2[128];
	GetPVarString(playerid, pvar, pvar2, sizeof(pvar2));
	return pvar2;
}

stock GetGVarStringEx(pvar[])
{
	new pvar2[128];
	GetGVarString(pvar, pvar2, sizeof(pvar2));
	return pvar2;
}


forward clanbantimer();
public clanbantimer()
{
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPVarInt(i, "Logged") == 1)
	    {
	        if(strlen(GetPVarStringEx(i, "Clan")) <= 1)
	        {
	            SetPVarString(i, "Clan", "None");
	        }
	    }
	}
}

//------------------------------------------------------------------------------
forward lottozastimer();
public lottozastimer()
{
	new szam1 = 1+random(98), szam2 = 1+random(98), szam3 = 1+random(98), szam4 = 1+random(98), szam5 = 1+random(98);
	if(szam1 == szam2 || szam1 == szam3 || szam1 == szam4 || szam1 == szam5) szam1 = 1+random(98);
    if(szam2 == szam1 || szam2 == szam3 || szam2 == szam4 || szam2 == szam5) szam2 = 1+random(98);
    if(szam3 == szam1 || szam3 == szam2 || szam3 == szam4 || szam3 == szam5) szam3 = 1+random(98);
    if(szam4 == szam1 || szam4 == szam2 || szam4 == szam3 || szam4 == szam5) szam4 = 1+random(98);
    if(szam5 == szam1 || szam5 == szam2 || szam5 == szam3 || szam5 == szam4) szam5 = 1+random(98);
	SendFormatMessageToAll(COLOR_LIGHTGREEN, "Lottó nyerõszámok: %d, %d, %d, %d, %d", szam1, szam2, szam3, szam4, szam5);
	SendClientMessageToAll(COLOR_LIGHTGREEN, "Nyertesek: ");
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPVarInt(i, "lottozott") == 1)
	    {
	        for(new x; x < 5; x++)	if(szam1 == lszamok[x][i]) nyeremeny[i] += 200000;
	        for(new x; x < 5; x++)	if(szam2 == lszamok[x][i]) nyeremeny[i] += 200000;
	        for(new x; x < 5; x++)	if(szam3 == lszamok[x][i]) nyeremeny[i] += 200000;
	        for(new x; x < 5; x++)	if(szam4 == lszamok[x][i]) nyeremeny[i] += 200000;
	        for(new x; x < 5; x++)	if(szam5 == lszamok[x][i]) nyeremeny[i] += 200000;
			SendFormatMessage(i, COLOR_GREEN, "Te lottószámaid: %d, %d, %d, %d, %d", lszamok[0][i], lszamok[1][i], lszamok[2][i], lszamok[3][i], lszamok[4][i]);
			SendFormatMessage(i, COLOR_GREEN, "Nyereményed: %d$", nyeremeny[i]);
			GivePlayerMoneyEx(i, nyeremeny[i], "Lottón nyert");
        	if(nyeremeny[i] != 0) SendClientMessageToAll(COLOR_LIGHTGREEN, GetPlayerNameEx(i));
			nyeremeny[i] = 0;
			lszamok[0][i] = 0, lszamok[1][i] = 0, lszamok[2][i] = 0, lszamok[3][i] = 0, lszamok[4][i] = 0;
			SetPVarInt(i, "lottozott", 0);
		}
	}
}

stock PlaySound(playerid, soundid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
    PlayerPlaySound(playerid, soundid, x, y, z);
}

stock GetPlayerJob(playerid)
{
    //if(cGetPlayerTeam(playerid) == 3) return true;
	if(cGetPlayerTeam(playerid) == 0) return true;
	if(cGetPlayerTeam(playerid) == 1) return true;
	//if(cGetPlayerTeam(playerid) == 2) return true;
	if(cGetPlayerTeam(playerid) == 5) return true;
	if(cGetPlayerTeam(playerid) == 7) return true;
	if(cGetPlayerTeam(playerid) == 9) return true;
	if(cGetPlayerTeam(playerid) == 17) return true;
	//if(cGetPlayerTeam(playerid) == 19) return true;
	if(cGetPlayerTeam(playerid) == 29) return true;
	if(cGetPlayerTeam(playerid) == 30) return true;
	if(cGetPlayerTeam(playerid) == 31) return true;
	if(cGetPlayerTeam(playerid) == 32) return true;
	else return false;
}

forward reakcioteszt();
public reakcioteszt()
{
    new abc[][] =
	{
		"A", "a", "B", "b",
		"C", "c", "D", "d",
		"E", "e", "F", "f",
		"G", "g", "H", "h",
		"I", "i", "J", "j",
		"K", "k", "L", "l",
		"M", "m", "N", "n",
		"O", "o", "P", "p",
		"Q", "q", "R", "r",
		"S", "s", "T", "t",
		"V", "v", "Z", "z",
		"X", "x", "Y", "y",
		"W", "w", "U", "u",
		"1", "2", "3", "4",
		"5", "6", "7", "8",
		"9"
	};
	format(reakciosz, sizeof(reakciosz), "%s%s%s%s%s%s%s%s%s%s", abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0], abc[random(sizeof(abc))][0]);
	SendFormatMessageToAll(COLOR_GREEN, #HLIME#"Aki legelõször beírja ezt: "#HYELLOW#"%s"#HLIME#", kap 10.000$-t és 3 EXP-et!", reakciosz);
	rteszt = true;
	megoldasszamlalo = 0;
	megoldastimer = SetTimer("megoldas", 1000, true);
	KillTimer(reakciotimer);
}

forward megoldas();
public megoldas()
{
	if(megoldasszamlalo == 120)
	{
		SendClientMessageToAll(COLOR_GREEN, #HLIME#"Mivel senki nem teljesítette a reakciótesztet törölve lett. 2 perc múlva új indul.");
		rteszt = false;
		reakciotimer = SetTimer("reakcioteszt", 2*60000, true);
		KillTimer(megoldastimer);
	}
	else megoldasszamlalo++;
}

//------------------------------------------------------------------------------
stock IsPlayerInWater(playerid)
{
    new anim = GetPlayerAnimationIndex(playerid);
    if (((anim >=  1538) && (anim <= 1542)) || (anim == 1544) || (anim == 1250) || (anim == 1062)) return 1;
    return 0;
}

stock IsPlayerAiming(playerid)
{
	new anim = GetPlayerAnimationIndex(playerid);
	if (((anim >= 1160) && (anim <= 1163)) || (anim == 1167) || (anim == 1365) ||
	(anim == 1643) || (anim == 1453) || (anim == 220)) return 1;
    return 0;
}

stock IsStringInSpecials(string[])
{
	for(new i; i < strlen(string); i++)
	{
	    if(string[i] == '{' || string[i] == '}' || string[i] == '|' || string[i] == '"' || string[i] == ' ' || string[i] == '+' || string[i] == '!' || string[i] == '/' || string[i] == '=' || string[i] == '@' || string[i] == '#' || string[i] == '<' || string[i] == '>' || string[i] == '¤' || string[i] == 'ß' || string[i] == '÷' || string[i] == '×' || string[i] == '?')
	    {
	        return true;
	    }
	    else return false;
	}
	return false;
}

stock IsStringInvalidBletters(string[])
{
	new abc[16][] =
	{
		"á", "Á",
		"é", "É",
		"í", "Í",
		"ó", "Ó",
		"ö", "Ö",
		"õ", "Õ",
		"ü", "Ü",
		"û", "Û"
	};
	for(new i; i < sizeof(abc); i++)
    if(strfind(string, abc[i][0], true) != -1)
    {
        return true;
    }
    return false;
}

//By Epsilon
stock replacestring(str[], const find[],const finish[])
{
	#define MAXLEN 128
	new start = strfind(str,find);
	do
	{
		new end = start+strlen(find);
		strdel(str,start,end);
		strins(str,finish,start,MAXLEN);
		start = strfind(str,find);
	}
	while(start != -1);
	return str;
}

//By GameStar
stock FloatToInt(Float: numb)
{
	return floatround(Float:numb, floatround_round);
}

stock Float:PointAngle(playerid, Float:xa, Float:ya, Float:xb, Float:yb)
{
    new Float:carangle;
    new Float:xc, Float:yc;
    new Float:angle;
    xc = floatabs(floatsub(xa,xb));
    yc = floatabs(floatsub(ya,yb));
    if (yc == 0.0 || xc == 0.0)
    {
        if(yc == 0 && xc > 0) angle = 0.0;
        else if(yc == 0 && xc < 0) angle = 180.0;
        else if(yc > 0 && xc == 0) angle = 90.0;
        else if(yc < 0 && xc == 0) angle = 270.0;
        else if(yc == 0 && xc == 0) angle = 0.0;
    }
    else
    {
        angle = atan(xc/yc);
        if(xb > xa && yb <= ya) angle += 90.0;
        else if(xb <= xa && yb < ya) angle = floatsub(90.0, angle);
        else if(xb < xa && yb >= ya) angle -= 90.0;
        else if(xb >= xa && yb > ya) angle = floatsub(270.0, angle);
    }
    GetVehicleZAngle(GetPlayerVehicleID(playerid), carangle);
    return floatadd(angle, -carangle);
}

//by Double-O-Seven
stock GetWeaponModel(weaponid)
{
        switch(weaponid)
        {
            case 1:
               return 331;
                case 2..8:
                   return weaponid+331;
        case 9:
                    return 341;

                case 10..15:
                        return weaponid+311;

                case 16..18:
                    return weaponid+326;

                case 22..29:
                    return weaponid+324;

                case 30,31:
					return weaponid+325;
                case 32:
                    return 372;

                case 33..45:
                    return weaponid+324;

                case 46:
                    return 371;
        }
        return 0;
}

stock GetVehicleSpeed(vehicleid)
{
	new Float:vSpeed[3];
	GetVehicleVelocity( vehicleid, vSpeed[0], vSpeed[1], vSpeed[2] );

	new Float:vSpeed_Float;
	vSpeed_Float = floatsqroot( ((vSpeed[0] * vSpeed[0]) + (vSpeed[1] * vSpeed[1])) + (vSpeed[2] * vSpeed[2])) * 161.0;

	new vSpeed_Int;
	vSpeed_Int = floatround( vSpeed_Float, floatround_round );

	return vSpeed_Int;
}

stock GetPlayerSpeed(playerid)
{
	new Float:vSpeed[3];
	GetPlayerVelocity( playerid, vSpeed[0], vSpeed[1], vSpeed[2] );

	new Float:vSpeed_Float;
	vSpeed_Float = floatsqroot( ((vSpeed[0] * vSpeed[0]) + (vSpeed[1] * vSpeed[1])) + (vSpeed[2] * vSpeed[2])) * 100.0;

	new vSpeed_Int;
	vSpeed_Int = floatround( vSpeed_Float, floatround_round );

	return vSpeed_Int;
}

convertFormattedNumber(n, slt[])
{
    new str[64], i = 0;                         //  Deklarálás
    format(str, 64, "%d", n);                   //  Átalakítjuk sztringgé a számot
    while (i < strlen(str)) {                   //  Egy ciklust futtatunk addig, míg el nem éri az i a megfelelõ értéket
        strins(str, slt[0], strlen(str) - i);      //  Hátulról hozzáadunk mindig egy pontot
       	i = i+4;                               //  Növeljük az i-t néggyel
    }
    strdel(str, strlen(str) - 1, strlen(str));  //  Kitöröljük az utolsó karaktert
    return str;                                 //  Visszatérünk az str nevû sztringünkkel
}

stock GetTableLines(table[])
{
	new sorok;
	format(query, sizeof(query), "SELECT * FROM %s", table);
	mysql_query(query);
	mysql_store_result();
	sorok = mysql_num_rows();
	mysql_free_result();
	return sorok;
}

stock getpercent2(Float:val1, Float:val2)
{
	new Float:percent = floatdiv(val1,floatdiv(val2,100));
    return _:percent;
}

stock GetAchievement(playerid, achievement[])
{
	return GetPVarInt(playerid, achievement);
}

stock IsPlayerUnallowedZone(playerid)
{
    if(GetPVarInt(playerid, "hazban") != 0) return true;
    else if(GetPVarInt(playerid, "garazsban") != 0) return true;
    else if(GetPVarInt(playerid, "fagyasztva") == 1) return true;
    else if(GetPVarInt(playerid, "haboruban") == 1) return true;
    else if(GetPVarInt(playerid, "lakocsi") != 0) return true;
    else if(GetPVarInt(playerid, "Cuffed") == 1) return true;
    else if(GetPVarInt(playerid, "1v1dmben") == 1) return true;
    else if(GetPVarInt(playerid, "paintball") == 1) return true;
	else return false;
}

stock SetPlayerPosEx(playerid, Float:X, Float:Y, Float:Z)
{
	SetPVarFloat(playerid, "acoX", X);
	SetPVarFloat(playerid, "acoY", Y);
	SetPVarFloat(playerid, "acoZ", Z);
	SetPlayerPos(playerid, X, Y, Z);
}
