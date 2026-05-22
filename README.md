# Cliente Mobile

Cliente Mobile e um mini CRM offline feito com Flutter e Dart. O app foi pensado para pequenos empreendedores, autonomos e freelancers que precisam organizar clientes e servicos de forma simples, sem depender de internet, planilhas ou conversas perdidas no WhatsApp.

## Objetivo

O projeto nasceu a partir de uma especificacao academica de um aplicativo mobile de gestao de clientes. A proposta original usava React Native, API em Node.js e MongoDB em nuvem. Nesta versao, o projeto foi adaptado para Flutter com funcionamento local/offline usando SQLite.

## Funcionalidades

- Cadastro, edicao e exclusao de clientes.
- Cadastro, edicao e exclusao de servicos.
- Vinculo de servicos a clientes.
- Status de servico: pendente, em andamento e concluido.
- Confirmacao ao alterar um servico ja concluido.
- Busca de clientes por nome ou telefone.
- Busca de servicos por titulo.
- Filtro de servicos por status e por cliente.
- Dashboard com resumo dos servicos.
- Tela de metricas com valores e progresso por status.
- Tema claro e escuro.
- Interface em portugues e ingles.
- Armazenamento local com SQLite.

## Tecnologias

- Flutter
- Dart
- SQLite
- sqflite
- Material Design

## Estrutura do Projeto

```text
lib/
  app/
  core/
  data/
  features/
```

`app/` contem a configuracao principal do aplicativo, tema e navegacao.

`core/` contem constantes, textos, formatadores e widgets reutilizaveis.

`data/` contem banco local, models, repositories e controller de dados.

`features/` contem as telas principais: Home, Clientes, Servicos, Metricas e Configuracoes.

## Como Rodar

Clone o repositorio, entre na pasta do projeto e execute:

```powershell
flutter pub get
flutter run
```

Se o Flutter nao estiver no PATH, use o caminho completo do SDK instalado na maquina.

## Status

MVP funcional concluido.

O app ja permite cadastrar clientes, cadastrar servicos, vincular servicos a clientes, editar, excluir, filtrar e visualizar metricas usando armazenamento local.
