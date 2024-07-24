-- Base de Datos: SistemaMedico
CREATE DATABASE SistemaMedico;
\c SistemaMedico;

-- Tabla para las empresas
CREATE TABLE empresas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_empresas_nombre ON empresas(nombre);
CREATE INDEX idx_empresas_email ON empresas(email);

-- Tabla para los doctores
CREATE TABLE doctores (
    id SERIAL PRIMARY KEY,
    empresa_id INT REFERENCES empresas(id) ON DELETE CASCADE,
    nombre VARCHAR(255) NOT NULL,
    especialidad_id INT REFERENCES especialidades(id) ON DELETE SET NULL,
    telefono VARCHAR(20),
    email VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_doctores_empresa_id ON doctores(empresa_id);
CREATE INDEX idx_doctores_nombre ON doctores(nombre);
CREATE INDEX idx_doctores_email ON doctores(email);

-- Tabla para las clínicas
CREATE TABLE clinicas (
    id SERIAL PRIMARY KEY,
    doctor_id INT REFERENCES doctores(id) ON DELETE CASCADE,
    nombre VARCHAR(255) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_clinicas_doctor_id ON clinicas(doctor_id);
CREATE INDEX idx_clinicas_nombre ON clinicas(nombre);
CREATE INDEX idx_clinicas_email ON clinicas(email);

-- Tabla para los pacientes
CREATE TABLE pacientes (
    id SERIAL PRIMARY KEY,
    clinica_id INT REFERENCES clinicas(id) ON DELETE CASCADE,
    nombre VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE,
    genero VARCHAR(10),
    direccion TEXT,
    telefono VARCHAR(20),
    email VARCHAR(255),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_pacientes_clinica_id ON pacientes(clinica_id);
CREATE INDEX idx_pacientes_nombre ON pacientes(nombre);
CREATE INDEX idx_pacientes_email ON pacientes(email);

-- Tabla para las citas
CREATE TABLE citas (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    doctor_id INT REFERENCES doctores(id) ON DELETE CASCADE,
    fecha_cita TIMESTAMP NOT NULL,
    tipo_cita VARCHAR(50) CHECK (tipo_cita IN ('presencial', 'online')),
    motivo TEXT,
    estado VARCHAR(50) CHECK (estado IN ('pendiente', 'confirmada', 'cancelada', 'completada')),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_citas_paciente_id ON citas(paciente_id);
CREATE INDEX idx_citas_doctor_id ON citas(doctor_id);
CREATE INDEX idx_citas_fecha_cita ON citas(fecha_cita);
CREATE INDEX idx_citas_estado ON citas(estado);

-- Tabla para la preclínica
CREATE TABLE preclinica (
    id SERIAL PRIMARY KEY,
    cita_id INT REFERENCES citas(id) ON DELETE CASCADE,
    peso DECIMAL(5,2),
    altura DECIMAL(5,2),
    presion_arterial VARCHAR(50),
    temperatura DECIMAL(4,2),
    observaciones TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_preclinica_cita_id ON preclinica(cita_id);

-- Tabla para el historial de preclínica
CREATE TABLE preclinica_historico (
    id SERIAL PRIMARY KEY,
    cita_id INT REFERENCES citas(id) ON DELETE CASCADE,
    peso DECIMAL(5,2),
    altura DECIMAL(5,2),
    presion_arterial VARCHAR(50),
    temperatura DECIMAL(4,2),
    observaciones TEXT,
    fecha_registro TIMESTAMP,
    fecha_transferencia TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_preclinica_historico_cita_id ON preclinica_historico(cita_id);

-- Tabla para las recetas
CREATE TABLE recetas (
    id SERIAL PRIMARY KEY,
    cita_id INT REFERENCES citas(id) ON DELETE CASCADE,
    descripcion TEXT NOT NULL,
    indicaciones TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_recetas_cita_id ON recetas(cita_id);

-- Tabla para las facturas
CREATE TABLE facturas (
    id SERIAL PRIMARY KEY,
    empresa_id INT REFERENCES empresas(id) ON DELETE CASCADE,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_factura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    estado VARCHAR(50) CHECK (estado IN ('pendiente', 'pagada', 'cancelada')),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_facturas_empresa_id ON facturas(empresa_id);
CREATE INDEX idx_facturas_paciente_id ON facturas(paciente_id);
CREATE INDEX idx_facturas_fecha_factura ON facturas(fecha_factura);
CREATE INDEX idx_facturas_estado ON facturas(estado);

-- Tabla para las notificaciones
CREATE TABLE notificaciones (
    id SERIAL PRIMARY KEY,
    paciente_id INT REFERENCES pacientes(id) ON DELETE CASCADE,
    mensaje TEXT NOT NULL,
    tipo_notificacion VARCHAR(50) CHECK (tipo_notificacion IN ('recordatorio', 'informacion')),
    fecha_envio TIMESTAMP,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_notificaciones_paciente_id ON notificaciones(paciente_id);
CREATE INDEX idx_notificaciones_tipo_notificacion ON notificaciones(tipo_notificacion);

-- Tabla para los recordatorios de citas
CREATE TABLE recordatorios_citas (
    id SERIAL PRIMARY KEY,
    cita_id INT REFERENCES citas(id) ON DELETE CASCADE,
    fecha_recordatorio TIMESTAMP NOT NULL,
    mensaje TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_recordatorios_citas_cita_id ON recordatorios_citas(cita_id);
CREATE INDEX idx_recordatorios_citas_fecha_recordatorio ON recordatorios_citas(fecha_recordatorio);

-- Historial de cambios en citas (opcional)
CREATE TABLE historial_citas (
    id SERIAL PRIMARY KEY,
    cita_id INT REFERENCES citas(id) ON DELETE CASCADE,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_cambio VARCHAR(255)
);
CREATE INDEX idx_historial_citas_cita_id ON historial_citas(cita_id);
CREATE INDEX idx_historial_citas_estado_anterior ON historial_citas(estado_anterior);
CREATE INDEX idx_historial_citas_estado_nuevo ON historial_citas(estado_nuevo);

-- Historial de cambios en facturas (opcional)
CREATE TABLE historial_facturas (
    id SERIAL PRIMARY KEY,
    factura_id INT REFERENCES facturas(id) ON DELETE CASCADE,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_cambio VARCHAR(255)
);
CREATE INDEX idx_historial_facturas_factura_id ON historial_facturas(factura_id);
CREATE INDEX idx_historial_facturas_estado_anterior ON historial_facturas(estado_anterior);
CREATE INDEX idx_historial_facturas_estado_nuevo ON historial_facturas(estado_nuevo);

-- Tabla para las especialidades médicas
CREATE TABLE especialidades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_especialidades_nombre ON especialidades(nombre);

-- Tabla para los procedimientos médicos
CREATE TABLE procedimientos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    costo DECIMAL(10, 2) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_procedimientos_nombre ON procedimientos(nombre);

-- Tabla para los procedimientos realizados
CREATE TABLE procedimientos_realizados (
    id SERIAL PRIMARY KEY,
    cita_id INT REFERENCES citas(id) ON DELETE CASCADE,
    procedimiento_id INT REFERENCES procedimientos(id) ON DELETE CASCADE,
    costo DECIMAL(10, 2) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_procedimientos_realizados_cita_id ON procedimientos_realizados(cita_id);
CREATE INDEX idx_procedimientos_realizados_procedimiento_id ON procedimientos_realizados(procedimiento_id);

-- Tabla para las enfermedades
CREATE TABLE enfermedades (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_enfermedades_nombre ON enfermedades(nombre);

-- Tabla para los diagnósticos
CREATE TABLE diagnosticos (
    id SERIAL PRIMARY KEY,
    cita_id INT REFERENCES citas(id) ON DELETE CASCADE,
    enfermedad_id INT REFERENCES enfermedades(id) ON DELETE SET NULL,
    descripcion TEXT,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_creacion VARCHAR(255),
    usuario_actualizacion VARCHAR(255)
);
CREATE INDEX idx_diagnosticos_cita_id ON diagnosticos(cita_id);
CREATE INDEX idx_diagnosticos_enfermedad_id ON diagnosticos(enfermedad_id);

-- Función para mover datos de preclínica a histórico
CREATE OR REPLACE FUNCTION mover_preclinica_a_historico(cita_id INT) RETURNS VOID AS $$
BEGIN
    INSERT INTO preclinica_historico (cita_id, peso, altura, presion_arterial, temperatura, observaciones, fecha_registro, usuario_creacion, usuario_actualizacion)
    SELECT cita_id, peso, altura, presion_arterial, temperatura, observaciones, fecha_registro, usuario_creacion, usuario_actualizacion
    FROM preclinica
    WHERE cita_id = $1;

    DELETE FROM preclinica WHERE cita_id = $1;
END;
$$ LANGUAGE plpgsql;

-- Triggers para actualizar automáticamente las fechas de actualización
CREATE OR REPLACE FUNCTION set_updated_at() RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear los triggers para las tablas relevantes
CREATE TRIGGER update_empresas BEFORE UPDATE ON empresas FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_doctores BEFORE UPDATE ON doctores FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_clinicas BEFORE UPDATE ON clinicas FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_pacientes BEFORE UPDATE ON pacientes FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_citas BEFORE UPDATE ON citas FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_preclinica BEFORE UPDATE ON preclinica FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_recetas BEFORE UPDATE ON recetas FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_facturas BEFORE UPDATE ON facturas FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_notificaciones BEFORE UPDATE ON notificaciones FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_recordatorios_citas BEFORE UPDATE ON recordatorios_citas FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_procedimientos BEFORE UPDATE ON procedimientos FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_procedimientos_realizados BEFORE UPDATE ON procedimientos_realizados FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_enfermedades BEFORE UPDATE ON enfermedades FOR EACH ROW EXECUTE FUNCTION set_updated_at();
CREATE TRIGGER update_diagnosticos BEFORE UPDATE ON diagnosticos FOR EACH ROW EXECUTE FUNCTION set_updated_at();
