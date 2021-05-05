//
//  Idemeum.swift
//  idemeum
//
//  Created by Atul Parmar on 12/04/21.
//

import UIKit
import AuthenticationServices
import Foundation


public class Idemeum: NSObject {
    
    public init(parentView: UIViewController, clientId:String) {
        self.anchorView = parentView
        self.clientID = clientId
        
        if !defaults.isKeyCreated {
            defaults.password = UUID().uuidString
        }
    }
    
    var clientID:String = ""
    var anchorView: UIViewController?
    let defaults = SecureDefaults()
    let OIDC_Token = "OIDC_Token"
    let webserviceURL:String = "https://ciam.idemeum.com/api/consumer"
    
    //MARK:- Login method.
    public func login(completionHandler: @escaping (_ isSuccess:Bool, _ mIdemeumResponse: OIDCToken?, _ error:Error?) -> Void) {
        
        if !Reachability.isConnectedToNetwork() {
            //No internet
            completionHandler(false,nil,Error(errorMsg: ErrorMsg.NO_INTERNET))
            return
        }
        
        guard let authURL = URL(string: "\(webserviceURL)/authorize?clientId=\(clientID)") else {
            completionHandler(false,nil,Error(errorMsg: ErrorMsg.UNKNOWN_ERROR))
            return
        }
        
        let scheme = "idemeum"
        
        // Initialize the session.
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { callbackURL, error in
            
            // Handle the callback.
            guard error == nil, let callbackURL = callbackURL else {
                completionHandler(false,nil,Error(errorMsg: ErrorMsg.OPERATION_CANCELLED))
                return
            }
            
            // The callback URL format depends on the provider. For this example:
            //   exampleauth://auth?token=1234
            let resultQueryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            
            guard let response = resultQueryItems?.filter({ $0.name == "response" }).first?.value else {
                completionHandler(false,nil,Error(errorMsg: ErrorMsg.UNKNOWN_ERROR))
                return
            }
            
            let base64Encoded = response
            let decodedData = Data(base64Encoded: base64Encoded)!
            let decodedString = String(data: decodedData, encoding: .utf8)!
            
            if let resultDic = self.convertStringToDictionary(text: decodedString) {
                
                if let status = resultDic["status"] as? Bool {
                    if status {
                        if let oidcValue = resultDic["oidc"] as? [String:Any] {
                            
                            let objOIDC = OIDCToken()
                            objOIDC.accessToken = oidcValue["accessToken"] as? String ?? ""
                            objOIDC.idToken = oidcValue["idToken"] as? String ?? ""
                            objOIDC.expires_in = oidcValue["expires_in"] as? Double ?? 0
                            
                            self.saveOIDCToUserdefaults(objOIDC.dictionary)
                            
                            completionHandler(true,objOIDC,nil)
                            return
                        }
                        completionHandler(false,nil,Error(errorMsg: ErrorMsg.TOKEN_ERROR))
                        return
                    }
                }
                if let errorMsg = resultDic["message"] as? String , let statusCode = resultDic["statusCode"] as? Int {
                    completionHandler(false,nil, Error(msg: errorMsg, code: statusCode))
                    return
                }
            }
            completionHandler(false,nil,Error(errorMsg: ErrorMsg.UNKNOWN_ERROR))
        }
        
        session.presentationContextProvider = self
        session.start()
    }
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    //MARK:- Token Validation
    public func userClaims(completionHandler: @escaping (_ isSuccess:Bool, _ mClaims: Any?, _ error:Error?) -> Void) {
        
        if !Reachability.isConnectedToNetwork() {
            //No internet
            completionHandler(false,nil,Error(errorMsg: ErrorMsg.NO_INTERNET))
            return
        }
        
        guard let oidcValue = self.getOIDCValueFromUserdefaults() else {
            completionHandler(false,nil, Error(errorMsg: ErrorMsg.USERLOGOUT))
            return
        }
        
        WebServiceBuilder.shared.postCall(serviceURL: "\(webserviceURL)/token/validation", parameters: oidcValue, headers: [:]) { (success, resultData) in
            if success , let unwrappedData = resultData {
                let jsonString = String(decoding: unwrappedData, as: UTF8.self)
                completionHandler(true,jsonString, nil)
                return
            }
            completionHandler(false,nil, Error(errorMsg: ErrorMsg.UNKNOWN_ERROR))            
        }
    }
    
    //MARK:- IS Logged In user
    public func isLoggedIn(completionHandler: @escaping (_ isSuccess:Bool) -> Void) {
       
        guard let oidcValue = self.getOIDCValueFromUserdefaults() else {
            completionHandler(false)
            return
        }
        
        WebServiceBuilder.shared.postCall(serviceURL: "\(webserviceURL)/token/validation/accessToken", parameters: oidcValue, headers: [:]) { (success, resultData) in
            if success, let _ = resultData  {
                completionHandler(true)
            }else{
                completionHandler(false)
            }
        }
    }
    
    //MARK:- Logout user.
    public func logout(){
        defaults.removeObject(forKey: OIDC_Token)
        defaults.synchronize()
    }
    
    
    func  saveOIDCToUserdefaults(_ oidcDic:[String:Any]) {
        defaults.setValue(oidcDic, forKey: OIDC_Token)
        defaults.synchronize()
    }
    
    func getOIDCValueFromUserdefaults()-> [String:Any]? {
        if let oidcValue = defaults.value(forKey: OIDC_Token) as? [String:Any] {
            return oidcValue
        }
        return nil
    }
}

extension Idemeum: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.anchorView?.view.window ?? ASPresentationAnchor()
    }
}
