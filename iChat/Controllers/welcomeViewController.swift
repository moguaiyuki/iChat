//
//  welcomeViewController.swift
//  iChat
//
//  Created by 大塚悠貴 on 2018/11/09.
//  Copyright © 2018年 otsuka. All rights reserved.
//

import UIKit
import ProgressHUD

class welcomeViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: IBActions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        dissmissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            loginUser()
        } else {
            ProgressHUD.showError("Email and Password are both required!")
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        dissmissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" {
            
            if passwordTextField.text == repeatPasswordTextField.text {
                registerUser()
            } else {
                ProgressHUD.showError("Password don't match!")
            }
            
        } else {
            ProgressHUD.showError("All fields are both required!")
        }
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        dissmissKeyboard()
    }
    
    // MARK: Helper functions
    
    func loginUser() {
        
        ProgressHUD.show("Login...")
        
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            self.goToApp()
        }
        
    }
    
    func registerUser() {
        dissmissKeyboard()
        performSegue(withIdentifier: "welcomToFinishReg", sender: self)
        cleanTextFields()
    }
    
    func dissmissKeyboard() {
        self.view.endEditing(false)
    }
    
    func cleanTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    
    //MARK: GoToApp
    func goToApp() {
        ProgressHUD.dismiss()
        cleanTextFields()
        dissmissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentId()])
        
        let mainViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainViewController, animated: true, completion: nil)
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "welcomToFinishReg" {
            let vc = segue.destination as! FinishRegistrationViewController
            vc.email = emailTextField.text!
            vc.password = passwordTextField.text!
        }
    }
    
}
