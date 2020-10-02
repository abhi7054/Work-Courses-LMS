//
//  Profile.swift
//  Work Courses LMS
//
//  Created by Arpit on 10/2/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import UIKit

class TVCProfile : UITableViewController {
    @IBOutlet var logoutButton: UIButton!
    @IBAction func logoutButtonTouched(_ sender: Any) {
        Preferences().auth = nil
        if let ad = UIApplication.shared.delegate as? AppDelegate {
            ad.setRoot()
        }
    }
}
