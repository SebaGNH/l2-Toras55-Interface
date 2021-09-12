class MacroPanelWnd extends UICommonAPI;

const MACROCOMMAND_MAX_COUNT = 12;
const MACRO_MAX_COUNT = 48;
const MACRO_ICONANME = "L2UI.MacroWnd.Macro_Icon";

const TIMER_ID = 9001;
const TIMER2_ID = 9002;
const TIMER3_ID = 9003;

var WindowHandle Me;
var	ItemWindowHandle	m_macroItem;
var AnimTextureHandle texAutoUse;


var bool m_bShow;
var ItemID m_DeleteItemID;
var int m_Max;

var bool cycleON;
var bool isLock;
var bool enterWorld;

var int cmdCount;
var int LineCount;
var int GAugSpeed;
var ItemID CycleID;
var string cmds[12];

var int globalIndex;
var int globalIdx;
var ItemInfo globalInfo;
var MacroInfo globalMacro;

var MacroListWnd script_macrolist;

function OnRegisterEvent()
{
	RegisterEvent(EV_ReceiveMagicSkillUse);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me=GetHandle("MacroPanelWnd");
		m_macroItem	=  ItemWindowHandle(GetHandle("MacroPanelWnd.MacroScroll.MacroItem"));
	}
	else
	{
		Me = GetWindowHandle( "MacroPanelWnd" );
		m_macroItem = GetItemWindowHandle("MacroPanelWnd.MacroScroll.MacroItem");
	}
	
	script_macrolist = MacroListWnd(GetScript("MacroListWnd"));
	
	m_bShow = false;
	cycleON = false;
	enterWorld = false;
	isLock = true;
	
	ClearItemID(m_DeleteItemID);
	ClearItemID(CycleID);
	
	cmdCount = 0;
	LineCount = 0;	
	texAutoUse = GetAnimTextureHandle( "MacroPanelWnd.MacroScroll.texAutoUse" );	
	texAutoUse.Stop();
	texAutoUse.HideWindow();
	
	//m_macroItem.SetScrollBarPosition( 0, 0, 0 );
	//HideWindow( "MacroPanelWnd.btnUnlock" );
}


function OnExitState( name a_NextStateName )
{
	enterWorld = false;
	if (cycleON )
	{
	//	class'UIAPI_WINDOW'.static.EnableWindow("MacroListWnd.AutoSpeedEdit");
		ClearItemID(CycleID);
		cmdCount = 0;
		Me.KillTimer( TIMER_ID );
		Me.KillTimer( TIMER2_ID );
		Me.KillTimer( TIMER3_ID );
		cycleON = false;
		texAutoUse.Stop();
		texAutoUse.HideWindow();
	}
}


function OnShow()
{
	m_bShow = true;
}
	
function OnHide()
{
	m_bShow = false;

}



function OnEvent(int Event_ID, String param)
{
	
  if (Event_ID == EV_ReceiveMagicSkillUse)
		if (GetUIState() == "GAMINGSTATE")
			if (class'UIAPI_CHECKBOX'.static.IsChecked("FlexOptionWnd.enableAnimMacro"))
				if (script_macrolist.cycleON && cycleON)
					HandleReceiveMagicSkillUse(param);
}

function HandleReceiveMagicSkillUse (string a_Param)
{
	local int AttackerID;
	local int SkillID;
	local int SkillLevel;
	local float SkillHitTime;
  local UserInfo PlayerInfo;
  local UserInfo AttackerInfo;
  local ItemInfo infItem;

  local SkillInfo UsedSkillInfo;
  local int SkillHitTime_ms;


  ParseInt(a_Param,"AttackerID",AttackerID);

  ParseInt(a_Param,"SkillID",SkillID);
  ParseInt(a_Param,"SkillLevel",SkillLevel);
  ParseFloat(a_Param,"SkillHitTime",SkillHitTime);
  
  if ( SkillHitTime > 0 )
  {
    SkillHitTime_ms = int(SkillHitTime * 1000) + 300;
  } else 
  {
    SkillHitTime_ms = 100;
  }
  
  GetUserInfo(AttackerID,AttackerInfo);

  GetPlayerInfo(PlayerInfo);

  GetSkillInfo(SkillID,SkillLevel,UsedSkillInfo);


	infItem.Description = UsedSkillInfo.SkillName @ "[line: " $ string(globalIdx+1) $"]";
	infItem.ID.ClassID = SkillID;
	infItem.Level = UsedSkillInfo.SkillLevel;
	infItem.Name = globalInfo.Name;
	infItem.Foretexture = "L2UI_CH3.etc.menu_outline";
	infItem.AdditionalName = UsedSkillInfo.EnchantName;
	infItem.IconName = UsedSkillInfo.TexName;
	infItem.IconPanel = UsedSkillInfo.IconPanel;
	infItem.ItemSubType = int(EShortCutItemType.SCIT_SKILL);

	if (  !IsNotDisplaySkill(SkillID) && (AttackerID == PlayerInfo.nID) && cycleON)
	{
		class'UIAPI_ITEMWINDOW'.static.SetItem("MacroPanelWnd.MacroScroll.MacroItem",globalIndex, infItem);
		Me.KillTimer(TIMER3_ID);
		Me.SetTimer( TIMER3_ID, SkillHitTime_ms + 300);
	}		
}


//매크로의 클릭
function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	
	if (strID == "MacroItem" && index>-1)
	{
		if (class'UIAPI_ITEMWINDOW'.static.GetItem("MacroPanelWnd.MacroScroll.MacroItem", index, infItem))
		{
			class'MacroAPI'.static.RequestUseMacro(infItem.ID);
		}		
	}
}

function OnRClickItem( string strID, int index )
{
	if ( !cycleON )
	{
		if (strID == "MacroItem" && index>-1)
		{
			if (class'UIAPI_ITEMWINDOW'.static.GetItem("MacroPanelWnd.MacroScroll.MacroItem", index, globalInfo))
			{
				if (globalInfo.IconName != "L2ui_ct1.emptyBtn")
				{
					if (int(class'UIAPI_EDITBOX'.static.GetString("FlexOptionWnd.AutoMacroDelay")) >= 0)
					GAugSpeed = int(class'UIAPI_EDITBOX'.static.GetString("FlexOptionWnd.AutoMacroDelay"));				
					CycleID = globalInfo.ID;
					globalIndex = index;
					MacroCycle( CycleID );
					cycleON = true;	
					script_macrolist.m_macroItem.SetDraggable(false);
					script_macrolist.cycleON = true;
					texAutoUse.SetAnchor( "MacroPanelWnd.MacroScroll.MacroItem", "TopLeft", "TopLeft", 37 * ( index % 12 ) + 1, 36 * ( ( index - ( index % 12 ) ) / 12 ) + 1 );
					script_macrolist.texAutoUse.SetAnchor( "MacroListWnd.MacroItem", "TopLeft", "TopLeft", 36 * ( index % 6 ) + 1, 36 * ( ( index - ( index % 6 ) ) / 6 ) + 1 );
					texAutoUse.Stop();
					script_macrolist.texAutoUse.Stop();
					texAutoUse.HideWindow();
					script_macrolist.texAutoUse.HideWindow();
					texAutoUse.SetLoopCount( -1 );
					script_macrolist.texAutoUse.SetLoopCount( -1 );
					texAutoUse.Play();
					script_macrolist.texAutoUse.Play();
					texAutoUse.ShowWindow();
					script_macrolist.texAutoUse.ShowWindow();
				}
			}
		}
	}
	else
	{
		ClearItemID(CycleID);
		cmdCount = 0;
		Me.KillTimer( TIMER_ID );
		Me.KillTimer( TIMER2_ID );
		Me.KillTimer( TIMER3_ID );
		class'UIAPI_ITEMWINDOW'.static.SetItem("MacroPanelWnd.MacroScroll.MacroItem",globalIndex, globalInfo);
		script_macrolist.Me.KillTimer( TIMER_ID );
		script_macrolist.Me.KillTimer( TIMER2_ID );
		script_macrolist.m_macroItem.SetDraggable(true);
		cycleON = false;
		script_macrolist.cycleON = false;
		texAutoUse.Stop();
		script_macrolist.texAutoUse.Stop();
		texAutoUse.HideWindow();
		script_macrolist.texAutoUse.HideWindow();
	}
	
	
}

function MacroCycle( ItemID cID )
{	
	local int idx;
	local int TimerDelay;
	local int MacroDelay;
	local string command;
	
	class'UIDATA_MACRO'.static.GetMacroInfo(cID, globalMacro);

	LineCount = 0;
	MacroDelay = 0;

	for ( idx = 0; idx < 12; idx++ )
	{
		command = globalMacro.CommandList[idx];
		cmds[idx] = command;

		if ( command != "" )
		{
			LineCount += 1;
		}
		
		if ( InStr( command, "/delay" ) > -1 )
		{
			MacroDelay += int( Mid ( command, 7 ) ) * 1000;
		}
	}
	
	TimerDelay = (GAugSpeed * LineCount + MacroDelay);
	ExecuteMacroLine( 0, LineCount );
	Me.KillTimer( TIMER_ID );
	Me.SetTimer( TIMER_ID, TimerDelay + GAugSpeed );	
	Me.KillTimer( TIMER3_ID );
	class'UIAPI_ITEMWINDOW'.static.SetItem("MacroPanelWnd.MacroScroll.MacroItem",globalIndex, globalInfo);
}

function ExecuteMacroLine(int idx, int count)
{
	local int ExtraTime;
	
	ExtraTime = 0;	
	Me.KillTimer( TIMER2_ID );
	globalIdx = idx;
	if ( InStr( cmds[idx], "/delay" ) > -1 )
	{
		ExtraTime  = int( Mid ( cmds[idx], 7 ) ) * 1000;
	}
	else
	{
		ExecuteCommand( cmds[idx] );	
	}
	cmdCount += 1;
	Me.SetTimer( TIMER2_ID, GAugSpeed + ExtraTime );
	
	if (cmdCount > count)
	{
		cmdCount = 0;
		Me.KillTimer( TIMER2_ID );
	}	
}

function OnTimer( int TimerID )
{
	if ( TimerID == TIMER_ID )
	{
		Me.KillTimer( TIMER_ID );
		MacroCycle( CycleID );
	}
	else 
		if ( TimerID == TIMER2_ID )
		{
			ExecuteMacroLine( cmdCount, LineCount );
		}
		else 
			if ( TimerID == TIMER3_ID )
			{
				class'UIAPI_ITEMWINDOW'.static.SetItem("MacroPanelWnd.MacroScroll.MacroItem",globalIndex, globalInfo);
			}
}


function Clear()
{
	class'UIAPI_ITEMWINDOW'.static.Clear("MacroPanelWnd.MacroScroll.MacroItem");
}

defaultproperties
{
}
