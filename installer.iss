#define MyAppName "Five Hearts Under One Roof S2 – German Patch"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "Fragi (fickrose)"
#define MyAppExeName "FHUOR2.exe"  ; wenn unbekannt: leer lassen ""

[Setup]
AppId={{B7F7E2B1-2A54-4B2A-9E5E-7E1C9B8C1FHU}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}

DefaultDirName={autopf}\Steam\steamapps\common\Five Hearts Under One Roof Season2
DisableProgramGroupPage=yes

OutputDir=.
OutputBaseFilename=FHUOR2_GermanPatch_Setup
Compression=lzma2
SolidCompression=yes

WizardStyle=modern
WizardImageFile=kawaii_sidebar.png

Uninstallable=no

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl"

[Tasks]
Name: "desktopicon"; Description: "Desktop-Verknüpfung anlegen"; GroupDescription: "Optionen:"; Flags: unchecked
Name: "openreadme"; Description: "Nach der Installation Readme öffnen"; GroupDescription: "Optionen:"; Flags: unchecked

[Files]
; Kopiert ALLES aus Files\ nach {app}, inkl. Unterordner
Source: "Files\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "kawaii_welcome.bmp"; Flags: dontcopy

; optional: Readme mit einpacken (wenn du eine hast)
; Source: "readme.txt"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon


[Run]
; optional: Readme öffnen, wenn vorhanden und Task gewählt
Filename: "{app}\readme.txt"; Description: "Readme öffnen"; Flags: postinstall shellexec skipifsilent; Tasks: openreadme; \
  Check: FileExists(ExpandConstant('{app}\readme.txt'))

[Code]
var
  KawaiiPage: TWizardPage;
  Banner: TBitmapImage;
  TitleLbl: TNewStaticText;
  SubLbl: TNewStaticText;
  HeartLbl: TNewStaticText;
  HintLbl: TNewStaticText;

function ScaleX(Value: Integer): Integer;
begin
  Result := MulDiv(Value, WizardForm.ClientWidth, 780);
end;

function ScaleY(Value: Integer): Integer;
begin
  Result := MulDiv(Value, WizardForm.ClientHeight, 470);
end;

procedure CreateKawaiiWelcomePage;
begin
  { Seite direkt nach der Standard-Willkommen-Seite }
  KawaiiPage := CreateCustomPage(wpWelcome,
    'Willkommen, Senpai! (◕‿◕✿)',
    'Kurzer Kawaii-Check, dann installieren wir deinen Deutsch-Patch ♡');

  { Banner Bild }
  Banner := TBitmapImage.Create(KawaiiPage.Surface);
  Banner.Parent := KawaiiPage.Surface;
  Banner.Left := 0;
  Banner.Top := 0;
  Banner.Width := KawaiiPage.SurfaceWidth;
  Banner.Height := ScaleY(155);
  Banner.Stretch := True;

  { Lade dein Banner }
 try
  ExtractTemporaryFile('kawaii_welcome.bmp');
  Banner.Bitmap.LoadFromFile(ExpandConstant('{tmp}\kawaii_welcome.bmp'));
except
  MsgBox('Kawaii-Banner konnte nicht geladen werden (kawaii_welcome.bmp).', mbInformation, MB_OK);
end;

  { Titel }
  TitleLbl := TNewStaticText.Create(KawaiiPage.Surface);
  TitleLbl.Parent := KawaiiPage.Surface;
  TitleLbl.Caption := 'Deutsch-Patch Installer (Ultra Kawaii Edition) ✨';
  TitleLbl.Left := ScaleX(20);
  TitleLbl.Top := Banner.Top + Banner.Height + ScaleY(12);
  TitleLbl.Font.Name := 'Segoe UI';
  TitleLbl.Font.Size := 14;
  TitleLbl.Font.Style := [fsBold];

  { Untertitel }
  SubLbl := TNewStaticText.Create(KawaiiPage.Surface);
  SubLbl.Parent := KawaiiPage.Surface;
  SubLbl.Caption :=
    'Dieser Installer kopiert alle Patch-Dateien in dein Spielverzeichnis.'#13#10+
    'Bitte schließe das Spiel vorher und wähle den richtigen Steam-Ordner aus.';
  SubLbl.Left := ScaleX(20);
  SubLbl.Top := TitleLbl.Top + ScaleY(32);
  SubLbl.Width := KawaiiPage.SurfaceWidth - ScaleX(40);
  SubLbl.Font.Name := 'Segoe UI';
  SubLbl.Font.Size := 10;

  { “Cute” Zeile }
  HeartLbl := TNewStaticText.Create(KawaiiPage.Surface);
  HeartLbl.Parent := KawaiiPage.Surface;
  HeartLbl.Caption := '♡ (づ｡◕‿‿◕｡)づ  Viel Spaß auf Deutsch!  ♡';
  HeartLbl.Left := ScaleX(20);
  HeartLbl.Top := SubLbl.Top + ScaleY(55);
  HeartLbl.Font.Name := 'Segoe UI';
  HeartLbl.Font.Size := 12;
  HeartLbl.Font.Style := [fsBold];

  { Hinweis }
  HintLbl := TNewStaticText.Create(KawaiiPage.Surface);
  HintLbl.Parent := KawaiiPage.Surface;
  HintLbl.Caption :=
    'Wenn etwas nicht Funktioniert gerne auf Steam anschreiben';
  HintLbl.Left := ScaleX(20);
  HintLbl.Top := HeartLbl.Top + ScaleY(40);
  HintLbl.Width := KawaiiPage.SurfaceWidth - ScaleX(40);
  HintLbl.Font.Name := 'Segoe UI';
  HintLbl.Font.Size := 9;
end;

procedure InitializeWizard;
begin
  CreateKawaiiWelcomePage;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;

  { Optional: Verzeichnis-Check, wenn EXE bekannt }
  if CurPageID = wpSelectDir then
  begin
    if ('{#MyAppExeName}' <> '') and (not FileExists(ExpandConstant('{app}\{#MyAppExeName}'))) then
    begin
      MsgBox('Uwu~ ich finde die Spiel-EXE hier nicht. 😿'#13#10+
             'Bitte wähle das Hauptverzeichnis des Spiels (Steam\steamapps\common\...).',
             mbInformation, MB_OK);
      Result := False;
    end;
  end;
end;
