@echo off
echo 📤 Pushing Backend to GitHub
echo ============================
echo.

echo Repository: https://github.com/abdisa38/abdisa38-ctc-club-backend
echo.

echo Pushing to GitHub...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ✅ Successfully pushed to GitHub!
    echo.
    echo Your backend repository is now at:
    echo https://github.com/abdisa38/abdisa38-ctc-club-backend
    echo.
    echo Next step: Connect this repository to Heroku
) else (
    echo.
    echo ❌ Push failed. You may need to:
    echo 1. Create the repository on GitHub first
    echo 2. Make sure you're logged into Git
    echo.
    echo To login to Git:
    echo git config --global user.name "Your Name"
    echo git config --global user.email "your.email@gmail.com"
)

echo.
pause