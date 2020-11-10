//
//  EndpointItem.swift
//  SwiftAPIClient
//
//  Created by Dylan Ah Teck on 10/14/20.
//

import Alamofire
import Foundation

enum EndpointItem {
    
    // MARK: User actions
    
    case profile
    case updateUser
    case userExists(_: String)
    
}

// MARK: - Extensions
// MARK: - EndPointType
extension EndpointItem: EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String {
        switch TestProjectApi.networkEnviroment {
            case ".dev": return "https://api.test.com/dev/"
            case ".production": return "https://api.test.com/prod/"
            case ".stage": return "https://api.test.com/staging/"
            default: return ""
        }
    }
    
    var version: String {
        return "/v0_1"
    }
    
    var path: String {
        switch self {
            
        case .profile:
            return "user/profile"
        case .updateUser:
            return "user/update"
        case .userExists(let email):
            return "/user/check/\(email)"
        }
    }
      
    var httpMethod: HTTPMethod {
        switch self {
        case .updateUser:
            return .post
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
    case .profile, .updateUser:
            return ["Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest",
                    "x-access-token": "someToken"]
        default:
            return ["Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"]
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
}
