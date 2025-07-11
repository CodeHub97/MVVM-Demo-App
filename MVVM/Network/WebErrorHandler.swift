//
//  WebErrorHandler.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation

class WebErrorHandler {
  
  static func findError(data: Data) -> String {
    
    do {
      if let errorJson = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
        debugPrint("error", errorJson)
        if let errors = errorJson[WebConstants.ERRORS] as? [String: Any] {
          if let firstError = (errors.first?.value as? [String])?.first {
            return firstError
          }else {
            return lastError(json: errorJson)
          }
        }else {
          return lastError(json: errorJson)
        }
      }
      
    }catch let error {
      debugPrint(error)
      return error.localizedDescription
    }
    return ""
  }
  
  static private func lastError(json: [String: Any]) -> String {
    
    let arrKeys = json.keys
    let msgKey: String = "message"
    
    let filteredStrings = arrKeys.filter({(item: String) -> Bool in
      
      let stringMatch = item.lowercased().range(of: msgKey.lowercased())
      return stringMatch != nil ? true : false
    })
    if filteredStrings.count == 0 {
      return ""
    }
    
    if let msg = json[filteredStrings.first!] as? String {
      return msg
    }else {
      return ""
    }
    
  }
  
}

