unit Zona.Frame.Movie;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Styles.Objects, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Ani, Zona.API.Movie;

type
  TBufferedLayout = TLayout;

  TFrameMovie = class(TFrame)
    CheckBox: TCheckBox;
    ImageData: TImage;
    LayoutInfo: TLayout;
    LabelYear: TLabel;
    LabelName: TLabel;
    LayoutStar: TLayout;
    PathStar: TPath;
    LineSep: TLine;
    LabelScore: TLabel;
    RectangleBG: TRectangle;
    LayoutContent: TLayout;
    RectangleAdult: TRectangle;
    Label1: TLabel;
    RectangleOver: TRectangle;
    FloatAnimationOverBG: TFloatAnimation;
    Path1: TPath;
    procedure LabelNameClick(Sender: TObject);
  private
    FYear: string;
    FScore: string;
    FText: string;
    FAdult: Boolean;
    FId: string;
    function GetBitmap: TBitmap;
    procedure SetScore(const Value: string);
    procedure SetText(const Value: string);
    procedure SetYear(const Value: string);
    procedure SetAdult(const Value: Boolean);
    procedure SetId(const Value: string);
  public
    property Text: string read FText write SetText;
    property Year: string read FYear write SetYear;
    property Score: string read FScore write SetScore;
    property Image: TBitmap read GetBitmap;
    property Adult: Boolean read FAdult write SetAdult;
    property Id: string read FId write SetId;
    procedure Fill(Data: TZonaMovie);
    procedure AfterConstruction; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses
  Zona.API, HGM.FMX.Image;

{$R *.fmx}

{ TFrameMovie }

procedure TFrameMovie.AfterConstruction;
begin
  inherited;
end;

constructor TFrameMovie.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
  CanFocus := True;
end;

destructor TFrameMovie.Destroy;
begin
  inherited;
end;

procedure TFrameMovie.Fill(Data: TZonaMovie);
begin
  Id := Data.Id;
  Text := Data.NameRus;
  if Text.IsEmpty then
    Text := Data.NameOriginal;
  Year := Data.Year.ToString + ' ' + Data.Country;

  var Rating := Data.RatingIMDB;
  if Rating = 0 then
    Rating := Data.RatingKP;
  if Rating = 0 then
    Rating := 10 + Data.Rating;
  if Rating = 0 then
    Score := '-.-'
  else
    Score := FormatFloat('0.0', Rating);

  Adult := Data.Adult;
  RectangleBG.Visible := True;

  Image.LoadFromUrlAsync(Self, TZonaAPI.BuildImageUrlV1(Id), True,
    procedure(Result: Boolean)
    begin
      if not Result then
      begin
        Image.LoadFromUrlAsync(Self, TZonaAPI.BuildImageUrlV2(Id), True,
          procedure(Result: Boolean)
          begin
            if Result then
              RectangleBG.Visible := False;
            Repaint;
          end);
      end
      else
      begin
        RectangleBG.Visible := False;
        Repaint;
      end;
    end);
end;

function TFrameMovie.GetBitmap: TBitmap;
begin
  Result := ImageData.Bitmap;
end;

procedure TFrameMovie.LabelNameClick(Sender: TObject);
begin
  Click;
end;

procedure TFrameMovie.SetAdult(const Value: Boolean);
begin
  FAdult := Value;
  RectangleAdult.Visible := FAdult;
end;

procedure TFrameMovie.SetId(const Value: string);
begin
  FId := Value;
end;

procedure TFrameMovie.SetScore(const Value: string);
begin
  FScore := Value;
  LabelScore.Text := FScore;
end;

procedure TFrameMovie.SetText(const Value: string);
begin
  FText := Value;
  LabelName.Text := Value;
  LabelName.Hint := Value;
end;

procedure TFrameMovie.SetYear(const Value: string);
begin
  FYear := Value;
  LabelYear.Text := FYear;
end;

end.

