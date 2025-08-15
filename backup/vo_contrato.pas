unit vo_contrato;

interface

uses
  SysUtils, DateUtils, fpjson, jsonparser;
  // Usando fpjson e jsonparser conforme seu modelo

type
  { TVoContrato }
  // Unidade de Valor (Value Object) para a tabela CONTRATO.
  // Mapeia os campos da tabela para propriedades Delphi.
  TVoContrato = class
  public
    // Propriedades que mapeiam as colunas da tabela CONTRATO
    ID: string;
    ID_CLIENTE: string;
    TOKEN: integer;
    DT_CONTRATO: TDateTime; // Usamos TDateTime para DATE para consistência no Lazarus
    VLR_CONTRATADO: double;
    PER_JUROS: double;
    VLR_MENSAL: double;
    DT_ULTIMO_PAGTO: TDateTime;
    VLR_ULTIMO_PAGTO: double;
    IDEUSUINS: string;
    IDEUSUALT: string;
    IDEUSUEXC: string;
    DTAHRAINS: TDateTime;
    DTAHRAULTALT: TDateTime;
    DTAHRAEXC: TDateTime;
    APAGADO: integer;
    VLR_JUROS_PAGOS: double;
    VLR_CAPITAL_PAGO: double;
    ATIVO: integer;
    DT_PROXIMO_PAGTO: TDateTime;
    CNPJ_CPF : String;
    NUM_CONTRATO : String;

    // Construtor para inicializar o objeto
    constructor Create;

    // Método para limpar ou redefinir os valores do objeto
    procedure Clear;

    // Método para carregar dados de uma string JSON
    // Retorna True se o carregamento foi bem-sucedido, False caso contrário.
    function LoadFromJsonString(const AJsonString: string): boolean;

    // Método para exportar os dados do objeto para uma string JSON
    function ToJsonString: string;
  end;

implementation

constructor TVoContrato.Create;
begin
  Clear; // Inicializa todas as propriedades com valores padrão
end;

procedure TVoContrato.Clear;
begin
  ID := '';
  ID_CLIENTE := '';
  TOKEN := 0;
  DT_CONTRATO := 0; // TDateTime 0 representa uma data/hora nula (30/12/1899)
  VLR_CONTRATADO := 0.0;
  PER_JUROS := 0.0;
  VLR_MENSAL := 0.0;
  DT_ULTIMO_PAGTO := 0;
  VLR_ULTIMO_PAGTO := 0.0;
  IDEUSUINS := '';
  IDEUSUALT := '';
  IDEUSUEXC := '';
  DTAHRAINS := 0;
  DTAHRAULTALT := 0;
  DTAHRAEXC := 0;
  APAGADO := 0;
  VLR_JUROS_PAGOS := 0.0;
  VLR_CAPITAL_PAGO := 0.0;
  ATIVO := 0;
  DT_PROXIMO_PAGTO := 0;
  CNPJ_CPF := '';
  NUM_CONTRATO := '';
end;

function TVoContrato.LoadFromJsonString(const AJsonString: string): boolean;
var
  JsonData: TJSONData;
  JsonObject: TJSONObject;
  DateStr: string;
  JsonParser: TJSONParser;
begin
  Result := False; // Assume falha por padrão

  JsonParser := nil; // Inicializa o parser como nil
  try
    try
      JsonParser := TJSONParser.Create(AJsonString); // Cria o parser com a string JSON
      JsonData := JsonParser.Parse; // Analisa a string JSON e obtém o objeto JSONData

      // Se o JSON foi analisado com sucesso e é um objeto JSON
      if JsonData is TJSONObject then
      begin
        JsonObject := TJSONObject(JsonData);

        // Mapeamento dos campos JSON para as propriedades do VO
        ID := JsonObject.Get('ID', '');
        ID_CLIENTE := JsonObject.Get('ID_CLIENTE', '');
        TOKEN := JsonObject.Get('TOKEN', 0);
        CNPJ_CPF := JsonObject.Get('CNPJ_CPF', '');

        // Para campos DATE e TIMESTAMP, lemos como string e convertemos para TDateTime
        DateStr := JsonObject.Get('DT_CONTRATO', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DT_CONTRATO)
        else
          DT_CONTRATO := 0; // Define como nulo se a string estiver vazia

        VLR_CONTRATADO := JsonObject.Get('VLR_CONTRATADO', 0.0);
        PER_JUROS := JsonObject.Get('PER_JUROS', 0.0);
        VLR_MENSAL := JsonObject.Get('VLR_MENSAL', 0.0);

        DateStr := JsonObject.Get('DT_ULTIMO_PAGTO', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DT_ULTIMO_PAGTO)
        else
          DT_ULTIMO_PAGTO := 0;

        VLR_ULTIMO_PAGTO := JsonObject.Get('VLR_ULTIMO_PAGTO', 0.0);

        IDEUSUINS := JsonObject.Get('IDEUSUINS', '');
        IDEUSUALT := JsonObject.Get('IDEUSUALT', '');
        IDEUSUEXC := JsonObject.Get('IDEUSUEXC', '');
        NUM_CONTRATO  := JsonObject.Get('NUM_CONTRATO', '');

        DateStr := JsonObject.Get('DTAHRAINS', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DTAHRAINS)
        else
          DTAHRAINS := 0;

        DateStr := JsonObject.Get('DTAHRAULTALT', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DTAHRAULTALT)
        else
          DTAHRAULTALT := 0;

        DateStr := JsonObject.Get('DTAHRAEXC', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DTAHRAEXC)
        else
          DTAHRAEXC := 0;

        APAGADO := JsonObject.Get('APAGADO', 0);
        VLR_JUROS_PAGOS := JsonObject.Get('VLR_JUROS_PAGOS', 0.0);
        VLR_CAPITAL_PAGO := JsonObject.Get('VLR_CAPITAL_PAGO', 0.0);
        ATIVO := JsonObject.Get('ATIVO', 0);

        DateStr := JsonObject.Get('DT_PROXIMO_PAGTO', '');
        if DateStr <> '' then
          TryStrToDateTime(DateStr, DT_PROXIMO_PAGTO)
        else
          DT_PROXIMO_PAGTO := 0;

        Result := True; // Sucesso no mapeamento
      end;
    except // Captura qualquer exceção que ocorra durante o processo
      on E: Exception do
      begin
        // Opcional: Aqui você pode adicionar um log do erro para depuração
        // Por exemplo: OutputDebugString(PChar('Erro ao carregar JSON para TVoContrato: ' + E.Message));
        Result := False; // Garante que o resultado seja falso em caso de erro
      end;
    end;
  finally
    // Garante que o objeto JsonParser seja liberado, mesmo que ocorra uma exceção
    if Assigned(JsonParser) then
      JsonParser.Free;
  end;
end;

function TVoContrato.ToJsonString: string;
var
  JsonObject: TJSONObject;
begin
  JsonObject := TJSONObject.Create; // Cria um novo objeto JSON
  try
    // Mapeamento das propriedades do VO para campos JSON
    JsonObject.Add('ID', ID);
    JsonObject.Add('ID_CLIENTE', ID_CLIENTE);
    JsonObject.Add('TOKEN', TOKEN);

    // Para datas/horas, convertemos para string no formato 'yyyy-mm-dd hh:nn:ss' (ISO 8601 simplificado)
    // Adicionando um tratamento para TDateTime = 0 para adicionar null no JSON, conforme seu modelo.
    if DT_CONTRATO <> 0 then
      JsonObject.Add('DT_CONTRATO', FormatDateTime('yyyy-mm-dd hh:nn:ss', DT_CONTRATO))
    else
      JsonObject.Add('DT_CONTRATO', TJSONNull.Create);

    JsonObject.Add('VLR_CONTRATADO', VLR_CONTRATADO);
    JsonObject.Add('PER_JUROS', PER_JUROS);
    JsonObject.Add('VLR_MENSAL', VLR_MENSAL);
    JsonObject.Add('CNPJ_CPF', CNPJ_CPF);
        JsonObject.Add('NUM_CONTRATO', NUM_CONTRATO);

    if DT_ULTIMO_PAGTO <> 0 then
      JsonObject.Add('DT_ULTIMO_PAGTO', FormatDateTime('yyyy-mm-dd hh:nn:ss',
        DT_ULTIMO_PAGTO))
    else
      JsonObject.Add('DT_ULTIMO_PAGTO', TJSONNull.Create);

    JsonObject.Add('VLR_ULTIMO_PAGTO', VLR_ULTIMO_PAGTO);

    JsonObject.Add('IDEUSUINS', IDEUSUINS);
    JsonObject.Add('IDEUSUALT', IDEUSUALT);
    JsonObject.Add('IDEUSUEXC', IDEUSUEXC);

    if DTAHRAINS <> 0 then
      JsonObject.Add('DTAHRAINS', FormatDateTime('yyyy-mm-dd hh:nn:ss', DTAHRAINS))
    else
      JsonObject.Add('DTAHRAINS', TJSONNull.Create);

    if DTAHRAULTALT <> 0 then
      JsonObject.Add('DTAHRAULTALT', FormatDateTime('yyyy-mm-dd hh:nn:ss', DTAHRAULTALT))
    else
      JsonObject.Add('DTAHRAULTALT', TJSONNull.Create);

    if DTAHRAEXC <> 0 then
      JsonObject.Add('DTAHRAEXC', FormatDateTime('yyyy-mm-dd hh:nn:ss', DTAHRAEXC))
    else
      JsonObject.Add('DTAHRAEXC', TJSONNull.Create);

    JsonObject.Add('APAGADO', APAGADO);
    JsonObject.Add('VLR_JUROS_PAGOS', VLR_JUROS_PAGOS);
    JsonObject.Add('VLR_CAPITAL_PAGO', VLR_CAPITAL_PAGO);
    JsonObject.Add('ATIVO', ATIVO);

    if DT_PROXIMO_PAGTO <> 0 then
      JsonObject.Add('DT_PROXIMO_PAGTO', FormatDateTime('yyyy-mm-dd hh:nn:ss',
        DT_PROXIMO_PAGTO))
    else
      JsonObject.Add('DT_PROXIMO_PAGTO', TJSONNull.Create);

    Result := JsonObject.AsJSON; // Converte o objeto JSON para string
  finally
    JsonObject.Free; // Libera a memória do objeto JSON
  end;
end;

end.
