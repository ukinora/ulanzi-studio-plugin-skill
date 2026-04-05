; Ulanzi Studio Plugin Installer - Inno Setup Template
; Replace all {#MyApp*} values with your plugin's info
; Generate a unique AppId GUID at https://www.guidgenerator.com/

#define MyAppName "My Plugin for Ulanzi"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Your Name"
#define MyAppURL "https://github.com/username/my-ulanzi-plugin"
#define PluginFolder "com.ulanzi.myplugin.ulanziPlugin"
#define UlanziExe "UlanziDeck.exe"

[Setup]
; IMPORTANT: Generate your own unique AppId GUID
AppId={{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
DefaultDirName={userappdata}\Ulanzi\UlanziDeck\Plugins\{#PluginFolder}
DisableProgramGroupPage=yes
DisableDirPage=yes
LicenseFile=..\LICENSE
OutputDir=output
OutputBaseFilename={#MyAppName}-Setup-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=lowest
UninstallDisplayName={#MyAppName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
; Add more languages as needed:
; Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"
; Name: "chinese"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"
; Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"

[Files]
; Core plugin files - adjust paths to match your plugin structure
Source: "..\manifest.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\assets\*"; DestDir: "{app}\assets"; Flags: ignoreversion recursesubdirs
Source: "..\libs\*"; DestDir: "{app}\libs"; Flags: ignoreversion recursesubdirs
Source: "..\plugin\*"; DestDir: "{app}\plugin"; Flags: ignoreversion recursesubdirs
Source: "..\property-inspector\*"; DestDir: "{app}\property-inspector"; Flags: ignoreversion recursesubdirs
; Localization files - add/remove as needed
Source: "..\en.json"; DestDir: "{app}"; Flags: ignoreversion
; Source: "..\ko_KR.json"; DestDir: "{app}"; Flags: ignoreversion
; Source: "..\zh_CN.json"; DestDir: "{app}"; Flags: ignoreversion

[Code]
var
  RestartCheckBox: TNewCheckBox;

function FindUlanziPath(): String;
var
  Path: String;
begin
  Path := ExpandConstant('{localappdata}') + '\Programs\Ulanzi\UlanziDeck.exe';
  if FileExists(Path) then begin
    Result := Path;
    Exit;
  end;
  Path := ExpandConstant('{pf}') + '\Ulanzi\UlanziDeck.exe';
  if FileExists(Path) then begin
    Result := Path;
    Exit;
  end;
  Path := ExpandConstant('{localappdata}') + '\Ulanzi\UlanziDeck.exe';
  if FileExists(Path) then begin
    Result := Path;
    Exit;
  end;
  Result := '';
end;

procedure KillUlanzi();
var
  ResultCode: Integer;
begin
  Exec(ExpandConstant('{sys}\taskkill.exe'),
    '/F /IM {#UlanziExe}', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  Sleep(1500);
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Result := '';
  Exec(ExpandConstant('{sys}\cmd.exe'),
    '/C tasklist /FI "IMAGENAME eq {#UlanziExe}" /NH | findstr /I "{#UlanziExe}"',
    '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
  if ResultCode = 0 then begin
    if MsgBox('Ulanzi Studio is currently running.' + #13#10 +
              'It must be closed to install the plugin.' + #13#10#13#10 +
              'Close it now?', mbConfirmation, MB_YESNO) = IDYES then
      KillUlanzi()
    else
      Result := 'Please close Ulanzi Studio and try again.';
  end;
end;

procedure InitializeWizard();
begin
  RestartCheckBox := TNewCheckBox.Create(WizardForm);
  RestartCheckBox.Parent := WizardForm.FinishedPage;
  RestartCheckBox.Left := WizardForm.RunList.Left;
  RestartCheckBox.Top := WizardForm.RunList.Top;
  RestartCheckBox.Width := WizardForm.RunList.Width;
  RestartCheckBox.Height := ScaleY(20);
  RestartCheckBox.Caption := 'Launch Ulanzi Studio';
  RestartCheckBox.Checked := True;
  WizardForm.RunList.Visible := False;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  UlanziPath: String;
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then begin
    if RestartCheckBox.Checked then begin
      UlanziPath := FindUlanziPath();
      if UlanziPath <> '' then
        Exec(UlanziPath, '', '', SW_SHOWNORMAL, ewNoWait, ResultCode);
    end;
  end;
end;

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
