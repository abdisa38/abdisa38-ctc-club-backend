import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config();

const MONGO_URI = 'mongodb+srv://abdisaawel313_db_user:XsmVsIvk84PJcUF5@cluster0.bcplrnn.mongodb.net/?appName=Cluster0';

const restoreCourses = async () => {
  try {
    console.log('Connecting to MongoDB...');
    await mongoose.connect(MONGO_URI);
    console.log('✓ Connected to MongoDB');

    // Get the Course collection directly (bypassing the model middleware)
    const db = mongoose.connection.db;
    const coursesCollection = db.collection('courses');

    // Find all soft-deleted courses
    const deletedCourses = await coursesCollection.find({ isDeleted: true }).toArray();
    console.log(`\nFound ${deletedCourses.length} soft-deleted courses:`);
    
    deletedCourses.forEach((course: any, index: number) => {
      console.log(`  ${index + 1}. ${course.title} (${course.category}) - $${course.price}`);
    });

    if (deletedCourses.length === 0) {
      console.log('\n✓ No deleted courses to restore.');
      process.exit(0);
    }

    // Restore all soft-deleted courses
    console.log('\nRestoring courses...');
    const result = await coursesCollection.updateMany(
      { isDeleted: true },
      { $set: { isDeleted: false } }
    );

    console.log(`\n✓ Successfully restored ${result.modifiedCount} courses!`);
    console.log('\nRestored courses are now visible in the admin dashboard.');
    
    process.exit(0);
  } catch (error) {
    console.error('Error:', (error as Error).message);
    process.exit(1);
  }
};

restoreCourses();
