unit vo_empresa;

interface

uses
  SysUtils, DateUtils, fpjson, jsonparser;

type
  TVoEmpresa = class
  public
    // Propriedades que mapeiam as colunas da tabela EMPRESA
    ID: string;
    CNPJ_CPF: string;
    Nome: string;
    Token: integer;
    DtaHraIns: TDateTime;
    DtaHraUltAlt: TDateTime;
    Apagado: integer;
    Ativo: integer;
    Dt_Validade: TDateTime;
    IdeUsuIns: string;
    IdeUsuAlt: string;
    IdeUsuExc: string;

    // Construtor para inicializar o objeto
    constructor Create;

    // Método para limpar ou redefinir os valores do objeto
    procedure Clear;

    // Novo método para carregar dados de uma string JSON
    function LoadFromJsonString(const AJsonString: string): boolean;

    // Novo método para exportar os dados do objeto para uma string JSON
    function ToJsonString: string;

  end;

implementation

constructor TVoEmpresa.Create;
begin
  Clear;
end;

procedure TVoEmpresa.Clear;
begin
  ID := '';
  CNPJ_CPF := '';
  Nome := '';
  Token := 0;
  DtaHraIns := 0;
  DtaHraUltAlt := 0;
  Apagado := 0;
  Ativo := 0;
  Dt_Validade := 0;
  IdeUsuIns := '';
  IdeUsuAlt := '';
  IdeUsuExc := '';
end;

function TVoEmpresa.LoadFromJsonString(const AJsonString: string): boolean;
var
  JsonData: TJSONData;
  JsonObject: TJSONObject;
  DateStr: string;
  JsonParser: TJSONParser;
begin
  Result := False; // Assume falha por padrão

  JsonParser := nil;
  // Boa prática: inicializa para garantir que seja nil em caso de exceção
  try
    try // Bloco TRY principal
      JsonParser := TJSONParser.Create(AJsonString); // Cria o parser com a string JSON
      JsonData := JsonParser.Parse; // Analisa a string JSON e obtém o objeto JSONData

      // Se o JSON foi analisado com sucesso e é um objeto JSON
      if JsonData is TJSONObject then
      begin
        JsonObject := TJSONObject(JsonData);

        // Mapeamento dos campos JSON para as propriedades do VO
        ID := JsonObject.Get('ID', '');
        CNPJ_CPF := JsonObject.Get('CNPJ_CPF', '');
        Nome := JsonObject.Get('NOME', '');
        Token := JsonObject.Get('TOKEN', 0);

        // Para datas/horas, lemos como string e convertemos para TDateTime
        DateStr := JsonObject.Get('DTAHRAINS', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DtaHraIns);

        DateStr := JsonObject.Get('DTAHRAULTALT', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DtaHraUltAlt);

        Apagado := JsonObject.Get('APAGADO', 0);
        Ativo := JsonObject.Get('ATIVO', 0);

        DateStr := JsonObject.Get('DT_VALIDADE', '');
        if DateStr <> '' then
          TryStrToDate(DateStr, Dt_Validade);

        IdeUsuIns := JsonObject.Get('IDEUSUINS', '');
        IdeUsuAlt := JsonObject.Get('IDEUSUALT', '');
        IdeUsuExc := JsonObject.Get('IDEUSUEXC', '');

        Result := True; // Sucesso no mapeamento
      end;
    except // Bloco EXCEPT
      on E: Exception do
      begin
        // Opcional: registrar o erro para depuração
        // ShowMessage('Erro ao carregar JSON: ' + E.Message);
        Result := False; // Garante que o resultado seja falso em caso de erro
      end;
    end; // <--- ADICIONEI ESTE 'END;' AQUI. ELE FECHA O BLOCO EXCEPT.
    // Agora a estrutura é: TRY ... EXCEPT ... END; FINALLY ... END;
  finally // Bloco FINALLY
    if Assigned(JsonParser) then // Garante que o parser seja liberado
      JsonParser.Free;
  end; // Fim do bloco try...finally

end;

function TVoEmpresa.ToJsonString: string;
var
  JsonObject: TJSONObject;
begin
  JsonObject := TJSONObject.Create;
  try
    // Mapeamento das propriedades do VO para campos JSON
    JsonObject.Add('ID', ID);
    JsonObject.Add('CNPJ_CPF', CNPJ_CPF);
    JsonObject.Add('NOME', Nome);
    JsonObject.Add('TOKEN', Token);

    // Para datas/horas, convertemos para string no formato ISO 8601
    // Adicionando um tratamento para TDateTime = 0 para não formatar datas inválidas
    if DtaHraIns <> 0 then
      JsonObject.Add('DTAHRAINS', FormatDateTime('yyyy-mm-dd hh:nn:ss', DtaHraIns))
    else
      JsonObject.Add('DTAHRAINS', TJSONNull.Create); // Adiciona null se a data for 0

    if DtaHraUltAlt <> 0 then
      JsonObject.Add('DTAHRAULTALT', FormatDateTime('yyyy-mm-dd hh:nn:ss', DtaHraUltAlt))
    else
      JsonObject.Add('DTAHRAULTALT', TJSONNull.Create);

    JsonObject.Add('APAGADO', Apagado);
    JsonObject.Add('ATIVO', Ativo);

    if Dt_Validade <> 0 then
      JsonObject.Add('DT_VALIDADE', FormatDateTime('yyyy-mm-dd', Dt_Validade))
    else
      JsonObject.Add('DT_VALIDADE', TJSONNull.Create);

    JsonObject.Add('IDEUSUINS', IdeUsuIns);
    JsonObject.Add('IDEUSUALT', IdeUsuAlt);
    JsonObject.Add('IDEUSUEXC', IdeUsuExc);

    Result := JsonObject.AsJSON; // Converte o objeto JSON para string
  finally
    JsonObject.Free; // Libera a memória do objeto JSON
  end;
end;

end.
