import Foundation

/// A concrete pitch identified by MIDI note number (`0...127`).
///
/// **Identity is MIDI.** Octave and pitch class are derived views.
public struct Pitch: Equatable, Hashable, Codable, Sendable, Comparable {
    /// MIDI note number in `0...127`.
    public let midiNote: Int

    /// Creates a pitch from a MIDI note, clamping into `0...127`.
    public init(midiNote: Int) {
        self.midiNote = min(127, max(0, midiNote))
    }

    /// Creates a pitch from pitch class and scientific octave (C4 = MIDI 60).
    public init(pitchClass: PitchClass, octave: Int) {
        let midi = (octave + 1) * 12 + pitchClass.value
        self.init(midiNote: midi)
    }

    /// The pitch class of this note.
    public var pitchClass: PitchClass {
        PitchClass(midiNote)
    }

    /// Scientific pitch octave (MIDI 60 → octave 4).
    public var octave: Int {
        midiNote / 12 - 1
    }

    /// Scientific label, e.g. `"C4"`, `"B♭3"`.
    public func scientificName(preferFlat: Bool = false) -> String {
        pitchClass.name(preferFlat: preferFlat) + "\(octave)"
    }

    /// Transposes by semitones, clamping to the MIDI range.
    public func transposed(by semitones: Int) -> Pitch {
        Pitch(midiNote: midiNote + semitones)
    }

    public static func < (lhs: Pitch, rhs: Pitch) -> Bool {
        lhs.midiNote < rhs.midiNote
    }
}
