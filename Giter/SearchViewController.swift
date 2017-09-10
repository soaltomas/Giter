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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        searchResults.removeAll()
        if textField.text != nil {
            repoKeyWord = textField.text!
        }
        manager.searchRepoJSON(url: "https://api.github.com/search/repositories?q=\(repoKeyWord)&client_id=8e053ea5a630b94a4bff&client_secret=2486d4165ac963432120e7c4d5a8cbcb5b745c4a")
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
