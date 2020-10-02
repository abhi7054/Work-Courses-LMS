//
//  Register.swift
//  Work Courses LMS
//
//  Created by Arpit on 10/2/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import UIKit

class VCRegister: UIViewController {
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
    
    func getParameters() -> Dictionary<String, Any>? {
        if tfFName.isEmpty {
            self.show(nil, "Please enter first name.", nil)
        } else if tfLName.isEmpty {
            self.show(nil, "Please enter las name.", nil)
        } else if tfCompany.isEmpty {
            self.show(nil, "Please enter company name.", nil)
        } else if tfPhone.isEmpty {
            self.show(nil, "Please enter phone number.", nil)
        } else if tfEmail.isEmpty {
            self.show(nil, "Please enter email.", nil)
        } else if tfPassword.isEmpty {
            self.show(nil, "Please enter password.", nil)
        }

        var params : [String:Any] = [:]
        params["firstname"] = tfFName.text
        params["lastname"] = tfLName.text
        params["phone"] = tfCompany.text
        params["email"] = tfPhone.text
        params["company"] = tfEmail.text
        params["password"] = tfPassword.text
        return params
    }
    
    @IBAction func registerButtonTouched(_ sender: Any) {
        self.view.endEditing(true)
        
        let p = WDManager.EndPoints.register.url()
        if let  param = self.getParameters() {
            let req = WDManager.urlRequest(with: p, params: param, method: "POST")
            let task = URLSession.shared.standerdResponseTask(with: req) { (register, response, error) in
                if let register = register {
                    print("auth = \(register)")
                    self.showToast(title: "Done!", message: "Account registred, wait for confirmation and then you can login.")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    //self.view.makeToast("Error! Will provide detailed description about error soon.")
                    if let e = error as NSError? {
                        self.showToast(title: nil, message: e.localizedDescription)
                        return
                    }
                }
            }
            task.resume()
        }
    }
    
    //..
    @IBAction func backButtonTouched(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
