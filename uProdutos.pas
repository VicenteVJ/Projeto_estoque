unit uProdutos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Edit,
  FMX.TabControl, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.Math.Vectors,
  FMX.Controls3D, FMX.Layers3D, FMX.ListBox, FMX.Ani, FMX.Objects;


type

  TProduto = record
    codigo : integer;
    descricao, unidade : String;
    valor, quantidade : Single;
  end;

  Tfrm_produtos = class(TForm)
    TabControl1: TTabControl;
    tbConsultar: TTabItem;
    Layout1: TLayout;
    sbtn_voltar: TSpeedButton;
    Label1: TLabel;
    Layout2: TLayout;
    sbtn_pesquisar: TSpeedButton;
    edt_pesquisar: TEdit;
    Layout3: TLayout;
    ListView1: TListView;
    tbInserir: TTabItem;
    Layout4: TLayout;
    sbtnVoltarInserir: TSpeedButton;
    Label2: TLabel;
    tbEditar: TTabItem;
    FDConnection1: TFDConnection;
    FDQ_Produtos: TFDQuery;
    Layout5: TLayout;
    sbtnSalvarProduto: TSpeedButton;
    Layout6: TLayout;
    edtDescricao: TEdit;
    Label4: TLabel;
    edtQtde: TEdit;
    Label5: TLabel;
    edtUnidade: TEdit;
    Label6: TLabel;
    edtPreco: TEdit;
    Label7: TLabel;
    Layout7: TLayout;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    Layout8: TLayout;
    Layout9: TLayout;
    edtDescricaoEditar: TEdit;
    Label8: TLabel;
    edtQtdeEditar: TEdit;
    Label9: TLabel;
    edtUndEditar: TEdit;
    Label10: TLabel;
    edtPrecoEditar: TEdit;
    Label11: TLabel;
    sbtnSalvaEdicaoProduto: TSpeedButton;
    edtCodigoEditar: TEdit;
    Label12: TLabel;
    sbtnDeletaProduto: TSpeedButton;
    filtroPesquisa: TComboBox;
    Descricao: TListBoxItem;
    Pre�o: TListBoxItem;
    Image1: TImage;

    procedure insereProdutoLista(produto : TProduto);
    procedure atualizaConsultaBD();
    procedure atualizaConsultaPrecoBD();
    procedure insereProdutoBD(produto : TProduto);
    procedure sbtn_pesquisarClick(Sender: TObject);
    procedure sbtnSalvarInsercao(Sender: TObject);
    procedure sbtnVoltarInserirClick(Sender: TObject);
    procedure editaProdutoBD(produto : TProduto);
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure sbtnSalvaEdicao(Sender: TObject);
    procedure deletaProduto(produtoCodigo : Integer);
    procedure sbtnDeletaProdutoClick(Sender: TObject);
    procedure sbtnFiltroClick(Sender: TObject);
    procedure sbtn_voltarClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_produtos: Tfrm_produtos;

implementation

{$R *.fmx}

{ Tfrm_produtos }

procedure Tfrm_produtos.atualizaConsultaBD;
var
  vProduto : TProduto; // Declara��o de uma vari�vel do tipo TProduto para armazenar os dados de cada produto
begin

  // Efetuar a consulta ao BD e trazer dados

  FDQ_Produtos.Close; // Fecha a consulta antes de configur�-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('select * from Produtos'); // Define a consulta para selecionar todos os dados da tabela "Produtos"

  if edt_pesquisar.Text <> '' then // Verifica se o campo de pesquisa n�o est� vazio
  begin
    FDQ_Produtos.SQL.Add('where descricao like :pesquisa'); // Adiciona uma cl�usula WHERE � consulta para filtrar por descri��o
    FDQ_Produtos.ParamByName('pesquisa').AsString := '%' + edt_pesquisar.Text + '%'; // Define o valor do par�metro de pesquisa com base no texto do campo de pesquisa
  end;

  FDQ_Produtos.Open(); // Executa a consulta

  FDQ_Produtos.First; // Move o cursor para o primeiro registro retornado pela consulta

  ListView1.Items.Clear; // Limpa a lista visual de produtos antes de atualiz�-la

  while not FDQ_Produtos.Eof do // Itera sobre todos os registros retornados pela consulta
  begin
    // L� os dados do produto do conjunto de resultados e os atribui � estrutura de dados TProduto
    vProduto.codigo := FDQ_Produtos.FieldByName('codigo').AsInteger;
    vProduto.descricao := FDQ_Produtos.FieldByName('descricao').AsString;
    vProduto.quantidade := FDQ_Produtos.FieldByName('quantidade').AsInteger;
    vProduto.unidade := FDQ_Produtos.FieldByName('unidade').AsString;
    vProduto.valor := FDQ_Produtos.FieldByName('valor').AsInteger;

    // Insere o produto na lista visual
    insereProdutoLista(vProduto);

    FDQ_Produtos.Next; // Move o cursor para o pr�ximo registro
  end;

end;

procedure Tfrm_produtos.atualizaConsultaPrecoBD;
var
  vProduto: TProduto; // Declara��o de uma vari�vel do tipo TProduto para armazenar os dados de cada produto
begin
  // Efetuar a consulta ao BD e trazer dados

  FDQ_Produtos.Close; // Fecha a consulta antes de configur�-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('select * from Produtos'); // Define a consulta para selecionar todos os dados da tabela "Produtos"

  if edt_pesquisar.Text <> '' then // Verifica se o campo de pesquisa n�o est� vazio
  begin
    FDQ_Produtos.SQL.Add('WHERE valor = :pesquisa'); // Adiciona uma cl�usula WHERE � consulta para filtrar por valor do produto
    FDQ_Produtos.ParamByName('pesquisa').AsString := '%' + edt_pesquisar.Text + '%'; // Define o valor do par�metro de pesquisa com base no texto do campo de pesquisa
  end;

  FDQ_Produtos.Open(); // Executa a consulta

  FDQ_Produtos.First; // Move o cursor para o primeiro registro retornado pela consulta

  ListView1.Items.Clear; // Limpa a lista visual de produtos antes de atualiz�-la

  while not FDQ_Produtos.Eof do // Itera sobre todos os registros retornados pela consulta
  begin
    // L� os dados do produto do conjunto de resultados e os atribui � estrutura de dados TProduto
    vProduto.codigo := FDQ_Produtos.FieldByName('codigo').AsInteger;
    vProduto.descricao := FDQ_Produtos.FieldByName('descricao').AsString;
    vProduto.quantidade := FDQ_Produtos.FieldByName('quantidade').AsInteger;
    vProduto.unidade := FDQ_Produtos.FieldByName('unidade').AsString;
    vProduto.valor := FDQ_Produtos.FieldByName('valor').AsInteger;

    // Insere o produto na lista visual
    insereProdutoLista(vProduto);

    FDQ_Produtos.Next; // Move o cursor para o pr�ximo registro
  end;
end;

procedure Tfrm_produtos.deletaProduto(produtoCodigo: Integer);
begin
  FDQ_Produtos.Close; // Fecha a consulta antes de configur�-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('DELETE FROM produtos WHERE codigo = :codigo'); // Define a instru��o SQL para excluir um produto com base no c�digo
  FDQ_Produtos.ParamByName('codigo').AsInteger := produtoCodigo; // Define o valor do par�metro 'codigo' com o c�digo do produto a ser exclu�do
  FDQ_Produtos.ExecSQL; // Executa a instru��o SQL para excluir o produto

  ShowMessage('Produto exclu�do'); // Exibe uma mensagem informando que o produto foi exclu�do com sucesso
  sbtn_pesquisar.OnClick(sbtn_pesquisar); // Executa o evento OnClick do bot�o de pesquisa para atualizar a lista de produtos ap�s a exclus�o
  TabControl1.TabIndex := 0; // Define o �ndice da guia para a primeira guia (possivelmente a guia principal) ap�s a exclus�o do produto
end;

procedure Tfrm_produtos.editaProdutoBD(produto: TProduto);
begin
  FDQ_Produtos.Close; // Fecha a consulta antes de configur�-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('UPDATE Produtos SET descricao = :descricao, valor = :valor, quantidade = :quantidade, unidade = :unidade WHERE codigo = :codigo'); // Define a instru��o SQL para atualizar os dados do produto
  FDQ_Produtos.ParamByName('descricao').AsString := produto.descricao; // Define o valor do par�metro 'descricao' com a descri��o do produto
  FDQ_Produtos.ParamByName('valor').AsSingle := produto.valor; // Define o valor do par�metro 'valor' com o valor do produto
  FDQ_Produtos.ParamByName('quantidade').AsSingle := produto.quantidade; // Define o valor do par�metro 'quantidade' com a quantidade do produto
  FDQ_Produtos.ParamByName('unidade').AsString := produto.unidade; // Define o valor do par�metro 'unidade' com a unidade do produto
  FDQ_Produtos.ParamByName('codigo').AsInteger := produto.codigo; // Define o valor do par�metro 'codigo' com o c�digo do produto
  FDQ_Produtos.ExecSQL; // Executa a instru��o SQL para atualizar os dados do produto

  ShowMessage('Produto atualizado com sucesso!'); // Exibe uma mensagem informando que o produto foi atualizado com sucesso
  sbtn_pesquisar.OnClick(sbtn_pesquisar); // Executa o evento OnClick do bot�o de pesquisa para atualizar a lista de produtos ap�s a atualiza��o
  TabControl1.TabIndex := 0; // Define o �ndice da guia para a primeira guia (possivelmente a guia principal) ap�s a atualiza��o do produto
end;

procedure Tfrm_produtos.Image1Click(Sender: TObject);
begin
    TabControl1.TabIndex := 1; // Define o �ndice da guia ativa do componente TabControl1 como 1
end;

procedure Tfrm_produtos.insereProdutoBD(produto: TProduto);
begin
  FDQ_Produtos.Close; // Fecha a consulta antes de configur�-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('insert into Produtos (descricao, valor, quantidade, unidade) values (:descricao, :valor, :quantidade, :unidade)'); // Define a instru��o SQL para inserir um novo produto na tabela
  FDQ_Produtos.ParamByName('descricao').AsString := produto.descricao; // Define o valor do par�metro 'descricao' com a descri��o do produto
  FDQ_Produtos.ParamByName('valor').AsSingle := produto.valor; // Define o valor do par�metro 'valor' com o valor do produto
  FDQ_Produtos.ParamByName('quantidade').AsSingle := produto.quantidade; // Define o valor do par�metro 'quantidade' com a quantidade do produto
  FDQ_Produtos.ParamByName('unidade').AsString := produto.unidade; // Define o valor do par�metro 'unidade' com a unidade do produto
  FDQ_Produtos.ExecSQL; // Executa a instru��o SQL para inserir o novo produto na tabela
end;

procedure Tfrm_produtos.insereProdutoLista(produto: TProduto);
begin
  with ListView1.Items.Add() do // Adiciona um novo item � ListView1
  begin
    // Define o texto dos subitens do novo item com base nos dados do produto fornecido
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(produto.codigo); // Define o c�digo do produto
    TListItemText(Objects.FindDrawable('txtDescricao')).Text := produto.descricao; // Define a descri��o do produto
    TListItemText(Objects.FindDrawable('txtQtde')).Text := FloatToStr(produto.quantidade); // Define a quantidade do produto
    TListItemText(Objects.FindDrawable('txtUnd')).Text := produto.unidade; // Define a unidade do produto
    TListItemText(Objects.FindDrawable('txtValor')).Text := Format('R$ %s', [FloatToStr(produto.valor)]); // Define o valor do produto formatado como moeda
  end;
end;

procedure Tfrm_produtos.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
var
  vProdutoID: Integer; // Declara��o de uma vari�vel para armazenar o ID do produto selecionado
begin
  TabControl1.TabIndex := 2; // Define o �ndice da guia ativa do componente TabControl1 como 2

  // Obt�m o c�digo e a descri��o do produto selecionado na ListView e os exibe nos campos de edi��o correspondentes
  edtCodigoEditar.Text := TListItemText(AItem.Objects.FindDrawable('txtCodigo')).Text; // Define o texto do campo de edi��o de c�digo com o c�digo do produto selecionado
  edtDescricaoEditar.Text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text; // Define o texto do campo de edi��o de descri��o com a descri��o do produto selecionado
end;

procedure Tfrm_produtos.sbtnDeletaProdutoClick(Sender: TObject);
begin
  // Chama o procedimento deletaProduto para excluir o produto com base no c�digo fornecido no campo de edi��o de c�digo (edtCodigoEditar)
  deletaProduto(StrToInt(edtCodigoEditar.Text));
end;

procedure Tfrm_produtos.sbtnFiltroClick(Sender: TObject);
var
  filtroSelecionado: Integer; // Declara��o de uma vari�vel para armazenar o filtro selecionado
begin
  // Este procedimento ser� respons�vel por aplicar um filtro � lista de produtos com base na op��o selecionada pelo usu�rio.
  // O c�digo para aplicar o filtro ser� adicionado aqui.
end;

procedure Tfrm_produtos.sbtnSalvaEdicao(Sender: TObject);
var
  vProduto: TProduto; // Declara��o de uma vari�vel para armazenar os dados do produto a ser editado
begin
  //Chamar procedure para salvar edi��o no banco

  // Preenche a estrutura de dados do produto com os valores dos campos de edi��o
  vProduto.codigo := StrToInt(edtCodigoEditar.Text);
  vProduto.descricao := edtDescricaoEditar.Text;
  vProduto.quantidade := StrToFloat(edtQtdeEditar.Text);
  vProduto.unidade := edtUndEditar.Text;
  vProduto.valor := StrToFloat(edtPrecoEditar.Text);

  // Chama o procedimento editaProdutoBD para salvar as altera��es no banco de dados
  editaProdutoBD(vProduto);
end;

procedure Tfrm_produtos.sbtnSalvarInsercao(Sender: TObject);
var
  vProduto: TProduto; // Declara��o de uma vari�vel para armazenar os dados do produto a ser inserido
begin
  //Chamar procedure para inserir cliente no banco

  // Preenche a estrutura de dados do produto com os valores fornecidos nos campos de entrada
  vProduto.descricao := edtDescricao.Text;
  vProduto.quantidade := StrToFloat(edtQtde.Text);
  vProduto.unidade := edtUnidade.Text;
  vProduto.valor := StrToFloat(edtPreco.Text);

  // Chama o procedimento insereProdutoBD para inserir o novo produto no banco de dados
  insereProdutoBD(vProduto);

  // Exibe uma mensagem informando que o produto foi cadastrado com sucesso
  ShowMessage('Produto cadastrado com sucesso!!');
end;

procedure Tfrm_produtos.sbtnVoltarInserirClick(Sender: TObject);
begin
  TabControl1.TabIndex := 0; // Define o �ndice da guia ativa do componente TabControl1 como 0
end;


procedure Tfrm_produtos.sbtn_pesquisarClick(Sender: TObject);
begin
  //Chama m�todo de atualizar lista

  filtroPesquisa.ItemIndex := 0; // Define o �ndice do filtro de pesquisa como 0 (possivelmente redefinindo para o padr�o)

  if filtroPesquisa.Items[filtroPesquisa.ItemIndex] = 'Descricao' then
  begin
    atualizaConsultaBD; // Chama o m�todo para atualizar a lista de produtos baseada na descri��o
  end
  else if filtroPesquisa.Items[filtroPesquisa.ItemIndex] = 'Pre�o' then
  begin
    atualizaConsultaPrecoBD; // Chama o m�todo para atualizar a lista de produtos baseada no pre�o
  end;
end;

procedure Tfrm_produtos.sbtn_voltarClick(Sender: TObject);
begin
    frm_produtos.Close; // Fecha o formul�rio atual (provavelmente o formul�rio de produtos)
end;

end.
