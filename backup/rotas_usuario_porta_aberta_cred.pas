unit rotas_usuario_porta_aberta_cred;

{$mode Delphi}{$H+}

interface

uses
  Classes, SysUtils, Horse, Horse.Jhonson, fpjson, jsonparser, dao_usuario;

procedure Registry;

implementation

procedure GetUsuarioByNome(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  DaoUsuario: TDaoUsuario;
  LEmail: string;
begin
  DaoUsuario := TDaoUsuario.Create(nil);
  LEmail := Req.Params['email'];
  JSONArray := DaoUsuario.ObterRegistroByEmail(LEmail);
  try
    Res.Send<TJSONArray>(JSONArray).status(200);
  finally
    DaoUsuario.Free;
  end;
end;

procedure PostUsuario(Req: THorseRequest; Res: THorseResponse; Next: TNextProc);
var
  LJsonObj: TJSONObject;
  I: integer;
  LId: string;
  LDao: TDaoUsuario;
  Status : Integer;
  LRetorno : String;
begin
  LJsonObj := TJSONObject(GetJSON(Req.Body));
{  LDao := TDaoUsuario.Create(nil);
  try
    Try
      LRetorno := LDao.GravarUsuario(LJsonObj, Status);
    Except
      on e : exception
    end;


  finally
    LDao.Free;
  end;   }

end;

procedure Registry;
begin
  THorse.Get('/portaabertacred/v1/usuario/:nome_usuario', GetUsuarioByNome);
  THorse.Post('/portaabertacred/v1/usuario', PostUsuario);

end;

end.
end;
