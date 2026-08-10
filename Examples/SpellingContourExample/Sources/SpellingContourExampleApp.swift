import PhraseLattice
import PhraseLatticeUI
import PitchKit
import SwiftUI

/// The pitch axis meets the time axis: a melody stored as **genotypes**
/// (MIDI + tick) renders as **phenotypes** (spelled pitches) in the grid's
/// `phraseFooter` lane — one Canvas per phrase, aligned 1:1 with the beats
/// above because the lane shares the system's endpoints.
struct MelodyNote {
    let tick: ScoreTick
    let midi: Int
}

struct MelodySheet: ScoreStructureSource {
    let id = UUID()
    var title = "Spelling contour"
    /// 4 bars of 4/4 (bar = 96 ticks) — one phrase.
    var durationTicks = 8 * 96
    var meterMap = MeterMap(events: [
        MeterEvent(tick: 0, signature: MeterSignature(numerator: 4, denominator: 4)),
    ])
    var pickupTicks: Int { 0 }
    var phraseBoundaries: [PhraseBoundary] { [] }

    /// D major — F♯ and C♯ in the signature.
    let signature = KeySignature(fifths: 2)

    /// Genotypes only. Beats 6–7 walk F♯→F♮ and bar 3 walks C♯→C♮:
    /// the ♮-cancel rule becomes visible in the rendered labels.
    let melody: [MelodyNote] = [
        .init(tick: 0, midi: 62), .init(tick: 24, midi: 66),
        .init(tick: 48, midi: 69), .init(tick: 72, midi: 74),
        .init(tick: 96, midi: 67), .init(tick: 120, midi: 66),
        .init(tick: 144, midi: 65), .init(tick: 168, midi: 64),
        .init(tick: 192, midi: 73), .init(tick: 216, midi: 72),
        .init(tick: 240, midi: 71), .init(tick: 264, midi: 69),
        .init(tick: 288, midi: 68), .init(tick: 312, midi: 67),
        .init(tick: 336, midi: 64), .init(tick: 360, midi: 62),
        .init(tick: 384, midi: 62), .init(tick: 408, midi: 66),
        .init(tick: 432, midi: 69), .init(tick: 456, midi: 74),
        .init(tick: 480, midi: 72), .init(tick: 504, midi: 71),
        .init(tick: 528, midi: 69), .init(tick: 552, midi: 67),
        .init(tick: 576, midi: 66), .init(tick: 600, midi: 65),
        .init(tick: 624, midi: 66), .init(tick: 648, midi: 69),
        .init(tick: 672, midi: 67), .init(tick: 696, midi: 66),
        .init(tick: 720, midi: 64), .init(tick: 744, midi: 62),
    ]

    func bar(containing tick: ScoreTick) throws -> DerivedBar? {
        try meterMap.bar(containing: tick, pickupTicks: pickupTicks)
    }
}

@main
struct SpellingContourExampleApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

struct ContentView: View {
    private let sheet = MelodySheet()
    @State private var selection: ScoreStructureSpan?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("D major (♯2) — watch F♯→F and C♯→C cancel with ♮, never a flat")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    LatticeGridView(source: sheet, selection: $selection) { beat in
                        Text(beat.ordinal.map(String.init) ?? "·")
                    } phraseFooter: { phrase in
                        ContourLane(
                            phrase: phrase,
                            melody: sheet.melody,
                            signature: sheet.signature
                        )
                        .frame(height: 96)
                    }
                }
                .padding()
            }
            .navigationTitle("PitchKit")
        }
    }
}

/// Contour LOD: one Canvas per phrase — dots on a time-linear x axis,
/// pitch height on y, each labeled with its **phenotype** from
/// `KeySpellingPolicy`. No per-note views, no staff yet: this is the folded
/// (cheap) representation; a full staff is just a richer renderer for the
/// same lane.
struct ContourLane: View {
    let phrase: ScoreStructureSpan
    let melody: [MelodyNote]
    let signature: KeySignature

    var body: some View {
        Canvas { context, size in
            let notes = melody.filter { phrase.range.contains($0.tick) }
            guard
                let low = notes.map(\.midi).min(),
                let high = notes.map(\.midi).max()
            else { return }
            let span = max(high - low, 1)
            let duration = CGFloat(phrase.range.durationTicks)

            for note in notes {
                let x = CGFloat(note.tick - phrase.range.startTick) / duration * size.width
                let y = 12 + (size.height - 36) * CGFloat(high - note.midi) / CGFloat(span)
                let spelled = KeySpellingPolicy.spell(midi: note.midi, in: signature)

                let dot = CGRect(x: x + 1, y: y - 2.5, width: 5, height: 5)
                let hasAccidental = spelled.accidental != signature.accidental(for: spelled.letter)
                context.fill(
                    Circle().path(in: dot),
                    with: .color(hasAccidental ? .orange : .accentColor)
                )
                context.draw(
                    Text(spelled.name).font(.system(size: 7)).foregroundStyle(.secondary),
                    at: CGPoint(x: x + 3.5, y: y + 11)
                )
            }
        }
    }
}
