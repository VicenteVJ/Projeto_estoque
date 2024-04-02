unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  Tfrm_caption = class(TForm)
    btn_clientes: TButton;
    btn_produtos: TButton;
    procedure btn_clientesClick(Sender: TObject);
    procedure btn_produtosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_caption: Tfrm_caption;

implementation

{$R *.fmx}
uses uClientes, uProdutos;

procedure Tfrm_caption.btn_clientesClick(Sender: TObject);
begin
  frm_clientes.Show;
end;

procedure Tfrm_caption.btn_produtosClick(Sender: TObject);
begin
 frm_produtos.Show;
end;

end.
