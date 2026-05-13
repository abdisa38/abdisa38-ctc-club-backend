import mongoose from 'mongoose';
import dotenv from 'dotenv';
import Course from './src/models/courseModel';

dotenv.config();

const MONGO_URI = 'mongodb+srv://abdisaawel313_db_user:XsmVsIvk84PJcUF5@cluster0.bcplrnn.mongodb.net/?appName=Cluster0';

const restoreCourses = async () => {
  try {
    console.log('Connecting to MongoDB...');
    await mongoose.connect(MONGO_URI);
    console.log('✓ Connected to MongoDB');

    // Find all soft-deleted courses (bypassing the query middleware)
    const deletedCourses = await Course.find({ isDeleted: true }).lean();
    console.log(`\nFound ${deletedCourses.length} soft-deleted courses:`);
    
    if (deletedCourses.length === 0) {
      console.log('No deleted courses to restore.');
      process.exit(0);
    }

    deletedCourses.forEach((course: any, index: number) => {
      console.log(`${index + 1}. ${course.title} (${course.status})`);
    });

    // Restore all soft-deleted courses by setting isDeleted to false
    const result = await Course.updateMany(
      { isDeleted: true },
      { $set: { isDeleted: false } }
    );

    console.log(`\n✓ Successfully restored ${result.modifiedCount} courses!`);
    console.log('\nYou can now see these courses in your admin dashboard.');
    
    process.exit(0);
  } catch (error) {
    console.error('Error restoring courses:', error);
    process.exit(1);
  }
};

restoreCourses();
