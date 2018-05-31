unit frmAboutUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ASLink{, verslab};

type
  TfrmAbout = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ASLink1: TASLink;
    BitBtn1: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}

end.
