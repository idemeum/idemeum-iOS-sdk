//
//  WebServiceBuilder.swift
//  idemeumSDK
//
//  Created by Atul Parmar on 03/03/21.
//

import UIKit

class WebServiceBuilder: NSObject {

    static let shared = WebServiceBuilder()
    
    func postCall(serviceURL: String, parameters: [String:Any]?, headers: [String:String], completionHandler: @escaping (_ success:Bool, _ data: Data?) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            //No internet
            completionHandler(false,nil)
        } else {
            var request : URLRequest = URLRequest(url: URL(string: serviceURL)!)
            request.httpMethod = "POST"
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [:], options: []) else {
                return
            }
            request.httpBody = httpBody
            //request.httpBody = Data()//Parameters here
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if let unwrappedError = error {
                    print("error=\(unwrappedError)")
                }else {
                    if let unwrappedData = data {
                        completionHandler(true, unwrappedData)
                        return
                    }
                }
                completionHandler(false,nil)
            }
            task.resume()
        }
    }
    
    func getCall(serviceURL: String, headers: [String:String], completionHandler: @escaping (_ success:Bool, _ data: Data?) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            //No internet
            completionHandler(false,nil)
        } else {
            var request : URLRequest = URLRequest(url: URL(string: serviceURL)!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if let unwrappedError = error {
                    print("error=\(unwrappedError)")
                }else {
                    if let unwrappedData = data {
                        completionHandler(true, unwrappedData)
                        return
                    }
                }
                completionHandler(false,nil)
            }
            task.resume()
        }
    }
}
