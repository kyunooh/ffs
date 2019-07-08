//
//  ViewController.swift
//  ffs
//
//  Created by jelly on 08/07/2019.
//  Copyright © 2019 jellyms. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON
import Alamofire

class UsersTableViewController: UITableViewController {
    
    var userList: [User] = []
    var username: String?
    let headers: HTTPHeaders = [            :
]

    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backButton.isEnabled = self.username != nil
        
        let username = self.username ?? "kyunooh"
        self.title = username
        
        firstly {
            Alamofire
                .request(createFollowersUrl(username: username), headers: headers)
                .responseDecodable([User].self)
        }.done { users in
            //to get JSON return value
            self.userList = users
            self.tableView.reloadData()
            //then use guard to get the value your want
            for (i, user) in users.enumerated() {
                let row = i
                self.setFollowerCount(row: row, user: user)
            }
        }.catch { error in
            print(error)
        }
        

    }
    
    func createFollowersUrl(username: String) -> URL {
        return URL(string: "https://api.github.com/users/\(username)/followers")!
    }

    func setFollowerCount(row: Int, user: User) {
        firstly {
            Alamofire
                .request(self.createUserUrl(username: user.username!), headers: headers)
                .responseDecodable(User.self)
        }.done { responseUser in
            print(responseUser.followerCount)
            print(row)
            print(self.tableView.cellForRow(at: IndexPath(row: row, section: 0)))
            if let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? UITableViewCell {
                self.userList[row].followerCount = responseUser.followerCount!
                configureCell(for: cell, with: self.userList[row])
            }
        }.catch { error in
            print(error)
        }
    }
    
    func configureFollowerCount(for cell: UITableViewCell, with user: User) {
        if let cell = cell as? UserTableViewCell {
            cell.followerCountLabel.text = String(user.followerCount!)
        }
    }
    
    func createUserUrl(username: String) -> URL {
        return URL(string: "https://api.github.com/users/\(username)")!
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = userList[indexPath.row]
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
            cell.followerCountLabel.text = "0"
            if let url = URL(string: user.profileImageUrl!) {
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

