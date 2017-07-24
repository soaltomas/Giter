//
//  TextViewController.swift
//  Giter
//
//  Created by Артем Полушин on 25.07.17.
//  Copyright © 2017 Артем Полушин. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    var text: String = ""
    @IBOutlet var textView : UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
