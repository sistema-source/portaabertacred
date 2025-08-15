unit rotas_usuario_porta_aberta_cred;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Jhonson, fpjson, jsonparser, dao_usuario,
  vo_usuario;

procedure Registry;

implementation

procedure GetUsuarioByEmail(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  Daousuario: TDaousuario;
  LToken: string;
  LEmail: string;
  LSenha: string;
begin
  Daousuario := TDaousuario.Create(nil);
  LToken := Req.Params['token'];
  LEmail := Req.Params['email'];
  LSenha := '';

  JSONArray := DaoUsuario.ObterUsuarioByEmail(StrToIntDef(LToken,0), LEmail, LSenha);
  try
    Res.Send<TJSONArray>(JSONArray).status(200);
  finally
    Daousuario.Free;
  end;
end;

procedure PostUsuario(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  Daousuario: TDaousuario;
  erro: string;
  vo: TVousuario;
  s: string;
begin
  erro := '';
  Daousuario := TDaousuario.Create(nil);
  vo := TVoUsuario.Create;
  s := Req.Body;
  vo.LoadFromJsonString(s);
  try
    try
      Daousuario.Gravarusuario(vo);
    except
      on e: Exception do
      begin
        erro := 'Erro ao tentar gravar a usuario [' + vo.EMAIL +
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
    Daousuario.Free;
    Vo.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/portaabertacred/v1/usuario/:email', GetUsuarioByEmail);
  THorse.Post('/portaabertacred/v1/usuario', PostUsuario);
  THorse.Post('/portaabertacred/v1/usuario/:token/:email', PostUsuario);
end;

end.
end;
