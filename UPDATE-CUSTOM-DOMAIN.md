# 🌐 Custom Domain Configuration Guide

## ✅ WHAT I'VE DONE FOR YOU (COMPLETED)

- [x] Updated CORS configuration in `src/server.ts` to allow your custom domain
- [x] Added `https://ctc2026.codes` to allowed origins
- [x] Added `https://www.ctc2026.codes` to allowed origins
- [x] Kept localhost URLs for local development
- [x] Made CORS more secure (no longer allows all origins)
- [x] Committed changes to Git
- [x] Pushed to GitHub (Heroku will auto-deploy)

## 📋 WHAT YOU NEED TO DO NOW

### STEP 1: Update Heroku Environment Variable (REQUIRED)

Your backend needs to know about your new custom domain. Follow these steps:

#### Option A: Using Heroku Dashboard (Easiest)

1. **Go to Heroku Dashboard**
   - Visit: https://dashboard.heroku.com/apps
   - Click on your backend app

2. **Navigate to Settings**
   - Click the "Settings" tab at the top

3. **Reveal Config Vars**
   - Scroll down to "Config Vars" section
   - Click "Reveal Config Vars" button

4. **Update CLIENT_URL**
   - Find the variable named `CLIENT_URL`
   - Change its value from your old Vercel URL to: `https://ctc2026.codes`
   - Click "Save" or it saves automatically

5. **Verify Other Variables**
   Make sure these are set correctly:
   ```
   CLIENT_URL = https://ctc2026.codes
   NODE_ENV = production
   JWT_SECRET = (your secret key)
   MONGO_URI = (your MongoDB connection string)
   SMTP_HOST = smtp.gmail.com
   SMTP_PORT = 587
   SMTP_USER = (your email)
   SMTP_PASS = (your Gmail app password)
   ```

#### Option B: Using Heroku CLI (Alternative)

If you prefer command line:

```bash
# Navigate to your backend folder
cd abdisa38-ctc-club-backend

# Login to Heroku (if not already logged in)
heroku login

# Update CLIENT_URL
heroku config:set CLIENT_URL=https://ctc2026.codes

# Verify it's set correctly
heroku config:get CLIENT_URL
```

### STEP 2: Wait for Heroku to Redeploy (5-10 minutes)

After pushing to GitHub, Heroku will automatically:
1. Detect the new code
2. Build the application
3. Deploy the updated version
4. Restart the server with new CORS settings

**Check deployment status:**
```bash
# View recent activity
heroku releases

# Watch logs in real-time
heroku logs --tail
```

Or check in Heroku Dashboard → Activity tab

### STEP 3: Verify CORS is Working

Once Heroku finishes deploying:

1. **Open your new domain**: https://ctc2026.codes
2. **Open browser console**: Press F12 → Console tab
3. **Try to login or use any feature**
4. **Check for errors**:
   - ✅ **No CORS errors** = Everything working!
   - ❌ **CORS error** = See troubleshooting below

## 🔍 VERIFICATION CHECKLIST

After completing the steps above:

- [ ] Heroku deployment completed successfully
- [ ] `CLIENT_URL` environment variable is set to `https://ctc2026.codes`
- [ ] Your custom domain loads the site
- [ ] Login works without CORS errors
- [ ] API calls work (check browser console - F12)
- [ ] No "blocked by CORS" errors in console

## 🚨 TROUBLESHOOTING

### Problem: Still getting CORS errors

**Solution 1: Check Heroku logs**
```bash
heroku logs --tail
```
Look for messages like: `CORS blocked origin: https://...`

**Solution 2: Verify CLIENT_URL is set**
```bash
heroku config:get CLIENT_URL
```
Should return: `https://ctc2026.codes`

**Solution 3: Manually restart Heroku**
```bash
heroku restart
```

**Solution 4: Check if deployment finished**
- Go to Heroku Dashboard → Activity tab
- Make sure latest deployment shows "Deployed"

### Problem: Heroku not auto-deploying

**Solution:**
```bash
# Force push to Heroku
git push heroku main

# Or if you don't have heroku remote:
heroku git:remote -a your-app-name
git push heroku main
```

### Problem: Environment variable not updating

**Solution:**
1. Delete the old CLIENT_URL in Heroku dashboard
2. Add it again with the new value
3. Restart the app: `heroku restart`

## 📝 WHAT CHANGED IN THE CODE

### Before (Insecure - Allowed ALL origins):
```typescript
app.use(cors({
    origin: function (origin, callback) {
        // Allow any origin
        callback(null, origin);
    },
    credentials: true,
}));
```

### After (Secure - Only allowed origins):
```typescript
const allowedOrigins = [
    'https://ctc2026.codes',
    'https://www.ctc2026.codes',
    'http://localhost:5173',
    'http://localhost:3000',
    process.env.CLIENT_URL,
];

app.use(cors({
    origin: function (origin, callback) {
        if (!origin) return callback(null, true);
        
        if (allowedOrigins.includes(origin)) {
            callback(null, true);
        } else {
            console.log(`CORS blocked origin: ${origin}`);
            callback(new Error('Not allowed by CORS'));
        }
    },
    credentials: true,
}));
```

## 🎯 BENEFITS OF THIS UPDATE

✅ **More Secure**: Only your domains can access the API
✅ **Custom Domain Support**: Works with ctc2026.codes
✅ **www Support**: Works with www.ctc2026.codes
✅ **Local Development**: Still works on localhost
✅ **Flexible**: Uses CLIENT_URL environment variable
✅ **Better Logging**: Shows blocked origins in logs

## 📞 NEED HELP?

If you're still having issues:

1. **Check Heroku logs**: `heroku logs --tail`
2. **Check browser console**: F12 → Console tab
3. **Verify environment variables**: `heroku config`
4. **Test API directly**: Visit `https://your-app.herokuapp.com/api`

## 🎉 SUCCESS!

Your backend is now configured to work with your custom domain!

**What works now:**
- ✅ https://ctc2026.codes can access your API
- ✅ https://www.ctc2026.codes can access your API
- ✅ localhost still works for development
- ✅ More secure (blocks unauthorized domains)
- ✅ Professional custom domain setup

---

**Next Steps:**
1. Complete the Vercel domain setup (DNS configuration)
2. Update CLIENT_URL on Heroku (this guide)
3. Test everything works
4. Celebrate! 🎉
