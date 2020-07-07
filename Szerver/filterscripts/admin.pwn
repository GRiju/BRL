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
//#define MSN_DIALOG 1023 //ezt ne �rjam sehova
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

//----------------------Havaz�s by Kwadre(?)-------------------------
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
//--------------------------Lott� rendszer-----------------------------
new lszamok[5][MAX_PLAYERS];
//new talalt[5][MAX_PLAYERS];
new nyeremeny[MAX_PLAYERS];
//---------------------------------------------------------------------
//--------------------------Reakci�teszt-------------------------------
new reakciotimer;
new megoldastimer;
new bool:rteszt;
new megoldasszamlalo;
new reakciosz[50];

#define REAKCIO_EXP 3
//---------------------------------------------------------------------
//--------------------------kar�csonyi dolgok--------------------------
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
#define PING_KICK //Aktiv�lja a magas ping kickel�st
#define MAXPING 500 //Max ping
#define ANTIFLOOD //antiflood aktiv�l�sa
#define MAX_FLOOD 5 //mennyit k�ldhet el max MAX_FLOODT m�sodpercenk�nt
#define MAX_FLOODT 3 //h�ny m�sodpercenk�nt k�ldhet el MAX_FLOOD �zenetet

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
	{"any�d"},
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
	{"M�V"},
	{"TAXI"},
	{"MENT�S"},
	{"BANKOS"},
	{"BANKRABL�"},
	{"KAMIONOS"},
	{"ZSARU"},
	{"POLITIKUS"},
	{"KATONA"},
	{"RIFA"},
	{"TRI�D"},
	{"MAFFIA"},
	{"VIETNAM"},
	{"GROVE"},
	{"PAP"},
	{"RIPORT"},
	{"T�ZOLT�"},
	{"RODNEYTEAM"},
	{"TRI�D"},
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
	{"�TTISZT�T�"},
	{"FARMER"},
	{"Kl�n1"},
	{"Kl�n2"},
	{"TDM1"},
	{"TDM2"}
};

new Errors[][]= {
{"[ HIBA ]: �rv�nytelen J�t�kosID!"},
{"[ HIBA ]: Ezt a parancsot nem haszn�lhatod magadon!"},
{"[ HIBA ]: Ezt a parancsot nem haszn�lhatod n�lad magasabb szint� adminon!"}
};

new LevelErrors[][]= {
{"[ HIBA ]: Ehez a parancshoz RCON adminisztr�tornak k�ne lenned!"},
{"[ HIBA ]: Ehez a parancshoz legal�bb moder�tornak kell lenned!"},
{"[ HIBA ]: Ehez a parancshoz legal�bb Kezd� Adminisztr�tornak kell lenned!"},
{"[ HIBA ]: Ehez a parancshoz legal�bb Adminisztr�tornak kell lenned!"},
{"[ HIBA ]: Ehez a parancshoz legal�bb F� Adminisztr�tornak kell lenned!"},
{"[ HIBA ]: Ezt a parancsot nem haszn�lhatod, mert az id� automata!"},
{"[ HIBA ]: Ehez a parancshoz VIP tagnak kell lenned!"}
};

//Rekl�mok
new Reklamok[][] =
{
    //"[ Rekl�m ]: Olcs� szerver kell? www.fps-system.eu",
    "[ Rekl�m ]: Regisztr�lj a szerver f�rumj�ra: www.brl.ucoz.net",
    "[ Rekl�m ]: Ha tetszik a szerver tedd a kedvencek k�z� ;)   -   [ IP: s2.fps-system.eu:8321 ]",
    "[ Tipp ]: Tartsd be a szab�lyokat �s tiszteld a j�t�kost�rsaid valamint az adminisztr�torokat!",
    "[ Tipp ]: Szab�lys�rt�t l�tsz? Jelentsd a /report paranccsal!",
    "[ Tipp ]: Ha ki akarsz rabolni egy �zletet, el�g bemenni �s be�rni az adott helyen a /rabol parancsot.",
    "[ Tipp ]: A ruha�zletekben (A t�rk�pen ruha ikonnal vannak jel�lve) vehetsz �j ruh�kat.",
    "[ Tipp ]: Akarsz besz�lni valakivel, de nem akarod hogy m�sok megtudj�k? Haszn�ld: /pm /w /cw parancsokat!",
    "[ Tudtad? ]: A szerveren alap�thatsz kl�nt is! /claninfo",
	"[ Tipp ]: Nincs p�nzed? Vagy el�g szerencs�s? Lott�zz: /lottoinfo",
	"[ Tipp ]: Ha k�r�znek, tal�lj egy K�r�z�si csillagot �s cs�kkentsd a k�r�z�sed.",
    "[ Tipp ]: A szerveren el vannak rejtve csomagok, ha megtal�lod �ket, jutalmat kapsz.",
    //"[ Rekl�m ]: FPS-SYSTEM.eu | SA-MP szerverek m�r 15ft/slot �rt�l! zsobo@fps-system.eu vagy info@fps-system.eu",
    "[ Rekl�m ]: www.sampforum.hu , egy j� k�z�ss�g!",
//    "[ Tipp ]: AdminTeam�nk megn�z�s��rt, haszn�ld  az /adminok parancsot",
    //"[ Tipp ]: Az Okoska BKV Zrt. jegy�rai�rt /jegyarak ; a b�rlettel utaz�k�rt a /berletesek parancsot haszn�ld",
	//"[ Figyelem! ]: 2012. Janu�r 22.-�t�l v�ltoztak az Okoska BKV Zrt Jegy- �s B�rlet�rai!",
	"[ Figyelem ]: Rend�rnek �s Katon�nak kiz�r�lag f�rumon lehet jelentkezni!",
    "[ Tipp ]: Ha hib�t vagy hi�nyoss�got l�tsz a szerveren haszn�ld a /bugreport parancsot!",
    "[ Rekl�m ]: A szerver UCP-je: brl.fps-system.eu",
    "[ Rekl�m ]: L�pj be a szerver facebook csoportj�ba: Budapest Real Life"
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
	    print(!"MySQL: Kapcsol�d�s sikertelen!");
		return 1;
 	}
 	print("MySQL: Kapcsol�d�s sikeres!");
 	print("Havaz�s by Kwadre");
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
    SetGVarInt("MaxPing", MAXPING); //Meghat�rozza a maxim�lis ping �rt�ket
    SetGVarInt("nmshow", 0);
    cube = CreateDynamicCube(-2618.9102,189.4115,0.1078, -2634.0920,200.4794,2.5075);
	new p = GetMaxPlayers();
    for (new i = 0; i < p; i++)
	{
            SetPVarInt(i, "laser", 0);
    }
    print("A l�zerszkriptet Skiaffo k�sz�tette.");
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
    //havaz�s
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
		format(join, sizeof(join), "[ CSATLAKOZ�S ]: "#HBLUE"%s"#HLIME#" csatlakozott a szerverhez!", GetPlayerNameEx(playerid));
		SendClientMessageToAll(COLOR_CONNECT, join);

		new kickform[128];
		format(kickform, sizeof(kickform), "Banolt j�t�kos (Indok: %s)", reason);
		KickReason(playerid, kickform, "SYSTEM");
		SendClientMessage(playerid, COLOR_RED, "HIBA: Te banolva vagy. Unbant k�rhetsz a weblapon: www.brl.ucoz.net");
		SendFormatMessage(playerid, COLOR_RED, "Ban indok [Bant ad� admin]: %s", reason);
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
        if(mysql_num_rows() != 0) //Ha az IP ugyanaz mint ami az adatb�zisban van
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
			switch(GetPVarInt(playerid, "Level"))//az adminszintekhez tartoz� megnevez�s v�ltoz�ba �r�sa
			{
			    case 1: SetPVarString(playerid, "AdminRang", "Moder�tor");
				case 2: SetPVarString(playerid, "AdminRang", "Kezd� Adminisztr�tor");
				case 3: SetPVarString(playerid, "AdminRang", "Halad� Adminisztr�tor");
				case 4: SetPVarString(playerid, "AdminRang", "F� Adminisztr�tor");
				case 5: SetPVarString(playerid, "AdminRang", "Any�d");
			}
			SetPVarInt(playerid, "Logged", 1);
			elteltt[playerid] = SetTimerEx("elteltido", 60000, 1, "i", playerid);
			GetPVarString(playerid, "AdminRang", adminpvar, sizeof(adminpvar));
            mysql_free_result();
            if(GetPVarInt(playerid, "Level") == 0) SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZN�L� ]: Sikeresen bejelentkezt�l!");
			if(GetPVarInt(playerid, "Level") != 0) SendFormatMessage(playerid, COLOR_REGLOG, "[ FELHASZN�L� ]: Sikeresen bejelentkezt�l! [ Rang: %s ]", adminpvar);

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
            ShowPlayerDialog(playerid, LOGIN_DIALOG, DIALOG_STYLE_PASSWORD , "Bejelentkez�s", "Ez a n�v regisztr�lva van!\nK�rlek jelentkezz be!\nWeboldalunk: www.brl.ucoz.net", "Bejelentkez�s", "Kil�p�s");
            //SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZN�L� ]: Ez a n�v regisztr�lva van! K�rlek jelentkezz be! [ /login jelsz� ]");
        }
    }
    else
    {
        ShowPlayerDialog(playerid, REGISTER_DIALOG, DIALOG_STYLE_INPUT , "Regisztr�ci�", "Ez a n�v m�g nincs regisztr�lva!\nK�rlek �rj be egy jelsz�t a regisztr�ci�hoz!\n ", "Regisztr�ci�", "Kil�p�s");
        //SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZN�L� ]: Ez a n�v m�g nincs regisztr�lva! K�rlek regisztr�lj a szerverre! [ /register jelsz� ]");
    }
    mysql_free_result();
	#if defined ENABLE_SPECTATE
    Spec[playerid][SpectateUpdate] = 255;
    #endif
	#if defined PING_KICK
	SetTimerEx("PingCheck1", 1*60*1000, false, "i", playerid);
	#endif
	if(GetPVarInt(playerid, "VIP") != 1) format(join, sizeof(join), "[ CSATLAKOZ�S ]: "#HBLUE"%s"#HLIME#" csatlakozott a szerverhez!", GetPlayerNameEx(playerid));
	else if(GetPVarInt(playerid, "VIP") == 1) format(join, sizeof(join), "[ CSATLAKOZ�S ]: "#HBLUE"%s "#HYELLOW#"VIP"#HLIME#" csatlakozott a szerverhez!", GetPlayerNameEx(playerid));
	SendClientMessageToAll(COLOR_CONNECT, join);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPVarInt(i, "ipshow") == 1)
	    {
	        new ips[16];
	        GetPlayerIp(playerid, ips, sizeof(ips));
	        SendFormatMessage(i, COLOR_CONNECT, "A j�t�kos IP-je: %s", ips);
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
		case 1:	disconnectreason = "Kil�pett";
		case 2:	disconnectreason = "Kick vagy Ban";
	}
	if(GetPVarInt(playerid, "VIP") != 1) format(leave, sizeof(leave), "[ CSATLAKOZ�S ]: "#HBLUE#"%s"#HLIME" elhagyta a szervert! "#HRED#"[%s]", GetPlayerNameEx(playerid), disconnectreason);
	else if(GetPVarInt(playerid, "VIP") == 1) format(leave, sizeof(leave), "[ CSATLAKOZ�S ]: "#HBLUE#"%s "#HYELLOW#"VIP"#HLIME#" elhagyta a szervert! "#HRED#"[%s]", GetPlayerNameEx(playerid), disconnectreason);
    format(leave, sizeof(leave), "[ CSATLAKOZ�S ]: "#HBLUE#"%s"#HLIME" elhagyta a szervert! "#HRED#"[%s]", GetPlayerNameEx(playerid), disconnectreason);
	SendClientMessageToAll(COLOR_CONNECT, leave);
	for(new i; i < MAX_PLAYERS; i++)
	{
	    if(GetPVarInt(i, "ipshow") == 1)
	    {
	        new ips[16];
	        GetPlayerIp(playerid, ips, sizeof(ips));
	        SendFormatMessage(i, COLOR_CONNECT, "A j�t�kos IP-je: %s", ips);
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
		    format(ajstring, sizeof(ajstring), "%s (AJ-b�l kil�p�s)", ajreason);
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
		CallRemoteFunction("UnlockAchievementpublic", "isss", killerid, "particle:bloodpool_64", "50 j�t�kos meg�l�se", "Sorozatgyilkos");
		CallRemoteFunction("GiveEXPpublic", "ii", killerid, 100);
	}
	if(GetPVarInt(killerid, "Kills") == 100)
	{
		CallRemoteFunction("UnlockAchievementpublic", "isss", killerid, "particle:bloodpool_64", "100 j�t�kos meg�l�se", "Orvgyilkos");
		CallRemoteFunction("GiveEXPpublic", "ii", killerid, 300);
	}
	if(GetPVarInt(killerid, "Kills") == 300)
	{
		CallRemoteFunction("UnlockAchievementpublic", "isss", killerid, "particle:bloodpool_64", "300 j�t�kos meg�l�se", "Pszichopata");
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
		GameTextForPlayer(killerid, FixGameString("~r~�n sz�ltam..."), 3000, 4);
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
 		GameTextForPlayer(killerid, FixGameString("~r~�n sz�ltam..."), 3000, 4);
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
	    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Interior DM", "Interiorban ne verekedj! Figyelmeztetve.", "Ok�", "");
	    WarnReason(playerid, "Interior DM", "SYSTEM");
		return 1;
	}
	if(IsPlayerInDynamicArea(playerid, cube))
	{
	    if(IsPlayerInDynamicArea(damagedid, cube))
	    {
		    ClearAnimations(playerid);
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Interior DM", "Interiorban ne verekedj! Figyelmeztetve.", "Ok�", "");
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
		    "Alap t�rt�net (Ezt m�r elmondta a j�t�kszervez�):\n",
		    "K�l�n�s dolgokat l�ttak ma egy sik�tor felett... Egy sik�tor felett, ahol t�len mindig k�l�n�s dolgok t�rt�nnek.\n",
		    "Ezt a k�l�n�s dolgot egy Burger Shoot-ban dolgoz� munk�s vette �szre. Arr�l sz�molt be hogy minden �vben kar�csonykor l�tta.\n",
		    "L�tott elrep�lni egy k�l�n�s dolgot a sik�tor felett minden �vben. Azonban ez az �v m�s! Ebben az esztend�ben\n",
		    "egy k�l�n�s t�rgyat dobott le, vagy ejtett le, ami nem m�s mint egy d�sz. Ez a d�sz nem egy v�za, sem egy k�p..\n",
		    "Ez egy kar�csonyfa d�sz! De hogy ez se legyen unalmas, ez egy k�l�n�s kar�csonyfa d�sz, ugyanis cs�r�g benne valami.\n",
		    "Eddig senki nem merte kinyitni, mert amint megcs�rgette ink�bb sz�pen visszatette a hely�re �s elfutott.\n\n",
		    "Nos, ennek kell ut�naj�rnod. Menj abba a sik�torba ahol ezek a dolgok t�rt�ntek.");
		    ShowPlayerDialog(i, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
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
	SendClientMessage(playerid, COLOR_RED, "id� felgyors�tva");
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
	SendClientMessage(playerid, COLOR_RED, "id� felgyors�tva");
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
	if(GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID) SendClientMessage(playerid, COLOR_GREEN, "Nincs aut�n.");
	else SendClientMessage(playerid, COLOR_GREEN, "Aut�n van.");
	SendFormatMessage(playerid, COLOR_GREEN, "Player sebess�g: %0.2f", GetPlayerSpeed(playerid));
	SendFormatMessage(playerid, COLOR_GREEN, "Player sebess�g: %d", GetPlayerSpeed(playerid));
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
    SendFormatMessage(playerid, COLOR_GREEN, "Player sebess�g: %0.2f", GetPlayerSpeed(playerid));
	SendFormatMessage(playerid, COLOR_GREEN, "Player sebess�g: %d", GetPlayerSpeed(playerid));
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
	SendClientMessage(playerid, COLOR_GREY, "k�sz...");
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
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem �rhatsz a chatbe ha levagy n�m�tva!");
	    WarnReason(playerid, "Besz�d n�m�t�s alatt", "SYSTEM");
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
				KickReason(playerid, "Hirdet�s", "SYSTEM");
				return 0;
			}
		}
	}
	if(rteszt == true)
	{
	    if(strlen(text) == 0) return 1;
	    if(!strcmp(reakciosz, text))
	    {
     		SendFormatMessageToAll(COLOR_GREEN, #HLIME#"%s megoldotta a reakci�tesztet "#HRED#"%d"#HLIME#" mp alatt. 2 perc m�lva �j indul.", GetPlayerNameEx(playerid), megoldasszamlalo);
        	reakciotimer = SetTimer("reakcioteszt", 2*60000, true);
        	KillTimer(megoldastimer);
        	rteszt = false;
        	GivePlayerMoneyEx(playerid, 10000);
        	CallRemoteFunction("GiveEXPpublic", "ii", playerid, REAKCIO_EXP);
        	SetPVarInt(playerid, "reakcio", GetPVarInt(playerid, "reakcio")+1);
        	if(GetPVarInt(playerid, "reakcio") == 50)
		    {
				CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "fonts:font1", "50 reakci�teszt megold�sa", "A gyorskez�");
    			SetPVarInt(playerid, "reakcio", GetPVarInt(playerid, "reakcio")+1);
				CallRemoteFunction("GiveEXPpublic", "ii", playerid, 50);
		    }
		    else if(GetPVarInt(playerid, "reakcio") == 100)
		    {
				CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "fonts:font2", "100 reakci�teszt megold�sa", "Ujjbajnok");
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
	if(GetGVarInt("count") == 1) return SendClientMessage(playerid, COLOR_GREY, "HIBA: 30mp-nek el kell telnie a sz�ml�l�sok k�zt!");
	counttimer = SetTimer("counttim", 1000, 1);
	countt = 6;
	SetGVarInt("count", 1);
	SendFormatMessageToAll(COLOR_GREY, "%s elind�tott egy visszasz�ml�l�st!", GetPlayerNameEx(playerid));
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
	SendClientMessage(playerid, COLOR_GREEN, "Funkci�v�lt�s: K�z�ps� eg�rgomb vagy NUM1");
	SetPVarInt(playerid, "aws", 1);
	return 1;
}

CMD:setarmor(playerid, params[])
{
	new oid, expv;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "ii", oid, expv)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /setarmor [ID] [armor mennyis�g]");
	if(!IsPlayerConnected(oid)) return SendClientMessage(playerid, COLOR_RED, "A  j�t�kos nem el�rhet�.");
	SetPlayerArmour(oid, expv);
    SendAdminCMDMessage(playerid, "SETARMOR", GetPlayerNameEx(oid));
	return 1;
}

CMD:givesp(playerid, params[])
{
	new oid, expv;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "ii", oid, expv)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /giveexp [ID] [Skillpoint mennyis�g]");
	if(!IsPlayerConnected(oid)) return SendClientMessage(playerid, COLOR_RED, "A  j�t�kos nem el�rhet�.");
	SetPVarInt(oid, "skillpoints", expv);
    SendFormatMessage(oid, COLOR_ADMINMSG, "[ ADMIN ]: %s adott %d K�pess�gpontot.", GetPlayerNameEx(playerid), expv);
    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Adt�l %s-nek %d K�pess�gpontot.", GetPlayerNameEx(oid), expv);
	return 1;
}

CMD:giveexp(playerid, params[])
{
	new oid, expv;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "ii", oid, expv)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /giveexp [ID] [EXP mennyis�g]");
	if(!IsPlayerConnected(oid)) return SendClientMessage(playerid, COLOR_RED, "A  j�t�kos nem el�rhet�.");
    CallRemoteFunction("GiveEXPpublic", "ii", oid, expv);
    SendFormatMessage(oid, COLOR_ADMINMSG, "[ ADMIN ]: %s adott %d EXP-et.", GetPlayerNameEx(playerid), expv);
    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Adt�l %s-nek %d EXP-et.", GetPlayerNameEx(oid), expv);
	return 1;
}

CMD:reakciot(playerid, params[])
{
	new betu[10][5];
	if(!IsPlayerAdminEx(playerid)) return 0;
	if(sscanf(params, "s[5]s[5]s[5]s[5]s[5]s[5]s[5]s[5]s[5]s[5]", betu[0], betu[1], betu[2], betu[3], betu[4], betu[5], betu[6], betu[7], betu[8], betu[9])) return SendClientMessage(playerid, COLOR_GREY, "Haszn�lat: /reakciot [10db karakter]");
    format(reakciosz, sizeof(reakciosz), "%s%s%s%s%s%s%s%s%s%s", betu[0], betu[1], betu[2], betu[3], betu[4], betu[5], betu[6], betu[7], betu[8], betu[9]);
	SendFormatMessageToAll(COLOR_GREEN, #HLIME#"Aki legel�sz�r be�rja ezt: "#HYELLOW#"%s"#HLIME#", kap 10.000$-t �s 3 EXP-et!", reakciosz);
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
	if(sscanf(params,"iis[100]",id, perc, ok)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "Haszn�lat: /ajail [id] [perc] [ok]");
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
    format(str, sizeof(str), "%s b�rt�nbe tette %s-t %d percre. Indok: %s", adminname, GetPlayerNameEx(playerid), time, reason);
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

//----------------------Kar�csonyi dolgok-----------------------------
#if defined AJANDEKOK
CMD:gift(playerid, params[])
{
	new id;
	if(GetPVarInt(playerid, "Gift") == 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Neked nincsen aj�nd�kcsomagod!");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /gift [ID/n�vr�szlet]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A j�t�kos nem el�rhet�.");
	if(id == playerid) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Magadnak mi�rt akarsz aj�nd�kot adni?");
	SendFormatMessage(playerid, COLOR_GREEN, #HLIME#"Aj�nd�kot adt�l"#HYELLOW#"%s"#HLIME#"-nek.", GetPlayerNameEx(id));
	SendFormatMessage(id, COLOR_GREEN, #HLIME#"Aj�nd�kot kapt�l "#HYELLOW#"%s"#HLIME#"-t�l. Kinyitni a "#HYELLOW#"/gifto"#HLIME#" paranccsal tudod.", GetPlayerNameEx(playerid));
	SetPVarInt(playerid, "Gift", GetPVarInt(playerid, "Gift")-1);
	SetPVarInt(id, "Gift", GetPVarInt(id, "Gift")+1);
	return 1;
}

CMD:gifto(playerid)
{
	if(GetPVarInt(playerid, "Gift") == 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Neked nincsen aj�nd�kcsomagod!");
	switch(random(8))
	{
	    case 0:
	    {
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az aj�nd�kcsomagot �s tal�lt�l benne"#HYELLOW#"50.000$"#HLIME#"-t!");
			GivePlayerMoneyEx(playerid, 50000);
		}
		case 1:
		{
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az aj�nd�kcsomagot �s tal�lt�l benne"#HYELLOW#"l�zert az M4-re �s 9mm-re!");
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kapt�l mell� egy M4-et 100 t�lt�nnyel �s egy 9mm-est 50 t�lt�nnyel!");
			GivePlayerMoneyEx(playerid, 50000);
			SetPVarInt(playerid, "laser", 1);
			GivePlayerWeapon(playerid, 31, 100);
			GivePlayerWeapon(playerid, 23, 50);
		}
		case 2:
		{
		    SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az aj�nd�kcsomagot �s tal�lt�l benne"#HYELLOW#"egy mikul�s sapk�t!");
		    if(GetPlayerSkin(playerid) == 30) SetPlayerAttachedObject( playerid, 5, 19066, 2, 0.135741, -0.00, 0.0, 194.897018, 97.656661, 266.509033, 1.000000, 1.000000, 1.000000 ); // SantaHat3 - sapka
			else SetPlayerAttachedObject( playerid, 5, 19066, 2, 0.128741, 0.014756, 0.008071, 194.897018, 97.656661, 266.509033, 1.000000, 1.000000, 1.000000 );
			playersapka[playerid] = true;
		}
		case 3:
	    {
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az aj�nd�kcsomagot �s tal�lt�l benne"#HYELLOW#"500.000$"#HLIME#"-t!");
			GivePlayerMoneyEx(playerid, 500000);
		}
		case 4:
	    {
	        SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az aj�nd�kcsomagot �s tal�lt�l benne"#HYELLOW#"100.000$"#HLIME#"-t!");
			GivePlayerMoneyEx(playerid, 100000);
		}
		case 5:
		{
		    CallRemoteFunction("GiveEXPpublic", "ii", playerid, 20);
		    SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az aj�nd�kcsomagot �s tal�lt�l benne"#HYELLOW#"20EXP"#HLIME#"-et!");
		}
		case 6:
		{
		    CallRemoteFunction("GiveEXPpublic", "ii", playerid, 50);
		    SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az aj�nd�kcsomagot �s tal�lt�l benne"#HYELLOW#"50EXP"#HLIME#"-et!");
		}
		case 7:
		{
		    CallRemoteFunction("GiveEXPpublic", "ii", playerid, 100);
		    SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Kinyitottad az aj�nd�kcsomagot �s tal�lt�l benne"#HYELLOW#"100EXP"#HLIME#"-et!");
		}
	}
	SetPVarInt(playerid, "Gift", GetPVarInt(playerid, "Gift")-1);
	return 1;
}
#endif
//---------------------------------------Inform�ci�k-----------------------------------------------
CMD:ivagyokl(playerid, params[])
{
	new id;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "i", id)) return SendClientMessage(playerid, COLOR_GREY, "Haszn�lat: /ivagyokl [playerid]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "HIBA: A j�t�kos nem online!");
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
	SendClientMessage(playerid, COLOR_GREEN, "Kl�n ID null�zva.");
	mysql_query("ALTER TABLE `houseobjects` DROP `ID`");
	mysql_query("ALTER TABLE  `houseobjects` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "h�zt�rgyak ID null�zva.");
	mysql_query("ALTER TABLE `zene` DROP `ID`");
	mysql_query("ALTER TABLE  `zene` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "zene ID null�zva.");
 	mysql_query("ALTER TABLE `zenelistav` DROP `ID`");
	mysql_query("ALTER TABLE  `zenelistav` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "zene v�r�lista ID null�zva.");
	mysql_query("ALTER TABLE `garages` DROP `ID`");
	mysql_query("ALTER TABLE  `garages` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "gar�zs ID null�zva.");
	mysql_query("ALTER TABLE `targyadatok` DROP `ID`");
	mysql_query("ALTER TABLE  `targyadatok` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	SendClientMessage(playerid, COLOR_GREEN, "t�rgy adatok ID null�zva.");
	//mysql_query("ALTER TABLE `users` DROP `ID`");
	//mysql_query("ALTER TABLE  `users` ADD  `ID` INT NOT NULL AUTO_INCREMENT FIRST , ADD PRIMARY KEY (  `ID` )");
	//SendClientMessage(playerid, COLOR_GREEN, "felhaszn�l�k ID null�zva.");
	return 1;
}

CMD:scm(playerid, params[])
{
	new id;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "is[128]", id, params)) return SendClientMessage(playerid, COLOR_GREY, "Haszn�lat: /scm [playerid] [�zenet]");
	if(strlen(params) > 128) return SendClientMessage(playerid, COLOR_RED, "HIBA: Maximum 128 karakteres lehet az �zenet!");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "HIBA: A j�t�kos nem online!");
	SendClientMessage(id, -1, params);
	return 1;
}

CMD:scmtoall(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "s[128]", params)) return SendClientMessage(playerid, COLOR_GREY, "Haszn�lat: /scmtoall [�zenet]");
	if(strlen(params) > 128) return SendClientMessage(playerid, COLOR_RED, "HIBA: Maximum 128 karakteres lehet az �zenet!");
	SendClientMessageToAll(-1, params);
	return 1;
}

CMD:setszint(playerid, params[])
{
	new id, szint;
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "ui", id, szint)) return SendClientMessage(playerid, COLOR_GREY, "Haszn�lat: /setszint [id/n�vr�szlet] [szint]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A j�t�kos nincs csatlakozva.");
    CallRemoteFunction("SetSzintpublic", "ii", id, szint);
    SendAdminCMDMessage(playerid, "SETSZINT", GetPlayerNameEx(id));
	return 1;
}

CMD:fakechat(playerid, params[])
{
	new id;
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "us[128]", id, params)) return SendClientMessage(playerid, COLOR_GREY, "Haszn�lat: /fakechat [id] [�zenet]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A j�t�kos nincs csatlakozva.");
	if(strlen(params) > 128) return SendClientMessage(playerid, COLOR_RED, "HIBA: Maximum 128 karakteres lehet az �zenet!");
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
	if(sscanf(params, "s[24]", nev)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /changename [�j neved]");
	if(!strcmp(GetPlayerNameEx(playerid), nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Most is ez a neved.");
    if(IsStringInSpecials(nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A n�v nem megengedett karaktereket tartalmaz!");
    if(IsStringInvalidBletters(nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A n�vben nem lehet �kezetes bet�!");
	if(strlen(nev) <= 2) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A n�v nem lehet kevesebb mint 2 karakter.");
	if(strlen(nev) > 20) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A n�v nem lehet t�bb mint 20 karakter.");
	if(!strcmp(nev, "nincs", true)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A szart fogod kihaszn�lni...");
	if(!strcmp(nev, "ELADO", true)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A szart fogod kihaszn�lni...");
	format(query, sizeof(query), "SELECT * FROM users WHERE Name = '%s'", nev);
	mysql_query(query);
	mysql_store_result();
	if(mysql_num_rows() != 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Ezt a nevet m�r haszn�lja valaki!"), mysql_free_result();

	ChangeName(playerid, nev);

	SendFormatMessageToAll(COLOR_GREEN, #HORANGE#"%s"#HLIME#" megv�ltoztatta a nev�t. �j neve: "#HGOLD#"%s", GetPlayerNameEx(playerid), nev);
	SendClientMessage(playerid, COLOR_GREEN, #HLIME#"A nevedet ne felejtsd el a SAMP n�vmez�j�ben is �t�rni!");
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
	if(sscanf(params, "us[24]", id, nev)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /achangename [ID/n�vr�szlet] [�j n�v]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A j�t�kos nincs csatlakozva.");
	if(!strcmp(GetPlayerNameEx(id), nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Most is ez a neve.");
    if(IsStringInSpecials(nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A n�v nem megengedett karaktereket tartalmaz!");
    if(IsStringInvalidBletters(nev)) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A n�vben nem lehet �kezetes bet�!");
	if(strlen(nev) <= 2) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A n�v nem lehet kevesebb mint 2 karakter.");
	if(strlen(nev) > 20) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A n�v nem lehet t�bb mint 20 karakter.");
	format(query, sizeof(query), "SELECT * FROM users WHERE Name = '%s'", nev);
	mysql_query(query);
	mysql_store_result();
	if(mysql_num_rows() != 0) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Ezt a nevet m�r haszn�lja valaki!"), mysql_free_result();
	
	ChangeName(id, nev);
	
	SendFormatMessageToAll(COLOR_GREEN, #HORANGE#"%s"#HLIME#" megv�ltoztatta a nev�t. �j neve: "#HGOLD#"%s", GetPlayerNameEx(id), nev);
	SendFormatMessage(id, COLOR_GREEN, #HLIME#"%s adminisztr�tor megv�ltoztatta a nevedet!", GetPlayerNameEx(playerid));
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
	    SendClientMessage(playerid, COLOR_ERROR, "HIBA: N�vv�lt�s sikertelen.");
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
	SendClientMessage(playerid, COLOR_GREEN, "K�k: 18648, Piros: 18647, Z�ld: 18649, S�rga: 18650, Feh�r: 18652, R�zsasz�n: 18651");
	SendClientMessage(playerid, COLOR_GREEN, "Villog�: 18646, Szir�na(villog): 19419 Szir�na(nem villog): 19420");
	return 1;
}

CMD:skin(playerid)
{
	ShowPlayerDialog(playerid, SKIN_DIALOG, DIALOG_STYLE_LIST, "V�laszd ki melyik skineddel spawnolj�l!", "Kl�n skin\nBoltban vett skin\nBanda/munka skin", "Kiv�laszt", "Kil�p");
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
			format(str, sizeof(str), "Slot: %d, Tulaj: %s, T�rstulaj: %s, ModelID: %d[%s], sz�n1: %d, sz�n2: %d", i, tarolo3, tarolo1, tarolo2[0], CarName[tarolo2[0]-400], tarolo2[1], tarolo2[2]);
			SendClientMessage(playerid, COLOR_GREY, str);
		}
	}
	return 1;
}

CMD:cmds(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s",
    "�tlagos felhaszn�l�k�nt az al�bbi parancsokat haszn�lhatod:\n",
    "/me - Cselekv�s szimul�l�sa\n",
    "/afk - afk m�d be\n",
	"/back - afk m�d ki\n",
	"/stats - Statisztika\n",
	"! - Teamchat\n",
	"/spawn - Spawnol�si hely\n",
	"/skin  - Spawnol�si skin\n",
	"/jedi - F�nykard\n",
	"/fogadas - Valaki 1v1-es DM meccsre h�v�sa\n");
	if(GetPVarInt(playerid, "Level") == 1)
	{
	    format(dstring, sizeof(dstring), "%s%s%s%s%s%s", dstring,
		"Moder�tork�nt az al�bbi parancsokat haszn�lhatod:\n",
		"/warn - Figyelmeztet�s kioszt�sa\n",
		"/slap - J�t�kos feldob�sa\n",
		"# - Adminchat\n",
		"/carrespawn - J�rm�vek respawnol�sa		|| /apanel - Adminpanel");
 	}
	else if(GetPVarInt(playerid, "Level") == 2)
	{
	    format(dstring, sizeof(dstring), "%s\n%s%s%s%s%s%s%s%s", dstring,
		"Kezd� Adminisztr�tork�nt az al�bbi parancsokat haszn�lhatod:\n",
		"/warn - Figyelmeztet�s kioszt�sa		|| /goto - Teleport�l�s valakihez\n",
		"/slap - J�t�kos feldob�sa		|| /announce - K�perny� �zenet\n",
		"# - Adminchat		|| + - Asay/AdminMSG\n",
		"/carrespawn - J�rm�vek respawnol�sa		|| /apanel - Adminpanel\n",
		"/mute - Valaki n�m�t�sa		|| /unmute - N�m�t�s felold�sa\n",
		"/akill - Valaki meg�l�se		|| /kick - Valaki kir�g�sa\n",
		"/weather - Id�j�r�s megv�ltoztat�sa");
	}
	else if(GetPVarInt(playerid, "Level") == 3)
	{
	    format(dstring, sizeof(dstring), "%s\n%s%s%s%s%s%s%s%s%s%s%s%s", dstring,
		"Halad� Adminisztr�tork�nt az al�bbi parancsokat haszn�lhatod:\n",
		"/warn - Figyelmeztet�s kioszt�sa		|| /goto - Teleport�l�s valakihez\n",
		"/slap - J�t�kos feldob�sa		|| /announce - K�perny� �zenet\n",
		"# - Adminchat		|| + - Asay/AdminMSG\n",
		"/carrespawn - J�rm�vek respawnol�sa		|| /apanel - Adminpanel\n",
		"/mute - Valaki n�m�t�sa		|| /unmute - N�m�t�s felold�sa\n",
		"/akill - Valaki meg�l�se		|| /kick - Valaki kir�g�sa\n",
		"/weather - Id�j�r�s megv�ltoztat�sa		|| /get - Valaki hozz�d teleport�l�sa\n",
		"/ban - Valaki v�gleges kitilt�sa		|| /setskin - Valaki skinj�nek megv�ltoztat�sa\n",
		"/freeze - Valaki lefagyaszt�sa		|| /unfreeze - Fagyaszt�s felold�sa\n",
		"/events - Eventek ind�t�sa		|| /healall - Mindenki �let�nek felt�lt�se\n",
		"/disarm - Valaki lefegyverz�se");
	}
	else if(GetPVarInt(playerid, "Level") == 4)
	{
	    format(dstring, sizeof(dstring), "%s\n%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s", dstring,
		"F� Adminisztr�tork�nt az al�bbi parancsokat haszn�lhatod:\n",
		"/warn - Figyelmeztet�s kioszt�sa		|| /goto - Teleport�l�s valakihez\n",
		"/slap - J�t�kos feldob�sa		|| /announce - K�perny� �zenet\n",
		"# - Adminchat		|| + - Asay/AdminMSG\n",
		"/carrespawn - J�rm�vek respawnol�sa		|| /apanel - Adminpanel\n",
		"/mute - Valaki n�m�t�sa		|| /unmute - N�m�t�s felold�sa\n",
		"/akill - Valaki meg�l�se		|| /kick - Valaki kir�g�sa\n",
		"/weather - Id�j�r�s megv�ltoztat�sa		|| /get - Valaki hozz�d teleport�l�sa\n",
		"/ban - Valaki v�gleges kitilt�sa		|| /setskin - Valaki skinj�nek megv�ltoztat�sa\n",
		"/freeze - Valaki lefagyaszt�sa		|| /unfreeze - Fagyaszt�s felold�sa\n",
		"/events - Eventek ind�t�sa		|| /healall - Mindenki �let�nek felt�lt�se\n",
		"/disarm - Valaki lefegyverz�se		|| /gravity - Gravit�ci� megv�ltoztat�sa\n",
		"/setlevel - Valaki rangj�nak megv�ltoztat�sa		|| /setcash - Valaki p�nz�nek �t�ll�t�sa\n",
		"/setkills - Valaki �l�seinek �t�ll�t�sa		|| /setdeaths - Valaki hal�lainak �t�ll�t�sa\n",
		"/leaderad - Valaki leaderr� kinevez�se		|| /time - Id� �t�ll�t�sa\n");
	}

	if(GetPVarInt(playerid, "VIP") == 1)
	{
	    format(dstring, sizeof(dstring), "%s\n%s%s%s%s%s", dstring,
	    "VIP tagk�nt a k�vetkez� parancsokat haszn�lhatod:\n",
	    "/carrespawn - J�rm�vek respawnol�sa    || /trespawn - Plat�k respawnol�sa\n",
	    "/vsay - VIP besz�d\n",
	    "/spectate - J�t�kos n�z�se     || /spectateoff - Kil�p�s a n�z�sb�l\n",
	    "/warn - J�t�kos figyelmeztet�se");
	    
	}
	ShowPlayerDialog(playerid, DIALOG_PARANCSLIST, DIALOG_STYLE_MSGBOX, "Parancslista:", dstring, "OK", "");
    return 1;
}

CMD:help(playerid)
{
	format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Szab�lyzat: "#HYELLOW#"/rules\n",
	""#HWHITE#"Munk�k: "#HYELLOW#"/jobs\n",
	""#HWHITE#"H�z inform�ci�k: "#HYELLOW#"/houseinfo\n",
	""#HWHITE#"Biznisz inform�ci�k: "#HYELLOW#"/bizinfo\n",
	""#HWHITE#"Aut� inform�ci�k: "#HYELLOW#"/autoinfo\n",
	""#HWHITE#"Verseny inform�ci�k: "#HYELLOW#"/racesinfo\n",
	""#HWHITE#"Kl�n inform�ci�k: "#HYELLOW#"/claninfo\n",
	""#HWHITE#"Lott� inform�ci�k: "#HYELLOW#"/lottoinfo\n",
	""#HWHITE#"Hal�sz�s inform�ci�k: "#HYELLOW#"/fishinfo\n",
	""#HWHITE#"Hidraulikaverseny inform�ci�k: "#HYELLOW#"/hidinfo\n",
	""#HWHITE#"Benzin inform�ci�k: "#HYELLOW#"/fuelinfo\n",
	""#HWHITE#"Szint inform�ci�k: "#HYELLOW#"/szintinfo\n",
	""#HWHITE#"K�ldet�s inform�ci�k: "#HYELLOW#"/questinfo\n",
	""#HWHITE#"Teljes�tm�ny inform�ci�k: "#HYELLOW#"/achinfo\n",
	""#HWHITE#"P�nzszerz�si lehet�s�gek: "#HYELLOW#"/money\n",
	""#HWHITE#"Tapasztalatszerz�si lehet�s�gek: "#HYELLOW#"/exp\n",
	""#HWHITE#"Kinyitott achievementek: "#HYELLOW#"/myach, /ach\n",
	""#HWHITE#"K�pess�g inform�ci�k: "#HYELLOW#"/skillinfo\n",
	""#HWHITE#"Parancsok: "#HYELLOW#"/cmds\n",
	""#HWHITE#"Online adminok: "#HYELLOW#"/admins");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Seg�ts�g", dstring, "Ok�", "");
	return 1;
}

CMD:skillinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Spawnol�sn�l minden j�t�kos kap egy fegyvert, egy �n. "#HYELLOW#"k�pess�g fegyvert"#HWHITE#". Ez a fegyver a Sniper rifle.\n",
	""#HWHITE#"Mivel ez egy k�pess�g fegyver, ez�rt nincs sebz�se.\n",
	""#HWHITE#"Ennek a fegyvernek 3 funkci�ja van, ami a jobb als� sarokban olvashat�.\n",
	""#HWHITE#"Ezeket a k�pess�geket k�pess�gpontokkal lehet fejleszteni, amit szintl�p�skor kapsz.\n",
	""#HWHITE#"Az �jonnan regisztr�lt j�t�kosok kapnak 1 k�pess�gpontot, amivel fejleszthetnek 1 k�pess�get.\n",
	""#HWHITE#"Min�l nagyobb egy k�pess�g szintje, ann�l kisebb az �jrat�lt�si id�.\n",
	""#HWHITE#"A k�pess�gek "#HYELLOW#"k�z�tt a k�z�ps� eg�rgombbal ('g�rg�vel')"#HWHITE#" vagy a NUM1 gombbal lehet navig�lni.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"A "#HYELLOW#"/skills"#HWHITE#" paranccsal lehet fejleszteni a k�pess�geket.\n",
	""#HWHITE#"\n",
	""#HWHITE#"K�pess�gek:\n",
	""#HWHITE#""#HYELLOW#"Teleport: "#HWHITE#"Ahova l�sz a fegyverrel oda teleport�lsz.\n",
	""#HWHITE#""#HYELLOW#"�get�s: "#HWHITE#"Ha egy j�t�kos mell� l�sz, elkezd �gni.\n",
	""#HWHITE#""#HYELLOW#"Vonz�s: "#HWHITE#"Ha egy j�rm�re l�sz amiben nem �l senki, odavonzod magadhoz.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "K�pess�gek", dstring, "Ok�", "");
	return 1;
}

CMD:hidinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Lehet�s�ged van jelentkezni hidraulikaversenyre a m�l�n�l.\n",
	""#HWHITE#"Ehhez sz�ks�ged van egy j�rm�re, ami fel van tuningolva hidraulik�val.\n",
	""#HWHITE#"Ha ez megvan, csatlakozhatsz a versenybe az I bet�be bele�llva\n",
	""#HWHITE#"Ut�na menj bele a piros k�rbe, �s nyomd azokat a hidraulikagombokat, amiket �r.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Hidraulika verseny", dstring, "Ok�", "");
	return 1;
}

CMD:questinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Minden szintn�l kapsz egy �j k�ldet�st, amit fel tudsz venni �s meg tudsz csin�lni.\n",
	""#HWHITE#"Egy k�ldet�s teljes�t�se ut�n p�nz �s EXP jutalmat kapsz.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/quests - "#HYELLOW#"Elfogadhat� k�ldet�sek megjelen�t�se\n",
	""#HWHITE#"/questcont - "#HYELLOW#"Megmutatja mit kell csin�lnod az aktu�lis k�ldet�sben\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "K�ldet�sek", dstring, "Ok�", "");
	return 1;
}

CMD:szintinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Szintet l�pni EXP "#HYELLOW#"(Experience = tapasztalat)"#HWHITE#" gy�jt�s�vel lehet.\n",
	""#HWHITE#"Szintenk�nt k�l�nb�z� mennyis�g� tapasztalatot kell �sszegy�jteni.\n",
	""#HWHITE#"A szintl�p�s fontos, mert egyes dolgok csak egy adott szintt�l v�lnak el�rhet�v�.\n",
    ""#HWHITE#"Minden szintl�p�skor jutalmat kapsz, �s egy k�ldet�st, amit el tudsz v�gezni. "#HYELLOW#"(/questinfo)\n",
    ""#HWHITE#"A jelenlegi maximum szint 50.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Szint inform�ci�", dstring, "Ok�", "");
	return 1;
}

CMD:money(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Sokf�lek�ppen lehet p�nzt szerezni a szerveren.\n",
	""#HWHITE#"- Munk�val "#HYELLOW#"(/jobs)"#HWHITE#"Aj�nlott munk�k: P�nzsz�ll�t�, Kamionos, Bankrabl�, Hotdogos, Farmer\n",
	""#HWHITE#"- Versenyz�ssel "#HYELLOW#"(/racesinfo)\n",
	""#HWHITE#"- Horg�sz�ssal "#HYELLOW#"(/fishinfo)\n",
	""#HWHITE#"- Lott�z�ssal "#HYELLOW#"(/lottoinfo)\n",
	""#HWHITE#"- M�s j�t�kos �l�s�vel, mivel ha meg�lsz egy j�t�kost, megkapod a n�la l�v� p�nz fel�t\n",
	""#HWHITE#"- Rejtett csomagok megtal�l�s�val\n",
	""#HWHITE#"- Hidraulika versennyel "#HYELLOW#"(/hidinfo)\n",
	""#HWHITE#"- K�ldet�sek teljes�t�s�vel "#HYELLOW#"(/questinfo)\n",
	""#HWHITE#"- Szintl�p�ssel"#HYELLOW#"(/szintinfo)\n",
	""#HWHITE#"- Band�sk�nt ter�letek elfoglal�s�val\n",
	""#HWHITE#"- M�s j�t�kos legy�z�s�vel az ar�n�ban. "#HYELLOW#"(/fogadas)\n",
	""#HWHITE#"- Boltok rabl�s�val "#HYELLOW#"(/rabol)\n",
	""#HWHITE#"- Achievementek teljes�t�s�vel "#HYELLOW#"(/myach, /achinfo)\n",
	""#HWHITE#"- Reakci�tesztek megold�s�val\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "P�nzszerz�si lehet�s�gek", dstring, "Ok�", "");
	return 1;
}

CMD:achinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Teljes�tm�nyek el�r�s�vel Tapasztalat pontokat gy�jthetsz.\n",
	""#HWHITE#"/myach - "#HYELLOW#"Megn�zheted vele az achievementjeidet.\n",
	""#HWHITE#"/ach - "#HYELLOW#"M�s j�t�kosok achievementjeit n�zheted meg vele.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "P�nzszerz�si lehet�s�gek", dstring, "Ok�", "");
	return 1;
}

CMD:exp(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Sokf�lek�ppen lehet tapasztalatot szerezni a szerveren.\n",
	""#HWHITE#"- Munk�val "#HYELLOW#"(/jobs)"#HWHITE#" [EXP mennyis�g: 1-15]\n",
	""#HWHITE#"- Versenyz�ssel "#HYELLOW#"(/racesinfo)"#HWHITE#" [EXP mennyis�g: 10-50]\n",
	""#HWHITE#"- Horg�sz�ssal "#HYELLOW#"(/fishinfo)"#HWHITE#" [EXP mennyis�g: 15]\n",
	""#HWHITE#"- M�s j�t�kos �l�s�vel [EXP mennyis�g: 15]\n",
	""#HWHITE#"- Reakci�tesztek megold�s�val [EXP mennyis�g: 3]\n",
	""#HWHITE#"- Hidraulika versennyel "#HYELLOW#"(/hidinfo)"#HWHITE#" [EXP mennyis�g: 10]\n",
	""#HWHITE#"- K�ldet�sek teljes�t�s�vel "#HYELLOW#"(/questinfo)"#HWHITE#" [EXP mennyis�g: 100-...]\n",
	""#HWHITE#"- Band�sk�nt ter�letek elfoglal�s�val [EXP mennyis�g: 10]\n",
	""#HWHITE#"- Achievementek teljes�t�s�vel "#HYELLOW#"(/myach, /achinfo)"#HWHITE#" [EXP mennyis�g: 40-2000]\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Tapasztalatszerz�si lehet�s�gek", dstring, "Ok�", "");
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
    
	format(dstring, sizeof(dstring), #HWHITE#"50 k�sel�s: %s(%02d/50)\n100 k�sel�s: %s(%02d/100)\n\
	50 �l�s 9mm-el: %s(%02d/50)\n100 �l�s 9mm-el: %s(%02d/100)\n\
	50 �l�s Deagle-el: %s(%02d/50)\n100 �l�s AK-47-tel: %s(%02d/100)\n100 �l�s SMG-vel: %s(%02d/100)\n\
	30 zsaru meg�l�se: %s(%02d/30)\n30 katona meg�l�se: %s(%02d/30)\n30 Rodney band�s meg�l�se: %s(%02d/30)\n\
	Versenyrekord fel�ll�t�sa: %d\n1. helyezett versenyben: %d\n2. helyezett versenyben: %d\n\
	3. helyezett versenyben: %d\n",
	(achies[0]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 k�sel�s
	(achies[0]) ? (50) : (GetAchievement(playerid, "knifes")),
	(achies[1]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 k�sel�s
	(achies[1]) ? (100) : (GetAchievement(playerid, "knifes")),
	(achies[2]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 9mm �l�s
	(achies[2]) ? (50) : (GetAchievement(playerid, "9mm")),
	(achies[3]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 9mm �l�s
	(achies[3]) ? (100) : (GetAchievement(playerid, "9mm")),
	(achies[4]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 Deagle �l�s
	(achies[4]) ? (50) : (GetAchievement(playerid, "Deagle")),
	(achies[5]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 AK-47 �l�s
	(achies[5]) ? (100) : (GetAchievement(playerid, "AK47")),
	(achies[6]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 SMG �l�s
	(achies[6]) ? (100) : (GetAchievement(playerid, "SMG")),
	(achies[7]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //30 zsaru �l�s
	(achies[7]) ? (30) : (GetAchievement(playerid, "Policekills")),
	(achies[8]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //30 katona �l�s
	(achies[8]) ? (30) : (GetAchievement(playerid, "Armykills")),
	(achies[9]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //30 Rodney band�s �l�s
	(achies[9]) ? (30) : (GetAchievement(playerid, "Rodkills")),
	GetAchievement(playerid, "RaceRecords"),
	GetAchievement(playerid, "Racegold"),
	GetAchievement(playerid, "Racesilver"),
	GetAchievement(playerid, "Racebronze"));
	
	format(dstring, sizeof(dstring), "%s50 p�rbaj megnyer�se: %s(%02d/50)\n100 p�rbaj megnyer�se: %s(%02d/100)\n200 p�rbaj megnyer�se: %s(%02d/200)\n\
	200 j�rm� vezet�se: %s(%02d/200)\n500 j�rm� vezet�se: %s(%02d/500)\n50 bolt kirabl�sa: %s(%02d/50)\n100 bolt kirabl�sa: %s(%02d/100)\n\
	50-szer letart�ztatva: %s(%02d/50)\n100-szor letart�ztatva: %s(%02d/100)", dstring,
	(achies[10]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 p�rbaj megnyer�se
	(achies[10]) ? (50) : (GetAchievement(playerid, "dmwins")),
	(achies[11]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 p�rbaj megnyer�se
	(achies[11]) ? (100) : (GetAchievement(playerid, "dmwins")),
	(achies[12]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //200 p�rbaj megnyer�se
	(achies[12]) ? (200) : (GetAchievement(playerid, "dmwins")),
	(achies[13]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //200 j�rm� vezet�se
	(achies[13]) ? (200) : (GetAchievement(playerid, "vehdrives")),
	(achies[14]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //500 j�rm� vezet�se
	(achies[14]) ? (500) : (GetAchievement(playerid, "vehdrives")),
	(achies[15]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 bolt kirabl�sa
	(achies[15]) ? (50) : (GetAchievement(playerid, "shoprob")),
	(achies[16]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 bolt kirabl�sa
	(achies[16]) ? (100) : (GetAchievement(playerid, "shoprob")),
	(achies[17]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50-szer letart�ztatva
	(achies[17]) ? (50) : (GetAchievement(playerid, "jails")),
	(achies[18]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100-szor letart�ztatva
	(achies[18]) ? (100) : (GetAchievement(playerid, "jails")));

	ShowPlayerDialog(playerid, MYACHIE_DIALOG, DIALOG_STYLE_MSGBOX, "Achievementek", dstring, "Tov�bb", "Kil�p");
	return 1;
}

CMD:ach(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /ach [ID/n�vr�szlet]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "A j�t�kos nem el�rhet�.");
	
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

	format(dstring, sizeof(dstring), #HWHITE#"50 k�sel�s: %s\n100 k�sel�s: %s\n50 �l�s 9mm-el: %s\n100 �l�s 9mm-el: %s\n\
	50 �l�s Deagle-el: %s\n100 �l�s AK-47-tel: %s\n100 �l�s SMG-vel: %s\n30 zsaru meg�l�se: %s\n30 katona meg�l�se: %s\n\
	30 Rodney band�s meg�l�se: %s\nVersenyrekord fel�ll�t�sa: %d\n1. helyezett versenyben: %d\n2. helyezett versenyben: %d\n\
	3. helyezett versenyben: %d\n",
	(achies[0]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 k�sel�s
	(achies[1]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 k�sel�s
	(achies[2]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 9mm �l�s
	(achies[3]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 9mm �l�s
	(achies[4]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 Deagle �l�s
	(achies[5]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 AK-47 �l�s
	(achies[6]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 SMG �l�s
	(achies[7]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //30 zsaru �l�s
	(achies[8]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //30 katona �l�s
	(achies[9]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //30 Rodney band�s �l�s
	GetAchievement(id, "RaceRecords"),
	GetAchievement(id, "Racegold"),
	GetAchievement(id, "Racesilver"),
	GetAchievement(id, "Racebronze"));

	format(dstring, sizeof(dstring), "%s50 p�rbaj megnyer�se: %s\n100 p�rbaj megnyer�se: %s\n200 p�rbaj megnyer�se: %s\n\
	200 j�rm� vezet�se: %s\n500 j�rm� vezet�se: %s\n50 bolt kirabl�sa: %s\n100 bolt kirabl�sa: %s\n\
	50-szer letart�ztatva: %s\n100-szor letart�ztatva: %s\n", dstring,
	(achies[10]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 p�rbaj megnyer�se
	(achies[11]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 p�rbaj megnyer�se
	(achies[12]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //200 p�rbaj megnyer�se
	(achies[13]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //200 j�rm� vezet�se
	(achies[14]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //500 j�rm� vezet�se
	(achies[15]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 bolt kirabl�sa
	(achies[16]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 bolt kirabl�sa
	(achies[17]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50-szer letart�ztatva
	(achies[18]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#)); //100-szor letart�ztatva

	new achst[50];
	format(achst, sizeof(achst), "%s Achievementjei", GetPlayerNameEx(id));
	SetPVarInt(playerid, "achcmd", id);
	ShowPlayerDialog(playerid, ACHIE_DIALOG, DIALOG_STYLE_MSGBOX, achst, dstring, "Tov�bb", "Kil�p");
	return 1;
}

CMD:fuelinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s",
	""#HWHITE#"A j�rm�vekb�l egyszer kifogy a benzin.\n",
	""#HWHITE#"Ha k�zj�rm�r�l van sz�, akkor az carrespawnkor �jrat�lt�dik,\n",
	""#HWHITE#"de ha saj�t j�rm�r�l van sz� akkor szerver restart ut�n is megmarad annyi amennyi volt.\n",
	""#HWHITE#"Tankolni a "#HYELLOW#"/tankol "#HWHITE#"paranccsal lehets�ges egy benzink�ton.\n",
	""#HWHITE#"A j�rm� motorj�t az "#HYELLOW#"N "#HWHITE#" gomb megnyom�s�val ind�thatod el �s �ll�thatod le.\n",
	""#HWHITE#"A saj�t j�rm�ved benzint�rol�j�nak kapacit�s�t n�velheted a j�rm� fejleszt�s�vel. (Szint)");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Tankol�s", dstring, "Ok�", "");
	return 1;
}

CMD:fishinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s",
	""#HWHITE#"A szerveren lehet�s�g van horg�szatra.\n",
	""#HWHITE#"A dolgod hogy elm�sz a tengerpartra, vagy ak�r cs�nakban a nyilt tenggerre,\n",
	""#HWHITE#"be�rod a "#HYELLOW#"/fish "#HWHITE#"parancsot �s v�rsz am�g nem lesz kap�s.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Hal�sz�s", dstring, "Ok�", "");
	return 1;
}

CMD:claninfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Lehet�s�ged van a szerveren kl�nt l�trehozni.\n",
	""#HWHITE#"Ha l�treszeretn�l hozni, rendelkezned kell minimum 1.5 milli� $-al.\n",
	""#HWHITE#"Ha van saj�t kl�nod, vehetsz hozz� j�rm�veket, amiket csak a kl�ntagok tudnak vezetni.\n",
	""#HWHITE#"H�bor�zhatsz m�s kl�nok ellen k�l�nb�z� p�ly�kon, �s gy�jthetitek a kl�nkassz�ba a p�nzt.\n",
	""#HWHITE#"Saj�t rangokat hozhatsz l�tre, �s a rangok jogait szabadon testreszabhatod.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/createclan - "#HYELLOW#"Kl�n l�trehoz�sa\n",
	""#HWHITE#"/claninvite - "#HYELLOW#"Kl�nmegh�v� k�ld�se\n",
	""#HWHITE#"/clanjoin  - "#HYELLOW#"Kl�nmegh�v� elfogad�sa\n",
	""#HWHITE#"/clanreject - "#HYELLOW#"Kl�nmegh�v� elutas�t�sa\n",
	""#HWHITE#"/clanpanel - "#HYELLOW#"Kl�n panel\n",
	""#HWHITE#"/c - "#HYELLOW#"Kl�n chat\n",
	""#HWHITE#"/clans - "#HYELLOW#"Jelenlegi kl�nok\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Kl�nok", dstring, "Ok�", "");
	return 1;
}

CMD:lottoinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s",
	""#HWHITE#"Egy lott�szelv�ny 15.000$ amit a "#HYELLOW#"/lotto "#HWHITE#"paranccsal tudsz megvenni.\n",
	""#HWHITE#"20 percenk�nt van sorsol�s. Ha eltal�ltad mind az 5 sz�mot megnyerted a f�nyerem�nyt.\n",
	""#HWHITE#"De ha nem tal�ltad el, akkoris sz�p �sszeget kapsz!\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Lott�z�s", dstring, "Ok�", "");
	return 1;
}

CMD:rules(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"1.� Tilos b�rmif�le mod, cheat vagy hack haszn�lata! "#HRED#"[ban]\n\n",
	""#HWHITE#"2.� Tilos m�s szerverek rekl�moz�sa! "#HRED#"[ban]\n\n",
	""#HWHITE#"3.� Tilos az any�z�s, k�romkod�s, rasszizmus, adminszid�s! "#HRED#"[kick/mute/jail]\n\n",
	""#HWHITE#"4.� Tilos b�rmilyen bug kihaszn�l�sa! [kick > ban]\n\n",
	""#HWHITE#"5.� Tilos az IK, DB, SK, Glitch! (Fogalmak lentebb) "#HRED#"[kick]\n\n",
	""#HWHITE#"6.� Tilos a flood, vagyis ne �rj le t�bbsz�r egym�s ut�n semmit! "#HRED#"[mute/warn/kick]\n\n",
	""#HWHITE#"7.� Tilos az interiorok kihaszn�l�sa! (Pl. fegyverbolt)"#HRED#"[warn]\n\n",
	""#HWHITE#"8.� Tilos az adminjog k�reget�se! "#HRED#"[kick]\n\n",
    ""#HWHITE#"9.� Bandater�leteket csak h�tk�znapi j�rm�vekkel lehet t�madni! "#HRED#"[warn/kick]\n\n",
    ""#HWHITE#"Fogalmak\n\n",
    ""#HRED#"Glitch\n",
    ""#HWHITE#"Azt nevezz�k Glitchnek, amikor egy fegyver t�rj�b�l kil�sz p�ld�ul 20 t�lt�nyt, marad benne 30,\n",
    ""#HWHITE#"�s hogy ne kelljen t�raznod, gyorsan fegyvert cser�lsz oda-vissza, hogy tele legyen a fegyver t�rja.\n\n",
    ""#HRED#"DB/Drive-by\n",
    ""#HWHITE#"DB-nek nevezz�k azt, amikor egy j�t�kos j�rm� seg�ts�g�vel �l/sebez meg egy gyalogost.\n",
    ""#HWHITE#"Gyakori el�fordul�sok:\n",
    ""#HWHITE#"- J�rm� b�rmely �l�s�b�l l�nek gyalogosra.\n",
    ""#HWHITE#"- El�tik a gyalogost.\n",
    ""#HWHITE#"- J�rm�vel r��llnak a gyalogosra.\n",
    ""#HWHITE#"- Fegyveres j�rm�vel l�nek a gyalogosra.\n",
    ""#HRED#"Figyelem: Ha a j�rm� sof�rj�t l�v�d, az nem DB!\n\n",
	""#HRED#"IK/Interior Kill\n",
	""#HWHITE#"IK-nak nevezz�k azt amikor egy j�t�kos egy m�sikat �p�letben �l/sebez meg.\n\n",
	""#HRED#"SK/Spawn Kill\n",
	""#HWHITE#"SK-nak nevezz�k azt amikor egy j�t�kos a lespawnol�s ut�n egyb�l meg�li a m�sikat.\n\n",
	""#HRED#"Interior kihaszn�l�s\n",
	""#HWHITE#"Amikor harcolsz, tilos a fegyverboltba rohang�lnod armour t�lt�s�rt!\n",
	""#HWHITE#"Amikor harcolsz, tilos egy �tkez�be bemenned �let t�lt�s�rt!\n",
	""#HWHITE#"Amikor egy rend�r �ld�z, tilos bemenni egy �p�letbe hogy ne kaphasson el!\n");
	ShowPlayerDialog(playerid, RULES1_DIALOG, DIALOG_STYLE_MSGBOX, "Szab�lyzat", dstring, "Tov�bb", "Ok�");
	return 1;
}

CMD:houseinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"A szerveren vehetsz saj�t h�zat amiben lakhatsz, a /spawn paranccsal �ll�thatod be hogy ott spawnolj.\n",
	""#HWHITE#"A t�rk�pen a megvehet� h�zak "#HLIME#"z�ld "#HWHITE#"h�zjellel vannak jel�lve.\n",
	""#HWHITE#"A h�zadba kiv�laszthatsz m�g egy t�rstulajt is akivel ketten laktok ott.\n",
	""#HWHITE#"A h�zadat el is nevezheted, �s kedved szerint rendezheted be mindenf�le t�rgyal.\n",
	""#HWHITE#"Lehet�s�ged van m�g lak�kocsiba is lakni. Ehhez venned kell egy Journey t�pus� aut�t, \n",
	""#HWHITE#"�s a "#HYELLOW#"/spawn "#HWHITE#"paranccsal be kell �ll�tanod kezd�helynek a lak�kocsit. \n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/tarstulaj - "#HYELLOW#"Kinevezhetsz magad mell� egy t�rstulajt\n",
	""#HWHITE#"/tarstulajelvesz - "#HYELLOW#"Elveheted a t�rstulajt\n",
	""#HWHITE#"/tarstulajkilep - "#HYELLOW#"Ha t�rstulaj vagy egy h�zn�l, ezzel elveheted magadt�l\n",
	""#HWHITE#"/hazad - "#HYELLOW#"�tadhatod a h�zat\n",
	""#HWHITE#"/housemenu - "#HYELLOW#"H�zmen�\n",
	""#HWHITE#"/lockhouse - "#HYELLOW#"Bez�rod a h�zat\n",
	""#HWHITE#"/unlockhouse - "#HYELLOW#"Kinyitod a h�zat\n",
	""#HWHITE#"A h�zakba az "#HYELLOW#"Y "#HWHITE#"gomb seg�ts�g�vel tudsz bemenni �s kimenni. A k�nnyebb v�laszt�s�rt az elad� h�zakba is bemehetsz.");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "H�zak", dstring, "Ok�", "");
	return 1;
}

CMD:autoinfo(playerid)
{
	format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Vehetsz saj�t aut�kat amik n�vre sz�lnak �s csak te tudod vezetni.\n",
	""#HWHITE#"Az aut�kra vehetsz tuningot �s neont.\n",
	""#HWHITE#"Ha venn�l, menj el a Ryuuzaki's cars-ba, ami az Otto's autos 3. emelet�n tal�lhat�.\n",
	""#HWHITE#"Ha van saj�t aut�d, m�g lehet�s�ged van 1 j�t�kosnak odaadni a kulcsot hozz�.\n",
	""#HWHITE#"A fegyvered csomagtart�j�ban fegyvert is t�rolhatsz.\n",
	""#HWHITE#"Egyszerre maximum 10 j�rm�ved lehet.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/mycars - "#HYELLOW#"Megtekintheted az aut�idat\n",
	""#HWHITE#"/kulcsad - "#HYELLOW#"Odaadod a kulcsot egy j�t�kosnak\n",
	""#HWHITE#"/kulcselvesz - "#HYELLOW#"Elveszed a kulcsot egy j�t�kost�l\n",
	""#HWHITE#"/autoad - "#HYELLOW#"Odaadod az aut�t egy j�t�kosnak\n",
	""#HWHITE#"/cstki - "#HYELLOW#"Kinyitod az aut� csomagtart�j�t\n",
	""#HWHITE#"/cstbe - "#HYELLOW#"Bez�rod az aut� csomagtart�j�t\n",
	""#HWHITE#"/mhki - "#HYELLOW#"Kinyitod az aut� motorh�ztet�j�t\n",
	""#HWHITE#"/mhbe - "#HYELLOW#"Bez�rod az aut� motorh�ztet�j�t\n",
	""#HWHITE#"/lock - "#HYELLOW#"Bez�rod az aut� ajtaj�t\n",
	""#HWHITE#"/unlock - "#HYELLOW#"Kinyitod az aut� ajtaj�t\n",
	""#HWHITE#"/autoszerkeszt - "#HYELLOW#"Szerkesztheted vele az aut�idat\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "J�rm�vek", dstring, "Ok�", "");
	return 1;
}

CMD:bizinfo(playerid)
{
	format(dstring, sizeof(dstring), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
	""#HWHITE#"Vehetsz saj�t bizniszt, ami termeli neked a p�nzt akkor is, ha nem vagy fent a szerveren.\n",
	""#HWHITE#"Csak 1 bizniszed lehet, mivel egyel is j�l lehet keresni.\n",
	""#HWHITE#"Minn�l dr�g�bb egy biznisz, ann�l t�bb p�nzt termel.\n",
	""#HWHITE#"Parancsok:\n",
	""#HWHITE#"/buybiz - "#HYELLOW#"Ha egy biznisz k�zel�ben vagy, ezzel a parancsal tudod megvenni.\n",
	""#HWHITE#"/sellbiz - "#HYELLOW#"Ezzel tudod eladni a bizniszedet, viszont ut�na nem kapod vissza az �r�t, se semennyit.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Bizniszek", dstring, "Ok�", "");
	return 1;
}

CMD:racesinfo(playerid)
{
    format(dstring, sizeof(dstring), "%s%s%s",
	""#HWHITE#"A szerveren a f�admin ind�that versenyeket �s stuntokat, vagy n�ha id�k�z�nk�nt indulnak.\n",
	""#HWHITE#"Ha csatlakozni szeretn�l egyhez: "#HYELLOW#"/join, "#HWHITE#"ha k�szen �llsz a versenyre: "#HYELLOW#"/ready.\n",
	""#HWHITE#"Ha el akarod hagyni a versenyt: "#HYELLOW#"/leave, "#HWHITE#"ha a rekordokat szeretn�d megn�zni: "#HYELLOW#"/rekordok.\n");
	ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Versenyek", dstring, "Ok�", "");
	return 1;
}

CMD:jobs(playerid,params[]) {
	SendClientMessage(playerid,COLOR_YELLOW," ][M][U][N][K][�][K][ ");
	SendClientMessage(playerid,COLOR_YELLOW,"M�V vonatvezet�: A vonatot kell vezetnie �s kapja a p�nzt. A t�rk�pen az R jel jel�li.");
	SendClientMessage(playerid,COLOR_YELLOW,"BKV busz �s villamossof�r: J�ratokat ind�t menetrend szerint. A t�rk�pen BS jel�li.");
	SendClientMessage(playerid,COLOR_YELLOW,"Taxis: El kell vinnie a j�t�kost A pontb�l B pontba. A t�rk�pen a T jel jel�li.");
	SendClientMessage(playerid,COLOR_YELLOW,"Katona: Le kell l�nie a k�r�z�tteket. A t�rk�pen pisztoly jel�li.(TP rendszer)");
	SendClientMessage(playerid,COLOR_YELLOW,"Ment�s: Meg kell gy�gy�tania a j�t�kosokat. A t�rk�pen '+' jel jel�li.");
	SendClientMessage(playerid,COLOR_YELLOW,"Kamionos: Fel kell venni a rakom�nyt �s el kell sz�ll�tani az adott helyre. A t�rk�pen teheraut� jel�li.");
	SendClientMessage(playerid,COLOR_YELLOW,"Bankos: A bankba kell sz�ll�tania a p�nzt. A t�rk�pen piros $ jel jel�li.(TP rendszer)");
	SendClientMessage(playerid,COLOR_YELLOW,"Bankrabl�: Ki kell rabolnia a bankot. A t�rk�pen gy�m�nt jel�li.");
	SendClientMessage(playerid,COLOR_YELLOW,"Rend�r: Le kell csuknia a k�r�z�tteket. A t�rk�pen k�k szir�na jel�li.(TP rendszer)");
	SendClientMessage(playerid,COLOR_YELLOW,"Politikus: Semmit se csin�l �s kapja a p�nzt. A t�rk�pen W jel jel�li.");
	SendClientMessage(playerid,COLOR_YELLOW,"Hotdogos: El kell adnia a hotdogot az adott helyeken. A t�rk�pen nincs jel�lve.");
	SendClientMessage(playerid,COLOR_YELLOW,"Farmer: El kell vetnie a term�st �s ut�na learatni. A t�rk�pen az MC jel jel�li.");
	SendClientMessage(playerid,COLOR_YELLOW,"Band�k:");
	SendClientMessage(playerid,COLOR_YELLOW,"Triad: a t�rk�pen a ��piros k�gy� jel jel�li");
	SendClientMessage(playerid,COLOR_YELLOW,"Rifa: a Kamionos munka mellet");
	SendClientMessage(playerid,COLOR_YELLOW,"Maffia:Az �tteremn�l (��villa �s k�s�� jel)");
	SendClientMessage(playerid,COLOR_YELLOW,"Vietnami: A kik�t�ben(Pier 69)");
	SendClientMessage(playerid,COLOR_YELLOW,"Groove: LS-ben a Groove streetn�l");
	SendClientMessage(playerid,COLOR_RED,"TP rendszer: bizonyos TP-nk�nt(pl 20, 40 stb) n� a fizet�sed vagy a fegyverarzen�lod.");
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
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /msn [id/n�vr�szlet]");
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor5[playerid][id]);
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor4[playerid][id]);
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor3[playerid][id]);
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor2[playerid][id]);
 	format(msnstr, sizeof(msnstr), "%s%s\n", msnstr, msnsor1[playerid][id]);
 	SetPVarInt(playerid, "msn", id);
	ShowPlayerDialog(playerid, MSN_DIALOG, DIALOG_STYLE_INPUT, "MSN", msnstr, "Elk�ld", "Kil�p");
	return 1;
}*/
//---------------------------------Rangok, accountok------------------------------------
CMD:mysqlquery(playerid, params[])
{
	new mquery[200];
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(sscanf(params, "s[200]", mquery)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /mysqlquery [Query]");
    format(query, sizeof(query), "%s", mquery);
    mysql_query(query);
    SendAdminCMDMessage(playerid, "MYSQLQUERY");
	return 1;
}

CMD:mysqlselect(playerid, params[])
{
    new mquery[200];
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(sscanf(params, "s[200]", mquery)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /mysqlselect [Query]");
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
		ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Tal�latok", egyezestr, "Kil�p", "");
    }
    else SendClientMessage(playerid, COLOR_RED, "Hiba: Hiba.");
    SendAdminCMDMessage(playerid, "MYSQLSELECT");
	return 1;
}

CMD:egyezes(playerid, params[])
{
	new egynev[24];
    if(sscanf(params, "s[24]", egynev)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /egyezes [j�t�kosn�v]");
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
			    if(bani == 0) format(egyezestr, sizeof(egyezestr), "%s{00FFFF}%s \t\t{ffffff}[IP c�m: %s]\n", egyezestr, nevs, ips);
				else if(bani == 1) format(egyezestr, sizeof(egyezestr), "%s"#HRED#"%s \t\t{ffffff}[IP c�m: %s]\n", egyezestr, nevs, ips);
			}
			mysql_free_result();
			SetPVarString(playerid, "tovabbiegyip", egyip);
			SetPVarString(playerid, "tovabbiegyjelszo", egyjelszo);
			ShowPlayerDialog(playerid, EGYEZES_DIALOG, DIALOG_STYLE_MSGBOX, "Tal�latok", egyezestr, "Tov�bbi tal�latok", "Kil�p");
			SendAdminCMDMessage(playerid, "EGYEZES");
			SetPVarInt(playerid, "egyezesoldal", 1);
		}
		else SendClientMessage(playerid, COLOR_RED, "Nincs tal�lat.");
	}
	else SendClientMessage(playerid, COLOR_RED, "HIBA: Nincs ilyen nev� j�t�kos az adatb�zisban.");
	return 1;
}

CMD:setlevel(playerid, params[])
{
	new adminid, level;
	if(sscanf(params, "ui", adminid, level)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /setlevel [playerid/j�t�kosn�v] [szint]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(adminid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == adminid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if((GetPVarInt(playerid, "Level") < GetPVarInt(adminid, "Level")) && (!IsPlayerAdminEx(playerid))) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    if(level > 4) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: 4 a maximum adminszint!");
    SendAdminCMDMessage(playerid, "SETLEVEL", GetPlayerNameEx(adminid));

    SetPVarInt(adminid, "Level", level);
	switch(GetPVarInt(adminid, "Level"))//az adminszintekhez tartoz� megnevez�s v�ltoz�ba �r�sa
	{
	    case 0: SetPVarString(adminid, "AdminRang", "�tlagos J�t�kos");
		case 1: SetPVarString(adminid, "AdminRang", "Moder�tor");
		case 2: SetPVarString(adminid, "AdminRang", "Kezd� Adminisztr�tor");
		case 3: SetPVarString(adminid, "AdminRang", "Halad� Adminisztr�tor");
		case 4: SetPVarString(adminid, "AdminRang", "F� Adminisztr�tor");
		//case 5: SetPVarString(playerid, "AdminRang", "Any�d");
	}

	new adminpvar[64];
	GetPVarString(adminid, "AdminRang", adminpvar, sizeof(adminpvar));

	//Update3DTextLabelText(Admin3DText[adminid], COLOR_3DLABEL, adminpvar);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: %s rangja sikeresen megv�ltozott! Az �j rang: %s", GetPlayerNameEx(adminid), adminpvar);
    SendFormatMessage(adminid, COLOR_ADMINMSG, "[ ADMIN ]: %s megv�ltoztatta a rangodat! Az �j rang: %s", GetPlayerNameEx(playerid), adminpvar);
    return 1;
}

CMD:leaderad(playerid, params[])
{
	new id, leader, leadernames[][] = {"Sajn�lom, de nem kapt�l, hanem elvett�k t�led!", "Rend�r", "Drogd�ler", "Hacker", "OBKK", "Ryuuzaki's cars", "Rodney team", "Katonas�g", "Stunt munka"};
	if(sscanf(params, "ui", id, leader)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /leaderad [playerid/j�t�kosn�v] [rend�r = 1, drog = 2, hacker = 3, OBKK = 4, Ryuuzaki's cars = 5, Rodney team = 6]"), SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[7 = Katonas�g, 8 = Stunt munka]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(id)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(leader > 8) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Maximum 8 leaderes munk�hoz adhatsz leadert!");
    SendAdminCMDMessage(playerid, "LEADERAD", GetPlayerNameEx(id));

    SetPVarInt(id, "Leader", leader);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: %s-nek leadert adt�l! Amihez adtad a leadert: %s", GetPlayerNameEx(id), leadernames[leader]);
    SendFormatMessage(id, COLOR_ADMINMSG, "[ ADMIN ]: %s leadert adott neked! Amihez adta a leadert: %s", GetPlayerNameEx(playerid), leadernames[leader]);
    return 1;
}

CMD:vip(playerid, params[])
{
    new vipid, p[5];
	if(sscanf(params, "us[5]", vipid, p)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /vip [playerid/j�t�kosn�v] [ad/el]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(vipid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    SendAdminCMDMessage(playerid, "VIP", GetPlayerNameEx(vipid));

    if(!strcmp(p, "ad"))
	{
		SetPVarInt(vipid, "VIP", 1);
        SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen VIP rangot adt�l %s-nek!", GetPlayerNameEx(vipid));
    	SendFormatMessage(vipid, COLOR_ADMINMSG, "[ ADMIN ]: %s VIP rangot adott neked!", GetPlayerNameEx(playerid));
	}
	if(!strcmp(p, "el"))
	{
		SetPVarInt(vipid, "VIP", 0);
        SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen elvetted %s-t�l a VIP rangot!", GetPlayerNameEx(vipid));
    	SendFormatMessage(vipid, COLOR_ADMINMSG, "[ ADMIN ]: %s elvette t�led a VIP rangot!", GetPlayerNameEx(playerid));
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
    if(sscanf(params, "s[128]", reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /bugreport [sz�veg]");

	format(message, sizeof(message), "[ BUG ]: %s (%d) bejelentett egy hib�t: %s", GetPlayerNameEx(playerid), playerid, reason);
	SendClientMessageToAdmins(COLOR_REPORT, message);

	SendFormatMessage(playerid, COLOR_REPORT, "[ BUG ]: Sikeresen bejelentett�l egy hib�t [A hiba: %s ]", reason);
	return 1;
}*/

CMD:givecash(playerid, params[])
{
	new userid, money;
	if(GetPVarInt(playerid, "Logged") == 0) return 1;
	if(sscanf(params, "ui", userid, money)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /givemoney [playerid/j�t�kosn�v] [�sszeg]");
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(money <= 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Val�s �sszeget �rj�l be!");
    if(money > GetPlayerMoneyEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs ennyi p�nzed!");
	if(GetPVarInt(playerid, "1v1dmben") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: DM-ben nem k�ldhetsz p�nzt.");

	GivePlayerMoneyEx(playerid, -money, "P�nzt adott �t");
    GivePlayerMoneyEx(userid, money, "P�nzt kapott m�st�l");

    SendFormatMessage(playerid, COLOR_ADMINMSG, "Sikeresen k�ldt�l %s %d$-t! Jelenleg %d$-ja van!", rag(GetPlayerNameEx(userid),2), money, GetPlayerMoneyEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "%s k�ld�tt neked %d$-t! Jelenleg %d$-od van!", GetPlayerNameEx(playerid), money, GetPlayerMoneyEx(userid));
    return 1;
}

CMD:stats(playerid, params[])
{
	new userid, format1[128], format2[128], format3[128], format4[128];
	format(format1, sizeof(format1),"A statisztik�d:  [�l�sek: %d] - [Hal�lok: %d] - [Ar�ny: %0.2f] - [K�szp�nz: $ %d] - [Eltelt id�: %02d �ra, %02d perc]", GetPVarInt(playerid, "Kills"), GetPVarInt(playerid, "Deaths"), Float:GetPVarInt(playerid, "Kills")/Float:GetPVarInt(playerid, "Deaths"), GetPlayerMoneyEx(playerid), GetPVarInt(playerid, "Ora"), GetPVarInt(playerid, "Perc"));
	format(format3, sizeof(format3),"Kl�n: %s, Szint: %d", GetPVarStringEx(playerid, "Clan"), GetPVarInt(playerid, "Szint"));
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_ADMINMSG, format1), SendClientMessage(playerid, COLOR_ADMINMSG, format3);
	if(!IsPlayerValid(userid)) return SendClientMessage(playerid, RED, Errors[0][0]);
	format(format2, sizeof(format2), "%s statisztik�ja:  [�l�sek: %d] - [Hal�lok: %d] - [Ar�ny: %0.2f] - [K�szp�nz: $%d] - [Eltelt id�: %02d �ra, %02d perc]", GetPlayerNameEx(userid), GetPVarInt(userid, "Kills"), GetPVarInt(userid, "Deaths"), Float:GetPVarInt(userid, "Kills")/Float:GetPVarInt(userid, "Deaths"),GetPlayerMoneyEx(userid), GetPVarInt(userid, "Ora"), GetPVarInt(userid, "Perc"));
    format(format4, sizeof(format4),"Kl�n: %s, Szint: %d", GetPVarStringEx(userid, "Clan"), GetPVarInt(userid, "Szint"));
	SendClientMessage(playerid, COLOR_ADMINMSG, format2), SendClientMessage(playerid, COLOR_ADMINMSG, format4);
	return 1;
}

CMD:ip(playerid, params[])
{
	new userid, IP[50];
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /ip [playerid/j�t�kosn�v]");
    //if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);

	GetPlayerIp(userid, IP, sizeof(IP));
	SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: %s ipje: %s", GetPlayerNameEx(userid), IP);
	return 1;
}

CMD:setkills(playerid, params[])
{
	new userid, kills;
	if(sscanf(params, "ui", userid, kills)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /setkills [playerid/j�t�kosn�v] [�l�sek]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SETKILLS", GetPlayerNameEx(userid));

    SetPVarInt(userid, "Kills", kills);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: �t�ll�tottad %s �l�seinek sz�m�t! Jelenleg %d �l�se van!", GetPlayerNameEx(userid), GetPVarInt(userid, "Kills"));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s �t�l�totta az �l�seid sz�m�t! Jelenleg %d �l�sed van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "Kills"));
    return 1;
}

CMD:setdeaths(playerid, params[])
{
	new userid, deaths;
	if(sscanf(params, "ui", userid, deaths)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /setdeaths [playerid/j�t�kosn�v] [hal�lok]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SETDEATHS", GetPlayerNameEx(userid));

    SetPVarInt(userid, "Deaths", deaths);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: �t�ll�tottad %s hal�lainak sz�m�t! Jelenleg %d hal�la van!", GetPlayerNameEx(userid), GetPVarInt(userid, "Deaths"));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s �t�l�totta a hal�laid sz�m�t! Jelenleg %d hal�lod van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "Deaths"));
    return 1;
}

CMD:unlockach(playerid, params[])
{
    new userid, ac[20], acm;
	if(sscanf(params, "us[20]i", userid, ac, acm)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /unlockach [playerid/j�t�kosn�v] [achievementn�v] [mennyis�g]");
    if(!IsPlayerAdminEx(playerid) && strcmp("Ryuuzaki", GetPlayerNameEx(playerid), true)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    SendAdminCMDMessage(playerid, "UNLOCKACH", GetPlayerNameEx(userid));

    SetPVarInt(userid, ac, acm);
	return 1;
}

CMD:setcash(playerid, params[])
{
	new userid, cash;
	if(sscanf(params, "ui", userid, cash)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /setcash [playerid/j�t�kosn�v] [p�nz]");
    //if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerAdminEx(playerid) && strcmp("Ryuuzaki", GetPlayerNameEx(playerid), true)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    //if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SETCASH", GetPlayerNameEx(userid));

    ResetPlayerMoneyEx(userid);
    GivePlayerMoneyEx(userid, cash);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: �t�ll�tottad %s p�nz�t! Jelenleg %d p�nze van!", GetPlayerNameEx(userid), GetPlayerMoneyEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s �t�l�totta a p�nzedet! Jelenleg %d p�nzed van!", GetPlayerNameEx(playerid), GetPlayerMoneyEx(userid));
	return 1;
}

CMD:setora(playerid, params[])
{
	new userid, ora;
	if(sscanf(params, "ui", userid, ora)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /setora [playerid/j�t�kosn�v] [�r�k sz�ma]");
    if(!IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    SendAdminCMDMessage(playerid, "SETORA", GetPlayerNameEx(userid));

    SetPVarInt(userid, "Ora", ora);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: �t�ll�tottad %s �r�inak sz�m�t! Jelenleg %d �r�d van!", GetPlayerNameEx(userid), GetPVarInt(userid, "Ora"));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s �t�l�totta az �r�idnak sz�m�t! Jelenleg %d �r�d van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "Ora"));
	return 1;
}

CMD:setperc(playerid, params[])
{
	new userid, ora;
	if(sscanf(params, "ui", userid, ora)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /setperc [playerid/j�t�kosn�v] [percek sz�ma]");
    if(!IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    SendAdminCMDMessage(playerid, "SETPERC", GetPlayerNameEx(userid));

    SetPVarInt(userid, "Perc", ora);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: �t�ll�tottad %s perceinek sz�m�t! Jelenleg %d �r�d van!", GetPlayerNameEx(userid), GetPVarInt(userid, "Perc"));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s �t�l�totta a perceidnek sz�m�t! Jelenleg %d �r�d van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "Perc"));
	return 1;
}

CMD:settp(playerid, params[])
{
	new userid, tpp[15], cash;
	if(sscanf(params, "us[15]i", userid, tpp, cash)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /settp [playerid/j�t�kosn�v] [TP] [mennyis�g]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    //if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "SETTP", GetPlayerNameEx(userid));

	if(!strcmp(tpp, "rend�rtp", true))
	{
		SetPVarInt(userid, "RendorTP", cash);
		SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: �t�ll�tottad %s Rend�rTP-j�t! Jelenleg %d Rend�rTP-je van!", GetPlayerNameEx(userid), GetPVarInt(userid, "RendorTP"));
    	SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s �t�l�totta a Rend�rTP-det! Jelenleg %d Rend�rTP-d van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "RendorTP"));
	}
	else if(!strcmp(tpp, "bankostp", true))
	{
		SetPVarInt(userid, "bankosTP", cash);
		SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: �t�ll�tottad %s BankosTP-j�t! Jelenleg %d BankosTP-je van!", GetPlayerNameEx(userid), GetPVarInt(userid, "BankosTP"));
    	SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s �t�l�totta a BankosTP-det! Jelenleg %d BankosTP-d van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "BankosTP"));
	}
	else if(!strcmp(tpp, "katonatp", true))
	{
		SetPVarInt(userid, "KatonaTP", cash);
		SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: �t�ll�tottad %s KatonaTP-j�t! Jelenleg %d KatonaTP-je van!", GetPlayerNameEx(userid), GetPVarInt(userid, "KatonaTP"));
    	SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s �t�l�totta a KatonaTP-det! Jelenleg %d KatonaTP-d van!", GetPlayerNameEx(playerid), GetPVarInt(userid, "KatonaTP"));
	}
	return 1;
}

CMD:changepass(playerid, params[])
{
	new username[24], pass[512];
	if(sscanf(params, "s[24]s[512]", username, pass)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /changepass [j�t�kosn�v] [�j jelsz�]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ezt a parancsot csak egy F� Adminisztr�tor haszn�lhatja. Ha jelsz�t szeretn�l v�ltani �rj nekik");
    SendAdminCMDMessage(playerid, "CHANGEPASS", username);
    
    new Hash[145];
	WP_Hash(Hash, sizeof(Hash), pass);
	format(query, sizeof(query), "UPDATE users SET Password = '%s' WHERE Name = '%s'", Hash, username);
	mysql_query(query);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Ha volt %s az adatb�zisban akkor sikeresen �t�ll�tottad jelszav�t!", username);
    return 1;
}
//-----------------------------------Helyv�ltoztat�s---------------------------------
/*CMD:kill(playerid, params[])
{
	if(GetPVarInt(playerid, "JailTimerPLAYER") > 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: B�rt�nben nem haszn�lhatod ezt a parancsot!");
	SetPlayerHealth(playerid, 0);
	return 1;
}*/

/*CMD:afk(playerid, params[])
{
	if(GetPVarInt(playerid, "Cuffed") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Bilincsben nem haszn�lhatod ezt a parancsot!");
	SendFormatMessageToAll(YELLOW, "*** %s aktiv�lta az AFK m�dot!", GetPlayerNameEx(playerid));
	SendClientMessage(playerid, YELLOW, "�tlett�l rakva AFK m�dba, a visszat�r�shez: /back");
	TogglePlayerControllable(playerid, false);
	SetPlayerVirtualWorld(playerid, 1);
	return 1;
}

CMD:back(playerid, params[])
{
	if(GetPVarInt(playerid, "Cuffed") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Bilincsben nem haszn�lhatod ezt a parancsot!");
	SendFormatMessageToAll(YELLOW, "*** %s kikapcsolta az AFK m�dot!", GetPlayerNameEx(playerid));
	SendClientMessage(playerid, YELLOW, "Kilett�l szedve az AFK m�db�l!");
	TogglePlayerControllable(playerid, true);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}*/

CMD:goto(playerid, params[])
{
	new userid;
	if(GetPVarInt(playerid, "AJtime") > 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ajailban nem!");
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /goto [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(IsPlayerUnallowedZone(userid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Az illet� olyan helyen vagy �llapotban van, ahol nem haszn�lhatod ezt a parancsot rajta!");
    if(IsPlayerUnallowedZone(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Olyan helyen vagy �llapotban vagy, ahol nem haszn�lhatod ezt a parancsot!");
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

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Odateleport�lt�l %s mell�!", GetPlayerNameEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s odateleport�lt mell�d!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:enablejump(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new enab, pd;
	if(sscanf(params, "ui", pd, enab)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /enablejump [pid] [0-1]");
	SetPVarInt(pd, "enablej", enab);
	return 1;
}

CMD:posx(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz;
	if(sscanf(params, "i", pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /posx [mennyis�g]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x+pozz, y, z);
	return 1;
}

CMD:posy(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz;
	if(sscanf(params, "i", pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /posy [mennyis�g]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y+pozz, z);
	return 1;
}

CMD:posz(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz;
	if(sscanf(params, "i", pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /posz [mennyis�g]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z+pozz);
	return 1;
}

CMD:posxp(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz, up;
	if(sscanf(params, "ui", up, pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /posx [pid] [mennyis�g]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(up, x, y, z);
	SetPlayerPos(up, x+pozz, y, z);
	return 1;
}

/*CMD:posyp(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz, up;
	if(sscanf(params, "ui", pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /posy [pid] [mennyis�g]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(up, x, y, z);
	SetPlayerPos(up, x, y+pozz, z);
	return 1;
}

CMD:poszp(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	new pozz, up;
	if(sscanf(params, "ui", up, pozz)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /posz [pid] [mennyis�g]");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(up, x, y, z);
	SetPlayerPos(up, x, y, z+pozz);
	return 1;
}*/

CMD:get(playerid, params[])
{
	new userid;
	if(GetPVarInt(playerid, "AJtime") > 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ajailban nem!");
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /get [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    if(IsPlayerUnallowedZone(userid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Az illet� olyan helyen vagy �llapotban van, ahol nem haszn�lhatod ezt a parancsot rajta!");
    if(IsPlayerUnallowedZone(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Olyan helyen vagy �llapotban vagy, ahol nem haszn�lhatod ezt a parancsot!");
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

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Magadhoz teleport�ltad %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s odateleport�lt t�ged mag�hoz!", GetPlayerNameEx(playerid));
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
	SendFormatMessageToAll(COLOR_YELLOW, "%s Adminisztr�tor mag�hoz teleport�lt mindenkit!", GetPlayerNameEx(playerid));
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

	SendClientMessageToAll(COLOR_GREEN,"[Auto respawn]* Minden haszn�laton k�v�li j�rm� helyre lett �ll�tva!");
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

	SendClientMessageToAll(COLOR_GREEN,"[Auto respawn]* Minden plat� helyre lett �ll�tva!");
	return 1;
}
//----------------------------�zenetek/Inform�ci�k------------------------------------------
CMD:asay(playerid, params[])
{
	new text[128];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /asay [sz�veg]");
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	SendFormatMessageToAll(COLOR_SAY, "[Admin] %s: %s", GetPlayerNameEx(playerid), text);

	return 1;
}

CMD:vsay(playerid, params[])
{
	new text[128];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /asay [sz�veg]");
	if(GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[6][0]);
	SendFormatMessageToAll(COLOR_SAY, "[VIP] %s: %s", GetPlayerNameEx(playerid), text);

	return 1;
}

CMD:asayy(playerid, params[])
{
	new text[128];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /fasay [sz�veg]");
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	SendFormatMessageToAll(COLOR_SAY, "[Admin]: %s", text);

	return 1;
}

CMD:fasay(playerid, params[])
{
	new text[128];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /fasay [sz�veg]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendFormatMessageToAll(COLOR_SAY, "[F�Admin] %s: %s", GetPlayerNameEx(playerid), text);

	return 1;
}

CMD:googlesay(playerid, params[])
{
	new text[128], command[20];
	new string[200];
	if(sscanf(params, "s[20]s[128]", command, text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /hsay [angol/magyar] [sz�veg]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(!strcmp(GetPlayerNameEx(playerid), "Austin")) return SendClientMessage(playerid, COLOR_ERROR, "Austin! Te mit k�pzelsz hogy ilyeneket �rogatsz a j�t�kosoknak??"), SendClientMessage(playerid, COLOR_ERROR, "Mi az hogy valaki megk�ri hogy hagyd abba, azt�n len�zel r�, mert nem tud semmit se tenni..."), SendClientMessage(playerid, COLOR_ERROR, "�r�m�dre megszabad�talak ett�l a parancs�l, �s a 4-es adminodt�l."), SetPVarInt(playerid, "Level", 3);
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
	if(GetPVarInt(playerid, "lottozott") == 1) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Te m�r lott�zt�l!");
	if(GetPlayerMoneyEx(playerid) < 15000) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Nincs el�g p�nzed! A lott� 15.000$!");
	if(sscanf(params, "iiiii", szamok[0], szamok[1], szamok[2], szamok[3], szamok[4])) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /lotto [sz�m1] [sz�m2] [sz�m3] [sz�m4] [sz�m5]");
    if(1 > szamok[0] || szamok[0] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A sz�moknak 1 �s 99 k�zt kell lenni�k!");
    if(1 > szamok[1] || szamok[1] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A sz�moknak 1 �s 99 k�zt kell lenni�k!");
    if(1 > szamok[2] || szamok[2] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A sz�moknak 1 �s 99 k�zt kell lenni�k!");
    if(1 > szamok[3] || szamok[3] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A sz�moknak 1 �s 99 k�zt kell lenni�k!");
    if(1 > szamok[4] || szamok[4] > 99) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: A sz�moknak 1 �s 99 k�zt kell lenni�k!");
    if(szamok[0] == szamok[1] || szamok[0] == szamok[2] || szamok[0] == szamok[3] || szamok[0] == szamok[4]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy sz�mot csak egyszer �rhatsz!");
    if(szamok[1] == szamok[0] || szamok[1] == szamok[2] || szamok[1] == szamok[3] || szamok[1] == szamok[4]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy sz�mot csak egyszer �rhatsz!");
    if(szamok[2] == szamok[0] || szamok[2] == szamok[1] || szamok[2] == szamok[3] || szamok[2] == szamok[4]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy sz�mot csak egyszer �rhatsz!");
    if(szamok[3] == szamok[0] || szamok[3] == szamok[1] || szamok[3] == szamok[2] || szamok[3] == szamok[4]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy sz�mot csak egyszer �rhatsz!");
    if(szamok[4] == szamok[0] || szamok[4] == szamok[1] || szamok[4] == szamok[2] || szamok[4] == szamok[3]) return SendClientMessage(playerid, COLOR_ERROR, "HIBA: Egy sz�mot csak egyszer �rhatsz!");
	lszamok[0][playerid] = szamok[0];
	lszamok[1][playerid] = szamok[1];
	lszamok[2][playerid] = szamok[2];
	lszamok[3][playerid] = szamok[3];
	lszamok[4][playerid] = szamok[4];
	SendFormatMessage(playerid, COLOR_GREEN, #HLIME#"Lott�z�s sikeres. Sz�mok:"#HYELLOW#" %d, %d, %d, %d, %d", szamok[0], szamok[1], szamok[2], szamok[3], szamok[4]);
	SetPVarInt(playerid, "lottozott", 1);
	GivePlayerMoneyEx(playerid, -15000);
	return 1;
}

CMD:ad(playerid, params[])
{
	new text[200];
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /ad [sz�veg]");
    if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem �rhatsz a chatbe ha levagy n�m�tva!");
	    WarnReason(playerid, "Besz�d n�m�t�s alatt", "SYSTEM");
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
			KickReason(playerid, "Hirdet�s", "SYSTEM");
			return 1;
		}
	}

	SendFormatMessageToAll(DEEPBLUE, "[HIRDET�S] %s! Felad�: %s, /pm %d", text, GetPlayerNameEx(playerid), playerid);
	
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
	if(sscanf(params, "s[128]", me)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /me [sz�veg]");
    if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem �rhatsz a chatbe ha levagy n�m�tva!");
	    WarnReason(playerid, "Besz�d n�m�t�s alatt", "SYSTEM");
	    return 0;
	}
	SendFormatMessageToAll(0xf54fdcAA, "%s %s", GetPlayerNameEx(playerid), me);
	return 1;
}

CMD:announce(playerid, params[])
{
	new text[128];
	if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /announce [sz�veg]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    SendAdminCMDMessage(playerid, "ANNOUNCE");

	GameTextForAll(FixGameString(text), 5*1000, 4);
	SendFormatMessageToAll(COLOR_ASAY, "%s k�perny� �zenete: %s", GetPlayerNameEx(playerid), text);

    return 1;
}

CMD:clearchat(playerid, params[])
{
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    SendAdminCMDMessage(playerid, "CLEARCHAT");

	for(new i; i < 60; i++) SendClientMessageToAll(WHITE, "");
	for(new i; i < MAX_PLAYERS; i++) PlaySound(i, 1057);
	GameTextForAll(FixGameString("~r~Chat megtiszt�tva!"), 4000, 4);

    return 1;
}

CMD:pmshow(playerid)
{
	if(GetPVarInt(playerid, "Logged") == 0) return 1;
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(GetPVarInt(playerid, "pmshow") == 0)
	{
	    SetPVarInt(playerid, "pmshow", 1);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostm�r l�tod mindenki PM-�t!");
	    SendAdminCMDMessage(playerid, "PMSHOW ON");
	}
	else if(GetPVarInt(playerid, "pmshow") == 1)
	{
 		SetPVarInt(playerid, "pmshow", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostm�r nem l�tod m�s PM-�t, csak a saj�tjaidat!");
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
	    SendClientMessage(playerid, COLOR_GREEN, "Mostm�r l�tod a teamchat-et!");
	    SendAdminCMDMessage(playerid, "TSHOW ON");
	}
	else if(GetPVarInt(playerid, "tshow") == 1)
	{
 		SetPVarInt(playerid, "tshow", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostm�r nem l�tod m�s teamchat-j�t!");
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
	    SendClientMessage(playerid, COLOR_GREEN, "Mostm�r l�tod mindenki PM-�t!");
	}
	else if(GetPVarInt(playerid, "pmshow") == 1)
	{
 		SetPVarInt(playerid, "pmshow", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostm�r nem l�tod m�s PM-�t, csak a saj�tjaidat!");
	}
	return 1;
}

CMD:hiddedtshow(playerid)
{
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(GetPVarInt(playerid, "tshow") == 0)
	{
	    SetPVarInt(playerid, "tshow", 1);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostm�r l�tod a teamchat-et!");
	}
	else if(GetPVarInt(playerid, "tshow") == 1)
	{
 		SetPVarInt(playerid, "tshow", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostm�r nem l�tod m�s teamchat-j�t!");
	}
	return 1;
}

CMD:pm(playerid, params[])
{
	new userid,message[128];
	if(sscanf(params, "us[128]",userid,message)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /pm [playerid/j�t�kosid] [sz�veg]");
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
	if(playerid==userid) return SendClientMessage(playerid, COLOR_ERROR, Errors[1][0]);
	if(GetPVarInt(userid, "pmtilt") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ez a j�t�kos letiltotta a PM fogad�st!");
	if(strlen(message) > 128) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: A PM sz�vege t�l hossz�!");
	if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem �rhatsz a chatbe ha levagy n�m�tva!");
	    WarnReason(playerid, "Besz�d n�m�t�s alatt", "SYSTEM");
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
			KickReason(playerid, "Hirdet�s", "SYSTEM");
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
	                SendFormatMessage(i, COLOR_PMSHOW, "[ PM ] %s(%d)-t�l %s(%d)-nek: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(userid), userid, message);
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
	printf("PM: %s-t�l, %s-nek: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(userid), message);
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
	if(sscanf(params, "s[128]",message)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /r [sz�veg]");
	if(LastPM[playerid]==255) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: M�g senki nem k�ld�tt neked PM-et");
    if(!IsPlayerValid(LastPM[playerid])) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
   	if(GetPVarInt(LastPM[playerid], "pmtilt") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ez a j�t�kos letiltotta a PM fogad�st!");
    if(GetPVarInt(playerid, "Mute") == 1)
	{
	    SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem �rhatsz a chatbe ha levagy n�m�tva!");
	    WarnReason(playerid, "Besz�d n�m�t�s alatt", "SYSTEM");
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
			KickReason(playerid, "Hirdet�s", "SYSTEM");
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
	                SendFormatMessage(i, COLOR_PMSHOW, "[ PM ] %s(%d)-t�l %s(%d)-nek: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(LastPM[playerid]), LastPM[playerid], message);
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

	printf("PM: %s-t�l, %s-nek: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(LastPM[playerid]), message);
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
	    SendClientMessage(playerid, COLOR_GREEN, "Mostant�l nem tud PM-et k�ldeni neked senki!");
	}
	else if(GetPVarInt(playerid, "pmtilt") == 1)
	{
	    SetPVarInt(playerid, "pmtilt", 0);
	    SendClientMessage(playerid, COLOR_GREEN, "Mostant�l megint tudnak neked PM-et k�ldeni!");
	}
	return 1;
}

CMD:vote(playerid, params[])
{
	new szavazas1[128];
	if(sscanf(params, "s[128]", szavazas1)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /vote [igennel vagy nemmel megv�laszolhat� k�rd�s]");
	if(GetGVarInt("VoteRunning") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: M�r folyamatban van egy szavaz�s!");
	if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);

	SetGVarInt("VoteRunning", 1);
	SetTimer("VoteTimer", 1*60*1000, false);
	SetGVarString("VoteKerdes", szavazas1);

	SendFormatMessageToAll(COLOR_ADMINMSG, "[ Szavazas ]: %s elind�tott egy szavaz�st: %s!", GetPlayerNameEx(playerid), szavazas1);
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /igen /nem parancsokkal tudsz!");
	return 1;
}

CMD:igen(playerid, params[])
{
	new string[200];
	if(GetGVarInt("VoteRunning") == 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs folyamatban szavaz�s!");
	if(GetPVarInt(playerid, "IsPlayerVoted") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Te m�r szavazt�l!");

	SetGVarInt("VoteIgen", GetGVarInt("VoteIgen")+1);
	SetPVarInt(playerid, "IsPlayerVoted", 1);

	new szavazas1[128];
	GetGVarString("VoteKerdes", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "[ Szavaz�s ]: %s!", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "A szavaz�s jelenlegi �ll�sa: %d igen �s %d nem.", GetGVarInt("VoteIgen"), GetGVarInt("VoteNem"));
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /igen /nem parancsokkal tudsz!");
	format(string, sizeof(string), "[ Szavaz�s ]: %s igennel szavazott!", GetPlayerNameEx(playerid));
	SendClientMessageToAdmins(COLOR_ADMINMSG, string);

	return 1;
}

CMD:nem(playerid, params[])
{
	new string[200];
	if(GetGVarInt("VoteRunning") == 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs folyamatban szavaz�s!");
	if(GetPVarInt(playerid, "IsPlayerVoted") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Te m�r szavazt�l!");

	SetGVarInt("VoteNem", GetGVarInt("VoteNem")+1);
	SetPVarInt(playerid, "IsPlayerVoted", 1);

	new szavazas1[128];
	GetGVarString("VoteKerdes", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "[ Szavaz�s ]: %s!", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "A szavaz�s jelenlegi �ll�sa: %d igen �s %d nem.", GetGVarInt("VoteIgen"), GetGVarInt("VoteNem"));
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /igen /nem parancsokkal tudsz!");
	format(string, sizeof(string), "[ Szavaz�s ]: %s nemmel szavazott!", GetPlayerNameEx(playerid));
	SendClientMessageToAdmins(COLOR_ADMINMSG, string);
	return 1;
}

CMD:zigen(playerid, params[])
{
	new string[200];
	if(GetGVarInt("ZeneVoteRunning") == 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs folyamatban zene szavaz�s!");
	if(GetPVarInt(playerid, "IsPlayerZeneVoted") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Te m�r szavazt�l!");

	SetGVarInt("zeneigen", GetGVarInt("zeneigen")+1);
	SetPVarInt(playerid, "IsPlayerZeneVoted", 1);
	SetPVarInt(playerid, "zenekell", 1);

	SendFormatMessageToAll(COLOR_ADMINMSG, "A zene szavaz�s jelenlegi �ll�sa: %d igen �s %d nem.", GetGVarInt("zeneigen"), GetGVarInt("zenenem"));
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /zigen /znem parancsokkal tudsz!");
	format(string, sizeof(string), "[ Szavaz�s ]: %s igennel szavazott!", GetPlayerNameEx(playerid));
	SendClientMessageToAdmins(COLOR_ADMINMSG, string);

	return 1;
}

CMD:znem(playerid, params[])
{
	new string[200];
	if(GetGVarInt("ZeneVoteRunning") == 0) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nincs folyamatban zene szavaz�s!");
	if(GetPVarInt(playerid, "IsPlayerZeneVoted") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Te m�r szavazt�l!");

	SetGVarInt("zenenem", GetGVarInt("zenenem")+1);
	SetPVarInt(playerid, "IsPlayerZeneVoted", 1);
	SetPVarInt(playerid, "zenekell", 2);

	SendFormatMessageToAll(COLOR_ADMINMSG, "A zene szavaz�s jelenlegi �ll�sa: %d igen �s %d nem.", GetGVarInt("zeneigen"), GetGVarInt("zenenem"));
	SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni az /zigen /znem parancsokkal tudsz!");
	format(string, sizeof(string), "[ Szavaz�s ]: %s nemmel szavazott!", GetPlayerNameEx(playerid));
	SendClientMessageToAdmins(COLOR_ADMINMSG, string);
	return 1;
}

forward VoteTimer();
public VoteTimer()
{
	new szavazas1[128];
	GetGVarString("VoteKerdes", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "A '%s' k�rd�sel ind�tott szavaz�s befejez�d�tt!", szavazas1);
	SendFormatMessageToAll(COLOR_ADMINMSG, "A szavaz�s eredm�nye: %d igen �s %d nem.", GetGVarInt("VoteIgen"), GetGVarInt("VoteNem"));
	SetGVarInt("VoteRunning", 0);
	SetGVarInt("VoteIgen", 0);
	SetGVarInt("VoteNem", 0);

	for(new i; i < MAX_PLAYERS; i++) SetPVarInt(i, "IsPlayerVoted", 0);
	return 1;
}

forward ZeneVote();
public ZeneVote()
{
	SendClientMessageToAll(COLOR_ADMINMSG, "A zene szavaz�s befejez�d�tt!");
	SendFormatMessageToAll(COLOR_ADMINMSG, "A szavaz�s eredm�nye: %d igen �s %d nem.", GetGVarInt("zeneigen"), GetGVarInt("zenenem"));
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
	SendClientMessage(playerid, COLOR_GREEN, "A zene felker�lt a list�ra.");
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
	SendClientMessage(playerid, COLOR_GREEN, "A zene nem felker�lt a list�ra.");
	SetPVarInt(playerid, "zenetbiral", 0);
	new link[250], nev[100];
    GetPVarString(playerid, "birallink", link, sizeof(link));
    GetPVarString(playerid, "biralnev", nev, sizeof(nev));
    format(query, sizeof(query), "DELETE FROM zenelistav WHERE Nev = '%s' AND Link = '%s'", nev, link);
    mysql_query(query);
	return 1;
}
//----------------------------------Cs�terfel�gyelet----------------------------------
CMD:slap(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /slap [playerid/j�t�kosn�v]");
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
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s feldobott t�ged!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:setskin(playerid, params[])
{
	new userid, skinid;
	if(sscanf(params, "ui", userid, skinid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /setskin [playerid/j�t�kosn�v] [skinid]");
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
	if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
	SendAdminCMDMessage(playerid, "SETSKIN", GetPlayerNameEx(userid));

	SetPlayerSkin(userid, skinid);
	SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen megv�ltoztattad %s skinj�t [�j skin: %d]", GetPlayerNameEx(userid), skinid);
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s megv�ltoztatta a skined [�j skin: %d]", GetPlayerNameEx(playerid), skinid);
	return 1;
}

CMD:disarm(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /disarm [playerid/j�t�kosn�v]");
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
	if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
	SendAdminCMDMessage(playerid, "DISARM", GetPlayerNameEx(userid));

	SetPlayerArmour(userid, 0);
	ResetPlayerWeapons(userid);
    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen lefegyverezted %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s lefegyverzett t�ged!", GetPlayerNameEx(playerid));
	return 1;
}

CMD:mute(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /mute [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "MUTE", GetPlayerNameEx(userid));

	SetPVarInt(userid, "Mute", 1);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen len�m�tottad %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s len�m�tott t�ged!", GetPlayerNameEx(playerid));
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

    SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s mindenkit len�m�tott!", GetPlayerNameEx(playerid));
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

    SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s feloldotta mindenki n�m�t�s�t!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:unmute(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /unmute [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == userid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "UNMUTE", GetPlayerNameEx(userid));

	SetPVarInt(userid, "Mute", 0);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen feloldottad %s n�m�t�s�t!", GetPlayerNameEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s feloldotta a n�m�t�sodat!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:antiakill(playerid, params[])
{
    new userid, aaa;
	if(sscanf(params, "ui", userid, aaa)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /antiakill [playerid/j�t�kosn�v] [sz�m]");
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);

	SetPVarInt(userid, "aakill", aaa);
	return 1;
}

CMD:antislap(playerid, params[])
{
    new userid, aaa;
	if(sscanf(params, "ui", userid, aaa)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /antoslap [playerid/j�t�kosn�v] [sz�m]");
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);

	SetPVarInt(userid, "aslap", aaa);
	return 1;
}

CMD:akill(playerid, params[])
{
	new userid;
	if(GetPVarInt(playerid, "AJtime") > 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ajailban nem!");
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /akill [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "AKILL", GetPlayerNameEx(userid));

	if(GetPVarInt(userid, "aakill") != 1) SetPlayerHealth(userid, 0);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen meg�lted %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s meg�lt t�ged!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:freeze(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /freeze [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "FREEZE", GetPlayerNameEx(userid));

	TogglePlayerControllable(userid,0);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen lefagyasztottad %s!", rag(GetPlayerNameEx(userid), 3));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s lefagyasztott t�ged!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:unfreeze(playerid, params[])
{
	new userid;
	if(sscanf(params, "u", userid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /unfreeze [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(userid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(GetPVarInt(playerid, "Level") < GetPVarInt(userid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
    SendAdminCMDMessage(playerid, "UNFREEZE", GetPlayerNameEx(userid));

	TogglePlayerControllable(userid,1);

    SendFormatMessage(playerid, COLOR_ADMINMSG, "[ ADMIN ]: Sikeresen feloldottad %s fagyaszt�s�t!", GetPlayerNameEx(userid));
    SendFormatMessage(userid, COLOR_ADMINMSG, "[ ADMIN ]: %s feloldotta a fagyaszt�sodat!", GetPlayerNameEx(playerid));
    return 1;
}

CMD:spectateteszt(playerid, params[])
{
    new specplayerid;
	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /spectate [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(specplayerid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == specplayerid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A j�t�kos nincs spawnolva!");
    SendAdminCMDMessage(playerid, "SPECTATE", GetPlayerNameEx(specplayerid));

    TogglePlayerSpectating(playerid, 1);
	PlayerSpectatePlayer(playerid, specplayerid, SPECTATE_MODE_SIDE);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdt�l spect�lni!");
	return 1;
}

CMD:spectateteszt2(playerid, params[])
{
    new specplayerid;
	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /spectate [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(specplayerid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == specplayerid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A j�t�kos nincs spawnolva!");
    SendAdminCMDMessage(playerid, "SPECTATE", GetPlayerNameEx(specplayerid));

    TogglePlayerSpectating(playerid, 1);
	PlayerSpectatePlayer(playerid, specplayerid, SPECTATE_MODE_FIXED);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdt�l spect�lni!");
	return 1;
}

CMD:spectate(playerid, params[])
{
	#if defined ENABLE_SPECTATE
	new specplayerid;
	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /spectate [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(specplayerid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == specplayerid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A j�t�kos nincs spawnolva!");
    SendAdminCMDMessage(playerid, "SPECTATE", GetPlayerNameEx(specplayerid));

	StartSpectate(playerid, specplayerid);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdt�l spect�lni!");
	return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spect�l�s le van tiltva! �rj egy F� Adminisztr�tornak.");
	return 1;
    #endif
}

CMD:silencedspectate(playerid, params[])
{
	#if defined ENABLE_SPECTATE
	new specplayerid;
	if(sscanf(params, "u", specplayerid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /spectate [playerid/j�t�kosn�v]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
    if(!IsPlayerValid(specplayerid)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
    if(playerid == specplayerid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(GetPlayerState(specplayerid) != 1 && GetPlayerState(specplayerid) != 2 && GetPlayerState(specplayerid) != 3) return SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A j�t�kos nincs spawnolva!");

	StartSpectate(playerid, specplayerid);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdt�l spect�lni!");
	return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spect�l�s le van tiltva! �rj egy F� Adminisztr�tornak.");
	return 1;
    #endif
}

CMD:spectateveh(playerid, params[])
{
	#if defined ENABLE_SPECTATE
	new specvehicleid;
	if(sscanf(params, "u", specvehicleid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /spectateveh [j�rm�id]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
//	if(specvehicleid >= MAX_VEHICLES) return SendClientMessage(playerid,COLOR_ERROR, "[HIBA]: �rv�nytelen j�rm� ID!");
	SendAdminCMDMessage(playerid, "SPECTATEVEH");

	TogglePlayerSpectating(playerid, 1);
	PlayerSpectateVehicle(playerid, specvehicleid);
	Spec[playerid][SpectateID] = specvehicleid;
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen elkezdt�l spect�lni!");
	Spec[playerid][SpectateType] = ADMIN_SPEC_TYPE_VEHICLE;
	return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spect�l�s le van tiltva! �rj egy F� Adminisztr�tornak.");
	return 1;
    #endif
}

CMD:spectateoff(playerid, params[])
{
	#if defined ENABLE_SPECTATE
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(Spec[playerid][SpectateType] == ADMIN_SPEC_TYPE_NONE) return SendClientMessage(playerid,COLOR_ERROR, "[HIBA]: Eddig sem spect�lt�l senkit!");
    SendAdminCMDMessage(playerid, "SPECTATEOFF");

	StopSpectate(playerid);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen abbahagytad a spect�l�st!");
    return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spect�l�s le van tiltva! �rj egy F� Adminisztr�tornak.");
	return 1;
    #endif
}

CMD:silencedspectateoff(playerid, params[])
{
	#if defined ENABLE_SPECTATE
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid) && GetPVarInt(playerid, "VIP") != 1) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(Spec[playerid][SpectateType] == ADMIN_SPEC_TYPE_NONE) return SendClientMessage(playerid,COLOR_ERROR, "[HIBA]: Eddig sem spect�lt�l senkit!");

	StopSpectate(playerid);
	SendClientMessage(playerid,COLOR_ADMINMSG,"[ ADMIN ]: Sikeresen abbahagytad a spect�l�st!");
    return 1;

	#else
	SendClientMessage(playerid, COLOR_ERROR, "[HIBA]: A spect�l�s le van tiltva! �rj egy F� Adminisztr�tornak.");
	return 1;
    #endif
}

CMD:report(playerid, params[])
{
    new message[128], reason, id;
    if(sscanf(params, "is[128]", id, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /report [ID] [panasz]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_ERROR, Errors[0][0]);
 	format(message, sizeof(message), "[ REPORT ]: %s (%d) Panasza %s(%d)-re: %s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(id), id, reason);
	SendClientMessageToAdmins(COLOR_REPORT, message);

	SendClientMessage(playerid, COLOR_REPORT, "[ REPORT ]: Panaszod elk�ldve az adminoknak!");
	return 1;
}

CMD:maxping(playerid, params[])
{
	new maxping;
	if(sscanf(params, "i", maxping)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /maxping [Maxim�lis Ping]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	SetGVarInt("MaxPing", maxping);

	SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s megv�ltoztatta a maxim�lis ping �rt�k�t! [ �j �rt�k: %d ]", GetPlayerNameEx(playerid), GetGVarInt("MaxPing"));
	return 1;
}

CMD:warn(playerid, params[])
{
    new warnedid, reason[128];
    if(sscanf(params, "us[128]", warnedid, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /warn [playerid/j�t�kosn�v] [indok]");
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
    if(sscanf(params, "us[128]", kickedid, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /kick [playerid/j�t�kosn�v] [indok]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
	if(!IsPlayerValid(kickedid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
	if(playerid == kickedid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
    if(!strcmp(GetPlayerNameEx(kickedid), "Ryuuzaki")) return SendClientMessage(playerid, COLOR_ERROR, "Pr�b�lkozunk?");
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
	    if(sscanf(params, "us[128]", kickedid, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /votekick [playerid/j�t�kosn�v] [indok]");
        if(GetPVarInt(playerid, "Level") < 1 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "Csak Adminok ind�thatnak votekick szavaz�st!");
		if(!IsPlayerValid(kickedid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
		if(playerid == kickedid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
		if(GetPVarInt(playerid, "Level") < GetPVarInt(kickedid, "Level") && !IsPlayerAdminEx(playerid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);

		SetPVarInt(playerid, "VotedToKick", 1);

		SetPVarInt(kickedid, "KickVotes", 1);
		SetGVarInt("VoteKickStarted", 1);
		SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: Egy kir�g�si szavaz�s indult %s ellen! [ Indok: %s ]", GetPlayerNameEx(kickedid), reason);
		SendClientMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: Ahoz hogy szavazz �rd be a /votekick parancsot!");
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
	  		        SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: �jabb szavazat �rkezett %s ellen! [ Szavazatok: %d/%d ]", GetPlayerNameEx(i), GetPVarInt(i, "KickVotes"), VOTEKICK_VOTES);

					if(GetPVarInt(i, "KickVotes") == VOTEKICK_VOTES)
					{
					    SetGVarInt("VoteKickStarted", 0);
					    KickReason(i, "Sikeres kiszavaz�s", "SYSTEM");

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
    if(sscanf(params, "s[24]",playername)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /passwordban [j�t�kosn�v]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(!strcmp(playername, "Ryuuzaki")) return SendClientMessage(playerid, COLOR_ERROR, "Pr�b�lkozunk?");
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
		else SendClientMessage(playerid, COLOR_RED, "Ilyen jelsz� m�r banolva van!");
	}
	else SendClientMessage(playerid, COLOR_RED, "Ilyen n�v nem tal�lhat� az adatb�zisban!");
    return 1;
}

CMD:ban(playerid, params[])
{
    new bannedid, reason[200];
    if(sscanf(params, "us[128]", bannedid, reason)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /ban [playerid/j�t�kosn�v] [indok]");
	if(GetPVarInt(playerid, "Level") < 3 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
	if(!IsPlayerValid(bannedid)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
	if(playerid == bannedid) return SendClientMessage( playerid, COLOR_ERROR, Errors[1][0]);
	if(!strcmp(GetPlayerNameEx(bannedid), "Ryuuzaki")) return SendClientMessage(playerid, COLOR_ERROR, "Pr�b�lkozunk?");
	if(GetPVarInt(playerid, "Level") < GetPVarInt(bannedid, "Level")) return SendClientMessage( playerid, COLOR_ERROR, Errors[2][0]);
	SendAdminCMDMessage(playerid, "BAN", GetPlayerNameEx(bannedid));
	BanReason(bannedid, reason, GetPlayerNameEx(playerid));
    return 1;
}


CMD:repair(playerid, params[])
{
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "Nem vagy j�rm�ben!");
	SendAdminCMDMessage(playerid, "REPAIR");
	RepairVehicle(GetPlayerVehicleID(playerid));
    return 1;
}

//------------------------Mod, filterscript kezel�s---------------------------------
/*CMD:loadfs(playerid, params[])
{
    new scriptname[64], command[128];
    if(sscanf(params, "s[64]", scriptname)) return SendClientMessage(playerid,COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /loadfs [scriptn�v]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendAdminCMDMessage(playerid, "LOADFS");
	format(command, sizeof(command), "loadfs %s", scriptname);
	SendRconCommand(command);
    return 1;
}

CMD:unloadfs(playerid, params[])
{
    new scriptname[64], command[128];
    if(sscanf(params, "s[64]", scriptname)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /unloadfs [scriptn�v]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendAdminCMDMessage(playerid, "UNLOADFS");
	format(command, sizeof(command), "unloadfs %s", scriptname);
	SendRconCommand(command);
    return 1;
}

CMD:reloadfs(playerid, params[])
{
    new scriptname[64], command[128];
    if(sscanf(params, "s[64]", scriptname)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /reloadfs [scriptn�v]");
	if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	SendAdminCMDMessage(playerid, "RELOADFS");
	format(command, sizeof(command), "reloadfs %s", scriptname);
	SendRconCommand(command);
    return 1;
}

CMD:changemode(playerid, params[])
{
    new scriptname[64], command[128];
    if(sscanf(params, "s[64]", scriptname)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /changemode [modn�v]");
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
	SendClientMessageToAll(COLOR_GREEN, "J�t�kos adatok elmentve!");
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
	SendFormatMessageToAll(COLOR_YELLOW, "%s Adminisztr�tor felt�lt�tte mindenki �let�t!", GetPlayerNameEx(playerid));
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
	SendFormatMessageToAll(COLOR_YELLOW, "%s Adminisztr�tor felt�lt�tte mindenki p�nc�lj�t!", GetPlayerNameEx(playerid));
	SendAdminCMDMessage(playerid, "ARMOURALL");
	return 1;
}

CMD:aheal(playerid, params[])
{
	new id;
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /aheal [id/n�vr�szlet]");
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
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /aarmour [id/n�vr�szlet]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[3][0]);
    if(!IsPlayerValid(id)) return SendClientMessage( playerid, COLOR_ERROR, Errors[0][0]);
    PlaySound(id, 1057);
    SetPlayerArmour(id, 100);
    SendAdminCMDMessage(playerid, "AARMOUR");
	return 1;
}*/

//------------------------------Id�j�r�s, id�---------------------------------
CMD:weather(playerid, params[])// /weather [weatherid]
{
    new weatherid;
    if(sscanf(params, "i", weatherid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /weather [id�j�r�s id]");
    if(GetPVarInt(playerid, "Level") < 2 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[2][0]);
 	SendAdminCMDMessage(playerid, "WEATHER");
	SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s megv�ltoztatta az id�j�r�st! Az �j id�j�r�s ID-je: %d", GetPlayerNameEx(playerid), weatherid);
	SetWeather(weatherid);
    return 1;
}

CMD:time(playerid, params[])// /time [hour]
{
    new time;
    if(sscanf(params, "i", time)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /time [�ra]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[5][0]);
    SendAdminCMDMessage(playerid, "TIME");
	SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s megv�ltoztatta az id�t! Az �j id�: %d �ra", GetPlayerNameEx(playerid), time);
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
    if(sscanf(params, "f", gravity)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /gravity [gravity]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    SendAdminCMDMessage(playerid, "GRAVITY");
  	SendFormatMessageToAll(COLOR_ADMINMSG, "[ ADMIN ]: %s megv�ltoztatta az gravit�ci�t! Az �j gravit�ci� �rt�ke: %f ", GetPlayerNameEx(playerid), gravity);
	SetGravity(gravity);
    return 1;
}

CMD:pos(playerid, params[])
{
	new Float:px2, Float:py2, Float:pz2;
	if(GetPVarInt(playerid, "AJtime") > 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Ajailban nem!");
	if(sscanf(params, "fff", px2, py2, pz2)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /pos [x] [y] [z]");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
    SetPlayerPosEx(playerid, px2, py2, pz2);
	return 1;
}

CMD:inti(playerid, params[])
{
	new inti;
 	if(!IsPlayerAdminEx(playerid)) return 0;
	if(sscanf(params, "i", inti)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /inti [inti]");
    SetPlayerInterior(playerid, inti);
	return 1;
}

CMD:vw(playerid, params[])
{
	new vw;
 	if(!IsPlayerAdminEx(playerid)) return 0;
	if(sscanf(params, "i", vw)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /vw [vw]");
    SetPlayerVirtualWorld(playerid, vw);
	return 1;
}

CMD:destroycar(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: Nem vagy j�rm�ben!");
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	DestroyVehicle(GetPlayerVehicleID(playerid));
	return 1;
}

CMD:destroycarwithid(playerid, params[])
{
	new veid;
    if(GetPVarInt(playerid, "Level") < 4 && !IsPlayerAdminEx(playerid)) return SendClientMessage(playerid, COLOR_ERROR, LevelErrors[4][0]);
	if(sscanf(params, "i", veid)) return SendClientMessage(playerid, COLOR_HASZNALATIMOD, "[ HASZN�LAT ]: /destroycarwithid [ID]");
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
			ShowPlayerDialog(playerid, APANEL_DIALOG, DIALOG_STYLE_LIST, "Admin panel", "Event system\nZene szavaz�s\nZen�k\nFeny�fa fel�ll�t�sa\nFeny�fa leszed�se\nZene elfogad�sa\nHavaz�s bekapcsol�sa\nHavaz�s kikapcsol�sa", "V�laszt", "Kil�p");
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
	ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zen�k", "R�di�k\nZen�k list�ja\nKeres�s a list�ban\nZene ind�t�s MP3 linkr�l\nZene bek�ld�se\nZene le�ll�t�sa\nInform�ci�", "Kiv�laszt", "Kil�p");
	return 1;
}

CMD:addzene(playerid, params[])
{
	new nev[40], link[250];
	if(!IsPlayerAdminEx(playerid)) return 0;
	if(sscanf(params, "s[250]s[40]", link, nev)) return SendClientMessage(playerid, COLOR_GREEN, "Haszn�lat: /addzene [link] [n�v]");
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
        if(mysql_num_rows() == 0) ShowPlayerDialog(playerid, REGISTER_DIALOG, DIALOG_STYLE_INPUT , "Regisztr�ci�", "Ez a n�v m�g nincs regisztr�lva!\nK�rlek �rj be egy jelsz�t a regisztr�ci�hoz!\n", "Regisztr�ci�", "Kil�p�s");
        else ShowPlayerDialog(playerid, LOGIN_DIALOG, DIALOG_STYLE_INPUT , "Bejelentkez�s", "Ez a n�v regisztr�lva van!\nK�rlek jelentkezz be!", "Bejelentkez�s", "Kil�p�s");
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
		    if(GetPVarInt(playerid, "aws") == 3) SetPVarInt(playerid, "aws", 1), SendClientMessage(playerid, COLOR_GREEN, "Teleport�l�s");
		    else if(GetPVarInt(playerid, "aws") == 1) SetPVarInt(playerid, "aws", 2), SendClientMessage(playerid, COLOR_GREEN, "Robbant�s");
		    else if(GetPVarInt(playerid, "aws") == 2) SetPVarInt(playerid, "aws", 3), SendClientMessage(playerid, COLOR_GREEN, "Vonz�s");
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
			    format(rconstr, sizeof(rconstr), "%s megpr�b�lt bel�pni az Rcon-ba", GetPlayerNameEx(i));
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
  				ShowPlayerDialog(i, DIALOG_RCONLOGIN, DIALOG_STYLE_PASSWORD, "Te t�nyleg tudod az Rcon-t? hm...", "�s ezt a jelszavat is?", "Ja, tudom", "");
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
				    if(bani == 0) format(egyezestr, sizeof(egyezestr), "%s{00FFFF}%s \t\t{ffffff}[IP c�m: %s]\n", egyezestr, nevs, ips);
					else if(bani == 1) format(egyezestr, sizeof(egyezestr), "%s"#HRED#"%s \t\t{ffffff}[IP c�m: %s]\n", egyezestr, nevs, ips);
				}
				mysql_free_result();
				ShowPlayerDialog(playerid, EGYEZES_DIALOG, DIALOG_STYLE_MSGBOX, "Tal�latok", egyezestr, "Tov�bbi tal�latok", "Kil�p");
			}
			else SendClientMessage(playerid, COLOR_RED, "Nincs tal�lat.");
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

		    format(dstring, sizeof(dstring), #HWHITE#"Els� h�z megv�tele: %s\nEls� j�rm� megv�tele: %s\nEls� biznisz megv�tele: %s\n\
			Els� leaderes munkatags�g: %s\nEls� kl�ntags�g: %s\nEls� kl�n alap�t�sa: %s\n\
			50 hal kifog�sa: %s(%02d/50)\n100 hal kifog�sa: %s(%02d/100)\n\
			50 reakci�teszt megold�sa: %s(%02d/50)\n100 reakci�teszt megold�sa: %s(%02d/100)\n\
			10 j�tszott �ra: %s\n50 j�tszott �ra: %s\n100 j�tszott �ra: %s\n200 j�tszott �ra: %s\n",
			(achies[0]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� h�z
			(achies[1]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� j�rm�
			(achies[2]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� biznisz
			(achies[3]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //ELs� leaderes mel�
			(achies[4]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� kl�ntags�g
			(achies[5]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� kl�n
			(achies[6]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 horg�szat
			(achies[6]) ? (50) : (GetAchievement(playerid, "horgaszat")),
			(achies[7]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 horg�szat
			(achies[7]) ? (100) : (GetAchievement(playerid, "horgaszat")),
			(achies[8]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 reakci�
			(achies[8]) ? (50) : (GetAchievement(playerid, "reakcio")),
			(achies[9]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 reakci�
			(achies[9]) ? (100) : (GetAchievement(playerid, "reakcio")),
            (achies[10]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#),
            (achies[11]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#),
            (achies[12]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#),
            (achies[13]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#));
            
			format(dstring, sizeof(dstring), "%s10 elfoglalt ter�let: %s(%02d/10)\n30 elfoglalt ter�let: %s(%02d/30)\n50 elfoglalt ter�let: %s(%02d/50)\n\
			50 �l�s: %s(%02d/50)\n100 �l�s: %s(%02d/100)\n300 �l�s: %s(%02d/300)\n", dstring,
			(achies[14]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //10 ter�let
			(achies[14]) ? (10) : (GetAchievement(playerid, "area")),
			(achies[15]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //30 ter�let
			(achies[15]) ? (30) : (GetAchievement(playerid, "area")),
			(achies[16]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 ter�let
			(achies[16]) ? (50) : (GetAchievement(playerid, "area")),
			(achies[17]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 �l�s
			(achies[17]) ? (50) : (GetAchievement(playerid, "Kills")),
			(achies[18]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 �l�s
			(achies[18]) ? (100) : (GetAchievement(playerid, "Kills")),
			(achies[19]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //300 �l�s
			(achies[19]) ? (300) : (GetAchievement(playerid, "Kills")));

			ShowPlayerDialog(playerid, MYACHIE_DIALOG, DIALOG_STYLE_MSGBOX, "Achievementek", dstring, "Tov�bb", "Kil�p");
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

		    format(dstring, sizeof(dstring), #HWHITE#"Els� h�z megv�tele: %s\nEls� j�rm� megv�tele: %s\nEls� biznisz megv�tele: %s\n\
			Els� leaderes munkatags�g: %s\nEls� kl�ntags�g: %s\nEls� kl�n alap�t�sa: %s\n\
			50 hal kifog�sa: %s\n100 hal kifog�sa: %s\n\
			50 reakci�teszt megold�sa: %s\n100 reakci�teszt megold�sa: %s\n\
			10 j�tszott �ra: %s\n50 j�tszott �ra: %s\n100 j�tszott �ra: %s\n200 j�tszott �ra: %s\n",
			(achies[0]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� h�z
			(achies[1]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� j�rm�
			(achies[2]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� biznisz
			(achies[3]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //ELs� leaderes mel�
			(achies[4]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� kl�ntags�g
			(achies[5]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //Els� kl�n
			(achies[6]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 horg�szat
			(achies[7]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 horg�szat
			(achies[8]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 reakci�teszt
			(achies[9]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 reakci�teszt
			(achies[10]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#),
            (achies[11]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#),
            (achies[12]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#),
            (achies[13]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#));
            
            format(dstring, sizeof(dstring), "%s10 elfoglalt ter�let: %s\n30 elfoglalt ter�let: %s\n50 elfoglalt ter�let: %s\n\
			50 �l�s: %s\n100 �l�s: %s\n300 �l�s: %s\n", dstring,
			(achies[14]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //10 ter�let
			(achies[15]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //30 ter�let
			(achies[16]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 ter�let
			(achies[17]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //50 �l�s
			(achies[18]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#), //100 �l�s
			(achies[19]) ? (#HGREEN#"Kinyitva"#HWHITE#) : (#HRED#"Lez�rva"#HWHITE#)); //300 �l�s
	    
	        new achst[50];
			format(achst, sizeof(achst), "%s Achievementjei", GetPlayerNameEx(GetPVarInt(playerid, "achcmd")));
			ShowPlayerDialog(playerid, ACHIE_DIALOG, DIALOG_STYLE_MSGBOX, achst, dstring, "Tov�bb", "Kil�p");
	    }
	}
	if(dialogid == DIALOG_JATEK1)
	{
	    if(response)
	    {
			new dialogstr[812];
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
		    "A lev�lben ez �ll:\n",
		    "Aki ezt a levelet megtal�lja a seg�ts�g�re van sz�ks�gem. �n vagyok az aki minden �vben megaj�nd�koz titeket.\n",
		    "Azonban ma rossz dolog t�rt�nt. �ppen mentem a k�vetkez� v�ros fel�, �s t�rt�nt egy kis gubanc a sz�nh�z�immal.\n",
		    "Akkor nem vettem �szre hogy az �sszes aj�nd�komat elejtettem valahol �s a gond hogy nem tudom hol.\n",
		    "Ha igaz�n seg�teni akarsz nekem �s egy kis kincskeres�sre v�gysz akkor tal�lkozzunk azon a helyen ahol a t�lt�nyek vannak...\n",
		    "De nem a polcokon, a f�ld�n. Teh�t gyere el ide �s elmondom szem�lyesen a k�vetkez� l�p�seket.\n\n",
		    "Al��r�s: Egy k�v�r, hossz� szak�las, kedves ember");
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "Lev�l", dialogstr, "Ok�", "");
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
	        
	        format(astr, sizeof(astr), "[H�R!!!] %s megtal�lta az elveszett aj�nd�kokat �s elfogadta a jutalmat!", GetPlayerNameEx(playerid));
			SendClientMessageToAdmins(COLOR_ASAY, astr);
			DeleteChristmasGames();
			for(new i; i < 19; i++) DestroyDynamicObject(ajiobjectek[i]);
			DestroyDynamicObject(ajikapu);
			
			format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
	        "H�t akkor nagyon sok boldog kar�csonyt k�v�nok neked fiam!\n",
	        "Tal�lt�l:\n",
	        "- 4000EXP\n",
	        "- 5.000.000$\n",
	        "- MEGLEPET�S sapka\n",
	        "- L�zer + hozz� fegyverek\n",
	        "- Egy aut� v�r r�d a Ryuuzaki's cars el�tt! (Ha nem lenne ott k�rj carrespawn-t)");
	        ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "�zenet", dialogstr, "Ok�", "");
	    }
	    if(!response)
	    {
	        new astr[128];
	        ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "�zenet", "�rdekes hogy �gy d�nt�tt�l. Mint mondtam nincs vissza. Boldog kar�csonyt!", "Ok�", "");
	        format(astr, sizeof(astr), "[H�R!!!] %s megtal�lta az elveszett aj�nd�kokat de nem fogadta el a jutalmat!", GetPlayerNameEx(playerid));
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
			ShowPlayerDialog(playerid, REGISTER_DIALOG, DIALOG_STYLE_INPUT , "Regisztr�ci�", "Ez a n�v m�g nincs regisztr�lva!\nK�rlek �rj be egy jelsz�t a regisztr�ci�hoz!\n", "Regisztr�ci�", "Kil�p�s");
		}
		if(response)
		{
            if(strlen(inputtext) < 4 || strlen(inputtext) > 20)
            {
                ShowPlayerDialog(playerid, REGISTER_DIALOG, DIALOG_STYLE_INPUT , "Regisztr�ci�", "A jelsz�nak hossz�nak 4 �s 20 karakter k�z�tt kell lennie!", "Regisztr�ci�", "Kil�p�s");
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
			
			SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZN�L� ]: Sikeresen regisztr�lt�l �gy automatikusan bejelentkezt�l!");

			SetPVarInt(playerid, "skillpoints", 1);
			SetPVarInt(playerid, "Logged", 1);
		 	elteltt[playerid] = SetTimerEx("elteltido", 60000, 1, "i", playerid);
            GivePlayerMoneyEx(playerid, 100000);
		}
	}
	else if(dialogid == LOGIN_DIALOG)
	{
		if(!response) ShowPlayerDialog(playerid, LOGIN_DIALOG, DIALOG_STYLE_INPUT , "Bejelentkez�s", "Ez a n�v regisztr�lva van!\nK�rlek jelentkezz be!", "Bejelentkez�s", "Kil�p�s");
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
				if(GetPVarInt(playerid, "WrongPass") == MAX_FAIL_LOGINS) return KickReason(playerid, "Sikertelen bejelentkez�s!", "SYSTEM");
               	format(passtext, sizeof(passtext), "[ FELHASZN�L� ]: A be�rt jelsz� hib�s!\nM�g van %d pr�b�lkoz�si lehet�s�ged!", MAX_FAIL_LOGINS-GetPVarInt(playerid, "WrongPass"));
               	ShowPlayerDialog(playerid, LOGIN_DIALOG, DIALOG_STYLE_INPUT , "Bejelentkez�s", passtext, "Bejelentkez�s", "Kil�p�s");
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
				switch(GetPVarInt(playerid, "Level"))//az adminszintekhez tartoz� megnevez�s v�ltoz�ba �r�sa
				{
				    case 1: SetPVarString(playerid, "AdminRang", "Moder�tor");
					case 2: SetPVarString(playerid, "AdminRang", "Kezd� Adminisztr�tor");
					case 3: SetPVarString(playerid, "AdminRang", "Halad� Adminisztr�tor");
					case 4: SetPVarString(playerid, "AdminRang", "F� Adminisztr�tor");
					case 5: SetPVarString(playerid, "AdminRang", "Any�d");
				}
				SetPVarInt(playerid, "Logged", 1);
				elteltt[playerid] = SetTimerEx("elteltido", 60000, 1, "i", playerid);
				GetPVarString(playerid, "AdminRang", adminpvar, sizeof(adminpvar));
                mysql_free_result();
                if(GetPVarInt(playerid, "Level") == 0) SendClientMessage(playerid, COLOR_REGLOG, "[ FELHASZN�L� ]: Sikeresen bejelentkezt�l!");
				if(GetPVarInt(playerid, "Level") != 0) SendFormatMessage(playerid, COLOR_REGLOG, "[ FELHASZN�L� ]: Sikeresen bejelentkezt�l! [ Rang: %s ]", adminpvar);
				
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
			""#HWHITE#"10.� Egy j�t�kosnak csak is egy biznisze lehet! M�s karakteren sem lehet!"#HRED#"[karakter null�z�s]\n\n");
			ShowPlayerDialog(playerid, RULES2_DIALOG, DIALOG_STYLE_MSGBOX, "Szab�lyzat", dstring, "Ok�", "");
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
				if(GetGVarInt("autoevent") == 0) format(dialogstring, sizeof(dialogstring), "Race event\nStunt event\nElindul�si id�k: %d(Be�ll�t�s)\nNevez�si d�jak: %d(Be�ll�t�s)\nAut�matikus eventek: {FF0000}OFF\n{FFFFFF}Ennyi id�k�z�nk�nt indulnak a versenyek: %d(Be�ll�t�s)\nEvent elind�t�sa\nJ�t�kos kiz�r�sa az eventb�l", GetGVarInt("StartRaceTime"), GetGVarInt("NevezesiDij"), GetGVarInt("autostarttime"));
				if(GetGVarInt("autoevent") == 1) format(dialogstring, sizeof(dialogstring), "Race event\nStunt event\nElindul�si id�k: %d(Be�ll�t�s)\nNevez�si d�jak: %d(Be�ll�t�s)\nAut�matikus eventek: {00FF00}ON\n{FFFFFF}Ennyi id�k�z�nk�nt indulnak a versenyek: %d(Be�ll�t�s)\nEvent elind�t�sa\nJ�t�kos kiz�r�sa az eventb�l", GetGVarInt("StartRaceTime"), GetGVarInt("NevezesiDij"), GetGVarInt("autostarttime"));
				ShowPlayerDialog(playerid, EVENT_DIALOG, DIALOG_STYLE_LIST, "V�lassz eventet", dialogstring, "Kiv�laszt", "Kil�p");
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
			        	    format(zene, sizeof zene, "%sTov�bb", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    new cimstr[60];
			    format(cimstr, sizeof(cimstr), "V�lassz zen�t", strlen(zene));
			    ShowPlayerDialog(playerid, ZENEVOTE_DIALOG, DIALOG_STYLE_LIST, cimstr, zene, "Kiv�laszt", "Vissza");
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
			        	    format(zene, sizeof zene, "%sTov�bb", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    new cimstr[60];
			    format(cimstr, sizeof(cimstr), "V�lassz zen�t(karakterek sz�ma: %d)", strlen(zene));
			    ShowPlayerDialog(playerid, ZENEADMIN_DIALOG, DIALOG_STYLE_LIST, cimstr, zene, "Kiv�laszt", "Vissza");
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
			    format(cimstr, sizeof(cimstr), "Zene elfogad�sa(karakterek sz�ma: %d)", strlen(zenestr));
			    ShowPlayerDialog(playerid, ZENEFOGAD_DIALOG, DIALOG_STYLE_LIST, cimstr, zenestr, "Lej�tsz�s", "Vissza");
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
			    SendClientMessage(playerid, COLOR_GREEN, "A zene elindult. Ha megfelel�en megy, minden ok� stb, akkor �rd be hogy /zenefogad, ha nem akkor /zenetorol");
			    SetPVarInt(playerid, "zenetbiral", 1);
			    SetPVarString(playerid, "birallink", tarolo);
			    SetPVarString(playerid, "biralnev", inputtext);
	        }
	    }
	    else ShowPlayerDialog(playerid, APANEL_DIALOG, DIALOG_STYLE_LIST, "Admin panel", "Event system\nZene szavaz�s\nZen�k\nFeny�fa fel�ll�t�sa\nFeny�fa leszed�se\nZene elfogad�sa", "V�laszt", "Kil�p");
	}
	if(dialogid == ZENEVOTE_DIALOG)
	{
	    if(response)
	    {
	        if(GetGVarInt("ZeneVoteRunning") == 1) return SendClientMessage(playerid, COLOR_ERROR, "[ HIBA ]: M�r folyamatban van egy szavaz�s!");
            if(!strcmp(inputtext, "Tov�bb"))
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
			        	    format(zene, sizeof zene, "%sTov�bb", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    ShowPlayerDialog(playerid, ZENEVOTE_DIALOG, DIALOG_STYLE_LIST, "V�lassz zen�t", zene, "Kiv�laszt", "Vissza");
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
			SendFormatMessageToAll(COLOR_ADMINMSG, "[ Szavazas ]: %s egy szavaz�st ind�tott erre a zen�re: %s", GetPlayerNameEx(playerid), inputtext);
			SendClientMessageToAll(COLOR_ADMINMSG, "Szavazni a /zigen /znem parancsokkal tudsz!");
	    }
	    else ShowPlayerDialog(playerid, APANEL_DIALOG, DIALOG_STYLE_LIST, "Admin panel", "Event system\nZene szavaz�s\nZen�k\nFeny�fa fel�ll�t�sa\nFeny�fa leszed�se\nZene elfogad�sa", "V�laszt", "Kil�p");
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
	        if(!strcmp(inputtext, "Tov�bb"))
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
			        	    format(zene, sizeof zene, "%sTov�bb", zene, tarolo);
			        	    SetPVarInt(playerid, "i", i);
			        	    break;
			        	}
					}
			    }
			    new cimstr[60];
			    format(cimstr, sizeof(cimstr), "V�lassz zen�t(karakterek sz�ma: %d)", strlen(zene));
			    ShowPlayerDialog(playerid, ZENEADMIN_DIALOG, DIALOG_STYLE_LIST, cimstr, zene, "Kiv�laszt", "Vissza");
	        }
		}
		else ShowPlayerDialog(playerid, APANEL_DIALOG, DIALOG_STYLE_LIST, "Admin panel", "Event system\nZene szavaz�s\nZen�k\nFeny�fa fel�ll�t�sa\nFeny�fa leszed�se\nZene elfogad�sa", "V�laszt", "Kil�p");
	}
	if(dialogid == ZENE1_DIALOG)
	{
	    if(response)
	    {
	        if(listitem == 0)
	        {
	            ShowPlayerDialog(playerid, RADIO_DIALOG, DIALOG_STYLE_LIST, "V�lassz r�di�t", "ClassFM\nRadio1\nRiseFM\nNeoFM\nMusicFM\nGong Radio", "Elind�t", "Vissza");
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
			        	    format(zene, sizeof zene, "%sTov�bb", zene);
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
			    format(zene, sizeof zene, "%sTov�bb", zene);
		        SetPVarInt(playerid, "i", i);*/
		        
			    ShowPlayerDialog(playerid, ZENE2_DIALOG, DIALOG_STYLE_LIST, "V�lassz zen�t", zene, "Kiv�laszt", "Vissza");
	        }
	        if(listitem == 2)
	        {
	            ShowPlayerDialog(playerid, ZENE3_DIALOG, DIALOG_STYLE_INPUT, "Zene keres�s a list�ban", "�rd be a zene c�m�t, r�szletet bel�le,\nvagy el�ad�j�b�l!", "Keres�s", "Vissza");
	        }
	        if(listitem == 3)
	        {
	            ShowPlayerDialog(playerid, ZENE4_DIALOG, DIALOG_STYLE_INPUT, "Zene ind�t�s MP3 linkr�l", "M�sold be ide annak a zen�nek az MP3 let�lt�si linkj�t,\namit meg szeretn�l hallgatni!", "Lej�tsz�s", "Vissza");
	        }
	        if(listitem == 4)
	        {
	            ShowPlayerDialog(playerid, ZENEKLINK_DIALOG, DIALOG_STYLE_INPUT, "Zene bek�ld�s: link", "Ha nincs egy zene a list�n, de te szeretn�d hogy odaker�lj�n,\nakkor csak m�sold be a zene MP3 let�lt�si linkj�t, az admin elb�r�lja,\n�s ha megfelel�, akkor m�r fel is ker�l a list�ra!\nAkkor most m�sold be ide az MP3 let�lt�si linkj�t:", "Tov�bb", "Vissza");
	        }
	        if(listitem == 5)
	        {
	            StopAudioStreamForPlayer(playerid);
	        }
	        if(listitem == 6)
	        {
	            SendClientMessage(playerid, COLOR_YELLOW, "Ebben a men�ben hallgathatsz online r�di�t �s zen�ket amik fel vannak t�ltve ide.");
	            SendClientMessage(playerid, COLOR_YELLOW, "Ha szeretn�l egy r�di�t a mostaniak k�z� ami m�g nincsen, �rj a f�rumra a szob�k t�m�ba.");
	            SendClientMessage(playerid, COLOR_YELLOW, "Ha szeretn�l egy zen�t a list�ba ami m�g nincsen k�zt�k, akkor menj a zene bek�ld�se pontra,");
	            SendClientMessage(playerid, COLOR_YELLOW, "�s illeszd be az MP3 URL-j�t. Sokan elrontj�k a linkel�st. Olyan linket illessz be, ami lehet�leg");
	            SendClientMessage(playerid, COLOR_YELLOW, "MP3 form�tum� f�jl. Ha olyan oldalon vagy fent ami gombos, r�nyomsz a gombra �s elkezdi a let�lt�st,");
	            SendClientMessage(playerid, COLOR_YELLOW, "Kattints jobb gombal a gombra, tulajdons�gok �s azt a linket ami ott van, illeszd be ide, �s a t�bbi m�r �rthet�.");
	            SendClientMessage(playerid, COLOR_RED, "MEGJEGYZ�S: N�melyik zene youtube-r�l van let�ltve, teh�t lehets�ges hogy nem odaill� dolgok lesznek a v�g�n!");
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
	    else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zen�k", "R�di�k\nZen�k list�ja\nKeres�s a list�ban\nZene ind�t�s MP3 linkr�l\nZene bek�ld�se\nZene le�ll�t�sa\nInform�ci�", "Kiv�laszt", "Kil�p");
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
	        if(!strcmp(inputtext, "Tov�bb"))
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
			        	    format(zene, sizeof zene, "%sTov�bb", zene, tarolo);
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
			    format(zene, sizeof zene, "%sTov�bb", zene);
		        SetPVarInt(playerid, "i", i);*/

			    ShowPlayerDialog(playerid, ZENE2_DIALOG, DIALOG_STYLE_LIST, "V�lassz zen�t", zene, "Kiv�laszt", "Vissza");
	        }
		}
		else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zen�k", "R�di�k\nZen�k list�ja\nKeres�s a list�ban\nZene ind�t�s MP3 linkr�l\nZene bek�ld�se\nZene le�ll�t�sa\nInform�ci�", "Kiv�laszt", "Kil�p");
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
		    ShowPlayerDialog(playerid, ZENE2_DIALOG, DIALOG_STYLE_LIST, "V�lassz zen�t", zene, "Kiv�laszt", "Vissza");
	    }
	    else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zen�k", "R�di�k\nZen�k list�ja\nKeres�s a list�ban\nZene ind�t�s MP3 linkr�l\nZene bek�ld�se\nZene le�ll�t�sa\nInform�ci�", "Kiv�laszt", "Kil�p");
	}
	if(dialogid == ZENE4_DIALOG)
	{
	    if(response)
	    {
	        PlayAudioStreamForPlayer(playerid, inputtext);
	    }
     	else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zen�k", "R�di�k\nZen�k list�ja\nKeres�s a list�ban\nZene ind�t�s MP3 linkr�l\nZene bek�ld�se\nZene le�ll�t�sa\nInform�ci�", "Kiv�laszt", "Kil�p");
	}
	if(dialogid == ZENEKLINK_DIALOG)
	{
	    if(response)
	    {
			SetPVarString(playerid, "kuldlink", inputtext);
			ShowPlayerDialog(playerid, ZENEKNEV_DIALOG, DIALOG_STYLE_INPUT, "Zene bek�ld�s: n�v", "Rendben, most �rd be a zene el�ad�j�t, c�m�t.\nEl�ad� - C�m, pl.\nTankcsapda - Be vagyok r�gva, a jeleket ker�ld!", "Tov�bb", "Vissza");
	    }
	    else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zen�k", "R�di�k\nZen�k list�ja\nKeres�s a list�ban\nZene ind�t�s MP3 linkr�l\nZene bek�ld�se\nZene le�ll�t�sa\nInform�ci�", "Kiv�laszt", "Kil�p");
	}
	if(dialogid == ZENEKNEV_DIALOG)
	{
	    if(response)
	    {
	        new link[250];
			SendClientMessage(playerid, COLOR_GREEN, "Rendben! Mostm�r a zene el k�ldve az adminoknak! V�rj hogy elb�r�lj�k, �s m�r meg is tal�lod a list�ban!");
			GetPVarString(playerid, "kuldlink", link, sizeof(link));
			format(query, sizeof(query), "INSERT INTO zenelistav (ID, Nev, Link) VALUES (0, '%s', '%s')", inputtext, link);
			mysql_query(query);
	    }
	    else ShowPlayerDialog(playerid, ZENE1_DIALOG, DIALOG_STYLE_LIST, "Zen�k", "R�di�k\nZen�k list�ja\nKeres�s a list�ban\nZene ind�t�s MP3 linkr�l\nZene bek�ld�se\nZene le�ll�t�sa\nInform�ci�", "Kiv�laszt", "Kil�p");
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
				else SendClientMessage(playerid, COLOR_ERROR, "HIBA: Nem vagy kl�nban!");
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
			ShowPlayerDialog(playerid, MSN_DIALOG, DIALOG_STYLE_INPUT, "MSN", msnstr, "Elk�ld", "Kil�p");
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
		ShowPlayerDialog(playerid, MSN_DIALOG, DIALOG_STYLE_INPUT, "MSN", msnstr, "Elk�ld", "Kil�p");
		SendFormatMessage(GetPVarInt(playerid, "msn"), COLOR_YELLOW, "%s �zenetet k�ld�tt neked! /msn %d", GetPlayerNameEx(playerid), playerid);
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
		SendClientMessage(playerid, 0xFCBB00FF, "Te figyelmeztetve lett�l!");
		SendFormatMessage(playerid, 0xFCBB00FF, "Figyelmeztet�sek sz�ma: %d darab a maxim�lis 3 darabb�l!", GetPVarInt(playerid, "Warns"));
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
	for(new i = 0;i < 4;i++) SendClientMessage(playerid, COLOR_RED, " "); //Besz�r 3 darab �res sort
	SendClientMessage(playerid, 0xFCBB00FF, "##############################################################################################");
	SendClientMessage(playerid, 0xFCBB00FF, "Te ki lett�l KICK-elve a szerverr�l!");
	SendFormatMessage(playerid, 0xFCBB00FF, "Indok: %s", reason);
	SendFormatMessage(playerid, 0xFCBB00FF, "Admin: %s", admin);
//	SendClientMessage(playerid, 0xFCBB00FF, "Amennyiben �gy gondolod hogy jogtalan volt akkor �rj egy e-mailt a ideird@azemailcimed.hu-ra!");
	SendClientMessage(playerid, 0xFCBB00FF, "###############################################################################################");
	SendFormatMessageToAll(COLOR_GREY, "%s (%d) KICK-elve lett a szerverr�l! Indok: %s", GetPlayerNameEx(playerid), playerid, reason);

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
	for(new i = 0;i < 4;i++) SendClientMessage(playerid, COLOR_RED, " "); //Besz�r 3 darab �res sort
	SendClientMessage(playerid, 0xFCBB00FF, "##############################################################################################");
	SendClientMessage(playerid, 0xFCBB00FF, "Te ki lett�l BAN-olva a szerverr�l!");
	SendFormatMessage(playerid, 0xFCBB00FF, "Indok: %s", reason);
	SendFormatMessage(playerid, 0xFCBB00FF, "Admin: %s", admin);
//	SendClientMessage(playerid, 0xFCBB00FF, "Amennyiben �gy gondolod hogy jogtalan volt akkor �rj egy e-mailt a ideird@azemailcimed.hu-ra!");
	SendClientMessage(playerid, 0xFCBB00FF, "###############################################################################################");
	SendFormatMessageToAll(GREY, "[ ADMIN ]: %s (%d) BAN-olva lett a szerverr�l! Indok: %s", GetPlayerNameEx(playerid), playerid, reason);

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
	format(message, sizeof(message), "[ ADMIN_CMD ]: %s (%d) egy admin parancsot haszn�lt: %s", GetPlayerNameEx(adminid), adminid, command);
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
			if(tipus == 1) format(string2,sizeof(string2),"%s�val", string);
			else if(tipus == 2) format(string2,sizeof(string2),"%s�nak", string);
			else if(tipus == 3) format(string2,sizeof(string2),"%s�t", string);
		    return string2;
		}
		else
		{
            sorszam = strfind(string, "e");
            if(sorszam == 1)
			{
			    format(string,sizeof(string),"%s", szo);
				strdel(string, xd-1, xd);
			    if(tipus == 1) format(string2,sizeof(string2),"%s�vel", string);
			    else if(tipus == 2) format(string2,sizeof(string2),"%s�nek", string);
			    else if(tipus == 3) format(string2,sizeof(string2),"%s�t", string);
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
					    if(tipus == 1) format(string2,sizeof(string2),"%s�val", string);
					    else if(tipus == 2) format(string2,sizeof(string2),"%s�nak", string);
					    else if(tipus == 3) format(string2,sizeof(string2),"%s�t", string);
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
	else format(string, sizeof(string), "T�pus nem j�");
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
	"�","�","�","�",
    "�","�","�","�",
 	"�","�","�","�",
 	"�","�","�","�",
 	"�","�","�","�",
 	"�","�","�","�",
 	"�","�","�","�",
	"�","�","�","�",
	"�","�","�","�"
};

stock FixGameString(const ta[])
{
	// T�rol�k l�trehoz�sa
	new index,
	    dest[256];

	// Karakterl�nc �tm�sol�sa
	strmid(dest,ta,0,strlen(ta),sizeof dest);

	// V�gigl�pked�nk a karaktereken
	for(index = 0; index < strlen(dest); index++)
	{
	    // V�gigl�pked�nk a karaktert�mb�n
		for(new idx = 0; idx < sizeof(chlist); idx++)
		{
		    // Ha az indexelt karakterek egyeznek
		    if(dest[index] == chlist[idx][0])
		    {
		        // Jav�tjuk
		        dest[index] = chlist[idx-2][0];
			}
		}
	}

	// Visszat�r�s
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
				    case 0: SetPVarString(i, "AdminRang", "�tlagos J�t�kos");
					case 1: SetPVarString(i, "AdminRang", "Moder�tor");
					case 2: SetPVarString(i, "AdminRang", "Kezd� Adminisztr�tor");
					case 3: SetPVarString(i, "AdminRang", "Halad� Adminisztr�tor");
					case 4: SetPVarString(i, "AdminRang", "F� Adminisztr�tor");
					case 5: SetPVarString(i, "AdminRang", "Any�d");
				}

				new adminpvar[64];
				GetPVarString(i, "AdminRang", adminpvar, sizeof(adminpvar));

				SendFormatMessage(i, COLOR_ADMINMSG, "[ ADMIN ]: %s megv�ltoztatta a rangodat! Az �j rang: %s", aplayer, adminpvar);
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
						SendClientMessage(j, COLOR_RED, "A kl�nod t�r�lve lett.");
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
	//GameTextForPlayer(playerid,"~n~~n~~n~~w~Spect�l�s befejezve!",1000,3);
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

//k�t pont k�z�tti t�vols�g
stock Float:GetDistanceBetweenPoints(Float:X, Float:Y, Float:Z, Float:PointX, Float:PointY, Float:PointZ)
{
	new Float:Distance;
	Distance = floatabs(floatsub(X, PointX)) + floatabs(floatsub(Y, PointY)) + floatabs(floatsub(Z, PointZ));
	return Distance;
}

//k�t pont k�z�tti t�vols�g (Z kiv�ve)
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
			//if( (weaponid == 35) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhaszn�lat", "SYSTEM"); //RPG
			if( (weaponid == 36) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhaszn�lat", "SYSTEM"); //Rocket Launcher
			else if( (weaponid == 37) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhaszn�lat", "SYSTEM"); //L�ngsz�r�
			else if( (weaponid == 38) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhaszn�lat", "SYSTEM"); //Minigun
			else if( (weaponid == 39) && (ammo != 0) ) BanReason(i, "Tiltott fegyverhaszn�lat", "SYSTEM"); //Robbant� t�ska
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
				    SendFormatMessage(i, COLOR_GREEN, "t�vols�g: %0.2f a", GetDistanceBetweenPoint(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY")));
				    //SendFormatMessage(i, COLOR_GREEN, "t�vols�g: %0.2f b", GetDistanceBetweenPoints(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acoZ"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY"), GetPVarFloat(i, "acnZ")));
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
								SendClientMessage(i, COLOR_RED, "kickelni k�ne t�ged");
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
					    SendFormatMessage(i, COLOR_GREEN, "t�vols�g: %0.2f a", GetDistanceBetweenPoint(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY")));
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
				    SendFormatMessage(i, COLOR_GREEN, "t�vols�g: %0.2f", GetDistanceBetweenPoint(GetPVarFloat(i, "acoX"), GetPVarFloat(i, "acoY"), GetPVarFloat(i, "acnX"), GetPVarFloat(i, "acnY")));
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
	    format(pingkickreason, sizeof(pingkickreason), "Magas ping: %d (Maxim�lis megengedett ping: %d)", pingaverage, GetGVarInt("MaxPing"));
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
			BanEx(i, "p�nzcheat");
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
		CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "ld_grav:timer", "10 j�tszott �ra", "Kezd� j�t�kos");
		CallRemoteFunction("GiveEXPpublic", "ii", playerid, 100);
    }
    if(GetPVarInt(playerid, "Ora") == 50 && GetPVarInt(playerid, "Perc") == 0)
    {
		CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "ld_grav:timer", "50 j�tszott �ra", "Halad� j�t�kos");
		CallRemoteFunction("GiveEXPpublic", "ii", playerid, 500);
    }
    if(GetPVarInt(playerid, "Ora") == 100 && GetPVarInt(playerid, "Perc") == 0)
    {
		CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "ld_grav:timer", "100 j�tszott �ra", "Profi j�t�kos");
		CallRemoteFunction("GiveEXPpublic", "ii", playerid, 1000);
    }
    if(GetPVarInt(playerid, "Ora") == 200 && GetPVarInt(playerid, "Perc") == 0)
    {
		CallRemoteFunction("UnlockAchievementpublic", "isss", playerid, "ld_grav:timer", "200 j�tszott �ra", "V�rprofi j�t�kos");
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
        	format(str, sizeof str, "%sN�v: %s, VehID: %d, �r: %s\n", str, tarolo, tarolo2, tarolo3);
		}
    }
    ShowPlayerDialog(playerid, 9595, DIALOG_STYLE_LIST, "Aut�", str, "Vesz", "M�gse");
	return 1;
}*///�gy kell kiiratni valamit dialogba, pl nem tudom mit... l�nyeg hogy �rtem

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

//----------------------------------Havaz�s by Kwarde(?)------------------------
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

//kar�csonyi dolgok

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
			SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Tal�lt�l egy aj�nd�kcsomagot! A /gift paranccsal adhatod oda valakinek, a /gifto paranccsal kinyithatod.");
			SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Megjegyz�s: Az aj�nd�kok miut�n kil�psz elvesznek!");
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
	if(IsPlayerInDynamicArea(playerid, diszarea[9])) GameTextForPlayer(playerid, "�", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[10])) GameTextForPlayer(playerid, "r", 2000, 4);
	if(IsPlayerInDynamicArea(playerid, diszarea[11])) GameTextForPlayer(playerid, "�", 2000, 4);*/
	
	#if defined KARACSONYIJATEK
	if(IsPlayerInAnyVehicle(playerid)) return 1;
	new dialogstr[1500];
	if(IsPlayerInDynamicArea(playerid, jatekarea[0]))
	{
		new Float: pp[3];
		GetPlayerPos(playerid, pp[0], pp[1], pp[2]);
		SetPlayerPosEx(playerid, pp[0]+4, pp[1], pp[2]);
	    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s%s%s%s%s%s%s",
	    "Alap t�rt�net (Ezt m�r elmondta a j�t�kszervez�):\n",
	    "K�l�n�s dolgokat l�ttak ma egy sik�tor felett... Egy sik�tor felett, ahol t�len mindig k�l�n�s dolgok t�rt�nnek.\n",
	    "Ezt a k�l�n�s dolgot egy Burger Shoot-ban dolgoz� munk�s vette �szre. Arr�l sz�molt be hogy minden �vben kar�csonykor l�tta.\n",
	    "L�tott elrep�lni egy k�l�n�s dolgot a sik�tor felett minden �vben. Azonban ez az �v m�s! Ebben az esztend�ben\n",
	    "egy k�l�n�s t�rgyat dobott le, vagy ejtett le, ami nem m�s mint egy d�sz. Ez a d�sz nem egy v�za, sem egy k�p..\n",
	    "Ez egy kar�csonyfa d�sz! De hogy ez se legyen unalmas, ez egy k�l�n�s kar�csonyfa d�sz, ugyanis cs�r�g benne valami.\n",
	    "Eddig senki nem merte kinyitni, mert amint megcs�rgette ink�bb sz�pen visszatette a hely�re �s elfutott.\n\n",
	    "Nos, ennek kell ut�naj�rnod. Menj abba a sik�torba ahol ezek a dolgok t�rt�ntek.\n\n",
	    "Jelenlegi szitu�ci�:\n",
	    "Ide�rt�l a sik�torba �s megl�ttad azt a h�res, k�l�n�s de ijeszt� kar�csonyfa d�szt. Kicsit gondolkozol azt�n felveszed.\n",
	    "Megcs�rgeted a f�led mellett, kicsit megijedsz, de nem futsz el mert �rdekel a dolog. Megfogod a markodba, megpr�b�lod\n",
	    "�sszeroppantani, de gyenge fizikumod miatt ink�bb a f�ldh�z v�god �s sz�tt�rik. A d�szben egy �zenetet tal�lsz.\n",
	    "Az �zenetben ez �ll: (Kattints a tov�bb gombra)");
	    ShowPlayerDialog(playerid, DIALOG_JATEK1, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Tov�bb", "Kil�p");
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[1]))
	{
	    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s%s%s%s%s%s%s",
	    "Ide�rsz a m�l�hoz ahol a DM partyk szoktak menni. Elgondolkodsz �s eszedbe jut:\n",
		"Sok t�lt�ny... A f�ld�n sok a t�lt�ny... �rtem! Mivel itt szokott mindenki DM-elni ez�rt itt maradt a sok t�lt�ny a f�ld�n.\n",
		"K�rben�zel �s tal�lsz egy m�sik d�szt. Kicsit elszomorodsz hogy nem l�thatod a mikul�st.\n",
		"M�r k�sz�lsz a f�ldh�z v�gni, de megpillantasz rajta egy cetlit amin ez �ll: NE V�GJ F�LDH�Z!! INK�BB NYOMD MEG A GOMBOT!!\n",
		"H�mm�gsz egyet, de elkezded rajta keresni a gombot.... Megtal�ltad. El�ugrik benne egy kis k�perny� mint a sci-fi filmekben.\n",
		"Nagyot n�zel. A kis csodak�ty�n egy vide� elkezd lej�tsz�dni. A k�perny�j�n egy M bet� �ll, �s megint elszomorodsz\n",
		"hogy nem l�thatod a mikul�st. A vide�t lej�tszod, a hang eltorz�tottan megy.\n",
		"�dv bar�tom. M vagyok, M mint... Ok�, erre most nem �r�nk r�! Ott tartottam hogy elejtettem az aj�nd�kaimat.\n",
		"Mikor a sz�n megr�zk�dott akkor �gy eml�kszem egy farm felett mentem el... Igen! Egy farm! Majdnem leestem, ezalatt az\n",
		"egy m�sodperc alatt felm�rtem a terepet. 3 sz�nt�f�ld volt. Az egyiken sorban �lltak a sz�nagurig�k.\n",
		"Ha a farm tulaja tal�lt valamit akkor val�sz�n�leg bevitte a pajt�ba. Menj oda �s n�zz k�r�l.");
	    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[2]))
	{
	    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s%s",
	    "Sz�p cs�ndben bem�sz a pajt�ba, megpillantasz m�g egy d�szt. Felveszed, j�l megszor�tod\n",
	    "de nem el�g j�l... Kics�szott a kezedb�l �s nem t�rt �ssze.. De megint felveszed, megszor�tod �s a f�ldh�z v�god.\n",
	    "Hopp�! Nincs benne semmi. Na most mi lesz? Gondolod. De szerencs�dre (vagy balszerencs�dre) kij�n a farm tulaja\n",
		"felh�borodottan �s elkezd �v�lt�zni veled. Te sz�pen lenyugtatod �s eln�z�st k�rsz, azt�n megk�rdezed mit tud err�l a d�szr�l.\n",
		"Szerencs�dre mindent l�tott. L�tott elrep�lni ingadozva egy sz�nt, amib�l kiesett egy d�sz. Bevitte a pajt�ba majd ott hagyta.\n",
		"Mi m�s�rt vitte volna be mint hogy feltegye a feny�f�j�ra? De te sz�pen �sszet�rted.. A l�nyeg, hogy l�tta elrep�lni\n",
		"az �tsz�li pihen� mellett �s ott is leejtett valamit, meg l�tott valami hom�lyt, de akkor mer�lt le a telefonja, �gy a nagy�t�nak annyi volt.\n",
		"Menj az �tsz�li pihen�h�z �s k�rdezd meg ott mit l�ttak.");
		ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
		SetPVarInt(playerid, "pihenohozvissza", 0);
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[3]))
	{
	    if(GetPVarInt(playerid, "pihenohozvissza") == 0)
	    {
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
		    "Meg�rkezt�l a pihen�h�z. R�n�zel a kis h�zakra, szinte bemenn�l �s lefek�dn�l. De nem teszed.\n",
		    "Megfogod a d�szt a kezedbe, elm�sz a pihen� vezet�j�hez �s k�rdezgetsz r�la.\n",
		    "A vezet� nem tud megsz�lalni, annyira izgatott... De nagyon!! A kezedbe nyom egy kulcsot �s elmutat az egyik ir�nyba.\n",
		    "Na de egy baj van. Mindk�t kez�vel mutatott. Teh�t nem is az egyik, hanem k�t ir�nya mutat.\n",
		    "K�zbe siker�l egy sz�t kiny�gnie a sz�j�n: rakt�r..h�z...\n",
		    "Te pislogt�l k�zben �s nem l�ttad j�l hogy merre mutat, teh�t gondolsz egyet �s le�t�d szeg�nyt.\n",
		    "M�g egyet gondolsz �s elindulsz k�rben�zni a ter�leten, h�tha kell valahova ez a kulcs...");
			//"A kulcsot �gy haszn�lhatod: /xkulcs");
			ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
		}
		else if(GetPVarInt(playerid, "pihenohozvissza") == 1)
		{
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s",
		    "Ide�rt�l, bekopogsz. Kisz�deleg a vezet�, megk�sz�ni hogy le�t�tted �s elmutat egy ir�nyba.\n",
		    "Vezet�: Menj arra, tal�lsz egy h�zat �s nyisd ki azzal a kulcsal amit adtam. Szerintem azt keresed.\n",
		    "Keresed a kulcsot a zsebedben de nem tal�lod... Keresed a gaty�dban, bels� seb, kab�t zseb, mindenhol.\n",
		    "De nem tal�lod. Tal�n benne felejtetted az egyik rakt�rh�z kulcslyuk�ban.");
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
		    SetPVarInt(playerid, "raktarhazkulcs", 1);
		}
		else if(GetPVarInt(playerid, "pihenohozvissza") == 2)
		{
		    format(dialogstr, sizeof(dialogstr), "%s%s",
		    "Sz�t n�zel, megpillantod a f�ld�n a ragaszt�t �s felveszed. �sszeragasztod a kulcsot\n",
		    "�s sz�tn�zel. Keress egy h�zat ami be van z�rva, a /xkulcs parancsal haszn�lhatod a kulcsot.");
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
		}
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[4]))
	{
	    if(GetPVarInt(playerid, "raktarhazkulcs") == 0)
	    {
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
		    "�vatosan felm�szol a megpillantott d�sz ut�n a kont�nerekre, azt�n felveszed.\n",
		    "A kont�nerhez hozz�v�god, sz�t t�rik, de nincs benne semmi. M�gcsak seg�ts�g sincsen.\n",
		    "Nem tudod mit csin�lj, de m�g mindig van egy kulcsod �s nem tudod mire j�.\n",
		    "Lem�sz, megpr�b�lod valamelyik rakt�rt kinyitni vele, de nem ny�lik egyik se.\n",
			"De eszedbe jut valami: Las Venturas-ban is van egy rakt�rh�z �s ez az �t pont oda vezet.\n",
			"Kicsit k�rbe�rod magadban: Az aut�p�lya megy el mellette... Egyb�l miut�n bet�rtem Las Venturas-ba... Meglesz.\n",
			"Teh�t a k�vetkez� c�lod: Las Venturas rakt�rh�z.");
			ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
		}
		else if(GetPVarInt(playerid, "raktarhazkulcs") == 1)
		{
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s",
		    "N�zed sorban a rakt�rh�zak kulcslyukait, nem tal�... De megtal�ltad. Belet�rve az egyikbe.\n",
		    "Biztos a nagy izgalom miatt t�rt�nhetett. Na de most mi legyen? - Gondolod magadban.\n",
			"J�v�re k�rsz a mikul�st�l egy �j kulcsot �s j�v� ut�n pedig megkeresed az aj�nd�kokat?\n",
			"Sok id�. H�t elkezded kibogar�szni a belet�rt felet a z�rb�l.\n",
			"Egy csoda folyt�n kiesik bel�le. A m�sik fele megvan, kiveszel a zsebedb�l egy kis raga...\n",
			"A ragaszt� kiesett a pihen�n�l mik�zben a kulcsot kerested...");
		    ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
		    SetPVarInt(playerid, "pihenohozvissza", 2);
		}
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[5]))
	{
	    format(dialogstr, sizeof(dialogstr), "%s%s%s%s%s%s%s",
	    "Sz�p cs�ndben bem�sz a telekhelyre, megl�tod a kar�csonyfa d�szt �s megfogod.\n",
	    "Hm, ez k�l�n�sen neh�z. - Gondolod.\n",
	    "A f�ldh�z v�god, de nem t�rik sz�t. Megint megpr�b�lod, nem siker�lt.. Sokadszorra sem.\n",
	    "Megn�zed k�zelebbr�l a k�vet �s �szreveszed hogy bele van v�sve egy felirat:\n",
		"Gyere vissza a pihen�h�z te kincskeres� - �dv: vezet�\n",
		"Gondolkodsz... Azt�n eml�kszel... Le�t�tted.\n",
		"De sebaj, ir�ny vissza!");
		ShowPlayerDialog(playerid, ALAP_DIALOG, DIALOG_STYLE_MSGBOX, "T�rt�n�s", dialogstr, "Ok�", "");
		SetPVarInt(playerid, "pihenohozvissza", 1);
	}
	if(IsPlayerInDynamicArea(playerid, jatekarea[6]))
	{
	    if(GetPVarInt(playerid, "ajimegtalalva") == 0)
	    {
	        SetPVarInt(playerid, "ajimegtalalva", 1);
		    format(dialogstr, sizeof(dialogstr), "%s%s%s%s",
		    "Mikor meg�rkezel, nem hiszel a szemednek... Itt vannak az aj�nd�kok. Felveszed a tal�lt d�szt\n",
		    "�s megint egy kis gombot keresel rajta amit sikeresen meg is tal�lt�l. Bej�n a k�perny�,\n",
		    "m�g mindig egy M bet� van ott. Torz�tott hangon mondja: Te megtal�ltad az aj�nd�kaim!\n",
		    "Nagyon h�l�s vagyok neked! Jutalomb�l minden ami benne van a ti�d! De az j� k�rd�s hogyan ker�ltek be ide...\n",
		    "Nem �rdekel! K�sz�n�m! H�la neked a kar�csony folytat�dhat. Egy�bk�nt a nevem M, mint... MEGLEPET�S!\n",
		    "K�red az aj�nd�kokat vagy meghagyod m�snak? Csak egyszer v�laszthatsz!");
		    ShowPlayerDialog(playerid, DIALOG_JATEK2, DIALOG_STYLE_MSGBOX, "A v�laszt�s", dialogstr, "K�rem", "Meghagyom");
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
			SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Tal�lt�l egy aj�nd�kcsomagot! A /gift paranccsal adhatod oda valakinek, a /gifto paranccsal kinyithatod.");
			SendClientMessage(playerid, COLOR_GREEN, #HLIME#"Megjegyz�s: Az aj�nd�kok miut�n kil�psz elvesznek!");
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
	if(pickupid == disz[9]) GameTextForPlayer(playerid, "�", 2000, 4);
	if(pickupid == disz[10]) GameTextForPlayer(playerid, "r", 2000, 4);
	if(pickupid == disz[11]) GameTextForPlayer(playerid, "�", 2000, 4);
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
	SendFormatMessageToAll(COLOR_LIGHTGREEN, "Lott� nyer�sz�mok: %d, %d, %d, %d, %d", szam1, szam2, szam3, szam4, szam5);
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
			SendFormatMessage(i, COLOR_GREEN, "Te lott�sz�maid: %d, %d, %d, %d, %d", lszamok[0][i], lszamok[1][i], lszamok[2][i], lszamok[3][i], lszamok[4][i]);
			SendFormatMessage(i, COLOR_GREEN, "Nyerem�nyed: %d$", nyeremeny[i]);
			GivePlayerMoneyEx(i, nyeremeny[i], "Lott�n nyert");
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
	SendFormatMessageToAll(COLOR_GREEN, #HLIME#"Aki legel�sz�r be�rja ezt: "#HYELLOW#"%s"#HLIME#", kap 10.000$-t �s 3 EXP-et!", reakciosz);
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
		SendClientMessageToAll(COLOR_GREEN, #HLIME#"Mivel senki nem teljes�tette a reakci�tesztet t�r�lve lett. 2 perc m�lva �j indul.");
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
	    if(string[i] == '{' || string[i] == '}' || string[i] == '|' || string[i] == '"' || string[i] == ' ' || string[i] == '+' || string[i] == '!' || string[i] == '/' || string[i] == '=' || string[i] == '@' || string[i] == '#' || string[i] == '<' || string[i] == '>' || string[i] == '�' || string[i] == '�' || string[i] == '�' || string[i] == '�' || string[i] == '?')
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
		"�", "�",
		"�", "�",
		"�", "�",
		"�", "�",
		"�", "�",
		"�", "�",
		"�", "�",
		"�", "�"
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
    new str[64], i = 0;                         //  Deklar�l�s
    format(str, 64, "%d", n);                   //  �talak�tjuk sztringg� a sz�mot
    while (i < strlen(str)) {                   //  Egy ciklust futtatunk addig, m�g el nem �ri az i a megfelel� �rt�ket
        strins(str, slt[0], strlen(str) - i);      //  H�tulr�l hozz�adunk mindig egy pontot
       	i = i+4;                               //  N�velj�k az i-t n�ggyel
    }
    strdel(str, strlen(str) - 1, strlen(str));  //  Kit�r�lj�k az utols� karaktert
    return str;                                 //  Visszat�r�nk az str nev� sztring�nkkel
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
