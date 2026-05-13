import express, { type Application, type Request, type Response } from 'express';
import path from 'path';
import dotenv from 'dotenv';
import cors from 'cors';
import cookieParser from 'cookie-parser';
import connectDB from './config/db';
import { notFound, errorHandler } from './middleware/errorMiddleware';
import authRoutes from './routes/authRoutes';
import courseRoutes from './routes/courseRoutes';
import lessonRoutes from './routes/lessonRoutes';
import quizRoutes from './routes/quizRoutes';
import projectRoutes from './routes/projectRoutes';
import supportRoutes from './routes/supportRoutes';
import dashboardRoutes from './routes/dashboardRoutes';
import communityRoutes from './routes/communityRoutes';
import notificationRoutes from './routes/notificationRoutes';
import uploadRoutes from './routes/uploadRoutes';
import eventRoutes from './routes/eventRoutes';
import resourceRoutes from './routes/resourceRoutes';

// Load env vars
dotenv.config();

// Connect to database
connectDB();

const app: Application = express();

// Body parser with increased limit for base64 images
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Serve uploaded lesson assets
app.use('/uploads', express.static(path.resolve(process.cwd(), 'uploads')));

// Cookie parser
app.use(cookieParser());

// Enable CORS - Allow all origins for now to fix connection issues
app.use(cors({
    origin: function (origin, callback) {
        // Allow requests with no origin (like mobile apps or curl requests)
        if (!origin) return callback(null, true);
        
        // Allow any origin and explicitly return it
        callback(null, origin);
    },
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Cookie'],
    exposedHeaders: ['Set-Cookie'],
}));

// Additional CORS headers as fallback
app.use((req: Request, res: Response, next) => {
    const origin = req.headers.origin;
    if (origin) {
        res.setHeader('Access-Control-Allow-Origin', origin);
    }
    res.setHeader('Access-Control-Allow-Credentials', 'true');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, Cookie');
    res.setHeader('Access-Control-Expose-Headers', 'Set-Cookie');
    
    // Handle preflight
    if (req.method === 'OPTIONS') {
        return res.sendStatus(200);
    }
    
    next();
});

// Basic Route for testing
app.get('/', (req: Request, res: Response) => {
    res.json({ message: 'CTC Club Backend is running successfully!' });
});

app.get('/api', (req: Request, res: Response) => {
    res.json({ message: 'Welcome to the CTC Club API' });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/courses', courseRoutes);
app.use('/api/quizzes', quizRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/support', supportRoutes);
app.use('/api/dashboard', dashboardRoutes);
app.use('/api/community', communityRoutes);
app.use('/api/notifications', notificationRoutes);
app.use('/api/uploads', uploadRoutes);
app.use('/api/events', eventRoutes);
// For operations purely based on LessonId (Update, Delete a lesson)
app.use('/api/lessons', lessonRoutes);
app.use('/api/resources', resourceRoutes);

// Error handling middleware
app.use(notFound);
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
});
