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
    Preço: TListBoxItem;
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
  vProduto : TProduto; // Declaração de uma variável do tipo TProduto para armazenar os dados de cada produto
begin

  // Efetuar a consulta ao BD e trazer dados

  FDQ_Produtos.Close; // Fecha a consulta antes de configurá-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('select * from Produtos'); // Define a consulta para selecionar todos os dados da tabela "Produtos"

  if edt_pesquisar.Text <> '' then // Verifica se o campo de pesquisa não está vazio
  begin
    FDQ_Produtos.SQL.Add('where descricao like :pesquisa'); // Adiciona uma cláusula WHERE à consulta para filtrar por descrição
    FDQ_Produtos.ParamByName('pesquisa').AsString := '%' + edt_pesquisar.Text + '%'; // Define o valor do parâmetro de pesquisa com base no texto do campo de pesquisa
  end;

  FDQ_Produtos.Open(); // Executa a consulta

  FDQ_Produtos.First; // Move o cursor para o primeiro registro retornado pela consulta

  ListView1.Items.Clear; // Limpa a lista visual de produtos antes de atualizá-la

  while not FDQ_Produtos.Eof do // Itera sobre todos os registros retornados pela consulta
  begin
    // Lê os dados do produto do conjunto de resultados e os atribui à estrutura de dados TProduto
    vProduto.codigo := FDQ_Produtos.FieldByName('codigo').AsInteger;
    vProduto.descricao := FDQ_Produtos.FieldByName('descricao').AsString;
    vProduto.quantidade := FDQ_Produtos.FieldByName('quantidade').AsInteger;
    vProduto.unidade := FDQ_Produtos.FieldByName('unidade').AsString;
    vProduto.valor := FDQ_Produtos.FieldByName('valor').AsInteger;

    // Insere o produto na lista visual
    insereProdutoLista(vProduto);

    FDQ_Produtos.Next; // Move o cursor para o próximo registro
  end;

end;

procedure Tfrm_produtos.atualizaConsultaPrecoBD;
var
  vProduto: TProduto; // Declaração de uma variável do tipo TProduto para armazenar os dados de cada produto
begin
  // Efetuar a consulta ao BD e trazer dados

  FDQ_Produtos.Close; // Fecha a consulta antes de configurá-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('select * from Produtos'); // Define a consulta para selecionar todos os dados da tabela "Produtos"

  if edt_pesquisar.Text <> '' then // Verifica se o campo de pesquisa não está vazio
  begin
    FDQ_Produtos.SQL.Add('WHERE valor = :pesquisa'); // Adiciona uma cláusula WHERE à consulta para filtrar por valor do produto
    FDQ_Produtos.ParamByName('pesquisa').AsString := '%' + edt_pesquisar.Text + '%'; // Define o valor do parâmetro de pesquisa com base no texto do campo de pesquisa
  end;

  FDQ_Produtos.Open(); // Executa a consulta

  FDQ_Produtos.First; // Move o cursor para o primeiro registro retornado pela consulta

  ListView1.Items.Clear; // Limpa a lista visual de produtos antes de atualizá-la

  while not FDQ_Produtos.Eof do // Itera sobre todos os registros retornados pela consulta
  begin
    // Lê os dados do produto do conjunto de resultados e os atribui à estrutura de dados TProduto
    vProduto.codigo := FDQ_Produtos.FieldByName('codigo').AsInteger;
    vProduto.descricao := FDQ_Produtos.FieldByName('descricao').AsString;
    vProduto.quantidade := FDQ_Produtos.FieldByName('quantidade').AsInteger;
    vProduto.unidade := FDQ_Produtos.FieldByName('unidade').AsString;
    vProduto.valor := FDQ_Produtos.FieldByName('valor').AsInteger;

    // Insere o produto na lista visual
    insereProdutoLista(vProduto);

    FDQ_Produtos.Next; // Move o cursor para o próximo registro
  end;
end;

procedure Tfrm_produtos.deletaProduto(produtoCodigo: Integer);
begin
  FDQ_Produtos.Close; // Fecha a consulta antes de configurá-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('DELETE FROM produtos WHERE codigo = :codigo'); // Define a instrução SQL para excluir um produto com base no código
  FDQ_Produtos.ParamByName('codigo').AsInteger := produtoCodigo; // Define o valor do parâmetro 'codigo' com o código do produto a ser excluído
  FDQ_Produtos.ExecSQL; // Executa a instrução SQL para excluir o produto

  ShowMessage('Produto excluído'); // Exibe uma mensagem informando que o produto foi excluído com sucesso
  sbtn_pesquisar.OnClick(sbtn_pesquisar); // Executa o evento OnClick do botão de pesquisa para atualizar a lista de produtos após a exclusão
  TabControl1.TabIndex := 0; // Define o índice da guia para a primeira guia (possivelmente a guia principal) após a exclusão do produto
end;

procedure Tfrm_produtos.editaProdutoBD(produto: TProduto);
begin
  FDQ_Produtos.Close; // Fecha a consulta antes de configurá-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('UPDATE Produtos SET descricao = :descricao, valor = :valor, quantidade = :quantidade, unidade = :unidade WHERE codigo = :codigo'); // Define a instrução SQL para atualizar os dados do produto
  FDQ_Produtos.ParamByName('descricao').AsString := produto.descricao; // Define o valor do parâmetro 'descricao' com a descrição do produto
  FDQ_Produtos.ParamByName('valor').AsSingle := produto.valor; // Define o valor do parâmetro 'valor' com o valor do produto
  FDQ_Produtos.ParamByName('quantidade').AsSingle := produto.quantidade; // Define o valor do parâmetro 'quantidade' com a quantidade do produto
  FDQ_Produtos.ParamByName('unidade').AsString := produto.unidade; // Define o valor do parâmetro 'unidade' com a unidade do produto
  FDQ_Produtos.ParamByName('codigo').AsInteger := produto.codigo; // Define o valor do parâmetro 'codigo' com o código do produto
  FDQ_Produtos.ExecSQL; // Executa a instrução SQL para atualizar os dados do produto

  ShowMessage('Produto atualizado com sucesso!'); // Exibe uma mensagem informando que o produto foi atualizado com sucesso
  sbtn_pesquisar.OnClick(sbtn_pesquisar); // Executa o evento OnClick do botão de pesquisa para atualizar a lista de produtos após a atualização
  TabControl1.TabIndex := 0; // Define o índice da guia para a primeira guia (possivelmente a guia principal) após a atualização do produto
end;

procedure Tfrm_produtos.Image1Click(Sender: TObject);
begin
    TabControl1.TabIndex := 1; // Define o índice da guia ativa do componente TabControl1 como 1
end;

procedure Tfrm_produtos.insereProdutoBD(produto: TProduto);
begin
  FDQ_Produtos.Close; // Fecha a consulta antes de configurá-la novamente
  FDQ_Produtos.SQL.Clear; // Limpa o comando SQL da consulta
  FDQ_Produtos.SQL.Add('insert into Produtos (descricao, valor, quantidade, unidade) values (:descricao, :valor, :quantidade, :unidade)'); // Define a instrução SQL para inserir um novo produto na tabela
  FDQ_Produtos.ParamByName('descricao').AsString := produto.descricao; // Define o valor do parâmetro 'descricao' com a descrição do produto
  FDQ_Produtos.ParamByName('valor').AsSingle := produto.valor; // Define o valor do parâmetro 'valor' com o valor do produto
  FDQ_Produtos.ParamByName('quantidade').AsSingle := produto.quantidade; // Define o valor do parâmetro 'quantidade' com a quantidade do produto
  FDQ_Produtos.ParamByName('unidade').AsString := produto.unidade; // Define o valor do parâmetro 'unidade' com a unidade do produto
  FDQ_Produtos.ExecSQL; // Executa a instrução SQL para inserir o novo produto na tabela
end;

procedure Tfrm_produtos.insereProdutoLista(produto: TProduto);
begin
  with ListView1.Items.Add() do // Adiciona um novo item à ListView1
  begin
    // Define o texto dos subitens do novo item com base nos dados do produto fornecido
    TListItemText(Objects.FindDrawable('txtCodigo')).Text := IntToStr(produto.codigo); // Define o código do produto
    TListItemText(Objects.FindDrawable('txtDescricao')).Text := produto.descricao; // Define a descrição do produto
    TListItemText(Objects.FindDrawable('txtQtde')).Text := FloatToStr(produto.quantidade); // Define a quantidade do produto
    TListItemText(Objects.FindDrawable('txtUnd')).Text := produto.unidade; // Define a unidade do produto
    TListItemText(Objects.FindDrawable('txtValor')).Text := Format('R$ %s', [FloatToStr(produto.valor)]); // Define o valor do produto formatado como moeda
  end;
end;

procedure Tfrm_produtos.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
var
  vProdutoID: Integer; // Declaração de uma variável para armazenar o ID do produto selecionado
begin
  TabControl1.TabIndex := 2; // Define o índice da guia ativa do componente TabControl1 como 2

  // Obtém o código e a descrição do produto selecionado na ListView e os exibe nos campos de edição correspondentes
  edtCodigoEditar.Text := TListItemText(AItem.Objects.FindDrawable('txtCodigo')).Text; // Define o texto do campo de edição de código com o código do produto selecionado
  edtDescricaoEditar.Text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text; // Define o texto do campo de edição de descrição com a descrição do produto selecionado
end;

procedure Tfrm_produtos.sbtnDeletaProdutoClick(Sender: TObject);
begin
  // Chama o procedimento deletaProduto para excluir o produto com base no código fornecido no campo de edição de código (edtCodigoEditar)
  deletaProduto(StrToInt(edtCodigoEditar.Text));
end;

procedure Tfrm_produtos.sbtnFiltroClick(Sender: TObject);
var
  filtroSelecionado: Integer; // Declaração de uma variável para armazenar o filtro selecionado
begin
  // Este procedimento será responsável por aplicar um filtro à lista de produtos com base na opção selecionada pelo usuário.
  // O código para aplicar o filtro será adicionado aqui.
end;

procedure Tfrm_produtos.sbtnSalvaEdicao(Sender: TObject);
var
  vProduto: TProduto; // Declaração de uma variável para armazenar os dados do produto a ser editado
begin
  //Chamar procedure para salvar edição no banco

  // Preenche a estrutura de dados do produto com os valores dos campos de edição
  vProduto.codigo := StrToInt(edtCodigoEditar.Text);
  vProduto.descricao := edtDescricaoEditar.Text;
  vProduto.quantidade := StrToFloat(edtQtdeEditar.Text);
  vProduto.unidade := edtUndEditar.Text;
  vProduto.valor := StrToFloat(edtPrecoEditar.Text);

  // Chama o procedimento editaProdutoBD para salvar as alterações no banco de dados
  editaProdutoBD(vProduto);
end;

procedure Tfrm_produtos.sbtnSalvarInsercao(Sender: TObject);
var
  vProduto: TProduto; // Declaração de uma variável para armazenar os dados do produto a ser inserido
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
  TabControl1.TabIndex := 0; // Define o índice da guia ativa do componente TabControl1 como 0
end;


procedure Tfrm_produtos.sbtn_pesquisarClick(Sender: TObject);
begin
  //Chama método de atualizar lista

  filtroPesquisa.ItemIndex := 0; // Define o índice do filtro de pesquisa como 0 (possivelmente redefinindo para o padrão)

  if filtroPesquisa.Items[filtroPesquisa.ItemIndex] = 'Descricao' then
  begin
    atualizaConsultaBD; // Chama o método para atualizar a lista de produtos baseada na descrição
  end
  else if filtroPesquisa.Items[filtroPesquisa.ItemIndex] = 'Preço' then
  begin
    atualizaConsultaPrecoBD; // Chama o método para atualizar a lista de produtos baseada no preço
  end;
end;

procedure Tfrm_produtos.sbtn_voltarClick(Sender: TObject);
begin
    frm_produtos.Close; // Fecha o formulário atual (provavelmente o formulário de produtos)
end;

end.
