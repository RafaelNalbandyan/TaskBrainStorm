//
//  BaseAPI.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import Alamofire

class BaseAPI<T: TargetType> {
    
    func fetchData<M: Decodable>(target: T, responseClass: M.Type, completion: @escaping (Result<M?,NSError>) -> Void) {
        let method = Alamofire.HTTPMethod(rawValue: target.methods.rawValue)
        let headers = Alamofire.HTTPHeaders(target.headers ?? [:])
        let params = buildParams(task: target.task)
        
        
        AF.request(target.baseURL + target.path,
                   method: method,
                   parameters: params.0,
                   encoding: params.1,
                   headers: headers).responseJSON { (response) in
            print("➡️➡️➡️➡️➡️➡️➡️ Request start ➡️➡️➡️➡️➡️➡️➡️")
            print("➡️ URL: \(String(describing: target.baseURL + target.path)))")
            print("➡️ METHOD: \(method))")
            print("➡️ HEADERS: \(headers)) ")
            print("➡️ PARAMS: \(params)) ")
            
            
            if let body = response.data,
               let str = String(data: body, encoding: .utf8) {
                    print("➡️ BODY: \(str))")
            } else {
                print("➡️ BODY: Empty")
            }
            print("➡️➡️➡️➡️➡️➡️➡️ Request end ➡️➡️➡️➡️➡️➡️➡️")
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(NSError(domain: response.error?.localizedDescription ?? "error",
                                            code: response.error?.responseCode ?? -1)))
                return
            }
            if statusCode == 200 {
                //successfull request
                guard let jsonResponse = try? response.result.get() else {
                    
                    completion(.failure(NSError(domain: response.error?.localizedDescription ?? "error",
                                                code: response.error?.responseCode ?? -1)))
                    return
                }
                
                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse,options: []) else {
                    
                    completion(.failure(NSError(domain: response.error?.localizedDescription ?? "error",
                                                code: response.error?.responseCode ?? -1)))
                    return
                }
                
                do {
                    let theJSONData = try JSONSerialization.data(withJSONObject: jsonResponse,
                                                                 options: [])
                } catch {
                    completion(.failure(error as NSError))
                }
                
                do {
                    let responseObj = try JSONDecoder().decode(M.self, from: theJSONData)
                    completion(.success(responseObj))
                } catch {
                    completion(.failure(error as NSError))
                }
            } else {
                // add custom error
                completion(.failure(NSError(domain: response.error?.localizedDescription ?? "error",
                                            code: response.error?.responseCode ?? -1)))
            }
            
        }
    }
    
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
    
}

public class Debouncer {

    private let timeInterval: TimeInterval
    private var timer: Timer?

    typealias Handler = () -> Void
    var handler: Handler?

    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }

    public func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                     repeats: false,
                                     block: { [weak self] (timer) in
            self?.timeIntervalDidFinish(for: timer)
        })
    }

    @objc private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else {
            return
        }

        handler?()
        handler = nil
    }

}
