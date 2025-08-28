@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

REM Diretório do script
set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%"

REM Ativa o venv se existir
if exist ".venv311\Scripts\activate.bat" (
  call ".venv311\Scripts\activate.bat"
) else (
  echo [ATENCAO] .venv311 nao encontrado. Crie o ambiente e instale as dependencias.
)

REM Argumentos: CODIGO_AF TWO_CAPTCHA_API_KEY USUARIO SENHA
set "CODIGO_AF=%~1"
set "TWO_CAPTCHA_API_KEY=%~2"
set "USUARIO=%~3"
set "SENHA=%~4"

if "%CODIGO_AF%"=="" set /p CODIGO_AF="Informe CODIGO_AF: "
if "%TWO_CAPTCHA_API_KEY%"=="" set /p TWO_CAPTCHA_API_KEY="Informe TWO_CAPTCHA_API_KEY: "
if "%USUARIO%"=="" set /p USUARIO="Informe USUARIO (login/e-mail): "

if "%SENHA%"=="" (
  for /f "usebackq delims=" %%i in (`powershell -NoProfile -Command "$p = Read-Host 'Informe SENHA' -AsSecureString; $bptr=[Runtime.InteropServices.Marshal]::SecureStringToBSTR($p); [Runtime.InteropServices.Marshal]::PtrToStringAuto($bptr)"`) do set "SENHA=%%i"
)

python "%SCRIPT_DIR%main.py" -c "%CODIGO_AF%" -k "%TWO_CAPTCHA_API_KEY%" -u "%USUARIO%" -p "%SENHA%"
set "ERR=%ERRORLEVEL%"

popd
exit /b %ERR%