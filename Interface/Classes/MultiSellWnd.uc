class MultiSellWnd extends UICommonAPI;

const MULTISELLWND_DIALOG_OK=1122;
var WindowHandle Me;
var TextBoxHandle PointItemName;
var TextBoxHandle txtPointItemDescription;
var TextureHandle t_first;
var TextureHandle t_second;
var TextureHandle t_third;
var TextureHandle t_fourth;
var ItemWindowHandle ItemList;

struct MultiSellInfo
{
	var int 				MultiSellInfoID;
	var int 				MultiSellType;
//	var INT64 				NeededItemNum;
	var	ItemInfo			ResultItemInfo;
	var array< ItemInfo >	OutputItemInfoList;
	var array< ItemInfo >	InputItemInfoList;
};

var array< MultiSellInfo >	m_MultiSellInfoList;
var int						m_MultiSellGroupID;
var int						m_nSelectedMultiSellInfoIndex;
var int						m_nCurrentMultiSellInfoIndex;
var int						MultiSell;
var INT64					GlobalItemCount,GlobalAvailable;
var string					GlobalParam;

function OnRegisterEvent()
{
	registerEvent( EV_MultiSellInfoListBegin );
	registerEvent( EV_MultiSellResultItemInfo );
	registerEvent( EV_MultiSellOutputItemInfo );
	registerEvent( EV_MultiSellInputItemInfo );
	registerEvent( EV_MultiSellInfoListEnd );
	registerEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		PointItemName = TextBoxHandle ( GetHandle( "PointItemName" ) );
		txtPointItemDescription = TextBoxHandle ( GetHandle( "txtPointItemDescription" ) );
		ItemList = ItemWindowHandle( GetHandle( "MultiSellWnd.ItemList"));
	}
	else
	{
		Me = GetWindowHandle("MultiSellWnd");
		PointItemName = GetTextBoxHandle ( "PointItemName" );
		txtPointItemDescription = GetTextBoxHandle ("txtPointItemDescription" );
		ItemList = GetItemWindowHandle("MultiSellWnd.ItemList");
		t_first =  GetTextureHandle( "MultiSellWnd.firstLayer" );
		t_second =  GetTextureHandle( "MultiSellWnd.secondLayer" );
		t_third =  GetTextureHandle( "MultiSellWnd.thirdLayer" );
		t_fourth =  GetTextureHandle( "MultiSellWnd.fourthLayer" );
	}
	class'UIAPI_EDITBOX'.static.SetString("MultiSellWnd.ItemCountEdit","1");
	class'UIAPI_WINDOW'.static.EnableWindow("MultiSellWnd.ItemCountEdit");
	class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.AvailableTB","Available: ");
	GlobalAvailable = IntToINT64(0);
	MultiSell = 0;
	m_nSelectedMultiSellInfoIndex = -1;
	t_first.HideWindow();
	t_second.HideWindow();
	t_third.HideWindow();
	t_fourth.HideWindow();
	PointItemName.HideWindow();
	txtPointItemDescription.HideWindow();
}

function OnEvent(int Event_ID, string param)
{
	switch( Event_ID )
	{
	case EV_MultiSellInfoListBegin:
		HandleMultiSellInfoListBegin( param );
		break;
	case EV_MultiSellResultItemInfo:
		HandleMultiSellResultItemInfo( param );
		break;
	case EV_MultiSellOutputItemInfo:
		HandelMultiSellOutputItemInfo( param );
		break;
	case EV_MultiSellInputItemInfo:
		HandelMultiSellInputItemInfo( param );
		break;
	case EV_MultiSellInfoListEnd:
		HandleMultiSellInfoListEnd( param );
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	default:
		break;
	};
}

function OnShow()
{
	class'UIAPI_EDITBOX'.static.Clear("MultiSellWnd.ItemCountEdit");
	class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.AvailableTB","Available: ");
	class'UIAPI_EDITBOX'.static.SetString("MultiSellWnd.ItemCountEdit","1");
	GlobalItemCount = IntToINT64(1);
	MultiSell = 0;
	GlobalAvailable = IntToINT64(0);
	GlobalParam = "";
}

function OnHide()
{
	class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.AvailableTB","Available: ");
	Me.KillTimer(6670);
	Me.KillTimer(6671);
}

function OnClickButton( string ControlName )
{
	if( ControlName == "OKButton" )
	{
		HandleOKButton();
	}
	else if( ControlName == "CancelButton" )
	{
		Clear();
		HideWindow("MultiSellWnd");
	}
}


function bool GetMyUserInfo( out UserInfo a_MyUserInfo )
{
	return GetPlayerInfo( a_MyUserInfo );
}

function CustomTooltip SetTooltip(string Name, string AdditionalName, string GradeTexture, int CrystalType)
{
	local CustomTooltip Tooltip;
	local DrawItemInfo info;
	local DrawItemInfo infoClear;
	
	Tooltip.DrawList.Length = 3;

	info = infoClear;
	info.eType = DIT_TEXT;
	info.t_bDrawOneLine = true;
	info.t_strText = Name;
	Tooltip.DrawList[0] = info;
	
	info = infoClear;
	info.bLineBreak = false;
	info.t_bDrawOneLine = true;
	info.eType = DIT_TEXT;
	info.t_strText = "";
	Tooltip.DrawList[1] = info;
	if (AdditionalName != "")
	{	
		info = infoClear;
		info.eType = DIT_TEXT;
		info.t_bDrawOneLine = true;
		info.t_color.R = 255;
		info.t_color.G = 215;
		info.t_color.B = 0;
		info.t_color.A = 255;
		info.t_strText = " " $ AdditionalName;
		Tooltip.DrawList[1] = info;
	}
	
	
	info = infoClear;
	info.bLineBreak = false;
	info.t_bDrawOneLine = true;
	Tooltip.DrawList[2] = info;
	if (GradeTexture != "")
	{
		info = infoClear;
		info.eType = DIT_TEXTURE;
		info.nOffSetX = 2;
		info.t_bDrawOneLine = true;
		if (CrystalType == 6 || CrystalType == 7)
		{
			info.u_nTextureWidth = 32;
			info.u_nTextureHeight = 16;
			
			info.u_nTextureUWidth = 32;
			info.u_nTextureUHeight = 16;
		}
		else
		{
			info.u_nTextureWidth = 16;
			info.u_nTextureHeight = 16;
			
			info.u_nTextureUWidth = 16;
			info.u_nTextureUHeight = 16;
		}
		info.u_strTexture = GradeTexture;
		Tooltip.DrawList[2] = info;
	}
	return Tooltip;
}

function OnSelectItemWithHandle( ItemWindowHandle a_hItemWindow, int index )
{
	local int i;
	local string param;
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	local string		TextureName, strTmp, strRetName;
	local INT64		nTmp;
	local UserInfo	info;
	local PCCafeEventWnd script_pc;
//	local ItemInfo info1;
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.ItemInfo");
//	class'UIAPI_MULTISELLNEEDEDITEM'.static.Clear("MultiSellWnd.NeededItem");
	class'UIAPI_TREECTRL'.static.Clear("MultiSellWnd.NeedItem");
	t_first.HideWindow();
	t_second.HideWindow();
	t_third.HideWindow();
	t_fourth.HideWindow();
	infNode.strName = "root";
	infNode.nOffSetX = 0;
	infNode.nOffSetY = 2;
	strTmp = class'UIAPI_TREECTRL'.static.InsertNode("MultiSellWnd.NeedItem", "", infNode);
//	a_hItemWindow.GetSelectedItem( info1 );
//	printItemInfo(info1);
	if (a_hItemWindow == ItemList )
	{
		if( index >= 0 && index < m_MultiSellInfoList.Length )
		{
			for( i=0 ; i < m_MultiSellInfoList[index].InputItemInfoList.Length ; ++i )
			{
			//	AddSystemMessageString("ItemCOunt - " $ Int64ToString(GlobalItemCount));
				param = "";
				ParamAdd( param, "Name",		m_MultiSellInfoList[index].InputItemInfoList[i].Name );
				ParamAdd( param, "ID",			string(m_MultiSellInfoList[index].InputItemInfoList[i].Id.ClassID ));
				ParamAddInt64( param, "Num",	m_MultiSellInfoList[index].InputItemInfoList[i].ItemNum);
				ParamAdd( param, "Icon",		m_MultiSellInfoList[index].InputItemInfoList[i].IconName );
				ParamAdd( param, "Enchant",		string(m_MultiSellInfoList[index].InputItemInfoList[i].Enchanted) );
				ParamAdd( param, "CrystalType", string(m_MultiSellInfoList[index].InputItemInfoList[i].CrystalType) );
				ParamAdd( param, "ItemType",	string(m_MultiSellInfoList[index].InputItemInfoList[i].ItemType) );
				ParamAdd( param, "IconPanel",	m_MultiSellInfoList[index].InputItemInfoList[i].IconPanel );			// -- 판넬 추가 -_-;;
		//		ParamAdd( param, "ForeTexture",	m_MultiSellInfoList[index].InputItemInfoList[i].ForeTexture );
				//debug("what the hell");

				//debug("AddData " $ param );
			//	class'UIAPI_MULTISELLNEEDEDITEM'.static.AddData("MultiSellWnd.NeededItem", param);
			
				if (m_MultiSellInfoList[index].InputItemInfoList[i].IconPanel=="icon.low_tab") 
				{	
					if(i==0) 
					{
						t_first.SetTexture("icon.low_tab");
						t_first.ShowWindow();
					}
					if(i==1) 
					{
						t_second.SetTexture("icon.low_tab");
						t_second.ShowWindow();
					}
				}
				
				if (m_MultiSellInfoList[index].InputItemInfoList[i].Enchanted>0) 
				{	
					if(i==0) 
					{
						t_third.SetTexture("pug.enchant"$m_MultiSellInfoList[index].InputItemInfoList[i].Enchanted);
						t_third.ShowWindow();
					}
					if (m_MultiSellInfoList[index].InputItemInfoList[i].IconPanel=="icon.pvp_tab")

					{
						t_first.SetTexture("icon.pvp_tab");
						t_first.ShowWindow();
					}
				}
				TextureName = GetItemGradeTextureName(m_MultiSellInfoList[index].InputItemInfoList[i].CrystalType);
				
				infNode = infNodeClear;
				infNode.strName = "" $ string(m_MultiSellInfoList[index].InputItemInfoList[i].Id.ClassID )$string(i);
				if (m_MultiSellInfoList[index].InputItemInfoList[i].Enchanted>0)
					infNode.Tooltip = SetTooltip("+" $ string(m_MultiSellInfoList[index].InputItemInfoList[i].Enchanted) @ m_MultiSellInfoList[index].InputItemInfoList[i].Name, m_MultiSellInfoList[index].InputItemInfoList[i].AdditionalName, TextureName,m_MultiSellInfoList[index].InputItemInfoList[i].CrystalType);
				else
					infNode.Tooltip = SetTooltip(m_MultiSellInfoList[index].InputItemInfoList[i].Name, m_MultiSellInfoList[index].InputItemInfoList[i].AdditionalName, TextureName,m_MultiSellInfoList[index].InputItemInfoList[i].CrystalType);					
				infNode.nOffSetY = 4;
				infNode.bShowButton = 0;
				strRetName = class'UIAPI_TREECTRL'.static.InsertNode("MultiSellWnd.NeedItem","root", infNode);
												
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXTURE;
				infNodeItem.nOffSetX = 0;
				infNodeItem.nOffSetY = 0;
				infNodeItem.u_nTextureWidth = 32;
				infNodeItem.u_nTextureHeight = 32;
				infNodeItem.u_strTexture = m_MultiSellInfoList[index].InputItemInfoList[i].IconName;
				class'UIAPI_TREECTRL'.static.InsertNodeItem("MultiSellWnd.NeedItem", strRetName, infNodeItem);
							
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXT;
				infNodeItem.t_strText = m_MultiSellInfoList[index].InputItemInfoList[i].Name;
				if (m_MultiSellInfoList[index].InputItemInfoList[i].Enchanted>0)
					infNodeItem.t_strText = "+" $ string(m_MultiSellInfoList[index].InputItemInfoList[i].Enchanted) @ m_MultiSellInfoList[index].InputItemInfoList[i].Name;
				if (Len(infNodeItem.t_strText @ m_MultiSellInfoList[index].InputItemInfoList[i].AdditionalName)>29) 
				{
					infNodeItem.t_strText = Left(infNodeItem.t_strText, 28 - Len(m_MultiSellInfoList[index].InputItemInfoList[i].AdditionalName) - 4) $ "...";
				}				
				infNodeItem.t_bDrawOneLine = true;
				infNodeItem.nOffSetX = 2;
				infNodeItem.nOffSetY = 3;
				class'UIAPI_TREECTRL'.static.InsertNodeItem("MultiSellWnd.NeedItem", strRetName, infNodeItem);
						
				if (m_MultiSellInfoList[index].InputItemInfoList[i].AdditionalName != "")
				{
					infNodeItem = infNodeItemClear;
					infNodeItem.eType = XTNITEM_TEXT;
					infNodeItem.t_strText = m_MultiSellInfoList[index].InputItemInfoList[i].AdditionalName;
					infNodeItem.t_bDrawOneLine = true;
					infNodeItem.nOffSetX = 3;
					infNodeItem.nOffSetY = 3;
					infNodeItem.t_color.R = 255;
					infNodeItem.t_color.G = 215;
					infNodeItem.t_color.B = 0;
					infNodeItem.t_color.A = 255;
					class'UIAPI_TREECTRL'.static.InsertNodeItem("MultiSellWnd.NeedItem", strRetName, infNodeItem);
				}
				

				if (Len(TextureName)>0)
				{
					infNodeItem.eType = XTNITEM_TEXTURE;
					infNodeItem.nOffSetX = 2;
					infNodeItem.nOffSetY = 3;
					if (m_MultiSellInfoList[index].InputItemInfoList[i].CrystalType == 6 || m_MultiSellInfoList[index].InputItemInfoList[i].CrystalType == 7)
					{
						infNodeItem.u_nTextureWidth = 32;
						infNodeItem.u_nTextureHeight = 16;
			
						infNodeItem.u_nTextureUWidth = 32;
						infNodeItem.u_nTextureUHeight = 16;
					}
					else
					{
						infNodeItem.u_nTextureWidth = 16;
						infNodeItem.u_nTextureHeight = 16;
			
						infNodeItem.u_nTextureUWidth = 16;
						infNodeItem.u_nTextureUHeight = 16;
					}
					infNodeItem.u_strTexture = TextureName;
					class'UIAPI_TREECTRL'.static.InsertNodeItem("MultiSellWnd.NeedItem", strRetName, infNodeItem);
				}
			
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXT;
				infNodeItem.t_strText = " x " $ MakeCostStringInt64(GlobalItemCount * (m_MultiSellInfoList[index].InputItemInfoList[i].ItemNum));
			//	AddSystemMessageString(MakeCostStringInt64(GlobalItemCount * (m_MultiSellInfoList[index].InputItemInfoList[i].ItemNum)));
				infNodeItem.bLineBreak = true;
				infNodeItem.nOffSetX = 31;
				infNodeItem.nOffSetY = -14;
				class'UIAPI_TREECTRL'.static.InsertNodeItem("MultiSellWnd.NeedItem", strRetName, infNodeItem);
				
				infNodeItem = infNodeItemClear;
				infNodeItem.eType = XTNITEM_TEXT;
				nTmp = GetInventoryItemCount(GetItemID(m_MultiSellInfoList[index].InputItemInfoList[i].Id.ClassID ));
				//AddSystemMessageString(m_MultiSellInfoList[index].InputItemInfoList[i].IconName);
				if (m_MultiSellInfoList[index].InputItemInfoList[i].IconName == "icon.pvp_point_i00")
					if (GetMyUserInfo(info))
					{
						nTmp = IntToINT64(info.PvPPoint);
					}
				if (m_MultiSellInfoList[index].InputItemInfoList[i].IconName == "icon.etc_i.etc_pccafe_point_i00")					
					{
						script_pc = PCCafeEventWnd(GetScript("PCCafeEventWnd"));
						nTmp = IntToINT64(script_pc.m_TotalPoint);
					}
				if (i==0) GlobalAvailable = nTmp/m_MultiSellInfoList[index].InputItemInfoList[i].ItemNum;
				if (i>=0)
					if (GlobalAvailable > nTmp/m_MultiSellInfoList[index].InputItemInfoList[i].ItemNum) GlobalAvailable = nTmp/m_MultiSellInfoList[index].InputItemInfoList[i].ItemNum;
				class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.AvailableTB","Available: " $ Int64ToString(GlobalAvailable));
				infNodeItem.t_strText = " (" $ MakeCostStringInt64(nTmp) $ ")";
				infNodeItem.nOffSetX = 0;
				infNodeItem.nOffSetY = -14;
				if (nTmp<(GlobalItemCount * m_MultiSellInfoList[index].InputItemInfoList[i].ItemNum))
				{
						infNodeItem.t_color.R = 168;
						infNodeItem.t_color.G = 168;
						infNodeItem.t_color.B = 168;
						infNodeItem.t_color.A = 255;
				}
				class'UIAPI_TREECTRL'.static.InsertNodeItem("MultiSellWnd.NeedItem", strRetName, infNodeItem);
			}

			for( i=0 ; i < m_MultiSellInfoList[index].OutputItemInfoList.Length ; ++i )
			{
				class'UIAPI_MULTISELLITEMINFO'.static.SetItemInfo("MultiSellWnd.ItemInfo", i, m_MultiSellInfoList[index].OutputItemInfoList[i] );
				if 	(m_MultiSellInfoList[index].OutputItemInfoList[i].Enchanted>0)
				{
					t_fourth.SetTexture("pug.enchant"$m_MultiSellInfoList[index].OutputItemInfoList[i].Enchanted);
					t_fourth.ShowWindow();
				}
				if (m_MultiSellInfoList[index].OutputItemInfoList[i].IconName == "icon.pvp_point_i00")
				{
					class'UIAPI_WINDOW'.static.ShowWindow("MultiSellWnd.PointItemName");
					class'UIAPI_WINDOW'.static.ShowWindow("MultiSellWnd.txtPointItemDescription");
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.PointItemName",GetSystemString(102)$"x"$Int64ToString(m_MultiSellInfoList[index].OutputItemInfoList[i].ItemNum));
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription",GetSystemMessage(2334));
				}
				else
				{
					class'UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.PointItemName");
					class'UIAPI_WINDOW'.static.HideWindow("MultiSellWnd.txtPointItemDescription");
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.PointItemName","");
					class'UIAPI_TEXTBOX'.static.SetText("MultiSellWnd.txtPointItemDescription","");
				}
				
				
				
			}

		//	class'UIAPI_EDITBOX'.static.Clear("MultiSellWnd.ItemCountEdit");
			
		//	if( m_MultiSellInfoList[index].MultiSellType == 0 )
		//	{
			//	class'UIAPI_EDITBOX'.static.SetString("MultiSellWnd.ItemCountEdit", "1");
			//	class'UIAPI_WINDOW'.static.DisableWindow("MultiSellWnd.ItemCountEdit");
	//			GlobalItemCount = Int(class'UIAPI_EDITBOX'.static.GetString("MultiSellWnd.ItemCountEdit"));
		//	}
		//	else if( m_MultiSellInfoList[index].MultiSellType == 1 )
		//	{
			//	class'UIAPI_EDITBOX'.static.SetString("MultiSellWnd.ItemCountEdit", Int64ToString(GlobalItemCount));
			//	class'UIAPI_WINDOW'.static.EnableWindow("MultiSellWnd.ItemCountEdit");
	//			GlobalItemCount = Int(class'UIAPI_EDITBOX'.static.GetString("MultiSellWnd.ItemCountEdit"));
		//	}
			
			if(m_nSelectedMultiSellInfoIndex != index)	//다이얼로그를 없애준다. - innowind
			{
				if( DialogIsMine() )
				{
					DialogHide();
				}
			}
		}
	}
}



function Clear()
{
	m_nCurrentMultiSellInfoIndex = 0;
	m_MultiSellInfoList.Length = 0;
	m_MultiSellGroupID = 0;
	GlobalItemCount = IntToINT64(1);
	class'UIAPI_MULTISELLITEMINFO'.static.Clear("MultiSellWnd.ItemInfo");
	class'UIAPI_ITEMWINDOW'.static.Clear("MultiSellWnd.ItemList");
	class'UIAPI_TREECTRL'.static.Clear("MultiSellWnd.NeedItem");
	t_first.HideWindow();
	t_second.HideWindow();
	t_third.HideWindow();
	t_fourth.HideWindow();
}

function HandleMultiSellInfoListBegin( string param )
{

	Clear();
	ParseInt( param, "MultiSellGroupID", m_MultiSellGroupID );
}

function HandleMultiSellResultItemInfo( string param)
{
	local int		nMultiSellInfoID;
	local int		nBuyType;
	local ItemInfo	info;
	
	ParseInt( param, "MultiSellInfoID",			nMultiSellInfoID );
	ParseInt( param, "BuyType",					nBuyType );
	ParseInt( param, "Enchant",					info.Enchanted );
	ParseInt( param, "RefineryOp1",				info.RefineryOp1 );
	ParseInt( param, "RefineryOp2",				info.RefineryOp2 );
	ParseInt( param, "AttrAttackType",			info.AttackAttributeType );
	ParseInt( param, "AttrAttackValue",			info.AttackAttributeValue );
	ParseInt( param, "AttrDefenseValueFire",	info.DefenseAttributeValueFire );
	ParseInt( param, "AttrDefenseValueWater",	info.DefenseAttributeValueWater );
	ParseInt( param, "AttrDefenseValueWind",	info.DefenseAttributeValueWind );
	ParseInt( param, "AttrDefenseValueEarth",	info.DefenseAttributeValueEarth );
	ParseInt( param, "AttrDefenseValueHoly",	info.DefenseAttributeValueHoly );
	ParseInt( param, "AttrDefenseValueUnholy",	info.DefenseAttributeValueUnholy );
	
	m_nCurrentMultiSellInfoIndex = m_MultiSellInfoList.Length;
	m_MultiSellInfoList.Length = m_nCurrentMultiSellInfoIndex + 1;
	SetEnchantTex(info);
	
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID	= nMultiSellInfoID;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellType		= nBuyType;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].ResultItemInfo	= info;

}

function HandelMultiSellOutputItemInfo( string param )
{
	local int		nMultiSellInfoID;
	local int		nCurrentOutputItemInfoIndex;
	local ItemInfo	info;
	local int		nItemClassID;
	
	
	//~ local ItemInfo	info;
	//~ ParseItemID( param, info.Id );
	//~ class'UIDATA_ITEM'.static.GetItemInfo( info.Id, info );
	//~ ParseInt( param, "MultiSellInfoID",			nMultiSellInfoID );
	
	ParseItemID( param, info.ID );
	
	class'UIDATA_ITEM'.static.GetItemInfo( info.ID, info );
	

	
	ParseInt( param, "ClassID",					nItemClassID );
	ParseInt( param, "MultiSellInfoID",			nMultiSellInfoID );
	ParseInt( param, "SlotBitType",				info.SlotBitType );
	ParseInt( param, "ItemType",				info.ItemType );
	ParseInt64( param, "ItemCount",				info.ItemNum);
	ParseInt( param, "Enchant",					info.Enchanted );
	ParseInt( param, "RefineryOp1",				info.RefineryOp1);
	ParseInt( param, "RefineryOp2",				info.RefineryOp2);
	ParseInt( param, "AttrAttackType",			info.AttackAttributeType );
	ParseInt( param, "AttrAttackValue",			info.AttackAttributeValue );
	ParseInt( param, "AttrDefenseValueFire",	info.DefenseAttributeValueFire );
	ParseInt( param, "AttrDefenseValueWater",	info.DefenseAttributeValueWater );
	ParseInt( param, "AttrDefenseValueWind",	info.DefenseAttributeValueWind );
	ParseInt( param, "AttrDefenseValueEarth",	info.DefenseAttributeValueEarth );
	ParseInt( param, "AttrDefenseValueHoly",	info.DefenseAttributeValueHoly );
	ParseInt( param, "AttrDefenseValueUnholy",	info.DefenseAttributeValueUnholy );
	if (info.Enchanted>0) info.ForeTexture = "pug.enchant" $ info.Enchanted;
	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		//debug("MultiSellWnd::HandelMultiSellOutputItemInfo - Invalid nMultiSellInfoID");
		return;
	}

	if( nItemClassID == -300 )
	{
		info.Name = GetSystemString( 102 );
		info.IconName = "icon.pvp_point_i00";
		info.Enchanted = 0;
		info.ItemType = -1;
		info.Id.ClassID = 0;
	}

	// 투영병기의 경우 강제로, 100% Durability를 표시하게 합니다 - NeverDie
	if( 0 < info.Durability )
	{
		info.CurrentDurability = info.Durability;
	}
	
	nCurrentOutputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length;
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList.Length = nCurrentOutputItemInfoIndex + 1;
	SetEnchantTex(info);
	m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].OutputItemInfoList[nCurrentOutputItemInfoIndex] = info;
}

function HandelMultiSellInputItemInfo( string param )
{
	local int		nMultiSellInfoID;
	local int		nCurrentInputItemInfoIndex;
	local int		nItemClassID;
	local ItemInfo	info;

	ParseItemID( param, info.Id );
	class'UIDATA_ITEM'.static.GetItemInfo( info.Id, info );

	ParseInt( param, "MultiSellInfoID",			nMultiSellInfoID );
	ParseInt( param, "ClassID",					nItemClassID );
	ParseInt( param, "ItemType",				info.ItemType );
	ParseInt64( param, "ItemCount",				info.ItemNum);
	ParseInt( param, "Enchant",					info.Enchanted );
	ParseInt( param, "RefineryOp1",				info.RefineryOp1);
	ParseInt( param, "RefineryOp2",				info.RefineryOp2);
	ParseInt( param, "AttrAttackType",			info.AttackAttributeType );
	ParseInt( param, "AttrAttackValue",			info.AttackAttributeValue );
	ParseInt( param, "AttrDefenseValueFire",	info.DefenseAttributeValueFire );
	ParseInt( param, "AttrDefenseValueWater",	info.DefenseAttributeValueWater );
	ParseInt( param, "AttrDefenseValueWind",	info.DefenseAttributeValueWind );
	ParseInt( param, "AttrDefenseValueEarth",	info.DefenseAttributeValueEarth );
	ParseInt( param, "AttrDefenseValueHoly",	info.DefenseAttributeValueHoly );
	ParseInt( param, "AttrDefenseValueUnholy",	info.DefenseAttributeValueUnholy );

	if(m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].MultiSellInfoID != nMultiSellInfoID)
	{
		//debug("MultiSellWnd::HandelMultiSellInputItemInfo - Invalid nMultiSellInfoID");
		return;
	}
	
	if( nItemClassID == -100 )
	{
		info.Name = GetSystemString(1277);
		info.IconName = "icon.etc_i.etc_pccafe_point_i00";
		info.Enchanted = 0;
		info.ItemType = -1;
		info.Id.ClassID = 0;
	}
	else if( nItemClassID == -200 )
	{
		info.Name = GetSystemString( 1311 );
		info.IconName = "icon.etc_i.etc_bloodpledge_point_i00";
		info.Enchanted = 0;
		info.ItemType = -1;
		info.Id.ClassID = 0;
	}
	else if( nItemClassID == -300 )
	{
		info.Name = GetSystemString( 102 );
		info.IconName = "icon.pvp_point_i00";
		info.Enchanted = 0;
		info.ItemType = -1;
		info.Id.ClassID = 0;
	}
	else
	{
		info.Name = class'UIDATA_ITEM'.static.GetItemName( info.Id );
		info.IconName = class'UIDATA_ITEM'.static.GetItemTextureName( info.Id );
	}

	info.ItemType = class'UIDATA_ITEM'.static.GetItemDataType( info.Id );
	info.CrystalType = class'UIDATA_ITEM'.static.GetItemCrystalType( info.Id );
	
	//-400 필드사이클일 경우 아무 데이터도 삽입하지 안ㅅ는 식으로 처리 함. 
	if (nItemClassID != -400 )
	{
		nCurrentInputItemInfoIndex = m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length;
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList.Length = nCurrentInputItemInfoIndex + 1;
		SetEnchantTex(info);
		m_MultiSellInfoList[m_nCurrentMultiSellInfoIndex].InputItemInfoList[nCurrentInputItemInfoIndex] = info;
	}
}

function HandleMultiSellInfoListEnd( string param )
{
	local WindowHandle m_inventoryWnd;
	
	if(CREATE_ON_DEMAND==0)
		m_inventoryWnd = GetHandle( "InventoryWnd" );	//인벤토리
	else
		m_inventoryWnd = GetWindowHandle( "InventoryWnd" );	//인벤토리
	
	if( m_inventoryWnd.IsShowWindow() )			//인벤토리 창이 열려있으면 닫아준다. 
	{
		m_inventoryWnd.HideWindow();
	}	
	
	ShowWindow("MultiSellWnd");
	class'UIAPI_WINDOW'.static.SetFocus("MultiSellWnd");
	ShowItemList();
}

function ShowItemList()
{
	local ItemInfo info;
	local int i;

	for( i=0 ; i < m_MultiSellInfoList.Length ; ++i )
	{
		info = m_MultiSellInfoList[i].OutputItemInfoList[0];
		SetEnchantTex(info);
		class'UIAPI_ITEMWINDOW'.static.AddItem( "MultiSellWnd.ItemList", info );
	}
}

function HandleOKButton()
{
	local int selectedIndex;
	local INT64 itemNum;

	selectedIndex = class'UIAPI_ITEMWINDOW'.static.GetSelectedNum("MultiSellWnd.ItemList");
	itemNum = StringToInt64(class'UIAPI_EDITBOX'.static.GetString("MultiSellWnd.ItemCountEdit"));
	
	if( selectedIndex >= 0 )
	{
		DialogSetReservedInt( selectedIndex );
		DialogSetReservedInt2( itemNum );
		DialogSetID( MULTISELLWND_DIALOG_OK );
		DialogShow(DIALOG_Modalless,DIALOG_Warning, GetSystemMessage(1383));
		m_nSelectedMultiSellInfoIndex = selectedIndex;
	}
}

function OnChangeEditBox( String strID )
{
	local int selectedIndex;
	switch( strID )
	{
	case "ItemCountEdit":
		selectedIndex = class'UIAPI_ITEMWINDOW'.static.GetSelectedNum("MultiSellWnd.ItemList");
		if( selectedIndex >= 0 )
		{
			GlobalItemCount = StringToInt64(class'UIAPI_EDITBOX'.static.GetString("MultiSellWnd.ItemCountEdit"));
			m_nSelectedMultiSellInfoIndex = selectedIndex;
		//	AddSystemMessageString("EB Changed");
			OnSelectItemWithHandle( ItemList, m_nSelectedMultiSellInfoIndex);
		}
	break;
	}
}

function HandleDialogOK()
{
	local string param;
	local int SelectedIndex;

	if( DialogIsMine() )
	{
		SelectedIndex = DialogGetReservedInt();

		if( SelectedIndex >= m_MultiSellInfoList.Length )
		{
			return;
		}
		
		if (StringToInt64(class'UIAPI_EDITBOX'.static.GetString("MultiSellWnd.ItemCountEdit")) <= IntToINT64(0))
		{
			return;
		}
		
		ParamAdd( param, "MultiSellGroupID",		string( m_MultiSellGroupID ) );
		ParamAdd( param, "MultiSellInfoID",			string( m_MultiSellInfoList[SelectedIndex].MultiSellInfoID ) );
		ParamAdd( param, "Enchant",					string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.Enchanted ) );
		ParamAdd( param, "RefineryOp1",				string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp1 ) );
		ParamAdd( param, "RefineryOp2",				string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.RefineryOp2 ) );
		ParamAdd( param, "AttrAttackType",			string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeType ) );
		ParamAdd( param, "AttrAttackValue",			string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.AttackAttributeValue ) );
		ParamAdd( param, "AttrDefenseValueFire",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueFire ) );
		ParamAdd( param, "AttrDefenseValueWater",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWater ) );
		ParamAdd( param, "AttrDefenseValueWind",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueWind ) );
		ParamAdd( param, "AttrDefenseValueEarth",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueEarth ) );
		ParamAdd( param, "AttrDefenseValueHoly",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueHoly ) );
		ParamAdd( param, "AttrDefenseValueUnholy",	string( m_MultiSellInfoList[SelectedIndex].ResultItemInfo.DefenseAttributeValueUnholy ) );

		if( m_MultiSellInfoList[SelectedIndex].MultiSellType == 0 )
		{
		class'UIAPI_EDITBOX'.static.DisableWindow("MultiSellWnd.ItemCountEdit");
		ParamAddINT64( param, "ItemCount",			IntToINT64(1) );
		GlobalParam = param;	
		MultiSell	= 0;	
		Me.SetTimer(6671,100);
		}
		else if( m_MultiSellInfoList[SelectedIndex].MultiSellType == 1 )
		{
			class'UIAPI_EDITBOX'.static.DisableWindow("MultiSellWnd.ItemCountEdit");
		ParamAddINT64( param, "ItemCount",			GlobalItemCount );
		RequestMultiSellChoose( param );
		Me.SetTimer(6670,300);
		}

		
	}
}






function OnTimer(int TimerID)
{

	if (TimerID == 6670)
	{
	//	AddSystemMessageString("Timer");
		OnSelectItemWithHandle( ItemList, m_nSelectedMultiSellInfoIndex);
		class'UIAPI_EDITBOX'.static.EnableWindow("MultiSellWnd.ItemCountEdit");
		Me.KillTimer(6670);
	}
	if (TimerID == 6671)
	{
		if (GlobalItemCount <= GlobalAvailable)
		{
		//	AddSystemMessageString("Timer2");		
			RequestMultiSellChoose( GlobalParam );
			MultiSell = MultiSell +1;
			Me.KillTimer(6671);
			Me.SetTimer(6671,300);
			if (MultiSell == INT64ToInt(GlobalItemCount)) 
			{
				Me.KillTimer(6671);
				Me.SetTimer(6670,300);
	//		OnSelectItemWithHandle( ItemList, m_nSelectedMultiSellInfoIndex);
				MultiSell = 0;
			}
		}
		else
		if (GlobalItemCount > GlobalAvailable)
		{
		//	AddSystemMessageString("Timer2");		
			RequestMultiSellChoose( GlobalParam );
			MultiSell = MultiSell +1;
			Me.KillTimer(6671);
			Me.SetTimer(6671,300);
			if (IntToINT64(MultiSell) == GlobalAvailable) 
			{
				Me.KillTimer(6671);
				Me.SetTimer(6670,300);
	//		OnSelectItemWithHandle( ItemList, m_nSelectedMultiSellInfoIndex);
				MultiSell = 0;
			}
		}
//		OnSelectItemWithHandle( ItemList, m_nSelectedMultiSellInfoIndex);
		
	}

}
defaultproperties
{
}
