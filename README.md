#1

#3

#2

#4  AutoPotions y FlexOptionWnd actualizados

#5
"235"	b_gotLock = false;
"242"   b_gotLock = true;

#6  FlexOptionWnd <-- Se cambió el tamaño a 20 y en 690 se pasó a negación
"441"	if (temp == 20)
"690"   			if (!c_enableBigBuff.IsChecked())

"692"				s_handle.SetIconSize(20);
"693"				SetINIInt("Buff Control", "Size", 20, "PatchSettings");