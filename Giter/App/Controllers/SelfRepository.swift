import UIKit
import WatchConnectivity
import Alamofire
import SwiftyJSON
import RealmSwift

private let reuseIdentifier = "Cell"

class SelfRepository: UICollectionViewController {
    
    let manager: ManagerData = ManagerData()
    let requestFactory = RequestFactory()
    
    var repoDataArray = List<Repository>()
    
    var currentRepo: String = ""
    var currentBranch: String = ""

    @IBAction func refreshButton(_ sender: Any) {
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestFactory.getUser(completionHandler: { response in
            guard
                let currentUser = response.value
                else {
                    return
            }
            RequestRouter.currentUser = currentUser
            print("-----User: \(currentUser)")
        })
        
   //     NotificationCenter.default.addObserver(self, selector: #selector(updateCollection), name: NSNotification.Name(rawValue: "updateCollection"), object: nil)
        
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
            manager.loadRepositories()
            print("------Грузим из сети")
        } else {
            RepositoryRepository.getRepositories()
            repoDataArray.removeAll()
            for repo in RepositoryRepository.repositories {
                repoDataArray.append(repo)
            }
            print("-------Грузим из базы")

    }
        
    }
    
//    func updateCollection() {
//        ManagerData.singleManager.getRepoDataFromDB()
//        repoDataArray.removeAll()
//        for repo in ManagerData.singleManager.repoData {
//            if repo.ownerLogin == "soaltomas" {
//                repoDataArray.append(repo)
//            }
//        }
//        self.collectionView?.reloadData()
//    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return repoDataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let labelName: UILabel = cell.viewWithTag(1) as! UILabel
        labelName.text = RepositoryRepository.repositories[indexPath.row].name
        let viewDescription: UITextView = cell.viewWithTag(2) as! UITextView
      //  viewDescription.text = RepositoryRepository.repositories[indexPath.row].descr
        let labelLanguage: UILabel = cell.viewWithTag(3) as! UILabel
        labelLanguage.text = RepositoryRepository.repositories[indexPath.row].language
        let labelBranch: UILabel = cell.viewWithTag(5) as! UILabel
        labelBranch.text = "<current_branch>"
        let forkImage: UIImageView = cell.viewWithTag(4) as! UIImageView
        if RepositoryRepository.repositories[indexPath.row].isFork {
            forkImage.image = UIImage(named: "if_code-fork_1608638")
        } else {
            forkImage.image = UIImage(named: "")
        }
        
        let selectBranchButton: UIButton = cell.viewWithTag(6) as! UIButton
        selectBranchButton.layer.setValue(indexPath.row, forKey: "index")
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            if let destination = segue.destination as? ViewController {
                let cell = sender as! UICollectionViewCell
                let indexPath = self.collectionView?.indexPath(for: cell)
                let selectedItem = RepositoryRepository.repositories[(indexPath?.row)!].name
               // manager.loadBranchList(repository: selectedItem, user: currentUser!)
                destination.repoName = selectedItem!
                destination.currentBranch = "<current_branch>"
            }
        }
        if segue.identifier == "branches" {
            if let destination = segue.destination as? ChooseBranchController {
                let button = sender as! UIButton
                destination.currentRepo = RepositoryRepository.repositories[(button.layer.value(forKey: "index") as! Int)].name!
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
