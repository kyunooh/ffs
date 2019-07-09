//
//  User.swift
//  ffs
//
//  Created by jelly on 08/07/2019.
//  Copyright © 2019 jellyms. All rights reserved.
//

import Foundation

class User: Codable {
    var username: String? = ""
    var followerCount: Int? = 0
    var profileImageUrl: String? = ""
    
    enum CodingKeys: String, CodingKey {
        case username = "login", profileImageUrl = "avatar_url", followerCount = "followers"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        followerCount = try values.decodeIfPresent(Int.self, forKey: .followerCount)
        profileImageUrl = try values.decodeIfPresent(String.self, forKey: .profileImageUrl)
    }
 
}
