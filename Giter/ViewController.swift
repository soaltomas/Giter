//
//  ViewController.swift
//  Giter
//
//  Created by Артем Полушин on 09.07.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
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

protocol AddHeader {
    func addHeader(name: String)
}

class ViewController: UITableViewController {
    
    let manager: ManagerData = ManagerData()
    var repoName: String = ""
    var fileDataArray = List<FileData>()
    var dirUrl: String = ""
    
    var delegate2: AddHeader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let repository = manager.loadDB(repository: repoName)
        for value in repository[0].fileList {
            fileDataArray.append(value)
        }
        for value in fileDataArray {
            manager.getFileContent(url: "\(value.url.components(separatedBy: "?")[0])?client_id=8e053ea5a630b94a4bff&client_secret=2486d4165ac963432120e7c4d5a8cbcb5b745c4a", filename: value.name)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(goToDir), name: NSNotification.Name(rawValue: "goToDir"), object: nil)
    }
    
    func goToDir() {
        //delegate1.loadDirContent(repository: repoName, path: dirName)
        let repository = manager.loadDB(repository: repoName)[0]
        manager.loadJSON(repository: repository, pathToDir: dirUrl)
        let tempFileArray = manager.loadDB(repository: repoName)[0].fileList
        for file in tempFileArray {
            if file.name == manager.getNameOfPath(path: dirUrl) {
                fileDataArray = file.fileList
                break
            }
        }
        for value in fileDataArray {
            manager.getFileContent(url: "\(value.url.components(separatedBy: "?")[0])?client_id=8e053ea5a630b94a4bff&client_secret=2486d4165ac963432120e7c4d5a8cbcb5b745c4a", filename: value.name)
        }
            self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileDataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fileDataArray[indexPath.row].name
        let image: UIImageView = cell.viewWithTag(5) as! UIImageView
        if fileDataArray[indexPath.row].type == "dir" {
            image.image = UIImage(named: "folder")
        } else {
            image.image = UIImage(named: "document")
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tvc = storyboard?.instantiateViewController(withIdentifier: "textView") as! TextViewController
        delegate2 = tvc
        if fileDataArray[indexPath.row].type == "file" {
            if let indexPath = tableView.indexPathForSelectedRow {
                do{
                    delegate2?.addHeader(name: fileDataArray[indexPath.row].name)
                    let path = NSHomeDirectory() + "/Documents/\(fileDataArray[indexPath.row].name)"
                    let text = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
                    var result: String = ""
                    for symbol in text.characters {
                        if symbol != "\n" {
                            result.append(symbol)
                        }
                    }
                    
                    tvc.text = result.base64Decoded()!
                } catch let fileError as NSError {
                    print("Couldn't create file because of error: \(fileError)")
                }
                navigationController?.pushViewController(tvc, animated: true)
            }
        } else {
            dirUrl = fileDataArray[indexPath.row].url.components(separatedBy: "?")[0]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToDir"), object: nil)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "goToDir"), object: nil)
    }
}

