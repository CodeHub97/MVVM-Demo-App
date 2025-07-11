//
//  Environment.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation
import UIKit

 enum Environment {
  case dev, qa, live
  
  var type: String {
    switch self {
    case .dev:
      return "https://jsonplaceholder.typicode.com"
    case .qa:
      
      return ""
    case .live:
      
      return ""
    }
  }
}

var appEnvironment: Environment = .dev
