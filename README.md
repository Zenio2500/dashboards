# dashboards

Este é um projeto composto, principalmente, por um conjunto de diagramas UML e uma plataforma desenvolvida com Ruby on Rails.

Para o desenvolvimento dos diagramas de classes, foi preciso, à priori, estabelecer os principais casos de uso, que são:

    1. Cadastro;
    2. Edição de Perfil;
    3. Exclusão de Perfil;
    4. Criação de Dashboard;
    5. Edição de Dashboard;
    6. Exclusão de Dashboard;
    7. Adição de Tarefas à Fazer;
    8. Edição de Tarefas à Fazer (Renomear);
    9. Remoção de Tarefas à Fazer;
    10. Adição de Tarefas em Progresso;
    11. Edição de Tarefas em Progresso (Renomear);
    12. Remoção de Tarefas em Progresso;
    13. Adição de Tarefas Concluídas;
    14. Edição de Tarefas Concluídas (Renomear);
    15. Edição de Tarefas Concluídas (Alterar a Data de Conclusão);
    16. Remoção de Tarefas Concluídas.

Após estabelecer os casos de uso, um diagrama de casos de uso foi feito, mas, diferentemente do comum, não foi feito um documento de fluxo de eventos.

Para cada caso de uso, foi desenvolvido um diagrama de sequências e, posteriormente, um diagrama de classes para cada um dos casos de uso. Porém, durante o desenvolvimento do sistema, foi notado que Rails possui diversos ‘casamentos de nomes’, além de cada tela (arquivos ‘.html.erb’) estar associada a um método dentro de um ‘controller’, em vez de ter seu próprio ‘controller’, como imaginado durante o desenvolvimento dos diagramas de sequência e, consequentemente, de classes. Portanto, criou-se um outro diagrama de classes, mais consonante com o funcionamento do sistema desenvolvido, em Ruby on Rails.

Vale ressaltar que é preciso usar o aplicativo [Astah UML](https://astah.net/downloads/) para abrir o arquivo dos diagramas UML.

Em se tratando da plataforma, seguem as dependências abaixo:

    1. ruby "3.2.2"; (tutorial de instalação: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-20-04)
    2. gem "rails", "~> 7.1.2";
    3. gem "sprockets-rails";
    4. gem "pg", "~> 1.1";
    5. gem "puma", ">= 5.0";
    6. gem "importmap-rails";
    7. gem "turbo-rails";
    8. gem "stimulus-rails";
    9. gem "jbuilder";
    10. gem "bcrypt", "~> 3.1.7";
    11. gem "tzinfo-data";
    12. gem 'bootstrap-sass', '~> 3.4.1';
    13. gem 'sassc-rails', '>= 2.1.0';
    14. gem "bootsnap";
    15. gem "debug";
    16. gem "web-console";
    17. gem "capybara";
    18. gem "selenium-webdriver".

É possível instalar as ‘gems’ com um comando ‘bundle install’ no terminal, no diretório do sistema (home/.../dashboards).

Para executar o sistema, basta usar o comando ‘rails server’ no diretório do sistema.

A navegação no site é bastante simples.

Na tela inicial, há a opção de cadastro e entrar. Nas duas opções, basta preencher os formulários de acordo com as limitações sinalizadas e enviar. No caso de cadastro, uma conta será criada e, no cado de entrar, o usuário acessará o ‘menu’.


O ‘menu’ possui três opções principais: ‘meus dashboards’, ‘editar perfil’ e ‘excluir perfil’. As duas últimas opções envolvem uma confirmação de usuário, então será preciso validar o acesso a partir dos ‘e-mail’ e ‘senha’ corretos para, então, acessar as páginas de interesse.

A página de ‘editar perfil’ possui um formulário igual ao de cadastro, então deve-se preencher as informações novas e enviar. Por outro lado, a página de ‘excluir perfil’ só possui um botão, isto é, basta clicar nele para a conta ser excluída.

A página ‘meus dashboards’ permite ao usuário a criação de um novo ‘dashboard’, pelo botão maior na página. É possível, também, clicar num dos ‘dashboards’ e excluí-los por meio de um botão ‘excluir’.

Na página de cada dashboard, há três colunas escuras(tarefas à fazer, em progresso e concluídas) com um botão ‘+’ logo abaixo de cada uma. Assim, é possível acessar uma página por onde o usuário escreve um nome para a tarefa e a cria. Em seguida, é possível visualizar a tarefa na coluna correspondente com um ‘botão lixeira’ ao lado do nome da tarefa, para exclusão. E, para passar uma tarefa para uma coluna diferente, basta arrastar para a coluna de interesse, mas vale salientar que não foi usado ‘sortablejs’ para este fim, foi usada uma forma mais rudimentar, por isso pode haver alguns problemas com o ‘arrastar e soltar’ de uma coluna para a outra.

A forma rudimentar usada foi a obtenção, a cada carregamento da página, da posição no eixo x, em pixels, da coluna do meio (tarefas em progresso). E, também, a posição de cada tarefa é obtida de forma a se saber se a mesma está numa posição mais à esquerda da coluna do meio (tarefas à fazer), ou bem mais à direita da coluna do meio (+500px de diferença) .


Vale ressaltar que é possível ir para a página, que permite editar o nome (e a data no caso de tarefas concluídas) de cada tarefa, ao clicar em seu respectivo nome. Por fim, há um gráfico ‘pizza’, que indica a ‘fatia’ de cada tipo de tarefa no dashboard, e um gráfico de linha, que indica a quantidade de tarefas concluídas de acordo com as datas de conclusão. Ambos os gráficos foram feitos com ‘chartjs’.

O código está bastante comentado na parte do ‘javascript’.

A persistência dos dados foi feita com ‘postgresql’.

