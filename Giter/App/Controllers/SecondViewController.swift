import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

protocol SecondLoadNextDirectory {
    func secondLoadNextDirectory(url: String, branch: String)
}

class SecondViewController: UITableViewController, FirstLoadNextDirectory {
    
    let manager: ManagerData = ManagerData()
    var repoName: String = ""
    var fileDataArray = List<FileData>()
    var dirUrl: String = ""
    var counter: Int = 0
    var currentDir: String = ""
    var currentBranch: String = "master"
    
    var delegate1: SecondLoadNextDirectory?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "octocat_iphone_orange")
        let imageView = UIImageView(image: image)
        tableView.backgroundView = imageView
        imageView.alpha = 0.2
        
        let oldBranch = manager.loadDB(repository: repoName)[0].currentBranch
        if oldBranch != currentBranch {
            manager.setCurrentBranch(repo: repoName, currentBranch: currentBranch)
            if counter == 0 {
                let repository = manager.loadDB(repository: repoName)
                for value in repository[0].fileList {
                    fileDataArray.append(value)
                }
            }
            let fileManager = FileManager.default
            do {
                try fileManager.removeItem(atPath: NSHomeDirectory() + "/Documents/files")
                try fileManager.createDirectory(atPath: NSHomeDirectory() + "/Documents/files", withIntermediateDirectories: false, attributes: nil)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            manager.clearFileListDB(repository: repoName)
            fileDataArray.removeAll()
          //  manager.loadRepoJSON(selectedRepo: repoName, branch: currentBranch)
        }

        
        if counter == 0 {
            let repository = manager.loadDB(repository: repoName)
            for value in repository[0].fileList {
                fileDataArray.append(value)
            }
        }
        for value in fileDataArray {
            manager.getFileContent(url: "\(value.url.components(separatedBy: "?")[0])?ref=\(currentBranch)", filename: value.name)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name(rawValue: "updateTable"), object: nil)
    }
    
    func firstLoadNextDirectory(url: String, branch: String) {
        currentDir = url
        let repository = manager.loadDB(repository: repoName)[0]
        manager.loadJSON(repository: repository, user: "soaltomas", pathToDir: url)
        fileDataArray.removeAll()
        fileDataArray.append(contentsOf: manager.loadDirDB(pathToDir: url)[0].fileList)
        for value in fileDataArray {
            manager.getFileContent(url: "\(value.url.components(separatedBy: "?")[0])?ref=\(currentBranch)", filename: value.name)
        }

    }
    
    func updateTable() {
        if counter > 0 {
            fileDataArray = manager.loadDirDB(pathToDir: currentDir)[0].fileList
            for value in fileDataArray {
                manager.getFileContent(url: "\(value.url.components(separatedBy: "?")[0])?ref=\(currentBranch)", filename: value.name)
            }
            self.tableView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let tvc = storyboard?.instantiateViewController(withIdentifier: "textView") as! TextViewController //---Просмотр текстового файла
        let firstTableView = storyboard?.instantiateViewController(withIdentifier: "firstTableView") as! ViewController //---Переход в директорию
        delegate1 = firstTableView
       // delegate2 = tvc
        if fileDataArray[indexPath.row].type == "file" {
            if let indexPath = tableView.indexPathForSelectedRow {
                do{
                   // delegate2?.addHeader(name: fileDataArray[indexPath.row].name)
                    let path = NSHomeDirectory() + "/Documents/files/\(fileDataArray[indexPath.row].name)"
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
            firstTableView.counter = self.counter + 1
            firstTableView.currentBranch = self.currentBranch
            firstTableView.repoName = self.repoName
            delegate1?.secondLoadNextDirectory(url: dirUrl, branch: self.currentBranch)
            navigationController?.pushViewController(firstTableView, animated: true)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTable"), object: nil)
    }


}
