program ZonaFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  FMX.Types,
  Zona.Main in 'Zona.Main.pas' {FormMain},
  WinUI3.Dialogs in 'DelphiWinUI3\Demo\Utils\WinUI3.Dialogs.pas',
  WinUI3.Form.Dialog in 'DelphiWinUI3\Demo\Utils\WinUI3.Form.Dialog.pas',
  WinUI3.Form in 'DelphiWinUI3\Demo\Utils\WinUI3.Form.pas',
  WinUI3.Frame.Dialog.ColorPicker in 'DelphiWinUI3\Demo\Utils\WinUI3.Frame.Dialog.ColorPicker.pas',
  WinUI3.Frame.Dialog.Input in 'DelphiWinUI3\Demo\Utils\WinUI3.Frame.Dialog.Input.pas',
  WinUI3.Frame.Dialog in 'DelphiWinUI3\Demo\Utils\WinUI3.Frame.Dialog.pas',
  WinUI3.Frame.Dialog.Text in 'DelphiWinUI3\Demo\Utils\WinUI3.Frame.Dialog.Text.pas',
  WinUI3.Frame.Inner.Dialog in 'DelphiWinUI3\Demo\Utils\WinUI3.Frame.Inner.Dialog.pas',
  WinUI3.Frame.Inner.InfoBar in 'DelphiWinUI3\Demo\Utils\WinUI3.Frame.Inner.InfoBar.pas',
  WinUI3.Frame.Inner.InfoBarPanel in 'DelphiWinUI3\Demo\Utils\WinUI3.Frame.Inner.InfoBarPanel.pas',
  WinUI3.Utils in 'DelphiWinUI3\Demo\Utils\WinUI3.Utils.pas',
  FMX.MultiView.Presentations in 'DelphiWinUI3\Demo\Fixes\D12\FMX.MultiView.Presentations.pas',
  FMX.StyledContextMenu in 'DelphiWinUI3\Demo\Fixes\D12\FMX.StyledContextMenu.pas',
  FMX.Calendar.Style in 'DelphiWinUI3\Demo\Fixes\D12\FMX.Calendar.Style.pas',
  FMX.Menus in 'DelphiWinUI3\Demo\Fixes\D12\FMX.Menus.pas',
  HGM.FMX.Image in 'HGM.FMX.Image.pas',
  HGM.ObjectHolder in 'AsyncObjectHolder\HGM.ObjectHolder.pas',
  Zona.Frame.Movie in 'Zona.Frame.Movie.pas' {FrameMovie: TFrame},
  Zona.API.Genre in 'ZonaAPI\Zona.API.Genre.pas',
  Zona.API.Movie in 'ZonaAPI\Zona.API.Movie.pas',
  Zona.API in 'ZonaAPI\Zona.API.pas',
  Zona.API.QBuilder in 'ZonaAPI\Zona.API.QBuilder.pas',
  Zona.API.Response in 'ZonaAPI\Zona.API.Response.pas',
  Zona.API.Base in 'ZonaAPI\Zona.API.Base.pas',
  Zona.API.Country in 'ZonaAPI\Zona.API.Country.pas',
  Zona.Frame.GenreMovies in 'Zona.Frame.GenreMovies.pas' {FrameGenreRow: TFrame},
  Zona.Frame.MovieView in 'Zona.Frame.MovieView.pas' {FrameMovieView: TFrame},
  Zona.Frame.TextItem in 'Zona.Frame.TextItem.pas' {FrameTextItem: TFrame},
  Zona.Frame.Movies in 'Zona.Frame.Movies.pas' {FrameMovies: TFrame},
  FMX.Windows.Hints in 'DelphiWinUI3\FMXWindowsHint\FMX.Windows.Hints.pas',
  Zona.API.Person in 'ZonaAPI\Zona.API.Person.pas',
  Zona.API.Torrent in 'ZonaAPI\Zona.API.Torrent.pas';

{$R *.res}

begin
  {$IFDEF ANDROID}
  GlobalUseSkia := True;
  {$ENDIF}
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
