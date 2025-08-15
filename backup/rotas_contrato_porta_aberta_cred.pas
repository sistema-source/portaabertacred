unit rotas_contrato_porta_aberta_cred;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Jhonson, fpjson, jsonparser, dao_usuario,
  dao_Contrato, vo_empresa, vo_Contrato;

procedure Registry;

implementation

procedure GetByCnpjCpf(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  DaoContrato: TDaoContrato;
  LCnpjCpf, LToken: string;
begin
  DaoContrato := TDaoContrato.Create(nil);
  LCnpjCpf := Req.Params['cnpj_cpf'];
  LToken := Req.Params['token'];

  JSONArray := DaoContrato.ObterContratoByCnpjCpf(LCnpjCpf, StrToIntDef(LToken, 0));
  try
    Res.Send<TJSONArray>(JSONArray).status(200);
  finally
    DaoContrato.Free;
  end;
end;

procedure PostContrato(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  DaoContrato: TDaoContrato;
  erro: string;
  LCnpjCpf, LToken: string;
  vo: TVoContrato;
  s: string;
begin
  LCnpjCpf := '';

  LCnpjCpf := Req.Params['cnpj_cpf'];
  LToken := Req.Params['token'];


  erro := '';
  DaoContrato := TDaoContrato.Create(nil);
  vo := TVoContrato.Create;
  s := REq.Body;
  vo.LoadFromJsonString(s);

  try
    try
      if vo.CNPJ_CPF = '' then
        raise Exception.Create('O campo CNPJ_CPF não pode ser vazio');

      if vo.ID_CLIENTE = '' then
        raise Exception.Create('O campo ID_CLIENTE não pode ser vazio');

      DaoContrato.GravarContrato(vo);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar gravar a Contrato [' + LCnpjCpf +
          ']. Mensagem do banco de dados ' + e.Message;
      end;
    end;
    if erro <> '' then
    begin
      res.Status(400);
      res.Send(erro);
    end
    else
    begin
      res.Status(200);
    end;
  finally
    DaoContrato.Free;
    Vo.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/portaabertacred/v1/contrato/:token/:cnpj_cpf', GetByCnpjCpf);
  THorse.Post('/portaabertacred/v1/contrato', PostContrato);
  THorse.Post('/portaabertacred/v1/contrato/:token/:cnpj_cpf', PostContrato);

end;

end.
end;
