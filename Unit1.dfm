object Form1: TForm1
  Left = 644
  Top = 112
  BorderStyle = bsDialog
  Caption = ' '
  ClientHeight = 539
  ClientWidth = 234
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object Button1: TSpeedButton
    Left = 0
    Top = 0
    Width = 23
    Height = 22
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      0400000000000001000000000000000000001000000010000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0033333333B333
      333B33FF33337F3333F73BB3777BB7777BB3377FFFF77FFFF77333B000000000
      0B3333777777777777333330FFFFFFFF07333337F33333337F333330FFFFFFFF
      07333337F3FF3FFF7F333330F00F000F07333337F77377737F333330FFFFFFFF
      07333FF7F3FFFF3F7FFFBBB0F0000F0F0BB37777F7777373777F3BB0FFFFFFFF
      0BBB3777F3FF3FFF77773330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F37F3333330F08F0F0B33333337F7737F77FF333330FFFF003B
      B3333337FFFF77377FF333B000000333BB33337777777F3377FF3BB3333BB333
      3BB33773333773333773B333333B3333333B7333333733333337}
    NumGlyphs = 2
    OnClick = Button1Click
  end
  object Image1: TImage
    Left = 0
    Top = 22
    Width = 32
    Height = 32
    Picture.Data = {
      055449636F6E0000010001002020100000000000E80200001600000028000000
      2000000040000000010004000000000080020000000000000000000000000000
      0000000000000000000080000080000000808000800000008000800080800000
      80808000C0C0C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
      FFFFFF0000000090009000000000000000000000000090090099000000000000
      0000000009000909000900000000000000000000099909090900990000000000
      0000000000990990990099900000000000000000009900990990999000000000
      0000000000099009999999990000000000000000099099099999999900000000
      0000000000900990999BBBBB0000000000000000909999999BBBBBB000000000
      00000000990099999BBBBB70000000000000000009900999BBBBB77700000000
      0000000000999009BBBB7777700000000000000000009999BBB7777777000000
      0000000000999999BB777777777000000000000000099999B007777777770000
      0000000000000000000077777777700000000000000000000000077777777000
      0000000000000000000000777777700000000000000000000000000777777700
      0000000000000000000000007777777000000000000000000000000000077777
      0000000000000000000000000000777770000000000000000000000000000777
      7700000000000000000000000000007777000000000000000000000000000007
      7700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FDDFFFFFF6CFFFFFBAEFFFFF8AB3FFFFC931FFFFCC91FFFFE600FFFF
      9200FFFFD900FFFF4000FFFF30007FFF98003FFFC6001FFFF0000FFFC00007FF
      E00003FFFFC003FFFFE001FFFFF001FFFFF800FFFFFC007FFFFE003FFFFF801F
      FFFFE01FFFFFF01FFFFFF80FFFFFFC07FFFFFF87FFFFFFC3FFFFFFF1FFFFFFF9
      FFFFFFFE}
    PopupMenu = PopupMenu3
    OnDblClick = Image1DblClick
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
  end
  object ActivApp1: TActivApp
    MainFormTitle = 'MyOtherApp'
    ExePath = 'E:\Program Files\Borland\Delphi4\Bin\'
    Left = 8
    Top = 152
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'exe'
    Filter = 'Programs (*.exe)|*.exe|All files (*.*)|*.*'
    Left = 8
    Top = 184
  end
  object PopupMenu1: TPopupMenu
    Left = 8
    Top = 120
    object Up1: TMenuItem
      Caption = '&Up'
      OnClick = Up1Click
    end
    object Down1: TMenuItem
      Caption = '&Down'
      OnClick = Down1Click
    end
    object Up51: TMenuItem
      Caption = 'Up 5'
      OnClick = Up51Click
    end
    object Down51: TMenuItem
      Caption = 'Down 5'
      OnClick = Down51Click
    end
    object Delete1: TMenuItem
      Caption = 'De&lete'
      OnClick = Delete1Click
    end
    object Edit1: TMenuItem
      Caption = '&Edit'
      OnClick = Edit1Click
    end
  end
  object BNArea1: TTBNArea
    Copyright = #169' R. N'#228'gele 1997 - 99, Version 3.1'
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      0090009000000000000000000000000090090099000000000000000000000900
      0909000900000000000000000000099909090900990000000000000000000099
      0990990099900000000000000000009900990990999000000000000000000009
      9009999999990000000000000000099099099999999900000000000000000090
      0990999BBBBB0000000000000000909999999BBBBBB000000000000000009900
      99999BBBBB70000000000000000009900999BBBBB77700000000000000000099
      9009BBBB7777700000000000000000009999BBB7777777000000000000000099
      9999BB777777777000000000000000099999B007777777770000000000000000
      0000000077777777700000000000000000000000077777777000000000000000
      0000000000777777700000000000000000000000000777777700000000000000
      0000000000007777777000000000000000000000000000077777000000000000
      0000000000000000777770000000000000000000000000000777770000000000
      0000000000000000007777000000000000000000000000000007770000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FDDF
      FFFFF6CFFFFFBAEFFFFF8AB3FFFFC931FFFFCC91FFFFE600FFFF9200FFFFD900
      FFFF4000FFFF30007FFF98003FFFC6001FFFF0000FFFC00007FFE00003FFFFC0
      03FFFFE001FFFFF001FFFFF800FFFFFC007FFFFE003FFFFF801FFFFFE01FFFFF
      F01FFFFFF80FFFFFFC07FFFFFF87FFFFFFC3FFFFFFF1FFFFFFF9FFFFFFFE}
    PopupMenuR = PopupMenu2
    Tip = 'Launcher'
    OnLeftClick = BNArea1LeftClick
    Left = 8
    Top = 88
  end
  object PopupMenu2: TPopupMenu
    Left = 8
    Top = 216
    object About2: TMenuItem
      Caption = '&About'
      OnClick = About1Click
    end
    object StayOnTop1: TMenuItem
      Caption = 'Stay On &Top'
      OnClick = StayOnTop1Click
    end
    object Exit1: TMenuItem
      Caption = '&Exit'
      OnClick = Exit1Click
    end
  end
  object PopupMenu3: TPopupMenu
    Left = 8
    Top = 248
    object About1: TMenuItem
      Caption = '&About'
      OnClick = About1Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 8
    Top = 288
  end
end