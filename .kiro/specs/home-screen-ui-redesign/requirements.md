# Requirements Document

## Introduction

This feature redesigns the Luminous app's home screen to follow a modern, content-first layout inspired by popular logo maker apps. The redesign introduces a categorized template browsing experience with horizontally scrollable sections (e.g., "Most Popular", "Esport", "AI", "Fashion"), a quick-access category icon row, and a redesigned bottom navigation bar with labeled tabs. The Luminous brand identity (purple color scheme, dark background) is preserved throughout. All template cards will display a single placeholder image initially, to be replaced with real assets later.

---

## Glossary

- **Home_Screen**: The main landing screen of the Luminous app, shown after login/onboarding.
- **Top_Bar**: The header area at the top of the Home_Screen containing the app logo/title, search icon, and profile avatar.
- **Category_Icon_Row**: A horizontally scrollable row of shortcut icons below the Top_Bar (e.g., BG Remover, Business Card, YouTube, Instagram).
- **Template_Section**: A named group of logo template cards with a section title, optional badge, and a "See All" link.
- **Template_Card**: A square card with rounded corners displaying a logo template image (placeholder for now).
- **Section_Badge**: A small label (e.g., "NEW") displayed next to a Template_Section title.
- **Bottom_Nav_Bar**: The bottom navigation bar with labeled icon tabs.
- **Nav_Tab**: A single item in the Bottom_Nav_Bar consisting of an icon and a text label beneath it.
- **FAB**: The floating action button (center "+" button) used to create a new logo.
- **Placeholder_Image**: A single dummy image asset used in all Template_Cards until real images are available.
- **See_All_Link**: A tappable text link next to a Template_Section title that navigates to the full template list.

---

## Requirements

---

### Requirement 1: Top Bar Redesign

**User Story:** As a user, I want a clean top bar with the app title, a search icon, and my profile avatar, so that I can quickly identify the app and access key actions.

#### Acceptance Criteria

1. THE Home_Screen SHALL display a Top_Bar at the top of the screen.
2. THE Top_Bar SHALL display the text "LUMINOUS" as the app title in the center or left-aligned position.
3. THE Top_Bar SHALL display a hamburger menu icon on the left side.
4. THE Top_Bar SHALL display a search icon on the right side.
5. THE Top_Bar SHALL display a circular profile avatar on the right side, next to the search icon.
6. WHEN the user is a guest (not logged in), THE Top_Bar SHALL display a "LOGIN" button in place of the profile avatar.
7. WHEN the user taps the search icon, THE Home_Screen SHALL navigate to the search/templates screen.
8. WHEN the user taps the profile avatar, THE Home_Screen SHALL navigate to the profile screen.

---

### Requirement 2: Category Icon Row

**User Story:** As a user, I want a horizontally scrollable row of category shortcut icons below the top bar, so that I can quickly jump to specific template categories.

#### Acceptance Criteria

1. THE Home_Screen SHALL display a Category_Icon_Row below the Top_Bar.
2. THE Category_Icon_Row SHALL be horizontally scrollable.
3. THE Category_Icon_Row SHALL contain at least the following category items: "BG Remover", "Instagram", "Business Card", "YouTube", "Esport", "Fashion", "AI", "Minimalist".
4. EACH item in the Category_Icon_Row SHALL display a circular icon and a text label beneath it.
5. WHEN the user taps a category item in the Category_Icon_Row, THE Home_Screen SHALL scroll to or highlight the corresponding Template_Section.

---

### Requirement 3: Template Sections with Horizontal Scrollable Cards

**User Story:** As a user, I want to browse logo templates organized into named sections with horizontal scrolling, so that I can discover templates by category without leaving the home screen.

#### Acceptance Criteria

1. THE Home_Screen SHALL display at least the following Template_Sections: "Most Popular", "Esport", "AI", "Fashion".
2. EACH Template_Section SHALL display a section title on the left and a See_All_Link on the right.
3. EACH Template_Section SHALL display a horizontally scrollable row of Template_Cards.
4. EACH Template_Section SHALL display at least 4 Template_Cards visible in the initial viewport (partially showing the 5th to indicate scrollability).
5. EACH Template_Card SHALL display a square image with rounded corners using the Placeholder_Image.
6. EACH Template_Card SHALL have a fixed width and height maintaining a square aspect ratio.
7. WHERE a Template_Section is designated as new content, THE Home_Screen SHALL display a Section_Badge labeled "NEW" next to the section title.
8. WHEN the user taps a Template_Card, THE Home_Screen SHALL navigate to the editor screen with the selected template loaded.
9. WHEN the user taps a See_All_Link, THE Home_Screen SHALL navigate to the full templates list screen filtered by that section's category.

---

### Requirement 4: Placeholder Image in Template Cards

**User Story:** As a developer, I want all template cards to show a single placeholder image for now, so that the UI layout is complete and ready for real images to be swapped in later.

#### Acceptance Criteria

1. THE Home_Screen SHALL use a single Placeholder_Image asset for all Template_Cards across all Template_Sections.
2. THE Placeholder_Image SHALL be displayed using `BoxFit.cover` to fill the Template_Card bounds without distortion.
3. WHEN the Placeholder_Image asset is unavailable, THE Template_Card SHALL display a solid purple fallback color (`0xFF7B2FBE`) in place of the image.
4. THE Template_Card image area SHALL have rounded corners with a consistent border radius applied uniformly across all cards.

---

### Requirement 5: Bottom Navigation Bar Redesign

**User Story:** As a user, I want a bottom navigation bar with labeled icons, so that I can clearly understand what each tab does and navigate between sections easily.

#### Acceptance Criteria

1. THE Home_Screen SHALL display a Bottom_Nav_Bar at the bottom of the screen.
2. THE Bottom_Nav_Bar SHALL contain exactly 4 Nav_Tabs with the following labels and icons:
   - Tab 0: "Home" — home icon
   - Tab 1: "Logos" — grid/layers icon
   - Tab 2: "Stickers" — sticker/emoji icon
   - Tab 3: "My Work" — person/portfolio icon
3. EACH Nav_Tab SHALL display an icon above a text label.
4. THE Bottom_Nav_Bar SHALL display a FAB in the center position (between Tab 1 and Tab 2) as a "+" create button.
5. WHEN the user taps a Nav_Tab, THE Home_Screen SHALL switch to the corresponding screen.
6. THE active Nav_Tab SHALL be visually distinguished from inactive tabs using the Luminous purple color (`0xFF7B2FBE`) for the icon and label.
7. THE Bottom_Nav_Bar background SHALL use the dark surface color (`0xFF1A1D25`) consistent with the app's dark theme.
8. IF the CurvedNavigationBar widget does not support text labels natively, THEN THE Home_Screen SHALL replace it with a standard Flutter BottomNavigationBar or a custom implementation that supports both icons and text labels.

---

### Requirement 6: Floating Action Button (FAB)

**User Story:** As a user, I want a prominent "+" button in the center of the bottom bar, so that I can quickly start creating a new logo from anywhere on the home screen.

#### Acceptance Criteria

1. THE Home_Screen SHALL display a FAB centered above the Bottom_Nav_Bar.
2. THE FAB SHALL display a "+" icon in white on a purple background (`0xFF7B2FBE`).
3. WHEN the user taps the FAB and is logged in, THE Home_Screen SHALL navigate to the AI generator screen.
4. WHEN the user taps the FAB and is a guest, THE Home_Screen SHALL navigate to the login screen.
5. THE FAB SHALL be visible on all Nav_Tab screens, not only the Home tab.

---

### Requirement 7: Overall Visual Theme and Branding

**User Story:** As a user, I want the redesigned home screen to feel consistent with the Luminous brand, so that the new layout doesn't feel like a different app.

#### Acceptance Criteria

1. THE Home_Screen SHALL use a dark background color (`0xFF0B0D13`) as the primary scaffold background.
2. THE Home_Screen SHALL use the Luminous purple (`0xFF7B2FBE`) as the primary accent color for interactive elements, active states, and highlights.
3. THE Home_Screen SHALL use the Outfit font family consistently for all text elements.
4. THE Home_Screen SHALL maintain the existing dark purple gradient card style for any hero or promotional banner elements retained from the current design.
5. WHILE the app is running on any screen size, THE Home_Screen SHALL use `flutter_screenutil` responsive sizing (`sp`, `w`, `h`, `r`) for all dimensions and font sizes.

---

### Requirement 8: Scroll Behavior and Layout

**User Story:** As a user, I want the home screen to scroll smoothly and feel responsive, so that browsing templates is a pleasant experience.

#### Acceptance Criteria

1. THE Home_Screen SHALL use a single vertically scrollable container (e.g., `CustomScrollView` or `SingleChildScrollView`) that contains the Top_Bar, Category_Icon_Row, and all Template_Sections.
2. THE Home_Screen SHALL use `BouncingScrollPhysics` for the main vertical scroll.
3. EACH Template_Section's horizontal card row SHALL use independent horizontal scroll with `BouncingScrollPhysics`.
4. THE Home_Screen SHALL add sufficient bottom padding to prevent content from being obscured by the Bottom_Nav_Bar or FAB.
5. IF the user scrolls to the bottom of the Home_Screen, THEN THE Home_Screen SHALL display all Template_Sections without content being cut off.
