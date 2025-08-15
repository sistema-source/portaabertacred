unit dao_contrato;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ZDataset, dao_pai,fpjson, jsonparser, vo_contrato;

type

  { TDaoContrato }

  TDaoContrato = class(TDaoPai)
    QryContrato: TZQuery;
    QryCliente: TZQuery;
  private
    function ObterInstrucao: string;
  public
    function ObterContratoByCnpjCpf(pCnpjCpf: string; pToKen: integer): TJsonArray;
    function GravarContrato(pVo: TVoContrato): boolean;

  end;

var
  DaoContrato: TDaoContrato;

implementation

{$R *.lfm}

{ TDaoContrato }

function TDaoContrato.ObterInstrucao: string;
begin

  Result := 'SELECT ' + '  C.ID, ' + '  C.ID_CLIENTE, ' + '  C.TOKEN, C.CNPJ_CPF, C.NUM_CONTRATO,' +
    '  C.DT_CONTRATO, ' + '  C.VLR_CONTRATADO, ' + '  C.PER_JUROS, ' +
    '  C.VLR_MENSAL, ' + '  C.DT_ULTIMO_PAGTO, ' + '  C.VLR_ULTIMO_PAGTO, ' +
    '  C.IDEUSUINS, ' + '  C.IDEUSUALT, ' + '  C.IDEUSUEXC, ' + '  C.DTAHRAINS, ' +
    '  C.DTAHRAULTALT, ' + '  C.DTAHRAEXC, ' + '  C.APAGADO, ' + '  C.VLR_JUROS_PAGOS, ' +
    '  C.VLR_CAPITAL_PAGO, ' + '  C.ATIVO, ' + '  C.DT_PROXIMO_PAGTO ' + '  FROM CONTRATO C';

end;

function TDaoContrato.ObterContratoByCnpjCpf(pCnpjCpf: string;
  pToKen: integer): TJsonArray;
var
  s: string;
begin



  QryContrato.Close;
  QryContrato.Connection := ModelConexaoFirebird.Conexao;

  s := ObterInstrucao + ' WHERE C.CNPJ_CPF = :pCnpjCpf  ' + ' AND C.TOKEN = :pToken';
  QryContrato.SQL.Text := s;
  QryContrato.ParamByName('pCnpjCpf').AsString := pCnpjCpf;
  QryContrato.ParamByName('pToken').AsInteger := pToken;
  QryContrato.Open;

  Result := ZQueryToJSONArray(QryContrato);


end;

function TDaoContrato.GravarContrato(pVo: TVoContrato): boolean;
var
  s: string;
begin
  Result := False;
  try

    QryCliente.Close;
    QryCliente.Connection := ModelConexaoFirebird.Conexao;
    s := ' SELECT C.ID FROM CLIENTES C  WHERE C.CNPJ_CPF = :pCnpjCpf  ' + ' AND C.TOKEN = :pToken';
    QryCliente.SQL.Text := s;
    QryCliente.ParamByName('pCnpjCpf').AsString := pVo.CNPJ_CPF;
    QryCliente.ParamByName('pToken').AsInteger := pVo.TOKEN;
    QryCliente.Open;

    pVo.ID_CLIENTE := QryCliente.FieldByName('ID').AsString;

    QryContrato.Close;
    QryContrato.Connection := QryCliente.Connection

    s := ObterInstrucao + ' WHERE C.CNPJ_CPF = :pCnpjCpf '
    + ' AND C.TOKEN = :pToken';

    QryContrato.SQL.Text := s;
    QryContrato.ParamByName('pCnpjCpf').AsString := pVo.CNPJ_CPF;
    QryContrato.ParamByName('pToken').AsInteger := pVo.TOKEN;

    QryContrato.Open;

    if QryContrato.IsEmpty then
    begin
      QryContrato.Append;
      QryContrato.FieldByName('CNPJ_CPF').AsString := pVo.CNPJ_CPF;
      QryContrato.FieldByName('ID').AsString := 'id';
      QryContrato.FieldByName('TOKEN').AsInteger := pVo.Token;

    end
    else
    begin
      QryContrato.Edit;
    end;
    QryContrato.FieldByName('ID_CLIENTE').AsString := pVo.ID_CLIENTE;
    QryContrato.FieldByName('DT_CONTRATO').AsDateTime := pVo.DT_CONTRATO;
    QryContrato.FieldByName('VLR_CONTRATADO').AsCurrency := pVo.VLR_CONTRATADO;
    QryContrato.FieldByName('PER_JUROS').AsCurrency := pVo.PER_JUROS;
    QryContrato.FieldByName('VLR_MENSAL').AsCurrency := pVo.VLR_MENSAL;
    QryContrato.FieldByName('DT_ULTIMO_PAGTO').AsDateTime := pVo.DT_ULTIMO_PAGTO;
    QryContrato.FieldByName('VLR_ULTIMO_PAGTO').AsCurrency := pVo.VLR_ULTIMO_PAGTO;
    QryContrato.FieldByName('APAGADO').AsInteger := pVo.APAGADO;
    QryContrato.FieldByName('VLR_JUROS_PAGOS').AsCurrency := pVo.VLR_JUROS_PAGOS;
    QryContrato.FieldByName('VLR_CAPITAL_PAGO').AsCurrency := pVo.VLR_CAPITAL_PAGO;
    QryContrato.FieldByName('ATIVO').AsInteger := pVo.ATIVO;
    QryContrato.FieldByName('DT_PROXIMO_PAGTO').AsDateTime := pVo.DT_PROXIMO_PAGTO;
    QryContrato.FieldByName('NUM_CONTRATO').AsString := pVo.NUM_CONTRATO;
    QryContrato.Post;
    Result := True;
  except
    on e: Exception do
    begin
      raise Exception.Create('Metodo: [dao_contrato.TDaoCliente.GravarContrato].' +
        sLineBreak + 'Mensagem: ' + e.message);
    end;
  end;

end;

end.
