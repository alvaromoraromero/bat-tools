# Introduccion
Repositorio con algunos scripts en bash de Windows (.bat) con utilidades varias.

> [!TIP]
> Coloca estos scripts en una ubicación que tengas en la variable PATH.
> De esta forma, podrás ejecutarlos desde cualquier ubicación en una terminal.

# Indice
Haz clic en el script sobre el que deseas obtener informaciñon adicional
- [fix-mysql](#fix-mysql) Reparar carpeta data de la instalacion mysql de XAMPP
- [localgit](#localgit) Gestionar un repositorio "bare" git remoto en un USB

# fix-mysql
## Reparar carpeta data de la instalacion mysql de XAMPP

> [!NOTE]
>Este script utiliza la ruta `C:\xampp` por defecto, puedes cambiarla modificando el script manualmente.

A veces, el servicio MySQL de XAMPP se cierra y deja la carpeta data corrupta. La solución a este problema generalmente es regenerar la carpeta data utilizando la carpeta backup como base. Todo esto lo hace este script de forma automática.

Tras detener el servicio de mysql y comprobar que la carpeta existe, el script comienza renombrando `data-old` (si existe de ejecuciones anteriores) a `data-old-tmp`. Dicha carpeta de destino es borrada al inicio y al final del script, por lo que su existencia es temporal para no perder datos en caso de un fallo durante la ejecución del script.

Una vez se ha renombrado la carpeta, se copia la carpeta `data` en `data-old` (nueva carpeta). Esta carpeta de destino nunca se borrará, hasta la próxima ejecución del script. Una vez hecha la copia de seguridad de la carpeta `data`, se copian TODOS los archivos de la carpeta `backup` en `data`, reescribiendo los archivos coincidentes a excepción del archivo `ibdata1`.

Hecho esto, el servicio de MySQL de XAMPP debería volver a funcionar con normalidad.

> [!IMPORTANT]
> Aunque el script hace copias de las carpetas que modifica, es recomendable hacer una copia completa de `xampp\mysql` antes de su ejecución para evitar pérdida de datos en caso de algun fallo inesperado.

# localgit
## Gestionar un repositorio "bare" git remoto en un USB

> [!TIP]
> Para omitir la pregunta para introducir la ruta contenedora de repositorios en el USB, se puede dar un valor fijo a la variable `localgitpath`. Ten en cuenta que si la letra de unidad del USB cambia, será necesario actualizar el valor fijado de la variable.

Cuando se inicia el script, comprueba si la ruta desde la que se ha iniciado tiene un repositorio de git inicializado.
En caso negativo o que se indique que no se desea utilizar dicho repositorio, buscará y listará los repositorios en `C:\ProgramData\workspace`. Puedes cambiar esta ruta modificando el script manualmente.

Una vez seleccionado un repositorio, siempre mostrará una pantalla de confirmacion en la que se indica la ubicación del repositorio local y la que utilizará en el USB. Si existe, mostrará el menú principal y en caso contrario el menú de inicio de clonado en USB.

Una vez se ha clonado un repositorio en un USB siempre mostrará el menú principal para dicho repositorio, hasta que se elimine o se renombre.