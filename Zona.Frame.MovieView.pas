unit Zona.Frame.MovieView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects, Zona.Frame.TextItem,
  Zona.API, FMX.ListBox;

type
  TFrameMovieView = class(TFrame)
    LayoutContent: TLayout;
    ImageData: TImage;
    LabelTitle: TLabel;
    LayoutClient: TLayout;
    LayoutImage: TLayout;
    FlowLayoutTextItems: TFlowLayout;
    FlowLayoutInfo1: TFlowLayout;
    FlowLayoutInfo2: TFlowLayout;
    LabelDescription: TLabel;
    FrameTextItemScore: TFrameTextItem;
    FrameTextItemName: TFrameTextItem;
    FrameTextItemYear: TFrameTextItem;
    FrameTextItemGenres: TFrameTextItem;
    FrameTextItemCountry: TFrameTextItem;
    FrameTextItemPersons1: TFrameTextItem;
    FrameTextItemPersons3: TFrameTextItem;
    FrameTextItemPersons4: TFrameTextItem;
    FrameTextItemLength: TFrameTextItem;
    FrameTextItemRelease: TFrameTextItem;
    LayoutLoading: TLayout;
    AniIndicator1: TAniIndicator;
    ListBoxTorrents: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    RectangleBG: TRectangle;
    Path1: TPath;
    procedure FrameResize(Sender: TObject);
    procedure FlowLayoutInfo1Resize(Sender: TObject);
    procedure ListBoxTorrentsResize(Sender: TObject);
  private
    FZona: TZonaAPI;
    FIsRecalc: Boolean;
    procedure SetZona(const Value: TZonaAPI);
    procedure FOnPlayItemClick(Sender: TObject);
    procedure FOnListItemResize(Sender: TObject);
  public
    procedure Load(const Id: string);
    property Zona: TZonaAPI read FZona write SetZona;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses
  {$IFDEF MSWINDOWS}
  Winapi.ShellAPI, FMX.Platform.Win,
  {$ENDIF}
  System.Math, HGM.FMX.Image, HGM.ObjectHolder, WinUI3.Dialogs, System.Rtti;

{$R *.fmx}

constructor TFrameMovieView.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
  ListBoxTorrents.AniCalculations.Animation := True;
end;

procedure TFrameMovieView.FlowLayoutInfo1Resize(Sender: TObject);
begin
  var This := Sender as TFlowLayout;
  This.HorizontalGap := 1;
  This.HorizontalGap := 0;
  var H: Single := 0;
  for var Control in This.Controls do
    if Control.Visible then
      H := Max(H, Control.BoundsRect.Bottom + Control.Margins.Bottom);
  This.Height := H;
end;

procedure TFrameMovieView.FOnPlayItemClick(Sender: TObject);
begin
  var Url := (Sender as TButton).TagString;
  {$IFDEF MSWINDOWS}
  ShellExecute(ApplicationHWND, 'open', PChar(Url), nil, nil, 1);
  {$ENDIF}
end;

procedure TFrameMovieView.FOnListItemResize(Sender: TObject);
begin
  var Layout: TFlowLayout;
  if (Sender as TListBoxItem).FindStyleResource<TFlowLayout>('items', Layout) then
  begin
    var H: Single := 0;
    for var Control in Layout.Controls do
      H := Max(H, Control.BoundsRect.Bottom);
    (Sender as TListBoxItem).Height := H + 4;
  end;
end;

procedure TFrameMovieView.FrameResize(Sender: TObject);
begin
  if FIsRecalc then
    Exit;
  FIsRecalc := True;
  try
    LayoutContent.Width := Min(900, Width);
    if LayoutContent.Width < 600 then
    begin
      LayoutImage.Align := TAlignLayout.MostTop;
      LayoutImage.Height := 340;
    end
    else
    begin
      LayoutImage.Align := TAlignLayout.MostLeft;
      LayoutImage.Width := 240;
    end;
    // loading
    if LayoutLoading.Visible then
    begin
      Height := LayoutLoading.Height;
      Exit;
    end;

    var H: Single := 0;
    for var Control in LayoutClient.Controls do
      if Control.Visible and (Control.Align in [TAlignLayout.Top, TAlignLayout.MostTop, TAlignLayout.MostBottom, TAlignLayout.Bottom]) then
      begin
        Control.RecalcSize;
        H := H + Control.Height + Control.Margins.Bottom + Control.Margins.Top;
      end;
    LayoutClient.Height := Max(340 + ListBoxTorrents.Height + 10, H + 50);
    Height := LayoutClient.Height;
  finally
    FIsRecalc := False;
  end;
end;

procedure TFrameMovieView.ListBoxTorrentsResize(Sender: TObject);
begin
  var H: Single := 0;
  for var i := 0 to ListBoxTorrents.Count - 1 do
    H := H + ListBoxTorrents.ListItems[i].Height;
  ListBoxTorrents.Height := H + 50;
end;

procedure TFrameMovieView.Load(const Id: string);
begin
  LayoutLoading.Visible := True;
  LayoutClient.Visible := False;
  ListBoxTorrents.Clear;
  Self.Tag := Self.Tag + 1;
  var QueryId := Self.Tag;
  TaskRun(Self,
    procedure(Holder: IComponentHolder)
    begin
      var Q: TZonaQueryBuilder;
      Q.IfNot('abuse', 'zona');
      Q.IfAnd('id', Id);
      var Movies := Zona.GetMovies(Q.Query, 0, 1);
      try
        Sync(
          procedure
          begin
            Application.ProcessMessages;
            if not Holder.IsLive then
              Exit;
            if QueryId <> Self.Tag then
              Exit;

            if not Assigned(Movies) or (Length(Movies.Response.Items) <= 0) then
            begin
              LayoutLoading.Visible := False;
              LayoutClient.Visible := False;
              Resize;
              ShowUIMessage(TCustomForm(Application.MainForm), 'Фильм не найден');
              Exit;
            end;

            var Item := Movies.Response.Items[0];

            var ItemName := Item.NameRus;
            if ItemName.IsEmpty then
              ItemName := Item.NameEng;
            if ItemName.IsEmpty then
              ItemName := Item.NameOriginal;
            LabelTitle.Text := ItemName + ' ' + Item.MinAge.ToString + '+';

            if Item.Serial then
              LabelTitle.Text := LabelTitle.Text + ' (сериал)';

            LabelDescription.Text := Item.Description;

            var Rating := Item.RatingIMDB;
            if Rating = 0 then
              Rating := Item.RatingKP;
            if Rating = 0 then
              Rating := 10 + Item.Rating;
            if Rating = 0 then
              FrameTextItemScore.Text := '-.-'
            else
              FrameTextItemScore.Text := FormatFloat('0.0', Rating);

            FrameTextItemName.Text := Item.NameOriginal;
            if FrameTextItemName.Text.IsEmpty then
              FrameTextItemName.Text := Item.NameRus;

            if FrameTextItemName.Text.IsEmpty then
              FrameTextItemName.Text := Item.NameEng;

            FrameTextItemYear.Text := Item.Year.ToString;
            FrameTextItemGenres.Text := Item.GenreNames;
            FrameTextItemCountry.Text := Item.Country;
            if Item.ReleaseDateRus <> 0 then
              FrameTextItemRelease.Text := DateToStr(Item.ReleaseDateRus)
            else
              FrameTextItemRelease.Text := DateToStr(Item.ReleaseDateInt);
            if Item.Runtime = 0 then
              FrameTextItemLength.Text := '-'
            else
              FrameTextItemLength.Text := Item.Runtime.ToString + ' мин.';

            var Persons: TArray<string>;

            Persons := [];
            for var Per in Item.PersonItems do
              if Per.Role = 1 then
              begin
                var PerName := Per.Name;
                if PerName.IsEmpty then
                  PerName := Per.NameEng;
                Persons := Persons + [PerName];
              end;
            FrameTextItemPersons1.Text := string.Join(', ', Persons);

            Persons := [];
            for var Per in Item.PersonItems do
              if Per.Role = 3 then
              begin
                var PerName := Per.Name;
                if PerName.IsEmpty then
                  PerName := Per.NameEng;
                Persons := Persons + [PerName];
              end;
            FrameTextItemPersons3.Text := string.Join(', ', Persons);

            Persons := [];
            for var Per in Item.PersonItems do
              if Per.Role = 4 then
              begin
                var PerName := Per.Name;
                if PerName.IsEmpty then
                  PerName := Per.NameEng;
                Persons := Persons + [PerName];
              end;
            FrameTextItemPersons4.Text := string.Join(', ', Persons);

            ImageData.Bitmap := nil;
            RectangleBG.Visible := True;

            var Id := Item.Id;
            var Url := Zona.BuildImageUrlV1(Id);
            ImageData.Bitmap.LoadFromUrlAsync(ImageData, Url, True,
              procedure(Result: Boolean)
              begin
                if not Result then
                begin
                  var Url := Zona.BuildImageUrlV2(Id);
                  ImageData.Bitmap.LoadFromUrlAsync(ImageData, Url, True,
                    procedure(Result: Boolean)
                    begin
                      RectangleBG.Visible := not Result;
                      ImageData.Repaint;
                    end);
                end
                else
                begin
                  RectangleBG.Visible := not Result;
                  ImageData.Repaint;
                end;
              end);
            LayoutLoading.Visible := False;
            LayoutClient.Visible := True;
            FlowLayoutInfo1Resize(FlowLayoutInfo1);
            FlowLayoutInfo1Resize(FlowLayoutInfo2);
            FlowLayoutInfo1Resize(FlowLayoutTextItems);
            FrameResize(nil);
          end);
      finally
        Movies.Free;
      end;
      var QT: TZonaQueryBuilder;
      QT.IfAnd('kinopoisk_id', Id);
      QT.IfAnd('peers', 10, Integer.MaxValue);
      var Torrents := Zona.GetTorrents(QT.Query, 0, Integer.MaxValue, 'quality_id asc, peers desc');
      if Assigned(Torrents) then
      try
        Sync(
          procedure
          begin
            Application.ProcessMessages;
            if not Holder.IsLive then
              Exit;
            if QueryId <> Self.Tag then
              Exit;

            ListBoxTorrents.BeginUpdate;
            try
              for var Item in Torrents.Response.Items do
              begin
                var LI := TListBoxItem.Create(ListBoxTorrents);
                LI.StyleLookup := 'listboxitemstyle_tor_list2';
                LI.Height := 50;

                LI.Text := Item.Seeds.ToString + '/' + Item.Peers.ToString;
                LI.StylesData['quality'] := Item.QualityId.ToString;
                LI.StylesData['resolution'] := Item.Resolution;
                LI.StylesData['audio'] := Item.Language;
                LI.StylesData['size'] := FormatFloat('0.0', (Item.SizeBytes / 1024 / 1024 / 1024)) + ' гб';
                LI.StylesData['quality2'] := Item.QualityId.ToString;
                LI.StylesData['play.TagString'] := Item.TorrentDownloadLink;
                LI.StylesData['play.OnClick'] := TValue.From<TNotifyEvent>(FOnPlayItemClick);
                LI.DisableDisappear := True;
                LI.OnResize := FOnListItemResize;
                LI.OnResized := FOnListItemResize;

                ListBoxTorrents.AddObject(LI);
              end;
            finally
              ListBoxTorrents.Height := 50 * ListBoxTorrents.Count + 50;
              ListBoxTorrents.EndUpdate;
              FrameResize(nil);
            end;
          end);
      finally
        Torrents.Free;
      end;
    end);
end;

procedure TFrameMovieView.SetZona(const Value: TZonaAPI);
begin
  FZona := Value;
end;

end.

