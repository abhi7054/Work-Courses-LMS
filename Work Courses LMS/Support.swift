//
//  Support.swift
//  Work Courses LMS
//
//  Created by Arpit on 10/2/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import UIKit

extension String {
    enum ValidityType {
        case name
        case studentName
        case groupName
        case phoneNumber
        case password
        case numberOfBuses
    }
    enum Regex: String {
        case name = "[A-Za-z0-9 ]{4,}"
        case studentName = "(?i)ST[A-Za-z0-9]{2,}"
        case groupName = "(?i)GR[A-Za-z0-9]{2,}"
        case phoneNumber = "[0-9]{10,10}"
        case numberOfBuses = "[0-9]{0,}"
    }
    
    func isValid(_ validityType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validityType {
        case .name:
            regex = Regex.name.rawValue
        case .studentName :
            regex = Regex.studentName.rawValue
        case .groupName :
            regex = Regex.groupName.rawValue
        case .phoneNumber :
            regex = Regex.phoneNumber.rawValue
        case .numberOfBuses :
            regex = Regex.numberOfBuses.rawValue
        case .password :
            return (self.count >= 6)
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}

extension UIViewController {
    func viewController(viewController:String!, fromStoryBoard storyBoard : String!) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyBoard, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier:viewController)
    }
    
    static func viewController(viewController:String, fromStoryBoard storyBoard : String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyBoard, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier:viewController)
    }
    
    func showToast(title:String?, message:String?, duration:Double = 3) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    func showAlert(title:String?, message:String?, actions:[String]) {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(ac, animated: true, completion: nil)
    }
    
    func show(_ title: String? = nil, _ message: String? = nil, _ cancelAction: String, _ confirmAction: String, onSelectConfirm: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelAction, style: .cancel, handler: { (_) in
            onSelectConfirm(false)
        }))
        alert.addAction(UIAlertAction(title: confirmAction, style: .default, handler: { (_) in
            onSelectConfirm(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func show(_ title: String? = nil, _ message: String? = nil, _ actionName: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionName == nil ? "Ok" : actionName, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func show(_ title: String? = nil, _ message: String? = nil, _ confirmAction: String, onSelectConfirm: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmAction, style: .default, handler: { (_) in
            onSelectConfirm(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UITableView {
    func register(nib name:String, identifier:String) {
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: identifier)
    }
}


extension String {
    var capitalizeFirstLetter : String {
        get {
            let first = String(self.prefix(1)).capitalized
            let other = String(self.dropFirst())
            return first + other
        }
    }
    
    func heightWithConstraint(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}

extension UITextField {
    var isEmpty: Bool {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
