// Usuarios de prueba (solo para el prototipo; luego esto lo valida el backend con PostgreSQL)
const USUARIOS = [
  { nombre: 'Carlos Ruiz',   rol: 'Administrador', cedula: '10203040', clave: 'Admin2026', destino: 'dashboard-admin.html' },
  { nombre: 'Laura Mejía',   rol: 'Especialista',  cedula: '20304050', clave: 'Espe2026',  destino: 'especialista.html' },
  { nombre: 'Camila Torres', rol: 'Paciente',      cedula: '30405060', clave: 'Paci2026',  destino: 'paciente.html' },
  { nombre: 'Marta Rojas',   rol: 'Tutor',         cedula: '40506070', clave: 'Tuto2026',  destino: 'tutor.html' }
];

const form      = document.getElementById('loginForm');
const inCedula  = document.getElementById('cedula');
const inClave   = document.getElementById('clave');
const selRol    = document.getElementById('rol');
const btnEntrar = document.getElementById('btnEntrar');
const btnVer    = document.getElementById('verClave');
const errForm   = document.getElementById('formError');
const demoBody  = document.getElementById('demoBody');

/* ---------- Mostrar / ocultar contraseña ---------- */
btnVer.addEventListener('click', () => {
  const visible = inClave.type === 'text';
  inClave.type = visible ? 'password' : 'text';
  btnVer.textContent = visible ? 'Ver' : 'Ocultar';
  btnVer.setAttribute('aria-pressed', String(!visible));
  btnVer.setAttribute('aria-label', visible ? 'Mostrar contraseña' : 'Ocultar contraseña');
});

/* ---------- Solo números en la cédula ---------- */
inCedula.addEventListener('input', () => {
  inCedula.value = inCedula.value.replace(/\D/g, '');
});

/* ---------- Tabla de credenciales de prueba ---------- */
USUARIOS.forEach((u) => {
  const fila = document.createElement('tr');
  [u.nombre, u.rol, u.cedula, u.clave].forEach((texto) => {
    const celda = document.createElement('td');
    celda.textContent = texto;
    fila.appendChild(celda);
  });

  const celdaAccion = document.createElement('td');
  const usar = document.createElement('button');
  usar.type = 'button';
  usar.className = 'use';
  usar.textContent = 'Usar';
  usar.addEventListener('click', () => {
    inCedula.value = u.cedula;
    inClave.value = u.clave;
    selRol.value = u.rol;
    limpiarErrores();
    inClave.focus();
  });
  celdaAccion.appendChild(usar);
  fila.appendChild(celdaAccion);
  demoBody.appendChild(fila);
});

/* ---------- Validación ---------- */
function mostrarError(input, idError, mensaje) {
  document.getElementById(idError).textContent = mensaje;
  input.setAttribute('aria-invalid', 'true');
}

function limpiarErrores() {
  ['cedulaError', 'claveError', 'rolError'].forEach((id) => { document.getElementById(id).textContent = ''; });
  [inCedula, inClave, selRol].forEach((el) => el.removeAttribute('aria-invalid'));
  errForm.textContent = '';
}

function validar() {
  let valido = true;
  limpiarErrores();

  if (inCedula.value.trim() === '') {
    mostrarError(inCedula, 'cedulaError', 'Escribe tu número de cédula.');
    valido = false;
  } else if (inCedula.value.length < 6) {
    mostrarError(inCedula, 'cedulaError', 'La cédula debe tener entre 6 y 10 números.');
    valido = false;
  }

  if (inClave.value === '') {
    mostrarError(inClave, 'claveError', 'Escribe tu contraseña.');
    valido = false;
  } else if (inClave.value.length < 6) {
    mostrarError(inClave, 'claveError', 'La contraseña debe tener al menos 6 caracteres.');
    valido = false;
  }

  if (selRol.value === '') {
    mostrarError(selRol, 'rolError', 'Selecciona tu rol.');
    valido = false;
  }

  return valido;
}

/* ---------- Envío del formulario ---------- */
form.addEventListener('submit', (evento) => {
  evento.preventDefault();
  if (!validar()) return;

  const usuario = USUARIOS.find((u) =>
    u.cedula === inCedula.value.trim() &&
    u.clave === inClave.value &&
    u.rol === selRol.value
  );

  if (!usuario) {
    errForm.textContent = 'Cédula, contraseña o rol incorrectos. Revísalos e inténtalo de nuevo.';
    inClave.select();
    return;
  }

  // Guarda la sesión mientras la pestaña esté abierta
  sessionStorage.setItem('helpsyUsuario', JSON.stringify({
    nombre: usuario.nombre,
    rol: usuario.rol,
    cedula: usuario.cedula
  }));

  btnEntrar.disabled = true;
  btnEntrar.textContent = 'Entrando…';
  window.location.href = usuario.destino;
});