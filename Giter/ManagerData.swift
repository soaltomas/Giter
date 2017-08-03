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
    let accessData = AccessData()
   // let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
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
    
    
    func loadFilesJSON(repository: String = "GeekBrainsUniversity", path: String = "") -> [String] {
        var fileList: [String] = []
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
        let data = accessData.getData()
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
