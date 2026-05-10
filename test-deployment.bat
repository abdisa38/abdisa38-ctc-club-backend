@echo off
echo 🧪 Testing CTC-Club Platform Deployment
echo =======================================
echo.

echo Testing API endpoint...
echo Opening: https://ctc-club-platform.herokuapp.com/api
start https://ctc-club-platform.herokuapp.com/api
echo.

echo Checking app status...
heroku ps --app ctc-club-platform
echo.

echo Recent logs:
heroku logs --tail --app ctc-club-platform --num 20
echo.

echo ✅ Test complete!
echo.
echo If the API shows: {"message":"Welcome to the CTC Club API"}
echo Then your deployment is successful! 🎉
echo.
pause