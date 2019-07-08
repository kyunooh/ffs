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
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let username = self.username ?? "kyunooh"

        Alamofire.request(createFollowersUrl(username: username)).responseJSON { response in
            switch response.result {
            case .success(_):
                //to get JSON return value
                if let result = response.result.value {
                    let json = result as! [[String: Any]]
                    //then use guard to get the value your want
                    for u in json {
                        let user = User()
                        user.username = u["login"] as! String
                        user.profileImageUrl = u["avatar_url"] as! String
                        self.userList.userList.append(user)
                        Alamofire.request(self.createUserUrl(username: user.username)).responseJSON { response in
                            if let result = response.result.value as? [String: Any]{
                                user.followerCount = result["followers"] as! Int
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            case .failure(_): break
                
            }
        }
    }
    
    func createFollowersUrl(username: String) -> URL {
        return URL(string: "https://api.github.com/users/\(username)/followers")!
    }
    func createUserUrl(username: String) -> URL {
        return URL(string: "https://api.github.com/users/\(username)")!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserListSegue" {
            if let cell = sender as? UserTableViewCell,
                let destination = segue.destination as? UsersTableViewController {
                destination.username = cell.usernameLabel.text
            }
        }
    }
    
    
    func configureCell(for cell: UITableViewCell, with user: User) {
        if let cell = cell as? UserTableViewCell {
            cell.usernameLabel.text = user.username
            cell.followerCountLabel.text = String(user.followerCount)
            if let url = URL(string: user.profileImageUrl) {
                do {
                    let data = try Data(contentsOf: url)
                    cell.profileImageView.image = UIImage(data: data)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    
}

