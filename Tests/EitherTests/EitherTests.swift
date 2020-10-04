import XCTest

@testable import Either

class EitherTests: XCTestCase {
    let json = """
    {
        "id": "1",
        "idNumber": 1,
        "idString": "1"
    }
    """
    struct Object: Codable {
        var id: Either<Int, String>
        var idNumber: Either<Int, String>
        var idString: Either<Int, String>
    }
    private var object: Object!
    
    override func setUp() {
        super.setUp()
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        object = try! decoder.decode(Object.self, from: data)
    }
    
    func test_Equal() {
        XCTAssertEqual(object.id.right, "1")
        XCTAssertEqual(object.idNumber.left!, 1)
        XCTAssertEqual(object.idString.right, "1")
    }
    
    func test_Cast() {
        let newValue1 = object.id.rightFlatMap { (e) in
            return .right(Int(e) ?? 0)
        }
        XCTAssertEqual(newValue1.right, 1)
        
        let newValue2: String = object.idNumber.fold({ $0.description }, { $0})
        XCTAssertEqual(newValue2, "1")
        
        let newValue3: Int = object.idString.fold({ $0 }, { (Int($0) ?? 0)})
        XCTAssertEqual(newValue3, 1)
    }
}
