# PitchKit

Leaf package for **absolute pitch** and **pitch class**. No key, scale, chord, score, or UI.

## Owns

| Type | Identity | Notes |
|------|----------|--------|
| ``Pitch`` | MIDI note `0...127` | Octave + pitch class are derived |
| ``PitchClass`` | `0...11` (C…B) | Sharp/flat display names; parse from string |

```swift
let p = Pitch(midiNote: 60)                 // C4
p.pitchClass                                // .c
p.octave                                    // 4
p.scientificName(preferFlat: false)         // "C4"

Pitch(pitchClass: .bFlat, octave: 3)        // MIDI 58
PitchClass.from(name: "F#")?.name(sharp: true)  // "F♯"
```

## Does not own

- Key / scale / degree / key-signature spelling → **HarmonicsKit** (and a future KeyScale layer if split)
- Chord formulas, voicing, palette ranking
- Notation staff heads (`MusicNotationKit`)
- Audio / MIDI I/O

## Layer

```text
PitchKit          ← this package (sound coordinates)
    ↑
HarmonicsKit      ← Key, Scale, Chord, Degree, key-aware spelling
    ↑
Palette / Voicing / Score / UI kits
```

`HarmonicsKit` `@_exported import PitchKit` so existing `import HarmonicsKit` still sees `Pitch` / `PitchClass`.

## Verify

```bash
swift test --package-path ~/Projects/PitchKit
```
