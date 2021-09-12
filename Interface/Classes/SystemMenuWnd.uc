class SystemMenuWnd extends UICommonAPI;

var WindowHandle m_hOptionWnd;
var WindowHandle PostBoxWnd;
var TextBoxHandle m_hTbMacro;

var WindowHandle ProductInventoryWnd;

var int IsPeaceZone;		//현재 지역 PeaceZone인가

const DIALOGID_Gohome = 0;

function OnRegisterEvent()
{
	RegisterEvent( EV_LanguageChanged );
	RegisterEvent( EV_SetRadarZoneCode );
	RegisterEvent( EV_DialogOK );
	RegisterEvent( EV_DialogCancel );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		m_hOptionWnd=GetHandle("OptionWnd");
		m_hTbMacro=TextBoxHandle(GetHandle("SystemMenuWnd.txtMacro"));
		PostBoxWnd=GetHandle("PostBoxWnd");
		ProductInventoryWnd = GetHandle("ProductInventoryWnd");
	}
	else
	{
		m_hOptionWnd=GetWindowHandle("OptionWnd");
		m_hTbMacro=GetTextBoxHandle("SystemMenuWnd.txtMacro");
		PostBoxWnd=GetWindowHandle("PostBoxWnd");
		ProductInventoryWnd = GetWindowHandle("ProductInventoryWnd");
	}

	SetMenuString();
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnProductInventory" :		
		HideWindow("SystemMenuWnd");
		HandleShowProductInventory();
		break;
	case "btnPost":
		HideWindow("SystemMenuWnd");
		HandleShowPostBoxWnd();
		break;
	case "btnMacro":
		HideWindow("SystemMenuWnd");
		HandleShowMacroListWnd();
		break;
	case "btnOption":
		HideWindow("SystemMenuWnd");
		HandleShowOptionWnd();
		break;
	case "btnRestart":
		HideWindow("SystemMenuWnd");
		ExecuteEvent(EV_OpenDialogRestart);
		break;
	case "btnQuit":
		HideWindow("SystemMenuWnd");
		ExecuteEvent(EV_OpenDialogQuit);
		break;
	case "btnDEADZ":
		if (class'UIAPI_WINDOW'.static.IsShowWindow("FlexOptionWnd"))
			{HideWindow("SystemMenuWnd");
			class'UIAPI_WINDOW'.static.HideWindow("FlexOptionWnd");}
		else
			{HideWindow("SystemMenuWnd");
			class'UIAPI_WINDOW'.static.ShowWindow("FlexOptionWnd");}
		break;
	}
}

function OnEvent(int Event_ID, String param)
{
	local int zonetype;
	if( Event_ID == EV_LanguageChanged )
	{
		SetMenuString();
	}
	else if ( Event_ID == EV_SetRadarZoneCode )
	{
		ParseInt( param, "ZoneCode", zonetype );		
		if (zonetype == 12)
		{
			IsPeaceZone = 1;
		}
		else
		{
			IsPeaceZone = 0;
		}
	}
	else if( Event_ID == EV_DialogOK )
	{
		HandleDialogOK();
	}
	else if( Event_ID == EV_DialogCancel )
	{
		
	}
}

//상품 인벤토리 열기
function HandleShowProductInventory()
{
	if( ProductInventoryWnd.IsShowWindow() )
	{
		ProductInventoryWnd.HideWindow();
	}
	else
	{
		if( ! class'UIAPI_WINDOW'.static.IsShowWindow("ShopWnd") )	
		{
			ProductInventoryWnd.ShowWindow();
			ProductInventoryWnd.SetFocus();
		}
	}
}


//홈페이지 링크(10.1.18 문선준 추가)
function HandleDialogOK()
{
	if( !DialogIsMine() )
		return;

	switch( DialogGetID() )
	{
	case DIALOGID_Gohome:
		OpenL2Home();
		break;
	}
}



function HandleShowPostBoxWnd()
{
	if( PostBoxWnd.isShowWindow())
	{
		PostBoxWnd.HideWindow();
	}
	else
	{
		RequestRequestReceivedPostList();
		if (IsPeaceZone == 0)
			AddSystemMessage(3066);
	}

}

function HandleShowMacroListWnd()
{
	ExecuteEvent(EV_MacroShowListWnd);
}


function HandleShowOptionWnd()
{
	if (m_hOptionWnd.IsShowWindow())
	{
		PlayConsoleSound(IFST_WINDOW_CLOSE);
		m_hOptionWnd.HideWindow();
	}
	else
	{
		PlayConsoleSound(IFST_WINDOW_OPEN);
		m_hOptionWnd.ShowWindow();
		m_hOptionWnd.SetFocus();
	}
}

function SetMenuString()
{
	//단축키 붙여주기
	m_hTbMacro.SetText(GetSystemString(711) $ "(Alt+R)");
}
defaultproperties
{
}
