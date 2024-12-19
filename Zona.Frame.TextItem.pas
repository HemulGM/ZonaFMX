unit Zona.Frame.TextItem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TFrameTextItem = class(TFrame)
    LayoutValue: TLayout;
    LabelName: TLabel;
    LabelValue: TLabel;
    LayoutName: TLayout;
    procedure LabelValueResize(Sender: TObject);
    procedure FrameResize(Sender: TObject);
  private
    FTitle: string;
    FText: string;
    procedure SetText(const Value: string);
    procedure SetTitle(const Value: string);
    { Private declarations }
  public
    property Title: string read FTitle write SetTitle;
    property Text: string read FText write SetText;
  end;

implementation

uses
  System.Math;

{$R *.fmx}

procedure TFrameTextItem.FrameResize(Sender: TObject);
begin
  if Assigned(ParentControl) then
    ParentControl.RecalcSize;
end;

procedure TFrameTextItem.LabelValueResize(Sender: TObject);
begin
  Height := Max(LabelValue.Height, LabelName.Height);
end;

procedure TFrameTextItem.SetText(const Value: string);
begin
  FText := Value;
  LabelValue.Text := FText;
end;

procedure TFrameTextItem.SetTitle(const Value: string);
begin
  FTitle := Value;
  LabelName.Text := FTitle;
end;

end.

