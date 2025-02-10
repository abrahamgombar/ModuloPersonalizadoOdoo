# ModuloPersonalizadoOdoo

# Creación de Módulos en Odoo

```
Realizado por:
Juan Carlos Fornieles Cordón
Abraham Gómez Barcia
```

## Índice

- ¿ Qué vamos a realizar ?__________________________________________________________
- ¿ Qué necesitamos ?_______________________________________________________________
   - Requisitos Previos______________________________________________________________
   - Herramientas Recomendadas_________________________________________________
- 1. Primeros Pasos___________________________________________________________________
   - 1.1. Configuración de archivos y permisos_____________________________________
   - 1.2. Configuración de permisos_________________________________________________
   - 1.3. Configuración de la interfaz web___________________________________________
- 2. Creación de módulo_____________________________________________________________
   - 2.1. concesionario/ __manifest__.py_____________________________________________
   - 2.2. concesionario/models_____________________________________________________
      - Creación de una clase______________________________________________________
      - Propiedades del modelo____________________________________________________
      - Tipos de Datos_____________________________________________________________
      - Relaciones___________________________________________________________________
   - 2.3 concesionario/security/ir.model.access.csv_______________________________
      - ¿Cómo funciona un archivo CSV?__________________________________________
      - ¿Qué podemos encontrar en nuestro fichero csv?________________________
   - 2.4 concesionario/views_______________________________________________________
      - views.xml____________________________________________________________________
         - Definición de Vistas de Lista (list)______________________________________
         - Formularios Personalizados___________________________________________
         - Acciones de Ventana___________________________________________________
         - Elementos de Menú_____________________________________________________
   - 2.5 concesionario/demo_______________________________________________________
   - 2.6 concesionario/controllers_________________________________________________
      - Creación de la clase________________________________________________________
      - Primer método______________________________________________________________
      - Método para obtener todas las ventas en una vista_____________________
      - Método para obtener venta por ID._______________________________________
   - 2.7 concesionario/static/description/icon.png_______________________________
   - 2.8 concesionario/static/src/scss/concesionario.scss_______________________
   - 2.9 __init__.py___________________________________________________________________


**¿ Qué vamos a realizar?**

Ya conocemos qué son los módulos en Odoo y la importancia que tienen para
ampliar y personalizar las funcionalidades del sistema. En esta ocasión, nos
enfocaremos en aprender a crear un módulo personalizado desde cero,
adaptándolo a nuestras necesidades específicas.

Para lograrlo, necesitaremos comprender algunos conceptos clave y contar
con ciertas herramientas esenciales. Explicaremos paso a paso el proceso de
desarrollo, desde la estructura básica del módulo hasta su implementación y
prueba dentro de Odoo.

**¿ Qué necesitamos?**

Para desarrollar un módulo en Odoo, es fundamental contar con un entorno
de desarrollo correctamente configurado. A continuación, se detallan los
requisitos y herramientas recomendadas:

Requisitos Previos

1. **Python** : Odoo está desarrollado en Python, por lo que es necesario
    tenerlo instalado en la máquina local. Se recomienda utilizar la versión
    compatible con la versión específica de Odoo que se esté utilizando.
2. **Odoo** : Es indispensable instalar Odoo en el equipo de desarrollo para
    poder crear, probar e implementar módulos personalizados.
3. **PostgreSQL** : Odoo utiliza PostgreSQL como base de datos, y esta ya
    debería estar instalada en el sistema desde la configuración inicial de
    Odoo.

Herramientas Recomendadas

Para optimizar el proceso de desarrollo, se recomienda utilizar un entorno de
desarrollo integrado (IDE) y herramientas adicionales:

```
● Visual Studio Code (VS Code) : Un editor de código ligero y potente,
ampliamente utilizado para el desarrollo en Python y Odoo.
● Extensiones recomendadas para VS Code :
○ Python : Proporciona compatibilidad con el lenguaje Python,
resaltado de sintaxis, autocompletado y herramientas de
depuración.
○ Pylance : Mejora la experiencia de desarrollo con sugerencias de
código más precisas y comprobación estática de errores.
○ Python Debugger : Permite depurar código en Python de manera
eficiente.
```
Con estos requisitos y herramientas correctamente configurados, se podrá
comenzar con el desarrollo de módulos en Odoo de manera eficiente y
estructurada.


**1. Primeros Pasos**

1.1. Configuración de archivos y permisos

Para agilizar el proceso de creación del módulo y optimizar el tiempo de
desarrollo, proporcionamos una estructura de sistema de archivos
predefinida. Esta estructura incluye los elementos esenciales que deberán
configurarse y crearse para garantizar un desarrollo ordenado y eficiente.

A lo largo de este proceso, explicaremos cada uno de los archivos y directorios
que encontraremos tras la descarga y cómo configurarlos correctamente.

```
Descargar Plantilla Concesionario
```
1.2. Configuración de permisos

**Accedemos al archivo de configuración de odoo para definir la ruta en la que
se encontrarán nuestros módulos personalizados.**
sudo nano /etc/odoo/odoo.conf

**Añadimos la siguiente línea al final del archivo. Con esto definimos la ruta
donde se encuentran nuestros módulos personalizados.**
addons_path =
/usr/lib/python3/dist-packages/odoo/addons,/home/abraham/Miniproyecto_Abraha
m_JuanCarlos/custom_addons
***Ruta en la que se encuentra nuestro directorio donde crearemos nuestros módulos**

**Cambiamos el usuario y grupo propietario del directorio que anteriormente
indicamos. Con esto odoo tendrá el control del directorio y los archivos
pudiendo acceder a ellos sin problema.**
sudo chown -R odoo:odoo
/home/abraham/Miniproyecto_Abraham_JuanCarlos/custom_addons

**Cambiamos los permisos del directorio, para que otros usuarios que no sean
el usuario odoo ni pertenezcan al grupo de odoo, puedan tener acceso
completo al directorio. Esto es debido a que al nosotros pertenecer al tipo de
usuario “Otros”, con los permisos predeterminados, no podríamos modificar
los archivos.**
sudo chmod -R 757
/home/abraham/Miniproyecto_Abraham_JuanCarlos/custom_addons

**Reiniciamos Odoo**
sudo service odoo restart


**Posible ERROR
En caso que al accedera [http://localhost:8069](http://localhost:8069) odoo nos de un error, debemos
de introducir los siguientes comandos:
Paramos Odoo**
sudo service odoo stop

**Eliminamos los archivos de caché de Python.**
sudo su - odoo -s /bin/bash -c "find. -name '*.pyc' -delete"

**Eliminamos archivos temporales y caché que podrían causar problemas.**
sudo rm -rf ~/.local/share/Odoo/*
sudo rm -rf /var/lib/odoo/.local/share/Odoo/*

**Ajustamos los permisos para asegurarnos que Odoo y otros usuarios puedan
acceder al directorio y a los archivos.**
sudo chmod 755 /home/usuario
sudo chmod 755 /home/usuario/Miniproyecto_Abraham_JuanCarlos

**Activamos Odoo**
sudo service odoo start


1.3. Configuración de la interfaz web

Para poder actualizar y añadir nuestros módulos personalizados deberemos
de activar el “ **modo desarrollador”**. Para ello seguiremos los siguientes pasos:

```
● Accedemos al menú de inicio → Ajustes
```
```
● Haremos scroll hasta encontrar “Herramientas de desarrollador” → Activar
modo de desarrollador
```
```
● Guardamos los cambios
```

```
● Volvemos al menú donde podemos encontrar todas las aplicaciones.
Menú de Inicio → Aplicaciones
```
```
● Ahora ya tendremos la vista necesaria para poder visualizar nuestros
nuevos módulos. Para actualizar la vista y poderlos ver pulsaremos
sobre “Actualizar lista de aplicaciones”
```
```
● Finalmente ya nos aparecerán nuestros módulos.
```
**Nota
En caso que no encontremos nuestro módulo, proceder a buscarlo en la
barra superior de la pantalla. Si continúa sin aparecer, nuestro módulo
contiene errores y en consecuencia no aparece.**


**2. Creación de módulo**

Vamos a crear un módulo de Odoo utilizando Python enfocado
exclusivamente en la parte de BackEnd, lo que significa que gestionaremos la
lógica de negocio y datos mediante modelos, listas y registros, sin interfaz web
para el usuario final.

Tomaremos como ejemplo un módulo llamado "Concesionario", el cual iremos
desarrollando paso a paso más adelante. Al finalizar, la estructura del
proyecto tendrá el siguiente aspecto:

```
.
├── controllers
│ ├── controllers.py
│ └── __init__.py
├── demo
│ └── demo.xml
├── __init__.py
├── __manifest__.py
├── models
│ ├── __init__.py
│ └── models.py
├── security
│ └── ir.model.access.csv
├── static
│ ├── description
│ │ └── icon.png
│ └── src
│ └── scss
│ └── concesionario.scss
└── views
└── views.xml
```
2.1. concesionario/ __manifest__.py

Vamos a empezar con este archivo que es el que lleva toda la información de
nuestro módulo. Lo crearemos dentro de la carpeta raíz del proyecto.
En este archivo encontraremos los siguientes parámetros:
**● name:** Nombre de nuestro módulo.
**● summary:** Resumen del módulo.
**● author:** Nombre de los autores del módulo.
**● website:** Sitio web del autor o de la empresa.
**● category:** Categoría del módulo, usada para filtrar en la lista de
módulos.
**● version:** Versión del módulo.
**● depends:** Aquí se pondrá el nombre de cualquier módulo que sea
necesario para que funcione el nuestro.
**● application:** Indica si este módulo es una aplicación.
**● data:** Archivos que serán cargados.
**● assets:** Para que funcionen los archivos CSS.
**● demo:** Archivos cargados solo en modo demostración.


2.2. concesionario/models

Crearemos la carpeta models donde tendremos el modelo de nuestro módulo.
Como ejemplo usaremos el concesionario como ejemplo que tendrá 3 clases:
● **Ventas** : Se encarga de almacenar las ventas de vehículos.
● **Coches** : Se encarga de almacenar los modelos de vehículos y otros
datos.
● **Marcas** : Se encarga de almacenar las marcas de los vehículos.

Además se pueden crear relaciones entre las clases: Un concesionario vende
muchos coches pero un coche solo está en un concesionario. Un coche tiene
una única marca y una marca tiene muchos coches.

Creación de una clase

En el archivo **models.py** es donde tendremos todas nuestras clases, todas
deberán empezar así:

```
class NombreClase(models.Model):
```
Propiedades del modelo

Para que nuestro módulo reconozca el modelo y que funcione todo
correctamente, dentro de nuestra clase tendremos que poner los siguientes
metadatos:
**● _name:** Será el nombre que reconocerá las vistas para nuestro modelo.
Es así: **nombremodulo** .nombremodelo
**● _rec_name:** Será el nombre representativo de los registros en vistas y
relaciones. Por ejemplo: Una persona que tiene nombre y dni, si
queremos que en las vistas se vea el campo dni cuando haya relaciones,
pondremos _rec_name = ‘dniPersona’
**● _order:** Será el orden de los registros. Ejemplo: _order=’dniPersona’ se
ordenará la lista por DNI.
**● _description:** Descripción del modelo.


Tipos de Datos

```
Tipo Descripción Ejemplo
```
```
Char Texto corto (max 255 car)
```
```
nombreCliente =
fields.Char(string="Nombre del
cliente")
```
```
Text Texto largo
```
```
descripcion =
fields.Text(string="Descripción"
)
```
```
Integer Número entero
```
```
potencia =
fields.Integer(string="Potencia
(CV)")
```
```
Float Número decimal
```
```
precio =
fields.Float(string="Precio")
```
```
Boolean True o False
```
```
activo =
fields.Boolean(string="Activo",
default=True)
```
```
Selection Lista de opciones
```
```
tipoEntrega = fields.Selection([
('domicilio', 'A
Domicilio'),
('concesionario', 'En
concesionario')
], default='concesionario',
string="Tipo de entrega",
required=True)
```
```
Date Fecha.
```
```
fechaVenta =
fields.Date(string="Fecha de
venta")
```
```
Datetime Fecha y hora
```
```
fechaVenta =
fields.Datetime(string="Fecha y
hora de venta")
```

Relaciones

```
Relación Descripción Ejemplo
```
```
Many2one
```
```
Relación de un sólo
registro con otro
modelo (N:1)
```
```
cocheVend =
fields.Many2one('concesionario.coc
hes', string="Coche vendido")
```
```
One2many
```
```
Relación inversa: Un
registro está
vinculado a múltiples
de otro modelo. (1:N)
```
```
ventas_ids =
fields.One2many('concesionario.ven
tas, 'cocheVend', string="Ventas
realizadas")
```
```
Many2many Relaciónmuchos^ de^ muchos (N:M) a^
```
```
accesorios_ids =
fields.Many2many('concesionario.ac
cesorio', string="Accesorios")
```
```
coches_ids =
fields.Many2many('concesionario.co
che', string="Coches compatibles")
```
2.3 concesionario/security/ir.model.access.csv

¿Cómo funciona un archivo CSV?

Un archivo **CSV (Comma-Separated Values)** es un formato de texto simple
utilizado para almacenar datos en forma de tabla. Cada línea del archivo
representa una fila, y los valores de cada columna están separados por comas
(,) u otros delimitadores como punto y coma (;).

¿Qué podemos encontrar en nuestro fichero csv?

id: Identificador único del registro de acceso.
name: Nombre del registro de acceso.
model_id:id: Identificador del modelo al que se le asignan los permisos.
group_id:id: Identificador del grupo al que se le asignan los permisos.
perm_read: Permiso de lectura (1 para permitir, 0 para denegar).
perm_write: Permiso de escritura (1 para permitir, 0 para denegar).
perm_create: Permiso de creación (1 para permitir, 0 para denegar).
perm_unlink: Permiso de eliminación (1 para permitir, 0 para denegar).

id,name,model_id:id,group_id:id,perm_read,perm_write,perm_create,perm_unlink


2.4 concesionario/views

views.xml

Este archivo configura la interfaz del módulo "Concesionario" en Odoo,
definiendo vistas (listas, formularios, gráficos), acciones para gestionar
registros y menús de navegación. Su función es organizar y optimizar la
presentación e interacción con los datos dentro del sistema.

Estructura General del Archivo:

```
<odoo>
<data>
...
</data>
</odoo>
```
<odoo>: Indica que este es un archivo XML de Odoo.
<data>: Contiene todas las configuraciones de vistas, acciones y menús.

Definición de Vistas de Lista (list)

Las **vistas de lista** permiten ver varios registros en una tabla.

Explicación
● **<record>** : Define un nuevo registro en el modelo ir.ui.view (vistas en
Odoo).
● **name="Listado de Ventas"** : Nombre de la vista.
● **model="concesionario.ventas"** : Esta vista se aplica al modelo
concesionario.ventas.
● **arch type="xml"** : Indica que la estructura de la vista está en XML.
● **<list>** : Define una vista de lista con los siguientes campos:
○ fechaVenta, fechaEntrega, cocheVend, tipoEntrega,
nombreCliente.
○ El width="20%" controla el ancho de cada columna.


Ejemplo: Vista de lista de ventas (concesionario.list)

```
<record model="ir.ui.view" id="concesionario.list">
<field name="name">Listado de Ventas</field>
<field name="model">concesionario.ventas</field>
<field name="arch" type="xml">
<list>
<field class="titulo" name="fechaVenta" width="20%"/>
<field name="fechaEntrega" width="20%"/>
<field name="cocheVend" width="20%"/>
<field name="tipoEntrega" width="20%"/>
<field name="nombreCliente" width="20%"/>
</list>
</field>
</record>
```
Ejemplo: Vista de lista de ventas (concesionario.list)

```
<record model="ir.ui.view" id="concesionario.marcas_list">
<field name="name">Listado de Marcas</field>
<field name="model">concesionario.marcas</field>
<field name="arch" type="xml">
<list>
<field name="nombre"/>
<field name="ciudad"/>
<field name="descripcion"/>
</list>
</field>
</record>
```

Formularios Personalizados

Los **formularios personalizados** nos permiten crear formularios con diferentes
estilos y con los campos que nosotros queramos.

Explicación
● **<record>** : Define un nuevo registro en el modelo ir.ui.view (vistas en
Odoo).
● **name="Formulario Venta de Coches"** : Nombre de la vista.
● **model="concesionario.ventas"** : Esta vista se aplica al modelo
concesionario.ventas.
● **arch type="xml"** : Indica que la estructura de la vista está en XML.
● **<form>** : Indica que estamos creando un formulario.
● **<sheet>** : Contenedor donde se colocan los campos del formulario.
● **<group>** : Grupo que organiza varios campos juntos. Ideal para aplicar
estilos personalizados.
● **<field name=”campoModelo”>** : Representa un campo que se mostrará
en el formulario y que podremos rellenar.

Ejemplo: Formulario de Venta de Coches (concesionario.form)

```
<record model="ir.ui.view" id="concesionario.form">
<field name="name">Formulario Venta de coches</field>
<field name="model">concesionario.ventas</field>
<field name="arch" type="xml">
<form>
<sheet>
<group class="formulario">
<field name="fechaVenta" width="50%" />
<field name="fechaEntrega" width="50%"/>
<field name="tipoEntrega" required="1" width="50%"/>
<field name="nombreCliente" width="50%"/>
</group>
<group>
<field name="cocheVend"/>
</group>
</sheet>
</form>
</field>
</record>
```

Acciones de Ventana

Las **Acciones de Ventana** son las que determinan qué ocurrirá cuando un
usuario interactúe con un menú en la interfaz de Odoo.

Explicación
● **ir.actions.act_window** : Define una acción que abre una ventana, en
este caso, abre la vista de las ventas.
● **res_model** : Especifica el modelo de datos que contiene la información.
● **view_mode=”list,form”** : Define que la vista puede ser de tipo lista o
formulario.

Ejemplo: Ventana de Ventas

```
<record model="ir.actions.act_window"
id="concesionario.action_window">
<field name="name">Ventana de Ventas</field>
<field name="res_model">concesionario.ventas</field>
<field name="view_mode">list,form</field>
</record>
```

Elementos de Menú

Los **Elementos de Menú** son la forma en la que los usuarios acceden a las
vistas.

Explicación
● **menuitem** : Define un ítem o elemento de menú en la interfaz.
● **name** : El nombre del menú que aparecerá en la interfaz de usuario.
● **parent** : Especifica el menú principal o categoría bajo la cual aparece
este ítem.
● **action** : Relaciona el ítem de menú con una acción específica (en este
caso, las acciones de ventana como concesionario.action_window,
concesionario.coches_action_window, etc.).
● En este ejemplo, se están creando tres elementos de menú dentro de un
menú principal llamado **"Datos"** :
○ **Ventas** : Abre la acción de ventana para las ventas
(concesionario.action_window).
○ **Coches** : Abre la acción de ventana para los coches
(concesionario.coches_action_window).
○ **Marcas** : Abre la acción de ventana para las marcas
(concesionario.marcas_action_window).

Ejemplo:

```
<menuitem name="concesionario" id="concesionario.menu_root"/>
```
```
<menuitem name="Datos" id="concesionario.menu_1"
parent="concesionario.menu_root"/>
```
```
<menuitem name="Ventas" id="concesionario.menu_1_list"
parent="concesionario.menu_1"
action="concesionario.action_window"/>
```
```
<menuitem name="Coches" id="concesionario.ventas_menu_1_list"
parent="concesionario.menu_1"
action="concesionario.coches_action_window"/>
<menuitem name="Marcas" id="concesionario.marcas_menu_1_list"
parent="concesionario.menu_1"
action="concesionario.marcas_action_window"/>
```

2.5 concesionario/demo

En muchas ocasiones, al instalar un módulo en Odoo, este puede incluir datos
de ejemplo que se cargan automáticamente para facilitar las pruebas y la
demostración de funcionalidades. Para lograr esto, es necesario definir un
archivo XML con los registros que se desean predefinir. El archivo demo.xml se
debe ubicar dentro de un directorio denominado demo o data, dependiendo
de la organización del módulo.

```
<?xml version="1.0" encoding="utf-8"?>
<odoo>
<!-- Datos de marcas -->
<record id="marca_toyota" model="concesionario.marcas">
<field name="nombre">Toyota</field>
<field name="ciudad">Tokio</field>
<field name="descripcion">Fabricante japonés de
automóviles.</field>
</record>
```
```
<!-- Datos de coches -->
<record id="coche_corolla" model="concesionario.coches">
<field name="modelo">Corolla</field>
<field name="marca" ref="marca_toyota"/>
<field name="potencia">140</field>
<field name="precio">22000</field>
</record>
```
```
<!-- Datos de ventas -->
<record id="venta_1" model="concesionario.ventas">
<field name="fechaVenta">2024-01-15</field>
<field name="fechaEntrega">2024-01-20</field>
<field name="cocheVend" ref="coche_corolla"/>
<field name="tipoEntrega">domicilio</field>
<field name="nombreCliente">Juan Pérez</field>
</record>
</odoo>
```

2.6 concesionario/controllers

El controlador será el que se encargue de manejar las peticiones HTTP,
procesar la lógica de negocio y renderizar las vistas o responder con datos.

Creación de la clase

Crearemos una clase con el nombre de nuestro módulo que contendrá todos
los métodos que necesitamos.

```
from odoo import http
```
```
class Ventas(http.Controller):
```
Primer método

En este método, al acceder a esta ruta nos devolverá “Hello, world”. Con
**auth=’public’** indicará que la ruta es pública, por lo que no requiere
autenticación para acceder.

```
@http.route('/concesionario/ventas/', auth='public')
def index(self, **kw):
return "Hello, world"
```
Método para obtener todas las ventas en una vista

La ruta de este método define la URL en la que el controller responderá. Al
acceder a esta ruta, Odoo ejecutará el método **list.**

El método **list** obtiene todos los registros del modelo **concesionario.ventas** a
través de la vista **concesionario.listing**.

```
@http.route('/concesionario/ventas/objects/', auth='public')
def list(self, **kw):
return http.request.render('concesionario.listing', {
'root': '/concesionario/ventas,
'objects':
http.request.env['concesionario.ventas'].search([]),
})
```
Método para obtener venta por ID.

A través de una URL dinámica **(<model(“concesionario.ventas”):obj>/)** cogemos
un registro específico de una venta basándonos en la ID.

El método recibe el **obj** como parámetro, que es el objeto del modelo venta
correspondiente al ID introducido en la URL.


Después se renderiza la vista **concesionario.object** con el objeto capturado
para mostrar sus detalles.

```
@http.route('/concesionario/ventas/objects/<model("concesionario.v
entas"):obj>/', auth='public')
def object(self, obj, **kw):
return http.request.render('concesionario.object', {
'object': obj
})
```
2.7 concesionario/static/description/icon.png

Para añadir una imagen de nuestro módulo y que se vea así:

Tendremos que hacer lo siguiente:

1. Tendremos que crear una carpeta **static** dentro del directorio de
    nuestro módulo.
2. Dentro de **static** , crearemos otra carpeta llamada **description.**
3. Dentro de **description** , introduciremos nuestra imagen en formato png y
    la llamaremos **icon.png**.

2.8 concesionario/static/src/scss/concesionario.scss

En esta dirección será donde crearemos nuestra hoja SCSS para poder
aplicar estilos a nuestras vistas.
Para que funcione correctamente tenemos que añadir lo siguiente en el
**manifest:**

```
'assets': {
'web.assets_backend': [
'concesionario/static/src/scss/concesionario.scss',
]
},
```
Ahora en nuestro archivo SCSS podremos poner estilos. Y en nuestro **views.xml**
podremos aplicar las clases. Por ejemplo:

```
.formulario {
background-color: blue;
}
```

En views.xml en **concesionario.form** :

```
<form>
<sheet>
<group class="formulario" >
<field name="fechaVenta" width="50%" />
<field name="fechaEntrega" width="50%"/>
<field name="tipoEntrega" required="1" width="50%"/>
<field name="nombreCliente" width="50%"/>
</group>
<group>
<field name="cocheVend"/>
</group>
</sheet>
</form>
```
Y se vería así:

2.9 __init__.py

El archivo **__init__.py** es fundamental porque define qué archivos deben
cargarse cuando el módulo se ejecuta. Vamos a ver por ejemplo el __init__.py
principal:

```
# -*- coding: utf-8 -*-
```
```
from. import controllers
from. import models
```

En los directorios de nuestra estructura , en modelo y controlador, habrá un
archivo como este. Por ejemplo, en modelo será así:

```
# -*- coding: utf-8 -*-
```
```
from. import models
```

