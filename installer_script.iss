; Inno Setup Script for a Flutter Windows App

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value for other applications.
AppId=6c4f2b04-bef2-46b1-9321-6767be65080a
AppName=ShreeNect_Prices
AppVersion=1.0.0
AppPublisher=Anhad Technocrafts
AppPublisherURL=https://anhad.io
AppSupportURL=https://anhad.io/support/
AppUpdatesURL=https://anhad.io/updates/
DefaultDirName={autopf}\ShreeNect_Prices
DefaultGroupName=ShreeNect_Prices
AllowNoIcons=yes
; --- UPDATE THIS PATH ---
;LicenseFile=C:\path\to\your\license.txt
; "ArchitecturesAllowed=x64" specifies that the installer is for 64-bit Windows.
ArchitecturesAllowed=x64
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be done in
; 64-bit mode if the user is running 64-bit Windows.
ArchitecturesInstallIn64BitMode=x64
OutputBaseFilename=ShreeNect_Prices-setup
; --- UPDATE THIS PATH ---
SetupIconFile="C:\Users\Logarithmic Leap\Downloads\setting.ico"
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\ShreeNect_Prices"; Filename: "{app}\excel_query.exe"
Name: "{group}\{cm:UninstallProgram,ShreeNect_Prices}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\ShreeNect_Prices"; Filename: "{app}\excel_query.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\excel_query.exe"; Description: "{cm:LaunchProgram,ShreeNect_Prices}"; Flags: nowait postinstall skipifsilent