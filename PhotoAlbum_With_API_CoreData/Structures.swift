//
//  Structures.swift
//  PhotoAlbum_With_API_CoreData
//
//  Created by Mandar Choudhary on 14/06/24.
//

import Foundation

struct Photos: Decodable {
    var albumId: Int
    var id: Int
    var title: String
    var url: String
    var thumbnailUrl: String
}

struct Albums: Decodable {
    var userId: Int
    var id: Int
    var title: String
}

struct Comments: Decodable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}

struct User: Decodable {
    var id: Int
    var name: String
    var username: String
    var email: String
    var phone: String
    var website: String
    var address: Address
    var company: Company
}

struct Address: Decodable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo
}

struct Geo: Decodable {
    var lat: String
    var lng: String
}

struct Company: Decodable {
    var name: String
    var catchPhrase: String
    var bs: String
}
