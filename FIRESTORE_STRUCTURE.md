# Firestore & Firebase Storage Structure
## Project: `logo-creation-13cea`
## Storage Bucket: `logo-creation-13cea.firebasestorage.app`

---

## 📦 Document Field Reference

### Logo Collections (have full data)
Every document in logo collections has these fields:
```
number        : int      → sequence number (1, 2, 3...)
referenceId   : string   → e.g. "animal_001"
imageUrl      : string   → full Firebase Storage URL
fileName      : string   → e.g. "ani_1.png"
category      : string   → folder name e.g. "animal"
section       : string   → "logos"
sampleText    : string   → e.g. "Wild & Free"
tagline       : string   → e.g. "Connecting with nature"
storagePath   : string   → e.g. "musaf/logo/animal/ani_1.png"
createdAt     : string   → ISO date string
```

### Backgrounds / Fonts / Shapes Collections (simple — reference only)
Every document has only:
```
number        : int      → sequence number (1, 2, 3...)
referenceId   : string   → e.g. "abstract_001"
```
> To get the actual file, construct the Storage URL using the referenceId + known folder path.

---

## 🗂️ Storage URL Pattern

```
https://firebasestorage.googleapis.com/v0/b/logo-creation-13cea.firebasestorage.app/o/{encodedPath}?alt=media
```

Example:
```
https://firebasestorage.googleapis.com/v0/b/logo-creation-13cea.firebasestorage.app/o/musaf%2Flogo%2Fanimal%2Fani_1.png?alt=media
```

---

## 🖼️ BACKGROUNDS

### Storage Paths
```
musaf/background/abstract/   → bg21.png to bg60.png
musaf/background/blury/      → bg2.jpg to bg20.jpg
musaf/background/vintage/    → bg24.png to bg58.png
```

### Firestore Collections

#### `backgrounds_abstract`
- Total docs: **25**
- Doc ID: filename without extension (e.g. `bg21`)
- Fields: `number`, `referenceId`
- referenceId format: `abstract_001` → `abstract_025`

#### `backgrounds_blury`
- Total docs: **18**
- Doc ID: e.g. `bg2`
- Fields: `number`, `referenceId`
- referenceId format: `blury_001` → `blury_018`

#### `backgrounds_vintage`
- Total docs: **15**
- Doc ID: e.g. `bg24`
- Fields: `number`, `referenceId`
- referenceId format: `vintage_001` → `vintage_015`

---

## 🔤 FONTS

### Storage Paths
```
musaf/fonts/decorative/   → 12 font files (.ttf/.otf)
musaf/fonts/general/      → 175 font files
musaf/fonts/regular/      → 20 font files
musaf/fonts/simple/       → 42 font files
musaf/fonts/stylish/      → 26 font files
musaf/fonts/urdu/         → 11 font files
```

### Firestore Collections

#### `fonts_decorative`
- Total docs: **12**
- Doc ID: font filename without extension
- Fields: `number`, `referenceId`
- referenceId format: `decorative_001` → `decorative_012`

#### `fonts_general`
- Total docs: **175**
- referenceId format: `general_001` → `general_175`

#### `fonts_regular`
- Total docs: **20**
- referenceId format: `regular_001` → `regular_020`

#### `fonts_simple`
- Total docs: **42**
- referenceId format: `simple_001` → `simple_042`

#### `fonts_stylish`
- Total docs: **26**
- referenceId format: `stylish_001` → `stylish_026`

#### `fonts_urdu`
- Total docs: **11**
- referenceId format: `urdu_001` → `urdu_011`

---

## 🔷 SHAPES

### Storage Paths
```
musaf/shapes/basic/        → shape_1.png to shape_29.png
musaf/shapes/d_reverse/    → shape_138.png to shape_155.png
musaf/shapes/icons/        → shape_30.png to shape_63.png
musaf/shapes/label/        → shape_64.png to shape_99.png
musaf/shapes/lines/        → 00.png to 10.png
musaf/shapes/rectangular/  → shape_104.png to shape_158.png
musaf/shapes/ribben/       → shape_159.png to shape_200.png
musaf/shapes/round/        → shape_100.png to shape_118.png
```

### Firestore Collections

#### `shapes_basic`
- Total docs: **29**
- referenceId format: `basic_001` → `basic_029`

#### `shapes_d_reverse`
- Total docs: **18**
- referenceId format: `d_reverse_001` → `d_reverse_018`

#### `shapes_icons`
- Total docs: **34**
- referenceId format: `icons_001` → `icons_034`

#### `shapes_label`
- Total docs: **36**
- referenceId format: `label_001` → `label_036`

#### `shapes_lines`
- Total docs: **11**
- referenceId format: `lines_001` → `lines_011`

#### `shapes_rectangular`
- Total docs: **26**
- referenceId format: `rectangular_001` → `rectangular_026`

#### `shapes_ribben`
- Total docs: **42**
- referenceId format: `ribben_001` → `ribben_042`

#### `shapes_round`
- Total docs: **16**
- referenceId format: `round_001` → `round_016`

---

## 🎨 LOGOS

### Storage Base Path: `musaf/logo/{category}/`
### Firestore Collection Name: `logos_{category}`
### All logo documents have full fields: `number`, `referenceId`, `imageUrl`, `fileName`, `category`, `section`, `sampleText`, `tagline`, `storagePath`, `createdAt`

| Collection | Storage Path | Total Docs | referenceId Format |
|---|---|---|---|
| `logos_abstract` | `musaf/logo/abstract/` | 63 | `abstract_001` → `abstract_063` |
| `logos_animals` | `musaf/logo/animals/` | 45 | `animals_001` → `animals_045` |
| `logos_butterfly` | `musaf/logo/butterfly/` | 15 | `butterfly_001` → `butterfly_015` |
| `logos_camera` | `musaf/logo/camera/` | 21 | `camera_001` → `camera_021` |
| `logos_car` | `musaf/logo/car/` | 15 | `car_001` → `car_015` |
| `logos_circle` | `musaf/logo/circle/` | 27 | `circle_001` → `circle_027` |
| `logos_corporal` | `musaf/logo/corporal/` | 18 | `corporal_001` → `corporal_018` |
| `logos_dog` | `musaf/logo/dog/` | 11 | `dog_001` → `dog_011` |
| `logos_farmer` | `musaf/logo/farmer/` | 8 | `farmer_001` → `farmer_008` |
| `logos_festival` | `musaf/logo/festival/` | 31 | `festival_001` → `festival_031` |
| `logos_field` | `musaf/logo/field/` | 135 | `field_001` → `field_135` |
| `logos_flowers` | `musaf/logo/flowers/` | 15 | `flowers_001` → `flowers_015` |
| `logos_fly` | `musaf/logo/fly/` | 8 | `fly_001` → `fly_008` |
| `logos_functions` | `musaf/logo/functions/` | 90 | `functions_001` → `functions_090` |
| `logos_games` | `musaf/logo/games/` | 88 | `games_001` → `games_088` |
| `logos_hallowean` | `musaf/logo/hallowean/` | 20 | `hallowean_001` → `hallowean_020` |
| `logos_heart` | `musaf/logo/heart/` | 22 | `heart_001` → `heart_022` |
| `logos_holiday` | `musaf/logo/holiday/` | 25 | `holiday_001` → `holiday_025` |
| `logos_leaf` | `musaf/logo/leaf/` | 22 | `leaf_001` → `leaf_022` |
| `logos_music` | `musaf/logo/music/` | 12 | `music_001` → `music_012` |
| `logos_ngo` | `musaf/logo/ngo/` | 18 | `ngo_001` → `ngo_018` |
| `logos_party` | `musaf/logo/party/` | 25 | `party_001` → `party_025` |
| `logos_profession` | `musaf/logo/profession/` | 29 | `profession_001` → `profession_029` |
| `logos_restaurant` | `musaf/logo/restaurant/` | 28 | `restaurant_001` → `restaurant_028` |
| `logos_simple` | `musaf/logo/simple/` | 107 | `simple_001` → `simple_107` |
| `logos_social` | `musaf/logo/social/` | 13 | `social_001` → `social_013` |
| `logos_spots` | `musaf/logo/spots/` | 349 | `spots_001` → `spots_349` |
| `logos_square` | `musaf/logo/square/` | 12 | `square_001` → `square_012` |
| `logos_star` | `musaf/logo/star/` | 11 | `star_001` → `star_011` |
| `logos_text` | `musaf/logo/text/` | 24 | `text_001` → `text_024` |
| `logos_tools` | `musaf/logo/tools/` | 41 | `tools_001` → `tools_041` |
| `logos_toy` | `musaf/logo/toy/` | 25 | `toy_001` → `toy_025` |
| `logos_video` | `musaf/logo/video/` | 16 | `video_001` → `video_016` |

---

## 💡 Flutter Integration Example

### Fetch logo collection
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('logos_animals')
    .orderBy('number')
    .get();

final logos = snapshot.docs.map((doc) {
  return {
    'imageUrl'   : doc['imageUrl'],
    'sampleText' : doc['sampleText'],
    'tagline'    : doc['tagline'],
    'referenceId': doc['referenceId'],
  };
}).toList();
```

### Fetch background collection (construct URL manually)
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('backgrounds_abstract')
    .orderBy('number')
    .get();

// Construct Storage URL from referenceId
String getBackgroundUrl(String referenceId, int number) {
  final fileName = 'bg${number}.png'; // match actual filenames
  final path = 'musaf/background/abstract/$fileName';
  final encoded = Uri.encodeComponent(path);
  return 'https://firebasestorage.googleapis.com/v0/b/logo-creation-13cea.firebasestorage.app/o/$encoded?alt=media';
}
```

### Fetch font collection
```dart
final snapshot = await FirebaseFirestore.instance
    .collection('fonts_general')
    .orderBy('number')
    .get();

// Font Storage path pattern:
// musaf/fonts/{category}/{fontFileName}
// e.g. musaf/fonts/general/Oswald-Bold.ttf
```

---

## 📊 Total Summary

| Section | Collections | Total Documents |
|---|---|---|
| Logos | 33 | ~1,044 |
| Backgrounds | 3 | 58 |
| Fonts | 6 | 286 |
| Shapes | 8 | 212 |
| **TOTAL** | **50** | **~1,600** |
