//
//  SearchViewController.swift
//  Giter
//
//  Created by Артем Полушин on 10.09.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField!
    
    let manager: ManagerData = ManagerData()
    var repoKeyWord: String = ""
    var searchResults: [RepoData] = []
    
    @IBAction func forkRepository(_ sender: UIButton) {
        let repo: RepoData = manager.loadDB(repository: sender.layer.value(forKey: "name") as! String)[0]
        manager.forkRepository(owner: repo.ownerLogin, repoName: repo.name)
        sender.setImage(UIImage(named: "Check-icon"), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateCollection"), object: nil)
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "octocat_iphone_orange")
        let imageView = UIImageView(image: image)
        tableView.backgroundView = imageView
        imageView.alpha = 0.2
        
        self.searchField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateSearchTable), name: NSNotification.Name(rawValue: "updateSearchTable"), object: nil)
    }
    
    func updateSearchTable() {
        searchResults.append(contentsOf: manager.loadDB(repository: repoKeyWord))
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].name
        
        let forkButton: UIButton = cell.viewWithTag(1) as! UIButton
        forkButton.layer.setValue(cell.textLabel?.text, forKey: "name")
        
        if searchResults[indexPath.row].ownerLogin == currentUser! {
            forkButton.setImage(UIImage(named: "Check-icon"), for: .normal)
        } else {
            forkButton.setImage(UIImage(named: "fork"), for: .normal)
        }

        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchResults.removeAll()
        if textField.text != nil {
            repoKeyWord = textField.text!
        }
        manager.searchRepoJSON(url: "https://api.github.com/search/repositories?q=\(repoKeyWord)")
        return false
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destination = segue.destination as! ViewController
                let selectedRow = searchResults[indexPath.row].name
                destination.repoName = selectedRow
            }
        }
    }

}
