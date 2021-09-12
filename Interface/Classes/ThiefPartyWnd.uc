class ThiefPartyWnd extends PartyMatchWndCommon;

//HandleList
var WindowHandle Me;
var ListCtrlHandle ThiefLst;
var ButtonHandle RefreshBtn;
var TextBoxHandle TestText;
var int CUR_PAGE;
var int MAX_LEVEL;
const               MAXMEMBER = 12;
//var int opn;

function InitHandle()
{
	Me = GetWindowHandle("ThiefPartyWnd");
	ThiefLst = GetListCtrlHandle( "ThiefPartyWnd.ThiefList" );
	TestText = GetTextBoxHandle( "ThiefPartyWnd.TestText" );
	RefreshBtn = GetButtonHandle( "ThiefPartyWnd.RefreshButton" );
	
}


function OnRegisterEvent()
{
	RegisterEvent( EV_PartyMatchList );
	RegisterEvent(EV_PartyMatchStart);
	RegisterEvent( EV_UsePartyMatchAction );
//	RegisterEvent( EV_StateChanged );
}

function OnLoad()
{
	InitHandle();

}



function OnShow()

{
	ThiefLst.HideWindow();
	TestText.ShowWindow();
	
//		local PartyMatchWnd Script;
//	local UserInfo PlayerInfo;

//	Script = PartyMatchWnd( GetScript( "PartyMatchWnd" ) );
//	switch( a_strButtonName )
//	{
	//	case "RefreshButton":
//			ExecuteEvent(EV_PartyMatchStart);
//	ExecuteEvent(EV_PartyMatchList);
	//	class'PartyMatchAPI'.static.RequestOpenPartyMatch();
	//		class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
//	class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchWnd");
//	Script.RequestPartyRoomListLocal( 1 );
//	opn = 1;
//	class'PartyMatchAPI'.static.RequestOpenPartyMatch();
//	class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
//	class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchWnd");
//	ExecuteEvent(EV_PartyMatchStart);
	//ExecuteEvent(EV_PartyMatchList);
}





function OnEvent(int a_EventID, String param)
{
	//AddSystemMessageString(String( a_EventID )@ "thief");
	switch( a_EventID )
	{
	case EV_PartyMatchList:
	//	AddSystemMessageString("EV_PartyMatchList");
		HandlePartyMatchList(param);
		break;
	case EV_PartyMatchStart:
//		AddSystemMessageString("EV_PartyMatchStart");
//		HandlePartyMatchList(param);
		break;
		
//	case EV_StateChanged:
//		AddSystemMessageString(GetGameStateName());
//	break;
	}
}


function HandlePartyMatchList(string param)
{
	local int Count;
	local int i;
	local LVDataRecord Record;
	local int Number;
	local String PartyRoomName;
	local String PartyLeader;
	local int ZoneID;
	local int MinLevel;
	local int MaxLevel;
	local int MinMemberCnt;
	local int MaxMemberCnt;

	//선준 수정(2010.02.22 ~ 03.08) 완료
	local int j;
	local int MemberCnt;
	local int MemberClassID;
	local string MemberName;
	local LVData data1;

	TestText.SetText("");
	TestText.SetText(param);
	ThiefLst.DeleteAllItem();
	//선준 수정(2010.02.22 ~ 03.08) 완료
	Record.LVDataList.length = 7 + ( MAXMEMBER / 2 );

	ParseInt(param, "PageNum", CUR_PAGE);
	ParseInt(param, "RoomCount", Count);
	for( i = 0; i < Count; ++i )
	{
		ParseInt(param, "RoomNum_" $ i, Number);
		ParseString(param, "Leader_" $ i, PartyLeader);
		ParseInt(param, "ZoneID_" $ i, ZoneID);	
		ParseInt(param, "MinLevel_" $ i, MinLevel);
		ParseInt(param, "MaxLevel_" $ i, MaxLevel);
		ParseInt(param, "CurMember_" $ i, MinMemberCnt);
		ParseInt(param, "MaxMember_" $ i, MaxMemberCnt);
		ParseString(param, "RoomName_" $ i, PartyRoomName);
		ParseInt(param, "MemberCnt_" $ i, MemberCnt);

		Record.LVDataList[0].szData = String( Number );
		Record.LVDataList[1].szData = PartyLeader;
		Record.LVDataList[2].szData = PartyRoomName;
		Record.LVDataList[3].szData = GetZoneNameWithZoneID( ZoneID );
		Record.LVDataList[4].szData = MinLevel $ "-" $ MaxLevel;
		Record.LVDataList[5].szData = MinMemberCnt $ "/" $ MaxMemberCnt;
		Record.LVDataList[6].szData = string( MemberCnt );
		
		//	AddSystemMessageString(String( Number ));
		//	AddSystemMessageString(PartyLeader);
		//	AddSystemMessageString(PartyRoomName);
		//	AddSystemMessageString(GetZoneNameWithZoneID( ZoneID ));
		//	AddSystemMessageString(MinLevel $ "-" $ MaxLevel);
		//	AddSystemMessageString(string( MemberCnt ));

		//선준 수정(2010.02.22 ~ 03.08) 완료
		for( j = 0 ; j < MemberCnt ; ++j )
		{
			ParseString(param, "MemberName_" $ i $ "_" $ j, MemberName );			
			ParseInt(param, "MemberClassID_" $ i $ "_" $ j, MemberClassID );

			//debug( "[" $ i $ "]" $ "[" $ j $ "]==" $ MemberName );
			//debug( "[" $ i $ "]" $ "[" $ j $ "]==" $ MemberClassID );			
			
			data1.nReserved1 = MemberClassID;
			data1.szData = MemberName;

			Record.LVDataList[ 7 + j ] = data1;
		}

		ThiefLst.InsertRecord( Record );
	}
}

function OnClickButton( string a_strButtonName )
{
	local PartyMatchWnd Script;
//	local UserInfo PlayerInfo;

	Script = PartyMatchWnd( GetScript( "PartyMatchWnd" ) );
	switch( a_strButtonName )
	{
		case "RefreshButton":
		Script.RequestPartyRoomListLocal( 1 );
//			ExecuteEvent(EV_PartyMatchStart);
//	ExecuteEvent(EV_PartyMatchList);
//		class'PartyMatchAPI'.static.RequestOpenPartyMatch();
	//		class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchRoomWnd");
//	class'UIAPI_WINDOW'.static.ShowWindow("PartyMatchWnd");
//	ExecuteEvent( EV_UsePartyMatchAction );
//	class'PartyMatchAPI'.static.RequestPartyRoomList( 1, -1, 1 );
//	ExecuteEvent(EV_PartyMatchStart);
//	ExecuteEvent( EV_PartyMatchList );
//	class'PartyMatchAPI'.static.RequestPartyRoomList( 1, -1, 1 );
//	Script.RequestPartyRoomListLocal( 1 );
//	AddSystemMessageString("Under Construction");
		break;
	}
}


defaultproperties
{
}
