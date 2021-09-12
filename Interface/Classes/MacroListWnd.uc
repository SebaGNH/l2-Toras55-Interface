class MacroListWnd extends UICommonAPI;

const MACROCOMMAND_MAX_COUNT = 12;
const MACRO_MAX_COUNT = 48;
const MACRO_ICONANME = "L2UI.MacroWnd.Macro_Icon";

const TIMER_ID = 9001;
const TIMER2_ID = 9002;
const TIMER3_ID = 9003;

var WindowHandle Me;
var	ItemWindowHandle	m_macroItem;
var AnimTextureHandle texAutoUse;

var ButtonHandle btnAdd;
var ButtonHandle btnLock;
var ButtonHandle btnUnlock;

var bool m_bShow;
var ItemID m_DeleteItemID;
var int m_Max;

var bool cycleON;
var bool enterWorld;

var int cmdCount;
var int LineCount;
var int GAugSpeed;
var ItemID CycleID;
var string cmds[12];

var MacroPanelWnd script_macro;

function OnRegisterEvent()
{
	RegisterEvent( EV_DialogOK );	
	RegisterEvent(EV_MacroShowListWnd);
	RegisterEvent(EV_MacroUpdate);
	RegisterEvent(EV_MacroList);
	RegisterEvent(EV_ChatMessage);
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Me=GetHandle("MacroListWnd");
		m_macroItem	=  ItemWindowHandle(GetHandle("MacroListWnd.MacroItem"));
	}
	else
	{
		Me = GetWindowHandle( "MacroListWnd" );
		m_macroItem = GetItemWindowHandle("MacroListWnd.MacroItem");
	}
	

	m_bShow = false;
	cycleON = false;
	enterWorld = false;
	
	ClearItemID(m_DeleteItemID);
	ClearItemID(CycleID);
	
	cmdCount = 0;
	LineCount = 0;
		
	script_macro = MacroPanelWnd(GetScript("MacroPanelWnd"));
	texAutoUse = GetAnimTextureHandle( "MacroListWnd.texAutoUse" );
	btnLock = GetButtonHandle("MacroListWnd.btnLock");
	btnUnlock = GetButtonHandle("MacroListWnd.btnUnlock");
	btnAdd = GetButtonHandle("MacroListWnd.btnAdd");
	btnLock.SetTooltipCustomType(MakeTooltipSimpleText("Unlock panel"));
	btnUnlock.SetTooltipCustomType(MakeTooltipSimpleText("Lock panel"));
	btnAdd.SetTooltipCustomType(MakeTooltipSimpleText("Add macro"));
	texAutoUse.Stop();
	texAutoUse.HideWindow();
	HideWindow( "MacroListWnd.btnUnlock" );
}

function OnEnterState( name a_PreStateName )
{
	class'MacroAPI'.static.RequestMacroList();
}

function OnExitState( name a_NextStateName )
{
	enterWorld = false;
	if (cycleON )
	{
		ClearItemID(CycleID);
		cmdCount = 0;
		Me.KillTimer( TIMER_ID );
		Me.KillTimer( TIMER2_ID );
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

function OnClickButton( string strID )
{	
	switch( strID )
	{
	case "btnAdd":
		OnClickAdd();
		break;
	}
}

function OnEvent(int Event_ID, String param)
{
	if (Event_ID == EV_MacroShowListWnd)
	{
		HandleMacroShowListWnd();
	}
	else if (Event_ID == EV_MacroUpdate)
	{
		HandleMacroUpdate();
	}
	else if (Event_ID == EV_ChatMessage)
	{
		HandleChatMessage( param );
	}
	else if (Event_ID == EV_MacroList)
	{
		HandleMacroList(param);
	}
	else if (Event_ID == EV_DialogOK)
	{
		if (DialogIsMine())
		{
			if (IsValidItemID(m_DeleteItemID))
			{
				class'MacroAPI'.static.RequestDeleteMacro(m_DeleteItemID);
				ClearItemID(m_DeleteItemID);
				if(m_Max == 1)	//�ϳ����� ���� ���� ��� 0�� �ǹǷ� �ѹ� �������ش�. 
				{
					HandleMacroList("");// â�� �ѹ� �������ش�. //0�ϰ�쿡�� �������ָ� ��.
				}
			}
			
		}
	}
}


function HandleChatMessage( String param )
{
	local int SysMsgIndex;

	ParseInt(param, "SysMsgIndex", SysMsgIndex);
		
		if ( SysMsgIndex == 34 )
		{
			enterWorld = true;
			HandleMacroUpdate();
		}
}

//��ũ���� Ŭ��
function OnClickItem( string strID, int index )
{
	local ItemInfo 	infItem;
	
	if (strID == "MacroItem" && index>-1)
	{
		if (class'UIAPI_ITEMWINDOW'.static.GetItem("MacroListWnd.MacroItem", index, infItem))
		{
			class'MacroAPI'.static.RequestUseMacro(infItem.ID);
		}		
	}
}

function OnRClickItem( string strID, int index )
{
	local ItemInfo infItem;
	if ( !cycleON && !script_macro.cycleON)
	{
		if (strID == "MacroItem" && index>-1)
		{
			if (class'UIAPI_ITEMWINDOW'.static.GetItem("MacroListWnd.MacroItem", index, infItem))
			{
				if (infItem.IconName != "L2ui_ct1.emptyBtn")
				{
					if (int(class'UIAPI_EDITBOX'.static.GetString("FlexOptionWnd.AutoMacroDelay")) >= 0)
					GAugSpeed = int(class'UIAPI_EDITBOX'.static.GetString("FlexOptionWnd.AutoMacroDelay"));				
					CycleID = infItem.ID;
					MacroCycle( CycleID );
					m_macroItem.SetDraggable(false);
					cycleON = true;
					script_macro.cycleON = true;
					script_macro.texAutoUse.SetAnchor( "MacroPanelWnd.MacroScroll.MacroItem", "TopLeft", "TopLeft", 37 * ( index % 12 ) + 1, 36 * ( ( index - ( index % 12 ) ) / 12 ) + 1 );
					texAutoUse.SetAnchor( "MacroListWnd.MacroItem", "TopLeft", "TopLeft", 36 * ( index % 6 ) + 1, 36 * ( ( index - ( index % 6 ) ) / 6 ) + 1 );
					texAutoUse.Stop();
					script_macro.texAutoUse.Stop();
					texAutoUse.HideWindow();
					script_macro.texAutoUse.HideWindow();
					texAutoUse.SetLoopCount( -1 );
					script_macro.texAutoUse.SetLoopCount( -1 );
					texAutoUse.Play();
					script_macro.texAutoUse.Play();
					texAutoUse.ShowWindow();
					script_macro.texAutoUse.ShowWindow();
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
		script_macro.Me.KillTimer( TIMER_ID );
		script_macro.Me.KillTimer( TIMER2_ID );
		script_macro.Me.KillTimer( TIMER3_ID );
		cycleON = false;
		script_macro.cycleON = false;
		texAutoUse.Stop();
		script_macro.texAutoUse.Stop();
		texAutoUse.HideWindow();
		script_macro.texAutoUse.HideWindow();
		m_macroItem.SetDraggable(true);
	}
	
	
}

function MacroCycle( ItemID cID )
{
	local MacroInfo macroInf;
	local int idx;
	local int TimerDelay;
	local int MacroDelay;
	local string command;
	
	class'UIDATA_MACRO'.static.GetMacroInfo(cID, macroInf);

	LineCount = 0;
	MacroDelay = 0;

	for ( idx = 0; idx < 12; idx++ )
	{
		command = macroInf.CommandList[idx];
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
}

function ExecuteMacroLine(int idx, int count)
{
	local int ExtraTime;
	
	ExtraTime = 0;
	
	Me.KillTimer( TIMER2_ID );
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
	} else if ( TimerID == TIMER2_ID )
	{
		ExecuteMacroLine( cmdCount, LineCount );
	}
}

//�߰�
function OnClickAdd()
{
	class'UIAPI_MULTIEDITBOX'.static.SetString( "MacroInfoWnd.txtInfo", "");
	ExecuteEvent(EV_MacroShowEditWnd, "");
}

function int CheckEmpty()
{
	local int idx;
	local ItemInfo infItem;
	for (Idx=0; Idx < (MACRO_MAX_COUNT); Idx++)		
	{
		if (m_macroItem.GetItem(idx, infItem))
			if (infItem.IconName == "L2ui_ct1.emptyBtn")
			{
				return idx;
				break;
			}
	}
}

function HandleMacroUpdate()
{
	class'MacroAPI'.static.RequestMacroList();
}

function HandleMacroShowListWnd()
{
	if (m_bShow)
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		class'UIAPI_WINDOW'.static.HideWindow("MacroListWnd");
	}
	else
	{		
		PlayConsoleSound(IFST_WINDOW_OPEN);	
		class'UIAPI_WINDOW'.static.ShowWindow("MacroListWnd");
		class'UIAPI_WINDOW'.static.SetFocus("MacroListWnd");
	}
}

function Clear()
{
	class'UIAPI_ITEMWINDOW'.static.Clear("MacroListWnd.MacroItem");
}

function HandleMacroList(string param)
{
	local int Idx, i;
	local int Max;
	
	local string strIconName;
	local string strMacroName;
	local string strDescription;
	local string strTexture;
	local string macrosOrder;
	local string macrosIcon;
	local array<string> CommandList;
	
	local ItemInfo	infItem;
	local ItemInfo ClearItem;
	local MacroInfo macroInf;

	script_macro.Clear();
	Clear();
	ClearItemID( ClearItem.ID );	
	

	ParseInt(param, "Max", Max);
	
	m_Max = Max;	//�۷ι� �ƽ��� ���� -_-;;
	
	for (Idx=0; Idx < (MACRO_MAX_COUNT); Idx++)
	{
		ClearItem.IconName = "L2ui_ct1.emptyBtn";
		script_macro.m_macroItem.AddItem( ClearItem );
		m_macroItem.AddItem( ClearItem );
	}
	
	
	for (Idx=0; Idx<Max; Idx++)
	{
		strIconName = "";
		strMacroName = "";
		strDescription = "";
		strTexture = "";
		macrosIcon ="";
		macrosOrder ="";
		
		ParseItemIDWithIndex(param, infItem.ID, idx);
		ParseString(param, "IconName_" $ Idx, strIconName);
		ParseString(param, "MacroName_" $ Idx, strMacroName);
		ParseString(param, "Description_" $ Idx, strDescription);
		ParseString(param, "TextureName_" $ Idx, strTexture);
		ParseString(strDescription, "No", macrosOrder);
		ParseString(strDescription, "Ico", macrosIcon);
					
		if (( macrosOrder=="") && (macrosIcon ==""))
		{
			macrosOrder = string(idx);
			
			if (strTexture == "")
				macrosIcon = "1";		
			else
				macrosIcon = Right(strTexture, 1);
			
			infItem.Description = "No=" $ macrosOrder @ "Ico=" $ macrosIcon;
			
			class'UIDATA_MACRO'.static.GetMacroInfo(infItem.ID, macroInf);
			
			for (i=0; i<MACROCOMMAND_MAX_COUNT; i++)
			{
				CommandList.Insert(CommandList.Length, 1);
				CommandList[CommandList.Length-1] =  macroInf.CommandList[i];
			}						
			class'MacroAPI'.static.RequestMakeMacro(infItem.ID, strMacroName, strIconName, int(macrosIcon)-1, infItem.Description, CommandList);	
			return;
		}
		
		infItem.Name = strMacroName;
		infItem.IconName = MACRO_ICONANME $ macrosIcon;			
		infItem.AdditionalName = strIconName;
		infItem.Description = strDescription;
		infItem.Foretexture = "L2UI_CH3.etc.menu_outline";
		infItem.ItemSubType = int(EShortCutItemType.SCIT_MACRO);	

		script_macro.m_macroItem.SetItem(int(macrosOrder), infItem);
		m_macroItem.SetItem(int(macrosOrder), infItem);
	//	class'UIAPI_ITEMWINDOW'.static.SetItem("MacroPanelWnd.MacroScroll.MacroItem",int(macrosOrder), infItem);
	//	class'UIAPI_ITEMWINDOW'.static.SetItem("MacroListWnd.MacroItem",int(macrosOrder), infItem);
	}
		
	if ((Max == 0) && enterWorld)
	{
		ClearItemID( ClearItem.ID );
		for (i=0; i<MACROCOMMAND_MAX_COUNT; i++)
		{
			CommandList.Insert(CommandList.Length, 1);
			CommandList[CommandList.Length-1] =  "";
			if (i==0) CommandList[CommandList.Length-1] = "!Pagate el asado";
		}		
		class'MacroAPI'.static.RequestMakeMacro(ClearItem.ID, "Boiko#6678", "", 13, "No=0 Ico=16", CommandList);
	}
}

//Trash������������ DropITem
function OnDropItem( string strID, ItemInfo infItem, int x, int y)
{
	local int toIndex, fromIndex, i;
	local MacroInfo macroInfFrom, macroInfTo;
	local string macrosIconFrom, macrosIconTo;
	local array<string> CommandListFrom, CommandListTo;
	local ItemInfo infItemTo;
	switch( strID )
	{
	case "btnTrash":
		if (!cycleON) DeleteMacro(infItem);
		break;
	case "btnEdit":
		if (!cycleON) EditMacro(infItem);
		break;
	}
	
	if (( strID == "MacroItem" ) && (!cycleON))
	{
		if( infItem.DragSrcName == "MacroItem" )
		{
			toIndex = m_macroItem.GetIndexAt( x, y, 1, 1 );			
			if( toIndex >= 0 )
			{
				
				fromIndex = m_macroItem.FindItem(infItem.ID);
				if( toIndex != fromIndex )
				{
					m_macroItem.GetItem(toIndex, infItemTo);
					if (infItemTo.IconName != "L2ui_ct1.emptyBtn")
					{
						class'UIDATA_MACRO'.static.GetMacroInfo(infItemTo.ID, macroInfTo);
						ParseString(infItemTo.Description, "Ico", macrosIconTo);
						infItemTo.Description = "No=" $ string(fromIndex) @ "Ico=" $ macrosIconTo;
						for (i=0; i<MACROCOMMAND_MAX_COUNT; i++)
						{
							CommandListTo.Insert(CommandListTo.Length, 1);
							CommandListTo[CommandListTo.Length-1] =  macroInfTo.CommandList[i];
						}
					}
					
					m_macroItem.SwapItems(fromIndex, toIndex );
					
					ParseString(infItem.Description, "Ico", macrosIconFrom);
					infItem.Description = "No=" $ string(toIndex) @ "Ico=" $ macrosIconFrom;
				
					class'UIDATA_MACRO'.static.GetMacroInfo(infItem.ID, macroInfFrom);
				
					for (i=0; i<MACROCOMMAND_MAX_COUNT; i++)
					{
						CommandListFrom.Insert(CommandListFrom.Length, 1);
						CommandListFrom[CommandListFrom.Length-1] =  macroInfFrom.CommandList[i];
					}
				
					class'MacroAPI'.static.RequestMakeMacro(infItem.ID, macroInfFrom.Name, macroInfFrom.IconName, int(macrosIconFrom)-1, infItem.Description, CommandListFrom);

					
					if (infItemTo.IconName != "L2ui_ct1.emptyBtn")
					{
						class'MacroAPI'.static.RequestMakeMacro(infItemTo.ID, macroInfTo.Name, macroInfTo.IconName, int(macrosIconTo)-1, infItemTo.Description, CommandListTo);
					}
				}
			}
		}
	}
}

//��ũ�� ����
function DeleteMacro(ItemInfo infItem)
{
	local string strMsg;
	
	//��ũ�ΰ� �ƴϸ� �н�
	if (infItem.ItemSubType != int(EShortCutItemType.SCIT_MACRO))		
		return;			
	
	strMsg = MakeFullSystemMsg(GetSystemMessage(828), infItem.Name, "");
	m_DeleteItemID = infItem.ID;
	DialogShow(DIALOG_Modalless,DIALOG_Warning, strMsg);
}

//��ũ�� ����
function EditMacro(ItemInfo infItem)
{
	local string param;
	
	//��ũ�ΰ� �ƴϸ� �н�
	if (infItem.ItemSubType != int(EShortCutItemType.SCIT_MACRO))
		return;
	
	ParamAddItemID(param, infItem.ID);
	ExecuteEvent(EV_MacroShowEditWnd, param);
}

defaultproperties
{
}
