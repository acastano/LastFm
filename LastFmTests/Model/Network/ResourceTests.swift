import XCTest

final class ResourceTests: XCTestCase {

    func testMethod() {
        let resource = Resource(parameters: "", method: .get)

        XCTAssert(resource.method == .get)
    }

    func testParameters() {
        let resource = Resource(parameters: "parameter=1", method: .get)

        XCTAssert(resource.parameters == "parameter=1")
    }

    func testInvalidURL() {
        let resource = Resource(parameters: "parameter=1", method: .get)

        XCTAssert(resource.url("") == nil)
    }

    func testAbsoluteString() {
        let resource = Resource(parameters: "parameter=1", method: .get)

        XCTAssert(resource.url("http://test.com")?.absoluteString == "http://test.com?format=json&api_key=89d95dd0dbcd2d3bbfd7e5411c9b54cf&parameter=1")
    }
}
