//
//  LoginViewController.swift
//  Giter
//
//  Created by Артем Полушин on 10.08.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorText: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tryLogin(_ sender: Any) {
//        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
//            if let error = error {
//                self.errorText.text = "Incorrect e-mail or password"
//            }
//            else if let user = user {
//                self.performSegue(withIdentifier: "CurrentlyLoggedIn", sender: nil)
//            }
//        }
        self.performSegue(withIdentifier: "CurrentlyLoggedIn", sender: nil)
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
