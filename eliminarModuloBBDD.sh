#!/bin/bash

# Verificar si se tienen los permisos necesarios para interactuar con PostgreSQL
if ! command -v psql &> /dev/null
then
    echo "psql no está instalado. Instala PostgreSQL para continuar."
    exit 1
fi

echo "Conectándote a PostgreSQL para listar las bases de datos disponibles..."
echo "Bases de datos disponibles:"

# Obtener y listar las bases de datos en formato limpio
sudo -u postgres psql -tAc "SELECT datname FROM pg_database WHERE datistemplate = false;" | while read -r db; do
    echo "- $db"
done

# Solicitar la base de datos de Odoo dentro de un bucle hasta que sea válida
while true; do
    echo "Introduce el nombre de la base de datos de Odoo:"
    read DB_NAME

    # Verificar si la base de datos existe
    DB_EXISTS=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")
    if [[ $DB_EXISTS == "1" ]]; then
        break
    else
        echo "La base de datos '$DB_NAME' no existe. Por favor, introduce un nombre válido."
    fi
done

# Solicitar el nombre del módulo de Odoo dentro de un bucle hasta que sea válido
while true; do
    echo "Introduce el nombre del módulo de Odoo a borrar:"
    read MODULE_NAME

    if [[ -n $MODULE_NAME ]]; then
        break
    else
        echo "El nombre del módulo no puede estar vacío. Por favor, introduce un nombre válido."
    fi
done

# Confirmar acción (aceptando solo 'S/s' o 'N/n')
while true; do
    echo "Estás a punto de borrar el módulo '$MODULE_NAME' de la base de datos '$DB_NAME'. ¿Continuar? (S/N)"
    read -n 1 CONFIRM
    echo # Para agregar un salto de línea después de la entrada del usuario

    if [[ $CONFIRM == [Ss] ]]; then
        break
    elif [[ $CONFIRM == [Nn] ]]; then
        echo "Operación cancelada."
        exit 0
    else
        echo "Entrada no válida. Por favor, introduce 'S' para sí o 'N' para no."
    fi
done

# Ejecutar comandos para borrar el módulo
echo "Conectándose a la base de datos $DB_NAME y eliminando el módulo $MODULE_NAME..."
sudo -u postgres psql -d "$DB_NAME" <<EOF
BEGIN;

-- Eliminar registros relacionados con el módulo
DELETE FROM ir_actions WHERE name->>'en_US' LIKE '%$MODULE_NAME%';

-- Eliminar accesos relacionados con el modelo del módulo
DELETE FROM ir_model_access WHERE model_id IN (SELECT id FROM ir_model WHERE model LIKE '%$MODULE_NAME%');

-- Eliminar registros de ir_model_data que puedan estar causando duplicados
DELETE FROM ir_model_data WHERE module = 'base' AND name LIKE '%$MODULE_NAME%';
DELETE FROM ir_model_data WHERE module LIKE '%$MODULE_NAME%';

-- Eliminar registros de ir_module_module
DELETE FROM ir_module_module WHERE name LIKE '%$MODULE_NAME%';

-- Eliminar registros relacionados en otras tablas
DELETE FROM ir_model WHERE model LIKE '%$MODULE_NAME%';  -- Eliminar modelo del módulo

DELETE FROM ir_attachment WHERE res_model LIKE '%$MODULE_NAME%';  -- Eliminar archivos adjuntos relacionados

-- Eliminar registros de ir_ui_menu
-- Deshabilitar todas las restricciones en la tabla
ALTER TABLE ir_ui_menu DISABLE TRIGGER ALL;
-- Realiza tus operaciones
DELETE FROM ir_ui_menu WHERE name::text LIKE '%$MODULE_NAME%';
-- Habilitar las restricciones nuevamente
ALTER TABLE ir_ui_menu ENABLE TRIGGER ALL;

-- Eliminar registros de ir_model_data que puedan estar causando duplicados
DELETE FROM ir_model_data WHERE name LIKE '%$MODULE_NAME%';

-- Eliminar registros de ir_ui_view que puedan estar causando duplicados
DELETE FROM ir_ui_view WHERE model LIKE '%$MODULE_NAME%';

-- Verificar si existe alguna tabla con el nombre del módulo y eliminarla
DO \$\$
DECLARE
    r record;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND tablename LIKE '%$MODULE_NAME%') 
    LOOP
        EXECUTE 'DROP TABLE ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END;
\$\$;

-- Verificar si la tabla ir_translation existe antes de intentar eliminar
DO \$\$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ir_translation') THEN
        DELETE FROM ir_translation WHERE name LIKE '$MODULE_NAME';
    END IF;
END;
\$\$;

-- Verificar si la tabla ir_cache existe antes de intentar eliminar
DO \$\$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'ir_cache') THEN
        DELETE FROM ir_cache WHERE key LIKE '$MODULE_NAME';
    END IF;
END;
\$\$;

COMMIT;
EOF

if [[ $? -eq 0 ]]; then
    echo "El módulo '$MODULE_NAME' ha sido eliminado correctamente de la base de datos '$DB_NAME'."

    # Reiniciar el servicio de Odoo para aplicar los cambios
    echo "Reiniciando el servicio de Odoo..."
    sudo systemctl restart odoo
else
    echo "Ocurrió un error al intentar eliminar el módulo '$MODULE_NAME'."
fi