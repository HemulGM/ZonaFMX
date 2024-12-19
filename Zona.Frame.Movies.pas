unit Zona.Frame.Movies;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, Zona.API, FMX.Ani;

type
  TFrameMovies = class(TFrame)
    LayoutItemsOver: TLayout;
    LabelNothingFound: TLabel;
    LayoutPaging: TLayout;
    LayoutPages: TLayout;
    ButtonPagesLeft: TButton;
    ButtonPagesRight: TButton;
    HorzScrollBoxPages: THorzScrollBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    VertScrollBoxItems: TVertScrollBox;
    procedure LayoutPagingResize(Sender: TObject);
    procedure ButtonPagesLeftClick(Sender: TObject);
    procedure ButtonPagesRightClick(Sender: TObject);
    procedure HorzScrollBoxPagesViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure VertScrollBoxItemsResize(Sender: TObject);
  private
    FCount: Integer;
    FOffset: Integer;
    FZona: TZonaAPI;
    FQuery: TZonaQueryBuilder;
    FOnItemClick: TNotifyEvent;
    procedure UpdatePaging(TotalCount: Integer);
    procedure FOnChangePage(Sender: TObject);
    procedure ReloadAll(Clear: Boolean);
    procedure SetZona(const Value: TZonaAPI);
    procedure SetOnItemClick(const Value: TNotifyEvent);
    procedure FOnClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property Zona: TZonaAPI read FZona write SetZona;
    procedure UpdateList(Query: TZonaQueryBuilder);
    property OnItemClick: TNotifyEvent read FOnItemClick write SetOnItemClick;
  end;

var
  OffsetY: Integer = 8;
  OffsetX: Integer = 8;
  ItemWidth: Integer = 170;
  ItemHeight: Integer = 280;

implementation

uses
  System.Math, HGM.FMX.Image, HGM.ObjectHolder, System.DateUtils,
  Zona.Frame.Movie;

{$R *.fmx}

procedure TFrameMovies.FOnChangePage(Sender: TObject);
begin
  FOffset := (Sender as TControl).Tag * FCount;
  ReloadAll(False);
end;

procedure TFrameMovies.FOnClick(Sender: TObject);
begin
  if Assigned(FOnItemClick) then
    FOnItemClick(Sender);
end;

procedure TFrameMovies.ReloadAll(Clear: Boolean);
begin
  VertScrollBoxItems.Tag := VertScrollBoxItems.Tag + 1;
  var QueryId := VertScrollBoxItems.Tag;

  if Clear then
  begin
    HorzScrollBoxPages.BeginUpdate;
    while HorzScrollBoxPages.Content.ControlsCount > 0 do
      HorzScrollBoxPages.Content.Controls[0].Free;
    HorzScrollBoxPages.EndUpdate;
    HorzScrollBoxPages.ViewportPosition := TPointF.Zero;
    FOffset := 0;
  end;

  VertScrollBoxItems.BeginUpdate;
  while VertScrollBoxItems.Content.ControlsCount > 0 do
    VertScrollBoxItems.Content.Controls[0].Free;
  VertScrollBoxItems.EndUpdate;
  VertScrollBoxItemsResize(nil);

  var Q := FQuery;
  TaskRun(VertScrollBoxItems,
    procedure(Holder: IComponentHolder)
    begin
      var Movies := Zona.GetMovies(Q.Query, FOffset, FCount{, 'popularity desc, seeds desc, id desc'});
      try
        if not Assigned(Movies) then
          Exit;
        Sync(
          procedure
          begin
            if not Holder.IsLive then
              Exit;
            if QueryId <> VertScrollBoxItems.Tag then
              Exit;
            LabelNothingFound.Visible := Length(Movies.Response.Items) <= 0;
            UpdatePaging(Movies.Response.NumFound);
          end);
        for var Item in Movies.Response.Items do
        begin
          Sync(
            procedure
            begin
              Application.ProcessMessages;
              if not Holder.IsLive then
                Exit;
              if QueryId <> VertScrollBoxItems.Tag then
                Exit;

              var LI := TFrameMovie.Create(VertScrollBoxItems);
              LI.Opacity := 0;
              LI.Width := ItemWidth;
              LI.Height := ItemHeight;
              LI.Fill(Item);
              LI.OnClick := FOnClick;
              VertScrollBoxItems.AddObject(LI);
              TAnimator.AnimateFloat(LI, 'Opacity', 1);

              VertScrollBoxItemsResize(nil);
            end);
        end;
      finally
        Movies.Free;
      end;
    end);
end;

procedure TFrameMovies.SetOnItemClick(const Value: TNotifyEvent);
begin
  FOnItemClick := Value;
end;

procedure TFrameMovies.SetZona(const Value: TZonaAPI);
begin
  FZona := Value;
end;

procedure TFrameMovies.UpdateList(Query: TZonaQueryBuilder);
begin
  FQuery := Query;
  ReloadAll(True);
end;

procedure TFrameMovies.UpdatePaging(TotalCount: Integer);
begin
  if HorzScrollBoxPages.Content.ControlsCount <= 0 then
  begin
    HorzScrollBoxPages.BeginUpdate;
    try
      while HorzScrollBoxPages.Content.ControlsCount > 0 do
        HorzScrollBoxPages.Content.Controls[0].Free;

      LayoutPaging.Visible := TotalCount div FCount > 1;
      if not LayoutPaging.Visible then
        Exit;

      var Num: Integer := 1;
      var LWidth: Single := 0;
      for var i := 1 to TotalCount div FCount do
      begin
        var Button := TRadioButton.Create(HorzScrollBoxPages);
        Button.Align := TAlignLayout.Left;
        Button.GroupName := 'movie_page';
        Button.Margins.Right := 4;
        Button.StyleLookup := 'radiobuttonstyle_filter';
        Button.Text := Num.ToString;
        Button.Tag := Num;
        Button.TextSettings.HorzAlign := TTextAlign.Center;
        HorzScrollBoxPages.AddObject(Button);
        Button.ApplyStyleLookup;
        Button.Width := Button.Canvas.TextWidth(Button.Text) + 30;
        Button.OnChange := FOnChangePage;
        Button.IsChecked := Num = 1;
        LWidth := LWidth + Button.Width + Button.Margins.Right;
        Inc(Num);
      end;
      LWidth := LWidth + ButtonPagesLeft.Width + ButtonPagesLeft.Margins.Right + ButtonPagesRight.Width + ButtonPagesLeft.Margins.Left + 8;
      HorzScrollBoxPages.TagFloat := Min(400, LWidth);
    finally
      HorzScrollBoxPages.EndUpdate;
      LayoutPagingResize(nil);
    end;
  end;
end;

procedure TFrameMovies.VertScrollBoxItemsResize(Sender: TObject);
begin
  var ContentWidth := VertScrollBoxItems.Width - 20;
  var WCount := Max(1, Trunc(ContentWidth / (ItemWidth + OffsetX * 2)));
  var BorderOffset := (ContentWidth - (WCount * (ItemWidth + OffsetX * 2))) / 2;

  VertScrollBoxItems.BeginUpdate;
  for var i := 0 to Pred(VertScrollBoxItems.Content.ControlsCount) do
    if VertScrollBoxItems.Content.Controls[i] is TControl then
    begin
      if WCount > 0 then
      begin
        var Control := TControl(VertScrollBoxItems.Content.Controls[i]);
        var NC := Round(i mod WCount * (Control.Width + OffsetX * 2) + BorderOffset + OffsetX);
        var NR := Round(i div WCount * (Control.Height + OffsetY * 2) + OffsetY);
        if (Control.Position.X <> NC) or (Control.Position.Y <> NR) then
        begin
          Control.Position.X := NC;
          Control.Position.Y := NR;
        end;
      end;
    end;
  VertScrollBoxItems.EndUpdate;
end;

procedure TFrameMovies.ButtonPagesLeftClick(Sender: TObject);
begin
  HorzScrollBoxPages.AniCalculations.MouseWheel(-HorzScrollBoxPages.Width / 3, 0);
end;

procedure TFrameMovies.ButtonPagesRightClick(Sender: TObject);
begin
  HorzScrollBoxPages.AniCalculations.MouseWheel(+HorzScrollBoxPages.Width / 3, 0);
end;

constructor TFrameMovies.Create(AOwner: TComponent);
begin
  inherited;
  FCount := 60;
  FOffset := 0;
  {$IFDEF ANDROID}
  ItemWidth := Round(ItemWidth * 0.8);
  ItemHeight := Round(ItemHeight * 0.8);
  {$ENDIF}
  VertScrollBoxItems.AniCalculations.Animation := True;
  HorzScrollBoxPages.AniCalculations.Animation := True;
  HorzScrollBoxPages.TagFloat := 400;
end;

procedure TFrameMovies.HorzScrollBoxPagesViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  ButtonPagesLeft.Enabled := NewViewportPosition.X <> 0;
  ButtonPagesRight.Enabled := NewViewportPosition.X + HorzScrollBoxPages.Width < HorzScrollBoxPages.ContentBounds.Width;
end;

procedure TFrameMovies.LayoutPagingResize(Sender: TObject);
begin
  LayoutPages.Width := Min(HorzScrollBoxPages.TagFloat, LayoutPaging.Width);
end;

end.

