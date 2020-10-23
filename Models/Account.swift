//
//  Account.swift
//  SwiftAPIClient
//
//  Created by Dylan Ah Teck on 10/7/20.
//

import Foundation

public struct Account: DomainObject {

    public mutating func setId(id: String) {
        self.id = id
    }
    
    public func getId() -> String? {
        return id
    }
    
  var id: String
  var name: String
  var otherId: Int?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case otherId
  }
    
    init(name: String, id: String = "", otherId: Int? = 0){
        self.name = name
        self.id = id
        self.otherId = otherId
    }
    /**
    * No-arg constructor for object-mapping libraries.
     */
//    init(){
//
//    }
    public func getClassName() -> String {
        return "Account"
    }
    
    public func toString() -> String {
        return "name: \(name), id: \(id)"
    }
//    func getName() -> String{
//        if let n = name{
//            return n;
//        }
//        else {
//            return ""
//        }
//    }
    
}

