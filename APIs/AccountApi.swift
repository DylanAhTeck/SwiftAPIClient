//
//  AccountApi.swift
//  SwiftAPIClient
//
//  Created by Dylan Ah Teck on 10/14/20.
//

import Foundation

public class AccountApi {
    
    private final let api: TestProjectApi
    
    init(api: TestProjectApi){
        self.api = api
    }
    
    func create(account: Account, completionHandler: @escaping (_ CreateResult : TestProjectApi.CreateResult) -> ()){
        
        return api.create(entity: account, completionHandler: completionHandler)
    }
    
    func findOne(id: String, completionHandler: @escaping (_ FindResult : TestProjectApi.FindResult<Account>) -> ()){
    
        return api.findOne(id: id, ofClass: Account.self, completionHandler: completionHandler)
    }
    
    func findAll() -> TestProjectApi.FindManyResult<Account> {
        
    }
}
