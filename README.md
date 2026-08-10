# PitchKit

**Pitch as genotype.** Zero dependencies.

A sounding pitch is a unique MIDI-like value. PitchKit is deliberately
**notation-neutral**: it has no opinion about ♭ vs ♯ — one genotype maps to
several written forms, and choosing between them requires a key-signature
context that lives in the notation world, not here.

```swift
.package(url: "https://github.com/Muilyzz/PitchKit.git", from: "2.0.0"),
```

```swift
import PitchKit

let p = Pitch(midiNote: 60)                 // C4
p.pitchClass                                // .c
p.octave                                    // 4
Pitch(pitchClass: PitchClass(10), octave: 3) // MIDI 58
```

## Contents

| Type | Identity | Notes |
|------|----------|-------|
| `Pitch` | MIDI note `0...127` | octave and pitch class are derived views |
| `PitchClass` | `0...11` | display names, string parsing |

## Family

The notation (phenotype) world — spelled pitches, key signatures, the
spelling policy, and a staff renderer — lives in
[StaffLatticeKit](https://github.com/Muilyzz/StaffLatticeKit), which pairs
with [PhraseLatticeKit](https://github.com/Muilyzz/PhraseLatticeKit)'s
time axis.
