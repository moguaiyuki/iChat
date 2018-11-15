//
//  SettingsTableViewController.swift
//  iChat
//
//  Created by 大塚悠貴 on 2018/11/13.
//  Copyright © 2018年 otsuka. All rights reserved.
//

import UIKit
import ProgressHUD

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //MARK: IBActions
    
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        print("Hello")
        FUser.logOutCurrentUser { (success) in
            print("loged out")
            if success {
                print("logout success")
                self.showLoginView()
            }
        }
    }
    
    func showLoginView() {
        let mainViewControlelr = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
        self.present(mainViewControlelr, animated: true, completion: nil)
    }
}
