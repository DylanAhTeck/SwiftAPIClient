//
//  DomainObject.swift
//  SwiftAPIClient
//
//  Created by Dylan Ah Teck on 10/23/20.
//

import Foundation

public protocol DomainObject : Codable {
    mutating func setId(id: String) -> ()
    func getId() -> String?
}

extension DomainObject {
    func isIdPresent() -> Bool {
        guard let id = getId() else { return false }
        
        return !id.isEmpty
    }
}
