@echo off
setlocal enabledelayedexpansion
title FIX MySQL Data
REM Creado por Álvaro Mora
call "%~dp0config.bat"

if %debug%==1 (
    echo [DEBUG] Script ejecutandose en modo debug
)

REM Cambiar al directorio XAMPP. Se puede personalizar
cd /d %xampp_folder%

REM Verificar si existe la carpeta ./mysql/data
if not exist ".\mysql\data" (
    echo [ERROR] No se encontro la carpeta ".\mysql\data"
    goto:SALIR
)

REM Detener el proceso mysqld.exe si esta corriendo
echo [INFO]  Terminando proceso mysqld.exe...
taskkill /IM mysqld.exe /F >nul 2>&1

REM Borrar la carpeta ./mysql/data-old-tmp si existe
if exist ".\mysql\data-old-tmp" (
    echo [INFO]  Eliminando ".\mysql\data-old-tmp"...
    rmdir /s /q ".\mysql\data-old-tmp"
)

REM Renombrar ./mysql/data-old a ./mysql/data-old-tmp si existe
if exist ".\mysql\data-old" (
    echo [INFO]  Renombrando ".\mysql\data-old" a ".\mysql\data-old-tmp"...
    ren ".\mysql\data-old" "data-old-tmp"
)

REM Copiar ./mysql/data a ./mysql/data-old
echo [INFO]  Creando copia de seguridad de la carpeta data...
xcopy ".\mysql\data" ".\mysql\data-old" /E /I /H /Y >nul

REM Copiar archivos desde ./mysql/backup a ./mysql/data, excepto ibdata1
echo [INFO]  Restaurando archivos desde backup...
set "backupDir=%cd%\mysql\backup"
set "dataDir=%cd%\mysql\data"
for /r "%backupDir%" %%F in (*) do (
    set "fileName=%%~nxF"
    if /I not "!fileName!"=="ibdata1" (
        REM Obtener ruta relativa (sin la parte del backupDir)
        set "relPath=%%~dpF"
        set "relPath=!relPath:%backupDir%=!"
        
        REM Crear carpeta destino si no existe
        if not exist "%dataDir%!relPath!" (
            mkdir "%dataDir%!relPath!" >nul 2>&1
        )
        
        if %debug%==1 (
            echo [DEBUG] Copiando !relPath!!fileName!...
        )
        copy /Y "%%F" "%dataDir%!relPath!!fileName!" >nul
    ) else (
        echo [INFO]  Omitiendo ibdata1
    )
)

REM Borrar la carpeta ./mysql/data-old-tmp si existe
if exist ".\mysql\data-old-tmp" (
    echo [INFO]  Eliminando ".\mysql\data-old-tmp"...
    rmdir /s /q ".\mysql\data-old-tmp"
)

echo.
echo [OK]    Proceso completado.
pause

:SALIR
echo.
echo Saliendo...
timeout -t 2 > NUL
endlocal
