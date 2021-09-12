class TargetStatusWnd extends UICommonAPI;
	
const CONTRACT_HEIGHT = 46;
const EXPAND_HEIGHT = 80;

var bool m_bExpand;
var bool myPet;

var int	m_TargetLevel;
var int	m_TargetID;
var bool m_bShow;
var string g_NameStr;

var WindowHandle Me;
var BarHandle barMP;
var BarHandle barHP;
var TextBoxHandle txtPledgeAllianceName;
var TextureHandle texPledgeAllianceCrest;
var TextBoxHandle txtAlliance;
var TextBoxHandle txtPledgeName;
var TextureHandle texPledgeCrest;
var TextBoxHandle txtPledge;
var NameCtrlHandle RankName;
var NameCtrlHandle UserName;
var ButtonHandle btnIcon;
var ButtonHandle btnClose;

var TreeHandle NpcInfo;

var ButtonHandle btnExpand;
var ButtonHandle btnContract;

var ButtonHandle btnInvite;

var CustomTooltip TooltipAdena;
var TextBoxHandle ed_tbHP;
var PartyWnd script_pt;


function OnRegisterEvent()
{
	RegisterEvent( EV_TargetUpdate );
	RegisterEvent( EV_TargetHideWindow );
	
	RegisterEvent( EV_UpdateHP );
	RegisterEvent( EV_UpdateMP );
	RegisterEvent( EV_UpdateMaxHP );
	RegisterEvent( EV_UpdateMaxMP );
	
	RegisterEvent( EV_ReceiveTargetLevelDiff );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		Initialize();
	}
	else
		InitializeCOD();

	Load();

}

function Initialize()
{
	Me = GetHandle( "TargetStatusWnd" );
	barMP = BarHandle ( GetHandle( "TargetStatusWnd.barMP" ) );
	barHP = BarHandle ( GetHandle( "TargetStatusWnd.barHP" ) );
	txtPledgeAllianceName = TextBoxHandle ( GetHandle( "TargetStatusWnd.txtPledgeAllianceName" ) );
	texPledgeAllianceCrest = TextureHandle ( GetHandle( "TargetStatusWnd.texPledgeAllianceCrest" ) );
	txtAlliance = TextBoxHandle ( GetHandle( "TargetStatusWnd.txtAlliance" ) );
	txtPledgeName = TextBoxHandle ( GetHandle( "TargetStatusWnd.txtPledgeName" ) );
	texPledgeCrest = TextureHandle ( GetHandle( "TargetStatusWnd.texPledgeCrest" ) );
	txtPledge = TextBoxHandle ( GetHandle( "TargetStatusWnd.txtPledge" ) );
	RankName = NameCtrlHandle ( GetHandle( "TargetStatusWnd.RankName" ) );
	UserName = NameCtrlHandle ( GetHandle( "TargetStatusWnd.UserName" ) );
	btnClose = ButtonHandle ( GetHandle( "TargetStatusWnd.btnClose" ) );
	
	NpcInfo = TreeHandle ( GetHandle( "TargetStatusWnd.NpcInfo" ) );
	
	btnExpand = ButtonHandle ( GetHandle( "TargetStatusWnd.btnExpand" ) );;
	btnContract= ButtonHandle ( GetHandle( "TargetStatusWnd.btnContract" ) );;
	btnInvite= ButtonHandle ( GetHandle( "TargetStatusWnd.btnInvite" ) );;
	btnIcon = GetButtonHandle( "TargetStatusWnd.btnIcon" ) ;;
	ed_tbHP = TextBoxHandle(GetHandle("TargetStatusWnd.tbHP"));
}


function InitializeCOD()
{
	Me = GetWindowHandle( "TargetStatusWnd" );
	barMP =GetBarHandle( "TargetStatusWnd.barMP" );
	barHP = GetBarHandle( "TargetStatusWnd.barHP" );
	txtPledgeAllianceName = GetTextBoxHandle ( "TargetStatusWnd.txtPledgeAllianceName" );
	texPledgeAllianceCrest = GetTextureHandle ( "TargetStatusWnd.texPledgeAllianceCrest" );
	txtAlliance = GetTextBoxHandle ( "TargetStatusWnd.txtAlliance" );
	txtPledgeName = GetTextBoxHandle ( "TargetStatusWnd.txtPledgeName" );
	texPledgeCrest = GetTextureHandle ( "TargetStatusWnd.texPledgeCrest" );
	txtPledge = GetTextBoxHandle ( "TargetStatusWnd.txtPledge" );
	RankName = GetNameCtrlHandle ( "TargetStatusWnd.RankName"  );
	UserName = GetNameCtrlHandle ( "TargetStatusWnd.UserName"  );
	btnClose = GetButtonHandle ( "TargetStatusWnd.btnClose" );
	
	NpcInfo = GetTreeHandle ( "TargetStatusWnd.NpcInfo" );

	btnExpand = GetButtonHandle ( "TargetStatusWnd.btnExpand" );
	btnContract= GetButtonHandle ( "TargetStatusWnd.btnContract" );
	btnInvite= GetButtonHandle( "TargetStatusWnd.btnInvite" );
	btnIcon = GetButtonHandle ( "TargetStatusWnd.btnIcon" ) ;;
	ed_tbHP = GetTextBoxHandle("TargetStatusWnd.tbHP");
}

function Load()
{
	SetExpandMode(false);

	script_pt = PartyWnd(GetScript("PartyWnd"));
	
	g_NameStr = "";
	m_bShow = false;
	m_TargetID = -1;
		
	btnIcon.SetTexture("","","");
	btnIcon.HideWindow();
}

function OnShow()
{
	m_bShow = true;	
}

function OnHide()
{
	m_bShow = false;
	g_NameStr = "";
}

function OnEnterState( name a_PreStateName )
{
	local int nWndWidth;
	local int nWndHeight;

	Me.GetWindowSize(nWndWidth,nWndHeight);
}

function OnEvent(int Event_ID, string param)
{
	local UserInfo TargetInfo;
	local UserInfo Player;
	
	if (Event_ID == EV_TargetUpdate)
	{
		HandleTargetUpdate();
		
		GetPlayerInfo(Player);
			
		if ( m_targetID != -1 )
			if ( GetUserInfo(m_targetID,TargetInfo) )
			{
				if (!TargetInfo.bNpc && !TargetInfo.bPet && Player.Name != TargetInfo.Name)
				{
					script_pt.WriteTargetToPartyChat(TargetInfo.nID);
					script_pt.g_MsgAutoAssist = -1;
				}
			}				
	}
	else if (Event_ID == EV_TargetHideWindow)
	{
		HandleTargetHideWindow();
	}
	else if (Event_ID == EV_ReceiveTargetLevelDiff)
	{
		HandleReceiveTargetLevelDiff(param);
		
	}
	else if (Event_ID == EV_UpdateHP)
	{
		HandleUpdateGauge(param,0);
	}
	else if (Event_ID == EV_UpdateMaxHP)
	{
		HandleUpdateGauge(param,0);
	}
	else if (Event_ID == EV_UpdateMP)
	{
		HandleUpdateGauge(param,1);
	}
	else if (Event_ID == EV_UpdateMaxMP)
	{
		HandleUpdateGauge(param,1);
	}
}

function HandleTargetHideWindow()
{
		Me.HideWindow();
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnClose":
		OnCloseButton();
		break;
	case "btnExpand":
		SetExpandMode(false);
		break;
	case "btnContract":
		SetExpandMode(true);
		break;
	case "btnIcon":
		ExecuteCommand("/olympiadstat");
		break;
	case "btnInvite":
		OnInviteButton();
		break;
	}
}

function OnInviteButton()
{	
	if ( m_targetID != -1 )
		RequestInviteParty(UserName.GetName());
}


function OnRButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;
	
	rectWnd = Me.GetRect();
	if ( (X > rectWnd.nX + 13) && (X < rectWnd.nX + rectWnd.nWidth - 10) )
	{
		if ( m_targetID != -1 )
		{
			if ( GetPlayerInfo(UserInfo) )
			{
				RequestAssist(m_targetID,UserInfo.Loc);
			}
		}
	}
}

function OnLButtonDblClick (WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;
	rectWnd = Me.GetRect();
  
	if ( (X > rectWnd.nX + 13) && (X < rectWnd.nX + rectWnd.nWidth - 10) )
	{
		if ( m_targetID != -1 )
		{
			if ( GetPlayerInfo(UserInfo) )
			{
				if ( IsPKMode() )
				{
					RequestAttack(m_targetID,UserInfo.Loc);
				}
				else
				{
					RequestAction(m_targetID,UserInfo.Loc);
				}    
			}
		}
	}
}

function OnLButtonDown (WindowHandle a_WindowHandle, int X, int Y)
{
	local Rect rectWnd;
	local UserInfo UserInfo;
	rectWnd = Me.GetRect();
	if ( (X > rectWnd.nX + 13) && (X < rectWnd.nX + rectWnd.nWidth - 10) )
	{
		if ( m_targetID != -1 )
		{
			if ( GetUserInfo(m_targetID, UserInfo) )
			{
				if ( IsKeyDown(IK_Shift) )
				{
					if (UserInfo.Name != "")
					{
						SetChatMessage( "\"" $ UserInfo.Name $ " " );
					}
				}  
			}
		}
	} 
}


//����
function OnCloseButton()
{
	RequestTargetCancel();
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//HP,MP ������Ʈ
function HandleUpdateGauge(string param, int Type)
{
	local int ServerID;
	
	if (m_bShow)
	{
		ParseInt( param, "ServerID", ServerID );
		if (m_TargetID == ServerID)
			HandleTargetUpdateGauge( Type );
	}
}

//Ÿ�ٰ��� ���� ����
function HandleReceiveTargetLevelDiff(string param)
{
	
	ParseInt(param, "LevelDiff", m_TargetLevel);
	HandleTargetUpdate();
	
}

//Ÿ�� ���� ������Ʈ ó��(HP, MP)
function HandleTargetUpdateGauge( int Type )
{
	local UserInfo	info;
	local int		TargetID;
	
	//Ÿ��ID ������
	TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	if (TargetID<1)
	{
		Me.HideWindow();
		return;
	}
	m_TargetID = TargetID;
	
	GetTargetInfo(info);
	
	switch( Type )
	{
	case 0:
		UpdateHPBar(info.nCurHP, info.nMaxHP);
	break;
	case 1:
		UpdateMPBar(info.nCurMP, info.nMaxMP);
	break;
	}	
}

//Ÿ�� ���� ������Ʈ ó��
function HandleTargetUpdate()
{
	
	
	local Rect rectWnd;
	local string strTmp;
	
	local int		TargetID;
	local int		PlayerID;
	local int		PetID;
	local int		ClanType;
	local int		ClanNameValue;
	
	//Ÿ�� �Ӽ� ����
	local bool		bIsServerObject;
	local bool		bIsHPShowableNPC;	//��������
	local bool		bIsVehicle;
	
	local string	Name;
	local string	NameRank;
	local color	TargetNameColor;
	
	//ServerObject
	local int ServerObjectNameID;
	local Actor.EL2ObjectType ServerObjectType;
	
	//Vehicle
	local Vehicle	VehicleActor;
	local string	DriverName;
	
	//HP,MP
	local bool		bShowHPBar;
	local bool		bShowMPBar;
	
	//���� ����
	local bool		bShowPledgeInfo;
	local bool		bShowPledgeTex;
	local bool		bShowPledgeAllianceTex;
	local string	PledgeName;
	local string	PledgeAllianceName;
	local texture	PledgeCrestTexture;
	local texture	PledgeAllianceCrestTexture;
	local color	PledgeNameColor;
	local color	PledgeAllianceNameColor;
	
	//NPCƯ��
	local bool		 bShowNpcInfo;
	local Array<int>	 arrNpcInfo;
	
	//���ο�Target�ΰ�?
	local bool		IsTargetChanged;
	
	local bool  WantHideName;
	local int 	nMasterID;
	
	local UserInfo	info;
	local UserInfo PlayerInfo;
	local int ClassID;
	
	local Color WhiteColor;	//  �Ͼ���� ����.
	WhiteColor.R = 0;
	WhiteColor.G = 0;
	WhiteColor.B = 0;
	myPet = false;

	GetPlayerInfo(PlayerInfo);
	
	ClassID = Info.nSubClass; 
	
	//Ÿ��ID ������
	TargetID = class'UIDATA_TARGET'.static.GetTargetID();
	if (TargetID<1)
	{
		Me.HideWindow();
		return;
	}

	if (m_TargetID!=TargetID)
	{
		IsTargetChanged = true;	
	}
	m_TargetID = TargetID;
	
	GetTargetInfo(info);
	
	nMasterID= info.nMasterID;
	WantHideName= info.WantHideName;
	
	rectWnd = Me.GetRect();
	PledgeName = GetSystemString(431);
	PledgeAllianceName = GetSystemString(591);
	PledgeNameColor.R = 128;
	PledgeNameColor.G = 128;
	PledgeNameColor.B = 128;
	PledgeAllianceNameColor.R = 128;
	PledgeAllianceNameColor.G = 128;
	PledgeAllianceNameColor.B = 128;
	
	TargetNameColor = GetTargetNameColor(m_TargetLevel);
	
	bIsServerObject = class'UIDATA_TARGET'.static.IsServerObject();
	bIsVehicle = class'UIDATA_TARGET'.static.IsVehicle();
	btnInvite.HideWindow();
	if (bIsServerObject)
	{
		
		ServerObjectType = class'UIDATA_STATICOBJECT'.static.GetServerObjectType(m_TargetID);
		
		btnIcon.SetTexture("","","");
		btnIcon.HideWindow();
		
		
		if (ServerObjectType == EL2_AIRSHIPKEY)
		{
			Name = GetSystemString( 1966 );	//���� Ű
			NameRank = "";
		}
		else
		{
			ServerObjectNameID = class'UIDATA_STATICOBJECT'.static.GetServerObjectNameID(m_TargetID);
			if (ServerObjectNameID>0)
			{
				Name = class'UIDATA_STATICOBJECT'.static.GetStaticObjectName(ServerObjectNameID);
				NameRank = "";
			}
		}		
		
		UserName.SetName(Name, NCT_Normal,TA_Center);
		RankName.SetName(NameRank, NCT_Normal,TA_Center);
		
		//HPǥ��
		if (ServerObjectType == EL2_DOOR)
		{
			if( class'UIDATA_STATICOBJECT'.static.GetStaticObjectShowHP( m_TargetID ) )
			{
				bShowHPBar = true;
				UpdateHPBar(class'UIDATA_STATICOBJECT'.static.GetServerObjectHP(m_TargetID), class'UIDATA_STATICOBJECT'.static.GetServerObjectMaxHP(m_TargetID));
			}
		}
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Ż���ΰ�?
	else if( bIsVehicle )
	{		
		btnIcon.SetTexture("","","");
		btnIcon.HideWindow();
		HandleTargetHideWindow();
		return;
		
		//TO DO : ���̸�, ���߿� SYSSTRING�Ǵ� �������� ������ ������ ����.
		UserName.SetName("AirShip", NCT_Normal,TA_Center);
		
		VehicleActor = Vehicle(class'UIDATA_TARGET'.static.GetTargetActor());
		if( VehicleActor != None )
		{
			//���� �̸�
			if(VehicleActor.DriverID > 0 )
				DriverName = class'UIDATA_USER'.static.GetUserName( VehicleActor.DriverID );
			if( Len(DriverName) < 1 )
				DriverName = GetSystemString( 1967 );	// ������ ����
			RankName.SetName( DriverName, NCT_Normal,TA_Center );
		}		
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Ÿ��ID�� �ִµ� �̸��� �˼����ٸ�, �ָ��ִ� ��Ƽ����� ����
	else if (Len(info.Name)<1)
	{		
		btnIcon.SetTexture("","","");
		btnIcon.HideWindow();
		Name = class'UIDATA_PARTY'.static.GetMemberVirtualName(m_TargetID);
		if ( Name == "")
		{
			Name = class'UIDATA_PARTY'.static.GetMemberName(m_TargetID);
		}
		NameRank = "";
		UserName.SetName(Name, NCT_Normal,TA_Center);
		RankName.SetName(NameRank, NCT_Normal,TA_Center);
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Npc or Pc �� ���
	else
	{
		PlayerID = class'UIDATA_PLAYER'.static.GetPlayerID();
		PetID = class'UIDATA_PET'.static.GetPetID();
		
		bIsHPShowableNPC = class'UIDATA_TARGET'.static.IsHPShowableNPC();

		//if ((info.bNpc && !info.bPet && info.bCanBeAttacked ) ||	//���ǰ��
		if ((info.bNpc && !info.bPet && bIsHPShowableNPC) ||	//���ǰ��
			(PlayerID>0 && m_TargetID == PlayerID) ||		//���ǰ��
			(info.bNpc && info.bPet && m_TargetID == PetID) ||	//���ǰ��
			(info.bNpc && bIsHPShowableNPC)	)		//��������
		{
			
			btnIcon.SetTexture("","","");
			btnIcon.HideWindow();
			btnInvite.HIdeWindow();
			if(IsAllWhiteID(info.nClassID))
			{
				Name = info.Name;
				NameRank = "";
				UserName.SetName(Name, NCT_Normal,TA_Center);
				RankName.SetName(NameRank, NCT_Normal,TA_Center);
					
				//HPǥ��
				if(! (IsNoBarID(info.nClassID)))
				{
					bShowHPBar = true;
					UpdateHPBar(info.nCurHP, info.nMaxHP);
				}
			}
			else
			{
				Name = info.Name;
				NameRank = "";	
				UserName.SetNameWithColor(Name, NCT_Normal,TA_Center,TargetNameColor);
				RankName.SetName(NameRank, NCT_Normal,TA_Center);
				
				//HPǥ��
				bShowHPBar = true;
				if (info.bNpc && info.bPet && m_TargetID == PetID) myPet = true;
				UpdateHPBar(info.nCurHP, info.nMaxHP);
				
				//MPǥ��
				if (!(info.bNpc && !info.bPet))
				{
					bShowMPBar = true;
					UpdateMPBar(info.nCurMP, info.nMaxMP);
				}								
			}
		
			if (PlayerID>0 && m_TargetID == PlayerID)
			{
					ClassID = Info.nSubClass;
					btnIcon.ShowWindow();
					btnIcon.SetTexture(GetDetailedClassIconName(ClassID, 1),GetDetailedClassIconName(ClassID, 1),GetDetailedClassIconName(ClassID, 1));
					btnIcon.SetTooltipCustomType(MakeTooltipSimpleText(GetClassType(ClassID) $ " - " $ GetClassStr(ClassID)));
			}	
		
		}
		//Npc or Other Pc
		else
		{
			Name = info.Name;
			ClassID = Info.nSubClass;
			
			if (WantHideName)
			{
				RankName.hideWindow();	
				
			}
			if (info.bNpc)
			{
				NameRank = "";	
				g_NameStr = "";
				
				btnIcon.SetTexture("","","");
				btnIcon.HideWindow();
				btnInvite.HideWindow();
			}
			else
			{
				NameRank = GetClassType(Info.nSubClass) $ " [" $ GetUserRankString(Info.nUserRank) $ "]";
				g_NameStr = Name;				
				if (script_pt.isPartyMember(info.Name)) 
				{
					btnInvite.HideWindow();
				}
				else
				{
					if (script_pt.m_CurCount==0) btnInvite.ShowWindow();
					else 
					{
						if (script_pt.cb_Crown.isShowWindow()) btnInvite.ShowWindow();
						else  btnInvite.HideWindow();
					}
				}
				btnIcon.ShowWindow();
				btnIcon.SetTexture(GetDetailedClassIconName(ClassID, 1),GetDetailedClassIconName(ClassID, 1),GetDetailedClassIconName(ClassID, 1));
				btnIcon.SetTooltipCustomType(MakeTooltipSimpleText(GetClassType(ClassID) $ " - " $ GetClassStr(ClassID)));				
			}
			UserName.SetName(Name, NCT_Normal,TA_Center);
			RankName.SetName(NameRank, NCT_Normal,TA_Center);
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/// �߰� ���� ǥ��
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if (m_bExpand)
		{
			if (info.bNpc && 0 >= info.nMasterID)
			{
				if (class'UIDATA_NPC'.static.GetNpcProperty(info.nClassID, arrNpcInfo))
				{
					bShowNpcInfo = true;
					
					//Ʈ����Ʈ�ѿ� NpcƯ�������� �߰�
					//Ÿ���� �ٲ�������� ������ �����Ѵ�. �ȱ׷� HP�� ���ŵ� �� ���ڰŸ�
					if (IsTargetChanged)
						UpdateNpcInfoTree(arrNpcInfo);
				}				
			}
			else
			{
				bShowPledgeInfo = true;

				if (info.nClanID>0)						
				{
					//�����̸�
					PledgeName = class'UIDATA_CLAN'.static.GetName(info.nClanID);
					PledgeNameColor.R = 176;
					PledgeNameColor.G = 152;
					PledgeNameColor.B = 121;
					if( PledgeName != "" && class'UIDATA_USER'.static.GetClanType( m_TargetID, ClanType ) && class'UIDATA_CLAN'.static.GetNameValue(info.nClanID, ClanNameValue) )
					{
						if( ClanType == CLAN_ACADEMY )
						{
							PledgeNameColor.R = 209;
							PledgeNameColor.G = 167;
							PledgeNameColor.B = 2;
						}
						else if( ClanNameValue > 0 )
						{
							PledgeNameColor.R = 0;
							PledgeNameColor.G = 130;
							PledgeNameColor.B = 255;
						}
						else if( ClanNameValue < 0 )
						{
							PledgeNameColor.R = 255;
							PledgeNameColor.G = 0;
							PledgeNameColor.B = 0;
						}
					}
					
					//���� �ؽ��� ������
					if (class'UIDATA_CLAN'.static.GetCrestTexture(info.nClanID, PledgeCrestTexture))
					{
						bShowPledgeTex = true;
						texPledgeCrest.SetTextureWithObject(PledgeCrestTexture);
					}
					else
					{
						bShowPledgeTex = false;
					}
					
					//�����̸� �� ��ũ
					strTmp = class'UIDATA_CLAN'.static.GetAllianceName(info.nClanID);
					if (Len(strTmp)>0)
					{
						//���� �̸� ����
						PledgeAllianceName = strTmp;
						PledgeAllianceNameColor.R = 176;
						PledgeAllianceNameColor.G = 155;
						PledgeAllianceNameColor.B = 121;
						
						//���� �ؽ��� ������
						if (class'UIDATA_CLAN'.static.GetAllianceCrestTexture(info.nClanID, PledgeAllianceCrestTexture))
						{
							bShowPledgeAllianceTex = true;
							texPledgeAllianceCrest.SetTextureWithObject(PledgeAllianceCrestTexture);
						}
						else
						{
							bShowPledgeAllianceTex = false;
						}
					}
				}
			}
		}
	}
	if (!Me.IsShowWindow() && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		Me.ShowWindow();
		SetExpandMode(m_bExpand);
	}
	
	//HP,MPǥ��
	if (bShowHPBar && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		barHP.ShowWindow();
		ed_tbHP.ShowWindow();
	}
	else
	{
		barHP.HideWindow();
		ed_tbHP.HideWindow();
	}
	if (bShowMPBar && GetGameStateName() != "SPECIALCAMERASTATE" )
	{
		barMP.ShowWindow();
	}
	else
	{
		barMP.HIdeWindow();
	}
	
	//Hide Cursed PC Name, ttmayrin
	if( info.nClanID < 0 )
		bShowPledgeInfo = false;
		
	//�������� ǥ��
	if (bShowPledgeInfo)
	{
		 if (!WantHideName && GetGameStateName() != "SPECIALCAMERASTATE" )
		{
			txtPledge.ShowWindow();
			txtAlliance.ShowWindow();
			txtPledgeName.ShowWindow();
			txtPledgeAllianceName.ShowWindow();
			txtPledgeName.SetText(PledgeName);
			txtPledgeAllianceName.SetText(PledgeAllianceName);
			txtPledgeName.SetTextColor(PledgeNameColor);
			txtPledgeAllianceName.SetTextColor(PledgeAllianceNameColor);
		
			if (bShowPledgeTex)
			{
				texPledgeCrest.ShowWindow();
				txtPledgeName.MoveTo(rectWnd.nX + 66, rectWnd.nY + 43);
			}
			else
			{
				texPledgeCrest.HideWindow();
				txtPledgeName.MoveTo(rectWnd.nX + 48, rectWnd.nY + 43);
			}
			
			if (bShowPledgeAllianceTex)
			{
				texPledgeAllianceCrest.ShowWindow();
				txtPledgeAllianceName.MoveTo(rectWnd.nX + 66, rectWnd.nY + 59);
			}
			else
			{
				texPledgeAllianceCrest.HideWindow();
				txtPledgeAllianceName.MoveTo(rectWnd.nX + 48, rectWnd.nY + 59);
			}
		}
		
		else
		{		
			txtPledge.HideWindow();
			txtAlliance.HideWindow();
			txtPledgeName.HideWindow();
			txtPledgeAllianceName.HideWindow();
			texPledgeCrest.HideWindow();
			texPledgeAllianceCrest.HideWindow();
				
		}
	}
	else
	{
		txtPledge.HideWindow();
		txtAlliance.HideWindow();
		txtPledgeName.HideWindow();
		txtPledgeAllianceName.HideWindow();
		texPledgeCrest.HideWindow();
		texPledgeAllianceCrest.HideWindow();
		
	}
	
	//NPCƯ�� ǥ��
	if (bShowNpcInfo && GetGameStateName() != "SPECIALCAMERASTATE")
	{
		NpcInfo.ShowWindow();
		NpcInfo.ShowScrollBar(false);
	}
	else
	{
		NpcInfo.HideWindow();
	}
	btnInvite.SetTooltipCustomType(MakeTooltipSimpleText("Invite " $ UserName.GetName() $ " to party"));
}

//Frame Expand��ư ó��

//Expand���¿� ���� �������� ó��

// Ÿ�ٰ��� ���� ���̿� ���� ���� �� ������
function Color GetTargetNameColor(int TargetLevelDiff)
{
	local Color OutColor;
	local UserInfo userinfo;
	local int myLevel;


	GetPlayerInfo( userinfo );
	myLevel = userinfo.nLevel;
	
	OutColor.A = 255;
	
	if (myLevel < 78 )
	{
		if (TargetLevelDiff <= -9)
		{
			OutColor.R=255;
			OutColor.G=0;
			OutColor.B=0;
		}
		else if (TargetLevelDiff > -9 &&TargetLevelDiff <= -6)
		{
			OutColor.R=255;
			OutColor.G=145;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -6 &&TargetLevelDiff <= -3)
		{
			OutColor.R=250;
			OutColor.G=254;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -3 &&TargetLevelDiff <= 2)
		{
			OutColor.R=255;
			OutColor.G=255;
			OutColor.B=255;
		}
		else if (TargetLevelDiff > 2 &&TargetLevelDiff <= 5)
		{
			OutColor.R=162;
			OutColor.G=255;
			OutColor.B=171;
		}
		else if (TargetLevelDiff > 5 &&TargetLevelDiff <= 8)
		{
			OutColor.R=162;
			OutColor.G=168;
			OutColor.B=252;
		}
		else if (TargetLevelDiff > 8)
		{
			OutColor.R=0;
			OutColor.G=0;
			OutColor.B=255;
		}
	} 
	else 
	{
		// �������� 78�̻� �� ��� ���� ���� ���� ǥ�ø� �ٿ� �����ش�. 
		if (TargetLevelDiff <= -8)
		{
			OutColor.R=255;
			OutColor.G=0;
			OutColor.B=0;
		}
		else if (TargetLevelDiff > -8 &&TargetLevelDiff <= -5)
		{
			OutColor.R=255;
			OutColor.G=145;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -5 &&TargetLevelDiff <= -2)
		{
			OutColor.R=250;
			OutColor.G=254;
			OutColor.B=145;
		}
		else if (TargetLevelDiff > -2 &&TargetLevelDiff <= 1)
		{
			OutColor.R=255;
			OutColor.G=255;
			OutColor.B=255;
		}
		else if (TargetLevelDiff > 1 &&TargetLevelDiff <= 3)
		{
			OutColor.R=162;
			OutColor.G=255;
			OutColor.B=171;
		}
		else if (TargetLevelDiff > 3 &&TargetLevelDiff <= 5)
		{
			OutColor.R=162;
			OutColor.G=168;
			OutColor.B=252;
		}
		else if (TargetLevelDiff > 5)
		{
			OutColor.R=0;
			OutColor.G=0;
			OutColor.B=255;
		}
	}
	return OutColor;
}



function SetExpandMode(bool bExpand)
{
	local int nWndWidth, nWndHeight;	// ������ ������ �ޱ� ����
	Me.GetWindowSize(nWndWidth, nWndHeight);
	
	m_bExpand = bExpand;
	
	m_TargetID = -1;
	HandleTargetUpdate();
	
	if (bExpand)
	{
		btnExpand.ShowWindow();
		btnContract.HideWindow();
		Me.SetWindowSize(nWndWidth, EXPAND_HEIGHT);
	}
	else
	{
		btnExpand.HideWindow();
		btnContract.ShowWindow();
		Me.SetWindowSize(nWndWidth, CONTRACT_HEIGHT);
	}
}

//HP�� ����
function UpdateHPBar(int HP, int MaxHP)
{
	local float Percent;
	local PetInfo	info;
	
	if (myPet)
		if (GetPetInfo(info))
			{
				HP = info.nCurHP;
				MaxHP = info.nMaxHP;	
			}
	Percent = getPercent(HP,MaxHP)*100;
	barHP.SetValue(MaxHP, HP);
	ed_tbHP.SetText(string(Percent) $ "%");
}

//MP�� ����
function UpdateMPBar(int MP, int MaxMP)
{
	barMP.SetValue(MaxMP, MP);
}

//Ʈ����Ʈ�ѿ� NpcƯ�������� �߰�
function UpdateNpcInfoTree(array<int> arrNpcInfo)
{
	local int i;
	local int SkillID;
	local int SkillLevel;
	local int nWndWidth, nWndHeight;
	local int divider;
	local string				strNodeName;
	local XMLTreeNodeInfo		infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo		infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	
	//�ʱ�ȭ
	NpcInfo.Clear();
	Me.GetWindowSize(nWndWidth, nWndHeight);	
	if (nWndWidth >= 184) 
		divider = 9 + (nWndWidth - 189)/18;
	else
		divider = 8;
	//��Ʈ �߰�
	infNode.strName = "root";
	strNodeName = NpcInfo.InsertNode("", infNode);
	if (Len(strNodeName) < 1)
	{
		return;
	}
	
	for (i=0; i<arrNpcInfo.Length; i+=2)
	{
		SkillID = arrNpcInfo[i];
		SkillLevel = arrNpcInfo[i+1];
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert Node
		infNode = infNodeClear;
		infNode.nOffSetX = ((i/2)%divider)*18;
		if ((i/2)%divider==0)
		{
			if (i>0)
			{
				infNode.nOffSetY = 3;
			}
			else
			{
				infNode.nOffSetY = 0;
			}
		}
		else
		{
			infNode.nOffSetY = -15;
		}
		
		infNode.strName = "" $ i/2;
		infNode.bShowButton = 0;
		//Tooltip
		infNode.ToolTip = SetNpcInfoTooltip(SkillID, SkillLevel);
		strNodeName = NpcInfo.InsertNode("root", infNode);
		if (Len(strNodeName) < 1)
		{
			Log("ERROR: Can't insert node. Name: " $ infNode.strName);
			return;
		}
		//Node Tooltip Clear
		infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
		
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert NodeItem
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.u_nTextureWidth = 15;
		infNodeItem.u_nTextureHeight = 15;
		infNodeItem.u_nTextureUWidth = 32;
		infNodeItem.u_nTextureUHeight = 32;
		infNodeItem.u_strTexture = class'UIDATA_SKILL'.static.GetIconName(GetItemID(SkillID), SkillLevel);
		NpcInfo.InsertNodeItem(strNodeName, infNodeItem);
	}
}

function CustomTooltip SetNpcInfoTooltip(int ID, int Level)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	local DrawItemInfo infoClear;
	local ItemInfo Item;
	local ItemID cID;
	
	cID = GetItemID(ID);
	
	Item.Name = class'UIDATA_SKILL'.static.GetName(cID, Level);
	Item.Description = class'UIDATA_SKILL'.static.GetDescription(cID, Level);
	
	Tooltip.DrawList.Length = 1;
	
	//�̸�
	info = infoClear;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_strText = Item.Name;
	Tooltip.DrawList[0] = info;

	//����
	if (Len(Item.Description)>0)
	{
		Tooltip.MinimumWidth = 144;
		Tooltip.DrawList.Length = 2;
		
		info = infoClear;
		info.eType = DIT_TEXT;
		info.nOffSetY = 6;
		info.bLineBreak = true;
		info.t_color.R = 178;
		info.t_color.G = 190;
		info.t_color.B = 207;
		info.t_color.A = 255;
		info.t_strText = Item.Description;
		Tooltip.DrawList[1] = info;	
	}
	return Tooltip;
}

//�׻� ������� ǥ���� �� ���͸� üũ�ϴ� �Լ�
function bool IsAllWhiteID(int m_TargetID)
{
	local bool	bIsAllWhiteName;
	bIsAllWhiteName = false;
	
	switch( m_TargetID )
	{
		case 12775:	//��
		case 12776:
		case 12778:
		case 12779:
		case 13016:
		case 13017:	// ��
		case 13031:	//�Ŵ� ����
		case 13032:	//�Ŵ� ���� ����
		case 13033:	//�Ŵ� ���� ����
		case 13034:	//�ʰŴ� ����
		case 13035:	//Ȳ�� ����
		case 13036:	//���ݼ����� ��������
		case 13098:	//����ã�� ��������
		case 13120:	//�Ŵ� ��
		case 13121:	
		case 13122:	
		case 13123:	
		case 13124:	

		// ���� �̺�Ʈ 2009. 8.14 �߰� 
		case 13271:
		case 13272:
		case 13273:
		case 13274:
		case 13275:
		case 13276:
		case 13277:
		case 13278:

		// �� �̺�Ʈ 2009. 8.14 �߰� 
		case 13187:
		case 13188:
		case 13189:
		case 13190:
		case 13191:
		case 13192:

		// ��ȣ �̺�Ʈ 2019. 2.29 �߰� 
		case 13286: // �Ʊ� ��ȣ
		case 13287: // �Ʊ� ��ȣ ����
		case 13288: // ����� �Ʊ� ��ȣ
		case 13289: // ����� �Ʊ� ��ȣ ����
		case 13290: // ��ȣ
		case 13291: // ��ȣ ����
		case 13292: // ���� ������ ����

			 bIsAllWhiteName = true;
			 break;
	}	
	return bIsAllWhiteName;
}

//HP �ٵ� ǥ���ϸ� �ȵǴ� �������� üũ�ϴ� �Լ�
function bool IsNoBarID(int m_TargetID)
{
	local bool	bIsNoBarName;
	bIsNoBarName = false;
	
	switch( m_TargetID )
	{
		case 13036:	//���ݼ����� ��������
		case 13098:	//����ã�� ��������
			bIsNoBarName = true;
			break;
	}	
	return bIsNoBarName;
}


defaultproperties
{
}
