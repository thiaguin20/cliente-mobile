enum AppLanguage { pt, en }

class AppStrings {
  const AppStrings(this.language);

  final AppLanguage language;

  bool get isPortuguese => language == AppLanguage.pt;

  String get appName => 'Cliente Mobile';
  String get home => isPortuguese ? 'Home' : 'Home';
  String get clients => isPortuguese ? 'Clientes' : 'Clients';
  String get services => isPortuguese ? 'Serviços' : 'Services';
  String get metrics => isPortuguese ? 'Métricas' : 'Metrics';
  String get settings => isPortuguese ? 'Configurações' : 'Settings';
  String get settingsTab => isPortuguese ? 'Ajustes' : 'Settings';
  String get todayOverview => isPortuguese ? 'Visão do dia' : 'Today overview';
  String get welcomeTitle =>
      isPortuguese ? 'Organize seus atendimentos' : 'Organize your work';
  String get welcomeSubtitle => isPortuguese
      ? 'Acompanhe clientes, serviços e valores em um só lugar.'
      : 'Track customers, services, and values in one place.';
  String get pending => isPortuguese ? 'Pendente' : 'Pending';
  String get inProgress => isPortuguese ? 'Em andamento' : 'In progress';
  String get completed => isPortuguese ? 'Concluído' : 'Completed';
  String get expectedValue =>
      isPortuguese ? 'Valor previsto' : 'Expected value';
  String get quickActions => isPortuguese ? 'Ações rápidas' : 'Quick actions';
  String get newClient => isPortuguese ? 'Novo cliente' : 'New client';
  String get newService => isPortuguese ? 'Novo serviço' : 'New service';
  String get seePending => isPortuguese ? 'Ver pendentes' : 'See pending';
  String get todayServices =>
      isPortuguese ? 'Serviços de hoje' : 'Today services';
  String get priorityList => isPortuguese ? 'Prioridades' : 'Priorities';
  String get searchClients =>
      isPortuguese ? 'Buscar clientes' : 'Search clients';
  String get searchServices =>
      isPortuguese ? 'Buscar serviços' : 'Search services';
  String get customerDetail =>
      isPortuguese ? 'Detalhe do cliente' : 'Customer detail';
  String get linkedServices =>
      isPortuguese ? 'Serviços vinculados' : 'Linked services';
  String get notes => isPortuguese ? 'Observações' : 'Notes';
  String get totalByCustomer =>
      isPortuguese ? 'Total do cliente' : 'Customer total';
  String get lastUpdate => isPortuguese ? 'Última atualização' : 'Last update';
  String get serviceFilters => isPortuguese ? 'Filtros' : 'Filters';
  String get all => isPortuguese ? 'Todos' : 'All';
  String get monthlyResult =>
      isPortuguese ? 'Resultado do mês' : 'Monthly result';
  String get totalServices =>
      isPortuguese ? 'Total de serviços' : 'Total services';
  String get completedValue =>
      isPortuguese ? 'Valor concluído' : 'Completed value';
  String get pendingValue => isPortuguese ? 'Valor pendente' : 'Pending value';
  String get servicesByStatus =>
      isPortuguese ? 'Serviços por status' : 'Services by status';
  String get appearance => isPortuguese ? 'Aparência' : 'Appearance';
  String get languageText => isPortuguese ? 'Idioma' : 'Language';
  String get light => isPortuguese ? 'Claro' : 'Light';
  String get dark => isPortuguese ? 'Escuro' : 'Dark';
  String get system => isPortuguese ? 'Sistema' : 'System';
  String get portuguese => isPortuguese ? 'Português' : 'Portuguese';
  String get english => isPortuguese ? 'Inglês' : 'English';
  String get localData => isPortuguese ? 'Dados locais' : 'Local data';
  String get exportBackup => isPortuguese ? 'Exportar backup' : 'Export backup';
  String get clearData => isPortuguese ? 'Limpar dados' : 'Clear data';
  String get appInfo => isPortuguese ? 'Sobre o app' : 'About the app';
  String get offlineInfo => isPortuguese
      ? 'Primeira versão offline com dados salvos no aparelho.'
      : 'First offline version with data stored on the device.';
  String get noCustomersTitle =>
      isPortuguese ? 'Nenhum cliente cadastrado' : 'No clients yet';
  String get noCustomersDescription => isPortuguese
      ? 'Cadastre o primeiro cliente para começar a registrar serviços.'
      : 'Add the first client to start tracking services.';
  String get noServicesTitle =>
      isPortuguese ? 'Nenhum serviço cadastrado' : 'No services yet';
  String get noServicesDescription => isPortuguese
      ? 'Cadastre um serviço e vincule a um cliente existente.'
      : 'Add a service and link it to an existing client.';
  String get noPendingServicesTitle =>
      isPortuguese ? 'Nenhuma prioridade aberta' : 'No open priorities';
  String get noPendingServicesDescription => isPortuguese
      ? 'Serviços pendentes ou em andamento aparecerão aqui.'
      : 'Pending or in-progress services will appear here.';
  String get save => isPortuguese ? 'Salvar' : 'Save';
  String get saving => isPortuguese ? 'Salvando...' : 'Saving...';
  String get cancel => isPortuguese ? 'Cancelar' : 'Cancel';
  String get edit => isPortuguese ? 'Editar' : 'Edit';
  String get delete => isPortuguese ? 'Excluir' : 'Delete';
  String get confirm => isPortuguese ? 'Confirmar' : 'Confirm';
  String get requiredField =>
      isPortuguese ? 'Campo obrigatório' : 'Required field';
  String get invalidEmail => isPortuguese ? 'E-mail inválido' : 'Invalid email';
  String get selectCustomer =>
      isPortuguese ? 'Selecione um cliente' : 'Select a client';
  String get deleteCustomerTitle =>
      isPortuguese ? 'Excluir cliente?' : 'Delete client?';
  String get deleteCustomerMessage => isPortuguese
      ? 'Os serviços vinculados também serão excluídos.'
      : 'Linked services will also be deleted.';
  String get deleteServiceTitle =>
      isPortuguese ? 'Excluir serviço?' : 'Delete service?';
  String get deleteServiceMessage => isPortuguese
      ? 'Essa ação não pode ser desfeita.'
      : 'This action cannot be undone.';
  String get changeCompletedTitle =>
      isPortuguese ? 'Alterar serviço concluído?' : 'Change completed service?';
  String get changeCompletedMessage => isPortuguese
      ? 'Confirme para mudar o status de um serviço já concluído.'
      : 'Confirm to change the status of an already completed service.';
  String get fullName => isPortuguese ? 'Nome completo' : 'Full name';
  String get phoneWhatsapp =>
      isPortuguese ? 'Telefone / WhatsApp' : 'Phone / WhatsApp';
  String get email => isPortuguese ? 'E-mail' : 'Email';
  String get address => isPortuguese ? 'Endereço' : 'Address';
  String get city => isPortuguese ? 'Cidade' : 'City';
  String get serviceTitle =>
      isPortuguese ? 'Título do serviço' : 'Service title';
  String get linkedCustomer =>
      isPortuguese ? 'Cliente vinculado' : 'Linked customer';
  String get description => isPortuguese ? 'Descrição' : 'Description';
  String get status => isPortuguese ? 'Status' : 'Status';
  String get startDate => isPortuguese ? 'Data de início' : 'Start date';
  String get expectedEndDate => isPortuguese
      ? 'Data de conclusão prevista'
      : 'Expected completion date';
  String get value => isPortuguese ? 'Valor' : 'Value';
  String get dateHint => isPortuguese ? 'dd/mm/aaaa' : 'dd/mm/yyyy';
  String get invalidDate => isPortuguese ? 'Data inválida' : 'Invalid date';
  String get duplicatedCustomer => isPortuguese
      ? 'Já existe um cliente com esse e-mail ou telefone.'
      : 'A client with this email or phone already exists.';
  String get filterByCustomer =>
      isPortuguese ? 'Filtrar por cliente' : 'Filter by client';
  String get requiredLabel => isPortuguese ? 'Obrigatório' : 'Required';
  String get optionalLabel => isPortuguese ? 'Opcional' : 'Optional';
  String get mainInfo => isPortuguese ? 'Dados principais' : 'Main info';
  String get contactInfo => isPortuguese ? 'Contato' : 'Contact';
  String get serviceInfo => isPortuguese ? 'Dados do serviço' : 'Service info';
  String get scheduleInfo => isPortuguese ? 'Prazo e valor' : 'Schedule and value';
  String get deleteThisCustomer =>
      isPortuguese ? 'Excluir este cliente' : 'Delete this client';
  String get deleteThisService =>
      isPortuguese ? 'Excluir este serviço' : 'Delete this service';

  String statusLabel(String statusKey) {
    return switch (statusKey) {
      'pending' => pending,
      'inProgress' => inProgress,
      'completed' => completed,
      _ => statusKey,
    };
  }
}
