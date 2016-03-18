!define PRODUCT_NAME "wutau安裝檔"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "EASYCHAIN TECHNOLOGY CO.,LTD"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
SetCompressor lzma
; MUI 1.67 compatible ------
!include "MUI.nsh"
!include "WinVer.nsh"
; ------ 添加判斷操作系統 ------
!include "x64.nsh"
; ------ 添加字符串處理 ------
!include WordFunc.nsh
!include "LogicLib.nsh"
; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Directory page
;!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH
; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES
; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "TradChinese"
; Reserve files
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "iis.exe"
InstallDir "c:\inetpub\wwwroot"
ShowInstDetails show
ShowUnInstDetails show

/*Section "WebApp1" webapp1
CreateDirectory "$INSTDIR\WebApp1"

CreateDirectory "$INSTDIR\WebApp1\bin"
CreateDirectory "$INSTDIR\WebApp1\images"
SetOutPath "$INSTDIR\WebApp1"
SetOverwrite try
File /r /x *.txt /x Log\* /x [obj] /x *.cs /x *.pdb /x *.resx /x *.csproj /x *.csproj.* /x *.pubxml /x *.pubxml.* "WebApp1\*.*"
RMDir /r /REBOOTOK "$INSTDIR\WebApp1\obj"
RMDir /r /REBOOTOK "$INSTDIR\WebApp1\Log"
CreateDirectory "$INSTDIR\WebApp1\Log"


SectionEnd
*/

Section "設定AppPool" AppPool
   ;設定AppPool
  ;StrCpy $1 "v4.0"
  ;StrCpy $2 "Integrated"
  ;StrCpy $3 "true"
  nsExec::ExecToLog '$SYSDIR\inetsrv\appcmd add apppool /name:wutau /managedRuntimeVersion:v4.0 /enable32BitAppOnWin64:true'
 ; NsisIIs::CreateAppPool "wutau"
  ;Pop $0
SectionEnd
Section "設定IIS" IIS
 ;StrCpy $1 "wutau"
 ;StrCpy $2 "rwse"
 ;StrCpy $3 "login.aspx" ;Multiple documents must have a ", " separator.
 ;NsisIIS::CreateVDir "WebApp1" "$INSTDIR\WebApp1"
 ;NsisIIs::CreateWebSite "KSWebSite"  "c:\inetpub\wwwroot\HR"  "*:80:"
 nsExec::ExecToLog '$SYSDIR\inetsrv\appcmd add app /site.name:"Default Web Site" /path:/WebApp1 /physicalPath:$INSTDIR\WebApp1 /applicationPool:wutau'
 nsExec::ExecToLog '$SYSDIR\inetsrv\appcmd set site "Default Web Site" /application[path='/'].virtualDirectory[path='/'].physicalPath:"$INSTDIR"'
 nsExec::ExecToLog "$SYSDIR\inetsrv\appcmd set site /site.name:""Default Web Site"" /application[path='/'].applicationPool:wutau"

 ;pop $0
 SectionEnd
 
 Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

 Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "WebApp1已成功地從你的電腦移除。"
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "你確定要完全移除WebApp1" IDYES +2
  Abort
FunctionEnd
 
 Section Uninstall
  nsExec::ExecToLog '$SYSDIR\inetsrv\appcmd delete app "Default Web Site/WebApp1"'
 nsExec::ExecToLog '$SYSDIR\inetsrv\appcmd delete apppool "wutau"'

 RMDir /r /REBOOTOK "$INSTDIR\WebApp1"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  Delete "$INSTDIR\uninst.exe"
  SetAutoClose true
 SectionEnd
 