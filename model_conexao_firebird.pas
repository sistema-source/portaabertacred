unit model_conexao_firebird;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, configuracao_ini_file;

type

  { TModelConexaoFirebird }

  TModelConexaoFirebird = class(TDataModule)
    Conexao: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private

  public

  end;


implementation

{$R *.lfm}

{ TModelConexaoFirebird }

procedure TModelConexaoFirebird.DataModuleCreate(Sender: TObject);
var
  LConfig: TConfiguracaoBanco;
  LNomeArquivo, LPasta: string;
begin
  LPasta := ExtractFilePath(ParamStr(0)) + 'ini';
  if not DirectoryExists(LPasta) then
    ForceDirectories(LPasta);
  LNomeArquivo := ExtractFileName(ParamStr(0));
  LNomeArquivo := LPasta + '\' + ChangeFileExt(LNomeArquivo, '.ini');

  LConfig := TConfiguracaoBanco.Create(LNomeArquivo);
  try
    Conexao.HostName := LConfig.EnderecoBancoDados;
    Conexao.Database := LConfig.NomeBancoDados;
    Conexao.User := LConfig.Usuario;
    Conexao.Password := LConfig.Senha;
    try
      Conexao.Connected := True;
    except
      on e: Exception do
      begin
        raise Exception.Create('Não foi possível conectar no banco de dados. Verifique o arquivo ini ['+LNomeArquivo +'] '+  sLineBreak + '[TModelConexaoFirebird.DataModuleCreate]'
        +sLineBreak + 'Banco: '+  Conexao.Database
        +sLineBreak + 'Servidor: '+  Conexao.HostName
        +sLineBreak + 'Usuario : '+  Conexao.User
        +sLineBreak + 'Senha : '+  Conexao.Password
        +sLineBreak + 'Message: '+e.Message);
      end;
    end;
    LConfig.Salvar; // salvar alterações
  finally
    LConfig.Free;
  end;
end;

end.
