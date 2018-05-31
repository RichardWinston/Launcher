unit ManipulateBitmaps;

interface

uses ShellAPI, Windows, SysUtils, Graphics, ExtCtrls;

procedure GetIndicies(const DestinationLength, SourceLength,
  DestinationIndex : integer;
  Out FirstIndex, LastIndex : integer;
  Out FirstFraction, LastFraction : double);

procedure StretchBitmap(const Source, Destination : TBitmap);

procedure DrawIconInImage(FileName : string; AnImage : TImage);

implementation

type
  PLongIntArray = ^TLongIntArray;
  TLongIntArray = array[0..16383] of longint;

procedure GetIndicies(const DestinationLength, SourceLength,
  DestinationIndex : integer;
  Out FirstIndex, LastIndex : integer;
  Out FirstFraction, LastFraction : double);
{
This proceedure compares the length of two pixel arrays and determines
which pixels in the destination are covered by those in the source.
It also determines what fraction of the first and last pixels are covered
in the destination.
}
var
  Index1A : double;
  Index2A : double;
  Index2B : integer;
begin
  Index1A := DestinationIndex/DestinationLength*SourceLength;
  FirstIndex := Trunc(Index1A);
  FirstFraction := 1-Frac(Index1A);
  Index2A := (DestinationIndex+1)/DestinationLength*SourceLength;
  Index2B := Trunc(Index2A);
  if Index2A = Index2B then
  begin
    LastIndex := Index2B-1;
    LastFraction := 1;
  end
  else
  begin
    LastIndex := Index2B;
    LastFraction := Frac(Index2A);
  end;
  if FirstIndex = LastIndex then
  begin
    FirstFraction := FirstFraction - (1 - LastFraction);
    LastFraction := FirstFraction;
  end;
end;

procedure StretchBitmap(const Source, Destination : TBitmap);
{
This proceedure takes stretches the image in Source and puts it Destination.
The size of Destination must be specified before calling StretchBitmap.
}
var
  P, P1 {, P2}: PLongIntArray;
  X, Y : integer;
  FirstY, LastY, FirstX, LastX : integer;
  FirstYFrac, LastYFrac, FirstXFrac, LastXFrac : double;
  YFrac, XFrac : double;
  YIndex, XIndex : integer;
  AColor : TColor;
  Red, Green, Blue : integer;
  RedTotal, GreenTotal, BlueTotal, FracTotal : double;
begin
  Source.PixelFormat := pf32bit;
  Destination.PixelFormat := Source.PixelFormat;

  for Y := 0 to Destination.height -1  do
  begin
    P := Destination.ScanLine[y];

    GetIndicies(Destination.Height,Source.Height, Y,
      FirstY, LastY, FirstYFrac, LastYFrac);

    for x := 0 to Destination.width -1 do
    begin

      GetIndicies(Destination.width,Source.width, X,
        FirstX, LastX, FirstXFrac, LastXFrac);

      RedTotal := 0;
      GreenTotal := 0;
      BlueTotal := 0;
      FracTotal := 0;

      for YIndex := FirstY to LastY do
      begin
        P1 := Source.ScanLine[YIndex];
        if YIndex = FirstY then
        begin
          YFrac := FirstYFrac;
        end
        else if YIndex = LastY then
        begin
          YFrac := LastYFrac;
        end
        else
        begin
          YFrac := 1;
        end;

        for XIndex := FirstX to LastX do
        begin
          AColor := P1[XIndex];
          Red := AColor mod $100;
          AColor := AColor div $100;
          Green := AColor mod $100;
          AColor := AColor div $100;
          Blue := AColor mod $100;

          if XIndex = FirstX then
          begin
            XFrac := FirstXFrac;
          end
          else if XIndex = LastX then
          begin
            XFrac := LastXFrac;
          end
          else
          begin
            XFrac := 1;
          end;

          RedTotal := RedTotal + Red*XFrac*YFrac;
          GreenTotal := GreenTotal + Green*XFrac*YFrac;
          BlueTotal := BlueTotal + Blue*XFrac*YFrac;
          FracTotal := FracTotal + XFrac*YFrac;
        end;
      end;

      Red := Round(RedTotal/FracTotal);
      Green := Round(GreenTotal/FracTotal);
      Blue := Round(BlueTotal/FracTotal);

      AColor := Blue* $10000 + Green*$100 + Red;

      P[X] := AColor;
    end;
  end;
end;

procedure DrawIconInImage(FileName : string; AnImage : TImage);
var
  TheIcon: TIcon;
  ABitMap : TBitMap;
  Bitmap2 : TBitMap;
//  P, P1, P2: PLongIntArray;
//  X, Y : integer;
//  FirstY, LastY, FirstX, LastX : integer;
//  FirstYFrac, LastYFrac, FirstXFrac, LastXFrac : double;
//  YFrac, XFrac : double;
//  YIndex, XIndex : integer;
//  AColor : TColor;
//  Red, Green, Blue : integer;
//  RedTotal, GreenTotal, BlueTotal, FracTotal : double;
begin
  TheIcon := TIcon.Create;
  ABitMap := TBitMap.Create;
  Bitmap2 := TBitMap.Create;
  try
    TheIcon.Handle := ExtractIcon(hInstance, PChar(FileName), 0);

    ABitMap.Width := TheIcon.Width;
    ABitMap.Height := TheIcon.Height;

    if not DrawIconEx(ABitMap.Canvas.Handle, 0,0, TheIcon.Handle, ABitMap.Width,
      ABitMap.Height, 0, 0, DI_NORMAL) then RaiseLastWin32Error;

    Bitmap2.Width := AnImage.Width;
    Bitmap2.Height := AnImage.Height;

    StretchBitmap(ABitMap, Bitmap2);

    AnImage.Picture.Assign(Bitmap2);

  finally
    TheIcon.Free;
    ABitMap.Free;
    Bitmap2.Free;
  end;
end;



end.
