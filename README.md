# CTC-Club1 Backend — Heroku Deployment

This folder contains the Node + TypeScript backend for CTC-Club1. The repository is preconfigured for Heroku deployment.

Prerequisites
- Node 18.x (recommended)
- npm
- Git
- Heroku CLI (for deployment)
- A MongoDB Atlas URI for `MONGO_URI` (see notes)

Quick deploy steps (run from this folder):

```bash
cd CTC-Club1/backend
# initialize git if needed
git init
git add .
git commit -m "Prepare backend for Heroku deployment"

# login to Heroku (interactive)
heroku login

# create the app (or do this in the Dashboard)
heroku create your-app-name

# make sure Heroku installs devDependencies during build
heroku config:set NPM_CONFIG_PRODUCTION=false

# set required config vars (replace values)
heroku config:set MONGO_URI="your_mongo_connection_string"
heroku config:set JWT_SECRET="a_strong_secret"
heroku config:set CLIENT_URL="https://your-frontend-url"

# push to Heroku
git push heroku main

# tail logs
heroku logs --tail
```

Important notes
- The app build uses `tsc` to compile TypeScript to `dist` (see `tsconfig.json`).
- `Procfile` runs `node dist/server.js` so the `start` script must point to that file (already configured).
- Heroku filesystem is ephemeral: uploaded files in `/uploads` will be lost after dyno restarts. Use S3 or similar for persistence.
- You must provide your own MongoDB Atlas cluster — create a free cluster and a DB user, then copy the connection URI into `MONGO_URI`.

If you want, I can attempt to initialize git and create the Heroku app from here (Heroku CLI must be installed and you will need to login interactively). Otherwise I can walk you through the Atlas setup and config values.
