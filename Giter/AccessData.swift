import Foundation
import RealmSwift

class AccessData {
    static let data = AccessData()
    private let realm = try! Realm()
    
    func getData() -> Results<RepoData> {
        return try! Realm().objects(RepoData.self)
    }
    
    func addData(newData: RepoData) {
        try! realm.write {
            realm.add(newData, update: true)
        }

    }
}
