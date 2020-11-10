//
//  TestProjectApi.swift
//  SwiftAPIClient
//
//  Created by Dylan Ah Teck on 10/13/20.
//

import Foundation
import Alamofire

public class TestProjectApi {
    
    
    // Replace with the latest access token (expires every 24 hours), retrieved from the CodeBot web console:
    private static let paAccessToken = "access token";
    private var sessionManager: Session?
    private let url: String
    
    //static let networkEnviroment: NetworkE = .dev <- Look into this
    static let networkEnviroment: String = ".dev"
    
    //Change domain classes to Class Object
    private var allDomainClasses: [String]?
    
    
    //All the APIs
    public final var account: AccountApi?
    
    init(url: String){
        self.url = url
        registerAPIs()
        applyDefaultConfig()
    }
    
    func registerAPIs() {
        self.account = AccountApi(api: self)
    }
    
    func registerDomainClasses() {
        
    }
    /**
     * Connect to your API (in /Server folder) running locally.
     */
    public static func clientForLocalhost() -> TestProjectApi
    {
        return TestProjectApi(url: "http://127.0.0.1:7000/exampleuser/testproject");
    }

    public static func clientForUrl(url: String) -> TestProjectApi{
        return TestProjectApi(url: url);
    }
    
    private func applyDefaultConfig() {
       
        // create a custom session configuration
        let configuration = URLSessionConfiguration.default
        // add the headers
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json", "Accept": "application/json"]

        // create a session manager with the configuration
        self.sessionManager = Session(configuration: configuration)
    }
    
    /**
     * Override this in your application to customize the HTTP config,
     * e.g. configure a proxy server or a client certificate store.
     * <p>
     * For a full set of options, see: https://github.com/Kong/unirest-java#configuration
     */
    internal func applyConfig() {
    }

    /**
     * If you want to set a different object mapper (e.g. Jackson),
     * override this method from your own separate codebase.
     */
    internal func applyObjectMapper() {
       //Unirest.config().setObjectMapper(new GsonObjectMapper());
    }
    
    public func create<T: DomainObject>(entity: T, completionHandler: @escaping (_ CreateResult : CreateResult) -> ())  {
        do {
            let data = try entity.asDictionary()
            var id : String?
            var errMsg: String?
            let className = String(describing: T.self)
            self.sessionManager?.request("\(self.url)/\(className)", method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON{
                (response) in
                
                guard let httpStatusCode = response.response?.statusCode else {
                    return;
                 }
                if case .success = response.result {
                    id = self.idFrom(response: response)
                }
                else {
                    errMsg = self.errorMessageFrom(response: response)
                }
                let result = CreateResult(id: id, errorMsg: errMsg, statusCode :httpStatusCode)
                completionHandler(result)
            }
            
        } catch {
            print("An error occured: \(error)")
        }
    }
    
    public func createMany<T: DomainObject>(entities: [T], completionHandler: @escaping (_ CreateManyResult : CreateManyResult) -> ())  {
        do {
            var data : [String: [[String: Any]?]] = [:]
            var array : [[String: Any]?] = []
            entities.forEach{entity in
                do {
                    let dict = try entity.asDictionary()
                    array.append(dict)
                }
                catch {
                    print("Error converting object to dictionary")
                }
            }
            

            
            data["data"] = array

            var ids : [String]?
            var errMsg: String?
            let className = String(describing: T.self)
            
            //Correct Way once API is fixed
//            var request = URLRequest(url: try! "\(self.url)/\(className)".asURL())
//              //some header examples
//              request.httpMethod = "POST"
//              //parameter array
//              request.httpBody = try! JSONSerialization.data(withJSONObject: array)
//
//            self.sessionManager?.request(request).responseJSON { response in
//                    switch (response.result) {
//                    case .success:
//                        print("SUCCESS")
//                        print(response.value)
//
//                    case .failure(let error):
//                        print(error)
//                    }
//                }

            self.sessionManager?.request("\(self.url)/\(className)", method: .post, parameters: data, encoding: JSONEncoding.default).responseJSON{
                (response) in

                guard let httpStatusCode = response.response?.statusCode else {
                    print("Error! CreateMany request failed")
                    return;
                 }
                if case .success = response.result {
                    ids = self.idsFrom(response: response)
                }
                else {
                    errMsg = self.errorMessageFrom(response: response)
                }
                let result = CreateManyResult(errorMsg: errMsg, ids: ids, statusCode :httpStatusCode)
                completionHandler(result)
            }
            
        } catch {
            print("An error occured:")
        }
    }
    
    public func findOne<T: DomainObject>(id: String, ofClass: T.Type, completionHandler: @escaping (_ FindResult: FindResult<T>) -> ()) {
        
        let className = String(describing: ofClass)
        self.sessionManager?.request("\(self.url)/\(className)/\(id)", method: .get, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseDecodable(of: ofClass){
            (response) in
            
            guard let httpStatusCode: Int = response.response?.statusCode else {
                return;
             }
            
            guard case .success = response.result, let entity = response.value else {
                return completionHandler(FindResult(errorMsg: response.debugDescription, entity: nil, statusCode: response.response?.statusCode ?? 0))
            }
            
            completionHandler(FindResult(errorMsg: "", entity: entity, statusCode: httpStatusCode))
        }
    }
    
    //Todo: need to add error checking
    //Todo: need to check if adding attributes to string works
    public func findMany<T: DomainObject>(attrs: [String: T], ofClass: T.Type, completionHandler: @escaping (_ FindManyResult: FindManyResult<T>) -> ()) {
        
        let className = String(describing: ofClass)
        guard let url = URL(string: "\(self.url)/\(className)/") else {
            print("Invalid url")
            return;
        }
//        var urlRequest = URLRequest(url: url)
//        var urlRequestConvertable : URLConvertible?
//        do {
//            urlRequest.httpBody = try JSONEncoder().encode(attrs)
//            urlRequestConvertable = try urlRequest.asURLRequest()
//        } catch {
//            print("Invalid attributes")
//            return
//        }
        
        //Look as URLConvertible force unwrap
        //Still need to handle queries passed in as dictionary
        self.sessionManager?.request("\(self.url)/\(className)/", method: .get, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseDecodable(of: [T].self){
            (response) in

            guard let httpStatusCode: Int = response.response?.statusCode else {
                return;
             }
            guard case .success = response.result, let entities = response.value else {
                return completionHandler(FindManyResult(errorMsg: response.debugDescription, entities: nil, statusCode: httpStatusCode))
            }
            
            completionHandler(FindManyResult(errorMsg: "", entities: entities, statusCode: httpStatusCode))
        }
    }
    
    public func delete<T: DomainObject>(id: String, ofClass: T.Type, _ completionHandler: @escaping()-> ()){
        
            let className = String(describing: ofClass)
            self.sessionManager?.request("\(self.url)/\(className)/\(id)", method: .delete, encoding: JSONEncoding.default).responseJSON{ response in
                switch response.result {
                       case .success:
                           print("Delete Successful")
                           completionHandler()
                       case .failure(let error):
                           print(error)
                       }
            }
    }
    /**
     * Deletes all data in the table/collection represented by ofClass.
     */
    public func deleteAll<T: Codable>(ofClass: T){
        self.sessionManager?.request("\(self.url)/Account/", method: .delete, encoding: JSONEncoding.default).responseJSON{ response in
            switch response.result {
                   case .success:
                       print("Validation Successful")
                   case .failure(let error):
                       print(error)
                   }
        }
    }
    
    private func toDeleteResult(response: AFDataResponse<Any>){
        switch response.result{
            case .success:
                print("SUCCESS")
            case .failure:
                print("FAILURE")
        }
    }
    
    private func createCompletionHandler(_ id: String?, _ errMsg: String?,_ statusCode: Int) -> CreateResult {
        return CreateResult(id: id, errorMsg: errMsg, statusCode: statusCode)
    }
    
    //If need statusCode explicitly
//                    if let httpStatusCode = response.response?.statusCode {
//                          switch(httpStatusCode) {
//                          case 200:
//                          case 201:
//
//                          case default:
//
//                          }
//                    }
    
    private func idFrom(response: AFDataResponse<Any>) -> String? {
        var id : String?
        if let json = response.value as? [String: Any?] {
            if let array = json["insertedIds"] as? [String]{
                id =  array[0]
            }
        }
        return id
    }
    private func idsFrom(response:AFDataResponse<Any>)-> [String]? {
        
        if let json = response.value as? [String: Any?] {
            if let array = json["insertedIds"] as? [String]{
                return array
            }
        }
        return []
    }
    
    private func errorMessageFrom(response: AFDataResponse<Any>) -> String? {
        return response.error?.errorDescription
    }

    
    public class CreateResult : ApiResult {
        public final var id : String?
        public final var errorMsg: String?
        public final var statusCode: Int
        
        init(id: String?, errorMsg: String?, statusCode: Int){
            self.id = id
            self.errorMsg = errorMsg
            self.statusCode = statusCode;
        }
        
        func isOk() -> Bool {
            return id != nil
        }
        
        func toString() -> String {
            let sc : String = statusCode == 0 ? "" :  "\(statusCode) "
            return sc + (errorMsg ?? id ?? "")
        }
    }
    
    public class FindResult<T: DomainObject> : ApiResult  {
        public final var entity : T?
        public final var errorMessage: String?
        public final var statusCode: Int
        
        init(errorMsg: String?, entity: T?, statusCode: Int){
            self.entity = entity
            self.errorMessage = errorMsg
            self.statusCode = statusCode
        }
        
        public func isOk() -> Bool {
            return entity != nil
        }
        
        public func toString() -> String {
            let sc = statusCode == 0 ? "" : "\(self.statusCode) "
            // Should be entity.map(DomainObject::toString)
            return sc + (errorMessage ?? entity.map({($0.getId() ?? "[id]" )}) ?? "no entity returned")
        }
    }
    
    public class FindManyResult<T: DomainObject> : ApiResult {
        public final var entities: [T]?
        public final var errorMsg: String?
        public final var statusCode: Int
        
        init(errorMsg: String?, entities: [T]?, statusCode : Int){
            self.entities = entities
            self.errorMsg = errorMsg
            self.statusCode = statusCode
        }
        
        func isOk() -> Bool {
            return entities != nil
        }
        
        func toString() -> String {
            let sc : String = statusCode == 0 ? "" :  "\(statusCode) "
            return sc
//            return sc + (errorMsg ?? ("Created IDs: " + entities.map{(entity) -> T in
//                entity.toString()
//            }))
        }
    }
    
    public class CreateManyResult : ApiResult {
        public final var ids: [String]?
        public final var errorMsg: String?
        public final var statusCode: Int
        
        init(errorMsg: String?, ids: [String]?, statusCode : Int){
            self.ids = ids
            self.errorMsg = errorMsg
            self.statusCode = statusCode
        }
        
        func isOk() -> Bool {
            return ids != nil
        }
        
        func toString() -> String {
            let sc : String = statusCode == 0 ? "" :  "\(statusCode) "
            return sc + (errorMsg ?? ("Created IDs: " + (ids?.joined(separator: ", ") ?? "IDS")))
        }
    }
}

protocol ApiResult {
    func isOk() -> Bool;
}

extension ApiResult {
    func notOk() -> Bool {
        return !isOk()
    }
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
