//
//  ProfileViewTableViewController.swift
//  iChat
//
//  Created by 大塚悠貴 on 2018/11/15.
//  Copyright © 2018年 otsuka. All rights reserved.
//

import UIKit
import ProgressHUD

class ProfileViewTableViewController: UITableViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var user: FUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    // MARK: - IBActions
    
    @IBAction func callButtonPressed(_ sender: UIButton) {
        print("call user \(user!.fullname)")
    }
    
    @IBAction func chatButtonPressed(_ sender: UIButton) {
        print("chat user \(user!.fullname)")
    }
    
    @IBAction func BlockUserButtonPressed(_ sender: UIButton) {
        
        ProgressHUD.show()
        
        var currentBlockedIds = FUser.currentUser()!.blockedUsers
        
        if currentBlockedIds.contains(user!.objectId) {
            currentBlockedIds.remove(at: currentBlockedIds.index(of: user!.objectId)!)
        } else {
            currentBlockedIds.append(user!.objectId)
        }
        
        updateCurrentUserInFirestore(withValues: [kBLOCKEDUSERID: currentBlockedIds]) { (error) in
            if error != nil {
                print("errror updating user \(String(describing: error?.localizedDescription))")
                ProgressHUD.dismiss()
                return
            }
            self.updateBlockStatus()
            ProgressHUD.dismiss()
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
   
    // MARK: -
    func setUpUI() {
        if user != nil {
            self.title = "Profile"
            fullNameLabel.text = user!.fullname
            phoneNumberLabel.text = user!.phoneNumber
            
            updateBlockStatus()
            
            if user?.avatar != "" {
                imageFromData(pictureData: user!.avatar) { (avatarImage) in
                    if avatarImage != nil {
                        self.avatarImageView.image = avatarImage!.circleMasked
                    }
                }
            }
        }
    }
    
    func updateBlockStatus() {
        
        if user!.objectId != FUser.currentId() {
            blockButton.isHidden = false
            messageButton.isHidden = false
            callButton.isHidden = false
        } else {
            blockButton.isHidden = true
            messageButton.isHidden = true
            callButton.isHidden = true
        }
        
        if FUser.currentUser()!.blockedUsers.contains(user!.objectId) {
            blockButton.setTitle("Unblock user", for: .normal)
        } else {
            blockButton.setTitle("Block user", for: .normal)
        }
    }
}
