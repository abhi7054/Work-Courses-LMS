//
//  ViewController.swift
//  Work Courses LMS
//
//  Created by Abhishek Dubey on 30/07/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var username: String!
    var password: String!
    let loggedInKey = "loggedIn"
    let usernameKey = "username"
    
    struct loginResponse: Decodable {
        let authorizationToken: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        if UserDefaults.standard.bool(forKey: loggedInKey){
        }
        
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
        
        username = usernameTextField.text
        password = passwordTextField.text
        
        switch (usernameTextField.isEmpty, passwordTextField.isEmpty) {
        case (true, true):
            self.show("Empty Credentials", "Please enter login credentials")
        case (true, false):
            self.show("Empty Username", "Please enter the username")
        case (false, true):
            self.show("Empty Password", "Please enter the password")
        default:
            login(username: username, password: password)
        }
    }
    
    func login(username: String, password: String){
        self.view.endEditing(true)
        let p = WDManager.EndPoints.login.url(query: "username=\(username)&password=\(password)")
        let r = WDManager.urlRequest(with: p, params: [:], method: "POST")
        let task = URLSession.shared.stringResponeTask(with: r, completionHandler: { (text, response, error) in
            if let auth = text, auth == "Authorization Token: #3" {
                DispatchQueue.main.async {
                    let a = Auth(authToken: auth, email: username)
                    Preferences().auth = a
                    if let ad = UIApplication.shared.delegate as? AppDelegate {
                        ad.setRoot()
                    }
                }
            }else{
                //self.view.makeToast("Error! Will provide detailed description about error soon.")
                if let e = error as NSError? {
                    self.showToast(title: nil, message: e.localizedDescription)
                    return
                }
            }
        })
        task.resume()
    }
}
