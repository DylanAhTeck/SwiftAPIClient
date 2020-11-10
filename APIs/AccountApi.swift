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
    
    func createMany(entities: [Account], completionHandler: @escaping (_ CreateManyResult : TestProjectApi.CreateManyResult) -> ()){
        
        return api.createMany(entities: entities, completionHandler: completionHandler)
    }
    
    func delete(id: String, _  completionHandler: @escaping () -> () = {}) {
        api.delete(id: id, ofClass: Account.self, completionHandler)
    }
    
    func findOne(id: String, completionHandler: @escaping (_ FindResult : TestProjectApi.FindResult<Account>) -> ()){
    
        return api.findOne(id: id, ofClass: Account.self, completionHandler: completionHandler)
    }
    
    func findAll(completionHandler: @escaping (_ FindResult : TestProjectApi.FindManyResult<Account>) -> ()){
        
    }
    
    func findMany(completionHandler: @escaping (_ FindResult : TestProjectApi.FindManyResult<Account>) -> ()){
        return api.findMany(attrs: Dictionary(), ofClass: Account.self, completionHandler: completionHandler);
    }
}
