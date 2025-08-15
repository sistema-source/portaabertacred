unit rotas_cliente_porta_aberta_cred;


{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Jhonson, fpjson, jsonparser, dao_usuario,
  dao_cliente, vo_empresa, vo_cliente;

procedure Registry;

implementation

procedure GetByCnpjCpf(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  DaoCliente: TDaoCliente;
  LCnpjCpf, LToken: string;
begin
  DaoCliente := TDaoCliente.Create(nil);
  LCnpjCpf := Req.Params['cnpj_cpf'];
  LToken := Req.Params['token'];

  JSONArray := DaoCliente.ObterClienteByCnpjCpf(LCnpjCpf, StrToIntDef(LToken,0));
  try
    Res.Send<TJSONArray>(JSONArray).status(200);
  finally
    DaoCliente.Free;
  end;
end;


procedure GetByToken: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  DaoCliente: TDaoCliente;
  LToken: string;
begin
  DaoCliente := TDaoCliente.Create(nil);
  LToken := Req.Params['token'];

  JSONArray := DaoCliente.ObterClienteByToken(StrToIntDef(LToken,0));
  try
    Res.Send<TJSONArray>(JSONArray).status(200);
  finally
    DaoCliente.Free;
  end;
end;


procedure PostCliente(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  DaoCliente: TDaoCliente;
  erro: string;
  LCnpjCpf: string;
  vo: TVoCliente;
  s: string;
begin
  LCnpjCpf := '';

  LCnpjCpf := Req.Params['cnpj_cpf'];

  erro := '';
  DaoCliente := TDaoCliente.Create(nil);
  vo := TVoCliente.Create;
  s := REq.Body;
  vo.LoadFromJsonString(s);

  try
    try
      if vo.Nome = '' then
        raise Exception.Create('O campo NOME não pode ser vazio');

      if vo.CNPJ_CPF = '' then
        raise Exception.Create('O campo CNPJ_CPF não pode ser vazio');

      DaoCliente.GravarCliente(vo);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar gravar a Cliente [' + LCnpjCpf +
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
    DaoCliente.Free;
    Vo.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/portaabertacred/v1/cliente/:token/:cnpj_cpf', GetByCnpjCpf);
  THorse.Get('/portaabertacred/v1/cliente/:token', GetByToken);
  THorse.Post('/portaabertacred/v1/cliente', PostCliente);
  THorse.Post('/portaabertacred/v1/cliente/:cnpj_cpf', PostCliente);

end;

end.
end;
