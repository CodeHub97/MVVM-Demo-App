//
//  FeedViewModel.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation

class FeedViewModel: FeedViewProtocol {
    weak var feedView: FeedView?
    var feedModel: FeedModel?
  var onFeedUpated: (([FeedEntity]) -> Void)?
  var arrUsersList: [FeedEntity] = [] {
    didSet {
      self.onFeedUpated?(self.arrUsersList)
    }
  }
    
    static func initilize() -> FeedView {
        let feedView = FeedView.instantiate(fromStoryboard: .Main)
        
        let feedViewModel = FeedViewModel()
        let feedModel = FeedModel()
        feedView.feedViewModel = feedViewModel
        feedViewModel.feedView = feedView
        feedViewModel.feedModel = feedModel
        
        return feedView
    }
    
    func loadFeedData() {
        print(feedModel)
        self.feedModel?.getFeedList(parameters: ["":""], completion: { (result) in
          switch result {
              case .success(let list):
           
            self.arrUsersList = list
              case .failure(let error):
                  print(error.localizedDescription)
              }
        })
    }
}


