## Aclaración antes de participar

Es un proyecto Open Source, por lo que normalmente el código estará bajo licencia MIT y los asset bajo licencia CC-BY. Esto no quiere decir que en un futuro el proyecto pueda cambiar a ser un proyecto privativo. Normalmente vamos a querer hacer que el proyecto sea Open Source, pero por motivos de beneficio al proyecto se puede convertir a un proyecto privativo.

Si por algún motivo el juego cambia de licencia, prometemos dejar el código fuente de la última instancia en el cuál el proyecto era libre en Github.

## Forma de trabajo

Normalmente usamos estas herramientas principales: 
- HackNPlan : para la gestión de proyectos
- Github : Repositorio
- Discord : Comunicación

Para que el proceso de desarrollo sea más motivante sacamos versiones cada cierto tiempo. Puede ser cada un semana o cada un més, dependiendo lo que necesitemos cambiar para la próxima versión. Esto nos sirve para ir mostrando el juego y ir solucionando bugs y no concentrarnos totalmente en features, sino que tener una versión jugable para el final del milestone (objetivo del mes/semana).

## Ingreso al proyecto

Para ingresar al proyecto puede enviar un correo a writkas2{{at}}gmail{{dot}}com o también puede entrar al siguiente discord y preguntar por Matías y acerca de este proyecto: https://discord.gg/TpWVGfF

## Estructura del codigo.

Partimos con la Guia de estilo de Godot como base: http://docs.godotengine.org/en/3.0/getting_started/scripting/gdscript/gdscript_styleguide.html

## Estructura del proyecto.

### Carpetas principales y ubicacion de archivos

El proyecto se estructura de forma similar a esta:

```
.
├── addons
├── default_env.tres
├── icon.png
├── icon.png.import
├── LICENSE
├── project.godot
├── README.md
├── scenes
│   ├── actors
│   ├── autoloads
│   ├── backgrounds
│   ├── buttons
│   ├── effects
│   ├── hud
│   ├── items
│   └── main_screens
├── shaders
├── sounds
├── test_addons
├── tests
└── translations
```

### Carpetas y archivos

Las carpetas en snake_case y los archivos en CamelCase

### Nodos en el editor

En CamelCase

![Nodos en CamelCase](https://i.imgur.com/uoPPQHB.png)
