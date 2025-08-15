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
rotas_usuario_porta_aberta_cred, dao_pai, dao_usuario, dao_empresa, vo_empresa, vo_usuario, rotas_empresa_porta_aberta_cred, vo_cliente, 
rotas_cliente_porta_aberta_cred, dao_cliente, vo_contrato, rotas_contrato_porta_aberta_cred, dao_contrato;


{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TDaoEmpresa, DaoEmpresa);
  Application.CreateForm(TDaoCliente, DaoCliente);
  Application.CreateForm(TDaoContrato, DaoContrato);
  Application.Run;
end.

