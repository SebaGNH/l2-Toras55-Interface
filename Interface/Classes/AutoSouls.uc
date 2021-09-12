class AutoSouls extends UICommonAPI;

var WindowHandle Me;
var AnimTextureHandle AnimTex;
var TextureHandle BG;
var ItemWindowHandle SoulsHandle;
var ItemWindowHandle InvItem;
var ItemWindowHandle InvItem2;

var bool BottlesExist;
var bool isPause;

function OnRegisterEvent()
{
	RegisterEvent(EV_GamingStateEnter);
	RegisterEvent(EV_AbnormalStatusEtcItem);
	RegisterEvent(EV_UpdateUserInfo);
}

function OnEvent(int EventID, string param)
{
	switch (EventID)
	{
		case EV_AbnormalStatusEtcItem:
			if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSouls") && (!isPause) &&
				class'UIAPI_WINDOW'.static.IsEnableWindow("FlexOptionWnd.enableAutoSouls")) 
			{
				UseBottles(param);
			}
		break;
		case EV_GamingStateEnter:
			if (IsKamael())
			{
				class'UIAPI_WINDOW'.static.EnableWindow("FlexOptionWnd.enableAutoSouls");
				isPause = true;
			}
			else
				class'UIAPI_WINDOW'.static.DisableWindow("FlexOptionWnd.enableAutoSouls");			
		break;
		case EV_UpdateUserInfo:
			if (GetUIState() == "GAMINGSTATE" && 
				class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAutoSouls") &&
				class'UIAPI_WINDOW'.static.IsEnableWindow("FlexOptionWnd.enableAutoSouls"))
				CheckBottles();
		break;

	}
}

function OnLoad()
{
	InitHandles();
}

function InitHandles()
{
	Me = GetWindowHandle("AutoSouls");
	AnimTex = GetAnimTextureHandle("AutoSouls.AnimTex");
	SoulsHandle = GetItemWindowHandle("AutoSouls.SoulItem");
	InvItem = GetItemWindowHandle("InventoryWnd.InventoryItem");
	InvItem2 = GetItemWindowHandle("InventoryWnd.InventoryItem");
	BG = GetTextureHandle("InventoryWnd.BGSouls");
}

function OnShow()
{
	if (IsKamael())
	{
		SetPosition();
		class'UIAPI_WINDOW'.static.EnableWindow("FlexOptionWnd.enableAutoSouls");
		CheckBottles();
	}
	else
	{
		Me.HideWindow();
		class'UIAPI_WINDOW'.static.DisableWindow("FlexOptionWnd.enableAutoSouls");
	}
	
}

function OnHide()
{
	ClearOnNoItems();
}


function OnClickItem( String strID, int index )
{
	local ItemInfo info;
	local ItemID SoulBottleID;
	local int bottleindex;
	
	if  (strID == "SoulItem")
	{
		SoulBottleID.ClassID = 10410;
		bottleindex = InvItem.FindItemByClassID(SoulBottleID);
	//	AddSystemMessageString("NAJAli vhod" $ string(isPause)); 
		if (bottleindex > -1)
		{
			if (isPause)
				isPause = false;
			else
				isPause = true;				
		}
		else
		{	
			isPause = true;	
		}	
	//	AddSystemMessageString("NAJAli vihod" $ string(isPause)); 

		InvItem.GetItem( InvItem.FindItemByClassID(SoulBottleID), info );
			if (info.ItemNum > IntToInt64(0))
			{
				if  (!isPause) 
				{	
				RequestUseItem(info.ID);
			//	AddSystemMessageString("bottl po kliku"); 
				
				}
			}
	
		SoulsHandle.Clear();
		CheckBottles();		
		if 	(isPause) StopAnim(AnimTex);
	}
	
}


function bool IsKamael()
{
	local UserInfo info;

	GetPlayerInfo(info);
	switch (info.nSubClass)
	{
		case 123:
		case 124:
		case 127:
		case 128:
		case 129:
		case 130:
		case 131:
		case 132:
		case 133:
		case 134:
		case 135:
		case 136:
			return true;
		break;
		default:
			return false;
		break;
	}	
}

function CheckBottles()
{
	local ItemID SoulBottleID;
	local ItemInfo info;
	local int index;
	SoulBottleID.ClassID = 10410;

	index = InvItem2.FindItemByClassID(SoulBottleID);

	if (index > -1)
	{
		SoulsHandle.Clear();
		//AddSystemMessageString("index correct");
		if (!SoulsHandle.GetItem(0, info))
		{
			InvItem2.GetItem(index, info);
			SoulsHandle.Clear();
			SoulsHandle.AddItem(info);
	//		AddSystemMessageString("check bottl 1");
			BG.HideWindow();
			if (!isPause && !AnimTex.isShowWindow())
			{
			StartAnim(AnimTex);
	//		AddSystemMessageString("check bottl 2");
			}
		}
	}
	else
	{
	//	AddSystemMessageString("index incorrect");
		if (SoulsHandle.GetItem(0, info))
		{
	//		AddSystemMessageString("check bottl 3");
			SoulsHandle.Clear();
			BG.ShowWindow();
			StopAnim(AnimTex);
		}
	}
}

function UseBottles(string param)
{
	local ItemInfo info;
	local StatusIconInfo infoIcon;
	local ItemID SoulBottleID;
	
	local int soulCount;
	local int idx;
	local int tempMaxRange;
	local int Max;

	SoulBottleID.ClassID = 10410;
	
	ParseInt(param, "Max", Max);
	for (idx = 0; idx < Max; idx++)
	{
		ParseItemIDWithIndex(param, infoIcon.ID, idx);
		ParseInt(param, "SkillLevel_" $ idx, infoIcon.Level);
		ParseString(param, "Name_" $ idx, infoIcon.Name);
		
		if (infoIcon.ID.ClassID == 5446)
		{
			soulCount = infoIcon.Level;
			break;
		}
	}
	
	if ( soulCount < 10 && soulCount != 0)
	{
		tempMaxRange = (40 / 5 - 1);
		for (idx = 0; idx < tempMaxRange; idx++)
		{
			InvItem.GetItem( InvItem.FindItemByClassID(SoulBottleID), info );
			if (info.ItemNum > IntToInt64(0))
			{
				RequestUseItem(info.ID);
	//			AddSystemMessageString("use bottl");
			}
			else
			{
				CheckBottles();
				break;
			}		
		}
	}
}

function ClearOnNoItems()
{
	SoulsHandle.Clear();
	BG.ShowWindow();
	StopAnim(AnimTex);
}

function StartAnim(AnimTextureHandle handle)
{
	local AutoSS scipt_ass;
	scipt_ass = AutoSS(GetScript("AutoSS"));

	handle.ShowWindow();
	scipt_ass.StartAnimInit();
}

function StopAnim(AnimTextureHandle handle)
{
	handle.Stop();
	handle.HideWindow();
	
}

function SetPosition()
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

//	if (class'UIAPI_WINDOW'.static.IsShowWindow("AutoSS"))
//	{
//	if (!isVertical)
//	{
//			Me.SetAnchor("AutoSS", "TopRight", "TopLeft", 6, 0);
//			return;
//		}
//		else
//		{
//			Me.SetAnchor("AutoSS", "BottomLeft", "TopLeft", 0, 6);
//			return;
	//	}
//	}
	
	if (!isVertical)
	{		
		if (IsExpand5)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndHorizontal_5", -2, -30);
		}	
		else if (IsExpand4)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndHorizontal_4", -2, -30);
		}
			
		else if (IsExpand3)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndHorizontal_3", -2, -30);
		}
		else if (IsExpand2)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndHorizontal_2", -2, -30);
		}
			
		else if (IsExpand1)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndHorizontal_1", -2, -30);
		}
			
		else
		{
			AnchorSouls("ShortcutWnd.ShortcutWndHorizontal", -2, -30);
		}
	}
	else
	{	
		if (IsExpand5)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndVertical_5", -50, 462);
		}	
		else if (IsExpand4)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndVertical_4", -50, 462);
		}
			
		else if (IsExpand3)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndVertical_3", -50, 462);
		}
		else if (IsExpand2)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndVertical_2", -50, 462);
		}
			
		else if (IsExpand1)
		{
			AnchorSouls("ShortcutWnd.ShortcutWndVertical_1", -50, 462);
		}
			
		else
		{
			AnchorSouls("ShortcutWnd.ShortcutWndVertical", -50, 462);
		}
	}
	
}

function AnchorSouls(string window, int x, int y)
{
	Me.SetAnchor(window, "TopRight", "TopRight", x, y);
}
defaultproperties
{
}
