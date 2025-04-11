async function fetchTasks() {
  const response = await fetch('/tasks');
  const tasks = await response.json();
  const taskList = document.getElementById('taskList');
  taskList.innerHTML = '';

  tasks.forEach(task => {
    const li = document.createElement('li');
    li.textContent = task.task;
    taskList.appendChild(li);
    const deleteButton = document.createElement('button');
    deleteButton.textContent = 'Supprimer';
    deleteButton.classList.add('delete-button');
    deleteButton.addEventListener('click', async () => {
      await deleteTask(task.id); 
      fetchTasks(); 
    });
    li.appendChild(deleteButton);
    taskList.appendChild(li);
  });
}

async function deleteTask(taskId) {
  const response = await fetch(`/tasks/${taskId}`, {
    method: 'DELETE',
  });

  if (!response.ok) {
    alert('Erreur lors de la suppression de la tâche');
  }
}

document.getElementById('addTaskForm').addEventListener('submit', async function (e) {
  e.preventDefault();
  const task = document.getElementById('taskInput').value;

  const response = await fetch('/add', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ task }),
  });

  if (response.ok) {
    fetchTasks();
  } else {
    alert('Error adding task');
  }
});

fetchTasks();