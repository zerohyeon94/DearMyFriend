//
//  LoginController.swift
//  DearMyFriend
//
//  Created by Macbook on 11/5/23.
//

import UIKit

class LoginController: UIViewController {
    
    let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }

}
