unit Unit1;

interface

uses
  ShellAPI, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ActivApp, Buttons, Menus, DropImage, TBNArea, Registry,
  ImgList, System.Generics.Collections;

type
  TForm1 = class(TForm)
    ActivApp1: TActivApp;
    OpenDialog1: TOpenDialog;
    Button1: TSpeedButton;
    PopupMenu1: TPopupMenu;
    Up1: TMenuItem;
    Down1: TMenuItem;
    Delete1: TMenuItem;
    BNArea1: TTBNArea;
    PopupMenu2: TPopupMenu;
    Exit1: TMenuItem;
    StayOnTop1: TMenuItem;
    Edit1: TMenuItem;
    Image1: TImage;
    PopupMenu3: TPopupMenu;
    About1: TMenuItem;
    About2: TMenuItem;
    Timer1: TTimer;
    Up51: TMenuItem;
    Down51: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Up1Click(Sender: TObject);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Down1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure FileDropImage1FileDrop(Sender : TObject; files: TStringList);
    procedure Exit1Click(Sender: TObject);
    procedure StayOnTop1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure BNArea1LeftClick(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure About1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Up51Click(Sender: TObject);
    procedure Down51Click(Sender: TObject);
//    procedure FormShow(Sender: TObject);
  private
//    Images : TList;
    Applications : TStringList;
    Parameters : TStringList;
    RunAsAdministrators: TList<Boolean>;
    XOffset, YOffset : integer;
    Moving : boolean;
    Creating : boolean;
//    procedure ButtonAClick(Sender: TObject);
//    procedure DrawMyIcon(AFileName : String);
    procedure AddApplication(AFileName, Parameter: string; RunAsAdministrator: Boolean);
    procedure ReassignTags;
    procedure MyUpdateRegistry;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

const LauncherKey = '\Software\Richard B. Winston\Launcher';
  TopKey = 'Top';
  LeftKey = 'Left';
  StayOnTopKey = 'StayOnTop';
  CountKey = 'Count';
  ProgramsKey = 'Programs';
  ProgKey = 'Prog';
  ParamKey = 'Param';
  RunAsAdminstratorKey = 'RunAsAdminstrator';
  DirKey = 'Directory';
  SizeKey = 'Size';

implementation

uses Unit2, Unit3, frmAboutUnit, ManipulateBitmaps;

{$R *.DFM}

{type ThIconArray = array[0..0] of hIcon;
type PhIconArray = ^ThIconArray;

function ExtractIconExA(lpszFile: PAnsiChar;
          nIconIndex: Integer;
          phiconLarge : PhIconArray;
          phiconSmall: PhIconArray;
          nIcons: UINT): UINT; stdcall;
          external 'shell32.dll' name 'ExtractIconExA';


function ExtractIconExW(lpszFile: PWideChar;
          nIconIndex: Integer;
          phiconLarge: PhIconArray;
          phiconSmall: PhIconArray;
          nIcons: UINT): UINT; stdcall;
          external 'shell32.dll' name 'ExtractIconExW';

function ExtractIconEx(lpszFile: PAnsiChar;
         nIconIndex: Integer;
         phiconLarge : PhIconArray;
         phiconSmall: PhIconArray;
         nIcons: UINT): UINT; stdcall;
         external 'shell32.dll' name 'ExtractIconExA'; }

var FileName : string;
var  LaunchFullFilePath : string;



{procedure DrawIconInImage(FileName : string; AnImage : TImage);
var
  TheIcon: TIcon;
  ABitMap : TBitMap;
begin
  TheIcon := TIcon.Create;
  ABitMap := TBitMap.Create;
  try
    TheIcon.Handle := ExtractIcon(hInstance, PChar(FileName), 0);

    ABitMap.Width := AnImage.Width;
    ABitMap.Height := AnImage.Height;

    if not DrawIconEx(ABitMap.Canvas.Handle, 0,0, TheIcon.Handle, ABitMap.Width,
      ABitMap.Height, 0, 0, DI_NORMAL) then RaiseLastWin32Error;



    AnImage.Picture.Assign(ABitMap);

  finally
    TheIcon.Free;
    ABitMap.Free;
  end;
end;  }

{function GetDllFullPath(FileName :string ; var FullPath : String) : boolean ;
var
  Index : integer;
   buf : PChar ;
   bufLen : Integer;
   AString : string;
   AHandle : HWND;
begin
  FullPath := '';
  AHandle := GetModuleHandle(PChar(FileName))  ;
  if AHandle = 0 then
  begin
    Result := False;
  end
  else
  begin
    AString := '1';
    For Index := 1 to 10 do
    begin
      AString := AString + AString;
    end;
    buf := PChar(AString);
    bufLen := Length(AString);
    if (GetModuleFileName(AHandle, buf, bufLen) > 0) then
    begin
      FullPath := String(buf);
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  end;

end;}


procedure RunAsAdmin(const aFile: string; const aParameters: string = ''; Handle: HWND = 0);
var
  sei: TShellExecuteInfo;
begin
  FillChar(sei, SizeOf(sei), 0);

  sei.cbSize := SizeOf(sei);
  sei.Wnd := Handle;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := 'runas';
  sei.lpFile := PChar(aFile);
  sei.lpParameters := PChar(aParameters);
  sei.nShow := SW_SHOWNORMAL;

  if not ShellExecuteEx(@sei) then
    RaiseLastOSError;
end;

procedure TForm1.AddApplication(AFileName, Parameter : string; RunAsAdministrator: Boolean);
var
  AnotherFileDropImage : TFileDropImage;
  TheIcon: TIcon;
//  Rect : TRect;
  FileDropImage : TFileDropImage;
begin
  if not FileExists(AFileName) then
  begin
    Exit;
  end;

  FileDropImage := TFileDropImage.Create(self);
  FileDropImage.Parent := self;
  FileDropImage.Image.OnDblClick := Button2Click;
  FileDropImage.Image.OnMouseUp := ImageMouseUp;
  FileDropImage.Image.PopupMenu := PopupMenu1;
  FileDropImage.AcceptFiles := True;
  FileDropImage.OnFileDrop := FileDropImage1FileDrop;
  if Applications.Count > 0 then
  begin
    AnotherFileDropImage := Applications.Objects[Applications.Count-1] as TFileDropImage;
    FileDropImage.Top := AnotherFileDropImage.Top + AnotherFileDropImage.Height + 2;
  end
  else
  begin
    FileDropImage.Top := Image1.Top + Image1.Height + 2;
  end;

  FileDropImage.Tag := Applications.AddObject(AFileName, FileDropImage);
  Parameters.Add(Parameter);
  RunAsAdministrators.Add(RunAsAdministrator);
  FileDropImage.Image.Tag := FileDropImage.Tag;
  TheIcon := TIcon.Create;
  try
    TheIcon.Handle := ExtractIcon(hInstance,
                                PChar(AFileName),
                                0);

    FileDropImage.Width := Image1.Width;
    FileDropImage.Height := Image1.Height;

    DrawIconInImage(AFileName, FileDropImage.Image);

{    Rect.Left := 0;
    Rect.Top := 0;
    Rect.Right := FileDropImage.Width - 1;
    Rect.Bottom := FileDropImage.Height - 1;  }

//    MyImage.Canvas.StretchDraw(Rect, TheIcon);
//    FileDropImage.Image.Canvas.Draw(0,0 , TheIcon);

  finally
    TheIcon.Free;
  end;
  ClientHeight := FileDropImage.Top + FileDropImage.Height;
  if FileDropImage.Width > ClientWidth then
  begin
    ClientWidth := FileDropImage.Width;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Form2.edApp.Text := OpenDialog1.FileName;
    Form2.edParam.Text := '';
    if Form2.ShowModal = mrOK then
    begin
      AddApplication(Form2.edApp.Text, Form2.edParam.Text, Form2.cbRunAsAdmin.Checked);
      MyUpdateRegistry;
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Success : boolean;
  Index : integer;
  FileDropImage : TFileDropImage;
begin
  {FileDropImage := (Sender as TImage).Parent as TFileDropImage;
  Index := Applications.IndexOfObject(FileDropImage);
  with TRunItem.Create do
  try
    Params.ProcFileName := Applications[Index];
    Params.ProcParameters := Parameters[Index];
    Params.ProcCurrentDir := Directories[Index];
    if Params.ProcCurrentDir = '' then
    begin
      Params.ProcCurrentDir := ExtractFileDir(Applications[Index]);
    end;

    if not Launch then
      ShowMessage(IntToStr(GetLastError));
  finally
    Free;
  end;    }

  FileDropImage := (Sender as TImage).Parent as TFileDropImage;
  Index := Applications.IndexOfObject(FileDropImage);

  if RunAsAdministrators[Index] then
  begin
    RunAsAdmin(Applications[Index], Parameters[Index]);
  end
  else
  begin
    ActivApp1.ExePath := Applications[Index] + ' ' + Parameters[Index];
    SetCurrentDir(ExtractFileDir(Applications[Index]));
    ActivApp1.ExecuteApp(Success);
    if not Success then
    begin
      ActivApp1.ExePath := '"' + Trim(ActivApp1.ExePath) + '"';
      ActivApp1.ExecuteApp(Success);
    end;
    if not Success then ShowMessage('Failed');
  end;
end;


{procedure TForm1.ButtonAClick(Sender: TObject);
var
    NumIcons : integer;
    pTheLargeIcons : phIconArray;
    pTheSmallIcons : phIconArray;
    LargeIconWidth : integer;
    SmallIconWidth : integer;
    SmallIconHeight : integer;
    i : integer;
    TheIcon : TIcon;
    TheBitmap : TBitmap;
begin
  NumIcons := ExtractIconEx(PChar(OpenDialog1.FileName),
                -1, 
                nil, 
                nil, 
                0); 
  if NumIcons > 0 then
  begin
    LargeIconWidth := GetSystemMetrics(SM_CXICON); 
    SmallIconWidth := GetSystemMetrics(SM_CXSMICON); 
    SmallIconHeight := GetSystemMetrics(SM_CYSMICON); 
    GetMem(pTheLargeIcons, NumIcons * sizeof(hIcon)); 
    GetMem(pTheSmallIcons, NumIcons * sizeof(hIcon));
    FillChar(pTheLargeIcons^, NumIcons * sizeof(hIcon),#0);
    FillChar(pTheSmallIcons^, NumIcons * sizeof(hIcon),#0);
    ExtractIconEx(PChar(OpenDialog1.FileName),
                  0, 
                  pTheLargeIcons, 
                  pTheSmallIcons, 
                  numIcons); 
   {$IFOPT R+} 
     {$DEFINE CKRANGE} 
     {$R-} 
//   {$ENDIF}
 {   for i := 0 to (NumIcons - 1) do begin
      DrawIcon(Form1.Canvas.Handle, 
               i * LargeIconWidth, 
               0, 
               pTheLargeIcons^[i]); 
      TheIcon := TIcon. Create; 
      TheBitmap := TBitmap.Create; 
      TheIcon.Handle := pTheSmallIcons^[i]; 
      TheBitmap.Width := TheIcon.Width;
      TheBitmap.Height := TheIcon.Height; 
      TheBitmap.Canvas.Draw(0, 0, TheIcon); 
      TheIcon.Free; 
      Form1.Canvas.StretchDraw(Rect(i * SmallIconWidth, 
                                    100, 
                                    (i + 1) * SmallIconWidth,
                                    100 + SmallIconHeight),
                               TheBitmap); 
      TheBitmap.Free; 
    end; 
   {$IFDEF CKRANGE} 
     {$UNDEF CKRANGE} 
     {$R+} 
//   {$ENDIF}
{    FreeMem(pTheLargeIcons, NumIcons * sizeof(hIcon)); 
    FreeMem(pTheSmallIcons, NumIcons * sizeof(hIcon)); 
  end;
end;  }

{procedure TForm1.DrawMyIcon(AFileName : String);
var
  TheIcon: TIcon;
begin
  TheIcon := TIcon.Create;
  try
    TheIcon.Handle := ExtractIcon(hInstance,
                                PChar(AFileName),
                                0);
//  Do something with the icon
    MyImage.Width := TheIcon.Width;
    MyImage.Height := TheIcon.Height;
    MyImage.Picture.Assign(TheIcon);

  finally
    TheIcon.Free;
  end;
end;  }

procedure TForm1.MyUpdateRegistry;
var
  Index : integer;
  Reg : TRegIniFile;
begin
  if not Creating then
  begin
    Reg := TRegIniFile.Create('HKEY_CURRENT_USER');
    try
      if Reg.OpenKey(LauncherKey, True) then
      begin
        Reg.WriteInteger('', TopKey, Top);
        Reg.WriteInteger('', LeftKey, Left);
        Reg.WriteInteger('', SizeKey, Image1.Width);
        Reg.WriteBool('', StayOnTopKey, StayOnTop1.Checked);
        Reg.WriteInteger('', CountKey, Applications.count);
        Reg.EraseSection(ProgramsKey);
        if Reg.OpenKey(ProgramsKey, True) then
        begin
          for Index := 0 to Applications.count -1 do
          begin
            Reg.WriteString('', ProgKey + IntToStr(Index), Applications[Index]);
            Reg.WriteString('', ParamKey + IntToStr(Index), Parameters[Index]);
            Reg.WriteBool('', RunAsAdminstratorKey + IntToStr(Index), RunAsAdministrators[Index]);
          end;
        end;
      end;
    finally
      Reg.Free;
    end;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  Index : integer;
  FileDropImage : TFileDropImage;
//  Reg : TRegIniFile;
begin
{  Reg := TRegIniFile.Create('HKEY_CURRENT_USER');
  try
    if Reg.OpenKey(LauncherKey, True) then
    begin
      Reg.WriteInteger('', TopKey, Top);
      Reg.WriteInteger('', LeftKey, Left);
      Reg.WriteInteger('', SizeKey, Image1.Width);
      Reg.WriteBool('', StayOnTopKey, StayOnTop1.Checked);
      Reg.WriteInteger('', CountKey, Applications.count);
      Reg.EraseSection(ProgramsKey);
      if Reg.OpenKey(ProgramsKey, True) then
      begin
        for Index := 0 to Applications.count -1 do
        begin
          Reg.WriteString('', ProgKey + IntToStr(Index), Applications[Index]);
          Reg.WriteString('', ParamKey + IntToStr(Index), Parameters[Index]);
        end;
      end;
    end;

  finally
    Reg.Free;
  end; }

  for Index := 0 to Applications.count -1 do
  begin
    FileDropImage := Applications.Objects[Index] as TFileDropImage;
    FileDropImage.Free;
  end;

//  Applications.Insert(0, IntToStr(Top));
//  Applications.Insert(0, IntToStr(Left));
//  Applications.SaveToFile(FileName);
  Applications.Free;
  Parameters.Free;
  RunAsAdministrators.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Index : integer;
  FileDropImage : TFileDropImage;
  TempApplications : TStringList;
  Reg : TRegIniFile;
  Count : integer;
  AppString, ParamString : string;
  RunAdmin: Boolean;
begin
  Creating := True;
  //  Images := TList.Create;
  TempApplications := TStringList.Create;
  try
    Applications.Free;
    Parameters.Free;
    RunAsAdministrators.Free;
    Applications := TStringList.Create;
    Parameters := TStringList.Create;
    RunAsAdministrators := TList<Boolean>.Create;
    if FileExists(FileName) then
    begin
      TempApplications.LoadFromFile(FileName);
      if TempApplications.Count > 0 then
      begin
        Left := StrToInt(TempApplications[0]);
        if TempApplications.Count > 1 then
        begin
          Top := StrToInt(TempApplications[1]);
        end;
      end;

      for Index := 2 to TempApplications.Count -1 do
      begin
        AddApplication(TempApplications[Index], '', False);
      end;
      DeleteFile( FileName);
    end
    else
    begin
      Reg := TRegIniFile.Create('HKEY_CURRENT_USER');
      try
        if Reg.OpenKey(LauncherKey, True) then
        begin
          Top := Reg.ReadInteger('', TopKey, Top);
          Left := Reg.ReadInteger('', LeftKey, Left);

          Image1.Width := Reg.ReadInteger('', SizeKey, Image1.Width);;
          Image1.Height := Image1.Width;
          DrawIconInImage(LaunchFullFilePath, Image1);
          StayOnTop1.Checked := not Reg.ReadBool('', StayOnTopKey, FormStyle = fsStayOnTop);
          StayOnTop1Click(StayOnTop1);
          Count := Reg.ReadInteger('', CountKey, 0);
          if Reg.OpenKey(ProgramsKey, False) then
          begin
            for Index := 0 to count -1 do
            begin
              AppString := Reg.ReadString('', ProgKey + IntToStr(Index), '');
              ParamString := Reg.ReadString('', ParamKey + IntToStr(Index), '');
              RunAdmin := Reg.ReadBool('', RunAsAdminstratorKey + IntToStr(Index), False);
              AddApplication(AppString, ParamString, RunAdmin);
            end;
          end;
        end;
      finally
        Reg.Free;
      end;
    end;
    if Applications.Count > 0 then
    begin
      FileDropImage := Applications.Objects[0] as TFileDropImage;
      ClientWidth := FileDropImage.Width;
      for Index := 1 to Applications.Count -1 do
      begin
        FileDropImage := Applications.Objects[Index] as TFileDropImage;
        if FileDropImage.Width > ClientWidth then
        begin
          ClientWidth := FileDropImage.Width;
        end;
      end;
    end
    else
    begin
      ClientWidth := Button1.Width;
      ClientHeight := Image1.Top + Image1.Height;
    end;
    if Top < 0 then
    begin
      Top := 0;
    end;
    if Left > Screen.Width - Width then
    begin
      Left := Screen.Width - Width;
    end;
    if Left < 0 then
    begin
      Left := 0;
    end;
  finally
    TempApplications.Free;
    Creating := False;
  end;
end;

procedure TForm1.ReassignTags;
var
  Index : integer;
  Image, PreviousImage : TFileDropImage;
begin
  for Index := 0 to Applications.Count -1 do
  begin
    Image := Applications.Objects[Index] as TFileDropImage;
    Image.Tag := Index;
    Image.Image.Tag := Index;
    if Index = 0 then
    begin
      Image.Top := Image1.Top + Image1.Height + 2;
    end
    else
    begin
      PreviousImage := Applications.Objects[Index-1] as TFileDropImage;
      Image.Top := PreviousImage.Top + PreviousImage.Height + 2;
    end;
  end;
  if Applications.Count > 0 then
  begin
    Image := Applications.Objects[Applications.Count -1] as TFileDropImage;
    ClientHeight := Image.Top + Image.Height;
  end
  else
  begin
    ClientHeight := Button1.Height + Image1.Height;
  end;

end;

procedure TForm1.Up1Click(Sender: TObject);
begin
  if PopUpMenu1.Tag > 0 then
  begin
    Applications.Exchange(PopUpMenu1.Tag, PopUpMenu1.Tag-1);
    Parameters.Exchange(PopUpMenu1.Tag, PopUpMenu1.Tag-1);
    RunAsAdministrators.Exchange(PopUpMenu1.Tag, PopUpMenu1.Tag-1);
  end;
  ReassignTags;
  MyUpdateRegistry;

end;

procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PopupMenu1.Tag := (Sender as TComponent).Tag;
end;

procedure TForm1.Down1Click(Sender: TObject);
begin
  if PopUpMenu1.Tag < Applications.Count -1 then
  begin
    Applications.Exchange(PopUpMenu1.Tag, PopUpMenu1.Tag+1);
    Parameters.Exchange(PopUpMenu1.Tag, PopUpMenu1.Tag+1);
    RunAsAdministrators.Exchange(PopUpMenu1.Tag, PopUpMenu1.Tag+1);
  end;
  ReassignTags;
  MyUpdateRegistry;
end;

procedure TForm1.Delete1Click(Sender: TObject);
var
  Image : TFileDropImage;
begin
  Image := Applications.Objects[PopUpMenu1.Tag] as TFileDropImage;
  Image.Free;
  Applications.Delete(PopUpMenu1.Tag);
  Parameters.Delete(PopUpMenu1.Tag);
  RunAsAdministrators.Delete(PopUpMenu1.Tag);
  ReassignTags;
  MyUpdateRegistry;
end;

procedure TForm1.FileDropImage1FileDrop(Sender : TObject; files: TStringList);
var
  Success : boolean;
  Index : integer;
begin
  if files.Count > 0 then
  begin
    Index := Applications.IndexOfObject(Sender);
    ActivApp1.ExePath := Applications[Index] + ' ' + Parameters[Index]
      + ' "' + files[0] + '"';
    SetCurrentDir(ExtractFileDir(files[0]));
    ActivApp1.ExecuteApp(Success);
    if not Success then
    begin
      ActivApp1.ExePath := '"' + Trim(ActivApp1.ExePath) + '"';
      ActivApp1.ExecuteApp(Success);
    end;
    if not Success then ShowMessage('Failed');
  end;

end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.StayOnTop1Click(Sender: TObject);
var
  Index : integer;
  FileDropImage : TFileDropImage;
begin
  StayOnTop1.Checked := not StayOnTop1.Checked;
  if StayOnTop1.Checked then
  begin
    FormStyle := fsStayOnTop;
  end
  else
  begin
    FormStyle := fsNormal;
  end;
  for Index := 0 to Applications.Count -1 do
  begin
    FileDropImage := Applications.Objects[Index] as TFileDropImage;
    FileDropImage.AcceptFiles := True;
  end;
  MyUpdateRegistry;

end;

procedure TForm1.Edit1Click(Sender: TObject);
var
  TheIcon : TIcon;
  FileDropImage : TFileDropImage;
begin
  if PopUpMenu1.Tag > -1 then
  begin
    Form2.edApp.Text := Applications[PopUpMenu1.Tag];
    Form2.edParam.Text := Parameters[PopUpMenu1.Tag];
    Form2.cbRunAsAdmin.Checked := RunAsAdministrators[PopUpMenu1.Tag];
    if Form2.ShowModal = mrOK then
    begin
      if Applications[PopUpMenu1.Tag] <> Form2.edApp.Text then
      begin
        Applications[PopUpMenu1.Tag] := Form2.edApp.Text;
        FileDropImage := Applications.Objects[PopUpMenu1.Tag] as TFileDropImage;
        TheIcon := TIcon.Create;
        try
          TheIcon.Handle := ExtractIcon(hInstance,
                                      PChar(Applications[PopUpMenu1.Tag]),
                                      0);

          FileDropImage.Width := TheIcon.Width;
          FileDropImage.Height := TheIcon.Height;
          FileDropImage.Image.Canvas.Draw(0,0 , TheIcon);

        finally
          TheIcon.Free;
        end;

      end;
      Parameters[PopUpMenu1.Tag] := Form2.edParam.Text;
      RunAsAdministrators[PopUpMenu1.Tag] := Form2.cbRunAsAdmin.Checked;
    end;
  end;
  MyUpdateRegistry;
end;

procedure TForm1.BNArea1LeftClick(Sender: TObject);
var
  Index : integer;
  FileDropImage : TFileDropImage;
begin
  Show;
  if Applications.Count > 0 then
  begin
    FileDropImage := Applications.Objects[0] as TFileDropImage;
    ClientWidth := FileDropImage.Width;
    for Index := 1 to Applications.Count -1 do
    begin
      FileDropImage := Applications.Objects[Index] as TFileDropImage;
      if FileDropImage.Width > ClientWidth then
      begin
        ClientWidth := FileDropImage.Width;
      end;
    end;
    FileDropImage := Applications.Objects[Applications.Count -1] as TFileDropImage;
    ClientHeight := FileDropImage.Top + FileDropImage.Height;
  end
  else
  begin
    ClientWidth := Button1.Width;
    ClientHeight := Button1.Height;
  end;
  if Top > Screen.Height - Height then
  begin
    Top := Screen.Height - Height;
  end;
  if Top < 0 then
  begin
    Top := 0;
  end;
  if Left > Screen.Width - Width then
  begin
    Left := Screen.Width - Width;
  end;
  if Left < 0 then
  begin
    Left := 0;
  end;
  MyUpdateRegistry;
end;

procedure TForm1.Image1DblClick(Sender: TObject);
var
  Index : integer;
  FileDropImage, AnotherDropImage : TFileDropImage;
begin
  Moving := False;
  frmSize.seSize.Value := Image1.Width;
  if frmSize.ShowModal = mrOK then
  begin
    Image1.Width := frmSize.seSize.Value;
    Image1.Height := frmSize.seSize.Value;
    DrawIconInImage(LaunchFullFilePath, Image1);
    for Index := 0 to Applications.Count -1 do
    begin
      FileDropImage := Applications.Objects[Index] as TFileDropImage;
      FileDropImage.Width := Image1.Width;
      FileDropImage.Height := Image1.Height;
      if Index = 0 then
      begin
        FileDropImage.Top := Image1.Top + Image1.Height + 2;
      end
      else
      begin
        AnotherDropImage := Applications.Objects[Index-1] as TFileDropImage;
        FileDropImage.Top := AnotherDropImage.Top + AnotherDropImage.Height + 2;
      end;
      DrawIconInImage(Applications[Index], FileDropImage.Image);
    end;
    if Applications.Count > 0 then
    begin
      FileDropImage := Applications.Objects[Applications.Count-1] as TFileDropImage;
      ClientHeight := FileDropImage.Top + FileDropImage.Height;
    end
    else
    begin
      ClientHeight := Image1.Top + Image1.Height;
    end;
    if Image1.Width > Button1.Width then
    begin
      ClientWidth := Image1.Width;
    end
    else
    begin
      ClientWidth := Button1.Width;
    end;
    MyUpdateRegistry;
  end;

end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  XOffset := Mouse.CursorPos.x - Left;
  YOffset := Mouse.CursorPos.Y - Top;
  Moving := True;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Moving := False;
  MyUpdateRegistry;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  If Moving and (ssLeft	in Shift) then
  begin
    Left := Mouse.CursorPos.X - XOffset;
    Top := Mouse.CursorPos.Y - YOffset;
  end;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  FormCreate(nil);
  Timer1.Enabled := False;
end;

procedure TForm1.Up51Click(Sender: TObject);
var
  AString: string;
  AnObject: TObject;
  Distance: integer;
  ABool: Boolean;
begin
  if PopUpMenu1.Tag > 4 then
  begin
    Distance := 5;
  end
  else
  begin
    Distance := PopUpMenu1.Tag;
  end;

  if Distance > 0 then
  begin
    AString := Applications[PopUpMenu1.Tag];
    AnObject := Applications.Objects[PopUpMenu1.Tag];
    Applications.Delete(PopUpMenu1.Tag);
    Applications.InsertObject(PopUpMenu1.Tag-Distance, AString, AnObject);

    AString := Parameters[PopUpMenu1.Tag];
    Parameters.Delete(PopUpMenu1.Tag);
    Parameters.Insert(PopUpMenu1.Tag-Distance, AString);

    ABool := RunAsAdministrators[PopUpMenu1.Tag];
    RunAsAdministrators.Delete(PopUpMenu1.Tag);
    RunAsAdministrators.Insert(PopUpMenu1.Tag-Distance, ABool);
  end;
  ReassignTags;
  MyUpdateRegistry;

end;

procedure TForm1.Down51Click(Sender: TObject);
var
  AString: string;
  AnObject: TObject;
  Distance: integer;
  ABool: Boolean;
begin
  if PopUpMenu1.Tag < Applications.Count -5 then
  begin
    Distance := 5;
  end
  else
  begin
    Distance := Applications.Count - PopUpMenu1.Tag-1;
  end;

  if Distance > 0 then
  begin
    AString := Applications[PopUpMenu1.Tag];
    AnObject := Applications.Objects[PopUpMenu1.Tag];
    Applications.Delete(PopUpMenu1.Tag);
    Applications.InsertObject(PopUpMenu1.Tag+Distance, AString, AnObject);

    AString := Parameters[PopUpMenu1.Tag];
    Parameters.Delete(PopUpMenu1.Tag);
    Parameters.Insert(PopUpMenu1.Tag+Distance, AString);

    ABool := RunAsAdministrators[PopUpMenu1.Tag];
    RunAsAdministrators.Delete(PopUpMenu1.Tag);
    RunAsAdministrators.Insert(PopUpMenu1.Tag+Distance, ABool);


  end;
  ReassignTags;
  MyUpdateRegistry;
end;

initialization
  FileName := GetCurrentDir + '\Launcher.ini';
  LaunchFullFilePath := GetCurrentDir + '\Launcher.exe';
end.
