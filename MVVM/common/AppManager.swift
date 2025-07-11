//
//  AppManger.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation

class AppManager {
  static let shared = AppManager()
  //MARK: Generate Json From Data
    func makeJSON(from data: Data, completion: @escaping(_ jsonDictonary: Any) -> Void) {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
      completion(json)
    }catch let error {
      debugPrint(error)
    }
  }
  
    func decode<T: Codable>(modelType: T.Type, data: Data, completion: @escaping(_ model: T) -> Void) {
    do {
      let model = try JSONDecoder().decode(modelType, from: data)
      completion(model)
    }catch let error{
      
      AlertManager.alert(message: error.localizedDescription)
    }
    
  }
}
