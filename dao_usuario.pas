unit dao_usuario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ZDataset,
  dao_pai, fpjson, jsonparser, model_conexao_firebird, vo_usuario;

type

  { TDaoUsuario }

  TDaoUsuario = class(TDaoPai)
    QryUsuario: TZQuery;
    QryUsuarioEmpresa: TZQuery;
  private

    function ObterInstrucao: string;
  public
    function ObterUsuarioByEmail(pToken: integer; pEmail, pSenha: string): TJsonArray;
    function GravarUsuario(pVo: TVoUsuario): boolean;
  end;

var
  DaoUsuario: TDaoUsuario;

implementation

{$R *.lfm}

{ TDaoUsuario }

function TDaoUsuario.ObterInstrucao: string;
begin
  Result :=
    ' SELECT U.id, u.email, u.senha, u.ideusuins, u.ideusualt, u.ideusuexc, u.dtahrains, u.dtahraultalt, u.dtahraexc, u.ativo, u.apagado, u.nome, u.telefone FROM USUARIO U';
end;

function TDaoUsuario.ObterUsuarioByEmail(pToken: integer;
  pEmail, pSenha: string): TJsonArray;
var
  s: string;
begin

  s :=
    'SELECT U.id, u.email, u.senha, u.ideusuins, u.ideusualt, u.ideusuexc, u.dtahrains, u.dtahraultalt, u.dtahraexc, u.ativo, u.apagado, u.nome, u.telefone, ' + ' ut.token, ut.administrador FROM USUARIO U ' + ' left join usuario_token UT on ut.id_usuario = u.id' + ' WHERE 1 = 1 ';
  if pToken > 0 then
    s := s + ' AND U.TOKEN = :pToken';

  if pEmail <> '' then
    s := s + ' AND U.EMAIL = :pEmail';


  if pSenha <> '' then
    s := s + ' AND U.SENHA = :pSenha';


  QryUsuario.Close;

  QryUsuario.Connection := ModelConexaoFirebird.Conexao;

  QryUsuario.SQL.Text := s;

  if QryUsuario.Params.FindParam('pToken') <> nil then
    QryUsuario.ParamByName('pToken').AsInteger := pToken;

  if QryUsuario.Params.FindParam('pEmail') <> nil then
    QryUsuario.ParamByName('pEmail').AsString := pEmail;

  if QryUsuario.Params.FindParam('pSenha') <> nil then
    QryUsuario.ParamByName('pSenha').AsString := pSenha;

  QryUsuario.Open;

  Result := ZQueryToJSONArray(QryUsuario);

end;

function TDaoUsuario.GravarUsuario(pVo: TVoUsuario): boolean;
var
  s: string;
  LOperador: string;
begin
  Result := False;
  try

    QryUsuario.Connection := ModelConexaoFirebird.Conexao;
    QryUsuarioEmpresa.Connection := QryUsuario.Connection;
    LOperador := '';

    QryUsuario.Close;
    s := ObterInstrucao + ' WHERE U.EMAIL = :pEmail ';
    QryUsuario.SQL.Text := s;
    QryUsuario.ParamByName('pEmail').AsString := pVo.EMAIL;
    QryUsuario.Open;

    if QryUsuario.IsEmpty then
    begin
      QryUsuario.Append;
      QryUsuario.FieldByName('EMAIL').AsString := pVo.EMAIL;
      QryUsuario.FieldByName('ID').AsString := 'id';

    end
    else
    begin
      QryUsuario.Edit;
    end;
    QryUsuario.FieldByName('NOME').AsString := pVo.Nome;
    QryUsuario.FieldByName('APAGADO').AsInteger := pVo.Apagado;
    QryUsuario.FieldByName('ATIVO').AsInteger := pVo.Ativo;
    QryUsuario.FieldByName('SENHA').AsString := pVo.Senha;
    QryUsuario.FieldByName('TELEFONE').AsString := pVo.TELEFONE;
    QryUsuario.Post;
    Result := True;
  except
    on e: Exception do
    begin
      raise Exception.Create('Metodo: [dao_empresa.TDaoEmpresa.GravarUsuario].' +
        sLineBreak + 'Mensagem: ' + e.message);
    end;
  end;

  // Gravar o Token x Usuario

  QryUsuario.Close;
  s := ObterInstrucao + ' WHERE U.EMAIL = :pEmail ';
  QryUsuario.SQL.Text := s;
  QryUsuario.ParamByName('pEmail').AsString := pVo.EMAIL;
  QryUsuario.Open;

  s := ' SELECT UT.ID, UT.ID_USUARIO, UT.TOKEN, UT.ADMINISTRADOR, UT.APAGADO, UT.ATIVO FROM USUARIO_TOKEN UT' + ' WHERE UT.ID_USUARIO = :pIdUsuario ' + ' AND   UT.TOKEN = :pToken';


  QryUsuarioEmpresa.Close;
  QryUsuarioEmpresa.SQL.Text := s;
  QryUsuarioEmpresa.ParamByName('pIdUsuario').AsString :=  QryUsuario.FieldByName('ID').AsString;
  QryUsuarioEmpresa.ParamByName('pToken').AsInteger := pVo.TOKEN;
  QryUsuarioEmpresa.Open;

  if QryUsuarioEmpresa.IsEmpty then
  begin
    QryUsuarioEmpresa.Append;
    QryUsuarioEmpresa.FieldByName('ID').AsString := 'id';

    QryUsuarioEmpresa.FieldByName('ID_USUARIO').AsString :=
      QryUsuario.FieldByName('ID').AsString;
    QryUsuarioEmpresa.FieldByName('TOKEN').AsInteger := pVo.TOKEN;

  end;
  QryUsuarioEmpresa.FieldByName('ADMINISTRADOR').AsInteger := pVo.ADMINISTRADOR;
  QryUsuarioEmpresa.FieldByName('APAGADO').AsInteger := pVo.Apagado;
  QryUsuarioEmpresa.FieldByName('ATIVO').AsInteger := pVo.Ativo;
  QryUsuarioEmpresa.Post;

end;

end.
