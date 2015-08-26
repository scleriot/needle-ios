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
    @IBOutlet weak var signupSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpText.sizeToFit()
    }

    
    
    @IBAction func dismissPopup(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func login(sender: UIBarButtonItem) {
        if self.signupSwitch.on {
            var confirmAlert = UIAlertController(title: "Création du compte", message: "En créant votre compte, vous acceptez les conditions d'utilisation.", preferredStyle: UIAlertControllerStyle.Alert)
            
            confirmAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                Account.signup(self.emailField.text, password: self.passwordField.text, callback: { () -> Void in
                    self.doLogin()
                })
            }))
            
            confirmAlert.addAction(UIAlertAction(title: "Annuler", style: .Default, handler: { (action: UIAlertAction!) in
                
            }))
            
            presentViewController(confirmAlert, animated: true, completion: nil)
        }
        else {
            doLogin()
        }
    }
    
    func doLogin() {
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