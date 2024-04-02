unit uClientes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.ListView, FMX.Edit, FMX.TabControl;

type

  TCliente = record
    codigo :  Integer;
    nome, endereco :  String;
  end;

  Tfrm_clientes = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    sbtn_voltar: TSpeedButton;
    sbtn_acrescentar: TSpeedButton;
    Label1: TLabel;
    sbtn_pesquisar: TSpeedButton;
    edt_pesquisar: TEdit;
    ListView1: TListView;
    FDConnection1: TFDConnection;
    FDQ_Clientes: TFDQuery;
    TabControl1: TTabControl;
    tbConsultar: TTabItem;
    tbInserir: TTabItem;
    tbEditar: TTabItem;
    Layout4: TLayout;
    sbtnVoltarInserir: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    edtCodigo: TEdit;
    Label4: TLabel;
    edtNome: TEdit;
    Label5: TLabel;
    edtEndereco: TEdit;
    Layout5: TLayout;
    sbtnSalvarCliente: TSpeedButton;
    procedure sbtn_pesquisarClick(Sender: TObject);

    procedure atualizarConsultaClienteBD();
    procedure insereClienteLista(cliente : TCliente);
    procedure insereClienteBanco(cliente : TCliente);
    procedure sbtn_acrescentarClick(Sender: TObject);
    procedure sbtnSalvarClienteClick(Sender: TObject);
    procedure sbtnVoltarInserirClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_clientes: Tfrm_clientes;

implementation

{$R *.fmx}

procedure Tfrm_clientes.atualizarConsultaClienteBD;
var vCliente : TCliente;
begin

  // Efetuar a consulta ao BD e trazer dados
  FDQ_Clientes.Close;
  FDQ_Clientes.SQL.Clear;
  FDQ_Clientes.SQL.Add('select * from clientes');

  if edt_pesquisar.Text <> '' then
  begin
    FDQ_Clientes.SQL.Add('where nome like :pesquisa');
    FDQ_Clientes.ParamByName('pesquisa').AsString := edt_pesquisar.Text;

  end;

  FDQ_Clientes.Open();

  FDQ_Clientes.First;

  ListView1.Items.Clear;

  while not FDQ_Clientes.Eof do
  begin
    vCliente.codigo := FDQ_Clientes.FieldByName('codigo').AsInteger;
    vCliente.nome := FDQ_Clientes.FieldByName('nome').AsString;
    vCliente.endereco := FDQ_Clientes.FieldByName('endereco').AsString;

    insereClienteLista(vCliente);

    FDQ_Clientes.Next
  end;


end;

procedure Tfrm_clientes.insereClienteBanco(cliente : TCliente);
begin

  FDQ_Clientes.Close;
  FDQ_Clientes.SQL.Clear;
  FDQ_Clientes.SQL.Add('insert into clientes (codigo, nome, endereco) values (:codigo, :nome, :endereco)');
  FDQ_Clientes.ParamByName('codigo').AsInteger := cliente.codigo;
  FDQ_Clientes.ParamByName('nome').AsString := cliente.nome;
  FDQ_Clientes.ParamByName('endereco').AsString := cliente.endereco;
  FDQ_Clientes.ExecSQL;

end;

procedure Tfrm_clientes.insereClienteLista(cliente: TCliente);
begin

  with ListView1.Items.Add() do
  begin
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(cliente.codigo);
    TListItemText(Objects.FindDrawable('txtNome')).Text := cliente.nome;
  end;

end;

procedure Tfrm_clientes.sbtn_acrescentarClick(Sender: TObject);
begin

  TabControl1.TabIndex := 1;

end;

procedure Tfrm_clientes.sbtn_pesquisarClick(Sender: TObject);
begin

  // Chamar método de consulta ao BD
  atualizarConsultaClienteBD();

end;

procedure Tfrm_clientes.sbtnVoltarInserirClick(Sender: TObject);
begin

  TabControl1.TabIndex := 0;
  frm_clientes.Close;

end;

procedure Tfrm_clientes.sbtnSalvarClienteClick(Sender: TObject);
var
  vCliente : TCliente;
begin

  //Chamar procedure para inserir cliente no banco
  vCliente.codigo := StrToInt(edtCodigo.Text);
  vCliente.nome := edtNome.Text;
  vCliente.endereco := edtEndereco.Text;

  insereClienteBanco(vCliente);

  edtCodigo.Text := '';
  edtNome.Text := '' ;
  edtEndereco.Text := '' ;

  ShowMessage('Cliente cadastrado com sucesso!!');

end;

end.
