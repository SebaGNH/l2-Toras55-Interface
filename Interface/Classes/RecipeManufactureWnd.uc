class RecipeManufactureWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// RECIPE CONST
//////////////////////////////////////////////////////////////////////////////
const RECIPEWND_MAX_MP_WIDTH = 165.0f;

var int		m_RecipeID;		//RecipeID
var int		m_SuccessRate;		//성공률
var int		m_RecipeBookClass;	//드워프? 일반? 공방
var bool		m_MultipleProduct;
var int		m_MaxMP;
var int		m_PlayerID;
var int		xMulti;
var int MakingResultGlobal, CurrentMPGlobal, MPConsumeGlobal, GlobalAvailable;
var Color enableColor, disableColor;
var BarHandle MPBar;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeItemMakeInfo );
	RegisterEvent( EV_UpdateMP );
	RegisterEvent( EV_SystemMessage );
	RegisterEvent( EV_InventoryAddItem );
	RegisterEvent( EV_InventoryUpdateItem );
}

function OnLoad()
{
	
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
	{
		MPBar = BarHandle( GetHandle( "RecipeManufactureWnd.barMp" ) );
	}
	else
	{
		MPBar = GetBarHandle( "RecipeManufactureWnd.barMp" );
	}
	enableColor.R = 220;
	enableColor.G = 220;
	enableColor.B = 220;
	disableColor.R = 130;
	disableColor.G = 130;
	disableColor.B = 130;
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.AvailableTB","Available: ");
}

function OnShow()
{
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.AvailableTB","Available: ");
	GlobalAvailable = 0;
	MPConsumeGlobal = -1;
	CurrentMPGlobal = -1;
	MakingResultGlobal = -1;
	class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB","1");
	class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnManufacture");
	class'UIAPI_BUTTON'.static.HideWindow("RecipeManufactureWnd.btnStop");
	class'UIAPI_EDITBOX'.static.DisableWindow("RecipeManufactureWnd.QuantityEB");
//	class'UIAPI_EDITBOX'.static.SetHighLight("RecipeManufactureWnd.QuantityEB",false);
	class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeManufactureWnd.QuantityTB",disableColor);
	class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityCB");
	class'UIAPI_CHECKBOX'.static.SetCheck("RecipeManufactureWnd.QuantityCB",false);
//	m_hOwnerWnd.SetFocus();
}

function OnHide()
{
	Clear();
	class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnManufacture");
	class'UIAPI_BUTTON'.static.HideWindow("RecipeManufactureWnd.btnStop");
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.AvailableTB","Available: ");
	m_hOwnerWnd.KillTimer(4789);
	m_hOwnerWnd.KillTimer(4790);
}

function OnClickCheckBox(string strID)
{
	switch (strID)
	{
		case "QuantityCB":
			
			if (class'UIAPI_CHECKBOX'.static.IsChecked("RecipeManufactureWnd.QuantityCB"))
			{
				class'UIAPI_EDITBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityEB");
				if (GlobalAvailable == 0)
					class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB","1");
				else
					class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB",string(GlobalAvailable));
			//	class'UIAPI_EDITBOX'.static.SetHighLight("RecipeManufactureWnd.QuantityEB",true);
				class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeManufactureWnd.QuantityTB",enableColor);
			}
			else
			{
				class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB","1");
				class'UIAPI_EDITBOX'.static.DisableWindow("RecipeManufactureWnd.QuantityEB");
				//class'UIAPI_EDITBOX'.static.SetHighLight("RecipeManufactureWnd.QuantityEB",false);
				class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeManufactureWnd.QuantityTB",disableColor);
			}
		break;
	}
}

function OnEvent(int Event_ID, string param)
{
	//local Rect 	rectWnd;
	local int		ServerID;
	local int		MPValue;

	// 2006/07/10 NeverDie
	local int		msg_idx;
	local int		RecipeID;
	local int		CurrentMP;
	local int		MaxMP;
	local int		MakingResult;
	local int		Type;
	
	if (Event_ID == EV_RecipeItemMakeInfo)
	{
		Debug("EV_RecipeItemMakeInfo.... Do we have it?");
		class'UIAPI_WINDOW'.static.HideWindow("RecipeBookWnd");
		
		Clear();
		
		//윈도우의 위치를 RecipeBookWnd에 맞춤
		//rectWnd = class'UIAPI_WINDOW'.static.GetRect("RecipeBookWnd");
		//class'UIAPI_WINDOW'.static.MoveTo("RecipeManufactureWnd", rectWnd.nX, rectWnd.nY);
		
		//Show
		class'UIAPI_WINDOW'.static.ShowWindow("RecipeManufactureWnd");
		//class'UIAPI_WINDOW'.static.SetFocus("RecipeManufactureWnd");
		
		ParseInt( param, "RecipeID", RecipeID );
		ParseInt( param, "CurrentMP", CurrentMP );
		ParseInt( param, "MaxMP", MaxMP );
		ParseInt( param, "MakingResult", MakingResult );
		CurrentMPGlobal = CurrentMP;
		MakingResultGlobal = MakingResult;
		ParseInt( param, "Type", Type );
		
		ReceiveRecipeItemMakeInfo(RecipeID, CurrentMP, MaxMP, MakingResult, Type);
	}
	else if (Event_ID == EV_UpdateMP)
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentMP", MPValue);
		if (m_PlayerID==ServerID && m_PlayerID>0)
		{
			CurrentMPGlobal = MPValue;
			SetMPBar(MPValue);
		}
	}
	else if( Event_ID == EV_InventoryAddItem || Event_ID == EV_InventoryUpdateItem )
	{
		HandleInventoryItem(param);
	}
	else if ( Event_ID == EV_SystemMessage)
	{
		ParseInt(param, "Index", msg_idx);
		if ( msg_idx == 24) MakingResultGlobal = -1;
	}
}

function OnClickButton( string strID )
{
	local string param;
	
	switch( strID )
	{
	case "btnStop":
		class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnManufacture");
		class'UIAPI_BUTTON'.static.HideWindow("RecipeManufactureWnd.btnStop");
		class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityCB");
		class'UIAPI_EDITBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityEB");
		class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeManufactureWnd.QuantityTB",enableColor);
		m_hOwnerWnd.KillTimer(4789);
		m_hOwnerWnd.KillTimer(4790);		
		break;
	case "btnClose":
		CloseWindow();
		break;
	case "btnPrev":
		//RecipeBookWnd로 돌아감
		class'RecipeAPI'.static.RequestRecipeBookOpen(m_RecipeBookClass);
		
		CloseWindow();
		break;
	case "btnRecipeTree":
		if (class'UIAPI_WINDOW'.static.IsShowWindow("RecipeTreeWnd"))
		{
			class'UIAPI_WINDOW'.static.HideWindow("RecipeTreeWnd");	
		}
		else
		{
			ParamAdd(param, "RecipeID", string(m_RecipeID));
			ParamAdd(param, "SuccessRate", string(m_SuccessRate));
			ExecuteEvent( EV_RecipeShowRecipeTreeWnd, param);
		}
		break;
	case "btnManufacture":
		class'UIAPI_BUTTON'.static.HideWindow("RecipeManufactureWnd.btnManufacture");
		class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnStop");
		class'UIAPI_CHECKBOX'.static.DisableWindow("RecipeManufactureWnd.QuantityCB");
		class'UIAPI_EDITBOX'.static.DisableWindow("RecipeManufactureWnd.QuantityEB");
		class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeManufactureWnd.QuantityTB",disableColor);
		CheckMultipleCraft();		
		break;
	}
}

function CheckMultipleCraft()
{
	if (class'UIAPI_CHECKBOX'.static.IsChecked("RecipeManufactureWnd.QuantityCB"))
	{
		//MakingResult = -1;
		xMulti = int(class'UIAPI_EDITBOX'.static.GetString("RecipeManufactureWnd.QuantityEB"));
		if (xMulti > GlobalAvailable)
		{
			xMulti = GlobalAvailable;
			class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB",string(GlobalAvailable));
		}
		
		if (xMulti<=1) 
		{
			xMulti = 1;
			class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB","1");
			class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
			class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityCB");
			class'UIAPI_EDITBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityEB");
			class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeManufactureWnd.QuantityTB",enableColor);
			class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnManufacture");
			class'UIAPI_BUTTON'.static.HideWindow("RecipeManufactureWnd.btnStop");
			
		}
		else
		{
			class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnStop");
			//class'UIAPI_EDITBOX'.static.DisableWindow("RecipeManufactureWnd.QuantityEB");
			//class'UIAPI_EDITBOX'.static.SetHighLight("RecipeManufactureWnd.QuantityEB",false);
			class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeManufactureWnd.QuantityTB",disableColor);		
			if (CurrentMPGlobal>=MPConsumeGlobal) class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
			m_hOwnerWnd.SetTimer(4789, 200);
		}
	}
	else
	{
//		xMulti = StrToInt(class'UIAPI_EDITBOX'.static.GetString("RecipeManufactureWnd.QuantityEB"));
		class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB","1");
		class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityCB");
		class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
		class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnManufacture");
		class'UIAPI_BUTTON'.static.HideWindow("RecipeManufactureWnd.btnStop");
	}
}

function OnTimer(int TimerID)
{	
	if (TimerID == 4789)
	{
	//	AddSystemMessageString("4789 work");
	//	AddSystemMessageString(string(MakingResultGlobal));
		if ((MakingResultGlobal == 0) || (MakingResultGlobal == 1))
		{
			if (CurrentMPGlobal>=MPConsumeGlobal)	xMulti = xMulti - 1;
				class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB",string(xMulti));
				class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);		

			m_hOwnerWnd.KillTimer(4789);
			m_hOwnerWnd.SetTimer(4790, 200);
		}
		else
		{
			m_hOwnerWnd.KillTimer(4789);
			if (CurrentMPGlobal>=MPConsumeGlobal) class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
		//	class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
			m_hOwnerWnd.SetTimer(4789, 1000);
		}
	}
	
	if (TimerID == 4790)
	{
	//	AddSystemMessageString("4790 work");
	//	AddSystemMessageString(string(MakingResultGlobal));
		if ((xMulti>0) && ((MakingResultGlobal == 0) || (MakingResultGlobal == 1)))
		{
			if (CurrentMPGlobal>=MPConsumeGlobal) xMulti = xMulti - 1;
			//xMulti = xMulti - 1;
			class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB",string(xMulti));
			if (xMulti != 0)
			{
				class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);			
				 m_hOwnerWnd.SetTimer(4790, 200);
			}
			if (xMulti == 0)
			{
				m_hOwnerWnd.KillTimer(4790);
				class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityCB");
				class'UIAPI_EDITBOX'.static.EnableWindow("RecipeManufactureWnd.QuantityEB");
				class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeManufactureWnd.QuantityTB", enableColor);
				class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnManufacture");
				class'UIAPI_BUTTON'.static.HideWindow("RecipeManufactureWnd.btnStop");
				class'UIAPI_EDITBOX'.static.SetString("RecipeManufactureWnd.QuantityEB","1");
			}
			m_hOwnerWnd.KillTimer(4790);
		}
		if ((MakingResultGlobal == -1) && (xMulti>0))
		{
			m_hOwnerWnd.KillTimer(4790);
			if (CurrentMPGlobal>=MPConsumeGlobal) class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
			//class'RecipeAPI'.static.RequestRecipeItemMakeSelf(m_RecipeID);
			m_hOwnerWnd.SetTimer(4790, 1000);
		}
	}

}



//윈도우 닫기
function CloseWindow()
{
	Clear();
	m_hOwnerWnd.KillTimer(4789);
	m_hOwnerWnd.KillTimer(4790);
	class'UIAPI_BUTTON'.static.ShowWindow("RecipeManufactureWnd.btnManufacture");
	class'UIAPI_BUTTON'.static.HideWindow("RecipeManufactureWnd.btnStop");
	class'UIAPI_WINDOW'.static.HideWindow("RecipeManufactureWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//초기화
function Clear()
{
	m_RecipeID = 0;
	m_SuccessRate = 0;
	m_RecipeBookClass = 0;
	m_MultipleProduct = false;
	m_MaxMP = 0;
	m_PlayerID = 0;
	class'UIAPI_ITEMWINDOW'.static.Clear("RecipeManufactureWnd.ItemWnd");
}

function OnChangeEditBox( String strID )
{
	local int			i;
	local int			nTmp;
	local int			nTmp2;
	local string		param;
	local ItemInfo		infItem;
	
	switch( strID )
	{
	case "QuantityEB":
	if (class'UIAPI_BUTTON'.static.isShowWindow("RecipeManufactureWnd.btnManufacture"))
	{
		class'UIAPI_ITEMWINDOW'.static.Clear("RecipeManufactureWnd.ItemWnd");
		param = class'UIDATA_RECIPE'.static.GetRecipeMaterialItem(m_RecipeID);
		ParseInt(param, "Count", nTmp);
		for (i=0; i<nTmp; i++)
		{
		//Set ItemID
			ParseInt(param, "ID_" $ i, nTmp2);
			infItem.ID = GetItemID(nTmp2);
		
		//NeedNum
			ParseINT64(param, "NeededNum_" $ i, infItem.Reserved64);	
			infItem.Name = class'UIDATA_ITEM'.static.GetItemName(infItem.ID);
			infItem.AdditionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName(infItem.ID);
			infItem.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(infItem.ID);
			infItem.Description = class'UIDATA_ITEM'.static.GetItemDescription(infItem.ID);
			infItem.ItemNum = GetInventoryItemCount(infItem.ID);
			if (infItem.Reserved64>infItem.ItemNum)
			{

				infItem.bDisabled = true;
			}
			else 
			{	
				infItem.bDisabled = false;
			}
			class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeManufactureWnd.ItemWnd", infItem);
		}
	}
	break;
	}
}

//기본정보 셋팅
function ReceiveRecipeItemMakeInfo(int RecipeID,int CurrentMP,int MaxMP,int MakingResult,int Type)
{
	local int			i;
	
	local string		strTmp;
	local int			nTmp;
	local int			nTmp2;
	
	local int			ProductID;
	local int			ProductNum;
	local string		ItemName;
	
	local string		param;
	local ItemInfo		infItem;
	
	//전역변수 설정
	m_RecipeID = RecipeID;
	m_SuccessRate = class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
	m_MultipleProduct = bool(class'UIDATA_RECIPE'.static.GetRecipeIsMultipleProduct(RecipeID));
	m_RecipeBookClass = Type;
	m_MaxMP = MaxMP;
	debug ("MaxMP" @ MaxMP);
	m_PlayerID = class'UIDATA_PLAYER'.static.GetPlayerID();

	//Product ID
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	//(아이템)텍스쳐
	strTmp = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeManufactureWnd.texItem", strTmp);
	
	//아이템 이름
	ItemName = MakeFullItemName(ProductID);
	
	//Crystal Type(Grade Emoticon출력)
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	strTmp = GetItemGradeTextureName(nTmp);
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeManufactureWnd.texGrade", strTmp);
	
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtName", ItemName);
	
	//MP소비량
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
	MPConsumeGlobal = nTmp;
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtMPConsume", "" $ nTmp);
	
	//성공확률
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtSuccessRate", m_SuccessRate $ "%");
	
	//옵션부여가능여부
	if (m_MultipleProduct)
		class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtOption", GetSystemMessage(2320));
	else
		class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtOption", "");
		
	
	//결과물수
	ProductNum = class'UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtResultValue", "" $ ProductNum);
	
	//MP바 표시
	SetMPBar(CurrentMP);
	
	//보유갯수
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtCountValue", "" $ MakeCostString(Int64ToString(GetInventoryItemCount(GetItemID(ProductID)))));
	
	//제작결과
	strTmp = "";
	if (MakingResult == 0)
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(960), ItemName, "");
	}
	else if (MakingResult == 1)
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(959), ItemName, "" $ ProductNum);
	}
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.txtMsg", strTmp);
	
	//ItemWnd에 추가
	param = class'UIDATA_RECIPE'.static.GetRecipeMaterialItem(RecipeID);
	ParseInt(param, "Count", nTmp);
	GlobalAvailable = 0;
	for (i=0; i<nTmp; i++)
	{
		//Set ItemID
		ParseInt(param, "ID_" $ i, nTmp2);
		infItem.ID = GetItemID(nTmp2);
		
		//NeedNum
		ParseINT64(param, "NeededNum_" $ i, infItem.Reserved64);	
		infItem.Name = class'UIDATA_ITEM'.static.GetItemName(infItem.ID);
		infItem.AdditionalName = class'UIDATA_ITEM'.static.GetItemAdditionalName(infItem.ID);
		infItem.IconName = class'UIDATA_ITEM'.static.GetItemTextureName(infItem.ID);
		infItem.Description = class'UIDATA_ITEM'.static.GetItemDescription(infItem.ID);
		infItem.ItemNum = GetInventoryItemCount(infItem.ID);
		if (i==0) GlobalAvailable = INT64ToInt(infItem.ItemNum)/INT64ToInt(infItem.Reserved64);
		if (i>0)
			if (GlobalAvailable > INT64ToInt(infItem.ItemNum)/INT64ToInt(infItem.Reserved64)) GlobalAvailable = INT64ToInt(infItem.ItemNum)/INT64ToInt(infItem.Reserved64);
		if (infItem.Reserved64>infItem.ItemNum)
		{
	//		GlobalAvailable = 0;
			infItem.bDisabled = true;
		}
		else 
		{	
	//		if (GlobalAvailable > INT64ToInt(infItem.ItemNum)/INT64ToInt(infItem.Reserved64)) GlobalAvailable = 
	//		AddSystemMessageString(string(GlobalAvailable));
			infItem.bDisabled = false;
	//		AddSystemMessageString(string(div(infItem.ItemNum/infItem.Reserved64)));
	//		if ((infItem.ItemNum/infItem.Reserved64)>=1)
	//		{
	//			if (InStr(string(infItem.ItemNum/infItem.Reserved64),".") != -1)
	//				
					
	//		}
		}
		class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeManufactureWnd.ItemWnd", infItem);
	}
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.AvailableTB","Available: " $ GlobalAvailable);
	//AddSystemMessageString(string(GlobalAvailable) @ "from receive make info");
}

//MP Bar
function SetMPBar(int CurrentMP)
{
	/*
	local int	nTmp;
	local int	nMPWidth;
	
	nTmp = RECIPEWND_MAX_MP_WIDTH * CurrentMP;
	nMPWidth = nTmp / m_MaxMP;
	if (nMPWidth>RECIPEWND_MAX_MP_WIDTH)
	{
		nMPWidth = RECIPEWND_MAX_MP_WIDTH;
	}
	class'UIAPI_WINDOW'.static.SetWindowSize("RecipeManufactureWnd.texMPBar", nMPWidth, 12);
	*/
	
	MPBar.SetValue(m_MaxMP , CurrentMP);
}

//인벤아이템이 업데이트되면 아이템의 현재보유수를 바꿔준다
function HandleInventoryItem(string param)
{
	local ItemID cID;
	local int idx;
	local ItemInfo infItem;
	
	if (ParseItemID( param, cID ))
	{
		idx = class'UIAPI_ITEMWINDOW'.static.FindItem( "RecipeManufactureWnd.ItemWnd", cID);	// ClassID
		if (idx>-1)
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeManufactureWnd.ItemWnd", idx, infItem);
			infItem.ItemNum = GetInventoryItemCount(infItem.ID);
			if (GlobalAvailable > INT64ToInt(infItem.ItemNum)/INT64ToInt(infItem.Reserved64)) GlobalAvailable = INT64ToInt(infItem.ItemNum)/INT64ToInt(infItem.Reserved64);
			if (infItem.Reserved64>infItem.ItemNum)
				infItem.bDisabled = true;
			else
				infItem.bDisabled = false;
			class'UIAPI_ITEMWINDOW'.static.SetItem( "RecipeManufactureWnd.ItemWnd", idx, infItem);
		}
	//	AddSystemMessageString(string(GlobalAvailable) @ "from invetory update");
	}
	class'UIAPI_TEXTBOX'.static.SetText("RecipeManufactureWnd.AvailableTB","Available: " $ GlobalAvailable);
}
defaultproperties
{
}
