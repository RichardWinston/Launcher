object frmAbout: TfrmAbout
  Left = 254
  Top = 115
  Caption = 'About'
  ClientHeight = 204
  ClientWidth = 247
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 8
    Top = 0
    Width = 139
    Height = 42
    Caption = 'Launcher'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 96
    Width = 158
    Height = 19
    Caption = 'by: Richard B. Winston'
  end
  object ASLink1: TASLink
    Left = 8
    Top = 120
    Width = 195
    Height = 20
    Cursor = crHandPoint
    Transparent = True
    Caption = 'rbwinston@mindspring.com'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object BitBtn1: TBitBtn
    Left = 128
    Top = 144
    Width = 75
    Height = 25
    Caption = '&Done'
    Kind = bkClose
    NumGlyphs = 2
    TabOrder = 0
  end
end
