//
//  UserList.swift
//  ffs
//
//  Created by jelly on 08/07/2019.
//  Copyright © 2019 jellyms. All rights reserved.
//

import Foundation

class UserList {
    var userList: [User] = []
    
    init() {
        let user1 = User()
        user1.username = "this is user 1"
        user1.followerCount = 10
        self.userList.append(user1)
        
        let user2 = User()
        user2.username = "this is user 2"
        user2.followerCount = 550
        self.userList.append(user2)
        
        
    }
    
}
