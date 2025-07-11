//
//  AlertManager.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation
import UIKit

enum AlertButtonType:String {
    case photos = "PHOTOS"
    case camera = "CAMERA"
    case yes = "YES"
    case no = "NO"
    case cancel = "Cancel"
  case settings = "Settings"
    case okay = "OK"
  case sure = "Sure"
  case later = "Later"
}

class AlertManager: NSObject {
 
    static func alert(message: String, alertButtonTypes: [AlertButtonType]? = [.okay],   alertStyle: UIAlertController.Style? = nil, completion: ((AlertButtonType) -> () )? = nil ) {
        
        let style:UIAlertController.Style = alertStyle ?? .alert
      let alertController = UIAlertController.init(title: "MVVM", message: message, preferredStyle:style)
        
        for actionTitle in alertButtonTypes!{
            alertController.addAction(UIAlertAction(title: actionTitle.rawValue, style: .default, handler:    {(alert :UIAlertAction!) in
                completion?(AlertButtonType(rawValue:alert.title!)!)
            }))
        }
        DispatchQueue.main.async {
          
          let window = UIApplication.shared.windows.first
          
          window?.rootViewController?.present(alertController, animated: true, completion: {
            
          })
           
        }
    }
}

struct Messages {
  static let loginWithFacebook = "Please login with Facebook"
  static let pleaseEnablePushNotification = "You don't enable push notifications. Click on Settings to enable the push notifications."
}

