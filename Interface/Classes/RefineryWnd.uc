class RefineryWnd extends UICommonAPI;

const DIALOGID_GemstoneCount = 0;

const C_ANIMLOOPCOUNT = 1;
const C_ANIMLOOPCOUNT1 = 1;
const C_ANIMLOOPCOUNT2 = 1;
const C_ANIMLOOPCOUNT3 = 1;

var bool IsResult;
var bool IsRepeat;
var bool procedure1stat;
var bool procedure2stat;
var bool procedure3stat;
var bool procedure4stat;

var int gemIndex;
var ItemInfo RefineItemInfo;
var ItemInfo RefinerItemInfo;
var ItemInfo GemstoneItemInfo;
var ItemInfo RefinedITemInfo;
var ItemInfo TmpRefineItemInfo, TmpRefinerItemInfo, TmpGemstoneItemInfo;

var WindowHandle m_RefineryWnd_Main;
var WindowHandle m_RefineResultBackPattern;
var WindowHandle m_Highlight1;
var WindowHandle m_Highlight2;
var WindowHandle m_Highlight3;
var WindowHandle m_SeletedItemHighlight1;
var WindowHandle m_SeletedItemHighlight2;
var WindowHandle m_SeletedItemHighlight3;
var WindowHandle m_DragBox1;
var WindowHandle m_DragBox2;
var WindowHandle m_DragBox3;
var WindowHandle m_DragBoxResult;
var WindowHandle m_RefineAnimation;
var WindowHandle m_ResultAnimation1;
var WindowHandle m_ResultAnimation2;
var WindowHandle m_ResultAnimation3;
var ItemWindowHandle InvItem;

var AnimTextureHandle m_RefineAnim;
var AnimTextureHandle m_ResultAnim1;
var AnimTextureHandle m_ResultAnim2;
var AnimTextureHandle m_ResultAnim3;

var ButtonHandle m_OkBtn;
var ButtonHandle m_RefineryBtn;
var ButtonHandle m_RepeatBtn;

var ItemWindowHandle m_DragboxItem1;
var ItemWindowHandle m_DragBoxItem2;
var ItemWindowHandle m_DragBoxItem3;
var ItemWindowHandle m_ResultBoxItem;

var TextBoxHandle m_InstructionText;
var TextBoxHandle m_hGemstoneNameTextBox;
var TextBoxHandle m_hGemstoneCountTextBox;
var TextBoxHandle m_hAugmentInfoTextBox;

//제련 대상 무기 ID
var ItemID m_TargetItemID;
//제련 아이템 ID
var ItemID m_RefineItemID;
//젬스톤 아이디
var ItemID m_GemStoneItemID;
//젬스톤 수량 카운트
var INT64 m_NecessaryGemstoneCount;
var INT64 m_GemstoneCount;
var INT64 TmpNeededGems;
var string m_GemstoneName;
var bool detect;
var InventoryWnd InventoryWndScript;
var RefOptionWnd RefOptionWndScript;
var WindowHandle InventoryWnd;
var WindowHandle OptionWnd;


var ProgressCtrlHandle m_hRefineryWndRefineryProgress;

function OnRegisterEvent()
{
	RegisterEvent( EV_Restart );                      //리스타트 이벤트를 추가함. (2009.12.2)
	RegisterEvent( EV_ShowRefineryInteface );
	RegisterEvent( EV_RefineryConfirmTargetItemResult );
	RegisterEvent( EV_RefineryConfirmRefinerItemResult );
	RegisterEvent( EV_RefineryConfirmGemStoneResult );
	RegisterEvent( EV_RefineryRefineResult );
	RegisterEvent( EV_DialogOK );
}

function OnLoad()
{
	if(CREATE_ON_DEMAND==0)
		OnRegisterEvent();

	if(CREATE_ON_DEMAND==0)
		InitHandle();
	else
		InitHandleCOD();
	
	IsResult = false;
	IsRepeat = false;
	procedure1stat = false;
    procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	gemIndex = -1;
	
	m_RefineAnim.SetLoopCount( C_ANIMLOOPCOUNT );
	m_ResultAnim1.SetLoopCount( C_ANIMLOOPCOUNT1 );
	m_ResultAnim2.SetLoopCount( C_ANIMLOOPCOUNT2 );
	m_ResultAnim3.SetLoopCount( C_ANIMLOOPCOUNT3 );
	m_hRefineryWndRefineryProgress.SetProgressTime(1900);
	m_hRefineryWndRefineryProgress.HideWindow();

	InventoryWndScript = InventoryWnd( GetScript( "InventoryWnd" ) );
	RefOptionWndScript = RefOptionWnd( GetScript( "RefOptionWnd" ) );
}

function InitHandle()
{
	m_RefineryWnd_Main = GetHandle( "RefineryWnd" );
	m_RefineResultBackPattern = GetHandle( "RefineryWnd.BackPattern");
    m_Highlight1 = GetHandle( "RefineryWnd.ItemDragBox1Wnd.DropHighlight");
    m_Highlight2 = GetHandle( "RefineryWnd.ItemDragBox2Wnd.DropHighlight");
    m_Highlight3 = GetHandle( "RefineryWnd.ItemDragBox3Wnd.DropHighlight");
	m_SeletedItemHighlight1 = GetHandle( "RefineryWnd.ItemDragBox1Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight2 = GetHandle( "RefineryWnd.ItemDragBox2Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight3 = GetHandle( "RefineryWnd.ItemDragBox3Wnd.SelectedItemHighlight");
    m_DragBox1 = GetHandle( "RefineryWnd.ItemDragBox1Wnd");
    m_DragBox2 = GetHandle( "RefineryWnd.ItemDragBox2Wnd");
    m_DragBox3 = GetHandle( "RefineryWnd.ItemDragBox3Wnd");
	m_DragBoxResult = GetHandle( "RefineryWnd.ItemDragBoxResultWnd");
    m_RefineAnimation = GetHandle( "RefineryWnd.RefineLoadingAnimation");
    m_ResultAnimation1 = GetHandle( "RefineryWnd.RefineResultAnimation01");
    m_ResultAnimation2 = GetHandle( "RefineryWnd.RefineResultAnimation02");
    m_ResultAnimation3 = GetHandle( "RefineryWnd.RefineResultAnimation03");

    m_RefineAnim = AnimTextureHandle ( GetHandle( "RefineryWnd.RefineLoadingAnimation.RefineLoadingAnim") );
    m_ResultAnim1 = AnimTextureHandle ( GetHandle( "RefineryWnd.RefineResultAnimation01.RefineResult1") );
    m_ResultAnim2 = AnimTextureHandle ( GetHandle( "RefineryWnd.RefineResultAnimation02.RefineResult2") );
    m_ResultAnim3 = AnimTextureHandle ( GetHandle( "RefineryWnd.RefineResultAnimation03.RefineResult3") );

	m_DragboxItem1 = ItemWindowHandle ( GetHandle( "RefineryWnd.ItemDragBox1Wnd.ItemDragBox1") );
	m_DragBoxItem2 = ItemWindowHandle ( GetHandle( "RefineryWnd.ItemDragBox2Wnd.ItemDragBox2") );
	m_DragBoxItem3 = ItemWindowHandle ( GetHandle( "RefineryWnd.ItemDragBox3Wnd.ItemDragBox3") );
	m_ResultBoxItem = ItemWindowHandle ( GetHandle( "RefineryWnd.ItemDragBoxResultWnd.ItemRefined") );

	m_RefineryBtn = ButtonHandle ( GetHandle ("RefineryWnd.btnRefine") );
	m_OkBtn= ButtonHandle ( GetHandle ("RefineryWnd.btnClose") );
	m_RepeatBtn= ButtonHandle ( GetHandle ("RefineryWnd.btnRepeat") );

	m_InstructionText = TextBoxHandle ( GetHandle ("RefineryWnd.txtInstruction") );
	m_hGemstoneNameTextBox = TextBoxHandle( GetHandle( "RefineryWnd.txtGemstoneName" ) );
	m_hGemstoneCountTextBox = TextBoxHandle( GetHandle( "RefineryWnd.txtGemstoneCount" ) );
	m_hAugmentInfoTextBox = TextBoxHandle( GetHandle( "RefineryWnd.AugmentInfo" ) );
	
	OptionWnd = GetHandle( "RefOptionWnd" );

	InventoryWnd = GetHandle("InventoryWnd");
	
	
}

function InitHandleCOD()
{
	m_RefineryWnd_Main = GetWindowHandle( "RefineryWnd" );
	m_RefineResultBackPattern = GetWindowHandle( "RefineryWnd.BackPattern");
    m_Highlight1 = GetWindowHandle( "RefineryWnd.ItemDragBox1Wnd.DropHighlight");
    m_Highlight2 = GetWindowHandle( "RefineryWnd.ItemDragBox2Wnd.DropHighlight");
    m_Highlight3 = GetWindowHandle( "RefineryWnd.ItemDragBox3Wnd.DropHighlight");
	m_SeletedItemHighlight1 = GetWindowHandle( "RefineryWnd.ItemDragBox1Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight2 = GetWindowHandle( "RefineryWnd.ItemDragBox2Wnd.SelectedItemHighlight");
    m_SeletedItemHighlight3 = GetWindowHandle( "RefineryWnd.ItemDragBox3Wnd.SelectedItemHighlight");
    m_DragBox1 = GetWindowHandle( "RefineryWnd.ItemDragBox1Wnd");
    m_DragBox2 = GetWindowHandle( "RefineryWnd.ItemDragBox2Wnd");
    m_DragBox3 = GetWindowHandle( "RefineryWnd.ItemDragBox3Wnd");
	m_DragBoxResult = GetWindowHandle( "RefineryWnd.ItemDragBoxResultWnd");
    m_RefineAnimation = GetWindowHandle( "RefineryWnd.RefineLoadingAnimation");
    m_ResultAnimation1 = GetWindowHandle( "RefineryWnd.RefineResultAnimation01");
    m_ResultAnimation2 = GetWindowHandle( "RefineryWnd.RefineResultAnimation02");
    m_ResultAnimation3 = GetWindowHandle( "RefineryWnd.RefineResultAnimation03");

    m_RefineAnim = GetAnimTextureHandle( "RefineryWnd.RefineLoadingAnimation.RefineLoadingAnim");
    m_ResultAnim1 = GetAnimTextureHandle( "RefineryWnd.RefineResultAnimation01.RefineResult1");
    m_ResultAnim2 = GetAnimTextureHandle( "RefineryWnd.RefineResultAnimation02.RefineResult2");
    m_ResultAnim3 = GetAnimTextureHandle( "RefineryWnd.RefineResultAnimation03.RefineResult3");

	m_DragboxItem1 = GetItemWindowHandle( "RefineryWnd.ItemDragBox1Wnd.ItemDragBox1");
	m_DragBoxItem2 = GetItemWindowHandle( "RefineryWnd.ItemDragBox2Wnd.ItemDragBox2");
	m_DragBoxItem3 = GetItemWindowHandle( "RefineryWnd.ItemDragBox3Wnd.ItemDragBox3");
	m_ResultBoxItem = GetItemWindowHandle( "RefineryWnd.ItemDragBoxResultWnd.ItemRefined");

	m_RefineryBtn = GetButtonHandle ( "RefineryWnd.btnRefine");
	m_OkBtn= GetButtonHandle ( "RefineryWnd.btnClose");
	m_RepeatBtn= GetButtonHandle ( "RefineryWnd.btnRepeat");

	m_InstructionText = GetTextBoxHandle("RefineryWnd.txtInstruction");
	m_hGemstoneNameTextBox = GetTextBoxHandle( "RefineryWnd.txtGemstoneName" );
	m_hGemstoneCountTextBox = GetTextBoxHandle( "RefineryWnd.txtGemstoneCount" );
	m_hAugmentInfoTextBox = GetTextBoxHandle("RefineryWnd.AugmentInfo");
	
	OptionWnd = GetWindowHandle( "RefOptionWnd" );

	InventoryWnd = GetWindowHandle("InventoryWnd");
	InvItem = GetItemWindowHandle( "InventoryWnd.InventoryItem" );
	m_hRefineryWndRefineryProgress=GetProgressCtrlHandle("RefineryWnd.RefineryProgress");
}

function OnShow()
{
	ResetReady();
	if (!InventoryWnd.IsShowWindow())
	{
		ExecuteEvent(EV_InventoryToggleWindow);	
	}

	RefOptionWndScript.b_Start.DisableWindow();
}




// 초기화 
function ResetReady()
{
	m_RefineryBtn.SetNameText(GetSystemstring(1477));
	IsResult = false;
	procedure1stat = false;
	procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	m_GemstoneName = "";
	m_RefineryWnd_Main.ShowWindow();
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.ShowWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_SeletedItemHighlight1.HideWindow();
	m_SeletedItemHighlight2.HideWindow();
	m_SeletedItemHighlight3.HideWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	m_RefineAnim.Stop();
	m_ResultAnim1.Stop();
	m_ResultAnim2.Stop();
	m_ResultAnim3.Stop();
	m_InstructionText.SetText(GetSystemMessage(1957));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hAugmentInfoTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	m_DragBoxItem1.Clear();
	m_DragBoxItem2.Clear();
	m_DragBoxItem3.Clear();
	m_RefineryBtn.DisableWindow();
	m_RepeatBtn.DisableWindow();
	m_hRefineryWndRefineryProgress.Reset();
	m_DragBoxItem1.EnableWindow();
	m_DragBoxItem2.DisableWindow();
	m_DragBoxItem3.DisableWindow();
	m_OkBtn.EnableWindow();
}      
       

// Restart 시 초기화 , show, sound 재생 안함. 
function ResetReadyForRestart()
{
	m_RefineryBtn.SetNameText(GetSystemstring(1477));
	IsResult = false;
	procedure1stat = false;
	procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	m_GemstoneName = "";
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.ShowWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_SeletedItemHighlight1.HideWindow();
	m_SeletedItemHighlight2.HideWindow();
	m_SeletedItemHighlight3.HideWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	m_RefineAnim.Stop();
	m_ResultAnim1.Stop();
	m_ResultAnim2.Stop();
	m_ResultAnim3.Stop();
	m_InstructionText.SetText(GetSystemMessage(1957));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hAugmentInfoTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	m_DragBoxItem1.Clear();
	m_DragBoxItem2.Clear();
	m_DragBoxItem3.Clear();
	m_RefineryBtn.DisableWindow();
	m_hRefineryWndRefineryProgress.Reset();
	m_DragBoxItem1.EnableWindow();
	m_DragBoxItem2.DisableWindow();
	m_DragBoxItem3.DisableWindow();
	m_OkBtn.EnableWindow();
}  

// 제련 대상 확인 결과 후 처리할 것들
function OnRefineryConfirmTargetItemResult()
{
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.ShowWindow();
	m_Highlight3.HideWindow();
	m_SeletedItemHighlight1.ShowWindow();
	m_SeletedItemHighlight2.HideWindow();
	m_SeletedItemHighlight3.HideWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	procedure1stat = true;
	procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
	m_InstructionText.SetText(GetSystemMessage(1958));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	m_DragBoxItem1.EnableWindow();
	m_DragBoxItem2.EnableWindow();
	m_DragBoxItem3.DisableWindow();
	m_RefineryBtn.DisableWindow();
}      

// 제련 아이템 확인 후 처리할 것들
function OnRefineryConfirmRefinerItemResult()
{
	local String GemstoneName;
	local String Instruction;

	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.ShowWindow();
	m_SeletedItemHighlight1.ShowWindow();
	m_SeletedItemHighlight2.ShowWindow();
	m_SeletedItemHighlight3.HideWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	
	procedure1stat = true;
	procedure2stat = true;
	procedure3stat = false;
	procedure4stat = false;

	GemstoneName = class'UIDATA_ITEM'.static.GetItemName( m_GemStoneItemID );
	m_GemstoneName = GemstoneName;
	Instruction = MakeFullSystemMsg( GetSystemMessage( 1959 ), GemstoneName, Int64ToString( m_NecessaryGemstoneCount ) );
	m_InstructionText.SetText( Instruction );
	m_hGemstoneNameTextBox.SetText( GemstoneName );
	m_hGemstoneCountTextBox.SetText( MakeCostStringInt64(  m_NecessaryGemstoneCount ) );
	m_hGemstoneCountTextBox.SetTooltipString( ConvertNumToTextNoAdena( Int64ToString( m_NecessaryGemstoneCount ) ) );
	
	m_DragBoxItem1.EnableWindow();
	m_DragBoxItem2.EnableWindow();
	m_DragBoxItem3.EnableWindow();
	m_RefineryBtn.DisableWindow();
}      

// 제련 아이템 젬스톤 결과 확인 후 처리할 것들
function OnRefineryConfirmGemStoneResult()
{
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_SeletedItemHighlight1.ShowWindow();
	m_SeletedItemHighlight2.ShowWindow();
	m_SeletedItemHighlight3.ShowWindow();
	m_DragBox1.ShowWindow();
	m_DragBox2.ShowWindow();
	m_DragBox3.ShowWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	
	procedure1stat = true;
	procedure2stat = true;
	procedure3stat = true;
	procedure4stat = false;
	
	m_InstructionText.SetText(GetSystemMessage(1984));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	m_RefineryBtn.EnableWindow();
	m_hGemstoneCountTextBox.SetTooltipString( "" );
	if ((RefineItemInfo.SlotBitType != 2) && (RefineItemInfo.SlotBitType != 4) &&(RefineItemInfo.SlotBitType != 6) && (RefineItemInfo.SlotBitType != 8) && 
		(RefineItemInfo.SlotBitType != 16) && (RefineItemInfo.SlotBitType != 32) &&(RefineItemInfo.SlotBitType != 48))
			RefOptionWndScript.b_Start.EnableWindow();	
}	

// 제련 결과 후 처리할 것들
function OnRefineryRefineResult()
{
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_DragBox1.HideWindow();
	m_DragBox2.HideWindow();
	m_DragBox3.HideWindow();
	m_DragBoxResult.ShowWindow();
	m_RefineAnimation.HideWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	procedure1stat = true;
	procedure2stat = true;
	procedure3stat = true;
	procedure4stat = true;
	m_InstructionText.SetText(GetSystemMessage(1962));
	m_hGemstoneNameTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetText( "" );
	m_hGemstoneCountTextBox.SetTooltipString( "" );
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
	// Refinery Window Open
	case EV_ShowRefineryInteface:
		if (procedure1stat == false)
		{
			ShowRefineryInterface();
		}
		break;
	// Target Item Validation Result
	case EV_RefineryConfirmTargetItemResult:
		Playsound("ItemSound2.smelting.Smelting_dragin");
		OnTargetItemValidationResult( a_Param );
		break;
	// Refiner Item Validation Result
	case EV_RefineryConfirmRefinerItemResult:
		Playsound("ItemSound2.smelting.Smelting_dragin");
		OnRefinerItemValidationResult( a_Param );
		break;
	// Gemstone Validation Result
	case EV_RefineryConfirmGemStoneResult:
		Playsound("ItemSound2.smelting.Smelting_dragin");
		OnGemstoneValidationResult( a_Param );
		break;
	// Final Refine Result
	case EV_RefineryRefineResult:		
		OnRefineDoneResult( a_Param );
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	case EV_Restart :                  // 옵션>리스타트 할 경우에도
		ResetReadyForRestart();        // 초기화시킨다.
		break;
	default:
		break;
	}	
}

// 제련창 보여주는 함수 
function ShowRefineryInterface()
{
	ResetReady();
}

// 아이템을 올려 놓을 경우 분기
function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
	switch (a_WindowID)
	{
		case "ItemDragBox1":
			if (procedure1stat == false && procedure2stat == false && procedure3stat == false)
				ValidateFirstItem( a_ItemInfo );
			
		break;
		case "ItemDragBox2":
			if(procedure1stat == true && procedure2stat == false && procedure3stat == false)
				ValidateSecondItem( a_ItemInfo );
		break;
		case "ItemDragBox3":
			if(procedure1stat == true && procedure2stat == true && procedure3stat == false )
			ValidateGemstoneItem( a_ItemInfo);
		break;
	}
}

// 제련할  아이템의 검증요청
function ValidateFirstItem(ItemInfo a_ItemInfo)
{
	RefineItemInfo = a_ItemInfo;
	m_TargetItemID = a_ItemInfo.ID;

	class'RefineryAPI'.static.ConfirmTargetItem( m_TargetItemID );
}

//제련할 아이템을 수락받을지 결정
function OnTargetItemValidationResult(string a_Param)
{
	local int ItemValidationResult1;
	local ItemID scID;
	
	ParseItemID(a_Param, scID);
	ParseInt(a_Param, "Result", ItemValidationResult1);
	
	switch (ItemValidationResult1)
	{
	case 1:
		if (IsSameServerID(scID, RefineItemInfo.ID))
		{
			if( !m_DragBoxItem1.SetItem( 0, RefineItemInfo ) )
				m_DragBoxItem1.AddItem( RefineItemInfo );

			OnRefineryConfirmTargetItemResult();
		}
		break;
	case 0:
		break;
	}	
}

//연마제 검증 요청
function ValidateSecondItem(ItemInfo a_ItemInfo)
{
	RefinerItemInfo = a_ItemInfo;
	m_RefineItemID = a_ItemInfo.ID;
	class'RefineryAPI'.static.ConfirmRefinerItem( m_TargetItemID, m_RefineItemID );
}

//연마제를 수락 받을 지 결정
function OnRefinerItemValidationResult(string a_Param)
{
	local ItemID scID;
	local ItemID GemstoneID;
	local int ItemValidationResult2;
	local INT64 RequiredGemstoneAmount;
	local ItemInfo gemInfo;
		
	ParseItemID(a_Param, scID);
	ParseItemIDWithIndex(a_Param, GemstoneID, 1);
	ParseInt(a_Param, "Result", ItemValidationResult2);
	ParseINT64(a_Param, "GemStoneCount", RequiredGemstoneAmount);
	
	m_GemStoneItemID = GemstoneID;
	m_NecessaryGemstoneCount = RequiredGemstoneAmount;
	TmpNeededGems = m_NecessaryGemstoneCount;
	
	switch( ItemValidationResult2 )
	{
		case 1:
		if (IsSameServerID(scID, RefinerItemInfo.ID))
		{
			RefinerItemInfo.ItemNum = IntToInt64(1) ;
			if( !m_DragBoxItem2.SetItem( 0, RefinerItemInfo ) )
				m_DragBoxItem2.AddItem( RefinerItemInfo );
			OnRefineryConfirmRefinerItemResult();
			TmpRefinerItemInfo = RefinerItemInfo;
		}
		break;
		case 0:
		break;
	}
	gemIndex = InvItem.FindItem( GemstoneID );
	if (gemIndex!=-1) 
	{
		InvItem.GetItem(gemIndex, gemInfo);
		if (gemInfo.ItemNum >= RequiredGemstoneAmount) ValidateGemstoneItem (gemInfo);
	}
}

//젬스톤 검증요청
function ValidateGemstoneItem(ItemInfo a_ItemInfo)
{
	GemstoneItemInfo = a_ItemInfo;
	m_GemStoneItemID = a_ItemInfo.ID;

	if( a_ItemInfo.itemNum > IntToInt64(0) )
	{
		if(m_NecessaryGemstoneCount <= a_ItemInfo.itemNum)
		{
			m_GemstoneCount = m_NecessaryGemstoneCount;
		}
		else
		{
			m_GemstoneCount = a_ItemInfo.itemNum;
		}
		class'RefineryAPI'.static.ConfirmGemStone( m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_GemstoneCount );
	}
	else												// 숫자를 물어볼 것인가
	{
		DialogSetID( DIALOGID_GemstoneCount );
		DialogSetParamInt64( a_ItemInfo.ItemNum );
		DialogShow(DIALOG_Modalless, DIALOG_NumberPad, MakeFullSystemMsg( GetSystemMessage( 72 ), a_ItemInfo.Name, "" ) );
	}	
}      

//젬스톤을 수락 받을 지 결정
function OnGemstoneValidationResult(String a_Param)
{
	local ItemID scID;
	local int ItemValidationResult3;
	local INT64 RequiredMoreGemstoneAmount;
	local INT64 GemstoneAmountChecked;
		
	ParseItemID(a_Param, scID);
	ParseInt(a_Param, "Result", ItemValidationResult3);
	ParseINT64(a_Param, "NecessaryGemStoneCount", RequiredMoreGemstoneAmount);
	ParseINT64(a_Param, "GemStoneCount", GemstoneAmountChecked);
	
	m_GemStoneItemID = scID;	
	m_NecessaryGemstoneCount = GemstoneAmountChecked + RequiredMoreGemstoneAmount;
		
	switch (ItemValidationResult3)
	{
	case 1:
		if (IsSameServerID(scID, GemstoneItemInfo.ID))
		{
			if( !m_DragBoxItem3.SetItem( 0, GemstoneItemInfo ) )
			{
				GemstoneItemInfo.ItemNum = GemstoneAmountChecked;
				m_DragBoxItem3.AddItem( GemstoneItemInfo );	
			}

			OnRefineryConfirmGemStoneResult();
			TmpGemstoneItemInfo = GemstoneItemInfo;			
		}
		break;
	case 0:
		break;
	}	
}

// 버튼을 눌렀을때
function OnClickButton( string strID )
{
	switch (strID)
	{
		case "btnRefine":
			if(IsResult) //결과 화면일때
			{
				OnClickCancelButton();
				ShowRefineryInterface();				
			}
			else //제련 화면일때
			{
				Playsound("Itemsound2.smelting.smelting_loding");
				OnClickRefineButton();
			}
			break;
		case "btnClose":
			OnClickCancelButton();
			break;
		case "btnRepeat":
			OnClickRepeatButton();
			m_RefineryWnd_Main.SetTimer(8814, RefOptionWndScript.GAugSpeed);
			break;
		case "btnRefOption":
			OnClickOptionButton();
			break;
	}
}

function OnClickOptionButton()
{	
	if (OptionWnd.IsShowWindow())
	{
		OptionWnd.HideWindow();		
	}
	else
	{
		OptionWnd.ShowWindow();
	}		
}

function OnClickCancelButton()
{
	m_RefineryWnd_Main.HideWindow();
	Playsound("Itemsound2.smelting.smelting_dragout");
	m_hRefineryWndRefineryProgress.Stop();
	m_RefineAnim.Stop();
	m_RefineAnim.SetLoopCount( C_ANIMLOOPCOUNT );	
	procedure1stat = false;
    procedure2stat = false;
	procedure3stat = false;
	procedure4stat = false;
}

// 제련 버튼을 눌렀을 때 처리할 것들
function OnClickRefineButton()
{
	m_RefineResultBackPattern.HideWindow();
	m_Highlight1.HideWindow();
	m_Highlight2.HideWindow();
	m_Highlight3.HideWindow();
	m_DragBoxResult.HideWindow();
	m_RefineAnimation.ShowWindow();
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
	m_RefineryBtn.DisableWindow();
	m_OkBtn.DisableWindow();
	OnRefineRequest();
}

function OnClickRepeatButton()
{
	local INT64 GemCount, LSCount;
	
	GemCount = GetInventoryItemCount(TmpGemstoneItemInfo.ID);
	LSCount = GetInventoryItemCount(TmpRefinerItemInfo.ID);
	IsRepeat = false;
	if (LSCount > IntToInt64(0) && GemCount >= TmpNeededGems)
	{		
		if (RefOptionWndScript.firstAug == false)
		{
			OnClickCancelButton();
			ShowRefineryInterface();
			class'RefineryAPI'.static.ConfirmCancelItem( TmpRefineItemInfo.ID );
			class'RefineryAPI'.static.RequestRefineCancel( TmpRefineItemInfo.ID );
		}		
		m_RefineResultBackPattern.HideWindow();
		m_Highlight1.HideWindow();
		m_Highlight2.HideWindow();
		m_Highlight3.HideWindow();
		m_DragBoxResult.HideWindow();
		m_ResultAnimation1.HideWindow();
		m_ResultAnimation2.HideWindow();
		m_ResultAnimation3.HideWindow();
		
		if (RefOptionWndScript.firstAug && procedure1stat && procedure2stat && procedure3stat && !procedure4stat)
		{
			class'RefineryAPI'.static.RequestRefine( m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_NecessaryGemstoneCount);
			procedure1stat = true;
			procedure2stat = true;
			procedure3stat = true;
			procedure4stat = true;
		}		
		
		if (!RefOptionWndScript.firstAug)
			class'RefineryAPI'.static.RequestRefine( TmpRefineItemInfo.ID, TmpRefinerItemInfo.ID, TmpGemstoneItemInfo.ID, m_NecessaryGemstoneCount);
		RefOptionWndScript.firstAug = false;
		
	} else if (GemCount < TmpNeededGems)
	{
		m_hAugmentInfoTextBox.SetText( "Not enough gems!");
		if (RefOptionWndScript.b_Stop.IsShowWindow())
			RefOptionWndScript.OnClickStopButton();
	} 
	else
	{
		m_hAugmentInfoTextBox.SetText( "Not enough lifestones!");
		if (RefOptionWndScript.b_Stop.IsShowWindow())
			RefOptionWndScript.OnClickStopButton();
	} 
	IsRepeat = true;
		
}       

function PlayRefineAnimation()
{
	m_InstructionText.SetText("");
	m_RefineAnim.Stop();
	m_RefineAnim.SetLoopCount( C_ANIMLOOPCOUNT );
	m_RefineAnim.Play();
	m_hRefineryWndRefineryProgress.Start();

}

//연출 이펙트 애니메이션의 종료 확인 및 제련 요청
function OnTextureAnimEnd( AnimTextureHandle a_WindowHandle )
{
	switch ( a_WindowHandle )
	{
	case m_RefineAnim:
		m_RefineAnimation.HideWindow();
		m_DragBox1.HideWindow();
		m_DragBox2.HideWindow();
		m_DragBox3.HideWindow();
		OnRefineRequest();
		break;
	case m_ResultAnim1:
	case m_ResultAnim2:
	case m_ResultAnim3:
		OnResultAnimEnd();
		break;
	}
}

function OnResultAnimEnd()
{
	m_ResultAnimation1.HideWindow();
	m_ResultAnimation2.HideWindow();
	m_ResultAnimation3.HideWindow();
}

// 서버에 제련을 요청하는 함수 
function OnRefineRequest()
{
	if (procedure1stat && procedure2stat && procedure3stat && !procedure4stat)
	{
		class'RefineryAPI'.static.RequestRefine( m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_NecessaryGemstoneCount);
		procedure1stat = true;
		procedure2stat = true;
		procedure3stat = true;
		procedure4stat = true;
	}
}

function GetRefineryColor(int Quality, out int R, out int G, out int B)
{
	switch (Quality)
	{
	case 1:
		R = 187;
		G = 181;
		B = 138;
	break;
	case 2:
		R = 132;
		G = 174;
		B = 216;
	break;
	case 3:
		R = 193;
		G = 112;
		B = 202;
	break;
	case 4:
		R = 225;
		G = 109;
		B = 109;
	break;
	default:
		R = 187;
		G = 181;
		B = 138;
	break;
	}
}

//제련 완료에 따른 결과 확인 
function OnRefineDoneResult(string a_Param)
{
	local int Option1;
	local int Option2;
	local int RefineResult;
	local int Quality;
	
	local Color TextColor;
	local int ColorR, ColorG, ColorB;
	
	local string str1, str2, str3, str4, str5, str6;
	local string critSumm1, critSumm2, critSumm3, critSumm4;
	local string hpSumm1, hpSumm2, hpSumm3, hpSumm4;
	local string uString;
	local float totalCrit, totalHP;
	local int i;
	
	local ChatWnd chat_script;	
	
	chat_script = ChatWnd( GetScript("ChatWnd") );	

	ParseInt(a_Param, "Option1", Option1);
	ParseInt(a_Param, "Option2", Option2);
	ParseInt(a_Param, "Result", RefineResult);
	
	totalCrit = 0;
	totalHP = 0;
	detect = false;
	
	critSumm1 = "0";
	critSumm2 = "0";
	critSumm3 = "0";
	critSumm4 = "0";

	hpSumm1 = "0";
	hpSumm2 = "0";
	hpSumm3 = "0";
	hpSumm4 = "0";

	m_hRefineryWndRefineryProgress.SetPos(0);
	
	m_OkBtn.EnableWindow();
	m_RepeatBtn.EnableWindow();
	
	switch (RefineResult)
	{
	case 1:
		//제련 성공 옵션에 따라 아이템 업데이트하고 에니메이션 수행
		// 버튼을 활성화 시키는 코딩
		// 적절한 스테이트로 UI를 변경 할 것.?
		RefineItemInfo.RefineryOp1 = Option1;
		RefineItemInfo.RefineryOp2 = Option2;
		
		if (Option2 != 0)
		{
			Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality( Option2 );
			GetRefineryColor(Quality, ColorR, ColorG, ColorB);
		}
		
		TextColor.R = ColorR;
		TextColor.G = ColorG;
		TextColor.B = ColorB;
				
		class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Option1, str1, str2, str3 );
		class'UIDATA_REFINERYOPTION'.static.GetOptionDescription( Option2, str4, str5, str6);
		
		str1 = ReplaceTextWith(str1, "\\n", "");
		str2 = ReplaceTextWith(str2, "\\n", "");
		str4 = ReplaceTextWith(str4, "\\n", "");
		str5 = ReplaceTextWith(str5, "\\n", "");
		
		uString = str1 @ str2 @ str4@ str5;
		
		m_hAugmentInfoTextBox.SetText( uString );
		m_hAugmentInfoTextBox.SetTextColor( TextColor );
		
		if (RefOptionWndScript.isAutoBegin)
		{
			if (!RefOptionWndScript.h_GetLucky.IsChecked())
			{
				if (RefOptionWndScript.h_pEditFocus.IsChecked())
				{
					if (int(RefOptionWndScript.h_pEditFocusEdit.GetString()) > 0)
					{
						if ( InStr( str1 ,"Critical by" ) > -1 )
						{							
							critSumm1 = Right( str1, Len(str1) - 22 );
							critSumm1 = Left( critSumm1, Len(critSumm1) - 1 );
							totalCrit = totalCrit + float(critSumm1);							
						}
						if ( InStr( str2 ,"Critical by" ) > -1 )
						{							
							critSumm2 = Right( str2, Len(str2) - 22 );
							critSumm2 = Left( critSumm2, Len(critSumm2) - 1 );
							totalCrit = totalCrit + float(critSumm2);
						}
						
						if ( InStr( str4 ,"Critical by" ) > -1 )
						{							
							critSumm3 = Right( str4, Len(str4) - 22 );
							critSumm3 = Left( critSumm3, Len(critSumm3) - 1 );
							totalCrit = totalCrit + float(critSumm3);
						}
						if ( InStr( str5 ,"Critical by" ) > -1 )
						{							
							critSumm4 = Right( str5, Len(str5) - 22 );
							critSumm4 = Left( critSumm4, Len(critSumm4) - 1 );
							totalCrit = totalCrit + float(critSumm4);
						}
						
						if (totalCrit >= float(RefOptionWndScript.h_pEditFocusEdit.GetString()))
						{
							detect = true;
							chat_script.SystemMsg.AddString("Got Critical:" @ totalCrit, TextColor);
							RefOptionWndScript.OnClickStopButton();
							break;
						}
					}
				}
				if (RefOptionWndScript.h_pEditHP.IsChecked())
				{
					if (int(RefOptionWndScript.h_pEditHPEdit.GetString()) > 0)
					{
						if ( InStr( str1 ,"Max. HP by" ) > -1 )
						{							
							hpSumm1 = Right( str1, Len(str1) - 21 );
							hpSumm1 = Left( hpSumm1, Len(hpSumm1) - 1 );
							totalHP = totalHP + float(hpSumm1);
							
						}
						if ( InStr( str2 ,"Max. HP by" ) > -1 )
						{							
							hpSumm2 = Right( str2, Len(str2) - 21 );
							hpSumm2 = Left( hpSumm2, Len(hpSumm2) - 1 );
							totalHP = totalHP + float(hpSumm2);
						}
						
						if ( InStr( str4 ,"Max. HP by" ) > -1 )
						{							
							hpSumm3 = Right( str4, Len(str4) - 21 );
							hpSumm3 = Left( hpSumm3, Len(hpSumm3) - 1 );
							totalHP = totalHP + float(hpSumm3);
						}
						if ( InStr( str5 ,"Max. HP by" ) > -1 )
						{							
							hpSumm4 = Right( str5, Len(str5) - 21 );
							hpSumm4 = Left( hpSumm4, Len(hpSumm4) - 1 );
							totalHP = totalHP + float(hpSumm4);
						}
					
						if (totalHP >= float(RefOptionWndScript.h_pEditHPEdit.GetString()))
						{
							detect = true;
							chat_script.SystemMsg.AddString("Got HP:" @ totalHP, TextColor);
							RefOptionWndScript.OnClickStopButton();
							break;
						}
					}
				}								
				if (RefOptionWndScript.countStat > 0)
				{
					for (i = 0; i < 4; i++)
						if (RefOptionWndScript.statSkills[i] != 0)
							DetectSkill(RefOptionWndScript.statSkills[i], Option1, str1, str2, 0);
				}
				if (RefOptionWndScript.countActive1 > 0)
				{
					for (i = 0; i < 50; i++)
						if (RefOptionWndScript.activeSkills1[i] != 0)
							DetectSkill(RefOptionWndScript.activeSkills1[i], Option2, str4, str5, 1);	
				}	
				if (RefOptionWndScript.countActive2 > 0)
				{
					for (i = 0; i < 33; i++)
						if (RefOptionWndScript.activeSkills2[i] != 0)
							DetectSkill(RefOptionWndScript.activeSkills2[i], Option2, str4, str5, 1);	
				}				
				if (RefOptionWndScript.countPassive > 0)
				{
					for (i = 0; i < 21; i++)
						if (RefOptionWndScript.passiveSkills[i] != 0)
							DetectSkill(RefOptionWndScript.passiveSkills[i], Option2, str4, str5, 1);	
				}				
				if (RefOptionWndScript.countChance1 > 0)
				{
					for (i = 0; i < 50; i++)
						if (RefOptionWndScript.chanceSkills1[i] != 0)
							DetectSkill(RefOptionWndScript.chanceSkills1[i], Option2, str4,str5, 1);						

				}		
				if (RefOptionWndScript.countChance2 > 0)
				{
					for (i = 0; i < 24; i++)
						if (RefOptionWndScript.chanceSkills2[i] != 0)
							DetectSkill(RefOptionWndScript.chanceSkills2[i], Option2, str4, str5, 1);
				}	
				 if (!detect) 
				 {
					for (i = 24699; i < 24703; i++)
						DetectSkill(i, Option1, str1, str2, 2);
					
					for (i = 24521; i < 24699; i++)
						DetectSkill(i, Option2, str4, str5, 3);
				 }
			}		
			else		
			{
				for (i = 24699; i < 24703; i++)		
					DetectSkill(i, Option1, str1, str2, 0);	
				
				for (i = 24521; i < 24699; i++)
					DetectSkill(i, Option2, str4, str5, 1);	
			}				
		}		

		if( !m_ResultBoxItem.SetItem( 0, RefineItemInfo ) )
			m_ResultBoxItem.AddItem( RefineItemInfo );
		
		TmpRefineItemInfo = RefineItemInfo;

		OnRefineryRefineResult();

		Quality = class'UIDATA_REFINERYOPTION'.static.GetQuality( Option2 );
		if( 0 >= Quality )
			Quality = 1;
		else if( 4 < Quality )
			Quality = 4;

		m_RefineResultBackPattern.ShowWindow();
		m_RefineResultBackPattern.SetAlpha( 0 );
		m_RefineResultBackPattern.SetAlpha( 255, 1.f );
		PlayResultAnimation( Quality );
		m_RefineryBtn.SetNameText(GetSystemstring(1731));
		m_RefineryBtn.EnableWindow();
		IsResult = true;
		break;
		
	case 0:
		OnClickCancelButton();
		break;
	}	
}


function DetectSkill(int skillCheck, int checkOp, string desc1, string desc2, int type)
{
	local Color TextColor;
	local int j;
	local ChatWnd chat_script;	
	
	chat_script = ChatWnd( GetScript("ChatWnd") );		
	
	switch (type)
	{
		case 3:
			for (j = 0; j < 3; j++)
				if ( checkOp == (skillCheck - 1638 * j ) )
				{
					chat_script.SystemMsg.AddString("Skip Skill:" @ desc1 @ desc2, TextColor);
					break;
				}				
			for (j = 0; j < 10; j++)
				if ( checkOp == ( (skillCheck - 8358 ) - 178 * j ) )
				{
					chat_script.SystemMsg.AddString("Skip Skill:" @ desc1 @ desc2, TextColor);
					break;
				}		
		break;
		case 2:
			for (j = 0; j < 3; j++)
				if (checkOp == (skillCheck - 1638 * j ) )
				{
					chat_script.SystemMsg.AddString("Skip Stat:" @ desc1 @ desc2, TextColor);
					break;
				}
			for (j =0; j < 10; j++)
				if (checkOp == ( ( skillCheck - 8322 ) - 4 * j ) )
				{
					chat_script.SystemMsg.AddString("Skip Stat:" @ desc1 @ desc2, TextColor);
					break;
				}
		break;
		case 1:
			for (j = 0; j < 3; j++)
				if ( checkOp == (skillCheck - 1638 * j ) )
				{
					detect = true;
					chat_script.SystemMsg.AddString("Got Skill:" @ desc1 @ desc2, TextColor);
					RefOptionWndScript.OnClickStopButton();
					break;
				}				
			for (j = 0; j < 10; j++)
				if ( checkOp == ( (skillCheck - 8358 ) - 178 * j ) )
				{
					detect = true;
					chat_script.SystemMsg.AddString("Got Skill:" @ desc1 @ desc2, TextColor);
					RefOptionWndScript.OnClickStopButton();
					break;
				}
		break;
		case 0:
			for (j = 0; j < 3; j++)
				if (checkOp == (skillCheck - 1638 * j ) )
				{
					detect = true;
					chat_script.SystemMsg.AddString("Got Stat:" @ desc1 @desc2, TextColor);
					RefOptionWndScript.OnClickStopButton();
					break;
				}
			for (j =0; j < 10; j++)
				if (checkOp == ( ( skillCheck - 8322 ) - 4 * j ) )
				{
					detect = true;
					chat_script.SystemMsg.AddString("Got Stat:" @ desc1 @ desc2, TextColor);
					RefOptionWndScript.OnClickStopButton();
					break;
				}
		break;
	}
}

function HandleDialogOK()
{
	local int ID;

	if( DialogIsMine() )
	{
		ID = DialogGetID();

		switch( ID )
		{
			case DIALOGID_GemstoneCount:
				m_GemstoneCount = StringToInt64( DialogGetString() );
				class'RefineryAPI'.static.ConfirmGemStone( m_TargetItemID, m_RefineItemID, m_GemStoneItemID, m_GemstoneCount );
			break;
		}		
	}
}

// 제련 완료 애니메이션 재생
function PlayResultAnimation(int Grade)
{
	m_ResultAnim1.SetLoopCount( C_ANIMLOOPCOUNT1 );
	m_ResultAnim2.SetLoopCount( C_ANIMLOOPCOUNT2 );
	m_ResultAnim3.SetLoopCount( C_ANIMLOOPCOUNT3 );
	switch(Grade)
	{
	case 1:
		m_ResultAnimation1.ShowWindow();
		m_ResultAnim1.Play();
		break;
	case 2:
		m_ResultAnimation2.ShowWindow();
		m_ResultAnim2.Play();
		break;
	case 3:
		m_ResultAnimation3.ShowWindow();
		m_ResultAnim3.Play();
		break;
	case 4:
		m_ResultAnimation1.ShowWindow();
		m_ResultAnimation2.ShowWindow();
		m_ResultAnimation3.ShowWindow();
		m_ResultAnim1.Play();
		m_ResultAnim2.Play();
		m_ResultAnim3.Play();
		break;
	
	}
}

function MoveItemBoxes( bool a_Origin )
{
	local Rect Item1Rect;
	local Rect Item2Rect;
	local Rect Item3Rect;
	local Rect ResultRect;

	if( a_Origin )
	{
		m_DragBox1.SetAnchor( "RefineryWnd", "TopLeft", "TopLeft", 77, 51 );
		m_DragBox1.ClearAnchor();
		m_DragBox2.SetAnchor( "RefineryWnd", "TopLeft", "TopLeft", 157, 51 );
		m_DragBox2.ClearAnchor();
		m_DragBox3.SetAnchor( "RefineryWnd", "TopLeft", "TopLeft", 117, 91 );
		m_DragBox3.ClearAnchor();
	}
	else
	{
		Item1Rect = m_DragBox1.GetRect();
		Item2Rect = m_DragBox2.GetRect();
		Item3Rect = m_DragBox3.GetRect();
		ResultRect = m_DragBoxResult.GetRect();

		m_DragBox1.Move( ResultRect.nX - Item1Rect.nX, ResultRect.nY - Item1Rect.nY, 1.5f );
		m_DragBox2.Move( ResultRect.nX - Item2Rect.nX, ResultRect.nY - Item2Rect.nY, 1.5f );
		m_DragBox3.Move( ResultRect.nX - Item3Rect.nX, ResultRect.nY - Item3Rect.nY, 1.5f );
	}
}

function OnTimer(int TimerID)
{
	switch (TimerID)
	{
		case 8814:
		m_RefineryWnd_Main.KillTimer(8814);	
		OnClickRepeatButton();
		RefOptionWndScript.b_Start.EnableWindow();
		break;
		default:
		break;
	}
}
defaultproperties
{
}
