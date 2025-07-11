//  WebRequest.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.


import Foundation
import UIKit

enum ImageQualityModes: CGFloat {
  case lowest = 0.1
  case low = 0.3
  case medium = 0.5
  case good = 0.8
  case high = 1.0
}

class WebRequest {
  
  static let shared = WebRequest()
  private var urlRequest: URLRequest?
  
  func cancelRequest() {
    WebNetwork.shared.cancelPreviousRequest()
  }
  
  private func appendHeaders(headerTypes:[APIHeaders]?, request: inout URLRequest) {
    if headerTypes != nil {
      for header in headerTypes!{
        switch header {
        case .accept:
          
          request.setValue(WebConstants.APPLICATION_JSON, forHTTPHeaderField: WebConstants.ACCEPT)
          break
        case .contentType:
          
          break
        case .authorization:
          //TODO: - - Enter token here if required
          //                if let token = AppDataManager.shared.accessToken {
          //                  request.addValue(token, forHTTPHeaderField: WebConstants.ACCESS_TOKEN)
          //                }
          
          break
        case .apiKey:
          
          break
        }
      }
    }
  }
}
//MARK:- Get Request service
extension WebRequest {
  func getRequestWith(requestAPI: WebAPI,
                      parametersString param: String = "",
                      hearders: [APIHeaders],
                      success: @escaping(_ succes: Data, _ responseCode: Int) ->(),
                      failure: @escaping(_ failure: FailureModel) ->()) {
    
    urlRequest = self.makeGetUrlRequest(requestApi: requestAPI.rawValue,
                                        parametersString: param,
                                        hearders: hearders)
    
    guard let request = urlRequest else {
      failure(FailureModel(code: 0, message: ""))
      return
    }
    
    WebNetwork.shared.callRequest(urlRequest:request, result: { (code, data) in
      success(data, code)
    }) { (errorCode, message) in
      failure(FailureModel(code: errorCode, message: message))
    }
    urlRequest = nil
  }
  
  private func makeGetUrlRequest(requestApi: String,
                                 parametersString: String,
                                 hearders: [APIHeaders]) -> URLRequest? {
    
    let urlString = WebConstants.BASE_URL + requestApi + ((parametersString.isEmpty) ? "" : parametersString)
    var url: URL? = URL(string: urlString)
    guard let urlLink = url else {return nil}
    
    var request = URLRequest(url: urlLink)
    
    self.appendHeaders(headerTypes: hearders, request: &request)
    
    request.httpMethod = "GET"
    url =  nil
    return request
  }
  
  
  
}

//MARK:- Post Request

extension WebRequest {
  
  func postRequestWith(requestAPI: WebAPI,
                       requestType: RequestType = .POST,
                       queryType: QueryType = .queryParameters,
                       queryString: String = "" ,
                       parameters: [String: Any],
                       hearders: [APIHeaders],
                       success: @escaping(_ successData: Data, _ responseCode: Int) ->(),
                       failure: @escaping(_ failure: FailureModel) ->()) {
    
    urlRequest = makePostUrlRequest(requestAPI: requestAPI.rawValue,
                                    requetType: requestType,
                                    queryType: queryType,
                                    query: queryString,
                                    parameters: parameters, hearders: hearders)
    
    debugPrint("urlRequest", urlRequest)
    
    WebNetwork.shared.callRequest(urlRequest: urlRequest!, result: { (code, data) in
      success(data, code)
    }) { (errorCode, message) in
      failure(FailureModel(code: errorCode, message: message))
    }
    urlRequest = nil
  }
  
  private func queryMaker(type: QueryType, query: String) -> String  {
    return (query.count > 0 ? (type == .queryString ? "?\(query)" : "/\(query)") : "")
    
  }
  
  private func makePostUrlRequest(requestAPI: String,
                                  requetType: RequestType,
                                  queryType: QueryType,
                                  query: String,
                                  parameters: [String: Any],
                                  hearders: [APIHeaders]
  ) -> URLRequest {
    
    var url:URL? = URL(string: WebConstants.BASE_URL + requestAPI + self.queryMaker(type: queryType, query: query))
    var request =  URLRequest(url:url!)
    
    self.appendHeaders(headerTypes: hearders, request: &request)
    
    request.httpMethod = requetType.rawValue
    
    let parameterString = makeKeyValueParameters(parameter: parameters)
    
    if let data = parameterString.data(using: .utf8) {
      request.httpBody = data
    }
    
    url =  nil
    return request
  }
  
  private func makeKeyValueParameters(parameter : [String: Any]) -> String  {
    let param = (parameter.flatMap({ (key, value) -> String in
      
      
      if let arr = value as? Array<Any> {
        
        if  let jsonString = convertIntoJSONString(arrayObject: arr) {
          
          //          let afterRemoveFirst = jsonString.dropFirst()
          //          let afterRemoveLast = afterRemoveFirst.dropLast()
          // debugPrint(afterRemoveLast)
          
          return "\(key)=\(jsonString)"
        }
        
        return ""
      }else {
        return "\(key)=\(value)"
      }
    }) as Array).joined(separator: "&")
    return  param
  }
  
  private func convertIntoJSONString(arrayObject: [Any]) -> String? {
    
    do {
      let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
      if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
        return jsonString as String
      }
      
    } catch let error as NSError {
      print("Array convertIntoJSON - \(error.description)")
    }
    return nil
  }
}



extension WebRequest {
  private var utf8Encoding: String.Encoding {
    return String.Encoding.utf8
  }
  
  func uploadImages(requestAPI: WebAPI,
                    parameters: [String:Any],
                    arrImage: [[String: UIImage]],
                    accessToken: String?,
                    imageQuality: ImageQualityModes,
                    success: @escaping(_ succes: Data, _ responseCode: Int) ->(),
                    failure: @escaping(_ errorCode: Int, _ errorMessage: String) ->()) {
    
    urlRequest = makeRequestForImages(requestAPI: requestAPI.rawValue, parameters: parameters, arrImages: arrImage, accessToken: accessToken, imageQuality: imageQuality) as URLRequest
    
    WebNetwork.shared.callRequest(urlRequest: urlRequest!, result: { (code, data) in
      success(data, code)
    }) { (errorCode, message) in
      failure(errorCode, message)
    }
    urlRequest = nil
  }
  
  private func makeRequestForImages(requestAPI: String,
                                    parameters: [String: Any],
                                    arrImages: [[String: UIImage]],
                                    accessToken: String?,
                                    imageQuality: ImageQualityModes) ->NSMutableURLRequest {
    
    let url: URL? = URL(string:WebConstants.BASE_URL + requestAPI)
    let request = NSMutableURLRequest(url:url!);
    request.httpMethod = "POST"
    let boundary = generateBoundaryString()
    
    if accessToken != nil {
      request.addValue(accessToken!, forHTTPHeaderField: WebConstants.AUTHORIZATION)
    }
    request.setValue(WebConstants.APPLICATION_FORM_URLENCODED, forHTTPHeaderField:  WebConstants.CONTENT_TYPE)
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: WebConstants.CONTENT_TYPE)
    request.timeoutInterval = 300
    request.httpBody = createBodyWithParameters(parameters: parameters, arrImages: arrImages, boundary: boundary, imageQuality: imageQuality) as Data
    return request
  }
  
  
  private func createBodyWithParameters(parameters: [String: Any]?,
                                        arrImages: [[String: UIImage]],
                                        boundary: String,
                                        imageQuality: ImageQualityModes) -> NSMutableData {
    let body = NSMutableData()
    
    if parameters != nil {
      for (key, value) in parameters! {
        body.append("--\(boundary)\r\n".data(using: utf8Encoding)!)
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: utf8Encoding)!)
        body.append("\(value)\r\n".data(using: utf8Encoding)!)
      }
    }
    
    let mimetype = "image/jpg"
    
    for (_, value) in arrImages.enumerated() {
      
      let imageName = (value.first)?.key
      let image = value[imageName!]
      body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
      body.append("Content-Disposition: form-data; name=\"\(imageName!)\"; filename=\"\(".jpg")\"\r\n".data(using: utf8Encoding)!)
      body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: utf8Encoding)!)
      let imageData = image!.jpegData(compressionQuality: imageQuality.rawValue)
      body.append(imageData!)
      body.append("\r\n".data(using: utf8Encoding)!)
    }
    
    body.append("--\(boundary)--\r\n".data(using: utf8Encoding)!)
    
    return body
  }
  
  private func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
  }
}
//MARK: Upload Video
extension WebRequest {
  func uploadVideo(requestAPI: WebAPI,
                   _ videoData: Data,
                   accessToken: String?,
                   success: @escaping(_ succes: Data, _ responseCode: Int) ->(),
                   failure: @escaping(_ errorCode: Int, _ errorMessage: String) ->()) {
    
    urlRequest = makeRequestForVideo(videoData: videoData, requestAPI: requestAPI.rawValue, accessToken: accessToken) as URLRequest
    
    guard let request = urlRequest else {return}
    WebNetwork.shared.callUploadDataRequest(urlRequest: request, data: videoData, result: { (responseCode, data) in
      success(data, responseCode)
    }) { (errorCode, errorMessage) in
      failure(errorCode, errorMessage)
    }
    
    //    WebNetwork.shared.callRequest(urlRequest: urlRequest!, result: { (code, data) in
    //      success(data, code)
    //    }) { (errorCode, message) in
    //      failure(errorCode, message)
    //    }
    urlRequest = nil
  }
  
  private func makeRequestForVideo(videoData: Data, requestAPI: String, accessToken: String?) -> NSMutableURLRequest {
    
    let url: URL? = URL(string:WebConstants.BASE_URL + requestAPI)
    
    let request = NSMutableURLRequest(url: url!)
    let boundary = generateBoundaryString()
    
    request.httpMethod = "POST"
    
    if accessToken != nil {
      request.addValue(accessToken!, forHTTPHeaderField: WebConstants.AUTHORIZATION)
    }
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.setValue("keep-alive", forHTTPHeaderField: "Connection")
    
    var body = Data()
    
    let filename = "avatar"
    let mimetype = ""
    
    body.append("--\(boundary)\r\n".data(using: utf8Encoding)!)
    body.append("Content-Disposition: form-data; name=\"\(filename)\"; filename=\"\(".mov")\"\r\n".data(using: utf8Encoding)!)
    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: utf8Encoding)!)
    body.append(videoData)
    body.append("\r\n".data(using: utf8Encoding)!)
    body.append("--\(boundary)--\r\n".data(using: utf8Encoding)!)
    
    request.httpBody = body
    return request
  }
}


