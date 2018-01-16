# master

## Enhancements

- Update project to Swift 4.0 and Xcode 9.2

## Bug Fixes

- None.

# 1.1.2

## Enhancements

- None.

## Bug Fixes

- Fix layout freezing issues
  [issue](https://github.com/br1sk/brisk/issues/33)
  [change](https://github.com/br1sk/brisk/pull/120)

# 1.1.1

## Enhancements

- None.

## Bug Fixes

- Fix ambiguous layout when text fields are large
  [issue](https://github.com/br1sk/brisk/issues/113)
  [change](https://github.com/br1sk/brisk/pull/117)

- Fix ambiguous version field layout
  [change](https://github.com/br1sk/brisk/pull/118)

# 1.1.0

## Enhancements

- Add checkbox to control crossposting to open radar
  [issue](https://github.com/br1sk/brisk/issues/4)
  [change](https://github.com/br1sk/brisk/pull/107)

- Add drag and drop attachment support 
  [issue](https://github.com/br1sk/brisk/issues/35)
  [change](https://github.com/br1sk/brisk/pull/109)

- Default cross posting to false for duplicates
  [issue](https://github.com/br1sk/brisk/issues/106)
  [change](https://github.com/br1sk/brisk/issues/110)

## Bug Fixes

- Don't register dup'd radars as dirty files
  [change](https://github.com/br1sk/brisk/pull/103)

- Update the title when restoring a radar
  [change](https://github.com/br1sk/brisk/pull/104)

- Remove unnecessary change count +1
  [change](https://github.com/br1sk/brisk/pull/108)

# 1.0.1

## Enhancements

- Update invalid rdar:// URL error message
  [change](https://github.com/br1sk/brisk/pull/95)

## Bug Fixes

- None.

# 1.0.0

## Enhancements

- Make tab in text views jump between fields
  [issue](https://github.com/br1sk/brisk/issues/52)
  [change](https://github.com/br1sk/brisk/pull/78)

- Add UI for duping radars from OpenRadar
  [issue](https://github.com/br1sk/brisk/issues/14)
  [change](https://github.com/br1sk/brisk/pull/75)

- Respond to rdar:// URLs
  [issue](https://github.com/br1sk/brisk/issues/77)
  [change](https://github.com/br1sk/brisk/pull/79)

- Set filetype icon to app icon
  [issue](https://github.com/br1sk/brisk/issues/47)
  [change](https://github.com/br1sk/brisk/pull/83)

- Use User icon for Open Radar preferences
  [issue](https://github.com/br1sk/brisk/issues/15)
  [change](https://github.com/br1sk/brisk/pull/84)

- Make Configuration and Notes optional
  [issue](https://github.com/br1sk/brisk/issues/46)
  [change](https://github.com/br1sk/brisk/pull/86)

- Mark duplicate radars as dirty documents
  [change](https://github.com/br1sk/brisk/pull/88)

- Add ability to remove attachment
  [issue](https://github.com/br1sk/brisk/issues/16)
  [change](https://github.com/br1sk/brisk/pull/89)

- Combine `PlaceholderTextView` and `TextView`
  [change](https://github.com/br1sk/brisk/pull/90)

- Make text view font size the normal system size
  [change](https://github.com/br1sk/brisk/pull/92)

- Add hint text for text views
  [issue](https://github.com/br1sk/brisk/issues/54)
  [change](https://github.com/br1sk/brisk/issues/93)

## Bug Fixes

- Typing emoji caused font to change
  [issue](https://github.com/br1sk/brisk/issues/55)
  [change](https://github.com/br1sk/brisk/pull/67)

- Middle truncate long attachment names
  [change](https://github.com/br1sk/brisk/pull/69)

- Remove ruler support from text views
  [issue](https://github.com/br1sk/brisk/issues/27)
  [change](https://github.com/br1sk/brisk/pull/70)

- Remove unnecessary fields from `Info.plist`
  [change](https://github.com/br1sk/brisk/pull/72)

- Remove App Transport Security exceptions
  [change](https://github.com/br1sk/brisk/pull/73)

- Use Radar icon in Preferences
  [change](https://github.com/br1sk/brisk/pull/74)

- Focus existing windows when reopening documents
  [issue](https://github.com/br1sk/brisk/issues/48)
  [change](https://github.com/br1sk/brisk/issues/80)

- Only update window title on title text change
  [change](https://github.com/br1sk/brisk/pull/87)
