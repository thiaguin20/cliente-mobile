# Cliente Mobile

Mini CRM mobile offline desenvolvido em Flutter e Dart. O app organiza clientes e serviços sem depender de internet, usando banco local com SQLite.

## Demonstração

<video src="assets/demo.mp4" controls muted></video>

Se o vídeo não aparecer no GitHub, acesse diretamente: [assets/demo.mp4](assets/demo.mp4).

## Funcionalidades

- Cadastro, edição e exclusão de clientes.
- Cadastro, edição e exclusão de serviços.
- Vínculo de serviços a clientes.
- Status de serviço: pendente, em andamento e concluído.
- Busca de clientes por nome ou telefone.
- Busca de serviços por título.
- Filtro de serviços por status e por cliente.
- Dashboard com resumo dos serviços.
- Tela de métricas com valores e progresso por status.
- Tema claro e escuro.
- Interface em português e inglês.
- Armazenamento local offline com SQLite.

## Tecnologias

- Flutter
- Dart
- SQLite
- sqflite
- Material Design

## Estrutura

```text
lib/
  app/
  core/
  data/
  features/
```

- `app`: configuração principal, tema e navegação.
- `core`: constantes, textos, formatadores e widgets reutilizáveis.
- `data`: banco local, models, repositories e controller de dados.
- `features`: telas de clientes, serviços, métricas e configurações.

## Como rodar

```powershell
flutter pub get
flutter run
```

## Status

MVP funcional concluído. Foi meu primeiro app Flutter/Dart com foco em uso real offline.
