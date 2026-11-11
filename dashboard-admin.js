(function () {
  // Solo entra el administrador que inició sesión
  const usuario = JSON.parse(sessionStorage.getItem('helpsyUsuario') || 'null');
  if (!usuario || usuario.rol !== 'Administrador') {
    window.location.replace('inicio.html');
    return;
  }

  document.getElementById('uNombre').textContent = usuario.nombre;
  document.getElementById('uDatos').textContent = 'C.C. ' + usuario.cedula + ' · ' + usuario.rol;

  // Cerrar sesión
  document.getElementById('btnSalir').addEventListener('click', () => {
    sessionStorage.removeItem('helpsyUsuario');
    window.location.href = 'inicio.html';
  });

  // Notificaciones
  const btnBell = document.getElementById('btnBell');
  const pop = document.getElementById('popNotif');
  function cerrarPop() { pop.hidden = true; btnBell.setAttribute('aria-expanded', 'false'); }
  btnBell.addEventListener('click', (e) => {
    e.stopPropagation();
    const abrir = pop.hidden;
    pop.hidden = !abrir;
    btnBell.setAttribute('aria-expanded', String(abrir));
  });
  document.addEventListener('click', cerrarPop);
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape') cerrarPop(); });

  // Carga de datos reciente
  const input = document.getElementById('inputArchivo');
  const lista = document.getElementById('listaArchivos');
  const vacio = document.getElementById('vacio');
  document.getElementById('btnCargar').addEventListener('click', () => input.click());
  input.addEventListener('change', () => {
    Array.from(input.files).forEach((f) => {
      const li = document.createElement('li');
      const nombre = document.createElement('span');
      const peso = document.createElement('small');
      nombre.textContent = f.name;
      peso.textContent = Math.max(1, Math.round(f.size / 1024)) + ' KB';
      li.append(nombre, peso);
      lista.prepend(li);
    });
    if (lista.children.length) { vacio.hidden = true; lista.hidden = false; }
    input.value = '';
  });
})();