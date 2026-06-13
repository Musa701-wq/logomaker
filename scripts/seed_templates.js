const admin = require('firebase-admin');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const serviceAccount = require('./service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'logo-creation-13cea.firebasestorage.app',
});

const bucket = admin.storage().bucket();
const db = admin.firestore();

const STORAGE_ROOT = 'musaf';
const IGNORE_FOLDERS = ['fonts'];
const TARGET_FOLDERS = ['background', 'logo', 'shapes'];

const ALLOWED_EXTENSIONS = ['.png', '.jpg', '.jpeg', '.webp'];

const categoryNameMap = {
  background: 'Background',
  logo: 'Logo',
  shapes: 'Shape',
};

const subCategoryTitleHints = {
  abstract: 'Abstract',
  nature: 'Nature',
  technology: 'Technology',
  business: 'Business',
  geometric: 'Geometric',
  animal: 'Animal',
  floral: 'Floral',
  food: 'Food',
  sport: 'Sports',
  music: 'Music',
  travel: 'Travel',
  education: 'Education',
  health: 'Health',
  fashion: 'Fashion',
  circle: 'Circle',
  square: 'Square',
  round: 'Round',
  triangle: 'Triangle',
  hexagon: 'Hexagon',
  star: 'Star',
  minimal: 'Minimal',
  vintage: 'Vintage',
  modern: 'Modern',
  luxury: 'Luxury',
  gradient: 'Gradient',
  pattern: 'Pattern',
  texture: 'Texture',
};

const categoryStyleHints = {
  background: ['Creative', 'Modern', 'Stylish', 'Elegant', 'Minimalist'],
  logo: ['Creative', 'Professional', 'Unique', 'Bold', 'Modern'],
  shapes: ['Geometric', 'Modern', 'Sleek', 'Elegant', 'Clean'],
};

function generateTitle(filename, category, subCategory) {
  const nameWithoutExt = path.basename(filename, path.extname(filename));
  const cleanName = nameWithoutExt
    .replace(/[-_]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();

  const catName = categoryNameMap[category] || category;
  const styles = categoryStyleHints[category] || ['Creative'];

  if (/^\d+$/.test(cleanName)) {
    const hint = subCategoryTitleHints[subCategory?.toLowerCase()];
    const style = styles[Math.floor(Math.random() * styles.length)];
    return hint
      ? `${hint} ${catName}`
      : `${style} ${catName}`;
  }

  const words = cleanName.split(' ');
  const capitalized = words
    .map((w) => w.charAt(0).toUpperCase() + w.slice(1).toLowerCase())
    .join(' ');

  const hint = subCategoryTitleHints[subCategory?.toLowerCase()];
  if (hint && (words.length === 1 || /^\d+$/.test(words[words.length - 1]))) {
    return `${hint} ${catName}`;
  }

  const lastWord = words[words.length - 1]?.toLowerCase();
  const knownSub = subCategoryTitleHints[lastWord];
  if (knownSub && words.length > 1) {
    return `${capitalized} ${catName}`;
  }

  if (words.length === 1 && knownSub) {
    return `${knownSub} ${catName}`;
  }

  return `${capitalized} ${catName}`;
}

function detectCategory(storagePath) {
  const parts = storagePath.split('/');
  for (const target of TARGET_FOLDERS) {
    if (parts.includes(target)) return target;
  }
  return null;
}

function getSubCategory(storagePath, category) {
  const parts = storagePath.split('/');
  const categoryIndex = parts.indexOf(category);
  if (categoryIndex !== -1 && parts.length > categoryIndex + 1) {
    return parts[categoryIndex + 1];
  }
  return null;
}

async function listAllFiles(prefix) {
  const allFiles = [];
  const options = { prefix };

  const [files] = await bucket.getFiles(options);

  for (const file of files) {
    const filePath = file.name;
    const ext = path.extname(filePath).toLowerCase();

    if (!ALLOWED_EXTENSIONS.includes(ext)) continue;

    const relativePath = filePath.replace(`${STORAGE_ROOT}/`, '');
    const topFolder = relativePath.split('/')[0];

    if (IGNORE_FOLDERS.includes(topFolder)) continue;
    if (!TARGET_FOLDERS.includes(topFolder)) continue;

    allFiles.push(file);
  }

  return allFiles;
}

async function fileExists(storagePath) {
  const snapshot = await db
    .collection('templates')
    .where('storagePath', '==', storagePath)
    .limit(1)
    .get();
  return !snapshot.empty;
}

async function generateSignedUrl(file) {
  const ONE_YEAR = 365 * 24 * 60 * 60 * 1000;
  const [url] = await file.getSignedUrl({
    action: 'read',
    expires: Date.now() + ONE_YEAR,
  });
  return url;
}

async function processFiles() {
  console.log(`Scanning storage root: ${STORAGE_ROOT}/`);
  console.log(`Target folders: ${TARGET_FOLDERS.join(', ')}`);
  console.log('');

  const files = await listAllFiles(`${STORAGE_ROOT}/`);
  console.log(`Found ${files.length} image files\n`);

  let createdCount = 0;
  let skippedCount = 0;
  let idCounter = 0;

  // Get the current max id from Firestore
  try {
    const maxIdSnapshot = await db
      .collection('templates')
      .orderBy('id', 'desc')
      .limit(1)
      .get();
    if (!maxIdSnapshot.empty) {
      idCounter = maxIdSnapshot.docs[0].data().id || 0;
    }
  } catch {
    // collection might not exist yet
  }

  const BATCH_SIZE = 500;
  let batch = db.batch();
  let batchOpCount = 0;

  for (const file of files) {
    const storagePath = file.name;
    const relativePath = storagePath.replace(`${STORAGE_ROOT}/`, '');
    const fileName = path.basename(storagePath);
    const category = detectCategory(storagePath);
    const subCategory = getSubCategory(storagePath, category);

    const currentFolder = path.dirname(storagePath);
    console.log(`\nFolder: ${currentFolder}`);
    console.log(`  Image: ${fileName}`);

    const exists = await fileExists(storagePath);

    if (exists) {
      console.log(`  -> SKIPPED (already exists)`);
      skippedCount++;
      continue;
    }

    idCounter++;
    const title = generateTitle(fileName, category, subCategory);
    const imageUrl = await generateSignedUrl(file);

    const docId = uuidv4();
    const docRef = db.collection('templates').doc(docId);

    batch.set(docRef, {
      id: idCounter,
      title,
      category,
      subCategory: subCategory || '',
      storagePath,
      imageUrl,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    batchOpCount++;

    console.log(`  -> CREATED (id: ${idCounter}, title: "${title}")`);
    createdCount++;

    if (batchOpCount >= BATCH_SIZE) {
      await batch.commit();
      console.log(`\nBatch committed (${batchOpCount} operations)\n`);
      batch = db.batch();
      batchOpCount = 0;
    }
  }

  if (batchOpCount > 0) {
    await batch.commit();
    console.log(`\nFinal batch committed (${batchOpCount} operations)`);
  }

  console.log('\n========================================');
  console.log(`Processing complete.`);
  console.log(`  Documents created: ${createdCount}`);
  console.log(`  Documents skipped: ${skippedCount}`);
  console.log(`  Total processed:   ${createdCount + skippedCount}`);
  console.log('========================================');
}

processFiles().catch((err) => {
  console.error('Error:', err);
  process.exit(1);
});
