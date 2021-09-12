class RefOptionWnd extends UICommonAPI;

var WindowHandle Me;
var CheckBoxHandle  h_aPVPM;
var CheckBoxHandle	h_aReflect;
var CheckBoxHandle	h_aWM;
var CheckBoxHandle	h_aCelest;
var CheckBoxHandle	h_aHeal;
var CheckBoxHandle	h_aHealEmp;
var CheckBoxHandle	h_aVampRage;
var CheckBoxHandle	h_aBlessedBody;
var CheckBoxHandle	h_aAllRefresh;
var CheckBoxHandle	h_aSpellRefresh;
var CheckBoxHandle	h_aSkillRefresh;
var CheckBoxHandle	h_aMusicRefresh;
var CheckBoxHandle	h_aAllClarity;
var CheckBoxHandle	h_aSpellClarity;
var CheckBoxHandle	h_aSkillClarity;
var CheckBoxHandle	h_aMusicClarity;
var CheckBoxHandle	h_aProm;
var CheckBoxHandle	h_aHurr;
var CheckBoxHandle	h_aSolar;
var CheckBoxHandle	h_aAura;
var CheckBoxHandle	h_aHydro;
var CheckBoxHandle	h_aStone;
var CheckBoxHandle	h_aShadow;
var CheckBoxHandle	h_aAbsorb;
var CheckBoxHandle	h_aPDef;
var CheckBoxHandle	h_aPAtt;
var CheckBoxHandle	h_aMDef;
var CheckBoxHandle	h_aMAtt;
var CheckBoxHandle	h_aFocus;
var CheckBoxHandle	h_aEvasion;
var CheckBoxHandle	h_aAccuracy;
var CheckBoxHandle	h_aPrayer;
var CheckBoxHandle	h_aBattleRoar;
var CheckBoxHandle	h_aMaxCP;
var CheckBoxHandle	h_aBlessedSoul;
var CheckBoxHandle	h_aManaGain;
var CheckBoxHandle	h_aFear;
var CheckBoxHandle	h_aHold;
var CheckBoxHandle	h_aAnchor;
var CheckBoxHandle	h_aSleep;
var CheckBoxHandle	h_aStun;
var CheckBoxHandle	h_aMedusa;
var CheckBoxHandle	h_aDoom;
var CheckBoxHandle	h_aSilence;
var CheckBoxHandle	h_aBleed;
var CheckBoxHandle	h_aPoison;
var CheckBoxHandle	h_aShackle;
var CheckBoxHandle	h_aPowerBreak;
var CheckBoxHandle	h_aSlow;
var CheckBoxHandle	h_aTrick;
var CheckBoxHandle	h_aPeace;
var CheckBoxHandle	h_aCharm;
var CheckBoxHandle	h_aRessurection;
var CheckBoxHandle	h_aRecharge;
var CheckBoxHandle	h_aRestoreCP;
var CheckBoxHandle	h_aBurn;
var CheckBoxHandle	h_aRecall;
var CheckBoxHandle	h_aPRecall;
var CheckBoxHandle	h_aAggression;
var CheckBoxHandle	h_aStealth;
var CheckBoxHandle	h_aHead;
var CheckBoxHandle	h_aLung;
var CheckBoxHandle	h_aAcrobatics;
var CheckBoxHandle	h_aIronBody;
var CheckBoxHandle	h_aFirework;
var CheckBoxHandle	h_aBFirework;
var CheckBoxHandle	h_aMusic;
var CheckBoxHandle	h_aUnlock;
var CheckBoxHandle	h_aTFireAoe;
var CheckBoxHandle	h_aTWaterAoe;
var CheckBoxHandle	h_aTWindAoe;
var CheckBoxHandle	h_aTEarthAoe;
var CheckBoxHandle	h_aTHolyAoe;
var CheckBoxHandle	h_aTDarkAoe;
var CheckBoxHandle	h_aTNAAoe;
var CheckBoxHandle	h_aNTFireAoe;
var CheckBoxHandle	h_aNTWaterAoe;
var CheckBoxHandle	h_aNTWindAoe;
var CheckBoxHandle	h_aNTEarthAoe;
var CheckBoxHandle	h_aNTHolyAoe;
var CheckBoxHandle	h_aNTDarkAoe;
var CheckBoxHandle	h_aNTNAAoe;		
var CheckBoxHandle	h_pPVPM;
var CheckBoxHandle	h_pReflect;
var CheckBoxHandle	h_pWM;
var CheckBoxHandle	h_pFocus;
var CheckBoxHandle	h_pAllClarity;
var CheckBoxHandle	h_pSpellClarity;
var CheckBoxHandle	h_pSkillClarity;
var CheckBoxHandle	h_pMusicClarity;
var CheckBoxHandle	h_pPDef;
var CheckBoxHandle	h_pPAtt;
var CheckBoxHandle	h_pMDef;
var CheckBoxHandle	h_pMAtt;
var CheckBoxHandle	h_pEvasion;
var CheckBoxHandle	h_pAccuracy;
var CheckBoxHandle	h_pManaGain;
var CheckBoxHandle	h_pWeight;
var CheckBoxHandle	h_pHealEmp;
var CheckBoxHandle	h_pPrayer;
var CheckBoxHandle	h_pAcrobatics;
var CheckBoxHandle	h_pIronBody;
var CheckBoxHandle	h_pLung;
var CheckBoxHandle	h_pSTR;
var CheckBoxHandle	h_pCON;
var CheckBoxHandle	h_pINT;
var CheckBoxHandle	h_pMEN;
var CheckBoxHandle	h_pEditFocus;
var EditBoxHandle	h_pEditFocusEdit;
var CheckBoxHandle	h_pEditHP;
var EditBoxHandle	h_pEditHPEdit;	
var CheckBoxHandle	h_cOHAnchor;
var CheckBoxHandle	h_cOHMedusa;
var CheckBoxHandle	h_cOHDoom;
var CheckBoxHandle	h_cOHSilence;
var CheckBoxHandle	h_cOHStun;
var CheckBoxHandle	h_cOHFear;
var CheckBoxHandle	h_cOHSleep;
var CheckBoxHandle	h_cOHHold;
var CheckBoxHandle	h_cOHBleed;
var CheckBoxHandle	h_cOHPoison;
var CheckBoxHandle	h_cOHShackle;
var CheckBoxHandle	h_cOHSlow;
var CheckBoxHandle	h_cOHCharm;
var CheckBoxHandle	h_cOHHate;
var CheckBoxHandle	h_cOHBurn;	
var CheckBoxHandle	h_cOCAnchor;
var CheckBoxHandle	h_cOCMedusa;
var CheckBoxHandle	h_cOCDoom;
var CheckBoxHandle	h_cOCSilence;
var CheckBoxHandle	h_cOCStun;
var CheckBoxHandle	h_cOCFear;
var CheckBoxHandle	h_cOCSleep;
var CheckBoxHandle	h_cOCHold;
var CheckBoxHandle	h_cOCBleed;
var CheckBoxHandle	h_cOCPoison;
var CheckBoxHandle	h_cOCShackle;
var CheckBoxHandle	h_cOCSlow;
var CheckBoxHandle	h_cOCCharm;
var CheckBoxHandle	h_cOCHate;
var CheckBoxHandle	h_cOCBurn;	
var CheckBoxHandle	h_cOMAnchor;
var CheckBoxHandle	h_cOMMedusa;
var CheckBoxHandle	h_cOMDoom;
var CheckBoxHandle	h_cOMSilence;
var CheckBoxHandle	h_cOMStun;
var CheckBoxHandle	h_cOMFear;
var CheckBoxHandle	h_cOMSleep;
var CheckBoxHandle	h_cOMHold;
var CheckBoxHandle	h_cOMBleed;
var CheckBoxHandle	h_cOMPoison;
var CheckBoxHandle	h_cOMShackle;
var CheckBoxHandle	h_cOMSlow;
var CheckBoxHandle	h_cOMBurn;
var CheckBoxHandle	h_cODAnchor;
var CheckBoxHandle	h_cODMedusa;
var CheckBoxHandle	h_cODDoom;
var CheckBoxHandle	h_cODSilence;
var CheckBoxHandle	h_cODStun;
var CheckBoxHandle	h_cODFear;
var CheckBoxHandle	h_cODSleep;
var CheckBoxHandle	h_cODHold;
var CheckBoxHandle	h_cODBleed;
var CheckBoxHandle	h_cODPoison;
var CheckBoxHandle	h_cODShackle;
var CheckBoxHandle	h_cODSlow;
var CheckBoxHandle	h_cODPowerBreak;	
var CheckBoxHandle	h_cODCharm;
var CheckBoxHandle	h_cODPDef;
var CheckBoxHandle	h_cODPAtt;
var CheckBoxHandle	h_cODMDef;
var CheckBoxHandle	h_cODMAtt;
var CheckBoxHandle	h_cODPVPM;
var CheckBoxHandle	h_cODWPM;
var CheckBoxHandle	h_cODFocus;
var CheckBoxHandle	h_cODAccuracy;
var CheckBoxHandle	h_cODEvasion;
var CheckBoxHandle	h_cODPrayer;
var CheckBoxHandle	h_cODManaGain;
var CheckBoxHandle	h_cODMaxHP;
var CheckBoxHandle	h_cODMaxMP;
var CheckBoxHandle	h_cODMaxCP;
var CheckBoxHandle	h_cODRestoreHP;
var CheckBoxHandle	h_cODRestoreMP;
var CheckBoxHandle	h_cODRestoreCP;

var CheckBoxHandle h_GetLucky;
var ButtonHandle b_Start, b_Stop;
var RefineryWnd RefWndScript;
var TextBoxHandle h_SliderText;
var bool isAutoBegin, firstAug;
var int countActive1, countActive2, countPassive, countChance1, countChance2, countStat, GAugSpeed;

var int activeSkills1[50];
var int activeSkills2[33];
var int passiveSkills[21];
var int chanceSkills1[50];
var int chanceSkills2[24];
var int statSkills[4];


function OnLoad()
{
	local int i;
	
	Me = GetWindowHandle("RefOptionWnd");
		
	h_aPVPM = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPVPMightCheck");
	h_aReflect = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aReflectCheck");
	h_aWM = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aWMCheck");
	h_aCelest = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aCelestialCheck");
	h_aHeal = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aHealCheck");
	h_aHealEmp = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aHealEmpCheck");
	h_aVampRage  = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aVampRCheck");
	h_aBlessedBody = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aBlessedBodyCheck");
	h_aAllRefresh = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAllRefreshCheck");
	h_aSpellRefresh = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aSpellRefreshCheck");
	h_aSkillRefresh = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aSkillRefreshCheck");
	h_aMusicRefresh = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aMusicRefreshCheck");
	h_aAllRefresh = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAllRefreshCheck");
	h_aAllClarity = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAllClarityCheck");
	h_aSpellClarity = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aSpellClarityCheck");
	h_aSkillClarity = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aSkillClarityCheck");
	h_aMusicClarity = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aMusicClarityCheck");
	h_aProm = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPromCheck");
	h_aHurr = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aHurrCheck");
	h_aSolar = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aSolarCheck");
	h_aAura = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAuraCheck");
	h_aHydro = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aHydroCheck");
	h_aStone = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aStoneCheck");
	h_aShadow = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aShadowCheck");
	h_aAbsorb = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAbsorbCheck");
	h_aPDef = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPDefCheck");
	h_aPAtt = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPAttCheck");
	h_aMDef = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aMDefCheck");
	h_aMAtt = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aMAttCheck");
	h_aFocus = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aFocusCheck");
	h_aEvasion = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aEvasionCheck");
	h_aAccuracy = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAccuracyCheck");
	h_aPrayer = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPrayerCheck");
	h_aBattleRoar = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aBatlleRCheck");
	h_aMaxCP = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aMaxCPCheck");
	h_aBlessedSoul = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aBlessedSoulCheck");
	h_aManaGain = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aManaGainCheck");
	h_aFear = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aFearCheck");
	h_aHold = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aHoldCheck");
	h_aAnchor = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAnchorCheck");
	h_aSleep = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aSleepCheck");
	h_aStun = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aStunCheck");
	h_aMedusa = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aMedusaCheck");
	h_aDoom = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aDoomCheck");
	h_aSilence = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aSilenceCheck");
	h_aBleed = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aBleedCheck");
	h_aPoison = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPoisonCheck");
	h_aShackle = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aShackleCheck");
	h_aPowerBreak = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPowerBCheck");
	h_aSlow = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aSlowCheck");
	h_aTrick = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aTrickCheck");
	h_aPeace = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPeaceCheck");
	h_aCharm = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aCharmCheck");
	h_aRessurection = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aResCheck");
	h_aRecharge = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aRechCheck");
	h_aRestoreCP = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aRestoreCPCheck");
	h_aBurn = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aBurnCheck");
	h_aRecall = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aRecallCheck");
	h_aPRecall = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aPRecallCheck");
	h_aAggression = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAggrCheck");
	h_aStealth = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aStealthCheck");
	h_aHead = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aHeadCheck");
	h_aLung = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aLungCheck");
	h_aAcrobatics = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aAcrobaticsCheck");
	h_aIronBody = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aIronBodyCheck");
	h_aFirework = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aFireworkCheck");
	h_aBFirework = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aBFireworkCheck");
	h_aMusic = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aMusicCheck");
	h_aUnlock = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aUnlockCheck");
	h_aTFireAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aTFireAoeCheck");
	h_aTWaterAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aTWaterAoeCheck");
	h_aTWindAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aTWindAoeCheck");
	h_aTEarthAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aTEarthAoeCheck");
	h_aTHolyAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aTHolyAoeCheck");
	h_aTDarkAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aTDarkAoeCheck");
	h_aTNAAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aTNAAoeCheck");
	h_aNTFireAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aNTFireAoeCheck");
	h_aNTWaterAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aNTWaterAoeCheck");
	h_aNTWindAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aNTWindAoeCheck");
	h_aNTEarthAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aNTEarthAoeCheck");
	h_aNTHolyAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aNTHolyAoeCheck");
	h_aNTDarkAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aNTDarkAoeCheck");
	h_aNTNAAoe = GetCheckBoxHandle("RefOptionWnd.ActiveRef.activeScroll.aNTNAAoeCheck");
	
		
	h_pPVPM = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pPVPMightCheck");
	h_pReflect = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pReflectCheck");
	h_pWM = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pWMCheck");
	h_pFocus = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pFocusCheck");
	h_pAllClarity = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pAllClarityCheck");
	h_pSpellClarity = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pSpellClarityCheck");
	h_pSkillClarity = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pSkillClarityCheck");
	h_pMusicClarity = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pMusicClarityCheck");
	h_pPDef = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pPDefCheck");
	h_pPAtt = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pPAttCheck");
	h_pMDef = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pMDefCheck");
	h_pMAtt = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pMAttCheck");
	h_pEvasion = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pEvasionCheck");
	h_pAccuracy = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pAccuracyCheck");
	h_pManaGain = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pManaGainCheck");
	h_pWeight = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pWeightCheck");
	h_pHealEmp = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pHealEmpCheck");
	h_pPrayer = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pPrayerCheck");
	h_pAcrobatics = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pAcrobaticsCheck");
	h_pIronBody = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pIronBodyCheck");
	h_pLung = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pLungCheck");
	h_pSTR = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pSTRCheck");
	h_pCON = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pCONCheck");
	h_pINT = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pINTCheck");
	h_pMEN = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pMENCheck");
	h_pEditFocus = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pEditFocusCheck");
	h_pEditFocusEdit = GetEditBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pEditFocusEdit");
	h_pEditHP = GetCheckBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pEditHPCheck");
	h_pEditHPEdit = GetEditBoxHandle("RefOptionWnd.PassiveRef.passiveScroll.pEditHPEdit");	
	
	
	h_cOHAnchor = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHAnchorCheck");
	h_cOHMedusa = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHMedusaCheck");
	h_cOHDoom = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHDoomCheck");
	h_cOHSilence = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHSilenceCheck");
	h_cOHStun = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHStunCheck");
	h_cOHFear = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHFearCheck");
	h_cOHSleep = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHSleepCheck");
	h_cOHHold = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHHoldCheck");
	h_cOHBleed = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHBleedCheck");
	h_cOHPoison = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHPoisonCheck");
	h_cOHShackle = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHShackleCheck");
	h_cOHSlow = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHSlowCheck");
	h_cOHCharm = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHCharmCheck");
	h_cOHHate = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHHateCheck");
	h_cOHBurn = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOHBurnCheck");
	
	h_cOCAnchor = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCAnchorCheck");
	h_cOCMedusa = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCMedusaCheck");
	h_cOCDoom = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCDoomCheck");
	h_cOCSilence = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCSilenceCheck");
	h_cOCStun = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCStunCheck");
	h_cOCFear = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCFearCheck");
	h_cOCSleep = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCSleepCheck");
	h_cOCHold = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCHoldCheck");
	h_cOCBleed = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCBleedCheck");
	h_cOCPoison = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCPoisonCheck");
	h_cOCShackle = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCShackleCheck");
	h_cOCSlow = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCSlowCheck");
	h_cOCCharm = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCCharmCheck");
	h_cOCHate = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCHateCheck");
	h_cOCBurn = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOCBurnCheck");
	
	h_cOMAnchor = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMAnchorCheck");
	h_cOMMedusa = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMMedusaCheck");
	h_cOMDoom = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMDoomCheck");
	h_cOMSilence = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMSilenceCheck");
	h_cOMStun = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMStunCheck");
	h_cOMFear = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMFearCheck");
	h_cOMSleep = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMSleepCheck");
	h_cOMHold = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMHoldCheck");
	h_cOMBleed = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMBleedCheck");
	h_cOMPoison = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMPoisonCheck");
	h_cOMShackle = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMShackleCheck");
	h_cOMSlow = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMSlowCheck");
	h_cOMBurn = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cOMBurnCheck");
	
	h_cODAnchor = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODAnchorCheck");
	h_cODMedusa = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMedusaCheck");
	h_cODDoom = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODDoomCheck");
	h_cODSilence = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODSilenceCheck");
	h_cODStun = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODStunCheck");
	h_cODFear = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODFearCheck");
	h_cODSleep = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODSleepCheck");
	h_cODHold = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODHoldCheck");
	h_cODBleed = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODBleedCheck");
	h_cODPoison = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODPoisonCheck");
	h_cODShackle = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODShackleCheck");
	h_cODSlow = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODSlowCheck");
	h_cODPowerBreak = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODPowerBCheck");	
	h_cODCharm = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODCharmCheck");
	h_cODPDef = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODPDefCheck");
	h_cODPAtt = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODPAttCheck");
	h_cODMDef = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMDefCheck");
	h_cODMAtt = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMAttCheck");
	h_cODPVPM = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODPVPMCheck");
	h_cODWPM = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODWMCheck");
	h_cODFocus = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODFocusCheck");
	h_cODAccuracy = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODAccurCheck");
	h_cODEvasion = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODEvasionCheck");
	h_cODPrayer = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODPrayerCheck");
	h_cODManaGain = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMGCheck");
	h_cODMaxHP = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMaxHPCheck");
	h_cODMaxMP = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMaxMPCheck");
	h_cODMaxCP = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMaxCPCheck");
	h_cODRestoreHP = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMRestHPCheck");
	h_cODRestoreMP = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMRestMPCheck");
	h_cODRestoreCP = GetCheckBoxHandle("RefOptionWnd.ChanceRef.chanceScroll.cODMRestCPCheck");
	
			
	h_GetLucky = GetCheckBoxHandle("RefOptionWnd.GetLuckyCheck");	
	h_SliderText = GetTextBoxHandle("RefOptionWnd.speedCtrlText");		
	b_Start = GetButtonHandle("RefOptionWnd.btnStartAutoRef");
	b_Stop = GetButtonHandle("RefOptionWnd.btnStopAutoRef");	
	RefWndScript = RefineryWnd(GetScript("RefineryWnd"));	
	b_Stop.HideWindow();
	
	countActive1 = 0;
	countActive2 = 0;
	countPassive = 0;
	countStat = 0;
	countChance1 = 0;
	countChance2 = 0;
	GAugSpeed = 1000;
	
	for (i = 0; i < 50; i++) activeSkills1[i] = 0;
	for (i = 0; i < 33; i++) activeSkills2[i] = 0;
	for (i = 0; i < 21; i++) passiveSkills[i] = 0;
	for (i = 0; i < 4; i++) statSkills[i] = 0;
	for (i = 0; i < 50; i++) chanceSkills1[i] = 0;
	for (i = 0; i < 24; i++) chanceSkills2[i] = 0;
	
	h_SliderText.SetText(string(float(GAugSpeed)/1000));
	h_pEditFocusEdit.SetString("0");
	h_pEditHPEdit.SetString("0");
	
	class'UIAPI_SLIDERCTRL'.static.SetCurrentTick("RefOptionWnd.speedCtrl",1);
}

function SetSkillOption(CheckBoxHandle handle, int idx, int option, int type)
{
	if (handle.IsChecked())
	{
		switch (type)
		{
			case 0:	
			activeSkills1[idx] = option;
			countActive1++;
			break;
			case 1:	
			activeSkills2[idx] = option;
			countActive2++;
			break;			
			case 2:	
			passiveSkills[idx] = option;
			countPassive++;
			break;
			case 3:	
			chanceSkills1[idx] = option;
			countChance1++;
			break;	
			case 4:	
			chanceSkills2[idx] = option;
			countChance2++;
			break;	
			case 5:	
			statSkills[idx] = option;
			countStat++;
			break;			
		}
	}
	else
	{
		switch (type)
		{
			case 0:	
			activeSkills1[idx] = 0;
			countActive1--;
			break;
			case 1:	
			activeSkills2[idx] = 0;
			countActive2--;
			break;			
			case 2:	
			passiveSkills[idx] = 0;
			countPassive--;
			break;
			case 3:	
			chanceSkills1[idx] = 0;
			countChance1--;
			break;	
			case 4:	
			chanceSkills2[idx] = 0;
			countChance2--;
			break;	
			case 5:	
			statSkills[idx] = 0;
			countStat--;
			break;	
		}
	}
}

function OnClickCheckBox( String strID )
{
	switch (strID)
	{
		
		//active
		
		case "aPVPMightCheck":	
			SetSkillOption(h_aPVPM, 0, 24569, 0);
		break;
		case "aReflectCheck":		
			SetSkillOption(h_aReflect, 1, 24648, 0);
		break;		
		case "aWMCheck":	
			SetSkillOption(h_aWM, 2, 24652, 0);
		break;		
		case "aCelestialCheck":	
			SetSkillOption(h_aCelest, 3, 24651, 0);		
		break;	
		case "aHealCheck":	
			SetSkillOption(h_aHeal, 4, 24553, 0);		
		break;
		case "aHealEmpCheck":	
			SetSkillOption(h_aHealEmp, 5, 24551, 0);	
		break;
		case "aVampRCheck":	
			SetSkillOption(h_aVampRage, 6, 24662, 0);		
		break;
		case "aBlessedBodyCheck":	
			SetSkillOption(h_aBlessedBody, 7, 24557, 0);			
		break;
		case "aAllRefreshCheck":	
			SetSkillOption(h_aAllRefresh, 8, 24645, 0);		
		break;
		case "aSpellRefreshCheck":
			SetSkillOption(h_aSpellRefresh, 9, 24659, 0);		
		break;
		case "aSkillRefreshCheck":	
			SetSkillOption(h_aSkillRefresh, 10, 24655, 0);			
		break;
		case "aMusicRefreshCheck":		
			SetSkillOption(h_aMusicRefresh, 11, 24657, 0);		
		break;
		case "aAllClarityCheck":		
			SetSkillOption(h_aAllClarity, 12, 24646, 0);	
		break;
		case "aSpellClarityCheck":		
			SetSkillOption(h_aSpellClarity, 13, 24660, 0);		
		break;		
		case "aSkillClarityCheck":	
			SetSkillOption(h_aSkillClarity, 14, 24656, 0);	
		break;			
		case "aMusicClarityCheck":	
			SetSkillOption(h_aMusicClarity, 15, 24658, 0);	
		break;		
		case "aPromCheck":	
			SetSkillOption(h_aProm, 16, 24544, 0);		
		break;				
		case "aHurrCheck":	
			SetSkillOption(h_aHurr, 17, 24595, 0);			
		break;	
		case "aSolarCheck":	
			SetSkillOption(h_aSolar, 18, 24550, 0);			
		break;	
		case "aAuraCheck":	
			SetSkillOption(h_aAura, 19, 24563, 0);		
		break;	
		case "aHydroCheck":		
			SetSkillOption(h_aHydro, 20, 24594, 0);	
		break;
		case "aStoneCheck":	
			SetSkillOption(h_aStone, 21, 24542, 0);			
		break;
		case "aShadowCheck":
			SetSkillOption(h_aShadow, 22, 24591, 0);		
		break;
		case "aAbsorbCheck":	
			SetSkillOption(h_aAbsorb, 23, 24593, 0);			
		break;
		case "aPDefCheck":	
			SetSkillOption(h_aPDef, 24, 24566, 0);			
		break;
		case "aPAttCheck":		
			SetSkillOption(h_aPAtt, 25, 24564, 0);			
		break;
		case "aMDefCheck":	
			SetSkillOption(h_aMDef, 26, 24559, 0);			
		break;
		case "aMAttCheck":	
			SetSkillOption(h_aMAtt, 27, 24554, 0);			
		break;
		case "aFocusCheck":		
			SetSkillOption(h_aFocus, 28, 24647, 0);		
		break;		
		case "aEvasionCheck":	
			SetSkillOption(h_aEvasion, 29, 24539, 0);		
		break;	
		case "aAccuracyCheck":
			SetSkillOption(h_aAccuracy, 30, 24548, 0);		
		break;	
		case "aPrayerCheck":	
			SetSkillOption(h_aPrayer, 31, 24552, 0);			
		break;	
		case "aBatlleRCheck":
			SetSkillOption(h_aBattleRoar, 32, 24556, 0);			
		break;	
		case "aMaxCPCheck":	
			SetSkillOption(h_aMaxCP, 33, 24555, 0);			
		break;	
		case "aBlessedSoulCheck":
			SetSkillOption(h_aBlessedSoul, 34, 24558, 0);		
		break;	
		case "aManaGainCheck":	
			SetSkillOption(h_aManaGain, 35, 24561, 0);			
		break;			
		case "aFearCheck":		
			SetSkillOption(h_aFear, 36, 24543, 0);				
		break;			
		case "aHoldCheck":	
			SetSkillOption(h_aHold, 37, 24549, 0);		
		break;			
		case "aAnchorCheck":
			SetSkillOption(h_aAnchor, 38, 24565, 0);			
		break;		
		case "aSleepCheck":	
			SetSkillOption(h_aSleep, 39, 24579, 0);			
		break;	
		case "aStunCheck":		
			SetSkillOption(h_aStun, 40, 24581, 0);		
		break;	
		case "aMedusaCheck":	
			SetSkillOption(h_aMedusa, 41, 24590, 0);			
		break;
		case "aDoomCheck":		
			SetSkillOption(h_aDoom, 42, 24649, 0);		
		break;
		case "aSilenceCheck":		
			SetSkillOption(h_aSilence, 43, 24654, 0);		
		break;
		case "aBleedCheck":		
			SetSkillOption(h_aBleed, 44, 24540, 0);		
		break;
		case "aPoisonCheck":		
			SetSkillOption(h_aPoison, 45, 24567, 0);		
		break;		
		case "aShackleCheck":		
			SetSkillOption(h_aShackle, 46, 24538, 0);		
		break;		
		case "aPowerBCheck":		
			SetSkillOption(h_aPowerBreak, 47, 24568, 0);		
		break;			
		case "aSlowCheck":		
			SetSkillOption(h_aSlow, 48, 24580, 0);		
		break;		
		case "aTrickCheck":		
			SetSkillOption(h_aTrick, 49, 24589, 0);		
		break;		
		case "aPeaceCheck":		
			SetSkillOption(h_aPeace, 0, 24545, 1);		
		break;		
		case "aCharmCheck":		
			SetSkillOption(h_aCharm, 1, 24546, 1);		
		break;		
		case "aResCheck":		
			SetSkillOption(h_aRessurection, 2, 24571, 1);		
		break;	
		case "aRechCheck":		
			SetSkillOption(h_aRecharge, 3, 24562, 1);		
		break;	
		case "aRestoreCPCheck":		
			SetSkillOption(h_aRestoreCP, 4, 24541, 1);		
		break;	
		case "aBurnCheck":		
			SetSkillOption(h_aBurn, 5, 24560, 1);		
		break;	
		case "aRecallCheck":		
			SetSkillOption(h_aRecall, 6, 24570, 1);	
			SetSkillOption(h_aRecall, 7, 24650, 1);				
		break;			
		case "aPRecallCheck":		
			SetSkillOption(h_aPRecall, 8, 24653, 1);		
		break;	
		case "aAggrCheck":		
			SetSkillOption(h_aAggression, 9, 24547, 1);		
		break;	
		case "aStealthCheck":		
			SetSkillOption(h_aStealth, 10, 24661, 1);		
		break;	
		case "aHeadCheck":		
			SetSkillOption(h_aHead, 11, 24521, 1);		
		break;
		case "aLungCheck":		
			SetSkillOption(h_aLung, 12, 24522, 1);		
		break;
		case "aAcrobaticsCheck":		
			SetSkillOption(h_aAcrobatics, 13, 24523, 1);		
		break;
		case "aIronBodyCheck":		
			SetSkillOption(h_aIronBody, 14, 24524, 1);		
		break;
		case "aFireworkCheck":		
			SetSkillOption(h_aFirework, 15, 24525, 1);		
		break;
		case "aBFireworkCheck":		
			SetSkillOption(h_aBFirework, 16, 24527, 1);		
		break;
		case "aMusicCheck":		
			SetSkillOption(h_aMusic, 17, 24526, 1);		
		break;
		case "aUnlockCheck":		
			SetSkillOption(h_aUnlock, 18, 24592, 1);		
		break;	
		case "aTFireAoeCheck":		
			SetSkillOption(h_aTFireAoe, 19, 24573, 1);		
		break;
		case "aTWaterAoeCheck":		
			SetSkillOption(h_aTWaterAoe, 20, 24577, 1);		
		break;
		case "aTWindAoeCheck":		
			SetSkillOption(h_aTWindAoe, 21, 24578, 1);		
		break;		
		case "aTEarthAoeCheck":		
			SetSkillOption(h_aTEarthAoe, 22, 24572, 1);		
		break;			
		case "aTHolyAoeCheck":		
			SetSkillOption(h_aTHolyAoe, 23, 24574, 1);		
		break;		
		case "aTDarkAoeCheck":		
			SetSkillOption(h_aTDarkAoe, 24, 24576, 1);		
		break;		
		case "aTNAAoeCheck":		
			SetSkillOption(h_aTNAAoe, 25, 24575, 1);		
		break;			
		case "aNTFireAoeCheck":		
			SetSkillOption(h_aNTFireAoe, 26, 24583, 1);		
		break;	
		case "aNTWaterAoeCheck":		
			SetSkillOption(h_aNTWaterAoe, 27, 24587, 1);		
		break;	
		case "aNTWindAoeCheck":		
			SetSkillOption(h_aNTWindAoe, 28, 24588, 1);		
		break;	
		case "aNTEarthAoeCheck":		
			SetSkillOption(h_aNTEarthAoe, 29, 24582, 1);		
		break;			
		case "aNTHolyAoeCheck":		
			SetSkillOption(h_aNTHolyAoe, 30, 24584, 1);		
		break;		
		case "aNTDarkAoeCheck":		
			SetSkillOption(h_aNTDarkAoe, 31, 24586, 1);		
		break;			
		case "aNTNAAoeCheck":		
			SetSkillOption(h_aNTNAAoe, 32, 24585, 1);		
		break;		
		
		// passive
		
		case "pPVPMightCheck":		
			SetSkillOption(h_pPVPM, 0, 24643, 2);		
		break;			
		case "pReflectCheck":		
			SetSkillOption(h_pReflect, 1, 24692, 2);		
		break;			
		case "pWMCheck":		
			SetSkillOption(h_pWM, 2, 24694, 2);		
		break;			
		case "pFocusCheck":		
			SetSkillOption(h_pFocus, 3, 24691, 2);		
		break;		
		case "pAllClarityCheck":		
			SetSkillOption(h_pAllClarity, 4, 24689, 2);		
		break;	
		case "pSpellClarityCheck":		
			SetSkillOption(h_pSpellClarity, 5, 24698, 2);		
		break;	
		case "pSkillClarityCheck":		
			SetSkillOption(h_pSkillClarity, 6, 24696, 2);		
		break;
		case "pMusicClarityCheck":		
			SetSkillOption(h_pMusicClarity, 7, 24697, 2);		
		break;
		case "pPDefCheck":		
			SetSkillOption(h_pPDef, 8, 24642, 2);		
		break;
		case "pPAttCheck":		
			SetSkillOption(h_pPAtt, 9, 24641, 2);		
		break;
		case "pMDefCheck":		
			SetSkillOption(h_pMDef, 10, 24640, 2);		
		break;
		case "pMAttCheck":		
			SetSkillOption(h_pMAtt, 11, 24639, 2);		
		break;
		case "pEvasionCheck":		
			SetSkillOption(h_pEvasion, 12, 24690, 2);		
		break;
		case "pAccuracyCheck":		
			SetSkillOption(h_pAccuracy, 13, 24693, 2);		
		break;
		case "pManaGainCheck":		
			SetSkillOption(h_pManaGain, 14, 24695, 2);		
		break;
		case "pWeightCheck":		
			SetSkillOption(h_pWeight, 15, 24644, 2);		
		break;
		case "pHealEmpCheck":		
			SetSkillOption(h_pHealEmp, 16, 24637, 2);		
		break;
		case "pPrayerCheck":		
			SetSkillOption(h_pPrayer, 17, 24638, 2);		
		break;
		case "pAcrobaticsCheck":		
			SetSkillOption(h_pAcrobatics, 18, 24536, 2);		
		break;
		case "pIronBodyCheck":		
			SetSkillOption(h_pIronBody, 19, 24537, 2);		
		break;
		case "pLungCheck":		
			SetSkillOption(h_pLung, 20, 24535, 2);		
		break;		
		case "pSTRCheck":		
			SetSkillOption(h_pSTR, 0, 24699, 5);		
		break;	
		case "pCONCheck":		
			SetSkillOption(h_pCON, 1, 24700, 5);		
		break;	
		case "pINTCheck":		
			SetSkillOption(h_pINT, 2, 24701, 5);		
		break;	
		case "pMENCheck":		
			SetSkillOption(h_pMEN, 3, 24702, 5);		
		break;		
		
		// chance
				
		case "cOHAnchorCheck":		
			SetSkillOption(h_cOHAnchor, 0, 24665, 3);		
		break;			
		case "cOHMedusaCheck":		
			SetSkillOption(h_cOHMedusa, 1, 24601, 3);		
		break;		
		case "cOHDoomCheck":		
			SetSkillOption(h_cOHDoom, 2, 24663, 3);		
		break;	
		case "cOHSilenceCheck":		
			SetSkillOption(h_cOHSilence, 3, 24666, 3);		
		break;
		case "cOHStunCheck":		
			SetSkillOption(h_cOHStun, 4, 24668, 3);		
		break;
		case "cOHFearCheck":		
			SetSkillOption(h_cOHFear, 5, 24598, 3);		
		break;
		case "cOHSleepCheck":		
			SetSkillOption(h_cOHSleep, 6, 24667, 3);		
		break;
		case "cOHHoldCheck":		
			SetSkillOption(h_cOHHold, 7, 24599, 3);		
		break;	
		case "cOHBleedCheck":		
			SetSkillOption(h_cOHBleed, 8, 24597, 3);		
		break;	
		case "cOHPoisonCheck":		
			SetSkillOption(h_cOHPoison, 9, 24600, 3);		
		break;		
		case "cOHShackleCheck":		
			SetSkillOption(h_cOHShackle, 10, 24596, 3);		
		break;			
		case "cOHSlowCheck":		
			SetSkillOption(h_cOHSlow, 11, 24530, 3);		
		break;		
		case "cOHCharmCheck":		
			SetSkillOption(h_cOHCharm, 12, 24528, 3);		
		break;		
		case "cOHHateCheck":		
			SetSkillOption(h_cOHHate, 13, 24529, 3);		
		break;			
		case "cOHBurnCheck":		
			SetSkillOption(h_cOHBurn, 14, 24664, 3);		
		break;		
		case "cOCAnchorCheck":		
			SetSkillOption(h_cOCAnchor, 15, 24671, 3);		
		break;	
		case "cOCMedusaCheck":		
			SetSkillOption(h_cOCMedusa, 16, 24607, 3);		
		break;	
		case "cOCDoomCheck":		
			SetSkillOption(h_cOCDoom, 17, 24669, 3);		
		break;	
		case "cOCSilenceCheck":		
			SetSkillOption(h_cOCSilence, 18, 24672, 3);		
		break;	
		case "cOCStunCheck":		
			SetSkillOption(h_cOCStun, 19, 24674, 3);		
		break;
		case "cOCFearCheck":		
			SetSkillOption(h_cOCFear, 20, 24604, 3);		
		break;
		case "cOCSleepCheck":		
			SetSkillOption(h_cOCSleep, 21, 24673, 3);		
		break;
		case "cOCHoldCheck":		
			SetSkillOption(h_cOCHold, 22, 24605, 3);		
		break;
		case "cOCBleedCheck":		
			SetSkillOption(h_cOCBleed, 23, 24603, 3);		
		break;
		case "cOCPoisonCheck":		
			SetSkillOption(h_cOCPoison, 24, 24606, 3);		
		break;
		case "cOCShackleCheck":		
			SetSkillOption(h_cOCShackle, 25, 24602, 3);		
		break;
		case "cOCSlowCheck":		
			SetSkillOption(h_cOCSlow, 26, 24533, 3);		
		break;	
		case "cOCCharmCheck":		
			SetSkillOption(h_cOCCharm, 27, 24531, 3);		
		break;	
		case "cOCHateCheck":		
			SetSkillOption(h_cOCHate, 28, 24532, 3);		
		break;
		case "cOCBurnCheck":		
			SetSkillOption(h_cOCBurn, 29, 24670, 3);		
		break;
		case "cOMAnchorCheck":		
			SetSkillOption(h_cOMAnchor, 30, 24685, 3);		
		break;
		case "cOMMedusaCheck":		
			SetSkillOption(h_cOMMedusa, 31, 24636, 3);		
		break;
		case "cOMDoomCheck":		
			SetSkillOption(h_cOMDoom, 32, 24683, 3);		
		break;
		case "cOMSilenceCheck":		
			SetSkillOption(h_cOMSilence, 33, 24686, 3);		
		break;
		case "cOMStunCheck":		
			SetSkillOption(h_cOMStun, 34, 24688, 3);		
		break;	
		case "cOMFearCheck":		
			SetSkillOption(h_cOMFear, 35, 24633, 3);		
		break;	
		case "cOMSleepCheck":		
			SetSkillOption(h_cOMSleep, 36, 24687, 3);		
		break;	
		case "cOMHoldCheck":		
			SetSkillOption(h_cOMHold, 37, 24634, 3);		
		break;	
		case "cOMBleedCheck":		
			SetSkillOption(h_cOMBleed, 38, 24632, 3);		
		break;	
		case "cOMPoisonCheck":		
			SetSkillOption(h_cOMPoison, 39, 24635, 3);		
		break;	
		case "cOMShackleCheck":		
			SetSkillOption(h_cOMShackle, 40, 24631, 3);		
		break;	
		case "cOMSlowCheck":		
			SetSkillOption(h_cOMSlow, 41, 24534, 3);		
		break;	
		case "cOMBurnCheck":		
			SetSkillOption(h_cOMBurn, 42, 24684, 3);		
		break;	
		case "cODAnchorCheck":		
			SetSkillOption(h_cODAnchor, 43, 24679, 3);		
		break;
		case "cODMedusaCheck":		
			SetSkillOption(h_cODMedusa, 44, 24682, 3);		
		break;
		case "cODDoomCheck":		
			SetSkillOption(h_cODDoom, 45, 24675, 3);		
		break;
		case "cODSilenceCheck":		
			SetSkillOption(h_cODSilence, 46, 24680, 3);		
		break;	
		case "cODStunCheck":		
			SetSkillOption(h_cODStun, 47, 24681, 3);		
		break;	
		case "cODFearCheck":		
			SetSkillOption(h_cODFear, 48, 24676, 3);		
		break;			
		case "cODSleepCheck":		
			SetSkillOption(h_cODSleep, 49, 24629, 3);		
		break;			
		case "cODHoldCheck":		
			SetSkillOption(h_cODHold, 0, 24615, 4);		
		break;			
		case "cODBleedCheck":		
			SetSkillOption(h_cODBleed, 1, 24610, 4);		
		break;			
		case "cODPoisonCheck":		
			SetSkillOption(h_cODPoison, 2, 24626, 4);		
		break;			
		case "cODShackleCheck":		
			SetSkillOption(h_cODShackle, 3, 24608, 4);		
		break;			
		case "cODSlowCheck":		
			SetSkillOption(h_cODSlow, 4, 24630, 4);		
		break;			
		case "cODPowerBCheck":		
			SetSkillOption(h_cODPowerBreak, 5, 24627, 4);		
		break;			
		case "cODCharmCheck":		
			SetSkillOption(h_cODCharm, 6, 24613, 4);		
		break;		
		case "cODPDefCheck":		
			SetSkillOption(h_cODPDef, 7, 24625, 4);		
		break;			
		case "cODPAttCheck":		
			SetSkillOption(h_cODPAtt, 8, 24624, 4);		
		break;		
		case "cODMDefCheck":		
			SetSkillOption(h_cODMDef, 9, 24623, 4);		
		break;	
		case "cODMAttCheck":		
			SetSkillOption(h_cODMAtt, 10, 24618, 4);		
		break;	
		case "cODPVPMCheck":		
			SetSkillOption(h_cODPVPM, 11, 24628, 4);		
		break;	
		case "cODWMCheck":		
			SetSkillOption(h_cODWPM, 12, 24619, 4);		
		break;	
		case "cODFocusCheck":		
			SetSkillOption(h_cODFocus, 13, 24612, 4);		
		break;
		case "cODAccurCheck":		
			SetSkillOption(h_cODAccuracy, 14, 24614, 4);		
		break;
		case "cODEvasionCheck":		
			SetSkillOption(h_cODEvasion, 15, 24609, 4);		
		break;
		case "cODPrayerCheck":		
			SetSkillOption(h_cODPrayer, 16, 24616, 4);		
		break;		
		case "cODMGCheck":		
			SetSkillOption(h_cODManaGain, 17, 24677, 4);		
		break;			
		case "cODMaxHPCheck":		
			SetSkillOption(h_cODMaxHP, 18, 24621, 4);		
		break;			
		case "cODMaxMPCheck":		
			SetSkillOption(h_cODMaxMP, 19, 24622, 4);		
		break;			
		case "cODMaxCPCheck":		
			SetSkillOption(h_cODMaxCP, 20, 24620, 4);		
		break;
		case "cODMRestHPCheck":		
			SetSkillOption(h_cODRestoreHP, 21, 24617, 4);		
		break;
		case "cODMRestMPCheck":		
			SetSkillOption(h_cODRestoreMP, 22, 24678, 4);		
		break;
		case "cODMRestCPCheck":		
			SetSkillOption(h_cODRestoreCP, 23, 24611, 4);		
		break;
	
		case "GetLuckyCheck":
		OnLuckyCheck();
		break;
	}
}

function OnClickButton( string strID )
{
	switch (strID)
	{
		case "btnStartAutoRef":
		OnClickStartButton();
		break;
		case "btnStopAutoRef":
		OnClickStopButton();
		break;
	}
}

function int GetSpeedFromSliderTick(int iTick)
{
	local int ReturnSpeed;
	switch(iTick)
	{
	case 0 :
		ReturnSpeed = 500;
		break;
	case 1 :
		ReturnSpeed = 1000;
		break;
	case 2 :
		ReturnSpeed = 2000;
		break;
	}

	return ReturnSpeed;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
	local int Speed;
	Speed = GetSpeedFromSliderTick(iCurrentTick);
	switch(strID)
	{
	case "speedCtrl" :
		GAugSpeed = Speed;
		h_SliderText.SetText(string(float(GAugSpeed)/1000));
		break;
	}
}

function OnLuckyCheck()
{
	if (h_GetLucky.IsChecked())
	{
		class'UIAPI_WINDOW'.static.DisableWindow("RefOptionWnd.ActiveRef");
		class'UIAPI_WINDOW'.static.DisableWindow("RefOptionWnd.PassiveRef");
		class'UIAPI_WINDOW'.static.DisableWindow("RefOptionWnd.ChanceRef");
	}
	else
	{
		class'UIAPI_WINDOW'.static.EnableWindow("RefOptionWnd.ActiveRef");
		class'UIAPI_WINDOW'.static.EnableWindow("RefOptionWnd.PassiveRef");
		class'UIAPI_WINDOW'.static.EnableWindow("RefOptionWnd.ChanceRef");		
	}		
}


function OnClickStopButton()
{	
	isAutoBegin = false;
	Me.KillTimer(1488);
	b_Stop.HideWindow();
	b_Start.EnableWindow();
	b_Start.ShowWindow();
	if (!h_GetLucky.IsChecked())
	{
		class'UIAPI_WINDOW'.static.EnableWindow("RefOptionWnd.ActiveRef");
		class'UIAPI_WINDOW'.static.EnableWindow("RefOptionWnd.PassiveRef");
		class'UIAPI_WINDOW'.static.EnableWindow("RefOptionWnd.ChanceRef");
	}
}


function OnClickStartButton()
{
	
	if (!h_GetLucky.isChecked()) 
		if ((countActive1 == 0) && (countActive2 == 0) && (countPassive == 0) && (countChance1 == 0) && (countChance2 == 0) && (countStat == 0))
			if (!h_pEditFocus.isChecked() && !h_pEditHP.isChecked()) 
			{
				DialogShow( DIALOG_Modalless, DIALOG_OK, "Choose augment(s)!" );
				return;
			}	
		
	if (RefWndScript.m_hAugmentInfoTextBox.GetText() == "")
		if (RefWndScript.m_RefineryBtn.IsEnableWindow()) 	
			firstAug = true;
	
	isAutoBegin = true;
	RefWndScript.OnClickRepeatButton();
	Me.KillTimer(1488);
	b_Start.HideWindow();
	Me.SetTimer(1488, GAugSpeed);
	b_Stop.ShowWindow();
	class'UIAPI_WINDOW'.static.DisableWindow("RefOptionWnd.ActiveRef");
	class'UIAPI_WINDOW'.static.DisableWindow("RefOptionWnd.PassiveRef");
	class'UIAPI_WINDOW'.static.DisableWindow("RefOptionWnd.ChanceRef");
}

function OnTimer(int TimerID)
{
	switch (TimerID)
	{
		case 1488:
		Me.KillTimer(1488);	
		if (isAutoBegin)
		{
			RefWndScript.OnClickRepeatButton();
			Me.SetTimer(1488, GAugSpeed);
		}
		break;
		default:
		break;
	}
}

defaultproperties
{
}
