//
//  LoginViewController.swift
//  Giter
//
//  Created by Артем Полушин on 10.08.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorText: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var resultLogin: String = ""
    var headers: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goToApp), name: NSNotification.Name(rawValue: "goToApp"), object: nil)
        
        emailField.text = credentials?.values.first?.components(separatedBy: "Basic ")[1].base64Decoded()?.components(separatedBy: ":")[0]
        passwordField.text = credentials?.values.first?.components(separatedBy: "Basic ")[1].base64Decoded()?.components(separatedBy: ":")[1]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tryLogin(_ sender: Any) {
//        let credential = GitHubAuthProvider.credential(withToken: "9d233ee0abd93f59e064851653266dc8997ac7ad")
//
//        Auth.auth().signIn(with: credential) { (user, error) in
//            if error != nil {
//                self.errorText.text = "Incorrect e-mail or password"
//            }
//            else {
//                self.performSegue(withIdentifier: "CurrentlyLoggedIn", sender: nil)
//            }
//        }
        
        let credentialData = "\(emailField.text!):\(passwordField.text!)"
        let base64Credentials = credentialData.base64Encoded()!
        headers = ["Authorization": "Basic \(base64Credentials)"]
        
        
        Alamofire.request("https://api.github.com/user", method: .get, headers: headers).validate().responseJSON() { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.resultLogin = json["login"].stringValue
            case .failure(let error):
                print("Error thing: \(error)")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToApp"), object: nil)
        }
        
    }
    
    func goToApp() {
        if resultLogin == emailField.text {
            credentials = headers
            self.performSegue(withIdentifier: "CurrentlyLoggedIn", sender: nil)
        } else {
            self.errorText.text = "Incorrect e-mail or password"
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
