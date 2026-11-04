--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2026-11-03 22:34:32

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 248 (class 1259 OID 17437)
-- Name: actividad; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actividad (
    id integer NOT NULL,
    perfil_especialista_id integer NOT NULL,
    perfil_paciente_id integer NOT NULL,
    titulo character varying(150) NOT NULL,
    instrucciones text NOT NULL,
    fecha_limite date,
    estado character varying(20) DEFAULT 'pendiente'::character varying NOT NULL
);


ALTER TABLE public.actividad OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17436)
-- Name: actividad_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.actividad ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.actividad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 250 (class 1259 OID 17456)
-- Name: alerta_riesgo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerta_riesgo (
    id integer NOT NULL,
    perfil_paciente_id integer NOT NULL,
    perfil_especialista_id integer NOT NULL,
    motivo text NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado character varying(20) DEFAULT 'abierta'::character varying NOT NULL
);


ALTER TABLE public.alerta_riesgo OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17455)
-- Name: alerta_riesgo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.alerta_riesgo ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.alerta_riesgo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 17290)
-- Name: auditoria_acceso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auditoria_acceso (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    recurso character varying(100) NOT NULL,
    accion character varying(50) NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.auditoria_acceso OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17289)
-- Name: auditoria_acceso_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auditoria_acceso ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.auditoria_acceso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 236 (class 1259 OID 17337)
-- Name: categoria_atencion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_atencion (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    activa boolean DEFAULT true NOT NULL
);


ALTER TABLE public.categoria_atencion OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17336)
-- Name: categoria_atencion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.categoria_atencion ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.categoria_atencion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 240 (class 1259 OID 17362)
-- Name: cita; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cita (
    id integer NOT NULL,
    perfil_paciente_id integer NOT NULL,
    perfil_especialista_id integer NOT NULL,
    categoria_atencion_id integer NOT NULL,
    tutor_id integer,
    fecha date NOT NULL,
    duracion_min integer NOT NULL,
    tiempo time without time zone NOT NULL,
    estado character varying(20) DEFAULT 'programada'::character varying NOT NULL,
    CONSTRAINT chk_cita_duracion CHECK ((duracion_min > 0))
);


ALTER TABLE public.cita OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17361)
-- Name: cita_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cita ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cita_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 17302)
-- Name: consentimiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consentimiento (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    tipo character varying(50) NOT NULL,
    version character varying(20) NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.consentimiento OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17301)
-- Name: consentimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.consentimiento ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.consentimiento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 17390)
-- Name: consulta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.consulta (
    id integer NOT NULL,
    cita_id integer NOT NULL,
    inicio_real timestamp without time zone,
    fin_real timestamp without time zone,
    asistencia boolean DEFAULT false NOT NULL
);


ALTER TABLE public.consulta OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17389)
-- Name: consulta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.consulta ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.consulta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 17346)
-- Name: especialista_categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.especialista_categoria (
    id integer NOT NULL,
    categoria_atencion_id integer NOT NULL,
    perfil_especialista_id integer NOT NULL
);


ALTER TABLE public.especialista_categoria OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17345)
-- Name: especialista_categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.especialista_categoria ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.especialista_categoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 244 (class 1259 OID 17404)
-- Name: instrumento_seguimiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrumento_seguimiento (
    id integer NOT NULL,
    categoria_atencion_id integer NOT NULL,
    nombre character varying(100) NOT NULL
);


ALTER TABLE public.instrumento_seguimiento OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17403)
-- Name: instrumento_seguimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.instrumento_seguimiento ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.instrumento_seguimiento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 17275)
-- Name: notificacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notificacion (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    tipo character varying(50) NOT NULL,
    contenido text NOT NULL,
    leida boolean DEFAULT false NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notificacion OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17274)
-- Name: notificacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.notificacion ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.notificacion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 17262)
-- Name: perfil_administrador; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfil_administrador (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    nivel_acceso character varying(20) NOT NULL,
    cargo character varying(100)
);


ALTER TABLE public.perfil_administrador OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17261)
-- Name: perfil_administrador_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.perfil_administrador ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.perfil_administrador_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 17243)
-- Name: perfil_especialista; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfil_especialista (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    titulo character varying(100) NOT NULL,
    registro_profesional character varying(50) NOT NULL,
    estado_verificacion character varying(20) DEFAULT 'pendiente'::character varying NOT NULL,
    presentacion text,
    CONSTRAINT chk_especialista_verificacion CHECK (((estado_verificacion)::text = ANY ((ARRAY['pendiente'::character varying, 'verificado'::character varying, 'rechazado'::character varying])::text[])))
);


ALTER TABLE public.perfil_especialista OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17242)
-- Name: perfil_especialista_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.perfil_especialista ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.perfil_especialista_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 17215)
-- Name: perfil_paciente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfil_paciente (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    fecha_nacimiento date NOT NULL
);


ALTER TABLE public.perfil_paciente OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17214)
-- Name: perfil_paciente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.perfil_paciente ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.perfil_paciente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 252 (class 1259 OID 17476)
-- Name: registro_emocional; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registro_emocional (
    id integer NOT NULL,
    perfil_paciente_id integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado_animo character varying(30) NOT NULL,
    nota text,
    privada boolean DEFAULT false NOT NULL
);


ALTER TABLE public.registro_emocional OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17475)
-- Name: registro_emocional_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.registro_emocional ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.registro_emocional_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 17415)
-- Name: resultado_instrumento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultado_instrumento (
    id integer NOT NULL,
    instrumento_id integer NOT NULL,
    perfil_paciente_id integer NOT NULL,
    perfil_especialista_id integer NOT NULL,
    fecha timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    puntaje integer NOT NULL
);


ALTER TABLE public.resultado_instrumento OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17414)
-- Name: resultado_instrumento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.resultado_instrumento ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.resultado_instrumento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 17228)
-- Name: tutor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutor (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    numero_identidad character varying(30) NOT NULL,
    telefono character varying(20)
);


ALTER TABLE public.tutor OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17227)
-- Name: tutor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tutor ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tutor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 234 (class 1259 OID 17314)
-- Name: tutor_paciente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tutor_paciente (
    id integer NOT NULL,
    tutor_id integer NOT NULL,
    perfil_paciente_id integer NOT NULL,
    consentimiento_id integer NOT NULL,
    parentesco character varying(50) NOT NULL
);


ALTER TABLE public.tutor_paciente OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17313)
-- Name: tutor_paciente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.tutor_paciente ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tutor_paciente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 17200)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    correo character varying(150) NOT NULL,
    contrasena_hash character varying(255) NOT NULL,
    estado character varying(20) DEFAULT 'activo'::character varying NOT NULL,
    correo_verificado boolean DEFAULT false NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    rol character varying(20) NOT NULL,
    CONSTRAINT chk_usuario_estado CHECK (((estado)::text = ANY ((ARRAY['activo'::character varying, 'inactivo'::character varying, 'suspendido'::character varying])::text[]))),
    CONSTRAINT chk_usuario_rol CHECK (((rol)::text = ANY ((ARRAY['paciente'::character varying, 'especialista'::character varying, 'administrador'::character varying, 'tutor'::character varying])::text[])))
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17199)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.usuario ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usuario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 5106 (class 0 OID 17437)
-- Dependencies: 248
-- Data for Name: actividad; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actividad (id, perfil_especialista_id, perfil_paciente_id, titulo, instrucciones, fecha_limite, estado) FROM stdin;
\.


--
-- TOC entry 5108 (class 0 OID 17456)
-- Dependencies: 250
-- Data for Name: alerta_riesgo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerta_riesgo (id, perfil_paciente_id, perfil_especialista_id, motivo, fecha, estado) FROM stdin;
\.


--
-- TOC entry 5088 (class 0 OID 17290)
-- Dependencies: 230
-- Data for Name: auditoria_acceso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auditoria_acceso (id, usuario_id, recurso, accion, fecha) FROM stdin;
\.


--
-- TOC entry 5094 (class 0 OID 17337)
-- Dependencies: 236
-- Data for Name: categoria_atencion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_atencion (id, nombre, activa) FROM stdin;
\.


--
-- TOC entry 5098 (class 0 OID 17362)
-- Dependencies: 240
-- Data for Name: cita; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cita (id, perfil_paciente_id, perfil_especialista_id, categoria_atencion_id, tutor_id, fecha, duracion_min, tiempo, estado) FROM stdin;
\.


--
-- TOC entry 5090 (class 0 OID 17302)
-- Dependencies: 232
-- Data for Name: consentimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consentimiento (id, usuario_id, tipo, version, fecha) FROM stdin;
\.


--
-- TOC entry 5100 (class 0 OID 17390)
-- Dependencies: 242
-- Data for Name: consulta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.consulta (id, cita_id, inicio_real, fin_real, asistencia) FROM stdin;
\.


--
-- TOC entry 5096 (class 0 OID 17346)
-- Dependencies: 238
-- Data for Name: especialista_categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.especialista_categoria (id, categoria_atencion_id, perfil_especialista_id) FROM stdin;
\.


--
-- TOC entry 5102 (class 0 OID 17404)
-- Dependencies: 244
-- Data for Name: instrumento_seguimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrumento_seguimiento (id, categoria_atencion_id, nombre) FROM stdin;
\.


--
-- TOC entry 5086 (class 0 OID 17275)
-- Dependencies: 228
-- Data for Name: notificacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notificacion (id, usuario_id, tipo, contenido, leida, fecha) FROM stdin;
\.


--
-- TOC entry 5084 (class 0 OID 17262)
-- Dependencies: 226
-- Data for Name: perfil_administrador; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perfil_administrador (id, usuario_id, nivel_acceso, cargo) FROM stdin;
\.


--
-- TOC entry 5082 (class 0 OID 17243)
-- Dependencies: 224
-- Data for Name: perfil_especialista; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perfil_especialista (id, usuario_id, titulo, registro_profesional, estado_verificacion, presentacion) FROM stdin;
\.


--
-- TOC entry 5078 (class 0 OID 17215)
-- Dependencies: 220
-- Data for Name: perfil_paciente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perfil_paciente (id, usuario_id, fecha_nacimiento) FROM stdin;
\.


--
-- TOC entry 5110 (class 0 OID 17476)
-- Dependencies: 252
-- Data for Name: registro_emocional; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registro_emocional (id, perfil_paciente_id, fecha, estado_animo, nota, privada) FROM stdin;
\.


--
-- TOC entry 5104 (class 0 OID 17415)
-- Dependencies: 246
-- Data for Name: resultado_instrumento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultado_instrumento (id, instrumento_id, perfil_paciente_id, perfil_especialista_id, fecha, puntaje) FROM stdin;
\.


--
-- TOC entry 5080 (class 0 OID 17228)
-- Dependencies: 222
-- Data for Name: tutor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutor (id, usuario_id, numero_identidad, telefono) FROM stdin;
\.


--
-- TOC entry 5092 (class 0 OID 17314)
-- Dependencies: 234
-- Data for Name: tutor_paciente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tutor_paciente (id, tutor_id, perfil_paciente_id, consentimiento_id, parentesco) FROM stdin;
\.


--
-- TOC entry 5076 (class 0 OID 17200)
-- Dependencies: 218
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, nombre, correo, contrasena_hash, estado, correo_verificado, fecha_registro, rol) FROM stdin;
\.


--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 247
-- Name: actividad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actividad_id_seq', 1, false);


--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 249
-- Name: alerta_riesgo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerta_riesgo_id_seq', 1, false);


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 229
-- Name: auditoria_acceso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auditoria_acceso_id_seq', 1, false);


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 235
-- Name: categoria_atencion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_atencion_id_seq', 1, false);


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 239
-- Name: cita_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cita_id_seq', 1, false);


--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 231
-- Name: consentimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consentimiento_id_seq', 1, false);


--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 241
-- Name: consulta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.consulta_id_seq', 1, false);


--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 237
-- Name: especialista_categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.especialista_categoria_id_seq', 1, false);


--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 243
-- Name: instrumento_seguimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrumento_seguimiento_id_seq', 1, false);


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 227
-- Name: notificacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notificacion_id_seq', 1, false);


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 225
-- Name: perfil_administrador_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.perfil_administrador_id_seq', 1, false);


--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 223
-- Name: perfil_especialista_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.perfil_especialista_id_seq', 1, false);


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 219
-- Name: perfil_paciente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.perfil_paciente_id_seq', 1, false);


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 251
-- Name: registro_emocional_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registro_emocional_id_seq', 1, false);


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 245
-- Name: resultado_instrumento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resultado_instrumento_id_seq', 1, false);


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 221
-- Name: tutor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tutor_id_seq', 1, false);


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 233
-- Name: tutor_paciente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tutor_paciente_id_seq', 1, false);


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 1, false);


--
-- TOC entry 4899 (class 2606 OID 17444)
-- Name: actividad actividad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT actividad_pkey PRIMARY KEY (id);


--
-- TOC entry 4901 (class 2606 OID 17464)
-- Name: alerta_riesgo alerta_riesgo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_riesgo
    ADD CONSTRAINT alerta_riesgo_pkey PRIMARY KEY (id);


--
-- TOC entry 4875 (class 2606 OID 17295)
-- Name: auditoria_acceso auditoria_acceso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_acceso
    ADD CONSTRAINT auditoria_acceso_pkey PRIMARY KEY (id);


--
-- TOC entry 4883 (class 2606 OID 17344)
-- Name: categoria_atencion categoria_atencion_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_atencion
    ADD CONSTRAINT categoria_atencion_nombre_key UNIQUE (nombre);


--
-- TOC entry 4885 (class 2606 OID 17342)
-- Name: categoria_atencion categoria_atencion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_atencion
    ADD CONSTRAINT categoria_atencion_pkey PRIMARY KEY (id);


--
-- TOC entry 4889 (class 2606 OID 17368)
-- Name: cita cita_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT cita_pkey PRIMARY KEY (id);


--
-- TOC entry 4877 (class 2606 OID 17307)
-- Name: consentimiento consentimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consentimiento
    ADD CONSTRAINT consentimiento_pkey PRIMARY KEY (id);


--
-- TOC entry 4891 (class 2606 OID 17397)
-- Name: consulta consulta_cita_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT consulta_cita_id_key UNIQUE (cita_id);


--
-- TOC entry 4893 (class 2606 OID 17395)
-- Name: consulta consulta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT consulta_pkey PRIMARY KEY (id);


--
-- TOC entry 4887 (class 2606 OID 17350)
-- Name: especialista_categoria especialista_categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialista_categoria
    ADD CONSTRAINT especialista_categoria_pkey PRIMARY KEY (id);


--
-- TOC entry 4895 (class 2606 OID 17408)
-- Name: instrumento_seguimiento instrumento_seguimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumento_seguimiento
    ADD CONSTRAINT instrumento_seguimiento_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 2606 OID 17283)
-- Name: notificacion notificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT notificacion_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 17266)
-- Name: perfil_administrador perfil_administrador_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_administrador
    ADD CONSTRAINT perfil_administrador_pkey PRIMARY KEY (id);


--
-- TOC entry 4871 (class 2606 OID 17268)
-- Name: perfil_administrador perfil_administrador_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_administrador
    ADD CONSTRAINT perfil_administrador_usuario_id_key UNIQUE (usuario_id);


--
-- TOC entry 4863 (class 2606 OID 17251)
-- Name: perfil_especialista perfil_especialista_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_especialista
    ADD CONSTRAINT perfil_especialista_pkey PRIMARY KEY (id);


--
-- TOC entry 4865 (class 2606 OID 17255)
-- Name: perfil_especialista perfil_especialista_registro_profesional_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_especialista
    ADD CONSTRAINT perfil_especialista_registro_profesional_key UNIQUE (registro_profesional);


--
-- TOC entry 4867 (class 2606 OID 17253)
-- Name: perfil_especialista perfil_especialista_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_especialista
    ADD CONSTRAINT perfil_especialista_usuario_id_key UNIQUE (usuario_id);


--
-- TOC entry 4853 (class 2606 OID 17219)
-- Name: perfil_paciente perfil_paciente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_paciente
    ADD CONSTRAINT perfil_paciente_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 17221)
-- Name: perfil_paciente perfil_paciente_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_paciente
    ADD CONSTRAINT perfil_paciente_usuario_id_key UNIQUE (usuario_id);


--
-- TOC entry 4903 (class 2606 OID 17484)
-- Name: registro_emocional registro_emocional_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_emocional
    ADD CONSTRAINT registro_emocional_pkey PRIMARY KEY (id);


--
-- TOC entry 4897 (class 2606 OID 17420)
-- Name: resultado_instrumento resultado_instrumento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado_instrumento
    ADD CONSTRAINT resultado_instrumento_pkey PRIMARY KEY (id);


--
-- TOC entry 4857 (class 2606 OID 17236)
-- Name: tutor tutor_numero_identidad_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor
    ADD CONSTRAINT tutor_numero_identidad_key UNIQUE (numero_identidad);


--
-- TOC entry 4879 (class 2606 OID 17318)
-- Name: tutor_paciente tutor_paciente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor_paciente
    ADD CONSTRAINT tutor_paciente_pkey PRIMARY KEY (id);


--
-- TOC entry 4859 (class 2606 OID 17232)
-- Name: tutor tutor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor
    ADD CONSTRAINT tutor_pkey PRIMARY KEY (id);


--
-- TOC entry 4861 (class 2606 OID 17234)
-- Name: tutor tutor_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor
    ADD CONSTRAINT tutor_usuario_id_key UNIQUE (usuario_id);


--
-- TOC entry 4881 (class 2606 OID 17320)
-- Name: tutor_paciente uq_tutor_paciente; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor_paciente
    ADD CONSTRAINT uq_tutor_paciente UNIQUE (tutor_id, perfil_paciente_id);


--
-- TOC entry 4849 (class 2606 OID 17213)
-- Name: usuario usuario_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_correo_key UNIQUE (correo);


--
-- TOC entry 4851 (class 2606 OID 17211)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4925 (class 2606 OID 17445)
-- Name: actividad fk_actividad_especialista; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT fk_actividad_especialista FOREIGN KEY (perfil_especialista_id) REFERENCES public.perfil_especialista(id);


--
-- TOC entry 4926 (class 2606 OID 17450)
-- Name: actividad fk_actividad_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad
    ADD CONSTRAINT fk_actividad_paciente FOREIGN KEY (perfil_paciente_id) REFERENCES public.perfil_paciente(id);


--
-- TOC entry 4927 (class 2606 OID 17470)
-- Name: alerta_riesgo fk_alerta_especialista; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_riesgo
    ADD CONSTRAINT fk_alerta_especialista FOREIGN KEY (perfil_especialista_id) REFERENCES public.perfil_especialista(id);


--
-- TOC entry 4928 (class 2606 OID 17465)
-- Name: alerta_riesgo fk_alerta_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_riesgo
    ADD CONSTRAINT fk_alerta_paciente FOREIGN KEY (perfil_paciente_id) REFERENCES public.perfil_paciente(id);


--
-- TOC entry 4909 (class 2606 OID 17296)
-- Name: auditoria_acceso fk_auditoria_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditoria_acceso
    ADD CONSTRAINT fk_auditoria_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 4916 (class 2606 OID 17379)
-- Name: cita fk_cita_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT fk_cita_categoria FOREIGN KEY (categoria_atencion_id) REFERENCES public.categoria_atencion(id);


--
-- TOC entry 4917 (class 2606 OID 17374)
-- Name: cita fk_cita_especialista; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT fk_cita_especialista FOREIGN KEY (perfil_especialista_id) REFERENCES public.perfil_especialista(id);


--
-- TOC entry 4918 (class 2606 OID 17369)
-- Name: cita fk_cita_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT fk_cita_paciente FOREIGN KEY (perfil_paciente_id) REFERENCES public.perfil_paciente(id);


--
-- TOC entry 4919 (class 2606 OID 17384)
-- Name: cita fk_cita_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cita
    ADD CONSTRAINT fk_cita_tutor FOREIGN KEY (tutor_id) REFERENCES public.tutor(id);


--
-- TOC entry 4910 (class 2606 OID 17308)
-- Name: consentimiento fk_consentimiento_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consentimiento
    ADD CONSTRAINT fk_consentimiento_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;


--
-- TOC entry 4920 (class 2606 OID 17398)
-- Name: consulta fk_consulta_cita; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.consulta
    ADD CONSTRAINT fk_consulta_cita FOREIGN KEY (cita_id) REFERENCES public.cita(id) ON DELETE CASCADE;


--
-- TOC entry 4914 (class 2606 OID 17351)
-- Name: especialista_categoria fk_espcat_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialista_categoria
    ADD CONSTRAINT fk_espcat_categoria FOREIGN KEY (categoria_atencion_id) REFERENCES public.categoria_atencion(id);


--
-- TOC entry 4915 (class 2606 OID 17356)
-- Name: especialista_categoria fk_espcat_especialista; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.especialista_categoria
    ADD CONSTRAINT fk_espcat_especialista FOREIGN KEY (perfil_especialista_id) REFERENCES public.perfil_especialista(id) ON DELETE CASCADE;


--
-- TOC entry 4921 (class 2606 OID 17409)
-- Name: instrumento_seguimiento fk_instrumento_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrumento_seguimiento
    ADD CONSTRAINT fk_instrumento_categoria FOREIGN KEY (categoria_atencion_id) REFERENCES public.categoria_atencion(id);


--
-- TOC entry 4908 (class 2606 OID 17284)
-- Name: notificacion fk_notificacion_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificacion
    ADD CONSTRAINT fk_notificacion_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;


--
-- TOC entry 4907 (class 2606 OID 17269)
-- Name: perfil_administrador fk_perfil_administrador_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_administrador
    ADD CONSTRAINT fk_perfil_administrador_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;


--
-- TOC entry 4906 (class 2606 OID 17256)
-- Name: perfil_especialista fk_perfil_especialista_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_especialista
    ADD CONSTRAINT fk_perfil_especialista_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;


--
-- TOC entry 4904 (class 2606 OID 17222)
-- Name: perfil_paciente fk_perfil_paciente_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil_paciente
    ADD CONSTRAINT fk_perfil_paciente_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;


--
-- TOC entry 4929 (class 2606 OID 17485)
-- Name: registro_emocional fk_registro_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_emocional
    ADD CONSTRAINT fk_registro_paciente FOREIGN KEY (perfil_paciente_id) REFERENCES public.perfil_paciente(id);


--
-- TOC entry 4922 (class 2606 OID 17431)
-- Name: resultado_instrumento fk_resultado_especialista; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado_instrumento
    ADD CONSTRAINT fk_resultado_especialista FOREIGN KEY (perfil_especialista_id) REFERENCES public.perfil_especialista(id);


--
-- TOC entry 4923 (class 2606 OID 17421)
-- Name: resultado_instrumento fk_resultado_instrumento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado_instrumento
    ADD CONSTRAINT fk_resultado_instrumento FOREIGN KEY (instrumento_id) REFERENCES public.instrumento_seguimiento(id);


--
-- TOC entry 4924 (class 2606 OID 17426)
-- Name: resultado_instrumento fk_resultado_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultado_instrumento
    ADD CONSTRAINT fk_resultado_paciente FOREIGN KEY (perfil_paciente_id) REFERENCES public.perfil_paciente(id);


--
-- TOC entry 4911 (class 2606 OID 17331)
-- Name: tutor_paciente fk_tutor_paciente_consentimiento; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor_paciente
    ADD CONSTRAINT fk_tutor_paciente_consentimiento FOREIGN KEY (consentimiento_id) REFERENCES public.consentimiento(id);


--
-- TOC entry 4912 (class 2606 OID 17326)
-- Name: tutor_paciente fk_tutor_paciente_paciente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor_paciente
    ADD CONSTRAINT fk_tutor_paciente_paciente FOREIGN KEY (perfil_paciente_id) REFERENCES public.perfil_paciente(id) ON DELETE CASCADE;


--
-- TOC entry 4913 (class 2606 OID 17321)
-- Name: tutor_paciente fk_tutor_paciente_tutor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor_paciente
    ADD CONSTRAINT fk_tutor_paciente_tutor FOREIGN KEY (tutor_id) REFERENCES public.tutor(id) ON DELETE CASCADE;


--
-- TOC entry 4905 (class 2606 OID 17237)
-- Name: tutor fk_tutor_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tutor
    ADD CONSTRAINT fk_tutor_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;


-- Completed on 2026-11-03 22:34:33

--
-- PostgreSQL database dump complete
--

