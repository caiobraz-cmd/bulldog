🍔 Bull Dogs Lanches - Sistema de Gestão e Delivery

Este é um aplicativo de gestão de pedidos e controle de estoque para a lanchonete "Bull Dogs Lanches", desenvolvido como um Projeto Integrador para o curso de Análise e Desenvolvimento de Sistemas.

1. Contexto do Projeto

A lanchonete, atualmente, gerencia seu estoque e pedidos de forma manual através de planilhas. Este método causa erros, como a venda de produtos que estão sem ingredientes no estoque, e dificulta a geração de relatórios de vendas.

O objetivo deste sistema é automatizar o controle de saída de produtos (ingredientes) do estoque, fornecer um fluxo de pedidos completo para o cliente e gerar relatórios estratégicos para o administrador.

2. Stack de Tecnologia

Frontend (Mobile & Web): Flutter

Linguagem: Dart

Gerenciamento de Estado: Provider

Backend (API & Banco de Dados): Oracle APEX

Comunicação: Pacote http (REST API)

3. Funcionalidades Implementadas

O aplicativo é dividido em dois principais fluxos de usuário: Cliente e Administrador.

👤 Fluxo do Cliente

O cliente tem um fluxo completo de pedido, desde a visualização dos produtos até a finalização:

Tela de Abertura (Splash Screen): Uma animação de entrada suave com a logo da marca.

Login e Registro: Autenticação do cliente contra o banco de dados Oracle APEX.

Home (Cardápio): Visualização de todos os produtos (lanches) disponíveis, com busca de dados da API.

Adicionais: Um dialog modal permite ao cliente customizar seu lanche com ingredientes extras.

Fluxo "Vamos Nessa?": Um atalho para compra rápida de um único item.

Carrinho de Compras: Um modal que resume os itens, permite remoção e cálculo do total.

Tela de Endereço: Coleta o endereço de entrega e observações (ex: "casa de esquina").

Tela de Revisão: Uma tela de conferência final onde o cliente vê o endereço e um carrossel dos seus itens (com campo de observação individual) antes de pagar.

Tela de Pagamento: Exibe o total e as opções de pagamento (Pix, Cartão, Dinheiro) e finaliza o pedido com um dialog de sucesso.

🔑 Painel do Administrador

O administrador possui um painel focado na gestão do negócio (o foco principal do PDF):

Login Diferenciado: O admin é autenticado e redirecionado para a rota /admin.

Dashboard (Painel): Um menu central para navegar entre as funções de gerenciamento.

Gerenciamento de Produtos:

Listagem: O admin vê a lista completa de produtos cadastrados.

Criação e Edição: Um formulário unificado (AdminProductEditScreen) permite ao admin cadastrar novos produtos ou editar existentes. (A UI está pronta para ser conectada ao http.post e http.put).

Tela de Relatórios:

Filtro por Período: Permite ao admin selecionar datas ("De:" e "Até:") para filtrar relatórios.

Histórico de Saídas: Exibe uma tabela (atualmente com dados simulados) dos produtos que saíram do estoque, conforme solicitado no PDF.

4. Estrutura do Projeto (Simplificada)

O código-fonte está organizado da seguinte maneira:

lib/
├── models/         # (Contém product.dart, cart_item.dart, etc.)
├── pages/
│   ├── admin/      # (Telas exclusivas do admin)
│   ├── checkout_screen.dart
│   ├── home_page.dart
│   ├── login_page.dart
│   ├── payment_screen.dart
│   ├── register_screen.dart
│   ├── review_order_screen.dart
│   └── splash_screen.dart
├── providers/      # (Contém cart_provider.dart para gestão de estado)
├── services/       # (Contém api_service.dart e product_service.dart)
├── widgets/        # (Contém product_card.dart, cart_modal.dart, etc.)
└── main.dart       # (Ponto de entrada, configuração do Tema e Rotas)

5. Como Executar
Clone este repositório.

Abra o projeto no VS Code (ou Android Studio).

Execute flutter pub get no terminal para baixar as dependências (http, provider, google_fonts).

Pressione F5 ou execute flutter run para iniciar o aplicativo no emulador ou navegador (Web).

6. Agradecimentos
Gostaríamos de agradecer ao Professor Vinícius pela orientação fundamental na escolha das tecnologias (especialmente Flutter e Oracle APEX) e pelo apoio na estruturação do banco de dados e da arquitetura do projeto.

7. Autores
Caio Braz

Osvaldo Mazoni Neto