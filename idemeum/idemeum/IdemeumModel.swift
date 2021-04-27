//
//  IdemeumModel.swift
//  idemeum
//
//  Created by Atul Parmar on 12/04/21.
//

import Foundation

public class IdemeumSigninResponse: NSObject {
    
    public var status:Bool = false
    public var token:OIDCToken = OIDCToken()
    public var message:String = ""
}

public class OIDCToken:NSObject {
    
    public var accessToken: String = ""
    public var idToken: String = ""
    public var expires_in:Double = 0
    
    var dictionary: [String: Any] {
        return ["accessToken": accessToken,
                "idToken": idToken,
                "expires_in": expires_in]
    }
    
}

enum ErrorMsg: String {
    case OPERATION_CANCELLED = "Operation cancelled!!"
    case TOKEN_ERROR = "Token not received from backend!!"
    case UNKNOWN_ERROR = "Unknown error!!"
    case USERLOGOUT = "User is logout or token not available"
    
    var errorCode: Int {
        switch self {
        case .OPERATION_CANCELLED: return 11
        case .TOKEN_ERROR: return 12
        case .UNKNOWN_ERROR : return 13
        case .USERLOGOUT : return 14
        }
    }
}

public struct Error {
    public var errorMessage:String = ""
    public var statuscode:Int = 0
   
    init(msg:String, code:Int) {
        errorMessage = msg
        statuscode = code
    }
    
    init(errorMsg:ErrorMsg) {
        errorMessage = errorMsg.rawValue
        statuscode = errorMsg.errorCode
    }
   
}
