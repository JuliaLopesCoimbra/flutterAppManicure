📋 Sobre o Sistema
Este sistema é uma aplicação Flutter desenvolvida para gerenciar agendamentos entre clientes e manicures de forma simples e eficiente.

🖥 Funcionalidades principais:
Tela de Login

Você pode se conectar como manicure ou cliente.
imagem 1
Se ainda não tiver uma conta, pode se registrar rapidamente.

Tela de Registro

Cadastro de nome, e-mail, senha, CPF, sexo, idade e endereço completo.
imagem 2
O preenchimento do endereço é facilitado com a busca automática de dados pelo CEP, usando integração com a API ViaCEP.
imagem 3
imagem 4
Fluxo de Agendamento

Após o login, o cliente pode visualizar as manicures disponíveis e reservar um horário.
imagem 5
imagem 6
A manicure pode visualizar as reservas recebidas e confirmar ou não os horários solicitados.
imagem 7
Quando o horário é confirmado, o cliente é notificado que seu agendamento foi aprovado.
imagem 8
🚀 Tecnologias utilizadas
Flutter

Firebase Authentication (Login e Registro)

ViaCEP API (Busca automática de endereço via CEP)

HTTP Package para consumo da API

🎯 Resumo do fluxo
Login ou Registro

Cadastro com busca de endereço automático

Cliente reserva horário com manicure

Manicure confirma o horário

Cliente recebe a confirmação

📦 Como instalar e rodar o projeto
Pré-requisitos
Flutter instalado 

Conta no Firebase

Criar um projeto no Firebase e adicionar as configurações no app (já configurado no main.dart).

Adicionar dependências no pubspec.yaml.

Instalação
Clone o repositório:

bash
Copiar
Editar
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
Instale as dependências:

bash
Copiar
Editar
flutter pub get
Conecte um dispositivo ou emulador Android/iOS e execute:

bash
Copiar
Editar
flutter run
Configurações importantes
As credenciais do Firebase já devem estar configuradas no arquivo main.dart.

Certifique-se que o pacote http está adicionado ao pubspec.yaml:

yaml
Copiar
Editar
dependencies:
  http: ^1.1.0
📱 Fluxo de uso do app
Acesse a tela de login.

Se não tiver conta, clique em "Registrar-se".

Preencha seu cadastro:

Insira o CEP para preencher automaticamente seu endereço.

Escolha se é Manicure ou Cliente.

Após o cadastro:

Clientes conseguem reservar horários.

Manicures podem confirmar os agendamentos feitos.

O sistema atualiza o status de pendente para confirmado automaticamente.
