unit vo_cliente;

interface

uses
  SysUtils, DateUtils, fpjson, jsonparser;

type
  TVoClientes = class
  public
    // Propriedades que mapeiam as colunas da tabela CLIENTES
    ID: string;
    CNPJ_CPF: string;
    NOME: string;
    FONE1: string;
    FONE2: string;
    FONE3: string;
    EMAIL: string;
    IdeUsuIns: string;
    IdeUsuAlt: string;
    IdeUsuExc: string;
    DtaHraIns: TDateTime;
    DtaHraUltAlt: TDateTime;
    DtaHraExc: TDateTime;
    Apagado: integer;
    Ativo: integer;
    ENDERECO: string;
    NUMERO: string;
    BAIRRO: string;
    CIDADE: string;
    UF: string;
    TOKEN: integer;

    // Construtor para inicializar o objeto
    constructor Create;

    // Método para limpar ou redefinir os valores do objeto
    procedure Clear;

    // Método para carregar dados de uma string JSON
    function LoadFromJsonString(const AJsonString: string): boolean;

    // Método para exportar os dados do objeto para uma string JSON
    function ToJsonString: string;
  end;

implementation

constructor TVoClientes.Create;
begin
  Clear; // Chama o método Clear para inicializar todas as propriedades
end;

procedure TVoClientes.Clear;
begin
  ID := '';
  CNPJ_CPF := '';
  NOME := '';
  FONE1 := '';
  FONE2 := '';
  FONE3 := '';
  EMAIL := '';
  IdeUsuIns := '';
  IdeUsuAlt := '';
  IdeUsuExc := '';
  DtaHraIns := 0; // 0 representa uma TDateTime vazia
  DtaHraUltAlt := 0;
  DtaHraExc := 0;
  Apagado := 0;
  Ativo := 0;
  ENDERECO := '';
  NUMERO := '';
  BAIRRO := '';
  CIDADE := '';
  UF := '';
  TOKEN := 0;
end;

function TVoClientes.LoadFromJsonString(const AJsonString: string): boolean;
var
  JsonData: TJSONData;
  JsonObject: TJSONObject;
  DateStr: string;
  JsonParser: TJSONParser;
begin
  Result := False; // Assume falha por padrão

  JsonParser := nil; // Inicializa o parser como nil
  try
    try // Bloco principal para capturar exceções durante o parsing
      JsonParser := TJSONParser.Create(AJsonString); // Cria o parser com a string JSON
      JsonData := JsonParser.Parse; // Analisa a string JSON e obtém o objeto JSONData

      // Se o JSON foi analisado com sucesso e é um objeto JSON
      if JsonData is TJSONObject then
      begin
        JsonObject := TJSONObject(JsonData);

        // Mapeamento dos campos JSON para as propriedades do VO
        ID := JsonObject.Get('ID', '');
        CNPJ_CPF := JsonObject.Get('CNPJ_CPF', '');
        NOME := JsonObject.Get('NOME', '');
        FONE1 := JsonObject.Get('FONE1', '');
        FONE2 := JsonObject.Get('FONE2', '');
        FONE3 := JsonObject.Get('FONE3', '');
        EMAIL := JsonObject.Get('EMAIL', '');

        IdeUsuIns := JsonObject.Get('IDEUSUINS', '');
        IdeUsuAlt := JsonObject.Get('IDEUSUALT', '');
        IdeUsuExc := JsonObject.Get('IDEUSUEXC', '');

        // Para datas/horas, lemos como string e convertemos para TDateTime
        DateStr := JsonObject.Get('DTAHRAINS', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DtaHraIns);

        DateStr := JsonObject.Get('DTAHRAULTALT', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DtaHraUltAlt);

        DateStr := JsonObject.Get('DTAHRAEXC', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DtaHraExc);

        Apagado := JsonObject.Get('APAGADO', 0);
        Ativo := JsonObject.Get('ATIVO', 0);

        ENDERECO := JsonObject.Get('ENDERECO', '');
        NUMERO := JsonObject.Get('NUMERO', '');
        BAIRRO := JsonObject.Get('BAIRRO', '');
        CIDADE := JsonObject.Get('CIDADE', '');
        UF := JsonObject.Get('UF', '');
        TOKEN := JsonObject.Get('TOKEN', 0);

        Result := True; // Sucesso no mapeamento
      end;
    except // Captura qualquer exceção que ocorra durante o processo
      on E: Exception do
      begin
        // Opcional: Aqui você pode adicionar um log do erro para depuração
        // Ex: OutputDebugString(PChar('Erro ao carregar JSON para TVoClientes: ' + E.Message));
        Result := False; // Garante que o resultado seja falso em caso de erro
      end;
    end;
  finally
    // Garante que o objeto JsonParser seja liberado, mesmo que ocorra uma exceção
    if Assigned(JsonParser) then
      JsonParser.Free;
  end;
end;

function TVoClientes.ToJsonString: string;
var
  JsonObject: TJSONObject;
begin
  JsonObject := TJSONObject.Create; // Cria um novo objeto JSON
  try
    // Mapeamento das propriedades do VO para campos JSON
    JsonObject.Add('ID', ID);
    JsonObject.Add('CNPJ_CPF', CNPJ_CPF);
    JsonObject.Add('NOME', NOME);
    JsonObject.Add('FONE1', FONE1);
    JsonObject.Add('FONE2', FONE2);
    JsonObject.Add('FONE3', FONE3);
    JsonObject.Add('EMAIL', EMAIL);

    JsonObject.Add('IDEUSUINS', IdeUsuIns);
    JsonObject.Add('IDEUSUALT', IdeUsuAlt);
    JsonObject.Add('IDEUSUEXC', IdeUsuExc);

    // Para datas/horas, convertemos para string no formato ISO 8601
    // Adicionando um tratamento para TDateTime = 0 para adicionar null no JSON
    if DtaHraIns <> 0 then
      JsonObject.Add('DTAHRAINS', FormatDateTime('yyyy-mm-dd hh:nn:ss', DtaHraIns))
    else
      JsonObject.Add('DTAHRAINS', TJSONNull.Create);

    if DtaHraUltAlt <> 0 then
      JsonObject.Add('DTAHRAULTALT', FormatDateTime('yyyy-mm-dd hh:nn:ss', DtaHraUltAlt))
    else
      JsonObject.Add('DTAHRAULTALT', TJSONNull.Create);

    if DtaHraExc <> 0 then
      JsonObject.Add('DTAHRAEXC', FormatDateTime('yyyy-mm-dd hh:nn:ss', DtaHraExc))
    else
      JsonObject.Add('DTAHRAEXC', TJSONNull.Create);

    JsonObject.Add('APAGADO', Apagado);
    JsonObject.Add('ATIVO', Ativo);

    JsonObject.Add('ENDERECO', ENDERECO);
    JsonObject.Add('NUMERO', NUMERO);
    JsonObject.Add('BAIRRO', BAIRRO);
    JsonObject.Add('CIDADE', CIDADE);
    JsonObject.Add('UF', UF);
    JsonObject.Add('TOKEN', TOKEN);

    Result := JsonObject.AsJSON; // Converte o objeto JSON para string
  finally
    JsonObject.Free; // Libera a memória do objeto JSON
  end;
end;

end.
