unit view_principal;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, ExtCtrls, horse, Horse.Jhonson,
  fpjson, jsonparser,
  rotas_usuario_porta_aberta_cred,
  rotas_empresa_porta_aberta_cred,
  rotas_cliente_porta_aberta_cred,
  rotas_contrato_porta_aberta_cred;

type

  { TViewPrincipal }

  TViewPrincipal = class(TForm)
    BtnIniciar: TBitBtn;
    BtnParar: TBitBtn;
    EdtPorta: TEdit;
    Label1: TLabel;
    Timer1: TTimer;
    procedure BtnIniciarClick(Sender: TObject);
    procedure BtnPararClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    procedure Status;
    procedure Start;
    procedure Stop;

  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

procedure DoPing(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
begin
  Res.Send('pong ' + DateTimeToStr(now));
end;

procedure DoPingJson(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LBody: TJSONObject;
  Arrayj: TJsonArray;
begin
  Arrayj := TJsonArray.Create;
  LBody := TJSONObject.Create;
  LBody.Add('none', 'Tone Cezar da');
  LBody.Add('sobrenome', 'Costa');
  ArrayJ.Add(LBody);
  //Res.Send<TJSONObject>(LBody).status(200);
  Res.Send<TJSONArray>(ArrayJ).status(200);
end;

{$R *.lfm}

{ TViewPrincipal }

procedure TViewPrincipal.BtnIniciarClick(Sender: TObject);
begin
  Start;
  Status;
end;

procedure TViewPrincipal.BtnPararClick(Sender: TObject);
begin
  Stop;
  Status;
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin

  THorse.Use(Jhonson);
  rotas_usuario_porta_aberta_cred.Registry;
  rotas_empresa_porta_aberta_cred.Registry;
  rotas_cliente_porta_aberta_cred.Registry;
  rotas_contraliente_porta_aberta_cred.Registry;

  THorse.Get('/ping', DoPing);
  THorse.Get('/ping/json', DoPingJson);

  Timer1.Enabled := True;
end;

procedure TViewPrincipal.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  BtnIniciarClick(Sender);
end;

procedure TViewPrincipal.Status;
begin
  BtnParar.Enabled := THorse.IsRunning;
  BtnIniciar.Enabled := not THorse.IsRunning;
  edtPorta.Enabled := not THorse.IsRunning;
end;

procedure TViewPrincipal.Start;
begin
  // Need to set "HORSE_LCL" compilation directive
  THorse.Listen(StrToInt(edtPorta.Text));

end;

procedure TViewPrincipal.Stop;
begin
  THorse.StopListen;
end;

end.
