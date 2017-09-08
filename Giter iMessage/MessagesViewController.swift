//
//  MessagesViewController.swift
//  Giter iMessage
//
//  Created by Артем Полушин on 08.09.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import Messages
import Alamofire
import SwiftyJSON

class MessagesViewController: MSMessagesAppViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fileDataArray: [(String, String)] = []
    
    @IBOutlet weak var repoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repoListURL = "https://api.github.com/users/soaltomas/repos?client_id=8e053ea5a630b94a4bff&client_secret=2486d4165ac963432120e7c4d5a8cbcb5b745c4a"
        Alamofire.request(repoListURL, method: .get).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                var i: Int = 0
                while i < json.array!.count {
                    self.fileDataArray.append((json[i]["name"].stringValue, json[i]["html_url"].stringValue))
                    i += 1
                }
                
                
            case .failure(let error):
                print("Error thing: \(error)")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTable"), object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable), name: NSNotification.Name(rawValue: "updateTable"), object: nil)
    }
    
    func updateTable() {
        repoTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = MSMessageTemplateLayout()
        let url = URL(fileURLWithPath: fileDataArray[indexPath.row].1)
        print(fileDataArray[indexPath.row].1)
        layout.imageTitle = fileDataArray[indexPath.row].0
        layout.mediaFileURL = url
        layout.imageSubtitle = fileDataArray[indexPath.row].1
        layout.image = UIImage(named: "github-violet-icon")
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message, completionHandler: nil)
        
        
    }
    
    
    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        if message.url != nil {
            self.extensionContext?.open(message.url!)
        }
    }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileDataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imessagecell", for: indexPath)
        cell.textLabel?.text = fileDataArray[indexPath.row].0
        cell.imageView?.image = UIImage(named: "github-violet-icon")
        return cell
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateTable"), object: nil)
    }

}
