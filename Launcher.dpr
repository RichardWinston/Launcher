program Launcher;

uses
  Windows,
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {frmSize},
  frmAboutUnit in 'frmAboutUnit.pas' {frmAbout},
  ManipulateBitmaps in 'ManipulateBitmaps.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TfrmSize, frmSize);
  Application.CreateForm(TfrmAbout, frmAbout);
  ShowWindow(Application.Handle, SW_HIDE);
  Form1.Show;
  
  Application.Run;
end.
