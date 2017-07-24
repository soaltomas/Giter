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

class ViewController: UITableViewController {
    
    let manager: ManagerData = ManagerData()
    var repoName: String = ""
    var fileDataArray: [FileData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let repository = manager.loadDB(repository: repoName)
        for value in repository[0].fileList {
            fileDataArray.append(value)
        }
        for value in fileDataArray {
        manager.writeToFile(content: "Name: \(value.name)\nType: \(value.type)\nSize: \(value.size)\nSHA: \(value.sha)", filename: value.name)
        }
    
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
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "textFile" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! TextViewController
                do{
                    let path = NSHomeDirectory() + "/Documents/\(fileDataArray[indexPath.row].name)"
                    destinationVC.text = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) as String
                } catch let fileError as NSError {
                    print("Couldn't create file because of error: \(fileError)")
                }
            }
        }
    }
    
    
    @IBAction func goHome(segue: UIStoryboardSegue) {
        
    }


}

