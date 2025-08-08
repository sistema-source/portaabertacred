program ServidorPortaAbertaCred;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, zcomponent, view_principal, model_conexao_firebird,
rotas_empresa_porta_aberta_cred, dao_pai, dao_usuario, dao_empresa, vo_empresa;


{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TDaoEmpresa, DaoEmpresa);
  Application.Run;
end.

