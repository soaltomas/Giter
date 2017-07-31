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

class ManagerData {
    let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
    func getFileContent(url: String, filename: String) {
        Alamofire.request(url, method: .get).validate().responseJSON(queue: concurrentQueue) { response in
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
    
    
    func loadFilesJSON(repository: String = "GeekBrainsUniversity", path: String = "") -> [FileData] {
        var fileList = [FileData]()
        let selfContentURL = "https://api.github.com/repos/soaltomas/\(repository)/contents/\(path)"
        Alamofire.request(selfContentURL, method: .get).validate().responseJSON(queue: concurrentQueue) { response in
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
                            fileList.append(fileData)
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
        Alamofire.request(repoListURL, method: .get).validate().responseJSON(queue: concurrentQueue) { response in
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
                        tempRepoList.append(repoData)
                        i += 1
                    }
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

                
                
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }
        
    }
    
    func loadDB(repository: String) -> Results<RepoData> {
        return try! Realm().objects(RepoData.self).filter("name BEGINSWITH %@", repository)
    }
    
    func loadRepoListDB() -> [RepoData] {
        var repoList: [RepoData] = []
        let data = try! Realm().objects(RepoData.self)
        for value in data {
            repoList.append(value)
        }
        return repoList
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
