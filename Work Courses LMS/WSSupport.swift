//
//  WSSupport.swift
//  Work Courses LMS
//
//  Created by Arpit on 10/2/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import Foundation

// MARK: - Helper functions for creating encoders and decoders
func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

//MARK:- Managers
class WDManager {
    static let key = ""
    static let secret  = ""
    struct Path {
        static let base = "https://onlineinduction.com"
        static let auth = "\(base)/iphone"
        static let course  = "\(base)/learningcourses/contentbuilder"
    }
    
    //..
    enum EndPoints {
        case login
        case register
        case myCourses
        case courseSlides
        case courseContent
        
        var stringValue : String {
            switch self {
            case .login: return "\(Path.auth)/loginlms.php"

                /**
                for a new user registration, the link the form will post to is:
                https://www.onlineinduction.com/iphone/regprocesslms.php
                 Request:
                     firstname : Mr A
                     lastname : 001
                     phone : 9876543210
                     email : mra001@gmail.com
                     company : A001-Company
                     password : aaaaaa
                     
                 Response:
                     { "status": "success", "data": null, "message": "successfully registered" }
                */
            case .register: return "\(Path.auth)/regprocesslms.php"
                
                /**
                 shows list of courses to show, with logged in username being passed
                 */
            case .myCourses: return "\(Path.course)/contentshowlms.php"
                
                /**
                 shows list of slidenumbers to show for selected course, passing selected course name in URL
                 */
            case .courseSlides: return "\(Path.course)/slidenumbers.php"
                
                /**
                 the numbers aren't always in sequential order (might skip a number for example if someone deleted a slide on our end) it'll give you the starting ID and then the next ID to go to when clicking Next to move slides and the last ID to finish on.
                 */
            case .courseContent: return "\(Path.course)/showcontentslidelms.php"
            }
        }
        
        //..
        func url (query : String? = nil) -> URL {
            let path = URL(string: stringValue)!
            if let q = query {
                var component = URLComponents(url: path, resolvingAgainstBaseURL: true)!
                component.query = q
                return component.url!
            }
            return path
        }
    }
    
    public class func validate (statusCode:Int?, message:String?) -> String? {
        switch message {
        case "Token Expired.":
            return message
        default: break
        }
        return nil
    }
    
    public class func urlRequest(with path:URL, params:Dictionary<String, Any>, method:String, contentType:String = "application/json") -> URLRequest {
        print("request with", path.absoluteString, params, method, contentType)
        var request = URLRequest(url: path)
        request.httpMethod = method
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        if let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) {
            request.httpBody = httpBody
        }
        return request
    }
}

extension URLSession {
    func codableTask<T: Codable>(withRequest request: URLRequest, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }

            //print server response
            #if DEBUG
            if let returnData = String(data: data, encoding: .utf8) {
                print("Response = ", returnData)
            }
            #endif

            do {
                completionHandler(try newJSONDecoder().decode(T.self, from: data), response, nil)
            } catch {
                print("Unexpected error: \(error).")
                do {
                    var serverError : NSError? = nil
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                        #if DEBUG
                        print("jsonObject = ", jsonObject) // use the json here
                        #endif

                       let urlResponse = (response as? HTTPURLResponse) ?? nil
                       serverError = NSError(domain:"", code:urlResponse?.statusCode ?? 200, userInfo:jsonObject)
                    } else {
                        print("bad json")
                    }
                    completionHandler(nil, response, serverError)
                } catch {
                    let str = String(decoding: data, as: UTF8.self)
                    completionHandler(str as? T, response, nil)
                }
            }
        }
    }
    
    func codableTask<T: Codable>(withUrl url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            //print server response
            #if DEBUG
            if let returnData = String(data: data, encoding: .utf8) {
                print("Response = ", returnData)
            }
            #endif

            //completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
            do {
                completionHandler(try newJSONDecoder().decode(T.self, from: data), response, nil)
            } catch {
                print("Unexpected error: \(error).")
                do {
                    var serverError : NSError? = nil
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any] {
                        #if DEBUG
                        print("jsonObject = ", jsonObject) // use the json here
                        #endif
                       let urlResponse = (response as? HTTPURLResponse) ?? nil
                       serverError = NSError(domain:"", code:urlResponse?.statusCode ?? 200, userInfo:jsonObject)
                    } else {
                        print("bad json")
                    }
                    completionHandler(nil, response, serverError)
                } catch {
                    let str = String(decoding: data, as: UTF8.self)
                    completionHandler(str as? T, response, nil)
                }
            }
        }
    }
}

//MARK:- Raw result that only returns text messsage in response
typealias JSONDictionary = [String: Any]
class WSSupport {
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    typealias Result = (URL?, JSONDictionary?, String?) -> Void
    typealias RawResult = (URLResponse?, Data?, String?) -> Void
    
    private func updateResult(_ data: Data) -> JSONDictionary? {
        var response: JSONDictionary?
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            return response
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return nil
        }
    }
    
    
    func get(request : URLRequest, completion : @escaping RawResult) {
        dataTask = defaultSession.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let e = error {
                self?.errorMessage += "DataTask error: " + e.localizedDescription + "\n"
                #if DEBUG
                print("errorMessage = ", self?.errorMessage ?? "", "request = ", response ?? "")
                #endif

                DispatchQueue.main.async {
                    completion(response, nil, self?.errorMessage ?? "")
                }
            }else if let d = data, let r = response as? HTTPURLResponse, r.statusCode == 200 {
                DispatchQueue.main.async {
                    completion(response, d, self?.errorMessage ?? "")
                }
            }else {
                DispatchQueue.main.async {
                    completion(response, nil, "Error: Something went wrong please try again later!")
                }
            }
        })
        dataTask?.resume()
    }
}


// MARK: - StanderdResponse Manager
public struct StanderdResponse: Codable {
    public var status: String?
    public var data: String?
    public var message: String?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case message = "message"
    }

    public init(status: String?, data: String?, message: String?) {
        self.status = status
        self.data = data
        self.message = message
    }
}

// MARK: - URLSession StanderdResponse handlers
extension URLSession {
    func standerdResponseTask(with request: URLRequest, completionHandler: @escaping (StanderdResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(withRequest: request, completionHandler: completionHandler)
    }
    
    func standerdResponseTask(with url: URL, completionHandler: @escaping (StanderdResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(withUrl: url, completionHandler: completionHandler)
    }
}

//MARK: String Response
typealias StringResponse = String
extension URLSession {
    func stringResponeTask(with request: URLRequest, completionHandler: @escaping (StringResponse?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(withRequest: request, completionHandler: completionHandler)
    }
}
