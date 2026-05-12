# Local Development Setup (Optional)

## ⚠️ Important Note

**You don't need to run the backend locally!** 

The backend is already running on Heroku at:
- **URL**: https://ctc-14efa787b23a.herokuapp.com/api

The frontend is configured to use the Heroku backend, so you can just:
1. Work on the frontend code
2. Push changes to GitHub
3. Vercel will automatically deploy

---

## If You Want to Run Backend Locally (Optional)

### Step 1: Create `.env` File

Copy the `.env.example` file to `.env`:

```bash
cd abdisa38-ctc-club-backend
cp .env.example .env
```

Or on Windows:
```bash
copy .env.example .env
```

### Step 2: Fill in Environment Variables

Open `.env` and add your values:

```env
PORT=5000
NODE_ENV=development
MONGO_URI=mongodb+srv://your-username:your-password@cluster.mongodb.net/ctc-club?retryWrites=true&w=majority
JWT_SECRET=your_super_secret_jwt_key_here
CLIENT_URL=http://localhost:5173
SERVER_URL=http://localhost:5000

# Optional OAuth (can leave empty for local dev)
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
GITHUB_CLIENT_ID=
GITHUB_CLIENT_SECRET=

# Optional Email (can leave empty for local dev)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=
SMTP_PASS=
SMTP_FROM="CTC Club <noreply@ctcclub.com>"

PASSWORD_RESET_CODE_TTL_MINUTES=10
```

### Step 3: Get MongoDB Connection String

You need to get the MongoDB connection string from your MongoDB Atlas account:

1. Go to: https://cloud.mongodb.com/
2. Login to your account
3. Click "Connect" on your cluster
4. Choose "Connect your application"
5. Copy the connection string
6. Replace `<password>` with your actual password
7. Paste it into the `MONGO_URI` in your `.env` file

### Step 4: Run Backend Locally

```bash
cd abdisa38-ctc-club-backend
npm run dev
```

The backend will start on: http://localhost:5000

### Step 5: Update Frontend to Use Local Backend

If you want the frontend to use your local backend instead of Heroku:

1. Open `CTC-Club1/src/app/utils/api.ts`
2. Change the `baseURL` from:
   ```typescript
   baseURL: 'https://ctc-14efa787b23a.herokuapp.com/api'
   ```
   To:
   ```typescript
   baseURL: 'http://localhost:5000/api'
   ```

3. Run the frontend:
   ```bash
   cd CTC-Club1
   npm run dev
   ```

---

## ✅ Recommended Workflow (No Local Backend)

**For most development, you don't need to run the backend locally!**

### What You Should Do:

1. **Frontend Development**:
   ```bash
   cd CTC-Club1
   npm run dev
   ```
   - Frontend runs on: http://localhost:5173
   - Uses Heroku backend: https://ctc-14efa787b23a.herokuapp.com/api

2. **Make Changes**:
   - Edit frontend files in `CTC-Club1/src/`
   - Changes appear immediately (hot reload)

3. **Test Changes**:
   - Test on localhost: http://localhost:5173
   - Or test on Vercel: https://ctc-club-frontend.vercel.app/

4. **Deploy**:
   ```bash
   git add .
   git commit -m "your changes"
   git push origin main
   ```
   - Vercel automatically deploys frontend
   - Heroku automatically deploys backend (if you changed backend files)

---

## 🔧 Backend Changes Workflow

If you need to change backend code:

1. **Edit backend files** in `abdisa38-ctc-club-backend/src/`

2. **Test locally** (optional):
   - Set up `.env` file (see above)
   - Run `npm run dev`
   - Test with Postman or frontend

3. **Deploy to Heroku**:
   ```bash
   cd abdisa38-ctc-club-backend
   git add .
   git commit -m "your backend changes"
   git push origin main
   ```
   - Heroku automatically deploys
   - Wait 2-3 minutes
   - Test on: https://ctc-14efa787b23a.herokuapp.com/api

---

## 🆘 Current Issue: Avatar Upload

The avatar upload CORS error has been fixed on Heroku. You don't need to run the backend locally.

### What to Do Now:

1. **Stop the local backend** (if it's running):
   - Press `Ctrl + C` in the terminal

2. **Wait 2-3 minutes** for Heroku to deploy the fix

3. **Test avatar upload**:
   - Go to: https://ctc-club-frontend.vercel.app/app/settings
   - Click "Choose Image"
   - Upload an image
   - It should work now!

4. **If it still doesn't work**:
   - Clear browser cache: `Ctrl + Shift + R`
   - Check Heroku dashboard: https://dashboard.heroku.com/apps/ctc-14efa787b23a
   - Look for "Build succeeded" message

---

## 📝 Summary

- ❌ **Don't run backend locally** (unless you really need to)
- ✅ **Use Heroku backend** (already running and deployed)
- ✅ **Run frontend locally** for development
- ✅ **Push to GitHub** to deploy changes

---

## 📞 Contact

If you need help:
- Email: abdisaawel313@gmail.com
- Phone: 0938890645
- Telegram: @bdisa38
