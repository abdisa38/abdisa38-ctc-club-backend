@echo off
REM CTC-Club Heroku Deployment Script for Windows
REM Run this script after installing Heroku CLI and setting up MongoDB Atlas

echo 🚀 CTC-Club Heroku Deployment Setup
echo ======================================

REM Check if Heroku CLI is installed
heroku --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Heroku CLI is not installed. Please install it first:
    echo    https://devcenter.heroku.com/articles/heroku-cli
    pause
    exit /b 1
)

echo ✅ Heroku CLI found

REM Login to Heroku
echo 📝 Logging into Heroku...
heroku login

REM Get app name from user
set /p APP_NAME=Enter your Heroku app name (e.g., ctc-club-backend-2024): 

REM Create Heroku app
echo 🏗️  Creating Heroku app: %APP_NAME%
heroku create %APP_NAME%

REM Set basic environment variables
echo ⚙️  Setting basic environment variables...
heroku config:set NODE_ENV=production --app %APP_NAME%
heroku config:set PORT=5000 --app %APP_NAME%

REM Get MongoDB URI from user
echo.
echo 📊 MongoDB Atlas Setup Required:
echo 1. Go to https://www.mongodb.com/atlas
echo 2. Create a free cluster
echo 3. Create a database user
echo 4. Allow access from anywhere (0.0.0.0/0)
echo 5. Get your connection string
echo.
set /p MONGO_URI=Enter your MongoDB connection string: 
heroku config:set MONGO_URI="%MONGO_URI%" --app %APP_NAME%

REM Get JWT secret
set /p JWT_SECRET=Enter a strong JWT secret (32+ characters): 
heroku config:set JWT_SECRET="%JWT_SECRET%" --app %APP_NAME%

REM Get email settings
echo.
echo 📧 Email Setup (Gmail App Password Required):
set /p SMTP_USER=Enter your Gmail address: 
set /p SMTP_PASS=Enter your Gmail app password (16 characters): 
heroku config:set SMTP_HOST=smtp.gmail.com --app %APP_NAME%
heroku config:set SMTP_PORT=587 --app %APP_NAME%
heroku config:set SMTP_USER="%SMTP_USER%" --app %APP_NAME%
heroku config:set SMTP_PASS="%SMTP_PASS%" --app %APP_NAME%
heroku config:set SMTP_FROM="CTC Club <%SMTP_USER%>" --app %APP_NAME%

REM Set other variables
heroku config:set CLIENT_URL=http://localhost:3000 --app %APP_NAME%
heroku config:set PASSWORD_RESET_CODE_TTL_MINUTES=10 --app %APP_NAME%

REM Initialize git if needed
if not exist ".git" (
    echo 🔧 Initializing Git repository...
    git init
    git add .
    git commit -m "Initial commit for Heroku deployment"
)

REM Deploy to Heroku
echo 🚀 Deploying to Heroku...
git push heroku main
if %errorlevel% neq 0 (
    git push heroku master
)

echo.
echo 🎉 Deployment complete!
echo Your app is available at: https://%APP_NAME%.herokuapp.com
echo API endpoint: https://%APP_NAME%.herokuapp.com/api
echo.
echo To check logs: heroku logs --tail --app %APP_NAME%
echo To open app: heroku open --app %APP_NAME%

pause