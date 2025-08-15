unit dao_empresa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ZDataset,
  dao_pai, fpjson, jsonparser, model_conexao_firebird, vo_empresa;

type

  { TDaoEmpresa }

  TDaoEmpresa = class(TDaoPai)
    QryEmpresa: TZQuery;
  private

    function ObterInstrucao: string;
  public
    function ObterEmpresaByCnpjCpf(pCnpjCpf: string): TJsonArray;
    function ObterEmpresaByToken(pToken: string): TJsonArray;

    function GravarEmpresa(pVo: TVoEmpresa): boolean;

  end;

var
  DaoEmpresa: TDaoEmpresa;

implementation

{$R *.lfm}

{ TDaoEmpresa }

function TDaoEmpresa.ObterInstrucao: string;
begin
  Result := 'SELECT E.ID, ' + 'E.CNPJ_CPF, ' + 'E.NOME,      ' +
    'E.TOKEN,     ' + 'E.DTAHRAINS, ' + 'E.DTAHRAULTALT, ' +
    'E.APAGADO,      ' + 'E.ATIVO,        ' + 'E.DT_VALIDADE  ' + 'FROM EMPRESA E ';
end;

function TDaoEmpresa.ObterEmpresaByCnpjCpf(pCnpjCpf: string): TJsonArray;
var
  s: string;
  LOperador: string;
begin
  QryEmpresa.Close;

  QryEmpresa.Connection := ModelConexaoFirebird.Conexao;
  LOperador := ' =  ';

  s := ObterInstrucao + ' WHERE E.CNPJ_CPF = :pCnpjCpf ';
  QryEmpresa.SQL.Text := s;
  QryEmpresa.ParamByName('pCnpjCpf').AsString := pCnpjCpf;
  QryEmpresa.Open;

  Result := ZQueryToJSONArray(QryEmpresa);
end;

function TDaoEmpresa.ObterEmpresaByToken(pToken: string): TJsonArray;
var
  s: string;
  LOperador: string;
begin
  QryEmpresa.Close;

  QryEmpresa.Connection := ModelConexaoFirebird.Conexao;
  LOperador := ' =  ';

  s := ObterInstrucao + ' WHERE E.TOKEN = :pToken ';
  QryEmpresa.SQL.Text := s;
  QryEmpresa.ParamByName('pCnpjCpf').AsString := pCnpjCpf;
  QryEmpresa.Open;

  Result := ZQueryToJSONArray(QryEmpresa);
end;

function TDaoEmpresa.GravarEmpresa(pVo: TVoEmpresa): boolean;
var
  s: string;
  LOperador: string;
begin
  Result := False;
  try
    QryEmpresa.Close;

    QryEmpresa.Connection := ModelConexaoFirebird.Conexao;
    LOperador := ' =  ';

    s := ObterInstrucao + ' WHERE E.CNPJ_CPF = :pCnpjCpf ';
    QryEmpresa.SQL.Text := s;
    QryEmpresa.ParamByName('pCnpjCpf').AsString := pVo.CNPJ_CPF;
    QryEmpresa.Open;

    if QryEmpresa.IsEmpty then
    begin
      QryEmpresa.Append;
      QryEmpresa.FieldByName('CNPJ_CPF').AsString := pVo.CNPJ_CPF;
      QryEmpresa.FieldByName('ID').AsString := '';

    end
    else
    begin
      QryEmpresa.Edit;
    end;
    QryEmpresa.FieldByName('NOME').AsString := pVo.Nome;
    QryEmpresa.FieldByName('TOKEN').AsInteger := pVo.Token;
    QryEmpresa.FieldByName('APAGADO').AsInteger := pVo.Apagado;
    QryEmpresa.FieldByName('ATIVO').AsInteger := pVo.Ativo;
    QryEmpresa.FieldByName('DT_VALIDADE').AsDateTime := pVo.Dt_Validade;
    QryEmpresa.Post;
    Result := True;
  except
    on e: Exception do
    begin
      raise Exception.Create('Metodo: [dao_empresa.TDaoEmpresa.GravarEmpresa].' +
        sLineBreak + 'Mensagem: ' + e.message);
    end;
  end;
end;

end.
