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
import RealmSwift
import Realm

//extension String {
//    func stringByAppendingPathComponent1(path: String) -> String {
//        let nsSt = self as NSString
//        return nsSt.appendingPathComponent(path)
//    }
//}

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource, UITableViewDelegate {
    var fileDataArray: [String] = []
    
    func loadDB() -> Results<RepoData> {
        return try! Realm().objects(RepoData.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Giter")!
        let realmPath = directory.path.appending("/default.realm")
        let configuration = RLMRealmConfiguration.default()
        configuration.pathOnDisk = realmPath
        RLMRealmConfiguration.setDefault(configuration)
        let repos: [RepoData] = Array(loadDB())
        print("It's here: \(realmPath)")
        for repo in repos {
            fileDataArray.append(repo.name)
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
