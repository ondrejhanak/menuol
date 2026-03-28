//
//  VenueTests.swift
//  tests
//

@testable import menuol
import Testing

struct VenueTests {
	@Test func equalityUsesSlugsOnly() {
		let a = Venue(slug: "same", name: "Original", address: "", note: "")
		let b = Venue(slug: "same", name: "Different Name", address: "Different Address", note: "Different Note")
		#expect(a == b)
	}
}
