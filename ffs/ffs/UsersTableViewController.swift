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
    
    @IBOutlet weak var backButton: UIBarButtonItem!

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backButton.isEnabled = self.username != nil
        let username = self.username ?? "kyunooh"
        let headers: HTTPHeaders = [:]
        self.title = username
        
        Alamofire.request(createFollowersUrl(username: username), headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                //to get JSON return value
                if let result = response.result.value {
                    let json = result as! [[String: Any]]
                    //then use guard to get the value your want
                    for (i, u) in json.enumerated() {
                        let user = User()
                        let row = i
                        user.username = u["login"] as! String
                        user.profileImageUrl = u["avatar_url"] as! String
                        self.userList.userList.append(user)
                        self.tableView.insertRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
                        Alamofire.request(self.createUserUrl(username: user.username), headers: headers).responseJSON { response in
                            if let result = response.result.value as? [String: Any] {
                                user.followerCount = result["followers"] as? Int ?? 0
                                if let cell = self.tableView.cellForRow(at: IndexPath.init(row: row, section: 0)) as? UserTableViewCell {
                                    cell.followerCountLabel.text = String(user.followerCount)
                                }
                                
                            }
                        }
                    }
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

