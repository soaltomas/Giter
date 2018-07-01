import Foundation
import RealmSwift

class Repository: Object, Codable {
    
    dynamic var id: Int = 0
    dynamic var name: String?
    dynamic var descr: String?
    dynamic var language: String?
    dynamic var created: String?
    dynamic var updated: String?
    dynamic var isFork: Bool = false
    var fileList = List<FileData>()
    var branchList = List<BranchData>()
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descr = "description"
        case language
        case created = "created_at"
        case updated = "updated_at"
        case isFork = "fork"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
