//
//  ChatsViewController.swift
//  iChat
//
//  Created by 大塚悠貴 on 2018/11/14.
//  Copyright © 2018年 otsuka. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: IBActions
    @IBAction func createNewChatButtonTapped(_ sender: UIBarButtonItem) {
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userTableVIew") as! UsersTableViewController
        
        self.navigationController?.pushViewController(userVC, animated: true)
    }
}
