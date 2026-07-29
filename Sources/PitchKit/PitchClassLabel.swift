import SwiftUI

/// Compact pitch-class name label (`C`, `F♯`, `B♭`).
public struct PitchClassLabel: View {
    public var pitchClass: PitchClass
    public var preferFlat: Bool
    public var font: Font
    public var weight: Font.Weight
    public var foreground: Color

    public init(
        _ pitchClass: PitchClass,
        preferFlat: Bool = false,
        font: Font = .system(size: 11, design: .rounded),
        weight: Font.Weight = .medium,
        foreground: Color = .primary
    ) {
        self.pitchClass = pitchClass
        self.preferFlat = preferFlat
        self.font = font
        self.weight = weight
        self.foreground = foreground
    }

    public init(
        pitchClassValue: Int,
        preferFlat: Bool = false,
        font: Font = .system(size: 11, design: .rounded),
        weight: Font.Weight = .medium,
        foreground: Color = .primary
    ) {
        self.init(
            PitchClass(pitchClassValue),
            preferFlat: preferFlat,
            font: font,
            weight: weight,
            foreground: foreground
        )
    }

    public var body: some View {
        Text(pitchClass.name(preferFlat: preferFlat))
            .font(font)
            .fontWeight(weight)
            .foregroundStyle(foreground)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .accessibilityLabel(pitchClass.name(preferFlat: preferFlat))
    }
}

/// Absolute pitch with octave (`C4`, `B♭3`).
public struct PitchLabel: View {
    public var pitch: Pitch
    public var preferFlat: Bool
    public var font: Font
    public var weight: Font.Weight
    public var foreground: Color

    public init(
        _ pitch: Pitch,
        preferFlat: Bool = false,
        font: Font = .system(size: 11, design: .rounded),
        weight: Font.Weight = .medium,
        foreground: Color = .primary
    ) {
        self.pitch = pitch
        self.preferFlat = preferFlat
        self.font = font
        self.weight = weight
        self.foreground = foreground
    }

    public var body: some View {
        Text(pitch.scientificName(preferFlat: preferFlat))
            .font(font)
            .fontWeight(weight)
            .foregroundStyle(foreground)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
            .accessibilityLabel(pitch.scientificName(preferFlat: preferFlat))
    }
}
