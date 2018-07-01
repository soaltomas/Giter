import Foundation
import RealmSwift

class RepositoryRepository {
    
    private static let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
    
    private static var _repositories: [Repository] = []
    
    static var repositories: [Repository] {
        var repositoriesCopy: [Repository]!
        concurrentQueue.sync {
            repositoriesCopy = self._repositories
        }
        return repositoriesCopy
    }
    
    static func getRepositories() {
        let realm = try! Realm()
        self._repositories = Array(realm.objects(Repository.self))
    }
    
}
