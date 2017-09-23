//
//  ChooseBranchController.swift
//  Giter
//
//  Created by Артем Полушин on 16.09.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import RealmSwift

protocol LoadOtherBranch {
    func loadOtherBranch(repo: String, branch: String)
}

class ChooseBranchController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let manager: ManagerData = ManagerData()
    var currentRepo: String = ""
    var selectedBranch: String = ""
    
    @IBAction func selectBranchButton(_ sender: Any) {
        
    }
    @IBOutlet weak var branchPicker: UIPickerView!
    
    var branchList = List<BranchData>()
    
    var delegate: LoadOtherBranch?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateBranches), name: NSNotification.Name(rawValue: "updateBranches"), object: nil)
        manager.loadBranchList(repository: currentRepo, user: "soaltomas")
        branchPicker.delegate = self
        branchPicker.dataSource = self
    }
    
    func updateBranches() {
        let repository = manager.loadDB(repository: currentRepo)
        self.branchList.append(contentsOf: repository[0].branchList)
        self.branchPicker.reloadAllComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return branchList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return branchList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBranch = branchList[row].name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToRepo" {
            if let destination = segue.destination as? ViewController {
                destination.repoName = currentRepo
                destination.currentBranch = selectedBranch
                destination.currentDir = "https://api.github.com/repos/soaltomas/\(currentRepo)/contents"
            }
        }
    }

}
