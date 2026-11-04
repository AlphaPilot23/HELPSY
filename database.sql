-- =====================================================
-- Helpsy - Módulo 1: usuarios, perfiles y consentimientos
-- Base de datos: helpsy_db (PostgreSQL)
-- Evidencia GA6-220501096-AA2-EV02
-- =====================================================

-- 1. TABLA PADRE (no depende de ninguna)
CREATE TABLE IF NOT EXISTS usuario (
    id                INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre            VARCHAR(100) NOT NULL,
    correo            VARCHAR(150) NOT NULL UNIQUE,
    contrasena_hash   VARCHAR(255) NOT NULL,
    estado            VARCHAR(20)  NOT NULL DEFAULT 'activo',
    correo_verificado BOOLEAN      NOT NULL DEFAULT FALSE,
    fecha_registro    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    rol               VARCHAR(20)  NOT NULL,
    CONSTRAINT chk_usuario_estado CHECK (estado IN ('activo', 'inactivo', 'suspendido')),
    CONSTRAINT chk_usuario_rol CHECK (rol IN ('paciente', 'especialista', 'administrador', 'tutor'))
);

select *from usuario

-- 2. PERFILES (relación 1 a 1 con usuario)
CREATE TABLE IF NOT EXISTS perfil_paciente (
    id               INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id       INT  NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    CONSTRAINT fk_perfil_paciente_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id) ON DELETE CASCADE
);

SELECT * FROM perfil_paciente;

CREATE TABLE IF NOT EXISTS tutor (
    id                INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id        INT         NOT NULL UNIQUE,
    numero_identidad  VARCHAR(30) NOT NULL UNIQUE,
    telefono          VARCHAR(20),
    CONSTRAINT fk_tutor_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id) ON DELETE CASCADE
);

SELECT * FROM tutor;

CREATE TABLE IF NOT EXISTS perfil_especialista (
    id                   INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id           INT          NOT NULL UNIQUE,
    titulo               VARCHAR(100) NOT NULL,
    registro_profesional VARCHAR(50)  NOT NULL UNIQUE,
    estado_verificacion  VARCHAR(20)  NOT NULL DEFAULT 'pendiente',
    presentacion         TEXT,
    CONSTRAINT fk_perfil_especialista_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id) ON DELETE CASCADE,
    CONSTRAINT chk_especialista_verificacion
        CHECK (estado_verificacion IN ('pendiente', 'verificado', 'rechazado'))
);

SELECT * FROM perfil_especialista;

CREATE TABLE IF NOT EXISTS perfil_administrador (
    id           INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id   INT         NOT NULL UNIQUE,
    nivel_acceso VARCHAR(20) NOT NULL,
    cargo        VARCHAR(100),
    CONSTRAINT fk_perfil_administrador_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id) ON DELETE CASCADE
);

SELECT * FROM perfil_administrador

-- 3. TABLAS DE USUARIO (relación 1 a muchos con usuario)
CREATE TABLE IF NOT EXISTS notificacion (
    id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id INT         NOT NULL,
    tipo       VARCHAR(50) NOT NULL,
    contenido  TEXT        NOT NULL,
    leida      BOOLEAN     NOT NULL DEFAULT FALSE,
    fecha      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notificacion_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id) ON DELETE CASCADE
);

SELECT * FROM notificacion;

CREATE TABLE IF NOT EXISTS auditoria_acceso (
    id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id INT          NOT NULL,
    recurso    VARCHAR(100) NOT NULL,
    accion     VARCHAR(50)  NOT NULL,
    fecha      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id)
);

SELECT * FROM auditoria_acceso;

CREATE TABLE IF NOT EXISTS consentimiento (
    id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id INT         NOT NULL,
    tipo       VARCHAR(50) NOT NULL,
    version    VARCHAR(20) NOT NULL,
    fecha      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_consentimiento_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id) ON DELETE CASCADE
);
SELECT * FROM consentimiento;

-- 4. TABLA INTERMEDIA (depende de tutor, perfil_paciente y consentimiento)
CREATE TABLE IF NOT EXISTS tutor_paciente (
    id                 INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tutor_id           INT         NOT NULL,
    perfil_paciente_id INT         NOT NULL,
    consentimiento_id  INT         NOT NULL,
    parentesco         VARCHAR(50) NOT NULL,
    CONSTRAINT fk_tutor_paciente_tutor
        FOREIGN KEY (tutor_id) REFERENCES tutor (id) ON DELETE CASCADE,
    CONSTRAINT fk_tutor_paciente_paciente
        FOREIGN KEY (perfil_paciente_id) REFERENCES perfil_paciente (id) ON DELETE CASCADE,
    CONSTRAINT fk_tutor_paciente_consentimiento
        FOREIGN KEY (consentimiento_id) REFERENCES consentimiento (id),
    CONSTRAINT uq_tutor_paciente UNIQUE (tutor_id, perfil_paciente_id)
);

SELECT * FROM tutor_paciente;

-- 5. VERIFICACIÓN: mostrar las tablas creadas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

--HELPSY MODULO 2:

-- 1. TABLA PADRE DEL MÓDULO (no depende de ninguna)
CREATE TABLE IF NOT EXISTS categoria_atencion (
    id     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    activa BOOLEAN      NOT NULL DEFAULT TRUE
);

-- 2. TABLA INTERMEDIA (especialista <-> categoría, muchos a muchos)
CREATE TABLE IF NOT EXISTS especialista_categoria (
    id                    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categoria_atencion_id INT NOT NULL,
    perfil_especialista_id INT NOT NULL,
    CONSTRAINT fk_espcat_categoria
        FOREIGN KEY (categoria_atencion_id) REFERENCES categoria_atencion (id),
    CONSTRAINT fk_espcat_especialista
        FOREIGN KEY (perfil_especialista_id) REFERENCES perfil_especialista (id) ON DELETE CASCADE
);

-- 3. CITA (depende de paciente, especialista, categoría y tutor)
CREATE TABLE IF NOT EXISTS cita (
    id                     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    perfil_paciente_id     INT         NOT NULL,
    perfil_especialista_id INT         NOT NULL,
    categoria_atencion_id  INT         NOT NULL,
    tutor_id               INT,
    fecha                  DATE        NOT NULL,
    duracion_min           INT         NOT NULL,
    tiempo                 TIME        NOT NULL,
    estado                 VARCHAR(20) NOT NULL DEFAULT 'programada',
    CONSTRAINT fk_cita_paciente
        FOREIGN KEY (perfil_paciente_id) REFERENCES perfil_paciente (id),
    CONSTRAINT fk_cita_especialista
        FOREIGN KEY (perfil_especialista_id) REFERENCES perfil_especialista (id),
    CONSTRAINT fk_cita_categoria
        FOREIGN KEY (categoria_atencion_id) REFERENCES categoria_atencion (id),
    CONSTRAINT fk_cita_tutor
        FOREIGN KEY (tutor_id) REFERENCES tutor (id),
    CONSTRAINT chk_cita_duracion CHECK (duracion_min > 0)
);

-- 4. CONSULTA (relación 1 a 1 con cita)
CREATE TABLE IF NOT EXISTS consulta (
    id          INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cita_id     INT       NOT NULL UNIQUE,
    inicio_real TIMESTAMP,
    fin_real    TIMESTAMP,
    asistencia  BOOLEAN   NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_consulta_cita
        FOREIGN KEY (cita_id) REFERENCES cita (id) ON DELETE CASCADE
);

-- 5. VERIFICACIÓN: mostrar las tablas creadas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

--modulo 3 HELPSY

-- 1. TABLA PADRE DEL MÓDULO (depende solo de categoria_atencion)
CREATE TABLE IF NOT EXISTS instrumento_seguimiento (
    id                    INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categoria_atencion_id INT          NOT NULL,
    nombre                VARCHAR(100) NOT NULL,
    CONSTRAINT fk_instrumento_categoria
        FOREIGN KEY (categoria_atencion_id) REFERENCES categoria_atencion (id)
);

-- 2. RESULTADO DE UN INSTRUMENTO
CREATE TABLE IF NOT EXISTS resultado_instrumento (
    id                     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    instrumento_id         INT       NOT NULL,
    perfil_paciente_id     INT       NOT NULL,
    perfil_especialista_id INT       NOT NULL,
    fecha                  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    puntaje                INT       NOT NULL,
    CONSTRAINT fk_resultado_instrumento
        FOREIGN KEY (instrumento_id) REFERENCES instrumento_seguimiento (id),
    CONSTRAINT fk_resultado_paciente
        FOREIGN KEY (perfil_paciente_id) REFERENCES perfil_paciente (id),
    CONSTRAINT fk_resultado_especialista
        FOREIGN KEY (perfil_especialista_id) REFERENCES perfil_especialista (id)
);

-- 3. ACTIVIDAD (tarea que el especialista asigna al paciente)
CREATE TABLE IF NOT EXISTS actividad (
    id                     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    perfil_especialista_id INT          NOT NULL,
    perfil_paciente_id     INT          NOT NULL,
    titulo                 VARCHAR(150) NOT NULL,
    instrucciones          TEXT         NOT NULL,
    fecha_limite           DATE,
    estado                 VARCHAR(20)  NOT NULL DEFAULT 'pendiente',
    CONSTRAINT fk_actividad_especialista
        FOREIGN KEY (perfil_especialista_id) REFERENCES perfil_especialista (id),
    CONSTRAINT fk_actividad_paciente
        FOREIGN KEY (perfil_paciente_id) REFERENCES perfil_paciente (id)
);

-- 4. ALERTA DE RIESGO
CREATE TABLE IF NOT EXISTS alerta_riesgo (
    id                     INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    perfil_paciente_id     INT         NOT NULL,
    perfil_especialista_id INT         NOT NULL,
    motivo                 TEXT        NOT NULL,
    fecha                  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado                 VARCHAR(20) NOT NULL DEFAULT 'abierta',
    CONSTRAINT fk_alerta_paciente
        FOREIGN KEY (perfil_paciente_id) REFERENCES perfil_paciente (id),
    CONSTRAINT fk_alerta_especialista
        FOREIGN KEY (perfil_especialista_id) REFERENCES perfil_especialista (id)
);

-- 5. REGISTRO EMOCIONAL (diario emocional del paciente)
CREATE TABLE IF NOT EXISTS registro_emocional (
    id                 INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    perfil_paciente_id INT         NOT NULL,
    fecha              TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_animo       VARCHAR(30) NOT NULL,
    nota               TEXT,
    privada            BOOLEAN     NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_registro_paciente
        FOREIGN KEY (perfil_paciente_id) REFERENCES perfil_paciente (id)
);

-- 6. VERIFICACIÓN: mostrar las tablas creadas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;


SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';



