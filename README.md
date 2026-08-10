# PitchKit

**Pitch as genotype and phenotype.** Zero dependencies.

A sounding pitch is a unique MIDI-like value (the *genotype*). How it is
*written* — G♯4 or A♭4 — is a *phenotype*, and one genotype maps to several
phenotypes. This kit owns both vocabularies and the policy that translates
between them.

```swift
.package(url: "https://github.com/Muilyzz/PitchKit.git", from: "1.0.0"),
```

## The translation

Genotype → phenotype is **not a function** — it needs a required context, the
key signature:

```swift
import PitchKit

let dMajor = KeySignature(fifths: 2)            // F♯ C♯

KeySpellingPolicy.spell(midi: 66, in: dMajor).name   // "F♯4"  (in signature)
KeySpellingPolicy.spell(midi: 65, in: dMajor).name   // "F4"   (♮ cancels — never E♯)
KeySpellingPolicy.spell(midi: 61, in: dMajor).name   // "C♯4"
KeySpellingPolicy.spell(midi: 60, in: dMajor).name   // "C4"   (♮ cancels)

KeySpellingPolicy.spell(midi: 68, in: KeySignature(fifths: -1)).name  // "A♭4" (flat family)
KeySpellingPolicy.spell(midi: 68, in: KeySignature(fifths: 1)).name   // "G♯4" (sharp family)
```

Rules, in priority order:

1. **In-signature** — diatonic notes take their signature letter.
2. **Natural cancel** — accidentals work *against* the signature's direction:
   lowering a sharped letter is ♮, never a new flat.
3. **Family** — other chromatics follow the key's accidental family.

Because accidentals only push against the signature, doubles can never
accumulate — `Accidental` excludes 𝄪/𝄫 **at the type level**.

## Key signature ≠ scale

`KeySignature` is just the circle-of-fifths index (`-7...7`). It knows which
letters are altered and which family the key prefers — and nothing about
scale membership, degrees, or functions. Tone-placement vocabularies stay
deliberately unlinked; a host maps its richer key type down to `fifths` with
a one-line adapter.

## Contents

| Type | Identity | World |
|------|----------|-------|
| `Pitch` | MIDI note `0...127` | genotype (sound) |
| `PitchClass` | `0...11` | genotype (class) |
| `SpelledPitch` | letter · accidental · octave | phenotype (notation) |
| `KeySignature` | circle-of-fifths index | translation context |
| `KeySpellingPolicy` | pure `spell(midi:in:)` | the translator |

`SpelledPitch.midi` projects back to the genotype (total, lossy). Round-trip
`spell(midi:in:).midi == midi` holds for every key signature — see the tests,
which double as the specification.

## Family

Pairs naturally with
[PhraseLatticeKit](https://github.com/Muilyzz/PhraseLatticeKit) (the time
axis): the lattice grid's `phraseFooter` slot gives pitch content a
time-aligned lane. See `Examples/SpellingContourExample`.
