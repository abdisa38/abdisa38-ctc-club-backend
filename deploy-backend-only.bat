@echo off
echo 🚀 CTC-Club BACKEND ONLY Deployment Script
echo ==========================================
echo.

REM Check if we're in the backend directory
if not exist "package.json" (
    echo ❌ Error: package.json not found. Make sure you're in the backend directory.
    pause
    exit /b 1
)

REM Check if this is the backend package.json (not frontend)
findstr /C:"express" package.json >nul
if %errorlevel% neq 0 (
    echo ❌ Error: This doesn't look like the backend package.json
    echo Make sure you're in the CTC-Club1/backend directory, not the root CTC-Club1 directory
    pause
    exit /b 1
)

echo ✅ Found backend package.json - we're in the right directory
echo.

REM Check if Heroku CLI is installed
heroku --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Heroku CLI is not installed. Please install it first:
    echo    https://devcenter.heroku.com/articles/heroku-cli
    pause
    exit /b 1
)

echo ✅ Heroku CLI is installed
echo.

REM Login to Heroku
echo 📝 Please login to Heroku (browser will open)...
heroku login
if %errorlevel% neq 0 (
    echo ❌ Heroku login failed
    pause
    exit /b 1
)

echo ✅ Logged into Heroku
echo.

REM Try to create Heroku app (might already exist)
echo 🏗️  Creating Heroku app: ctc-club-platform
heroku create ctc-club-platform
echo Note: If app already exists, that's okay - we'll continue
echo.

REM Set all environment variables
echo ⚙️  Setting environment variables...

heroku config:set NODE_ENV=production --app ctc-club-platform
heroku config:set MONGO_URI="mongodb+srv://abdisaawel313_db_user:XsmVsIvk84PJcUF5@cluster0.bcplrnn.mongodb.net/?appName=Cluster0" --app ctc-club-platform
heroku config:set JWT_SECRET="ctc_super_secret_jwt_key_2024_secure" --app ctc-club-platform
heroku config:set CLIENT_URL="http://localhost:3000" --app ctc-club-platform
heroku config:set SMTP_HOST=smtp.gmail.com --app ctc-club-platform
heroku config:set SMTP_PORT=587 --app ctc-club-platform
heroku config:set SMTP_USER="abdisaawel313@gmail.com" --app ctc-club-platform
heroku config:set SMTP_PASS="A1B2C3D4E5f6g7h8j9" --app ctc-club-platform
heroku config:set SMTP_FROM="CTC Club <abdisaawel313@gmail.com>" --app ctc-club-platform
heroku config:set PASSWORD_RESET_CODE_TTL_MINUTES=10 --app ctc-club-platform

echo ✅ Environment variables set
echo.

REM Clean up any existing git remotes
git remote remove heroku 2>nul

REM Add Heroku remote
echo 🔧 Adding Heroku remote...
heroku git:remote -a ctc-club-platform

REM Add and commit all changes
echo 🔧 Preparing files for deployment...
git add .
git commit -m "Deploy CTC Club backend to Heroku" 2>nul || echo "No changes to commit"

echo.

REM Deploy to Heroku
echo 🚀 Deploying BACKEND ONLY to Heroku (this may take 2-5 minutes)...
echo This will deploy only the backend, not the frontend!
echo.

git push heroku master -f
if %errorlevel% neq 0 (
    echo Trying with main branch...
    git push heroku main -f
)

echo.
echo 🎉 Backend deployment complete!
echo.
echo Your BACKEND API is available at:
echo 🌐 Main App: https://ctc-club-platform.herokuapp.com
echo 🔗 API Endpoint: https://ctc-club-platform.herokuapp.com/api
echo.
echo Testing your API...
echo Opening browser to test API endpoint...
start https://ctc-club-platform.herokuapp.com/api
echo.
echo To check logs: heroku logs --tail --app ctc-club-platform
echo To restart app: heroku restart --app ctc-club-platform
echo.
echo ✅ If you see {"message":"Welcome to the CTC Club API"} in your browser,
echo    your backend deployment was successful!
echo.
pause