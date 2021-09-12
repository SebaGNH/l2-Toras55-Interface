class RecipeBuyManufactureWnd extends UICommonAPI;

//////////////////////////////////////////////////////////////////////////////
// RECIPE CONST
//////////////////////////////////////////////////////////////////////////////
const RECIPEWND_MAX_MP_WIDTH = 165.0f;

const CRYSTAL_TYPE_WIDTH = 14;
const CRYSTAL_TYPE_HEIGHT = 14;

var int		m_MerchantID;	//판매자의 ServerID
var int		m_RecipeID;	//RecipeID
var int		m_SuccessRate;	//성공률
var INT64	m_Adena;		//아데나
var int		m_MaxMP;
var int		xMulti;
var int MakingResultGlobal, GlobalAvailable, CraftDistance;
var Color enableColor, disableColor;

var BarHandle MPBar;
var	ItemWindowHandle	m_invenItem;

function OnRegisterEvent()
{
	RegisterEvent( EV_RecipeShopItemInfo );
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
		MPBar = BarHandle( GetHandle( "RecipeBuyManufactureWnd.barMp" ) );
	}
	else
	{
		m_invenItem	= GetItemWindowHandle("InventoryWnd.InventoryItem");
		MPBar = GetBarHandle( "RecipeBuyManufactureWnd.barMp" );
	}
	enableColor.R = 220;
	enableColor.G = 220;
	enableColor.B = 220;
	disableColor.R = 130;
	disableColor.G = 130;
	disableColor.B = 130;
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.AvailableTB","Available: ");
}

function OnShow()
{
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.AvailableTB","Available: ");
	CraftDistance = 0;
	GlobalAvailable = 0;
	//MPConsumeGlobal = -1;
	//CurrentMPGlobal = -1;
	MakingResultGlobal = -1;
	class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB","1");
	class'UIAPI_EDITBOX'.static.DisableWindow("RecipeBuyManufactureWnd.QuantityEB");
	class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnManufacture");
	class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnStop");	
//	class'UIAPI_EDITBOX'.static.SetHighLight("RecipeManufactureWnd.QuantityEB",false);
	class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB",disableColor);
	class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityCB");
	class'UIAPI_CHECKBOX'.static.SetCheck("RecipeBuyManufactureWnd.QuantityCB",false);
//	m_hOwnerWnd.SetFocus();
}

function OnHide()
{
	Clear();
	class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnManufacture");
	class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnStop");
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.AvailableTB","Available: ");
	m_hOwnerWnd.KillTimer(4791);
	m_hOwnerWnd.KillTimer(4792);
}

function OnClickCheckBox(string strID)
{
	switch (strID)
	{
		case "QuantityCB":
			
			if (class'UIAPI_CHECKBOX'.static.IsChecked("RecipeBuyManufactureWnd.QuantityCB"))
			{
				class'UIAPI_EDITBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityEB");
				if (GlobalAvailable == 0)
					class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB","1");
				else
					class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB",string(GlobalAvailable));
			//	class'UIAPI_EDITBOX'.static.SetHighLight("RecipeManufactureWnd.QuantityEB",true);
				class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB",enableColor);
			}
			else
			{
				class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB","1");
				class'UIAPI_EDITBOX'.static.DisableWindow("RecipeBuyManufactureWnd.QuantityEB");
				//class'UIAPI_EDITBOX'.static.SetHighLight("RecipeManufactureWnd.QuantityEB",false);
				class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB",disableColor);
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
	local int		MerchantID;
	local int		RecipeID;
	local int		CurrentMP;
	local int		MaxMP;
	local int		MakingResult;
	local INT64		Adena;
	
	if (Event_ID == EV_RecipeShopItemInfo)
	{
		class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyListWnd");
		
		Clear();
		
		//윈도우의 위치를 RecipeBuyListWnd에 맞춤
	//	rectWnd = class'UIAPI_WINDOW'.static.GetRect("RecipeBuyListWnd");
	//	class'UIAPI_WINDOW'.static.MoveTo("RecipeBuyManufactureWnd", rectWnd.nX, rectWnd.nY);
		
		//show
		class'UIAPI_WINDOW'.static.ShowWindow("RecipeBuyManufactureWnd");
		class'UIAPI_WINDOW'.static.SetFocus("RecipeBuyManufactureWnd");
		
		ParseInt( param, "MerchantID", MerchantID );
		ParseInt( param, "RecipeID", RecipeID );
		ParseInt( param, "CurrentMP", CurrentMP );
		ParseInt( param, "MaxMP", MaxMP );
		ParseInt( param, "MakingResult", MakingResult );
		ParseINT64( param, "Adena", Adena );
	//	CurrentMPGlobal = CurrentMP;
		MakingResultGlobal = MakingResult;
//		debug("MP" $CurrentMP $"  " $MaxMP);
		ReceiveRecipeShopSellList( MerchantID, RecipeID, CurrentMP, MaxMP, MakingResult, Adena );
	}
	else if (Event_ID == EV_UpdateMP)
	{
		ParseInt(param, "ServerID", ServerID);
		ParseInt(param, "CurrentMP", MPValue );
		if (m_MerchantID==ServerID && m_MerchantID>0)
		{
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
		if ( msg_idx == 24) 
		{
			MakingResultGlobal = -1;
			class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", "Not enough MP");
		}
	}
}

function OnClickButton( string strID )
{
	local string param;
	
	switch( strID )
	{
	case "btnStop":
		class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnManufacture");
		class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnStop");
		class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityCB");
		class'UIAPI_EDITBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityEB");
		class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB",enableColor);
		m_hOwnerWnd.KillTimer(4791);
		m_hOwnerWnd.KillTimer(4792);	
		break;
	case "btnClose":
		CloseWindow();
		break;
	case "btnPrev":
		//RecipeBuyListWnd로 돌아감
		class'RecipeAPI'.static.RequestRecipeShopSellList(m_MerchantID);
		
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
		class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnManufacture");
		class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnStop");
		class'UIAPI_CHECKBOX'.static.DisableWindow("RecipeBuyManufactureWnd.QuantityCB");
		class'UIAPI_EDITBOX'.static.DisableWindow("RecipeBuyManufactureWnd.QuantityEB");
		class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB",disableColor);
//		class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
		CheckDistance();
		CheckMultipleCraft();	
		
		break;
	}
}

function CheckMultipleCraft()
{
	if (class'UIAPI_CHECKBOX'.static.IsChecked("RecipeBuyManufactureWnd.QuantityCB"))
	{
		//MakingResult = -1;
		xMulti = int(class'UIAPI_EDITBOX'.static.GetString("RecipeBuyManufactureWnd.QuantityEB"));
		if (xMulti > GlobalAvailable)
		{
			xMulti = GlobalAvailable;
			class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB",string(GlobalAvailable));
		}
		
		if (xMulti<=1) 
		{
			xMulti = 1;
			class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB","1");
			class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
			class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityCB");
			class'UIAPI_EDITBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityEB");
			class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB",enableColor);
			class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnManufacture");
			class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnStop");
			
		}
		else
		{
			class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnStop");
			//class'UIAPI_EDITBOX'.static.DisableWindow("RecipeBuyManufactureWnd.QuantityEB");
			//class'UIAPI_EDITBOX'.static.SetHighLight("RecipeBuyManufactureWnd.QuantityEB",false);
			class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB",disableColor);	
			CheckDistance();
			if (CraftDistance > 240) 
			{
				class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityCB");
				class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnManufacture");
				class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnStop");
				class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB",enableColor);
				class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", "To far from crafter");
			}
			else
			{
				class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
				m_hOwnerWnd.SetTimer(4791, 200);
			}
		}
	}
	else
	{
//		xMulti = StrToInt(class'UIAPI_EDITBOX'.static.GetString("RecipeBuyManufactureWnd.QuantityEB"));
		class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB","1");
		class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityCB");
//		CheckDistance();
		class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
		class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnManufacture");
		class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnStop");
	}
}

function CheckDistance()
{
	local UserInfo Trader;
	local UserInfo Mine;
	local Vector x;
	local Vector y;
	
	GetUserInfo(m_MerchantID, Trader);
	GetPlayerInfo(Mine);
	x = Mine.Loc;
	y = Trader.Loc;
	CraftDistance = GetDistance(x,y);
//AddSystemMessageString(string(CraftDistance));
	
}



function OnTimer(int TimerID)
{	

	if (TimerID == 4791)
	{
		CheckDistance();
	//	AddSystemMessageString("4791 work");
	//	AddSystemMessageString(string(MakingResultGlobal));
		if ((MakingResultGlobal == 0) || (MakingResultGlobal == 1)) 
		{
			xMulti = xMulti - 1;
			class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB",string(xMulti));
			class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);		
			m_hOwnerWnd.KillTimer(4791);
			m_hOwnerWnd.SetTimer(4792, 200);
		}
		else
		{
			m_hOwnerWnd.KillTimer(4791);
			if (CraftDistance <= 240) 
				class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
			else 
			{	
				MakingResultGlobal = -1;
				class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", "To far from crafter");
			}
			m_hOwnerWnd.SetTimer(4792, 1000);
		}
	}
	
	if (TimerID == 4792)
	{
	//	AddSystemMessageString("4792 work");
	//	AddSystemMessageString(string(MakingResultGlobal));
		CheckDistance();
		if ((xMulti>0) && ((MakingResultGlobal == 0) || (MakingResultGlobal == 1)))
		{
			xMulti = xMulti - 1;
			class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB",string(xMulti));
			if (xMulti != 0)
			{
				if (CraftDistance <= 240) 
					class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
				else 
				{	
					MakingResultGlobal = -1;
					class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", "TO FAR FROM CRAFTER");
				}	
				m_hOwnerWnd.SetTimer(4792, 200);
			}
			if (xMulti == 0)
			{
				m_hOwnerWnd.KillTimer(4792);
				class'UIAPI_CHECKBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityCB");
				class'UIAPI_EDITBOX'.static.EnableWindow("RecipeBuyManufactureWnd.QuantityEB");
				class'UIAPI_TEXTBOX'.static.SetTextColor("RecipeBuyManufactureWnd.QuantityTB", enableColor);
				class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnManufacture");
				class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnStop");
				class'UIAPI_EDITBOX'.static.SetString("RecipeBuyManufactureWnd.QuantityEB","1");
			}
			m_hOwnerWnd.KillTimer(4792);
		}
		if ((MakingResultGlobal == -1) && (xMulti>0))
		{
			m_hOwnerWnd.KillTimer(4792);
			if (CraftDistance <= 240) 
				class'RecipeAPI'.static.RequestRecipeShopMakeDo(m_MerchantID, m_RecipeID, m_Adena);
			else 
			{	
				MakingResultGlobal = -1;
				class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", "To far from crafter");
			}	
			m_hOwnerWnd.SetTimer(4792, 1000);
		}
	}

}

//윈도우 닫기
function CloseWindow()
{
	Clear();
	m_hOwnerWnd.KillTimer(4791);
	m_hOwnerWnd.KillTimer(4792);
	class'UIAPI_BUTTON'.static.ShowWindow("RecipeBuyManufactureWnd.btnManufacture");
	class'UIAPI_BUTTON'.static.HideWindow("RecipeBuyManufactureWnd.btnStop");
	class'UIAPI_WINDOW'.static.HideWindow("RecipeBuyManufactureWnd");
	PlayConsoleSound(IFST_WINDOW_CLOSE);
}

//초기화
function Clear()
{
	m_MerchantID = 0;
	m_RecipeID = 0;
	m_SuccessRate = 0;
	m_Adena = IntToInt64(0);
	m_MaxMP = 0;
	class'UIAPI_ITEMWINDOW'.static.Clear("RecipeBuyManufactureWnd.ItemWnd");
}

function OnChangeEditBox( String strID )
{
	local int			i,adx;
	local int			nTmp;
	local int			nTmp2;
	local string		param;
	local ItemInfo		infItem;
	local ItemID AdenaID;
	local ItemInfo AdenaInfo;
	
	AdenaID.ClassID = 57;
	adx = m_invenItem.FindItemByClassID(AdenaID);
	m_invenItem.GetItem(adx,AdenaInfo);
	AdenaInfo.Reserved64 = m_Adena;
//	AddSystemMessageString(""$ Int64ToString(AdenaInfo.ItemNum));
	
	switch( strID )
	{
	case "QuantityEB":
	if (class'UIAPI_BUTTON'.static.isShowWindow("RecipeBuyManufactureWnd.btnManufacture"))
	{
		class'UIAPI_ITEMWINDOW'.static.Clear("RecipeBuyManufactureWnd.ItemWnd");
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
			class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeBuyManufactureWnd.ItemWnd", infItem);
			if (nTmp == i+1) class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeBuyManufactureWnd.ItemWnd", AdenaInfo);
		}
	}
	break;
	}
}

//기본정보 셋팅
function ReceiveRecipeShopSellList(int MerchantID,int RecipeID,int CurrentMP,int MaxMP,int MakingResult,INT64 Adena)
{
	local int			i,adx;
	
	local string		strTmp;
	local int			nTmp;
	local int			nTmp2;
	
	local int			ProductID;
	local int			ProductNum;
	local string		ItemName;
	
	local string		param;
	local ItemInfo		infItem;
	local ItemID AdenaID;
	local ItemInfo AdenaInfo;
	
	AdenaID.ClassID = 57;
	adx = m_invenItem.FindItemByClassID(AdenaID);
	m_invenItem.GetItem(adx,AdenaInfo);
	
//	AddSystemMessageString(""$ Int64ToString(AdenaInfo.ItemNum));	
	//전역변수 설정
	m_MerchantID = MerchantID;
	m_RecipeID = RecipeID;
	m_SuccessRate = class'UIDATA_RECIPE'.static.GetRecipeSuccessRate(RecipeID);
	m_Adena = Adena;
	m_MaxMP = MaxMP;
	AdenaInfo.Reserved64 = m_Adena;
	//윈도우 타이틀 설정
	strTmp = GetSystemString(663) $ " - " $ class'UIDATA_USER'.static.GetUserName(MerchantID);
	class'UIAPI_WINDOW'.static.SetWindowTitleByText("RecipeBuyManufactureWnd", strTmp);
	
	//Product ID
	ProductID = class'UIDATA_RECIPE'.static.GetRecipeProductID(RecipeID);
	
	//(아이템)텍스쳐
	strTmp = class'UIDATA_ITEM'.static.GetItemTextureName(GetItemID(ProductID));
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeBuyManufactureWnd.texItem", strTmp);
	
	//아이템 이름
	ItemName = MakeFullItemName(ProductID);
	
	//Crystal Type(Grade Emoticon출력)
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeCrystalType(RecipeID);
	strTmp = GetItemGradeTextureName(nTmp);
	class'UIAPI_TEXTURECTRL'.static.SetTexture("RecipeBuyManufactureWnd.texGrade", strTmp);
	if(nTmp == 6) // s80 아이템일경우 텍스쳐 사이즈를 늘려줌
	{
		class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyManufactureWnd.texGrade",CRYSTAL_TYPE_WIDTH * 2, CRYSTAL_TYPE_HEIGHT);
	}
	else	//나머지는 원래 사이즈로
	{
		class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyManufactureWnd.texGrade",CRYSTAL_TYPE_WIDTH, CRYSTAL_TYPE_HEIGHT);
	}
	
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtName", ItemName);
	
	//MP소비량
	nTmp = class'UIDATA_RECIPE'.static.GetRecipeMpConsume(RecipeID);
//	MPConsumeGlobal = nTmp;
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMPConsume", "" $ nTmp);
	
	//성공확률
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtSuccessRate", m_SuccessRate $ "%");
	
	//결과물수
	ProductNum = class'UIDATA_RECIPE'.static.GetRecipeProductNum(RecipeID);
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtResultValue", "" $ ProductNum);
	
	//MP바 표시
	//debug("CurrentMP" $CurrentMP);
	SetMPBar(CurrentMP);
	
	//보유갯수
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtCountValue", "" $ MakeCostString(Int64ToString(GetInventoryItemCount(GetItemID(ProductID)))));
	
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
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.txtMsg", strTmp);
	
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
			infItem.bDisabled = true;
		else
			infItem.bDisabled = false;
		class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeBuyManufactureWnd.ItemWnd", infItem);
		if (nTmp == i+1) class'UIAPI_ITEMWINDOW'.static.AddItem( "RecipeBuyManufactureWnd.ItemWnd", AdenaInfo);
		if (GlobalAvailable > INT64ToInt(AdenaInfo.ItemNum)/INT64ToInt(AdenaInfo.Reserved64)) GlobalAvailable = INT64ToInt(AdenaInfo.ItemNum)/INT64ToInt(AdenaInfo.Reserved64);
	}
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.AvailableTB","Available: " $ GlobalAvailable);
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
	class'UIAPI_WINDOW'.static.SetWindowSize("RecipeBuyManufactureWnd.texMPBar", nMPWidth, 12);
	*/
//	debug("MP STATUS" $m_MaxMP $" " $CurrentMP);
	MPBar.SetValue(m_MaxMP , CurrentMP);
}

//인벤아이템이 업데이트되면 아이템의 현재보유수를 바꿔준다
function HandleInventoryItem(string param)
{
	local ItemID cID;
	local int idx;
	local ItemInfo infItem;
//	local ItemID AdenaID;
//	local ItemInfo AdenaInfo;
	
//	AdenaID.ClassID = 57;
//	adx = m_invenItem.FindItemByClassID(AdenaID);
//	m_invenItem.GetItem(adx,AdenaInfo);
//	AddSystemMessageString(""$ Int64ToString(AdenaInfo.ItemNum));
	if (ParseItemID(param, cID))
	{
		idx = class'UIAPI_ITEMWINDOW'.static.FindItem( "RecipeBuyManufactureWnd.ItemWnd", cID);
		if (idx>-1)
		{
			class'UIAPI_ITEMWINDOW'.static.GetItem( "RecipeBuyManufactureWnd.ItemWnd", idx, infItem);
			infItem.ItemNum = GetInventoryItemCount(infItem.ID);
			if (infItem.ID.ClassID == 57) infItem.Reserved64 = m_Adena;
			if (GlobalAvailable > INT64ToInt(infItem.ItemNum)/INT64ToInt(infItem.Reserved64)) GlobalAvailable = INT64ToInt(infItem.ItemNum)/INT64ToInt(infItem.Reserved64);
			if (infItem.Reserved64>infItem.ItemNum)
				infItem.bDisabled = true;
			else
				infItem.bDisabled = false;
			class'UIAPI_ITEMWINDOW'.static.SetItem( "RecipeBuyManufactureWnd.ItemWnd", idx, infItem);
		//	AddSystemMessageString(infItem.Name);
		//	AddSystemMessageString(Int64ToString(infItem.ItemNum));
		//	AddSystemMessageString(Int64ToString(infItem.Reserved64));
			
		}
//		AddSystemMessageString(string(GlobalAvailable) @ "from invetory update");
//		AddSystemMessageString("udalil rudu");
		
	}
	class'UIAPI_TEXTBOX'.static.SetText("RecipeBuyManufactureWnd.AvailableTB","Available: " $ GlobalAvailable);
}
defaultproperties
{
}
