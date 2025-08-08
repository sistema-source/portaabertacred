unit rotas_empresa_porta_aberta_cred;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Jhonson, fpjson, jsonparser, dao_usuario,
  dao_empresa, vo_empresa;

procedure Registry;

implementation

procedure GetByCnpjCpf(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  DaoEmpresa: TDaoEmpresa;
  LCnpjCpf: string;
begin
  DaoEmpresa := TDaoEmpresa.Create(nil);
  LCnpjCpf := Req.Params['cnpj_cpf'];
  JSONArray := DaoEmpresa.ObterEmpresaByCnpjCpf(LCnpjCpf);
  try
    Res.Send<TJSONArray>(JSONArray).status(200);
  finally
    DaoEmpresa.Free;
  end;
end;

procedure PostEmpresa(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  DaoEmpresa: TDaoEmpresa;
  erro: string;
  LCnpjCpf: string;
  vo: TVoEmpresa;
  s: string;
begin
  LCnpjCpf := '';

  LCnpjCpf := Req.Params['cnpj_cpf'];

  erro := '';
  DaoEmpresa := TDaoEmpresa.Create(nil);
  vo := TVoEmpresa.Create;
  s := REq.Body;
  vo.LoadFromJsonString(s);
  try
    Try
    DaoEmpresa.GravarEmpresa(vo);

    Except
          on e : Exception do
          begin
            erro := 'Erro ao tentar gravar a Empresa [' + LCnpjCpf +
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
    DaoEmpresa.Free;
    Vo.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/portaabertacred/v1/empresa/:cnpj_cpf', GetByCnpjCpf);
  THorse.Post('/portaabertacred/v1/empresa', PostEmpresa);
  THorse.Post('/portaabertacred/v1/empresa/:cnpj_cpf', PostEmpresa);

end;

end.
end;
