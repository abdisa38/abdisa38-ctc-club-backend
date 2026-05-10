#!/bin/bash

# CTC-Club Heroku Deployment Script
# Run this script after installing Heroku CLI and setting up MongoDB Atlas

echo "🚀 CTC-Club Heroku Deployment Setup"
echo "======================================"

# Check if Heroku CLI is installed
if ! command -v heroku &> /dev/null; then
    echo "❌ Heroku CLI is not installed. Please install it first:"
    echo "   https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

echo "✅ Heroku CLI found"

# Login to Heroku
echo "📝 Logging into Heroku..."
heroku login

# Get app name from user
read -p "Enter your Heroku app name (e.g., ctc-club-backend-2024): " APP_NAME

# Create Heroku app
echo "🏗️  Creating Heroku app: $APP_NAME"
heroku create $APP_NAME

# Set basic environment variables
echo "⚙️  Setting basic environment variables..."
heroku config:set NODE_ENV=production --app $APP_NAME
heroku config:set PORT=5000 --app $APP_NAME

# Get MongoDB URI from user
echo ""
echo "📊 MongoDB Atlas Setup Required:"
echo "1. Go to https://www.mongodb.com/atlas"
echo "2. Create a free cluster"
echo "3. Create a database user"
echo "4. Allow access from anywhere (0.0.0.0/0)"
echo "5. Get your connection string"
echo ""
read -p "Enter your MongoDB connection string: " MONGO_URI
heroku config:set MONGO_URI="$MONGO_URI" --app $APP_NAME

# Get JWT secret
read -p "Enter a strong JWT secret (32+ characters): " JWT_SECRET
heroku config:set JWT_SECRET="$JWT_SECRET" --app $APP_NAME

# Get email settings
echo ""
echo "📧 Email Setup (Gmail App Password Required):"
read -p "Enter your Gmail address: " SMTP_USER
read -p "Enter your Gmail app password (16 characters): " SMTP_PASS
heroku config:set SMTP_HOST=smtp.gmail.com --app $APP_NAME
heroku config:set SMTP_PORT=587 --app $APP_NAME
heroku config:set SMTP_USER="$SMTP_USER" --app $APP_NAME
heroku config:set SMTP_PASS="$SMTP_PASS" --app $APP_NAME
heroku config:set SMTP_FROM="CTC Club <$SMTP_USER>" --app $APP_NAME

# Set other variables
heroku config:set CLIENT_URL=http://localhost:3000 --app $APP_NAME
heroku config:set PASSWORD_RESET_CODE_TTL_MINUTES=10 --app $APP_NAME

# Initialize git if needed
if [ ! -d ".git" ]; then
    echo "🔧 Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit for Heroku deployment"
fi

# Deploy to Heroku
echo "🚀 Deploying to Heroku..."
git push heroku main || git push heroku master

echo ""
echo "🎉 Deployment complete!"
echo "Your app is available at: https://$APP_NAME.herokuapp.com"
echo "API endpoint: https://$APP_NAME.herokuapp.com/api"
echo ""
echo "To check logs: heroku logs --tail --app $APP_NAME"
echo "To open app: heroku open --app $APP_NAME"