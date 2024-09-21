!include "FontInstall.nsh"

; The name of the installer
Name "Game Maker 8.2"

; The file to write
OutFile "Game Maker 8.2 Setup.exe"
Icon "gm82.ico"

; ask admin
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $APPDATA\GameMaker8.2

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\NSIS_GM82" "Install_Dir"

LoadLanguageFile "${NSISDIR}\Contrib\Language files\English.nlf"
;--------------------------------
;Version Information

  VIProductVersion "1.0.0.0"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "Game Maker 8.2"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" ""
  VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" ""
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" ""
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" ""
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Game Maker 8.2 Setup Wizard"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.0.0.0"

;--------------------------------

; Pages

Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

; The stuff to install
Section "Game Maker 8.2 Program Files"

  SectionIn RO
  
  ; close game maker
  ExecWait "taskkill /f /im GameMaker.exe"
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "7za.exe"
  File "Game_Maker_8.2_portable.7z"
  File associate.bat
  
  ; extract files
  nsExec::Exec '"$INSTDIR\7za.exe" -y x Game_Maker_8.2_portable.7z' 
  Delete "$INSTDIR\Game_Maker_8.2_portable.7z"

  nsExec::Exec '"$INSTDIR\associate.bat"'
  Delete "$INSTDIR\associate.bat"
  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\NSIS_GM82 "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GameMaker8.2" "DisplayName" "Game Maker 8.2"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GameMaker8.2" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GameMaker8.2" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GameMaker8.2" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"  
  
SectionEnd

; mandatory visual c runtime install
Section "Visual C Runtime (32 bits)"

  SectionIn RO
  SetOutPath $INSTDIR
  File "vcredist_x86.exe"
  ExecWait "$INSTDIR\vcredist_x86.exe /passive"
  Delete "$INSTDIR\vcredist_x86.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section /o "Default Script Colors and Font"

  SetOutPath $FONTS
  File "JetBrainsMono-Medium.ttf"
  !insertmacro FontInstallTTF "JetBrainsMono-Medium.ttf" "JetBrainsMono-Medium.ttf" "JetBrains Mono Medium"
  
  WriteRegStr   HKCU "Software\Game Maker\Version 8.2\Preferences" "FontName" "JetBrains Mono Medium"

  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor0" 0x00808080
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor1" 0x000080ff
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor2" 0x00ffffff
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor3" 0x0000a000
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor4" 0x000000ff
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor5" 0x00ffff00
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor6" 0x00ff8000
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor7" 0x00008000
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor8" 0x008000ff
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor9" 0x00000000
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor10" 0x00101010
  WriteRegDWORD HKCU "Software\Game Maker\Version 8.2\Preferences" "CodeColor11" 0x00a06850

SectionEnd

; Optional section (can be disabled by the user)
Section /o "Examples and Documentation"

  CreateDirectory "$DOCUMENTS\Game Maker 8.2 Documentation"
  SetOutPath "$DOCUMENTS\Game Maker 8.2 Documentation\"
  File "doc.7z"
  nsExec::Exec '"$INSTDIR\7za.exe" -y x doc.7z' 
  Delete "$DOCUMENTS\Game Maker 8.2 Documentation\doc.7z"
  ExecShell "open" "$DOCUMENTS\Game Maker 8.2 Documentation"
  CreateDirectory "$SMPROGRAMS\Game Maker 8.2"
  CreateShortcut "$SMPROGRAMS\Game Maker 8.2\Documentation.lnk" "$DOCUMENTS\Game Maker 8.2 Documentation"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\Game Maker 8.2"
  CreateShortcut "$SMPROGRAMS\Game Maker 8.2\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  CreateShortcut "$SMPROGRAMS\Game Maker 8.2\Game Maker 8.2.lnk" "$INSTDIR\GameMaker.exe"
  CreateShortcut "$SMPROGRAMS\Game Maker 8.2\Shader Anvil.lnk" "$INSTDIR\anvil.exe"
  CreateShortcut "$SMPROGRAMS\Game Maker 8.2\Room Editor.lnk" "$INSTDIR\gm82room.exe"
  CreateShortcut "$SMPROGRAMS\Game Maker 8.2\Video Encoder.lnk" "$INSTDIR\gm82venc.exe"
  CreateShortcut "$SMPROGRAMS\Game Maker 8.2\Video Player.lnk" "$INSTDIR\gm82vp.exe"
  CreateShortcut "$SMPROGRAMS\Game Maker 8.2\Model Viewer.lnk" "$INSTDIR\gm82mv.exe"

SectionEnd

; Optional section (can be disabled by the user)
Section "Desktop Shortcuts"

  CreateShortcut "$DESKTOP\Game Maker 8.2.lnk" "$INSTDIR\GameMaker.exe"
  
SectionEnd

Section "-installer cleanup"

  Delete "$INSTDIR\7za.exe"

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\GameMaker8.2"
  DeleteRegKey HKLM "SOFTWARE\NSIS_GM82"

  ; Remove files and uninstaller
  Delete "$INSTDIR\extensions\*"
  RMDir "$INSTDIR\extensions"
  
  Delete "$INSTDIR\lib\*"
  RMDir "$INSTDIR\lib"
  
  Delete "$INSTDIR\tutorials\Your First Game\*"
  RMDir  "$INSTDIR\tutorials\Your First Game"
  Delete "$INSTDIR\tutorials\Scrolling Shooters\Resources\*"
  RMDir  "$INSTDIR\tutorials\Scrolling Shooters\Resources"
  Delete "$INSTDIR\tutorials\Scrolling Shooters\*"
  RMDir  "$INSTDIR\tutorials\Scrolling Shooters"
  Delete "$INSTDIR\tutorials\GM82 Documentation\*"
  RMDir  "$INSTDIR\tutorials\GM82 Documentation"
  RMDir  "$INSTDIR\tutorials"
  
  Delete "$INSTDIR\dxdata"
  Delete "$INSTDIR\fnames"
  Delete "$INSTDIR\rundata"
  Delete "$INSTDIR\Game_Maker.chm"
  Delete "$INSTDIR\*.exe"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\snippets.txt"
  Delete "$INSTDIR\*.log"
  Delete "$INSTDIR\*.ini"

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Game Maker 8.2\*.lnk"
  Delete "$DESKTOP\Game Maker 8.2.lnk"
  Delete "$DESKTOP\Anvil.lnk"
  Delete "$DESKTOP\Room Editor.lnk"

  ; Remove directories
  RMDir "$SMPROGRAMS\Game Maker 8.2"  
  RMDir "$INSTDIR\temp\frames"
  RMDir "$INSTDIR\temp"
  RMDir "$INSTDIR"

SectionEnd
