//
//  WebServices.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation

typealias jsonDictonary = [String: Any]


class WebServices {
  
  //MARK: Generate Json From Data
  static private func makeJSON(from data: Data, completion: @escaping(_ jsonDictonary: jsonDictonary) -> Void) {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! jsonDictonary
       debugPrint("MAKE JSON===", json)
      
     // completion(json)
      
    }catch let error {
      debugPrint(error)
    }
  }
  
  static private func decode<T: Codable>(modelType: T.Type, data: Data, completion: @escaping(_ model: T) -> Void) {
    do {
      let model = try JSONDecoder().decode(modelType, from: data)
      completion(model)
    }catch let error{
      
      AlertManager.alert(message: error.localizedDescription)
    }
    
  }
  
  
  //MARK: Latest Track
  static func getLatestTrack(page: Int,
                             completion: @escaping(Result<[FeedEntity], FailureModel>) -> Void) {
    
   
  }
}
