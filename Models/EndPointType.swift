//
//  EndPointType.swift
//  SwiftAPIClient
//
//  Created by Dylan Ah Teck on 10/14/20.
//

import Foundation

import Alamofire

protocol EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }
    
}
