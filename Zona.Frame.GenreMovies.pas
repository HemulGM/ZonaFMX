unit Zona.Frame.GenreMovies;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  Zona.Frame.Movie, FMX.Layouts, FMX.Controls.Presentation, Zona.API;

type
  THorzScrollBox = class(FMX.Layouts.THorzScrollBox)
  protected
    procedure CMGesture(var EventInfo: TGestureEventInfo); override;
  end;

  TFrameGenreRow = class(TFrame)
    LayoutGenres: TLayout;
    ButtonScrollFilterLeft: TButton;
    ButtonScrollFilterRight: TButton;
    HorzScrollBoxItems: THorzScrollBox;
    ButtonOpen: TButton;
    FrameMovie1: TFrameMovie;
    FrameMovie2: TFrameMovie;
    FrameMovie3: TFrameMovie;
    FrameMovie4: TFrameMovie;
    FrameMovie5: TFrameMovie;
    FrameMovie6: TFrameMovie;
    FrameMovie7: TFrameMovie;
    FrameMovie8: TFrameMovie;
    FrameMovie9: TFrameMovie;
    FrameMovie10: TFrameMovie;
    FrameMovie11: TFrameMovie;
    FrameMovie12: TFrameMovie;
    FrameMovie13: TFrameMovie;
    procedure FramePaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
    procedure ButtonOpenApplyStyleLookup(Sender: TObject);
    procedure ButtonScrollFilterLeftClick(Sender: TObject);
    procedure ButtonScrollFilterRightClick(Sender: TObject);
    procedure HorzScrollBoxItemsViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure ButtonOpenClick(Sender: TObject);
  private
    FLoaded: Boolean;
    FOffset: Integer;
    FCount: Integer;
    FZona: TZonaApi;
    FIsSerial: Boolean;
    FGenre: string;
    FTitleOpen: string;
    FLoading: Boolean;
    FDone: Boolean;
    FYear: string;
    FOnItemClick: TNotifyEvent;
    FOnGroupClick: TNotifyEvent;
    procedure ReloadAll(Clear: Boolean);
    procedure SetZona(const Value: TZonaApi);
    procedure SetGenre(const Value: string);
    procedure SetIsSerial(const Value: Boolean);
    procedure SetTitleOpen(const Value: string);
    procedure SetYear(const Value: string);
    procedure DoItemClick(Sender: TObject);
    procedure SetOnItemClick(const Value: TNotifyEvent);
    procedure SetOnGroupClick(const Value: TNotifyEvent);
  public
    constructor Create(AOwner: TComponent); override;
    property Zona: TZonaApi read FZona write SetZona;
    property Genre: string read FGenre write SetGenre;
    property IsSerial: Boolean read FIsSerial write SetIsSerial;
    property TitleOpen: string read FTitleOpen write SetTitleOpen;
    property Year: string read FYear write SetYear;
    property OnItemClick: TNotifyEvent read FOnItemClick write SetOnItemClick;
    property OnGroupClick: TNotifyEvent read FOnGroupClick write SetOnGroupClick;
    procedure Load;
  end;

implementation

uses
  HGM.FMX.Image, FMX.Utils, FMX.Styles.Objects, HGM.ObjectHolder,
  System.DateUtils, FMX.Ani, Zona.Main;

{$R *.fmx}

{ TFrameGenreRow }

procedure TFrameGenreRow.ButtonOpenApplyStyleLookup(Sender: TObject);
begin
  var Text: TButtonStyleTextObject;
  if ButtonOpen.FindStyleResource<TButtonStyleTextObject>('text', Text) then
  begin
    Text.RecalcSize;
    ButtonOpen.Width := Text.Width + 50;
  end;
end;

procedure TFrameGenreRow.ButtonOpenClick(Sender: TObject);
begin
  if Assigned(FOnGroupClick) then
    FOnGroupClick(Self);
end;

procedure TFrameGenreRow.ButtonScrollFilterLeftClick(Sender: TObject);
begin
  HorzScrollBoxItems.AniCalculations.MouseWheel(-HorzScrollBoxItems.Width / 3, 0);
end;

procedure TFrameGenreRow.ButtonScrollFilterRightClick(Sender: TObject);
begin
  HorzScrollBoxItems.AniCalculations.MouseWheel(+HorzScrollBoxItems.Width / 3, 0);
end;

constructor TFrameGenreRow.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
  FLoaded := False;
  FLoading := False;
  FDone := False;
  FOffset := 0;
  FCount := 15;
  FIsSerial := False;
  HorzScrollBoxItems.AniCalculations.Animation := True;
  Zona := FormMain.Zona;
end;

procedure TFrameGenreRow.FramePaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
  if not FLoaded then
  begin
    FLoaded := True;
    Load;
  end;
end;

procedure TFrameGenreRow.HorzScrollBoxItemsViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  ButtonScrollFilterLeft.Enabled := NewViewportPosition.X <> 0;
  ButtonScrollFilterRight.Enabled := NewViewportPosition.X + HorzScrollBoxItems.Width < HorzScrollBoxItems.ContentBounds.Width;
  if (not ButtonScrollFilterRight.Enabled) and (not FLoading) and (not FDone) then
  begin
    FOffset := FOffset + FCount;
    ReloadAll(False);
  end;
end;

procedure TFrameGenreRow.Load;
begin
  ReloadAll(True);
end;

procedure TFrameGenreRow.DoItemClick(Sender: TObject);
begin
  if Assigned(FOnItemClick) then
    FOnItemClick(Sender);
end;

procedure TFrameGenreRow.ReloadAll(Clear: Boolean);
begin
  HorzScrollBoxItems.Tag := HorzScrollBoxItems.Tag + 1;
  var QueryId := HorzScrollBoxItems.Tag;

  if Clear then
  begin
    FOffset := 0;
    HorzScrollBoxItems.BeginUpdate;
    while HorzScrollBoxItems.Content.ControlsCount > 0 do
      HorzScrollBoxItems.Content.Controls[0].Free;
    HorzScrollBoxItems.EndUpdate;
  end;
  FLoading := True;
  TaskRun(HorzScrollBoxItems,
    procedure(Holder: IComponentHolder)
    begin
      var Q: TZonaQueryBuilder;
      Q.IfNot('abuse', 'zona');
      Q.IfAnd('tor_count', 1, 2147483647);
      Q.IfAnd('indexed', 1, 8);
      Q.IfAnd('serial', FIsSerial);
      if not FYear.IsEmpty then
        Q.IfAnd('year', FYear);
      if not FGenre.IsEmpty then
        Q.IfAnd('genreId', [FGenre]);
      var Movies := Zona.GetMovies(Q.Query, FOffset, FCount, 'year desc, popularity desc, seeds desc, id desc');
      try
        if not Assigned(Movies) then
          Exit;
        Sync(
          procedure
          begin
            if not Holder.IsLive then
              Exit;
            if QueryId <> HorzScrollBoxItems.Tag then
              Exit;
            FDone := Length(Movies.Response.Items) <= 0;
          end);
        for var Item in Movies.Response.Items do
        begin
          Sync(
            procedure
            begin
              if not Holder.IsLive then
                Exit;
              if QueryId <> HorzScrollBoxItems.Tag then
                Exit;
              Application.ProcessMessages;
              if not Holder.IsLive then
                Exit;
              if QueryId <> HorzScrollBoxItems.Tag then
                Exit;

              var LI := TFrameMovie.Create(HorzScrollBoxItems);
              LI.Opacity := 0;
              LI.Position.X := HorzScrollBoxItems.Content.ControlsCount * 200;
              LI.Align := TAlignLayout.Left;
              LI.Margins.Left := 10;
              LI.Width := ItemWidth;
              LI.Height := ItemHeight;
              LI.Fill(Item);
              LI.OnClick := DoItemClick;
              HorzScrollBoxItems.AddObject(LI);
              TAnimator.AnimateFloat(LI, 'Opacity', 1);
            end);
        end;
        Sync(
          procedure
          begin
            if not Holder.IsLive then
              Exit;
            if QueryId <> HorzScrollBoxItems.Tag then
              Exit;
            FLoading := False;
          end);
      finally
        Movies.Free;
      end;
    end);
end;

procedure TFrameGenreRow.SetGenre(const Value: string);
begin
  FGenre := Value;
end;

procedure TFrameGenreRow.SetTitleOpen(const Value: string);
begin
  FTitleOpen := Value;
  ButtonOpen.Text := FTitleOpen;
  ButtonOpen.ApplyStyleLookup;
end;

procedure TFrameGenreRow.SetIsSerial(const Value: Boolean);
begin
  FIsSerial := Value;
end;

procedure TFrameGenreRow.SetOnGroupClick(const Value: TNotifyEvent);
begin
  FOnGroupClick := Value;
end;

procedure TFrameGenreRow.SetOnItemClick(const Value: TNotifyEvent);
begin
  FOnItemClick := Value;
end;

procedure TFrameGenreRow.SetYear(const Value: string);
begin
  FYear := Value;
end;

procedure TFrameGenreRow.SetZona(const Value: TZonaApi);
begin
  FZona := Value;
end;

{ THorzScrollBox }

procedure THorzScrollBox.CMGesture(var EventInfo: TGestureEventInfo);
var
  Handled: Boolean;
  LGObj: IGestureControl;
var
  LP: TPointF;
begin
  //This is used when scrolling with the finger on top of a control (like a TButton on a TListItem).
  if (ContentLayout <> nil) and (EventInfo.GestureID = igiPan) then
  begin
    //FMouseEvents := False;
    LP := ContentLayout.AbsoluteToLocal(EventInfo.Location);
    if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
      AniMouseDown(True, LP.X, LP.Y)
    else if EventInfo.Flags = [] then
      AniMouseMove(True, LP.X, LP.Y)
    else if AniCalculations.Down then
      AniMouseUp(True, LP.X, LP.Y);
  end;

  begin
    Handled := False;
    try
      DoGesture(EventInfo, Handled);
      Handled := False;
    except
      Application.HandleException(Self);
    end;

    if not Handled and (FParent <> nil) and (EventInfo.GestureID <> sgiNoGesture) and Supports(Parent, IGestureControl, LGObj) then
      LGObj.CMGesture(EventInfo);
  end;
end;

end.

