//
//  TrackListModel.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation

struct FeedEntity: Codable {
    var id: Int?
    var userId: Int?
    var title: String?
    var body: String?
  
    enum Codingkeys: String, CodingKey {
      case id = "id"
      case userId = "userId"
      case title = "title"
      case body = "body"
    }
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: Codingkeys.self)
      id = try values.decodeIfPresent(Int.self, forKey: .id)
      userId = try values.decodeIfPresent(Int.self, forKey: .userId)
      title = try values.decodeIfPresent(String.self, forKey: .title)
      body = try values.decodeIfPresent(String.self, forKey: .body)
    }
}



