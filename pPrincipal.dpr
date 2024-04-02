program pPrincipal;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'uPrincipal.pas' {frm_caption},
  uClientes in 'uClientes.pas' {frm_clientes},
  uProdutos in 'uProdutos.pas' {frm_produtos};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_caption, frm_caption);
  Application.CreateForm(Tfrm_clientes, frm_clientes);
  Application.CreateForm(Tfrm_produtos, frm_produtos);
  Application.Run;
end.
