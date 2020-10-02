//
//  RegistrationViewController.swift
//  Work Courses LMS
//
//  Created by Abhishek Dubey on 23/09/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import UIKit

//MARK:- Controller
class RegistrationViewController: UIViewController {
    @IBOutlet var tfFName: UITextField!
    @IBOutlet var tfLName: UITextField!
    @IBOutlet var tfCompany: UITextField!
    @IBOutlet var tfPhone: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        
    }
}
