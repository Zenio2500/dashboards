// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// -> Gráfico Pizza
window.addEventListener('load', function() {

    var ctx = document.getElementById('tasks').getContext("2d");; // Obtendo o elemento 'canva'
    //ctx.height = 250;
    var todo = parseInt(document.getElementById('TDT').classList); // Obtendo a quantidade de ToDoTasks no dashboard
    //document.getElementById('TDT').innerText = todo

    var inprogress = parseInt(document.getElementById('IPT').classList); // Obtendo a quantidade de InProgressTasks no dashboard
    //document.getElementById('IPT').innerText = inprogress

    var finished = parseInt(document.getElementById('FT').classList); // Obtendo a quantidade de FinishedTasks no dashboard
    //document.getElementById('FT').innerText = finished

    //var totalTasks = todo+inprogress+finished;

    var myGraph = new Chart(ctx, {
      type: 'pie',
      data: {
        labels: ['Tarefas a Fazer', 'Tarefas em Progresso', 'Tarefas Concluídas'],
        datasets: [{
          label: 'Quantidade',
          data: [todo, inprogress, finished],
          backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)'
          ],
          borderColor: [
            'rgba(255, 99, 132, 1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)'
          ],
          borderWidth: 1
        }]
      }
    });

});


//-> Posição dos elementos em pixels

// Obtém a referência da coluna 'progresso'
var reference = document.getElementById('progress');

// Função para obter a posição da coluna 'progresso'
function getPositionReference(reference) {
    var position = reference.getBoundingClientRect();
    return {
        top: position.top + window.scrollY,
        left: position.left + window.scrollX
    };
}

// Atualiza a posição da coluna 'progresso'(posição de referência)
function refreshPositionReference() {
    var positionReference = getPositionReference(reference);
    //document.getElementById('pos').innerText = 'Topo: ' + positionReference.top + 'px, Esquerda: ' + positionReference.left + 'px' + '\n';

    // Seleciona todos os elementos 'ancoras'
    var as = document.querySelectorAll('a');
    // Para armazenar o id do dashboard
    var dashboardID;

    // Itera sobre os elementos input
    as.forEach(function(a) {
    // Obtém o id do elemento 'lista de dashboards', isto é, o id do dashboard
      if (a.id > 0){
        //document.getElementById('pos').innerText += 'ID do dashboard:' + a.id + "\n";
        dashboardID = a.id;
      }
    });

    // Enviar dados para o controlador do dashboard usando AJAX
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/save_reference', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader("X-CSRF-Token", token);
    xhr.send(JSON.stringify({ reference: positionReference.left, dashboard: dashboardID }));
}

// Chama a função para atualizar a posição de referência(coluna 'progresso') quando a página for carregada
window.addEventListener('load', function() {
    refreshPositionReference();
});

// Chama a função para atualizar a posição de referência(coluna 'progresso') quando a janela for redimensionada
window.addEventListener('resize', function() {
    refreshPositionReference();
});

//-> Tratamento do "arrastar e soltar"
const columns = document.querySelectorAll(".column");
  
document.addEventListener("dragstart", (e) => {
    e.target.classList.add("dragging");
});
  
// Atualizar o banco de dados dependendo de onde a tarefa foi solta('dropada')
document.addEventListener("dragend", (e) => {
    e.target.classList.remove("dragging");
    refreshPositionReference();
    refreshDataBase();
    window.location.reload();
});
  
columns.forEach((item) => {
    item.addEventListener("dragover", (e) => {
      const dragging = document.querySelector(".dragging");
      const applyAfter = getNewPosition(item, e.clientY);

      if (applyAfter) {
        applyAfter.insertAdjacentElement("afterend", dragging);
      } else {
        item.prepend(dragging);
      }
    });
});
  
function getNewPosition(column, posY) {
    const cards = column.querySelectorAll(".item:not(.dragging)");
    let result;

    for (let refer_card of cards) {
      const box = refer_card.getBoundingClientRect();
      const boxCenterY = box.y + box.height / 2;

      if (posY >= boxCenterY) result = refer_card;
    }

    return result;
}

//-> Tratamento no Banco de Dados
function refreshDataBase() {
    // Seleciona todos os elementos input
    var inputs = document.querySelectorAll('input');

    // Seleciona todos os elementos 'ancoras'
    var as = document.querySelectorAll('a');
    // Para armazenar o id do dashboard
    var dashboardID;

    // Itera sobre os elementos input
    as.forEach(function(a) {
      // Obtém o id do elemento 'lista de dashboards', isto é, o id do dashboard
      if (a.id > 0){
        //document.getElementById('pos').innerText += 'ID do dashboard:' + a.id + "\n";
        dashboardID = a.id;
      }
    });

    // Enviar dados para o servidor Ruby on Rails usando AJAX
    var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    var xhr = new XMLHttpRequest();

    // Itera sobre os elementos input
    inputs.forEach(function(input) {
    // Obtém o value(nome da tarefa) de cada elemento input do tipo 'submit' e envia para o controlador do dashboard
      if (input.type == 'submit'){
        xhr.open('POST', '/change_tasks', true);
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.setRequestHeader("X-CSRF-Token", token);
        //document.getElementById('pos').innerText += 'ID do elemento input:' + input.value + 'PosX: ' + input.getBoundingClientRect().left + "\n";
        xhr.send(JSON.stringify({ task: input.value, posX: input.getBoundingClientRect().left, dashboard: dashboardID }));
      }
    });
}