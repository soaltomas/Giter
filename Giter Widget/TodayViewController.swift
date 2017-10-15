//
//  TodayViewController.swift
//  Giter Widget
//
//  Created by Артем Полушин on 05.09.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    var fileDataArray: [String] = []
    
    func loadRepoJSON() {
        let repoListURL = "https://api.github.com/users/soaltomas/repos?client_id=8e053ea5a630b94a4bff&client_secret=2486d4165ac963432120e7c4d5a8cbcb5b745c4a"
        Alamofire.request(repoListURL, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var i: Int = 0
                while i < json.array!.count {
                    self.fileDataArray.append(json[i]["name"].stringValue)
                    i += 1
                }
                
                
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let repoListURL = "https://api.github.com/users/\(currentUser!)/repos?client_id=8e053ea5a630b94a4bff&client_secret=2486d4165ac963432120e7c4d5a8cbcb5b745c4a"
        Alamofire.request(repoListURL, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var i: Int = 0
                while i < json.array!.count {
                    self.fileDataArray.append(json[i]["name"].stringValue)
                    i += 1
                }
                
                
            case .failure(let error):
                print("Error thing: \(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "widgetcell", for: indexPath)
        cell.textLabel?.text = fileDataArray[indexPath.row]
        cell.imageView?.image = UIImage(named: "github-violet-icon")
        return cell
    }
    
}
