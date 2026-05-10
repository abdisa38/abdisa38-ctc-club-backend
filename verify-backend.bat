@echo off
echo 🔍 Verifying Backend Directory
echo =============================
echo.

echo Checking if we're in the backend directory...
if not exist "package.json" (
    echo ❌ package.json not found
    echo You need to be in the CTC-Club1/backend directory
    pause
    exit /b 1
)

echo ✅ package.json found
echo.

echo Checking if this is the backend package.json...
findstr /C:"express" package.json >nul
if %errorlevel% neq 0 (
    echo ❌ This doesn't look like the backend package.json
    echo Make sure you're in CTC-Club1/backend, not CTC-Club1
    pause
    exit /b 1
)

echo ✅ This is the backend package.json (contains Express)
echo.

echo Checking for required files...
if exist "Procfile" (echo ✅ Procfile exists) else (echo ❌ Procfile missing)
if exist "tsconfig.json" (echo ✅ tsconfig.json exists) else (echo ❌ tsconfig.json missing)
if exist "src\server.ts" (echo ✅ src\server.ts exists) else (echo ❌ src\server.ts missing)

echo.
echo Checking build...
npm run build
if %errorlevel% equ 0 (
    echo ✅ Build successful
) else (
    echo ❌ Build failed
    pause
    exit /b 1
)

echo.
echo 🎉 Backend verification complete!
echo You're ready to deploy the backend.
echo.
pause