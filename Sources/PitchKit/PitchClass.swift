import Foundation

/// A pitch class in twelve-tone equal temperament (C = 0 … B = 11).
///
/// Enharmonic spellings (`C♯` vs `D♭`) share one class; prefer flat/sharp only
/// for **display**. Key-aware spelling lives in HarmonicsKit.
public struct PitchClass: Equatable, Hashable, Codable, Sendable {
    /// Integer value in `0...11`.
    public let value: Int

    /// Creates a pitch class, wrapping into `0...11`.
    public init(_ value: Int) {
        let mod = value % 12
        self.value = mod >= 0 ? mod : mod + 12
    }

    public static let c = PitchClass(0)
    public static let cSharp = PitchClass(1)
    public static let dFlat = PitchClass(1)
    public static let d = PitchClass(2)
    public static let dSharp = PitchClass(3)
    public static let eFlat = PitchClass(3)
    public static let e = PitchClass(4)
    public static let f = PitchClass(5)
    public static let fSharp = PitchClass(6)
    public static let gFlat = PitchClass(6)
    public static let g = PitchClass(7)
    public static let gSharp = PitchClass(8)
    public static let aFlat = PitchClass(8)
    public static let a = PitchClass(9)
    public static let aSharp = PitchClass(10)
    public static let bFlat = PitchClass(10)
    public static let b = PitchClass(11)

    private static let sharpNames = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    private static let flatNames = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

    /// Display name using sharps or flats (Unicode `♯` / `♭`).
    public func name(sharp: Bool = true) -> String {
        sharp ? Self.sharpNames[value] : Self.flatNames[value]
    }

    /// Same as ``name(sharp:)`` with a prefer-flat flag (common host API).
    public func name(preferFlat: Bool) -> String {
        name(sharp: !preferFlat)
    }

    /// Parses `"C"`, `"F#"`, `"F♯"`, `"Bb"`, `"B♭"`, `"Db"`, doubles, etc.
    public static func from(name: String) -> PitchClass? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let upper = trimmed.uppercased()
        let letter: Character
        let accidental: String
        if upper.count == 1 {
            letter = upper[upper.startIndex]
            accidental = ""
        } else {
            letter = upper[upper.startIndex]
            accidental = String(trimmed.dropFirst())
        }

        let base: Int
        switch letter {
        case "C": base = 0
        case "D": base = 2
        case "E": base = 4
        case "F": base = 5
        case "G": base = 7
        case "A": base = 9
        case "B": base = 11
        default: return nil
        }

        switch accidental {
        case "", "♮":
            return PitchClass(base)
        case "#", "♯", "s", "S":
            return PitchClass(base + 1)
        case "b", "B", "♭":
            return PitchClass(base - 1)
        case "x", "X", "##", "♯♯", "𝄪":
            return PitchClass(base + 2)
        case "bb", "BB", "Bb", "bB", "♭♭", "𝄫":
            return PitchClass(base - 2)
        default:
            switch accidental.lowercased() {
            case "#", "s":
                return PitchClass(base + 1)
            case "b":
                return PitchClass(base - 1)
            case "x", "##":
                return PitchClass(base + 2)
            case "bb":
                return PitchClass(base - 2)
            default:
                return nil
            }
        }
    }

    /// Transposes by semitones (wraps mod 12).
    public func transposed(by semitones: Int) -> PitchClass {
        PitchClass(value + semitones)
    }
}
