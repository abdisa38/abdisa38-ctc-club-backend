#!/usr/bin/env node

/**
 * Pre-deployment test script for CTC-Club backend
 * This script checks if everything is ready for Heroku deployment
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('🧪 CTC-Club Pre-Deployment Test');
console.log('================================\n');

let allTestsPassed = true;

function test(description, testFn) {
  try {
    const result = testFn();
    if (result) {
      console.log(`✅ ${description}`);
    } else {
      console.log(`❌ ${description}`);
      allTestsPassed = false;
    }
  } catch (error) {
    console.log(`❌ ${description}: ${error.message}`);
    allTestsPassed = false;
  }
}

// Test 1: Check if required files exist
test('Procfile exists', () => fs.existsSync('Procfile'));
test('package.json exists', () => fs.existsSync('package.json'));
test('tsconfig.json exists', () => fs.existsSync('tsconfig.json'));
test('.env.example exists', () => fs.existsSync('.env.example'));
test('.gitignore exists', () => fs.existsSync('.gitignore'));

// Test 2: Check package.json configuration
test('package.json has engines specified', () => {
  const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
  return pkg.engines && pkg.engines.node;
});

test('package.json has heroku-postbuild script', () => {
  const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
  return pkg.scripts && pkg.scripts['heroku-postbuild'];
});

test('package.json has correct start script', () => {
  const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
  return pkg.scripts && pkg.scripts.start === 'node dist/server.js';
});

// Test 3: Check TypeScript compilation
test('TypeScript compiles without errors', () => {
  try {
    execSync('npm run build', { stdio: 'pipe' });
    return true;
  } catch (error) {
    console.log(`   Build error: ${error.message}`);
    return false;
  }
});

// Test 4: Check if dist folder was created
test('Build output (dist folder) exists', () => fs.existsSync('dist'));

// Test 5: Check if main server file was compiled
test('Compiled server.js exists', () => fs.existsSync('dist/server.js'));

// Test 6: Check .gitignore contents
test('.gitignore includes .env', () => {
  const gitignore = fs.readFileSync('.gitignore', 'utf8');
  return gitignore.includes('.env');
});

test('.gitignore includes node_modules', () => {
  const gitignore = fs.readFileSync('.gitignore', 'utf8');
  return gitignore.includes('node_modules');
});

// Test 7: Check if sensitive files are not committed (this is good for security)
test('.env file is properly ignored by git', () => {
  try {
    const result = execSync('git ls-files .env', { stdio: 'pipe', encoding: 'utf8' });
    if (result.trim()) {
      console.log('   Warning: .env file is tracked by git (security risk)');
      return false; // If .env is tracked, that's bad
    }
    return true;
  } catch (error) {
    return true; // If .env is not tracked, that's good
  }
});

// Test 8: Check dependencies
test('All dependencies are installed', () => {
  return fs.existsSync('node_modules') && fs.existsSync('package-lock.json');
});

// Test 9: Check for common issues
test('Main server file compiled successfully', () => {
  return fs.existsSync('dist/server.js');
});

console.log('\n' + '='.repeat(50));

if (allTestsPassed) {
  console.log('🎉 ALL TESTS PASSED!');
  console.log('✅ Your project is ready for Heroku deployment!');
  console.log('\nNext steps:');
  console.log('1. Setup MongoDB Atlas');
  console.log('2. Setup Gmail App Password');
  console.log('3. Run heroku-setup.sh (Mac/Linux) or heroku-setup.bat (Windows)');
} else {
  console.log('❌ SOME TESTS FAILED!');
  console.log('Please fix the issues above before deploying to Heroku.');
  process.exit(1);
}

console.log('\n📚 For detailed instructions, see:');
console.log('   - DEPLOYMENT-CHECKLIST.md');
console.log('   - deploy-guide.md');