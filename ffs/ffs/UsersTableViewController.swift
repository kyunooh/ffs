//
//  ViewController.swift
//  ffs
//
//  Created by jelly on 08/07/2019.
//  Copyright © 2019 jellyms. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UsersTableViewController: UITableViewController {

    var userList: UserList = UserList()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let url = URL(string: "https://api.github.com/users/kyunooh/followers") else {
        }
        
        Alamofire.request(method: .GET, "https://api.github.com/users/kyunooh/followers").responseJSON { (req, res, json) -> Void in
            let swiftyJsonVar = JSON(json)
            
            if let resData = swiftyJsonVar["contacts"].arrayObject {
                self.arrRes = resData as! [[String:AnyObject]]
            }
            if self.arrRes.count > 0 {
                self.tblJSON.reloadData()
            }
        }

        userList = UserList()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.userList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = userList.userList[indexPath.row]
        configureCell(for: cell, with: user)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
    func configureCell(for cell: UITableViewCell, with user: User) {
        if let cell = cell as? UserTableViewCell {
            cell.usernameLabel.text = user.username
            cell.followerCountLabel.text = String(user.followerCount)
        }
    }
    
    
}

