On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20
strComputer = "."

   Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\CIMV2")
   Set colItems = objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL", wbemFlagReturnImmediately + wbemFlagForwardOnly)

For Each objItem In colItems
  cntNumberOfCores = CInt(objItem.NumberOfCores)
'  WScript.Echo "NumberOfCores: " & cntNumberOfCores
  cntNumberOfLogicalProcessors = CInt(objItem.NumberOfLogicalProcessors)
'  WScript.Echo "NumberOfLogicalProcessors: " & cntNumberOfLogicalProcessors
'  WScript.Echo 
  Exit For
Next

Set WshShell = WScript.CreateObject("WScript.Shell")
WshShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\FeatureSettingsOverrideMask","3","REG_DWORD"
 
If (cntNumberOfLogicalProcessors > cntNumberOfCores) Then
'	WScript.Echo "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\FeatureSettingsOverride,72,REG_DWORD"
	WshShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\FeatureSettingsOverride","72","REG_DWORD"
Else
'	WScript.Echo "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\FeatureSettingsOverride,8264,REG_DWORD"
	WshShell.RegWrite "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\FeatureSettingsOverride","8264","REG_DWORD"
End If
Set WshShell = Nothing