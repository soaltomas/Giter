//
//  ManagerData.swift
//  Giter
//
//  Created by Артем Полушин on 09.07.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

private let _singleManager = ManagerData()

class ManagerData {
<<<<<<< HEAD
    
    class var singleManager: ManagerData {
        return _singleManager
    }
    
    private var _repoData: [RepoData] = []
    
    var repoData: [RepoData] {
        var repoDataCopy: [RepoData]!
        concurrentQueue.sync {
            repoDataCopy = self._repoData
        }
        return repoDataCopy
    }
    
    func getRepoDataFromDB() {
        let realm = try! Realm()
        self._repoData = Array(realm.objects(RepoData.self))
    }
    
    let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
=======
    let accessData = AccessData()
   // let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
>>>>>>> a1edb97e24dc899096cda160ce6c04f9f3258ea2
    func getFileContent(url: String, filename: String) {
        Alamofire.request(url, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let text = json["content"].stringValue
                let currentFile = NSHomeDirectory() + "/Documents/\(filename)"
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
        let currentFile = NSHomeDirectory() + "/Documents/\(filename)"
        do {
            try content.write(toFile: currentFile, atomically: true, encoding: String.Encoding.utf8)
        } catch let fileError as NSError {
            print("Couldn't create file because of error: \(fileError)")
        }
    }
    
<<<<<<< HEAD
    func loadFilesJSON(repository: String = "GeekBrainsUniversity", path: String = "") -> [FileData] {
        var fileList: [FileData] = []
=======
    
    func loadFilesJSON(repository: String = "GeekBrainsUniversity", path: String = "") -> [String] {
        var fileList: [String] = []
>>>>>>> a1edb97e24dc899096cda160ce6c04f9f3258ea2
        let selfContentURL = "https://api.github.com/repos/soaltomas/\(repository)/contents/\(path)"
        Alamofire.request(selfContentURL, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                        var i: Int = 0
                        while i < json.array!.count {
                            fileList.append(json[i]["name"].stringValue)
                            i += 1
                        }
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }
        return fileList
    }
    func loadRepoJSON() {
        var tempRepoList: [RepoData] = []
        let repoListURL = "https://api.github.com/users/soaltomas/repos"
        Alamofire.request(repoListURL, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                    var i: Int = 0
                    while i < json.array!.count {
                        let repoData = RepoData()
                        repoData.id = json[i]["id"].intValue
                        repoData.name = json[i]["name"].stringValue
                        repoData.repoDescription = json[i]["description"].stringValue
                        repoData.language = json[i]["language"].stringValue
                        repoData.url = json[i]["url"].stringValue
                        self.loadRepo = true as AnyObject
                        self.accessData.addData(newData: repoData)
                        i += 1
                    }
<<<<<<< HEAD
                for repo in tempRepoList {
                    let selfContentURL = "https://api.github.com/repos/soaltomas/\(repo.name)/contents/"
                    Alamofire.request(selfContentURL, method: .get).validate().responseJSON(queue: self.concurrentQueue) { response in
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
                                repo.fileList.append(fileData)
                                i += 1
                            }
                            let realm = try! Realm()
                            self.loadRepo = true as AnyObject
                            try! realm.write {
                                realm.add(repo, update: true)
                            }

                        case .failure(let error):
                            print("Error thing: \(error)")
                        }
                    }
                    
                }
=======
//                for repo in tempRepoList {
//                    let selfContentURL = "https://api.github.com/repos/soaltomas/\(repo.name)/contents/"
//                    Alamofire.request(selfContentURL, method: .get).validate().responseJSON(queue: self.concurrentQueue) { response in
//                        switch response.result {
//                        case .success(let value):
//                            let json = JSON(value)
//                            var i: Int = 0
//                            while i < json.array!.count {
//                                repo.fileList.append(json[i]["name"].stringValue)
//                                i += 1
//                            }
//                            self.loadRepo = true as AnyObject
//                            self.accessData.addData(newData: repo)
//                        case .failure(let error):
//                            print("Error thing: \(error)")
//                        }
//                    }
//                    
//                }
>>>>>>> a1edb97e24dc899096cda160ce6c04f9f3258ea2

                
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }
        
    }
    
    func loadDB(repository: String) -> Results<RepoData> {
        return accessData.getData().filter("name BEGINSWITH %@", repository)
    }
    
    func loadRepoListDB() -> [RepoData] {
        var resultList: [RepoData] = []
<<<<<<< HEAD
        let data = try! Realm().objects(RepoData.self)
=======
        let data = accessData.getData()
>>>>>>> a1edb97e24dc899096cda160ce6c04f9f3258ea2
        for value in data {
            resultList.append(value)
        }
        return resultList
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
    
}
