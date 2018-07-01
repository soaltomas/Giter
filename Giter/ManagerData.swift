import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: String.Encoding.utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}


private let _singleManager = ManagerData()

class ManagerData {
    
    let managerNotification: ManagerNotification = ManagerNotification()

    class var singleManager: ManagerData {
        return _singleManager
    }

    var fileList: [FileData] = [] //---List for display directory content
    
    
    let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "serial_queue")
    
    func getFileContent(url: String, filename: String) {
        Alamofire.request(url, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let text = json["content"].stringValue
                let currentFile = NSHomeDirectory() + "/Documents/files/\(filename)"
                do {
                    try text.write(toFile: currentFile, atomically: true, encoding: String.Encoding.utf8)
                } catch let fileError as NSError {
                    print("Couldn't create file because of error: \(fileError)")
                }
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }
    }
    
    func writeToFile(content: String, filename: String) {
        let currentFile = NSHomeDirectory() + "/Documents/files/\(filename)"
        do {
            try content.write(toFile: currentFile, atomically: true, encoding: String.Encoding.utf8)
        } catch let fileError as NSError {
            print("Couldn't create file because of error: \(fileError)")
        }
    }
    
    func getNameOfPath(path: String) -> String {
        let stringArray = path.components(separatedBy: "/")
        return stringArray[stringArray.count - 1]
    }
    
    //---Return array of path elements (starting with the first directory)
    func getSeparatedPath(repoName: String, path: String) -> [String] {
        var stringArray = path.components(separatedBy: "/")
        var resultArray: [String] = []
        for str in stringArray {
            if str != repoName {
                stringArray[stringArray.index(of: str)!] = ""
            } else {
                stringArray[stringArray.index(of: str)!] = ""
                stringArray[stringArray.index(of: str)! + 1] = ""
                break
            }
        }
        for str in stringArray {
            if str != "" {
                resultArray.append(str)
            }
        }
        return resultArray
    }
    
 //-----------------------------------------------------------------------------------------------------------
    func loadJSON(repository: RepoData, user: String, pathToDir: String/*, branch: String = "master"*/) {
        let file = try! Realm().objects(FileData.self).filter("url BEGINSWITH %@", "\(pathToDir)?")
        let branch = repository.currentBranch
        let realm = try! Realm()
            let selfContentURL = "\(pathToDir)?ref=\(branch)"
            Alamofire.request(selfContentURL, method: .get).validate().responseJSON() { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var i: Int = 0
                    while i < json.array!.count {
                        let fileData = FileData()
                        fileData.name = json[i]["name"].stringValue
                        fileData.path = json[i]["path"].stringValue
                        fileData.sha = json[i]["sha"].stringValue
                        fileData.size = json[i]["size"].intValue
                        fileData.url = json[i]["url"].stringValue
                        fileData.html_url = json[i]["html_url"].stringValue
                        fileData.git_url = json[i]["git_url"].stringValue
                        fileData.download_url = json[i]["download_url"].stringValue
                        fileData.type = json[i]["type"].stringValue
                        fileData.content = json[i]["content"].stringValue
                        if pathToDir == "\(repository.url)/contents" {
                            repository.fileList.append(fileData)
                        } else {
                            try! realm.write {
                                for tempFile in file[0].fileList{
                                    if tempFile.url == fileData.url {
                                        let index = file[0].fileList.index(of: tempFile)
                                        file[0].fileList.remove(objectAtIndex: index!)
                                    }
                                }
                                file[0].fileList.append(fileData)
                            }
                        }
                        i += 1
                    }
                    loadRepo = true as AnyObject
                    try! realm.write {
                        if pathToDir == "\(repository.url)/contents" {
                            realm.add(repository, update: true)
                        } else {
                            realm.add(file)
                        }
                    }
                    
                  //  self.loadBranchList(repository: repository.name, user: user)
                    
                case .failure(let error):
                    print("Error thing: \(error)")
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCollection"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSearchTable"), object: nil)
            }
            
        }
    
    let requestFactory = RequestFactory()
    func loadRepositories() {
        let realm = try! Realm()
        requestFactory.getRepositories { response in
            print("\(response)")
            guard
                let repositories = response.value
            else {
                return
            }
            print("----------It's here: \(repositories)")
            loadRepo = true as AnyObject
            try! realm.write {
                realm.add(repositories, update: true)
            }
        }
    }
    //------------------------------------------------------------------------------------------------------------
    
    
    func searchRepoJSON(url: String = "https://api.github.com/users/soaltomas/repos") {
        var tempRepoList: [RepoData] = []
        
        Alamofire.request(url, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var i: Int = 0
                while i < json["items"].array!.count {
                    let repoData = RepoData()
                    repoData.id = json["items"][i]["id"].intValue
                    repoData.name = json["items"][i]["name"].stringValue
                    repoData.repoDescription = json["items"][i]["description"].stringValue
                    repoData.language = json["items"][i]["language"].stringValue
                    repoData.url = json["items"][i]["url"].stringValue
                    repoData.ownerLogin = json["items"][i]["owner"]["login"].stringValue
                    repoData.updatedDate = json[i]["updated_at"].stringValue
                    repoData.fork = json[i]["fork"].boolValue
                    repoData.isSelf = false
                    tempRepoList.append(repoData)
                    i += 1
                }
                for repo in tempRepoList {
                    self.loadJSON(repository: repo, user: "soaltomas", pathToDir: "\(repo.url)/contents")
                }
                
                
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }

    }
    
    func forkRepository(owner: String, repoName: String) {
        let url = "https://api.github.com/repos/\(owner)/\(repoName)/forks"
        
        Alamofire.request(url, method: .post).validate().responseJSON() { response in
            switch response.result {
            case .success( _):
                print("Repository \(owner) will be forked")
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }
        
    //    self.loadRepoJSON()

    }
    
    func loadBranchList(repository: String, user: String) {
        let realm = try! Realm()
        let url: String = "https://api.github.com/repos/\(user)/\(repository)/branches"
        Alamofire.request(url, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var i: Int = 0
                try! realm.write {
                let repo = self.loadDB(repository: repository)
                while i < json.array!.count {
                    let branchData = BranchData()
                    branchData.name = json[i]["name"].stringValue
                    branchData.sha = json[i]["commit"]["sha"].stringValue
                    branchData.url = json[i]["commit"]["url"].stringValue
                    for tempBranch in repo[0].branchList{
                        if tempBranch.name == branchData.name {
                            let index = repo[0].branchList.index(of: tempBranch)
                            repo[0].branchList.remove(objectAtIndex: index!)
                        }
                    }
                    repo[0].branchList.append(branchData)
                    i += 1
                }
                loadRepo = true as AnyObject
                    realm.add(repo, update: true)
                }
                
            case .failure(let error):
                print("Error thing: \(error)")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateBranches"), object: nil)
        }

        
    }
    
    
    func loadDB(repository: String) -> Results<RepoData> {
        return try! Realm().objects(RepoData.self).filter("name BEGINSWITH %@", repository)
    }
    
    func loadDirDB(pathToDir: String) -> Results<FileData> {
        return try! Realm().objects(FileData.self).filter("url BEGINSWITH %@", "\(pathToDir)?")
    }

    //---This function clears the filelist of the selected repository
    func clearFileListDB(repository: String) {
        let realm = try! Realm()
        try! realm.write {
            let repo = try! Realm().objects(RepoData.self).filter("name BEGINSWITH %@", repository)
            repo[0].fileList.removeAll()
            realm.add(repo, update: true)
            let files = try! Realm().objects(FileData.self).filter("url BEGINSWITH 'https://api.github.com/repos/soaltomas/\(repository)'")
            realm.delete(files)
        }
    }
    
    func clearDB() {
        let realm = try! Realm()
        try! realm.write {
            let repos = try! Realm().objects(RepoData.self)
            let files = try! Realm().objects(FileData.self)
            let branches = try! Realm().objects(BranchData.self)
            realm.delete(repos)
            realm.delete(files)
            realm.delete(branches)
        }
    }
    
    //---This function sets the value for the field currentBranch
    func setCurrentBranch(repo: String,  currentBranch: String) {
        let realm = try! Realm()
        try! realm.write {
            let repo = try! Realm().objects(RepoData.self).filter("name BEGINSWITH %@", repo)
            repo[0].currentBranch = currentBranch
            realm.add(repo, update: true)
        }
    }
    
    
}

var loadRepo: AnyObject? {
    get {
        return UserDefaults.standard.object(forKey: "flag") as AnyObject?
    }
    set {
        UserDefaults.standard.set(newValue, forKey: "flag")
        UserDefaults.standard.synchronize()
    }
}

var timer: DispatchSourceTimer?


var lastUpdate: Date? {
    get {
        return UserDefaults.standard.object(forKey: "Last Update") as? Date
    }
    set {
        UserDefaults.standard.setValue(Date(), forKey: "Last Update")
    }
}
