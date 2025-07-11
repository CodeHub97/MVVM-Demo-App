//
//  FeedModel.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation

class FeedModel: FeedModelProtocol {
  
  func getFeedList(page: Int = 1, parameters: [String : Any], completion: @escaping(Result<[FeedEntity], FailureModel>) -> Void) {
    
    WebRequest.shared.getRequestWith(requestAPI: .feed,
                                     parametersString: "",
                                     hearders: [.accept]) { (data, responseCode) in
      AppManager.shared.makeJSON(from: data) { (json) in
        debugPrint(json)
      }
      
      AppManager.shared.decode(modelType: [FeedEntity].self, data: data) { (model) in
        completion(.success(model))
      }
    } failure: { (failure) in
      print(failure.localizedDescription)
      completion(.failure(failure))
    }
  }
}
