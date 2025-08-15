unit dao_cliente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ZDataset,
  fpjson, jsonparser, dao_pai, vo_cliente;

type

  { TDaoCliente }

  TDaoCliente = class(TDaoPai)
    QryCliente: TZQuery;
  private

    function ObterInstrucao: string;
  public
    function ObterClienteByCnpjCpf(pCnpjCpf: string; pToKen: integer): TJsonArray;
    function ObterClienteByToken(pToKen: integer): TJsonArray;
    function GravarCliente(pVo: TVoCliente): boolean;

  end;

var
  DaoCliente: TDaoCliente;

implementation

{$R *.lfm}

{ TDaoCliente }

function TDaoCliente.ObterInstrucao: string;
begin
  Result := 'SELECT    ' + '  C.ID,           ' + '  C.CNPJ_CPF,     ' +
    '  C.NOME,         ' + '  C.FONE1,        ' + '  C.FONE2,        ' +
    '  C.FONE3,        ' + '  C.EMAIL,        ' + '  C.IDEUSUINS,    ' +
    '  C.IDEUSUALT,    ' + '  C.IDEUSUEXC,    ' + '  C.DTAHRAINS,    ' +
    '  C.DTAHRAULTALT, ' + '  C.DTAHRAEXC,    ' + '  C.APAGADO,      ' +
    '  C.ATIVO,      ' + '  C.ENDERECO,     ' + '  C.NUMERO,       ' +
    '  C.BAIRRO,       ' + '  C.CIDADE,       ' + '  C.UF,           ' +
    '  C.TOKEN ' + '  FROM CLIENTES C';
end;

function TDaoCliente.ObterClienteByCnpjCpf(pCnpjCpf: string; pToKen: integer): TJsonArray;
var
  s: string;
begin
  QryCliente.Close;

  QryCliente.Connection := ModelConexaoFirebird.Conexao;

  s := ObterInstrucao + ' WHERE C.CNPJ_CPF = :pCnpjCpf  ' + ' AND C.TOKEN = :pToken';
  QryCliente.SQL.Text := s;
  QryCliente.ParamByName('pCnpjCpf').AsString := pCnpjCpf;
  QryCliente.ParamByName('pToken').AsInteger := pToken;
  QryCliente.Open;

  Result := ZQueryToJSONArray(QryCliente);

end;

function TDaoCliente.ObterClienteByToken(pToKen: integer): TJsonArray;
var
  s: string;
begin
  QryCliente.Close;

  QryCliente.Connection := ModelConexaoFirebird.Conexao;

  s := ObterInstrucao + ' WHERE C.TOKEN = :pToken';
  QryCliente.SQL.Text := s;
  QryCliente.ParamByName('pCnpjCpf').AsString := pCnpjCpf;
  QryCliente.ParamByName('pToken').AsInteger := pToken;
  QryCliente.Open;

  Result := ZQueryToJSONArray(QryCliente);

end;

function TDaoCliente.GravarCliente(pVo: TVoCliente): boolean;
var
  s: string;
begin
  Result := False;
  try
    QryCliente.Close;

    QryCliente.Connection := ModelConexaoFirebird.Conexao;

    s := ObterInstrucao + ' WHERE C.CNPJ_CPF = :pCnpjCpf '
    + ' AND C.TOKEN = :pToken';
    QryCliente.SQL.Text := s;
    QryCliente.ParamByName('pCnpjCpf').AsString := pVo.CNPJ_CPF;
    QryCliente.ParamByName('pToken').AsInteger := pVo.TOKEN;
    QryCliente.Open;

    if QryCliente.IsEmpty then
    begin
      QryCliente.Append;
      QryCliente.FieldByName('CNPJ_CPF').AsString := pVo.CNPJ_CPF;
      QryCliente.FieldByName('ID').AsString := 'id';
      QryCliente.FieldByName('TOKEN').AsInteger := pVo.Token;
    end
    else
    begin
      QryCliente.Edit;
    end;    QryCliente.FieldByName('NOME').AsString := pVo.Nome;
    QryCliente.FieldByName('APAGADO').AsInteger := pVo.Apagado;
    QryCliente.FieldByName('ATIVO').AsInteger := pVo.Ativo;
    QryCliente.FieldByName('FONE1').AsString := pVo.FONE1;
    QryCliente.FieldByName('FONE2').AsString := pVo.FONE2;
    QryCliente.FieldByName('FONE3').AsString := pVo.FONE3;
    QryCliente.FieldByName('EMAIL').AsString := pVo.EMAIL;
    QryCliente.FieldByName('IDEUSUINS').AsString := pVo.IdeUsuIns;
    QryCliente.FieldByName('IDEUSUALT').AsString := pVo.IdeUsuAlt;
    QryCliente.FieldByName('IDEUSUEXC').AsString := pVo.IdeUsuExc;
    QryCliente.FieldByName('ENDERECO').AsString := pVo.ENDERECO;
    QryCliente.FieldByName('NUMERO').AsString := pVo.NUMERO;
    QryCliente.FieldByName('BAIRRO').AsString := pVo.BAIRRO;
    QryCliente.FieldByName('CIDADE').AsString := pVo.CIDADE;
    QryCliente.FieldByName('UF').AsString := pVo.UF;
    QryCliente.Post;
    Result := True;
  except
    on e: Exception do
    begin
      raise Exception.Create('Metodo: [dao_Cliente.TDaoCliente.GravarCliente].' +
        sLineBreak + 'Mensagem: ' + e.message);
    end;
  end;

end;

end.
