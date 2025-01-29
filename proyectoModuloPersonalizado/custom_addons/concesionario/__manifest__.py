# -*- coding: utf-8 -*-
{
    # Nombre del módulo
    'name': "Concesionario",

    # Resumen del módulo
    'summary': """
        Modulo sencillo de concesionario""",

    # Descripción detallada del módulo
    'description': """
        Módulo de venta de coches (concesionario)
    """,

    # Autor(es) del módulo
    'author': "Abraham Gomez Barcia y Juan Carlos Fornieles",
    
    # Sitio web del autor o de la empresa
    'website': "http://www.yourcompany.com",

    # Categoría del módulo, usada para filtrar en la lista de módulos
    # Revisa https://github.com/odoo/odoo/blob/master/odoo/addons/base/module/module_data.xml
    # para la lista completa
    'category': 'Administration',
    
    # Versión del módulo
    'version': '1.0',

    # Cualquier módulo necesario para que este funcione correctamente
    'depends': ['base'],
    
    # Indica si este módulo es una aplicación
    'application': True,

    # Archivos siempre cargados
    'data': [
        # Archivo de seguridad para el acceso a modelos
        'security/ir.model.access.csv',
        # Vista principal del módulo
        'views/views.xml',
        # Plantillas del módulo
        'views/templates.xml',
    ],
    
    # Para que funcionen los archivos CSS
    'assets': {
        # Archivos CSS comunes
        'web.assets_common': [
            'concesionario/static/src/scss/concesionario.scss',
        ]
    },

    # Archivos cargados solo en modo demostración
    'demo': [
        'demo/demo.xml',
    ],
}