//  WebConstants.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation

class WebConstants {
  
  static let BASE_URL = appEnvironment.type
  static let ACCEPT = "Accept"
  static let APPLICATION_JSON = "application/json"
  static let CONTENT_TYPE = "Content-Type"
  static let APPLICATION_FORM_URLENCODED = "application/x-www-form-urlencoded"
  static let AUTHORIZATION = "Authorization"
  static let ACCESS_TOKEN = "access-token"
 
  static let SUCCESS_RESPONSE = 200
  static let ERROR = 400
  static let SERVER_ERROR = 500
  static let USER_NOT_FOUND = 405
  static let BAD_REQUEST = 400
  static let SESSION_EXPIRED = 401
  static let PAGE_NOT_FOUND = 404
  static let SERVER_NOT_ACCEPETING = 406
  static let SERVER_VALIDATION_ERROR = 422
  static let REQUEST_TIME_OUT = -1001
  static let CANCEL_REQUEST =  -999
 
  static let DEVICE_TYPE = "iOS"
  static let ERRORS = "errors"
 
}

enum QueryType: String {
  case queryString
  case queryParameters
}

enum RequestType: String {
  case GET  = "GET"
  case POST = "POST"
  case PUT   = "PUT"
  case DELETE = "DELETE"
}

enum APIHeaders{

    case accept
    case contentType
    case authorization
    case apiKey
}



