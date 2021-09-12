class DebuffWnd extends UICommonAPI;

var WindowHandle Me;
var StatusIconHandle DebuffIcon[12];
var TextBoxHandle txtTimer[12];

var bool m_bOnCurState;
var int m_DebuffRow;
var int TimeLeft[12];

function OnRegisterEvent()
{
	RegisterEvent( EV_AbnormalStatusNormalItem );
	RegisterEvent( EV_Restart );
	RegisterEvent( EV_Die );
}

function OnEvent(int Event_ID, string param)
{
	if ( class'UIAPI_CHECKBOX'.static.IsChecked( "FlexOptionWnd.showDebuffTimer" ) )
	{
		if (Event_ID == EV_AbnormalStatusNormalItem)
		{
			AddDebuff(param);
		}
		else if (Event_ID == EV_Restart)
		{
			HandleRestart();
		}
		else if (Event_ID == EV_Die)
		{
			HandleDie();
		}
	}
}

function HandleRestart()
{
	local int idx;
	
	for ( idx = 0; idx < 12; idx++)
	{
		ClearStatus(false, false, idx);
	}
}

//Normal
function HandleDie()
{
	local int idx;
	
	for ( idx = 0; idx < 12; idx++)
	{
		ClearStatus(false, false, idx);
	}
}

function ClearStatus(bool bEtcItem, bool bShortItem, int idx)
{
	local int i;
	local int j;
	local int RowCount;
	local int RowCountTmp;
	local int ColCount;
	local StatusIconInfo info;
	
	//Normal아이템을 초기화하는 경우라면, Normal아이템의 현재행을 초기화한다.
	if (bEtcItem==false && bShortItem==false)
	{
		m_DebuffRow = -1;
	}
	

	RowCount = DebuffIcon[idx].GetRowCount();
	for (i=0; i<RowCount; i++)
	{
		ColCount = DebuffIcon[idx].GetColCount(i);
		for (j=0; j<ColCount; j++)
		{
			DebuffIcon[idx].GetItem(i, j, info);
			
			//제대로 아이템을 얻어왔다면
			if (IsValidItemID(info.ID))
			{
				if (info.bEtcItem==bEtcItem && info.bShortItem==bShortItem)
				{
					DebuffIcon[idx].DelItem(i, j);
					j--;
					ColCount--;
					RowCountTmp = DebuffIcon[idx].GetRowCount();
					if (RowCountTmp != RowCount)
					{
						i--;
						RowCount--;
					}
				}
			}
		}
	}
}

function AddDebuff( string param )
{
	local int i;
	local int j;
	local int Max;
	local StatusIconInfo info;
	local int BuffCnt;
	local int noblesseType;
	
	//NormalStatus 초기화
	for ( i = 0; i < 12; i++)
	{
		ClearStatus(false, false, i);
	}
	
	BuffCnt = 0;
	
	//info 초기화
	
	//info.Size = 24;
	GetINIInt("Buff Control", "Size", info.Size, "PatchSettings");
	GetINIInt("Buff Control", "ShowNobl", noblesseType, "PatchSettings");
	info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
	info.bShow = true;
	info.bEtcItem = false;
	info.bShortItem = false;
	info.bDeBuff = true;

	ParseInt(param, "ServerID", info.ServerID);
	ParseInt(param, "Max", Max);

	for (i = 0; i < Max; i++)
	{
		ParseItemIDWithIndex(param, info.ID, i);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
		
		if (IsValidItemID(info.ID))
		{
			if (IsDebuff( info.ID, info.Level) || (info.ID.ClassID == 1323 && noblesseType == 1))
			{
				DebuffIcon[BuffCnt].InsertRow(0);
				//if (info.ID.ClassID == 1323) info.bDebuff = true;
				DebuffIcon[BuffCnt].AddCol(0, info);
				txtTimer[BuffCnt].SetText( "");
				if ( info.RemainTime != -1 )
				{
					TimeLeft[BuffCnt] = info.RemainTime;
					if (TimeLeft[BuffCnt] < 100)
					{						
						txtTimer[BuffCnt].SetText( string( TimeLeft[BuffCnt] ) );
						txtTimer[BuffCnt].ShowWindow();
					}
					for ( j = BuffCnt + 1; j < 12; j++)
					{
						txtTimer[j].SetText( "" );
						txtTimer[j].HideWindow();
					}
					Me.KillTimer( 5010 + BuffCnt);
					Me.SetTimer( 5010 + BuffCnt, 1000 );
				}
				
				BuffCnt++;
			}
		}
	}
	
	UpdateIcons();
	UpdateWindowSize();
	SetWndSize( info.Size );
	
}

function OnShow()
{
	local int RowCount;
	RowCount = DebuffIcon[0].GetRowCount();
	if (RowCount < 1)
	{
		Me.HideWindow();
	}
}

function OnLoad()
{
	local int idx;
	
	Me = GetWindowHandle( "DebuffWnd" );
	
	for ( idx = 0; idx < 12; idx++ )
	{
		txtTimer[idx] = GetTextBoxHandle( "DebuffWnd.txtTimer_" $ string( idx ) );
		DebuffIcon[idx] = GetStatusIconHandle( "DebuffWnd.DebuffIcon_" $ string( idx ) );
		TimeLeft[idx] = -1;
		txtTimer[idx].SetText( "" );
		DebuffIcon[idx].HideWindow();
	}
	
	m_bOnCurState = false;
	m_DebuffRow = -1;
	
}

function OnTimer( int TimerID )
{
	local int g;
	
	for (g = 0; g < 12; g++)
		if (TimerID == (5010 + g) && TimeLeft[g] >= 0)
		{
			TimeLeft[g] -= 1;

			if ( DebuffIcon[g].GetColCount( 0 ) == 1 )
			{
				if (TimeLeft[g] < 100)
				{
					txtTimer[g].SetText( string( TimeLeft[g] ) );
					txtTimer[g].ShowWindow();
				}	
			}
			else
			{
				txtTimer[g].SetText( "" );
			}
			
			if (TimeLeft[g] < 0)
			{
				txtTimer[g].HideWindow();
				Me.KillTimer(5010 + g);
			}
		}
}

function OnEnterState( name a_PreStateName )
{
	m_bOnCurState = true;
	UpdateWindowSize();
}

function OnExitState( name a_NextStateName )
{
	m_bOnCurState = false;
}

function UpdateWindowSize()
{
	local int RowCount;
	local Rect rectWnd;
	
	RowCount = DebuffIcon[0].GetRowCount();
	if ( RowCount > 0 )
	{
		//현재 GameState가 아니면 윈도우를 보이지 않는다.
		if (m_bOnCurState)
		{
			Me.ShowWindow();
		}
		else
		{
			Me.HideWindow();
		}
		
		//윈도우 사이즈 변경
		rectWnd = DebuffIcon[0].GetRect();
		Me.SetWindowSize(rectWnd.nWidth + 12, rectWnd.nHeight);
		
		//세로 프레임 사이즈 변경
	//	Me.SetFrameSize(12, rectWnd.nHeight);
	}
	else
	{
		Me.HideWindow();
	}
}

function SetWndSize( int size )
{
	local int idx;
	local int count;
//	local AbnormalStatusWnd script_abn;
	
//	script_abn = AbnormalStatusWnd( GetScript( "AbnormalStatusWnd" ) );
	
	count = 0;
	
	for ( idx = 0; idx < 12; idx++ )
	{
		if ( DebuffIcon[idx].GetColCount( 0 ) == 1 )
		{
			count++;
		}
	}
	
	if ( count == 0 )
	{
		if ( size == 24 )
		{
			Me.SetWindowSize( count , 28 );
		}
		else if ( size == 32 )
		{
			Me.SetWindowSize( count , 36 );
		}
		
	}
	else
	{
		if ( size == 24 )
		{
			Me.SetWindowSize( 38 + 28 * ( count - 1 ) , 28 );
		}
		else if ( size == 32 )
		{
			Me.SetWindowSize( 46 + 36 * ( count - 1 ) , 36 );
		}
		
	}
}

function UpdateIcons()
{
	local int idx;
	
	for ( idx = 0; idx < 12; idx++ )
	{
		if ( DebuffIcon[idx].GetColCount( 0 ) == 1 )
		{
			DebuffIcon[idx].ShowWindow();
		}
		else if ( DebuffIcon[idx].GetColCount( 0 ) == 0 )
		{
			DebuffIcon[idx].HideWindow();
		}
	}
}


function OnClickItem( string strID, int index )
{	
	//local int row;
	local int dbfIndex;
	local StatusIconInfo info;
	local SkillInfo skillInfo;		// 스킬 정보. 버프스킬인지 확인해야 하니까
	
	//col = index / 10;
	//row = index - (col * 10);
	
	//sysDebug( "ROW:" @ row @ "COL:" @ col );
	dbfIndex = int(Right(strID,1));
	//AddSystemMessageString("dbfIndex: " $ string(dbfIndex));
	//AddSystemMessageString("col: " $ string(col));
	//AddSystemMessageString("strID: " $ strID);
	//AddSystemMessageString("index: " $ string(index));
	DebuffIcon[dbfIndex].GetItem(0, 0, info);
	
	// ID를 가지고 스킬의 정보를 얻어온다. 없으면 패배
	if( !GetSkillInfo( info.ID.ClassID, info.Level , skillInfo ) )
	{
		//debug("ERROR - no skill info!!");
		//AddSystemMessageString("ERROR - no skill info!!");
		return;
	}	
	
	if ( InStr( strID ,"DebuffIcon_" ) > -1 )
	{
		if ((skillInfo.IsDebuff == false && skillInfo.OperateType == 1) || (skillInfo.SkillID == 1323))
		{	
			//AddSystemMessageString("debuff click");
			RequestDispel(info.ServerID, info.ID, info.Level);		
			GetINIInt("Buff Control", "Size", info.Size, "PatchSettings");
			UpdateIcons();
			UpdateWindowSize();
			SetWndSize( info.Size );
		//	ClearStatus(false, false, index);
		}					//버프 취소 요청
		else												
		{	
			AddSystemMessage(2318);
		}	//강화 스킬인 경우에만 버프 취소가 가능합니다. 
	}
}

defaultproperties
{
}
