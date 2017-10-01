//
//  SelfRepository.swift
//  Giter
//
//  Created by Артем Полушин on 17.07.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import WatchConnectivity
import Alamofire
import SwiftyJSON
import RealmSwift

private let reuseIdentifier = "Cell"

class SelfRepository: UICollectionViewController {
    
    let manager: ManagerData = ManagerData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "octocat_iphone_orange")
        let imageView = UIImageView(image: image)
        collectionView?.backgroundView = imageView
        imageView.alpha = 0.4
        
        navigationItem.hidesBackButton = true
        do {
            let fileManager = FileManager.default
            try fileManager.createDirectory(atPath: NSHomeDirectory() + "/Documents/files", withIntermediateDirectories: false, attributes: nil)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        if loadRepo == nil {
            manager.loadRepoJSON()
        } else {
            ManagerData.singleManager.getRepoDataFromDB()

    }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return ManagerData.singleManager.repoData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let labelName: UILabel = cell.viewWithTag(1) as! UILabel
        labelName.text = ManagerData.singleManager.repoData[indexPath.row].name
        let viewDescription: UITextView = cell.viewWithTag(2) as! UITextView
        viewDescription.text = ManagerData.singleManager.repoData[indexPath.row].repoDescription
        let labelLanguage: UILabel = cell.viewWithTag(3) as! UILabel
        labelLanguage.text = ManagerData.singleManager.repoData[indexPath.row].language
        if ManagerData.singleManager.repoData[indexPath.row].fork {
            let forkImage: UIImageView = cell.viewWithTag(4) as! UIImageView
            forkImage.image = UIImage(named: "if_code-fork_1608638")
        }
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            if let destination = segue.destination as? ViewController {
                let cell = sender as! UICollectionViewCell
                let indexPath = self.collectionView?.indexPath(for: cell)
                let selectedItem = ManagerData.singleManager.repoData[(indexPath?.row)!].name
               // manager.loadBranchList(repository: selectedItem, user: "soaltomas")
                destination.repoName = selectedItem
                destination.currentBranch = ManagerData.singleManager.repoData[(indexPath?.row)!].currentBranch
            }
        }
    }
    

    
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
