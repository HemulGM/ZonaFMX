unit Zona.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, WinUI3.Form,
  FMX.Objects, FMX.Ani, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Styles.Switch, FMX.Filter.Effects, FMX.Styles.Objects, FMX.ListBox,
  FMX.Layouts, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, REST.Types, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, REST.Client, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.Bind.ObjectScope, REST.Response.Adapter,
  FMX.ExtCtrls, FMX.Edit, FMX.Menus, Zona.API, FMX.TabControl,
  System.Generics.Collections, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  System.Skia, FMX.Skia, Zona.Frame.GenreMovies, FMX.MultiView,
  Zona.Frame.MovieView, Zona.Frame.Movies, FMX.ComboEdit, System.Actions,
  FMX.ActnList;

type
  TVertScrollBox = FMX.Layouts.TFramedVertScrollBox;

  TFormMain = class(TWinUIForm)
    StyleBookWinUI3: TStyleBook;
    StyleBookZone: TStyleBook;
    LayoutHead: TLayout;
    LayoutCaption: TLayout;
    EditSearch: TEdit;
    ClearEditButtonSearch: TClearEditButton;
    PopupSearch: TPopup;
    ListBoxSearch: TListBox;
    ListBoxItem125: TListBoxItem;
    LabelTitle: TLabel;
    Layout42: TLayout;
    Image7: TImage;
    Label1: TLabel;
    LayoutMenu: TLayout;
    VertScrollBoxMenu: TVertScrollBox;
    ButtonMenuHome: TButton;
    ButtonMenuMovies: TButton;
    ButtonMenuSerials: TButton;
    Label43: TLabel;
    Layout41: TLayout;
    PanelClient: TPanel;
    TabControlMain: TTabControl;
    TabItemMain: TTabItem;
    TabItemMovies: TTabItem;
    VertScrollBoxItems: TVertScrollBox;
    LayoutMoviesHead: TLayout;
    LayoutGenres: TLayout;
    ButtonScrollFilterLeft: TButton;
    ButtonScrollFilterRight: TButton;
    HorzScrollBoxGenre: THorzScrollBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    LabelMovieType: TLabel;
    LayoutItemsOver: TLayout;
    LabelNothingFound: TLabel;
    LayoutPaging: TLayout;
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
    LayoutPages: TLayout;
    VertScrollBoxHome: TVertScrollBox;
    Label2: TLabel;
    SkAnimatedImage1: TSkAnimatedImage;
    ButtonBack: TButton;
    Rectangle1: TRectangle;
    LayoutMobileHead: TLayout;
    ButtonMenu: TButton;
    EditSearchMobile: TEdit;
    ClearEditButton1: TClearEditButton;
    MultiViewMenu: TMultiView;
    ButtonMMenuHome: TButton;
    ButtonMMenuSerials: TButton;
    ButtonMMenuMovies: TButton;
    TabItemView: TTabItem;
    TabItemSearch: TTabItem;
    VertScrollBoxView: TVertScrollBox;
    FrameMovieView: TFrameMovieView;
    TimerSearch: TTimer;
    FrameMoviesSearch: TFrameMovies;
    Layout1: TLayout;
    LabelSearch: TLabel;
    ComboEditYear: TComboEdit;
    ActionListKeys: TActionList;
    ActionBack: TAction;
    SearchEditButtonSearch: TSearchEditButton;
    TabItemGroup: TTabItem;
    FrameMoviesGrouped: TFrameMovies;
    Layout2: TLayout;
    LabelGroupName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonMenuHomeClick(Sender: TObject);
    procedure ButtonMenuMoviesClick(Sender: TObject);
    procedure ButtonMenuSerialsClick(Sender: TObject);
    procedure VertScrollBoxItemsResize(Sender: TObject);
    procedure ButtonScrollFilterLeftClick(Sender: TObject);
    procedure ButtonScrollFilterRightClick(Sender: TObject);
    procedure HorzScrollBoxGenreViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure LayoutCaptionResize(Sender: TObject);
    procedure VertScrollBoxItemsViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure ButtonPagesLeftClick(Sender: TObject);
    procedure ButtonPagesRightClick(Sender: TObject);
    procedure LayoutPagingResize(Sender: TObject);
    procedure HorzScrollBoxPagesViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
    procedure ButtonBackClick(Sender: TObject);
    procedure SkAnimatedImage1Click(Sender: TObject);
    procedure EditSearchChangeTracking(Sender: TObject);
    procedure TimerSearchTimer(Sender: TObject);
    procedure ComboEditYearChange(Sender: TObject);
    procedure ActionBackExecute(Sender: TObject);
    procedure EditSearchEnter(Sender: TObject);
    procedure EditSearchExit(Sender: TObject);
    procedure VertScrollBoxViewResize(Sender: TObject);
    procedure SearchEditButtonSearchClick(Sender: TObject);
  private
    FZonaAPI: TZonaAPI;
    FIsSerial: Boolean;
    FSearch: string;
    FGenre: string;
    FYear: string;
    FOffset: Integer;
    FHideAdult: Boolean;
    FCount: Integer;
    FTotalCount: Integer;
    FCurrentMenu: Integer;
    FFromSearch: Boolean;
    FFromGrouped: Boolean;
    procedure LoadMovies;
    procedure LoadSerials;
    procedure UpdateMenu;
    procedure FOnChangeGenre(Sender: TObject);
    procedure LoadGenres;
    procedure FOnApiLog(Text: string);
    procedure UpdatePaging(TotalCount: Integer);
    procedure FOnChangePage(Sender: TObject);
    procedure CreateHome;
    procedure OpenHome;
    procedure OpenMovies;
    procedure OpenSerials;
    procedure CreateSearch;
    procedure OpenSearch(const Text: string);
    procedure OpenView(const Id: string);
    procedure FOnViewMovie(Sender: TObject);
    procedure FOnGroupClick(Sender: TObject);
  protected
    procedure DoOnSettingChange; override;
  public
    property Zona: TZonaAPI read FZonaAPI;
    procedure ReloadAll(Clear: Boolean);
    property IsSerial: Boolean read FIsSerial;
  end;

var
  FormMain: TFormMain;
  OldColor: TAlphaColor = $FF60CDFF;
  OldColorAccentText: TAlphaColor = $FF99EBFF;

var
  OffsetY: Integer = 8;
  OffsetX: Integer = 8;
  ItemWidth: Integer = 170;
  ItemHeight: Integer = 280;

implementation

uses
  HGM.ColorUtils, System.Math, System.Threading, System.DateUtils,
  SYstem.Character, System.Messaging, HGM.FMX.Image, HGM.ObjectHolder,
  Zona.Frame.Movie;

{$R *.fmx}

procedure ChangeStyleBookColor(StyleBook: TStyleBook; OldColor, NewColor: TAlphaColor);
var
  OldColorRec: TAlphaColorF;
  NewColorRec: TAlphaColorF;

  procedure ForAll(Obj: TFmxObject; Proc: TProc<TFmxObject>);
  begin
    Proc(Obj);
    if Assigned(Obj.Children) then
      for var Child in Obj.Children do
        ForAll(Child, Proc);
  end;

begin
  var Style := StyleBook.Style;
  OldColorRec := TAlphaColorF.Create(OldColor);
  NewColorRec := TAlphaColorF.Create(NewColor);
  ForAll(Style,
    procedure(Item: TFmxObject)
    begin
      Item.TagString := '';
    end);
  ForAll(Style,
    procedure(Item: TFmxObject)

      function UpdateColor(TargetColor: TAlphaColor): TAlphaColor;
      begin
        var Rec := TAlphaColorF.Create(TargetColor);
        if (Rec.R = OldColorRec.R) and (Rec.G = OldColorRec.G) and (Rec.B = OldColorRec.B) then
        begin
          Rec.R := NewColorRec.R;
          Rec.G := NewColorRec.G;
          Rec.B := NewColorRec.B;
        end;
        Result := Rec.ToAlphaColor;
      end;


    begin
      if not Item.TagString.IsEmpty then
        Exit;
      if Item is TShape then
      begin
        var Control := TRectangle(Item);

        Control.Fill.Color := UpdateColor(Control.Fill.Color);
        Control.Stroke.Color := UpdateColor(Control.Stroke.Color);

        Item.TagString := '0';
      end
      else if Item is TColorObject then
      begin
        var Control := TColorObject(Item);
        Control.Color := UpdateColor(Control.Color);
        Item.TagString := '0';
      end
      else if Item is TBrushObject then
      begin
        var Control := TBrushObject(Item);
        Control.Brush.Color := UpdateColor(Control.Brush.Color);
        Item.TagString := '0';
      end
      else if Item is TColorAnimation then
      begin
        var Control := TColorAnimation(Item);
        Control.StartValue := UpdateColor(Control.StartValue);
        Control.StopValue := UpdateColor(Control.StopValue);
        Item.TagString := '0';
      end
      else if Item is TLabel then
      begin
        var Control := TLabel(Item);
        Control.TextSettings.FontColor := UpdateColor(Control.TextSettings.FontColor);
        Item.TagString := '0';
      end
      else if Item is TText then
      begin
        if Item is TTabStyleTextObject then
        begin
          var Control := TTabStyleTextObject(Item);
          Control.HotColor := UpdateColor(Control.HotColor);
          Control.ActiveColor := UpdateColor(Control.ActiveColor);
          Control.Color := UpdateColor(Control.Color);
          Item.TagString := '0';
        end
        else if Item is TActiveStyleTextObject then
        begin
          var Control := TActiveStyleTextObject(Item);
          Control.ActiveColor := UpdateColor(Control.ActiveColor);
          Control.Color := UpdateColor(Control.Color);
          Item.TagString := '0';
        end
        else if Item is TButtonStyleTextObject then
        begin
          var Control := TButtonStyleTextObject(Item);
          Control.HotColor := UpdateColor(Control.HotColor);
          Control.FocusedColor := UpdateColor(Control.FocusedColor);
          Control.NormalColor := UpdateColor(Control.NormalColor);
          Control.PressedColor := UpdateColor(Control.PressedColor);
          Item.TagString := '0';
        end
        else
        begin
          var Control := TText(Item);
          Control.TextSettings.FontColor := UpdateColor(Control.TextSettings.FontColor);
          Item.TagString := '0';
        end;
      end
      else if Item is TSwitchObject then
      begin
        var Control := TSwitchObject(Item);
        Control.Fill.Color := UpdateColor(Control.Fill.Color);
        Control.FillOn.Color := UpdateColor(Control.FillOn.Color);
        Control.Stroke.Color := UpdateColor(Control.Stroke.Color);
        Control.Thumb.Color := UpdateColor(Control.Thumb.Color);
        Item.TagString := '0';
      end
      else if Item is TFillRGBEffect then
      begin
        var Control := TFillRGBEffect(Item);
        Control.Color := UpdateColor(Control.Color);
        Item.TagString := '0';
      end;
    end);
  ForAll(Style,
    procedure(Item: TFmxObject)
    begin
      Item.TagString := '';
    end);
  //
end;

procedure TFormMain.FOnChangeGenre(Sender: TObject);
begin
  FGenre := (Sender as TControl).TagString;
  ReloadAll(True);
end;

procedure TFormMain.FOnChangePage(Sender: TObject);
begin
  FOffset := (Sender as TControl).Tag * FCount;
  ReloadAll(False);
end;

procedure TFormMain.LayoutCaptionResize(Sender: TObject);
begin
  EditSearch.Width := Min(500, (LayoutCaption.Width - 200 * 2));
  if EditSearch.Width < 200 then
  begin
    LabelTitle.Visible := False;
    EditSearch.Align := TAlignLayout.Left;
    if ButtonBack.Visible then
      EditSearch.Margins.Left := PanelClient.Position.X + 10
    else
      EditSearch.Margins.Left := PanelClient.Position.X;
    EditSearch.Width := Min(500, (LayoutCaption.Width - 200 - EditSearch.Margins.Left));
  end
  else
  begin
    LabelTitle.Visible := True;
    EditSearch.Align := TAlignLayout.Center;
    EditSearch.Margins.Left := 0;
  end;
end;

procedure TFormMain.LayoutPagingResize(Sender: TObject);
begin
  LayoutPages.Width := Min(HorzScrollBoxPages.TagFloat, LayoutPaging.Width);
end;

procedure TFormMain.LoadGenres;
begin
  TaskRun(Self,
    procedure(Holder: IComponentHolder)
    begin
      var Genres := Zona.GetGenres;
      try
        Sync(
          procedure
          begin
            if not Holder.IsLive then
              Exit;
            HorzScrollBoxGenre.BeginUpdate;
            try
              while HorzScrollBoxGenre.Content.ControlsCount > 0 do
                HorzScrollBoxGenre.Content.Controls[0].Free;

              var ButtonAll := TRadioButton.Create(HorzScrollBoxGenre);
              ButtonAll.Align := TAlignLayout.Left;
              ButtonAll.GroupName := 'movie_genre';
              ButtonAll.Margins.Right := 4;
              ButtonAll.StyleLookup := 'radiobuttonstyle_filter';
              ButtonAll.Text := 'Все';
              ButtonAll.TagString := '';
              ButtonAll.TextSettings.HorzAlign := TTextAlign.Center;
              HorzScrollBoxGenre.AddObject(ButtonAll);
              ButtonAll.ApplyStyleLookup;
              ButtonAll.Width := ButtonAll.Canvas.TextWidth(ButtonAll.Text) + 30;
              ButtonAll.IsChecked := True;
              ButtonAll.OnChange := FOnChangeGenre;

              for var Item in Genres.Response.Items do
              begin
                var Button := TRadioButton.Create(HorzScrollBoxGenre);
                Button.Align := TAlignLayout.Left;
                Button.GroupName := 'movie_genre';
                Button.Margins.Right := 4;
                Button.StyleLookup := 'radiobuttonstyle_filter';
                var Txt := Item.Name;
                Txt[1] := Txt[1].ToUpper;
                Button.Text := Txt;
                Button.TagString := Item.Id;
                Button.TextSettings.HorzAlign := TTextAlign.Center;
                HorzScrollBoxGenre.AddObject(Button);
                Button.ApplyStyleLookup;
                Button.Width := Button.Canvas.TextWidth(Button.Text) + 30;
                Button.OnChange := FOnChangeGenre;
              end;
            finally
              HorzScrollBoxGenre.EndUpdate;
            end;
          end);
      finally
        Genres.Free;
      end;
    end);
end;

procedure TFormMain.LoadMovies;
begin
  LabelMovieType.Text := 'Фильмы';
  FIsSerial := False;
  ReloadAll(True);
end;

procedure TFormMain.LoadSerials;
begin
  LabelMovieType.Text := 'Сериалы';
  FIsSerial := True;
  ReloadAll(True);
end;

procedure TFormMain.UpdateMenu;
begin
  MultiViewMenu.HideMaster;
  ButtonMenuHome.IsPressed := FCurrentMenu = 0;
  ButtonMenuMovies.IsPressed := FCurrentMenu = 1;
  ButtonMenuSerials.IsPressed := FCurrentMenu = 2;
end;

procedure TFormMain.VertScrollBoxItemsResize(Sender: TObject);
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

procedure TFormMain.VertScrollBoxItemsViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin    {
  if (NewViewportPosition.Y <> 0) and (LayoutMoviesHead.Tag <> -1) then
  begin
    LayoutMoviesHead.Tag := -1;
    TAnimator.AnimateFloat(LayoutMoviesHead, 'Height', 0, 0.1);
  end
  else if (NewViewportPosition.Y = 0) and (LayoutMoviesHead.Tag <> 0) then
  begin
    LayoutMoviesHead.Tag := 0;
    TAnimator.AnimateFloat(LayoutMoviesHead, 'Height', 40, 0.1);
  end;   }
end;

procedure TFormMain.VertScrollBoxViewResize(Sender: TObject);
begin
  Queue(
    procedure
    begin
      FrameMovieView.RecalcSize;
      FrameMovieView.FrameResize(nil);
    end);
end;

procedure TFormMain.ButtonPagesLeftClick(Sender: TObject);
begin
  HorzScrollBoxPages.AniCalculations.MouseWheel(-HorzScrollBoxPages.Width / 3, 0);
end;

procedure TFormMain.ButtonPagesRightClick(Sender: TObject);
begin
  HorzScrollBoxPages.AniCalculations.MouseWheel(+HorzScrollBoxPages.Width / 3, 0);
end;

procedure TFormMain.OpenView(const Id: string);
begin
  FFromSearch := TabControlMain.ActiveTab = TabItemSearch;
  FFromGrouped := TabControlMain.ActiveTab = TabItemGroup;
  VertScrollBoxView.ViewportPosition := TPointF.Zero;
  TabControlMain.ActiveTab := TabItemView;
  ButtonBack.Visible := True;
  FrameMovieView.Load(Id);
end;

procedure TFormMain.ActionBackExecute(Sender: TObject);
begin
  if ButtonBack.Visible then
    ButtonBackClick(nil);
end;

procedure TFormMain.ButtonBackClick(Sender: TObject);
begin
  if FFromSearch then
  begin
    FFromSearch := False;
    TabControlMain.ActiveTab := TabItemSearch;
    Exit;
  end;
  if FFromGrouped then
  begin
    FFromGrouped := False;
    TabControlMain.ActiveTab := TabItemGroup;
    Exit;
  end;
  ButtonBack.Visible := False;
  LayoutCaptionResize(nil);

  case FCurrentMenu of
    0:
      TabControlMain.ActiveTab := TabItemMain;
    1:
      TabControlMain.ActiveTab := TabItemMovies;
    2:
      TabControlMain.ActiveTab := TabItemMovies;
  end;
end;

procedure TFormMain.OpenHome;
begin
  FCurrentMenu := 0;
  FFromSearch := False;
  FFromGrouped := False;
  ButtonBack.Visible := False;
  LayoutCaptionResize(nil);
  TabControlMain.ActiveTab := TabItemMain;
  UpdateMenu;
end;

procedure TFormMain.OpenMovies;
begin
  FCurrentMenu := 1;
  FFromSearch := False;
  FFromGrouped := False;
  ButtonBack.Visible := False;
  LayoutCaptionResize(nil);
  LoadMovies;
  TabControlMain.ActiveTab := TabItemMovies;
  UpdateMenu;
end;

procedure TFormMain.OpenSerials;
begin
  FCurrentMenu := 2;
  FFromSearch := False;
  FFromGrouped := False;
  ButtonBack.Visible := False;
  LayoutCaptionResize(nil);
  LoadSerials;
  TabControlMain.ActiveTab := TabItemMovies;
  UpdateMenu;
end;

procedure TFormMain.OpenSearch(const Text: string);
begin
  FSearch := Text;
  TabControlMain.ActiveTab := TabItemSearch;
  ButtonBack.Visible := True;
  LabelSearch.Text := 'Поиск: "' + Text + '"';
  //
  var Q: TZonaQueryBuilder;
  Q.IfNot('abuse', 'zona');
  Q.IfAnd('tor_count', 1, 2147483647);
  Q.IfAnd('indexed', 1, 8);
  Q.BeginParenthesisAnd;
  Q.IfOr('name_original', '*' + Text + '*');
  Q.IfOr('name_rus_search', '*' + Text + '*');
  Q.EndParenthesis;
  FrameMoviesSearch.UpdateList(Q);
end;

procedure TFormMain.ButtonMenuHomeClick(Sender: TObject);
begin
  OpenHome;
end;

procedure TFormMain.ButtonMenuMoviesClick(Sender: TObject);
begin
  OpenMovies;
end;

procedure TFormMain.ButtonMenuSerialsClick(Sender: TObject);
begin
  OpenSerials;
end;

procedure TFormMain.ButtonScrollFilterLeftClick(Sender: TObject);
begin
  HorzScrollBoxGenre.AniCalculations.MouseWheel(-HorzScrollBoxGenre.Width / 3, 0);
end;

procedure TFormMain.ButtonScrollFilterRightClick(Sender: TObject);
begin
  HorzScrollBoxGenre.AniCalculations.MouseWheel(+HorzScrollBoxGenre.Width / 3, 0);
end;

procedure TFormMain.DoOnSettingChange;
begin
  inherited;

  var SysAccent := ChangeColorSat(SystemAccentColor, 50); // DecreaseSaturation(SystemAccentColor, 0.8);

  ChangeStyleBookColor(StyleBookWinUI3, OldColor, SysAccent);
  ChangeStyleBookColor(StyleBookWinUI3, OldColorAccentText, DecreaseSaturation(SysAccent, 10));
  ChangeStyleBookColor(StyleBookZone, OldColor, SysAccent);
  ChangeStyleBookColor(StyleBookZone, OldColorAccentText, DecreaseSaturation(SysAccent, 10));

  var PC_Image := StyleBookWinUI3.Style.FindStyleResource('progresscell_bmp', False);
  if Assigned(PC_Image) and (PC_Image is TImage) then
  begin
    var Img := TImage(PC_Image);
    Img.Bitmap.Clear(SysAccent);
  end;

  OldColor := SysAccent;
  OldColorAccentText := DecreaseSaturation(SysAccent, 10);
  TMessageManager.DefaultManager.SendMessage(Self, TStyleChangedMessage.Create(StyleBookWinUI3, Self), True);
end;

procedure TFormMain.EditSearchChangeTracking(Sender: TObject);
begin
  TimerSearch.Enabled := False;
  if EditSearch.Text.IsEmpty then
    Exit;
  if EditSearch.Text = FSearch then
    Exit;
  TimerSearch.Enabled := True;
end;

procedure TFormMain.EditSearchEnter(Sender: TObject);
begin
  ClearEditButtonSearch.Enabled := not EditSearch.Text.IsEmpty;
end;

procedure TFormMain.EditSearchExit(Sender: TObject);
begin
  ClearEditButtonSearch.Enabled := False;
end;

procedure TFormMain.FOnApiLog(Text: string);
begin
  //
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  TBitmap.CachePath := 'images';
  FCount := 0;

  ComboEditYear.BeginUpdate;
  ComboEditYear.Clear;
  for var i := YearOf(Now) downto YearOf(Now) - 40 do
    ComboEditYear.Items.Add(i.ToString);
  ComboEditYear.EndUpdate;
  ComboEditYear.ItemIndex := 0;
  //ComboEditYear

  FOffset := 0;
  FCount := 63;
  FTotalCount := 0;
  FHideAdult := False;
  FYear := ComboEditYear.Text;
  ButtonMenuHome.StylesData['path.Data.Data'] := '''
    M30.8540000915527,16.5480003356934 C30.5230007171631,17.4300003051758 29.7029991149902,
    18 28.7639999389648,18 L28,18 L28,29 C28,29.5520000457764 27.5520000457764,30 27,
    30 L21,30 L21,23 C21,20.2430000305176 18.7569999694824,18 16,18 C13.2430000305176,
    18 11,20.2430000305176 11,23 L11,30 L5,30 C4.44799995422363,30 4,29.5520000457764 4,29 L4,
    18 L3.23499989509583,18 C2.2960000038147,18 1.47599995136261,17.4309997558594 1.14499998092651,
    16.548999786377 C0.814000010490417,15.6669998168945 1.05699992179871,14.6969995498657 1.76499998569489,
    14.0789995193481 L13.4440002441406,3.01900005340576 C14.8780002593994,1.66200006008148 17.1230010986328,
    1.66200006008148 18.5559997558594,3.01900005340576 L30.2630004882813,14.1050004959106 C30.9409999847412,
    14.6960000991821 31.1849994659424,15.6660003662109 30.8540000915527,16.5480003356934 Z
    ''';
  ButtonMenuMovies.StylesData['path.Data.Data'] := 'M95.45,47.72A47.72,47.72,0,1,0,47.72,95.45H95.45v-8H74.07A47.72,47.72,0,0,0,95.45,47.72ZM71.1,79.9a11.93,11.93,0,1,1,2.64-16.67A11.93,11.93,0,0,1,71.1,79.9Zm-.59-52.12a11.93,11.93,0,1,1-7.66,15A11.93,11.93,0,0,1,70.51,27.77ZM47.72,8A11.93,11.93,0,1,1,35.79,19.88,11.93,11.93,0,0,1,47.72,8ZM9.9,35.43a11.93,11.93,0,1,1,7.66,15A11.93,11.93,0,0,1,9.9,35.43ZM41,77.26a11.93,11.93,0,1,1-2.64-16.66A11.93,11.93,0,0,1,41,77.26Zm2.73-29.53a4,4,0,1,1,4,4A4,4,0,0,1,43.75,47.72Z';
  ButtonMenuSerials.StylesData['path.Data.Data'] := 'M87.24,22.42H54.59L72.22,4.78a2.8,2.8,0,0,0-4-4L47.82,21.26,27.39.82a2.8,2.8,0,0,0-4,4L41.06,22.42H8.41A8.42,8.42,0,0,0,0,30.82V87.24a8.42,8.42,0,0,0,8.41,8.41H87.24a8.42,8.42,0,0,0,8.41-8.41V30.82A8.42,8.42,0,0,0,87.24,22.42ZM90,87.24a2.81,2.81,0,0,1-2.8,2.8H8.41a2.81,2.81,0,0,1-2.8-2.8V30.82A2.81,2.81,0,0,1,8.41,28H87.24a2.81,2.81,0,0,1,2.8,2.8Z M81.63,33.62H14a2.8,2.8,0,0,0-2.8,2.8V81.63a2.8,2.8,0,0,0,2.8,2.8H81.63a2.8,2.8,0,0,0,2.8-2.8V36.43A2.8,2.8,0,0,0,81.63,33.62Zm-21,27.74L43.77,72.57a2.8,2.8,0,0,1-4.36-2.33V47.82a2.8,2.8,0,0,1,4.36-2.33L60.58,56.7a2.8,2.8,0,0,1,0,4.66Z';

  ButtonMMenuHome.StylesData['path.Data.Data'] := ButtonMenuHome.StylesData['path.Data.Data'].AsString;
  ButtonMMenuMovies.StylesData['path.Data.Data'] := ButtonMenuMovies.StylesData['path.Data.Data'].AsString;
  ButtonMMenuSerials.StylesData['path.Data.Data'] := ButtonMenuSerials.StylesData['path.Data.Data'].AsString;

  FZonaAPI := TZonaAPI.Create(Self);
  FZonaAPI.OnLog := FOnApiLog;
  CaptionControls := [LayoutCaption, LayoutHead];
  OffsetControls := [LayoutHead];
  TitleControls := [LabelTitle];
  HideTitleBar := True;
  DoOnSettingChange;
  HorzScrollBoxGenre.AniCalculations.Animation := True;
  HorzScrollBoxPages.AniCalculations.Animation := True;
  HorzScrollBoxPages.TagFloat := 400;
  VertScrollBoxMenu.AniCalculations.Animation := True;
  VertScrollBoxItems.AniCalculations.Animation := True;
  VertScrollBoxHome.AniCalculations.Animation := True;
  VertScrollBoxView.AniCalculations.Animation := True;
  LayoutPaging.Visible := False;
  {$IFDEF ANDROID}
  LayoutMenu.Visible := False;
  LayoutHead.Visible := False;
  LayoutMobileHead.Visible := True;
  ItemWidth := Round(ItemWidth * 0.8);
  ItemHeight := Round(ItemHeight * 0.8);
  {$ELSE}
  LayoutMobileHead.Visible := False;
  {$ENDIF}
  FrameMovieView.Zona := Zona;
  CreateSearch;
  CreateHome;
  OpenHome;
  LoadGenres;
end;

procedure TFormMain.CreateSearch;
begin
  FrameMoviesSearch.Zona := Zona;
  FrameMoviesSearch.OnItemClick := FOnViewMovie;
  FrameMoviesGrouped.Zona := Zona;
  FrameMoviesGrouped.OnItemClick := FOnViewMovie;
end;

procedure TFormMain.ComboEditYearChange(Sender: TObject);
begin
  if FCount = 0 then
    Exit;
  if FYear = ComboEditYear.Text then
    Exit;
  FYear := ComboEditYear.Text;
  ReloadAll(True);
end;

procedure TFormMain.FOnViewMovie(Sender: TObject);
begin
  var Id := (Sender as TFrameMovie).Id;
  OpenView(Id);
end;

procedure TFormMain.FOnGroupClick(Sender: TObject);
begin
  var Item := Sender as TFrameGenreRow;
  TabControlMain.ActiveTab := TabItemGroup;
  ButtonBack.Visible := True;
  LabelGroupName.Text := Item.TitleOpen;
  //
  var Q: TZonaQueryBuilder;
  Q.IfNot('abuse', 'zona');
  Q.IfAnd('tor_count', 1, 2147483647);
  Q.IfAnd('indexed', 1, 8);
  Q.IfAnd('serial', Item.IsSerial);
  if not Item.Year.IsEmpty then
    Q.IfAnd('year', Item.Year);
  if not Item.Genre.IsEmpty then
    Q.IfAnd('genreId', [Item.Genre]);
  FrameMoviesGrouped.UpdateList(Q);
end;

procedure TFormMain.CreateHome;

  procedure CreateGenreRow(const Genre, GenreName: string; IsSerial: Boolean);
  begin
    var Frame := TFrameGenreRow.Create(VertScrollBoxHome);
    Frame.Align := TAlignLayout.Top;
    Frame.Zona := Zona;
    Frame.Genre := Genre;
    Frame.IsSerial := IsSerial;
    Frame.Year := '';
    Frame.Margins.Rect := TRectF.Create(16, 16, 16, 16);
    Frame.OnItemClick := FOnViewMovie;
    Frame.OnGroupClick := FOnGroupClick;
    VertScrollBoxHome.AddObject(Frame);
    Frame.TitleOpen := GenreName;
  end;

begin
  CreateGenreRow('6', 'Комедии', False);
  CreateGenreRow('7', 'Мелодрамы', False);
  CreateGenreRow('14', 'Мультфильмы', False);
  CreateGenreRow('10', 'Приключения', False);
  CreateGenreRow('11', 'Для всей семьи', False);
  CreateGenreRow('1', 'Ужасы', False);
  CreateGenreRow('2', 'Фантастика', False);
  CreateGenreRow('4', 'Триллеры', False);
  CreateGenreRow('', 'Сериалы', True);
end;

procedure TFormMain.HorzScrollBoxGenreViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  ButtonScrollFilterLeft.Enabled := NewViewportPosition.X <> 0;
  ButtonScrollFilterRight.Enabled := NewViewportPosition.X + HorzScrollBoxGenre.Width < HorzScrollBoxGenre.ContentBounds.Width;
end;

procedure TFormMain.HorzScrollBoxPagesViewportPositionChange(Sender: TObject; const OldViewportPosition, NewViewportPosition: TPointF; const ContentSizeChanged: Boolean);
begin
  ButtonPagesLeft.Enabled := NewViewportPosition.X <> 0;
  ButtonPagesRight.Enabled := NewViewportPosition.X + HorzScrollBoxPages.Width < HorzScrollBoxPages.ContentBounds.Width;
end;

procedure TFormMain.UpdatePaging(TotalCount: Integer);
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

procedure TFormMain.ReloadAll(Clear: Boolean);
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

  TaskRun(VertScrollBoxItems,
    procedure(Holder: IComponentHolder)
    begin
      var Q: TZonaQueryBuilder;
      Q.IfNot('abuse', 'zona');
      //Q.IfNot('country_id', '2');
      if FHideAdult then
        Q.IfAnd('adult', False);
      Q.IfAnd('tor_count', 1, 2147483647);
      Q.IfAnd('indexed', 1, 8);
      Q.IfAnd('serial', FIsSerial);
      if not FYear.IsEmpty then
        Q.IfAnd('year', FYear);
      if not FGenre.IsEmpty then
        Q.IfAnd('genreId', [FGenre]);
      var Movies := Zona.GetMovies(Q.Query, FOffset, FCount, 'popularity desc, seeds desc, id desc');
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
              LI.OnClick := FOnViewMovie;
              LI.Fill(Item);
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

procedure TFormMain.SearchEditButtonSearchClick(Sender: TObject);
begin
  if EditSearch.Text.IsEmpty then
    Exit;
  OpenSearch(EditSearch.Text);
end;

procedure TFormMain.SkAnimatedImage1Click(Sender: TObject);
begin
  SkAnimatedImage1.Animation.Start;
end;

procedure TFormMain.TimerSearchTimer(Sender: TObject);
begin
  TimerSearch.Enabled := False;
  OpenSearch(EditSearch.Text);
end;

initialization
  //ReportMemoryLeaksOnShutdown := True;

end.

