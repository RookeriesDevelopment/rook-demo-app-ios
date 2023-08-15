//
//  NetworkManager.swift
//  RookMotionFrancisco
//
//  Created by Francisco Guerrero Escamilla on 08/03/21.
//

import Foundation
import Combine

final class Router<EndPoint: EndPointType>: NetworkRouter {
  
  // MARK:  Properties
  
  private var task: URLSessionTask?
  
  private let urlSession: URLSession
  
  // MARK:  Init
  
  init(urlSessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default) {
    self.urlSession = URLSession(configuration: urlSessionConfiguration)
  }
  
  // MARK:  Helpers
  
  func request(_ route: EndPoint,
               completion: @escaping NetworkRouterCompletion) {
    let session = URLSession.shared
    do {
      let request = try self.buildRequest(from: route)
      task = session.dataTask(with: request,
                              completionHandler: { (data, response, error) in
        completion(data, response, error)
      })
    } catch {
      completion(nil, nil, error)
    }
    task?.resume()
  }
  
  func request(_ route: EndPoint) -> AnyPublisher<Response, Error> {
    do {
      let request = try self.buildRequest(from: route)
      
      let cancelable: AnyPublisher<Response, Error>
      cancelable = urlSession.dataTaskPublisher(for: request)
        .tryMap { result -> Response in
          
          return Response(data: result.data,
                          response: result.response)
          
        }.mapError({ error in
          return error
        }).receive(on: DispatchQueue.main).eraseToAnyPublisher()
      
      return cancelable
    } catch {
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
  
  
  
  private func buildRequest(from route: EndPoint) throws -> URLRequest {
    
    guard let baseURL = route.baseUrl else {
      throw NSError(domain: "url base error",
                    code: 404,
                    userInfo: nil)
    }
    
    var request = URLRequest(
      url: baseURL.appendingPathComponent(route.path),
      cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
      timeoutInterval: 10.0)
    
    request.httpMethod = route.httpMethod.rawValue
    do {
      switch route.task {
      case .request:
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      case .requestParameters(let bodyParameters, let urlParamaters):
        try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParamaters, request: &request)
      case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
        self.additionalHeaders(additionalHeaders, request: &request)
        try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
      }
      return request
    } catch {
      throw error
    }
  }
  
  private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
    do {
      if let bodyParameters = bodyParameters {
        try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
      }
      if let urlParameters = urlParameters {
        try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
      }
    } catch {
      throw error
    }
  }
  
  private func additionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
    guard let headers = additionalHeaders else { return }
    for (key, value) in headers {
      request.setValue(value, forHTTPHeaderField: key)
    }
  }
}
