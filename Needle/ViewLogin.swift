//
//  ViewLogin.swift
//  Needle
//
//  Created by Simon Cleriot on 8/18/15.
//  Copyright (c) 2015 Needle. All rights reserved.
//

import UIKit
import Alamofire
import JLToast

class ViewLogin: UIViewController {
    @IBOutlet weak var helpText: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpText.sizeToFit()
    }

    
    
    @IBAction func dismissPopup(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func login(sender: UIBarButtonItem) {
        let progressHUD = ProgressHUD(text: "Connexion en cours...")
        self.view.addSubview(progressHUD)
        
        NeedleApiManager.sharedInstance.startOAuth2Login(emailField.text, password: passwordField.text,
            successCallback: {
                if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("curatedView") as? UIViewController
                {
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            },
            errorCallback: {
                JLToast.makeText("Erreur de connexion, vérifiez votre e-mail et mot de passe.", duration: JLToastDelay.LongDelay).show()
            })
    }
}