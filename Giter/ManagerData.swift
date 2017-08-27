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
    
    struct City {
        let name: String
        let lon: Double
        let lat: Double
    }
    
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
    
    var fileList: [FileData] = [] //---List for display directory content
    
    var cityList: [City] = [] //---temporary list for save city
    
    
    let concurrentQueue = DispatchQueue(label: "concurrent_queue", attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "serial_queue")
    
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
    
    
    func loadJSON(repository: RepoData, pathToDir: String) {
        let file = try! Realm().objects(FileData.self).filter("url BEGINSWITH %@", "\(pathToDir)?")
        let realm = try! Realm()
            let selfContentURL = "\(pathToDir)?client_id=8e053ea5a630b94a4bff&client_secret=2486d4165ac963432120e7c4d5a8cbcb5b745c4a"
            Alamofire.request(selfContentURL, method: .get).validate().responseJSON() { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var i: Int = 0
                    while i < json.array!.count {
                        let fileData = FileData()
                       // fileData.file_id = FileData.incrementId()
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
                           // for file in repository.fileList {
                               // if file.name == self.getNameOfPath(path: pathToDir) {
                                for tempFile in file[0].fileList{
                                    if tempFile.url == fileData.url {
                                        let index = file[0].fileList.index(of: tempFile)
                                        file[0].fileList.remove(objectAtIndex: index!)
                                    }
                                }
                                file[0].fileList.append(fileData)
                               // }
                        //    }
                            }
                        }
                        i += 1
                    }
                    self.loadRepo = true as AnyObject
                    try! realm.write {
                        if pathToDir == "\(repository.url)/contents" {
                            realm.add(repository, update: true)
                        } else {
                            realm.add(file)
                        }
                    }
                    
                case .failure(let error):
                    print("Error thing: \(error)")
                }
            }
            
        }
    
    
    func loadRepoJSON() {
        var tempRepoList: [RepoData] = []
        let repoListURL = "https://api.github.com/users/soaltomas/repos?client_id=8e053ea5a630b94a4bff&client_secret=2486d4165ac963432120e7c4d5a8cbcb5b745c4a"
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
                        tempRepoList.append(repoData)
                        i += 1
                    }
                for repo in tempRepoList {
                    self.loadJSON(repository: repo, pathToDir: "\(repo.url)/contents")
                }
                
                
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }
    }
    
    func loadDB(repository: String) -> Results<RepoData> {
        return try! Realm().objects(RepoData.self).filter("name BEGINSWITH %@", repository)
    }
    
    func loadDirDB(pathToDir: String) -> Results<FileData> {
        return try! Realm().objects(FileData.self).filter("url BEGINSWITH %@", "\(pathToDir)?")
    }
    
    func loadRepoListDB() -> [RepoData] {
        var resultList: [RepoData] = []
        let data = try! Realm().objects(RepoData.self)
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
    
    
    
    
    func loadOWMJSON()  {
        let url = "http://samples.openweathermap.org/data/2.5/box/city?bbox=12,32,15,37,10&appid=90ed5e72b54eb9d0573beeec4a2e19ce"
        Alamofire.request(url, method: .get).validate().responseJSON(queue: concurrentQueue) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for (_, subJson) in json["list"] {
                    let city = City(name: subJson["name"].stringValue, lon: subJson["coord"]["lon"].doubleValue, lat: subJson["coord"]["lat"].doubleValue)
                    self.cityList.append(city)
                    
                }
                self.loadRepo = true as AnyObject
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    
}
