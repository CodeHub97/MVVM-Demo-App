//
//  Storyboard.swift
//  Cyborg
//
//  Created by Gagan on 12/11/20.
//  Copyright © 2020 offsure. All rights reserved.
//

import Foundation
import UIKit
enum AppStoryboard: String {
  case Main
  var intance: UIStoryboard {
    return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
  }

  func viewController<T: UIViewController>(vc: T.Type) -> T {
    let storyboardId = (vc as UIViewController.Type).storyboadId

    return intance.instantiateViewController(withIdentifier: storyboardId) as! T
  }
}

let appStoryboard  = UIStoryboard(name: "Main", bundle: nil)


extension UIViewController {
  class var storyboadId: String {
    return "\(self)"
  }

  static func instantiate(fromStoryboard: AppStoryboard) -> Self {
    return fromStoryboard.viewController(vc: self)
  }

}
