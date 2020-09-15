//
//  GitHubSearchModel.swift
//  how_to_medium_series
//
//  Created by Vijay on 15/09/20.
//  Copyright © 2020 Gokul. All rights reserved.
//


import Foundation
struct GitHubSearchModel : Codable {
    let total_count : Int?
    let incomplete_results : Bool?
    let userInfo : [UserInfo]?

    enum CodingKeys: String, CodingKey {

        case total_count = "total_count"
        case incomplete_results = "incomplete_results"
        case userInfo = "items"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total_count = try values.decodeIfPresent(Int.self, forKey: .total_count)
        incomplete_results = try values.decodeIfPresent(Bool.self, forKey: .incomplete_results)
        userInfo = try values.decodeIfPresent([UserInfo].self, forKey: .userInfo)
    }

}

struct UserInfo : Codable {
    let login : String?
    let id : Int?
    private var avatar_url : String = ""
    var formatedImageURL:URL?  {
        return URL(string: avatar_url)
    }
    let type : String?
    let site_admin : Bool?
    let score : Double?

    enum CodingKeys: String, CodingKey {

        case login = "login"
        case id = "id"
        case avatar_url = "avatar_url"
        case type = "type"
        case site_admin = "site_admin"
        case score = "score"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        login = try values.decodeIfPresent(String.self, forKey: .login)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        avatar_url = try (values.decodeIfPresent(String.self, forKey: .avatar_url) ?? "")
        type = try values.decodeIfPresent(String.self, forKey: .type)
        site_admin = try values.decodeIfPresent(Bool.self, forKey: .site_admin)
        score = try values.decodeIfPresent(Double.self, forKey: .score)
    }

}
