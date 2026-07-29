import XCTest
@testable import PitchKit

final class PitchKitTests: XCTestCase {
    func testPitchMidiAndOctave() {
        let pitch = Pitch(pitchClass: .c, octave: 4)
        XCTAssertEqual(pitch.midiNote, 60)
        XCTAssertEqual(pitch.octave, 4)
        XCTAssertEqual(pitch.pitchClass, .c)
        XCTAssertEqual(pitch.scientificName(preferFlat: false), "C4")
    }

    func testScientificNamePreferFlat() {
        let bFlat3 = Pitch(midiNote: 58)
        XCTAssertEqual(bFlat3.scientificName(preferFlat: true), "B♭3")
        XCTAssertEqual(bFlat3.scientificName(preferFlat: false), "A♯3")
    }

    func testPitchClassFromName() {
        XCTAssertEqual(PitchClass.from(name: "C")?.value, 0)
        XCTAssertEqual(PitchClass.from(name: "F#")?.value, 6)
        XCTAssertEqual(PitchClass.from(name: "Bb")?.value, 10)
        XCTAssertEqual(PitchClass.from(name: "Db")?.value, 1)
        XCTAssertEqual(PitchClass.from(name: "F♯")?.value, 6)
        XCTAssertEqual(PitchClass.from(name: "B♭")?.value, 10)
        XCTAssertEqual(PitchClass.cSharp.name(sharp: true), "C♯")
        XCTAssertEqual(PitchClass.dFlat.name(preferFlat: true), "D♭")
        XCTAssertNil(PitchClass.from(name: "H"))
    }

    func testTransposeClampsMidi() {
        XCTAssertEqual(Pitch(midiNote: 125).transposed(by: 10).midiNote, 127)
        XCTAssertEqual(Pitch(midiNote: 2).transposed(by: -10).midiNote, 0)
    }
}
