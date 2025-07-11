//
//  FeedProtocols.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation


protocol FeedModelProtocol {
  func getFeedList(page: Int, parameters: [String: Any], completion: @escaping(Result<[FeedEntity], FailureModel>) -> Void)
}

protocol FeedViewProtocol {
  static func initilize() -> FeedView
  
}

