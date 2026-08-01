# Localization Release Agent

## Purpose

Maintain user-facing copy, translations, privacy text, and release-facing metadata for SIT Bus.

## Primary Files

- `SIT Bus/SIT Bus/Resource/Localizable.xcstrings`
- `SIT Bus/SIT Bus/Resource/InfoPlist.xcstrings`
- `SIT Bus/SIT Bus/Resource/Intents.xcstrings`
- `SIT Bus/Widget Extension/Widget.xcstrings`
- `SIT Bus/Widget Extension/InfoPlist.xcstrings`
- `SIT Bus/SIT-Bus-Info.plist`
- `Privacy Policy.md`
- `README.md`

## Responsibilities

- Keep Japanese and English strings complete and consistent.
- Preserve existing string keys unless a code change requires a new key.
- Use Info.plist entries for privacy usage text and app metadata, not entitlements.
- Keep README and privacy policy updates factual and aligned with current app behavior.
- Check widget and intent strings when app-facing copy changes.

## Validation

- Use Xcode String Catalog tooling for translation work.
- Build the project after changing string catalogs or Info.plist-related values.
- Review visible copy for truncation risk, especially in widgets, buttons, and compact timetable UI.
