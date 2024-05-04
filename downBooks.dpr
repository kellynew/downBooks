program downBooks;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '萱乐电子教科书下载';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
