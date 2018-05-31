object Form2: TForm2
  Left = 375
  Top = 368
  Caption = 'Application Properties'
  ClientHeight = 147
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 63
    Height = 15
    Caption = 'Application'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 58
    Height = 15
    Caption = 'Parameters'
  end
  object edApp: TEdit
    Left = 8
    Top = 24
    Width = 385
    Height = 23
    TabOrder = 0
  end
  object edParam: TEdit
    Left = 8
    Top = 72
    Width = 465
    Height = 23
    TabOrder = 2
  end
  object BitBtn1: TBitBtn
    Left = 400
    Top = 104
    Width = 75
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 4
  end
  object BitBtn2: TBitBtn
    Left = 320
    Top = 104
    Width = 75
    Height = 25
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
  end
  object Button1: TButton
    Left = 400
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Bowse'
    TabOrder = 1
    OnClick = Button1Click
  end
  object cbRunAsAdmin: TCheckBox
    Left = 8
    Top = 104
    Width = 153
    Height = 17
    Caption = 'Run as Administrator'
    TabOrder = 5
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'Programs (*.exe)|*.exe|All files (*.*)|*.*'
    Left = 64
  end
end
