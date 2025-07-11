//
//  WebNetwork.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import Foundation

final class WebNetwork: NSObject {
  
  static let shared = WebNetwork()
  private var session: URLSession?
  private var task: URLSessionDataTask?
  
  var clouserProgress: ((_ progress: Double, _ percentage: Int) -> Void)?
  
  func cancelPreviousRequest() {
    task?.cancel()
    session?.invalidateAndCancel()
    
    
  }
  
  private var sessionConfiguration: URLSessionConfiguration {
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.timeoutIntervalForRequest = 7200.0
    sessionConfig.timeoutIntervalForResource = 7200.0
    sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
    sessionConfig.urlCache = nil
    sessionConfig.httpShouldUsePipelining = true
    
    return sessionConfig
  }
  
  func callUploadDataRequest(urlRequest: URLRequest,
                             data: Data?,
                             result: @escaping(_ responseCode: Int, _ data: Data) -> (),
                             failure: @escaping(_ errorCode: Int, _ errorMessage: String) -> ()) {
    
    let config = sessionConfiguration
    session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
    
    task = session?.uploadTask(with: urlRequest, from: nil, completionHandler: { (data, response, error) in
      self.handleResult(data: data, response: response, error: error, result: result, failure: failure)
    })
    
    task?.resume()
  }
  
  func callRequest(urlRequest: URLRequest,
                   result: @escaping(_ responseCode: Int, _ data: Data) -> (),
                   failure: @escaping(_ errorCode: Int, _ errorMessage: String) -> ()) {
    debugPrint("UrlRequest", urlRequest)
    let config = sessionConfiguration
    session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
    
    task = session!.dataTask(with: urlRequest) { (data, response, error) in
      
      self.handleResult(data: data, response: response, error: error, result: result, failure: failure)
    }
    task!.resume()
  }
  
  //MARK: Handle Response
  private func handleResult(data: Data?,
                            response: URLResponse?,
                            error: Error?,
                            result: @escaping(_ responseCode: Int, _ data: Data) -> (),
                            failure: @escaping(_ errorCode: Int, _ errorMessage: String) -> ()) {
    if error == nil && data != nil {
      
      debugPrint("Server ResponseCode =========== ", (response as! HTTPURLResponse).statusCode)
      
      let statusCode = (response as! HTTPURLResponse).statusCode
      
      switch statusCode {
      case WebConstants.SUCCESS_RESPONSE:
        result(WebConstants.SUCCESS_RESPONSE, data!)
        break
      case WebConstants.SERVER_ERROR, WebConstants.BAD_REQUEST, WebConstants.SESSION_EXPIRED, WebConstants.USER_NOT_FOUND, WebConstants.PAGE_NOT_FOUND, WebConstants.SERVER_VALIDATION_ERROR, WebConstants.CANCEL_REQUEST:
        failure(statusCode, WebErrorHandler.findError(data: data!))
        break
      default :
        failure(WebConstants.SERVER_ERROR, WebErrorHandler.findError(data: data!))
        break
      }
    }else {
      
      let error = error as NSError?
      
      switch error?.code {
      case WebConstants.REQUEST_TIME_OUT:
        if let msg = error?.localizedDescription {
          failure(WebConstants.REQUEST_TIME_OUT, msg)
        }
        break
      case WebConstants.CANCEL_REQUEST:
        if let msg = error?.localizedDescription {
          failure(WebConstants.CANCEL_REQUEST, msg)
        }
        break
      default :
        failure(error!.code, "There is some network issue. Please try again later")
        break
      }
      debugPrint("Network Error code:", error!.code)
    }
  }
  
  //MARK: Data Upload Progress
  func dataUploadProgress(completion: @escaping (_ progress: Double, _ percentage: Int) -> Void) {
    self.clouserProgress = completion
  }
  
}


 //MARK: Large file upload trial
extension WebNetwork {
//
//  private var utf8Encoding: String.Encoding {
//    return String.Encoding.utf8
//  }
//
//  ////POST https://storage.googleapis.com/upload/storage/v1/b/myBucket/o?uploadType=multipart
//
//  func callFileRequest(_ file: Data) {
//
//    let request = makeRequestForVideo(videoData: file)
//    let config = sessionConfiguration
//    session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
//
//    task = session?.dataTask(with: request) { (data, response, error) in
//
//      if error != nil {
//        debugPrint(response)
//      }else {
//        debugPrint("Error While uploading ==", error)
//      }
//    }
//    task!.resume()
//  }
//
//  private func makeRequestForVideo(videoData: Data) -> NSMutableURLRequest {
//
//    // let url: URL? = URL(string: "https://storage.googleapis.com/cyborg-v2.appspot.com/")
//
//    let url: URL? = URL(string: "https://storage.googleapis.com/cyborg-v2.appspot.com/uploadType=multipart")
//
//    let request = NSMutableURLRequest(url: url!)
//    //     let boundary = generateBoundaryString()
//
//    request.httpMethod = "POST"
//
//    // request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//    request.setValue("keep-alive", forHTTPHeaderField: "Connection")
//
//    var body = Data()
//
//    let filename = "avatar"
//    let mimetype = ""
//
//    // body.append("--\(boundary)\r\n".data(using: utf8Encoding)!)
//    body.append("Content-Disposition: form-data; name=\"\(filename)\"; filename=\"\(".mov")\"\r\n".data(using: utf8Encoding)!)
//    body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: utf8Encoding)!)
//    body.append(videoData)
//    body.append("\r\n".data(using: utf8Encoding)!)
//    // body.append("--\(boundary)--\r\n".data(using: utf8Encoding)!)
//
//    request.httpBody = body
//    return request
//  }
//
}

//MARK: Session Delegates
extension WebNetwork: URLSessionTaskDelegate {
  
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
    
  }
  private func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
    
    completionHandler(Foundation.URLSession.ResponseDisposition.allow)
  }
  
  func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    let progress: Double = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
    
    let percentage = Int(progress * 100)
    
    if let cProress =  self.clouserProgress {
      cProress(progress, percentage)
    }
  }
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    if error != nil {
      
    }else {
      
    }
  }
  
  func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
    if (error != nil) {
      
    }
  }
  
}
