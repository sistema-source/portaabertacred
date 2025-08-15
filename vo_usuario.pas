unit vo_usuario;

interface

uses
  SysUtils, DateUtils, fpjson, jsonparser;

type
  TVoUsuario = class
  public
    // Propriedades que mapeiam as colunas da tabela USUARIO
    ID: string;
    EMAIL: string;
    SENHA: string;
    IdeUsuIns: string;
    IdeUsuAlt: string;
    IdeUsuExc: string;
    DtaHraIns: TDateTime;
    DtaHraUltAlt: TDateTime;
    DtaHraExc: TDateTime;
    Ativo: integer;
    Apagado: integer;
    NOME: string;
    TELEFONE: string;
    TOKEN: Integer;
    ADMINISTRADOR : Integer;

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

constructor TVoUsuario.Create;
begin
  Clear; // Chama o método Clear para inicializar todas as propriedades
end;

procedure TVoUsuario.Clear;
begin
  ID := '';
  EMAIL := '';
  SENHA := '';
  IdeUsuIns := '';
  IdeUsuAlt := '';
  IdeUsuExc := '';
  DtaHraIns := 0; // 0 representa uma TDateTime vazia
  DtaHraUltAlt := 0;
  DtaHraExc := 0;
  Ativo := 0;
  Apagado := 0;
  NOME := '';
  TELEFONE := '';
  Token := 0;
  Administrador := 0;
end;

function TVoUsuario.LoadFromJsonString(const AJsonString: string): boolean;
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
        EMAIL := JsonObject.Get('EMAIL', '');
        SENHA := JsonObject.Get('SENHA', '');
        NOME := JsonObject.Get('NOME', '');
        TELEFONE := JsonObject.Get('TELEFONE', '');


        TOKEN := JsonObject.Get('TOKEN', 0);
        Administrador := JsonObject.Get('ADMINISTADOR', 0);

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

        Ativo := JsonObject.Get('ATIVO', 0);
        Apagado := JsonObject.Get('APAGADO', 0);

        Result := True; // Sucesso no mapeamento
      end;
    except // Captura qualquer exceção que ocorra durante o processo
      on E: Exception do
      begin
        // Opcional: Aqui você pode adicionar um log do erro para depuração
        // Por exemplo: OutputDebugString(PChar('Erro ao carregar JSON para TVoUsuario: ' + E.Message));
        Result := False; // Garante que o resultado seja falso em caso de erro
      end;
    end;
  finally
    // Garante que o objeto JsonParser seja liberado, mesmo que ocorra uma exceção
    if Assigned(JsonParser) then
      JsonParser.Free;
  end;
end;

function TVoUsuario.ToJsonString: string;
var
  JsonObject: TJSONObject;
begin
  JsonObject := TJSONObject.Create; // Cria um novo objeto JSON
  try
    // Mapeamento das propriedades do VO para campos JSON
    JsonObject.Add('ID', ID);
    JsonObject.Add('EMAIL', EMAIL);
    JsonObject.Add('SENHA', SENHA);
    JsonObject.Add('NOME', NOME);
    JsonObject.Add('TELEFONE', TELEFONE);
    JsonObject.Add('TOKEN', TOKEN);
    JsonObject.Add('ADMINISTRADOR', Administrador);

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

    JsonObject.Add('ATIVO', Ativo);
    JsonObject.Add('APAGADO', Apagado);

    Result := JsonObject.AsJSON; // Converte o objeto JSON para string
  finally
    JsonObject.Free; // Libera a memória do objeto JSON
  end;
end;

end.
