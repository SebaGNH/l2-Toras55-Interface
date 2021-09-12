class AutoSS extends UICommonAPI;

const LOOP_COUNT = 1;

var WindowHandle Me;
var ItemWindowHandle Shot1;
var ItemWindowHandle Shot2;
var ItemWindowHandle Shot3;
var ItemWindowHandle Shot4;
var ItemWindowHandle RHand;
var ItemWindowHandle InvItem;
var ItemWindowHandle SumPetItem;
var AnimTextureHandle Animation1;
var AnimTextureHandle Animation2;
var AnimTextureHandle Animation3;
var AnimTextureHandle Animation4;
var ButtonHandle AutoSSMy;
var ButtonHandle AutoSSPet;
var TextureHandle texBG2;
var TextureHandle texBG3;
var TextureHandle texBG4;
var TextureHandle FrameSS2;
var TextureHandle FrameSS3;
var TextureHandle FrameSS4;
var NameCtrlHandle OwnName;

var ItemInfo EquippedWeapon;
var ItemInfo EquippedWeaponPrev;
var ItemInfo SoulShot;
var ItemInfo SpiritShot;
var ItemInfo SumPetShot;
var ItemInfo SumPetSpiritShot;
var PetInfo	 SumPetInfo;

var int WeaponT;
var int soulIndex;
var int spiritIndex;
var int sumpetsoulIndex;
var int sumpetspiritIndex;
var int attSpeed;
var int i;
var int i2;
var int i3;
var int i4;
var bool isUsedSoul;
var bool isUsedSpirit;
var bool isExistSoul;
var bool isExistSpirit;
var bool isExistPetSoul;
var bool isExistPetSpirit;
var bool isAttacking;
//var bool isAttackingDmg;

var bool isChargedtPetSoul;
var bool isChargedtPetSpirit;

var bool isPlayerDead;
var bool isSumPetExist;
var bool isNowMove;

var bool ShowMy;
var bool ShowPet;

var SkillInfo UsedSkill;

function OnLoad()
{
	Me = GetWindowHandle("AutoSS");
	Shot1 = GetItemWindowHandle("AutoSS.Item1");
	Shot2 = GetItemWindowHandle("AutoSS.Item2");
	Shot3 = GetItemWindowHandle("AutoSS.Item3");
	Shot4 = GetItemWindowHandle("AutoSS.Item4");
	Animation1 = GetAnimTextureHandle("AutoSS.Anim1");
	Animation2 = GetAnimTextureHandle("AutoSS.Anim2");
	Animation3 = GetAnimTextureHandle("AutoSS.Anim3");
	Animation4 = GetAnimTextureHandle("AutoSS.Anim4");
	texBG2 = GetTextureHandle("AutoSS.BGSpirit");
	texBG3 = GetTextureHandle("AutoSS.BGSumPetSoul");
	texBG4 = GetTextureHandle("AutoSS.BGSumPetSpirit");
	FrameSS2 = GetTextureHandle("AutoSS.FrameSS2");
	FrameSS3 = GetTextureHandle("AutoSS.FrameSS3");
	FrameSS4 = GetTextureHandle("AutoSS.FrameSS4");
	OwnName = GetNameCtrlHandle("StatusWnd.UserName");
	
	RHand = GetItemWindowHandle( "InventoryWnd.EquipItem_RHand" );
	InvItem = GetItemWindowHandle( "InventoryWnd.InventoryItem" );
	SumPetItem = GetItemWindowHandle( "InventoryWnd.InventoryItem" );
	
	AutoSSMy = GetButtonHandle("AutoSS.AutoSSMy");
	AutoSSPet = GetButtonHandle("AutoSS.AutoSSPet");

}

function OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_ReceiveMagicSkillUse);
	RegisterEvent(EV_ReceiveAttack);
//	RegisterEvent(EV_OlympiadTargetShow);
	RegisterEvent( EV_Die );
	RegisterEvent( EV_SystemMessage );
	RegisterEvent( EV_SummonedStatusShow );
	RegisterEvent( EV_PetSummonedStatusClose );
	RegisterEvent( EV_PetStatusShow );
	RegisterEvent( EV_Restart );

}

function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	
}

function AnchorShots(string window, int x, int y)
{
	local bool isVertical;
	
	isVertical = GetOptionBool( "Game", "IsShortcutWndVertical" );
//	Me.SetAnchor(window, "TopLeft", "TopLeft", x, y);
	if (!isVertical) Me.SetAnchor(window, "TopLeft", "TopLeft", x-1, y+4);
	else  Me.SetAnchor(window, "TopLeft", "TopLeft", x+4, y-1);

}

function OnShow()
{
//	isPlayerDead = false;
//	isSumPetExist = false;
//	isNowMove = false;
	isChargedtPetSoul = false;
	isChargedtPetSpirit = false;
	i = 0;
	i2 = 0;
	i3 = 0;
	i4 = 0;
	Shot1.Clear();
	Shot2.Clear();	
	Shot3.Clear();
	Shot4.Clear();
	Animation1.HideWindow();
	Animation2.HideWindow();
	Animation3.HideWindow();
	Animation4.HideWindow();

//	if (AutoSSMy.IsShowwindow()) ShowMy = true; else	ShowMy = false;
//	if (AutoSSPet.IsShowwindow()) ShowPet = true; else	ShowPet = false;

//	ExecuteEvent(EV_UpdateUserInfo);
//	if ((sumpetsoulIndex == -1) && (sumpetspiritIndex == -1))
//	{
//		Shot3.HideWindow();
//		Shot4.HideWindow();
//		Animation3.HideWindow();
//		Animation4.HideWindow();
//		texBG3.HideWindow();
//		texBG4.HideWindow();
//		ShowPet = false;
//	}
}

function SetSSPosition()
{
	local bool IsExpand1;
	local bool IsExpand2;
	local bool IsExpand3;
	local bool IsExpand4;
	local bool IsExpand5;
	
	local bool isVertical;
	
	isVertical = GetOptionBool( "Game", "IsShortcutWndVertical" );
	
	IsExpand1 = GetOptionBool( "Game", "Is1ExpandShortcutWnd" );
	IsExpand2 = GetOptionBool( "Game", "Is2ExpandShortcutWnd" );
	IsExpand3 = GetOptionBool( "Game", "Is3ExpandShortcutWnd" );
	IsExpand4 = GetOptionBool( "Game", "Is4ExpandShortcutWnd" );
	IsExpand5 = GetOptionBool( "Game", "Is5ExpandShortcutWnd" );
	
	if (!isVertical)
	{
		Me.SetWindowSize(132, 26);
		
		Animation2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 30, 0);
		Animation3.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 76, 0);
		Animation4.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 106, 0);
		Shot2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 30, 0);
		Shot3.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 76, 0);
		Shot4.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 106, 0);
		FrameSS2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 30, 0);
		FrameSS3.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 76, 0);
		FrameSS4.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 106, 0);
		texBG2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 31, 1);
		texBG3.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 77, 1);
		texBG4.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 107, 1);
		AutoSSMy.SetAnchor("AutoSS", "TopLeft", "TopLeft" , -17, 6);
		AutoSSPet.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 59, 6);
		if (IsExpand5)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_5", 36, -34);
		}	
		else if (IsExpand4)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_4", 36, -34);
		}
			
		else if (IsExpand3)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_3", 36, -34);
		}
		else if (IsExpand2)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_2", 36, -34);
		}
			
		else if (IsExpand1)
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal_1", 36, -34);
		}
			
		else
		{
			AnchorShots("ShortcutWnd.ShortcutWndHorizontal", 36, -34);
		}
	}
	else
	{
		Me.SetWindowSize(26, 132);
		
		Animation2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 30);
		Animation3.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 76);
		Animation4.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 106);
		Shot2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 30);
		Shot3.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 76);
		Shot4.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 106);
		FrameSS2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 30);
		FrameSS3.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 76);
		FrameSS4.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 0, 106);
		texBG2.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 1, 31);
		texBG3.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 1, 77);
		texBG4.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 1, 107);
		AutoSSMy.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 6, -17);
		AutoSSPet.SetAnchor("AutoSS", "TopLeft", "TopLeft" , 6, 59);
		if (IsExpand5)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_5", -34, 34);
		}	
		else if (IsExpand4)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_4", -34, 34);
		}
			
		else if (IsExpand3)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_3", -34, 34);
		}
		else if (IsExpand2)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_2", -34, 34);
		}
			
		else if (IsExpand1)
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical_1", -34, 34);
		}
			
		else
		{
			AnchorShots("ShortcutWnd.ShortcutWndVertical", -34, 34);
		}
	}
	
}

function OnEvent( int EventID, String param )
{
	local int msg_idx;
	local AutoSouls script_as;
	switch(EventID)
	{
		case EV_GamingStateEnter:
		
			script_as = AutoSouls(GetScript("AutoSouls"));
			script_as.SetPosition();
			SetSSPosition();
			if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
			{
				ShowMy = true;
				Me.ShowWindow();
			}
			else
				ShowMy = false;
			if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoPetSS")) ShowPet = true; else	ShowPet = false;
		//	AddSystemMessageString(string(ShowMy));
		//	AddSystemMessageString(string(ShowPet));
		//	GetEquippedWeaponPrev();			
				//Me.ShowWindow();
		break;
		case EV_UpdateUserInfo:
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
			{
		//	AddSystemMessageString("EV_UpdateUserInfo"); 
			EnterTheVoid();
			if (ShowPet) EnterTheAbyss();
			}
		break;
		case EV_ReceiveMagicSkillUse:
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
				SkillCast(param);
		break;
		case EV_ReceiveAttack:
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
				Attack(param);
		break;
		case EV_Die:
			OnDieEvent(param);
		break;
		
		case EV_SystemMessage:
			if (GetUIState() == "GAMINGSTATE") 
			{
				ParseInt(param, "Index", msg_idx);
				if ( msg_idx == 3108) isNowMove = true;
			}
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
			HandleSystemmsg(param);	
		break;
		
		case EV_SummonedStatusShow:
			isSumPetExist = true;
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
			{
		//	AddSystemMessageString("PriZIVAEM");	
			
			isChargedtPetSoul = false;
			isChargedtPetSpirit = false;
			GetPetInfo(SumPetInfo);
			EnterTheAbyss();	
			}
		break;
		
		case EV_PetStatusShow:
			isSumPetExist = true;
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
			{
			//AddSystemMessageString("PriZIVAEM");	
			
			isChargedtPetSoul = false;
			isChargedtPetSpirit = false;
			GetPetInfo(SumPetInfo);
			EnterTheAbyss();	
			}	
		break;
		
		case EV_PetSummonedStatusClose:
			isSumPetExist = false;
			if (GetUIState() == "GAMINGSTATE" && class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSS"))
			{
		//	AddSystemMessageString("IZGONYAEM");
			
			isChargedtPetSoul = false;
			isChargedtPetSpirit = false;
			Animation3.Stop();
			Animation4.Stop();
			Animation3.HideWindow();
			Animation4.HideWindow();
			EnterTheAbyss();	
			}	
		break;

		case EV_Restart:				
			ClearAll();			
		break;		
	}
}

function OnDieEvent(string param)
{
	isPlayerDead = true;
}

function ClearAll()
{
	
	isPlayerDead = false;
	isSumPetExist = false;
	isNowMove = false;
	i = 0;
	i2 = 0;
	i3 = 0;
	i4 = 0;
	Shot1.Clear();
	Shot2.Clear();
	Shot3.Clear();
	Shot4.Clear();
	Animation1.Stop();
	Animation2.Stop();
	Animation3.Stop();
	Animation4.Stop();
	ShowMy = false;
	ShowPet = false;
			Me.KillTimer(1112);	
			Me.KillTimer(1113);	
			Me.KillTimer(1114);
			Me.KillTimer(1115);
			Me.KillTimer(1116);
			Me.KillTimer(1117);
			Me.KillTimer(1120);
			//	EquippedWeaponPrev.Clear();
}

function HandleSystemmsg(string param) 
{
    local int msg_idx;
	local string to,from;
 //   local int howmuch;
//	local array<string> summpetnames;
//    local string to,from,who;
//    local int howmuch;
//	local string summname, debuffcheck;
//	local array<string> summnames;
//	local string debuffs[15];
//	local int debuffsDmg[15], CubicPoisonDmg, CubicIcyAirDmg;
//	local int i;
//	local UserInfo eSumm;
//	local UserInfo myInfo;

//    local string points, wins, winrate, matches;
//	local int WR_percent;
//	local float fWR;

//	summpetnames[0] = "Mew the Cat";
//	summpetnames[1] = "Magnus the Unicorn";
//	summpetnames[2] = "Nightshade";
//	summpetnames[3] = "Kai the Cat";
//	summpetnames[4] = "Kat the Cat";
//	summpetnames[5] = "Boxer the Unicorn";
//	summpetnames[6] = "Imperial Phoenix";
//	summpetnames[7] = "Dark Panther";
//	summpetnames[8] = "Mechanic Golem";
//	summpetnames[9] = "Divine Beast";
//	summpetnames[10] = "Mirage the Unicorn";
//	summpetnames[11] = "Reanimated Man";
//	summpetnames[12] = "Feline King";
//	summpetnames[13] = "Unicorn Seraphim";
//	summpetnames[14] = "Feline Queen";
//	summpetnames[15] = "Silhouette";
//	summpetnames[16] = "Shadow"; 
////	summpetnames[17] = "Soulless";
//	summpetnames[18] = "Spectral Lord";
//	summpetnames[19] = "Merrow the Unicorn";
//	summpetnames[20] = "Corrupted Man";
//	summpetnames[21] = "Cursed Man";
//	summpetnames[22] = "Big Boom";
//	summpetnames[23] = "Fenrir";
	
	ParseInt(param, "Index", msg_idx);
	
	if ( msg_idx == 3108) // dvinulis s mesta pri vhode
	{
		isNowMove = true;
		EnterTheVoid();
	}
	
		if ( msg_idx == 1495) // otschet na oly
	{
		isUsedSoul = false;
		isUsedSpirit = false;
		isChargedtPetSoul = false;
		isChargedtPetSpirit = false;
		EnterTheVoid();
	}

	
	if ( msg_idx == 2261 || msg_idx == 2281)
	{
		ParseString(param,"Param1", from);
		ParseString(param,"Param2", to);
	}	
		
//	if ( ( msg_idx == 2261 || msg_idx == 2281) && (from == OwnName.GetName()))
//	{
//		isAttackingDmg=false;
//	}		
	
	
	
	if ( ( msg_idx == 2261 || msg_idx == 2281) && (from != OwnName.GetName()) && (to != OwnName.GetName()) && (ShowPet) && (isExistPetSoul))
	{	
		RequestUseItem(SumPetShot.ID);
		Me.SetTimer(1120, 1000);
//	AddSystemMessageString("Pet udaril kogo-to"); 
//	AddSystemMessageString(string(SumPetInfo.nSoulShotCosume));
		isChargedtPetSoul = false;
		ExecuteEvent(EV_UpdateUserInfo); 
//	 ParseInt(param,"Param3", howmuch);
	} 
//	AddSystemMessageString(string(msg_idx));
}




function bool isSoulSkill(int skillid)
{
	switch (skillid)
	{
		case 2039:
		case 2150:
		case 2151:
		case 2152:
		case 2153:
		case 2154:
			return true;
		default:
			return false;
		break;
	}
}

function bool isSpiritSkill(int skillid)
{
	switch (skillid)
	{
		case 2047:
		case 2061:
		case 2160:
		case 2161:
		case 2162:
		case 2163:
		case 2164:
			return true;
		default:
			return false;
		break;
	}
}

function bool isFizSkillNoSoul(int skillID)
{
	local bool	bisFizSkillNoSoul;
	bisFizSkillNoSoul = false;
	switch( skillID )
	{
		case 18://  Hate
		case 680:// Hate
		case 681:// Hate
		case 28:// Hate
		case 979:// Hate
		case 3080:// Hate
		case 3108:// Hate
		case 3109:// Hate
		case 3149:// Hate
		case 979:// Hate
		case 286:// Hate
		case 452:// Hate
		case 127:// Hamstring
		
		case 1539:// Stigma
		case 6090:// paral sk
		
		case 402:// arrest
		case 403:// shackle
		case 404:// mass
		
		case 619:// 
		case 810:// 
		case 811:// 
		case 812://  Vanguard
		case 813:// 
		case 838://
		case 839:
		
		case 92:// 
		case 352://  shield stun
		case 353:// 
		case 5683:
		case 5682:

		case 485:// 
		case 794://  
		case 484://  
		case 994:// 
//		case 793://  berserker
//		case 995://  
		case 501:// 
		case 833:// 
		case 503:// 
		case 522:// 
		case 502:// 
		case 5548:// 
		
		case 6813:// 
		case 6814:// 
		case 918:// 
		case 919://
		case 440://
		case 998://
		
		case 50:// 
		case 95://
		case 461://
		case 453:// 
		case 454:// 
		case 455:// 
		case 456:// 
		case 457://
		case 458://
		case 459://
		case 460://
		case 2046:
		case 5698:
		
		case 13://
		case 25://
		case 299://
		case 301://
		case 419:
		case 448:
		case 831:
		case 8250:
		case 2361:	// dwarf
		case 254:
		case 302:
		case 42:
		case 444:	
		case 1320:
		case 1321:
		case 1322:	
		case 34:
		case 9114:
		case 21242:
		case 21243:
		case 21244:
		
		case 767:
		case 2452:
		case 5565:		
		bisFizSkillNoSoul = true;
			 break;
	}	
	return bisFizSkillNoSoul;
}

function bool isCubicSkill(int skillID)
{
	local bool	bisCubicSkill;
	bisCubicSkill = false;
	switch( skillID )
	{
		case 4049:
		case 4050:
		case 4051:
		case 4052:
		case 4053:
		case 4054:
		case 4055:	
		case 4165: // icy air
		case 4164:
		case 4166:
		case 4338:
		case 5115:
		case 5116:
		case 5579:
		
		bisCubicSkill = true;
			 break;
	}	
	return bisCubicSkill;
}

function bool isItemSkill(int skillID)
{
	local bool	bisItemSkill;
	bisItemSkill = false;
	switch( skillID )
	{
		case 2498:
		case 9074:
		case 2288:
		case 2042:
		case 2043:
		case 2011:
		case 2031:
		case 2032:
		case 2034:
		case 2035:	
		case 2037: // etc
		case 2038:
		case 2165:
		case 2166:
		case 2169:
		case 2305:
		case 2335:
		case 2336:
		case 2337:
		case 2338:
		case 2339:
		case 2340:
		case 2395:
		case 2396:
		case 2397:
		case 2398:
		case 2402:
		case 2403:
		case 2593:
		case 9067:
		case 22055:
		case 9113:
		case 22042:
		case 22054:
		case 22223:
		case 22224:
		case 2013:
		case 2014:
		case 2286:
		case 2530:
		case 4380:
		case 6817:
		case 21011:
		case 21012:
		case 21013:
		case 21066:
		case 21084:
		case 2036:
		case 2040:
		case 2041:
		case 2049:
		case 2062:
		case 2170:
		case 2531:
		case 2099:
		case 2177:
		case 2178:
		case 2179:
		case 2320:
		case 2321:
		case 2364:
		case 2365:
		case 22103:
		case 2525:
		case 2289:
		case 2287:	//elixir
		bisItemSkill = true;
			 break;
	}	
	return bisItemSkill;
}

function bool isHerbSkill(int skillID)
{
	local bool	bisHerbSkill;
	bisHerbSkill = false;
	switch( skillID )
	{
		case 2244:
		case 2245:
		case 2246:
		case 2247:
		case 2278:
		case 2279:
		case 2280:		
		case 2281:
		case 2282:	//drop herbs
		case 2283:
		case 2284:
		case 2285:
		case 2485:
		case 2486:
		case 2512:
		case 2513:
		case 2514:
		case 2580:
		
		case 2900:
		case 2901:
		case 2902:	//hein herbs
		case 2903:
		case 2993:	// ?
		
		bisHerbSkill = true;
			 break;
	}	
	return bisHerbSkill;
}

function SkillCast (string a_Param)
{
	local int AttackerID;
	local int DefenderID;
	local int SkillID;
	local int SkillLevel;
	local float SkillHitTime;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	local UserInfo DefenderInfo;
	local int SkillHitTime_ms;

	ParseInt(a_Param,"AttackerID",AttackerID);
	ParseInt(a_Param,"DefenderID",DefenderID);
	ParseInt(a_Param,"SkillID",SkillID);
	ParseInt(a_Param,"SkillLevel",SkillLevel);
	ParseFloat(a_Param,"SkillHitTime",SkillHitTime);
	  
	if ( SkillHitTime > 0 )
		SkillHitTime_ms = int(SkillHitTime * 1000) + 200;
	else
		SkillHitTime_ms = 100;
	//sysDebug("1st time: "$SkillHitTime_ms);
	  
	GetUserInfo(AttackerID,AttackerInfo);
	GetUserInfo(DefenderID,DefenderInfo);
	GetPlayerInfo(PlayerInfo);
	GetPetInfo(SumPetInfo);
	//if	(PlayerInfo.nMagicCastingSpeed < 1000) SkillHitTime_ms = int(SkillHitTime * 1000) + 600;
	
	GetSkillInfo( SkillID, SkillLevel, UsedSkill );
//	PrintSkillInfo( UsedSkill);
	
	
	
//	PrintSkillInfo(UsedSkill);
	if ( SumPetInfo.nID == AttackerID && SkillID == 2033)
	{	
	isChargedtPetSoul = true;
//	AddSystemMessageString("isChargedtPetSoul");
	
	}
	
	if ( SumPetInfo.nID == AttackerID && SkillID == 2009)
	{	
	isChargedtPetSpirit = true;
//	AddSystemMessageString("isChargedtPetSpirit");	
	}
	

	
	
	
	
		
	if ( SumPetInfo.nID == AttackerID &&  UsedSkill.IsMagic == 1 && ShowPet)
	{	
//	isAttackingDmg = false;
	Me.SetTimer(1116, SkillHitTime_ms + 50);
	Me.SetTimer(1117, SkillHitTime_ms + 250);
//	AddSystemMessageString("timer suma cast " $ string(SkillHitTime_ms) );	
	}
	
	
	
	if ( PlayerInfo.nID != AttackerID) return;
	
	
	if (isCubicSkill(SkillID) || isHerbSkill(SkillID) || isItemSkill(skillID) || (!ShowMy) )
	{	
	return;
	}
	
	if ( PlayerInfo.nID == AttackerID && isFizSkillNoSoul(SkillID))
	{	
	return;
	}
	
	
	if (PlayerInfo.nID == AttackerID && UsedSkill.IsMagic == 0 && !UsedSkill.IsDebuff && UsedSkill.OperateType == 1)
	{	
	return;
	}
	
	
	if (PlayerInfo.nID == AttackerID && UsedSkill.IsMagic > 1)
	{	
	return;
	}

	if (PlayerInfo.nID == AttackerID && isSoulSkill(SkillID))
	{
		isUsedSoul = true;
	}
	
	if	(PlayerInfo.nID == AttackerID && isSpiritSkill(SkillID))
	{
		isUsedSpirit = true;
	}
//	if (PlayerInfo.nID == DefenderID && UsedSkill.IsMagic == 1 && !UsedSkill.IsDebuff && UsedSkill.OperateType == 1)
//	{	
//	AddSystemMessageString("MAG BUFF");
//	RequestUseItem(SpiritShot.ID);
//	return;
//	}
	//isAttacking = false;
	//isAttacking = false;
	
	if (PlayerInfo.nID == AttackerID && UsedSkill.IsMagic == 1) {RequestUseItem(SpiritShot.ID);}
	
	if (PlayerInfo.nID == AttackerID && !IsNotDisplaySkill(SkillID) && UsedSkill.IsMagic == 0)   // fiz skilli
	{
		//i = 0;
		//i2 = 0;
	isAttacking = false;	
		i3 = 0;
//		AddSystemMessageString("kill 1114 v FIZSKILLCAST");
		Me.KillTimer(1114);
//		Me.KillTimer(1113);
//	isAttackingDmg = false;
	isUsedSoul = false;
//	AddSystemMessageString("START 1114 v FIZSKILLCAST " $ string(SkillHitTime_ms));
//	AddSystemMessageString("START 1114 v FIZSKILLCAST " $ string(SkillHitTime));
	if ( (SkillHitTime*1000) <= 0 ) {Me.SetTimer(1114, 35); return;}
	
	if ( (SkillHitTime*1000) > 1500 ) {Me.SetTimer(1114, 150); return;}
	
	if ( (SkillHitTime*1000) > 700 ) {Me.SetTimer(1114, 100); return;}
	
	if ( (SkillHitTime*1000) > 0 ) {Me.SetTimer(1114, 50); return;}
	

		
//		isUsedSpirit = false;
		
		
//		Me.SetTimer(1113, SkillHitTime_ms - 150);

		//Me.SetTimer(1113, SkillHitTime_ms*1.5 - 200);
		//sysDebug("TIMER SET");
		//sysDebug("isUsedSoul"@ isUsedSoul);
		//sysDebug("isUsedSpirit"@ isUsedSpirit);
	}
	if (PlayerInfo.nID == AttackerID && !IsNotDisplaySkill(SkillID) && UsedSkill.IsMagic == 1) // mag skilli
	{
		i = 0;
		i2 = 0;
		i3 = 0;
//		isAttackingDmg = false;
//		AddSystemMessageString("kill 1112 v mAGSKILLCAST");
		Me.KillTimer(1112);
		Me.KillTimer(1113);
	//	isUsedSoul = false;
		isUsedSpirit = false;
		isAttacking = false;	
		Me.SetTimer(1112, SkillHitTime_ms + 50);
		Me.SetTimer(1113, SkillHitTime_ms - 150);
//		AddSystemMessageString("START 1112 v mAGSKILLCAST" $ string(SkillHitTime_ms+50));
		//Me.SetTimer(1113, SkillHitTime_ms*1.5 - 200);
		//sysDebug("TIMER SET");
		//sysDebug("isUsedSoul"@ isUsedSoul);
		//sysDebug("isUsedSpirit"@ isUsedSpirit);
	}
	else if (PlayerInfo.nID == AttackerID && isSoulSkill(SkillID))
	{
	//	isUsedSoul = true;
		//Me.KillTimer(1112);
		//AddSystemMessageString("DETECT USE SS and kill 1112");
		//sysDebug("TIMER STOPPED");
		//sysDebug("USED SOULSHOT");
	}
	else if	(PlayerInfo.nID == AttackerID && isSpiritSkill(SkillID))
	{
		isUsedSpirit = true;
		Me.KillTimer(1112);
		//sysDebug("TIMER STOPPED");
		//sysDebug("USED SPIRITSHOT");
	}	
	 
}

function Attack (string a_Param)
{
	local int AttackerID;
	local UserInfo PlayerInfo;
	local UserInfo AttackerInfo;
	//local PetInfo PetInfo;


	ParseInt(a_Param,"AttackerID",AttackerID);
	  
	GetUserInfo(AttackerID,AttackerInfo);
	GetPlayerInfo(PlayerInfo);
	attSpeed = PlayerInfo.nPhysicalAttackSpeed;
	isAttacking = true;
//	isAttackingDmg = true;
//	if (PlayerInfo.nID == AttackerID) isAttackingDmg = true;
	if ((PlayerInfo.nID == AttackerID) && (ShowMy))
	{
	//	AddSystemMessageString("DETECT ATTACK");
		//if (isExistSoul) RequestUseItem(SoulShot.ID);
		//AddSystemMessageString("KILL 1115 v ATTTACK");
		//Me.KillTimer(1115);
//		UsedSoul = false;
	//	isUsedSpirit = false;
		Me.SetTimer(1115, 50);
//		Me.SetTimer(1112, 50);
//		AddSystemMessageString("START 1115 v ATTTACK");
	}
}

function OnTimer(int TimerID)
{
	local UserInfo check;
	local int i1;
//	local


	if (GetPlayerInfo(check))
	{
		if (check.nCurHP <= 0)
		{
			Me.KillTimer(1112);	
			Me.KillTimer(1113);	
			Me.KillTimer(1114);
			Me.KillTimer(1115);
			Me.KillTimer(1116);
			Me.KillTimer(1117);
			Me.KillTimer(1120);
			return;
		}
	}
	
	if (GetPetInfo(SumPetInfo))
	{
		if (SumPetInfo.nCurHP <= 0)
		{
			Me.KillTimer(1116);
			Me.KillTimer(1117);
			Me.KillTimer(1120);
		}
	}
	
	

	switch (TimerID)
	{
		case 1112: // mag skilli

		//	AddSystemMessageString("1112 rabotaet");
			if ( isExistSpirit)// && !isAttacking && UsedSkill.IsMagic == 1)
	//		if (!isUsedSpirit && isExistSpirit)// && !isAttacking && UsedSkill.IsMagic == 1)
			{
				InvItem.GetItem(spiritIndex, SpiritShot);
				

				if ((SpiritShot.ItemNum > IntToInt64(0)) && (SpiritShot.ItemNum >= IntToInt64(EquippedWeapon.SpiritshotCount)))
				{

					RequestUseItem(SpiritShot.ID);
				//	AddSystemMessageString("1112 vnutri");
				}
				else
				{
					Animation2.Stop();
					Me.KillTimer(1113);
					Me.KillTimer(1112);
				}
				//sysDebug("REQUEST SPIRIT");
			}
	//		if (!isExistSpirit) Me.KillTimer(1112);
			
			Me.KillTimer(1112);	
			Me.SetTimer(1112, 50);
			if (!isExistSpirit) Me.KillTimer(1112);
		break;
	
		case 1113:   // na mag skilli esli posle kasta kast
		//if (i2==3) {Me.KillTimer(1113);AddSystemMessageString("VOSHLI NA VIHOD"); break;};
		//	AddSystemMessageString("1113 rabotaet");
			if (i>4) break;
			else 
			{
				for ( i1=i ; i1 < 5; ++i1 )
				{
					if (isExistSpirit && !isAttacking)// && ((UsedSkill.IsMagic == 1) || isUsedSpirit) )
					{
						InvItem.GetItem(spiritIndex, SpiritShot);

						if ((SpiritShot.ItemNum > IntToInt64(0)) && (SpiritShot.ItemNum >= IntToInt64(EquippedWeapon.SpiritshotCount)))
						{
					//		AddSystemMessageString("1113 vnutri");
							RequestUseItem(SpiritShot.ID);
							if (i==4) {i2=i2+1;}
						}
					else
						{
							Animation2.Stop();
							Me.KillTimer(1113);
							Me.KillTimer(1113);
							Me.KillTimer(1112);
							break;
						}
								//sysDebug("REQUEST SPIRIT");
					}
			
					i=i1;
					Me.KillTimer(1113);	
					if (i1<5) Me.SetTimer(1113, i1*50);
					if (i2==3)
						{
							Me.KillTimer(1113);
							Me.KillTimer(1112);
							isUsedSpirit = false;
	//						AddSystemMessageString("kill 1112  v 1113");
							break;
						}
				}
			if (!isExistSpirit) Me.KillTimer(1113);
			}
		
		break;
		
		case 1114:  // na fiz skilli
		//if (isExistSoul) RequestUseItem(SoulShot.ID);Me.KillTimer(1114);break;
		//	AddSystemMessageString("1114 rabotaet");
			if (isExistSoul && UsedSkill.IsMagic == 0  && (UsedSkill.OperateType < 2) )
			{
				InvItem.GetItem(soulIndex, SoulShot);
							
				if ((SoulShot.ItemNum > IntToInt64(0)) && (SoulShot.ItemNum >= IntToInt64(EquippedWeapon.SoulShotCount)))
				{

					RequestUseItem(SoulShot.ID);
			//		AddSystemMessageString("1114 vnutri");
					i3 = i3+1;
	//				AddSystemMessageString("SSS v 1114 - " $ string(i3));
				}
				else
				{
				//	Animation1.Stop();
					Me.KillTimer(1114);
				}
				if (i3==25)
				{
					i3=0;
					Me.KillTimer(1114);
	//				AddSystemMessageString("KILL 1114 v 1114");
					break;
				}	//sysDebug("REQUEST SOUL");
			}
		//	if (isUsedSoul) Me.KillTimer(1114);
		break;
		
		case 1115:  // na avtoattaku
		//if (isExistSoul) RequestUseItem(SoulShot.ID);Me.KillTimer(1114);break;
		//	AddSystemMessageString("1115 rabotaet");
			if (isExistSoul)
			{
				InvItem.GetItem(soulIndex, SoulShot);

				if ((SoulShot.ItemNum > IntToInt64(0)) && (SoulShot.ItemNum >= IntToInt64(EquippedWeapon.SoulShotCount)))
				{

					RequestUseItem(SoulShot.ID);
			//		AddSystemMessageString("1115 vnutri - " $ string(i4) $ "- " $ string(attSpeed));
					i4 = i4+1;
	//				AddSystemMessageString("SSS v 1115 - " $ string(i4));
				}
				else
				{
				//	Animation1.Stop();
					Me.KillTimer(1115);
					
				}
			if ((i4==10) && (attSpeed>=1000)) 	{i4=0;Me.KillTimer(1115);isUsedSoul = false;break;}
			if ((i4==20) && (attSpeed>=500))	{i4=0;Me.KillTimer(1115);isUsedSoul = false;break;}
			if ((i4==25) && (attSpeed>=400)) 	{i4=0;Me.KillTimer(1115);isUsedSoul = false;break;}
			if ((i4==30) && (attSpeed>=300)) 	{i4=0;Me.KillTimer(1115);isUsedSoul = false;break;}
			if ((i4==50) && (attSpeed>=0)) 		{i4=0;Me.KillTimer(1115);isUsedSoul = false;break;}
			//AddSystemMessageString("KILL 1115 v 1115");
				//sysDebug("REQUEST SOUL");//sysDebug("REQUEST SOUL");
			}
			if (!isExistSoul) Me.KillTimer(1115); //break;
		break;
			
		case 1116: 
		//	AddSystemMessageString("1116 rabotaet");
			if (isExistPetSpirit)
				{
				InvItem.GetItem(sumpetspiritIndex, SumPetSpiritShot);
		//		AddSystemMessageString("1116 vnutri");
				RequestUseItem(SumPetSpiritShot.ID);
				}
			isChargedtPetSpirit = false;
			Me.KillTimer(1116);
		break;	
		
		case 1117: 
		//	AddSystemMessageString("1117 rabotaet");
			if (isExistPetSpirit)
				{
				InvItem.GetItem(sumpetspiritIndex, SumPetSpiritShot);
		//		AddSystemMessageString("1117 vnutri");
				RequestUseItem(SumPetSpiritShot.ID);
				}
			isChargedtPetSpirit = false;
			Me.KillTimer(1117);
		break;
		
		case 1120:
		if ( (ShowPet) && (isExistPetSoul))
		{	
			RequestUseItem(SumPetShot.ID);
		}
		Me.KillTimer(1120);
		break;
	}
}


function bool GetEquippedWeapon()
{
	if (RHand.GetItem(0, EquippedWeapon))
		return true;
	else 
		return false;
}

function FindAllShotsByWeapGrade(int weapGrade)
{
	local ItemID SoulShotID;
	local ItemID SpiritShotID;
	
	SoulShotID.ClassID = GetSoulShotID(weapGrade);	
	SpiritShotID.ClassID = GetSpiritShotID(weapGrade);
	
	soulIndex = InvItem.FindItem( SoulShotID );
	if ((SoulShotID.ClassID == 5789) && (soulIndex == -1))
		{
			SoulShotID.ClassID = 1835;
			soulIndex = InvItem.FindItem( SoulShotID );
		}
	spiritIndex = InvItem.FindItem( SpiritShotID );
	if ((SpiritShotID.ClassID == 5790) && (spiritIndex == -1))
		{
			SpiritShotID.ClassID = 3947;
			spiritIndex = InvItem.FindItem(SpiritShotID);
		}
}

function FindAllSumPetShots()
{
	local ItemID SoulShotID;
	local ItemID SpiritShotID;
	
	SoulShotID.ClassID = 6645;
	SpiritShotID.ClassID = 6647;
	
	sumpetsoulIndex = SumPetItem.FindItem( SoulShotID );
	sumpetspiritIndex = SumPetItem.FindItem( SpiritShotID );
}

function int GetSpiritShotID(int weapGrade)
{
	switch (GetGradeByIndex(weapGrade))
	{
		case 'NOGRADE':
			return 5790;
		break;
		case 'D':
			return 3948;
		break;
		case 'C':
			return 3949;
		break;
		case 'B':
			return 3950;
		break;
		case 'A':
			return 3951;
		break;
		case 'S':
			return 3952;
		break;
	}
}

function int GetSoulShotID(int weapGrade)
{
	switch (GetGradeByIndex(weapGrade))
	{
		case 'NOGRADE':
			return 5789;
		break;
		case 'D':
			return 1463;
		break;
		case 'C':
			return 1464;
		break;
		case 'B':
			return 1465;
		break;
		case 'A':
			return 1466;
		break;
		case 'S':
			return 1467;
		break;
	}
}

function name GetGradeByIndex(int weapIndex)
{
	switch (weapIndex)
	{
		case 0:
			return 'NOGRADE';
		break;
		case 1:
			return 'D';
		break;
		case 2:
			return 'C';
		break;
		case 3:
			return 'B';
		break;
		case 4:
			return 'A';
		break;
		case 5:
		case 6:
		case 7:
			return 'S';
		break;
	}
}

function StartAnimInit()
{
	local AutoSouls script_as;
	script_as = AutoSouls(GetScript("AutoSouls"));
	if (Animation1.isShowWindow())
	{
		Animation1.SetTexture("L2_SkillTime.ToggleEffect.ToggleEffect001");
		Animation1.Stop();	
		Animation1.SetLoopCount(-1);
		Animation1.Play();
	}
	if (Animation2.isShowWindow())
	{
		Animation2.SetTexture("L2_SkillTime.ToggleEffect.ToggleEffect001");
		Animation2.Stop();	
		Animation2.SetLoopCount(-1);
		Animation2.Play();
	}
	if (Animation3.isShowWindow())
	{
		Animation3.SetTexture("L2_SkillTime.ToggleEffect.ToggleEffect001");
		Animation3.Stop();	
		Animation3.SetLoopCount(-1);
		Animation3.Play();
	}
	if (Animation4.isShowWindow())
	{
		Animation4.SetTexture("L2_SkillTime.ToggleEffect.ToggleEffect001");
		Animation4.Stop();	
		Animation4.SetLoopCount(-1);
		Animation4.Play();
	}
	if (script_as.AnimTex.isShowWindow())
	{
		script_as.AnimTex.SetTexture("L2_SkillTime.ToggleEffect.ToggleEffect001");
		script_as.AnimTex.Stop();	
		script_as.AnimTex.SetLoopCount(-1);
		script_as.AnimTex.Play();
	}
}


function StartAnimOne()
{
	
	Animation1.ShowWindow();
	StartAnimInit();
	isUsedSoul = false;
}

function StartAnimTwo()
{
	Animation2.ShowWindow();
	StartAnimInit();
	isUsedSpirit = false;
}

function StartAnimThree()
{
	Animation3.ShowWindow();
	StartAnimInit();
}

function StartAnimFour()
{
	Animation4.ShowWindow();
	StartAnimInit();
}

function StopOne()
{
	Animation1.Stop();
	Animation1.HideWindow();
	Shot1.Clear();
	isExistSoul = false;
}

function StopTwo()
{
	Animation2.Stop();
	Animation2.HideWindow();
	Shot2.Clear();
	isExistSpirit = false;
}

function StopThree()
{
	Animation3.Stop();
	Animation3.HideWindow();
	Shot3.Clear();
	isExistPetSoul = false;
}

function StopFour()
{
	Animation4.Stop();
	Animation4.HideWindow();
	Shot4.Clear();
	isExistPetSpirit = false;
}

function AddSoulShot(int index)
{
	local ItemInfo soulInfo;
	
	InvItem.GetItem(index, soulInfo);
	Shot1.Clear();
	Shot1.AddItem(soulInfo);
	
	if (soulInfo.ItemNum < IntToInt64(EquippedWeapon.SoulShotCount) || (!ShowMy))
		Animation1.HideWindow();
	
	if ((ShowMy) && (isNowMove) && (soulInfo.ItemNum >= IntToInt64(EquippedWeapon.SoulShotCount)))
	{	
		if (!Animation1.IsShowwindow()) StartAnimOne();
		if (!isUsedSoul) RequestAutoSoulShots(index);
		isExistSoul = true;
	}	
}

function AddSpiritShot(int index)
{
	local ItemInfo spiritInfo;
		
	InvItem.GetItem(index, spiritInfo);
	Shot2.Clear();
	Shot2.AddItem(spiritInfo);
	if (spiritInfo.ItemNum < IntToInt64(EquippedWeapon.SpiritShotCount) || (!ShowMy))
		Animation2.HideWindow();
	
	if ((ShowMy) && (isNowMove) && (spiritInfo.ItemNum >= IntToInt64(EquippedWeapon.SpiritShotCount)))
	{
		if (!Animation2.IsShowwindow()) StartAnimTwo();
		if (!isUsedSpirit) RequestAutoSoulShots(index);
		isExistSpirit = true;
	}
}

function RequestAutoSoulShots(int index)
{
	
	if (index == soulIndex)
	{
		InvItem.GetItem(index, SoulShot);
//		sysDebug("vhod v request1");
		RequestUseItem(SoulShot.ID);	
		isUsedSoul	= true;
	}
	else if (index == spiritIndex)
	{
		InvItem.GetItem(index, SpiritShot);
	//	sysDebug("vhod v request2");
		RequestUseItem(SpiritShot.ID);
		isUsedSpirit = true;
	}
}


function EnterTheVoid()
{
	
	if (GetEquippedWeapon())
	{
		
		if (EquippedWeapon != EquippedWeaponPrev) {isUsedSoul=false; isUsedSpirit=false;}
		EquippedWeaponPrev = EquippedWeapon;
		
			FindAllShotsByWeapGrade(EquippedWeapon.CrystalType);
		
			if (soulIndex != -1)
				AddSoulShot(soulIndex);
			else
				StopOne();
	
			if (spiritIndex != -1)
				AddSpiritShot(spiritIndex);	
			else
				StopTwo();
		
	}
	else
	{
		StopOne();
		StopTwo();
	}
	WeaponT = EquippedWeapon.WeaponType;
}

function EnterTheAbyss()
{
//	if (GetEquippedWeapon())
//	{
		//FindAllShotsByWeapGrade(EquippedWeapon.CrystalType);
		
		FindAllSumPetShots();
		if (sumpetsoulIndex != -1)
			AddSumPetSoulShot(sumpetsoulIndex);
		else
			
			StopThree();
	
		if (sumpetspiritIndex != -1)
			AddSumPetSpiritShot(sumpetspiritIndex);	
		else
			
			StopFour();
		

}

function AddSumPetSoulShot(int index)
{
	local ItemInfo soulInfo;
	
	SumPetItem.GetItem(index, soulInfo);
	Shot3.Clear();
	Shot3.AddItem(soulInfo);	

	if (soulInfo.ItemNum < IntToInt64(SumPetInfo.nSoulShotCosume) || (!ShowPet))
	{	
		Animation3.HideWindow();
		isExistPetSoul = false;

	}
	
	if ((isSumPetExist) && (ShowPet) && (soulInfo.ItemNum >= IntToInt64(SumPetInfo.nSoulShotCosume)))
	{

	if (!Animation3.IsShowwindow()) StartAnimThree();
	isExistPetSoul = true;
	if (!isChargedtPetSoul)  RequestAutoSumPetSoulShots(index);
	}
}

function AddSumPetSpiritShot(int index)
{
	local ItemInfo spiritInfo;
	
	SumPetItem.GetItem(index, spiritInfo);
	Shot4.Clear();
	Shot4.AddItem(spiritInfo);
	if (spiritInfo.ItemNum < IntToInt64(SumPetInfo.nSpiritShotConsume) || (!ShowPet))
	{	
		Animation4.HideWindow();
		isExistPetSpirit = false;
	}
	
	if ((isSumPetExist) && (ShowPet) && (spiritInfo.ItemNum >= IntToInt64(SumPetInfo.nSpiritShotConsume)))
	{
	if (!Animation4.IsShowwindow()) StartAnimFour();
	isExistPetSpirit = true;
	if (!isChargedtPetSpirit) RequestAutoSumPetSoulShots(index);
	}
//	isExistSpirit = true;
}

function RequestAutoSumPetSoulShots(int index)
{

	
	if (index == sumpetsoulIndex)
	{
		SumPetItem.GetItem(index, SumPetShot);
	//	sysDebug("vhod v request3");
		RequestUseItem(SumPetShot.ID);
	}
	else if (index == sumpetspiritIndex)
	{
		SumPetItem.GetItem(index, SumPetSpiritShot);
	//	sysDebug("vhod v request4");
		//sysDebug("GOT ITEM DATA - SPIRIT");
		RequestUseItem(SumPetSpiritShot.ID);
	}
}


function OnClickButtonWithHandle(ButtonHandle Button)
{
	switch (Button)
	{
		case AutoSSMy:
			if (ShowMy)
			{
				ShowMy = false;
				Animation1.Stop();
				Animation2.Stop();
				
			}
			else
			{
				ShowMy = true;
				isUsedSoul = false;
				isUsedSpirit = false;
			}
			ExecuteEvent(EV_UpdateUserInfo);
		break;
		case AutoSSPet:
			if (ShowPet)
			{
				ShowPet = false;
				Animation3.Stop();
				Animation4.Stop();
				Animation3.HideWindow();
				Animation4.HideWindow();
			}
			else
			{
				ShowPet = true;
				isChargedtPetSpirit = false;
				isChargedtPetSoul = false;
			}
			ExecuteEvent(EV_UpdateUserInfo);
		break;

	}
}
defaultproperties
{
}
