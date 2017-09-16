//
//  ViewController.swift
//  TwitSplit_iOS
//
//  Created by dat on 9/15/17.
//  Copyright © 2017 dat. All rights reserved.
//

import UIKit

class TwitSplitVC: UIViewController {

    @IBOutlet weak var tfUserMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnPostMessageClicked(_ sender: UIButton) {
        
        // show posting notification to UI
        self.view.makeToastActivity("Posting message...", .center)
        // processing message should use in background thread to protect UI
        DispatchQueue.global().async {
            [weak self] in
            // processing input message
            let sendMessage = UtilFunctions.splitMessage(self?.tfUserMessage.text)
            // back to main thread to show result to UI
            DispatchQueue.main.sync {
                self?.view.hideToastActivity()
                var messageResult = "Success!"
                if sendMessage == nil {
                    messageResult = "Error!"
                }
                self?.view.makeToast(messageResult, duration: 2.0, position: .center)
            }
            
        }
    }

}

