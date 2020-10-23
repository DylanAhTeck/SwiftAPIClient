import Alamofire
//Account
class AccountExamples {
    
    private static let api = TestProjectApi.clientForLocalhost()
    
    public static func run() {
        createAndRetrieveSingleAccount()
    }
    
    public static func createAndRetrieveSingleAccount() {
        // Change this to ExampleDataHelper
        let accountToCreate = Account(name: "Dylan", id: "123")
        
        if let account = api.account {

            account.create(account: accountToCreate, completionHandler: { (CreateResult: TestProjectApi.CreateResult) ->() in
                
                print("Create result: \(CreateResult)")
                
                if let createdId = CreateResult.id {
                    
                    account.findOne(id: createdId, completionHandler: { (FindResult: TestProjectApi.FindResult<Account>) -> () in
                        
                        print("Find result: \(FindResult)")
                        if FindResult.entity != nil {
                            print("Account rows in the database (expecting at least 1):  \(self.count())");

                            //Delete Account
//                            api.account.delete(accountToCreate, completionHandler: {
//
//                            })
//                          print("Delete results \()")
                            print("Account rows in the database: \(self.count())");

                            
                        }
                    }
                    
                    )
                    
            
                }
            }
        )
    }
    }
    
    static func count() -> Int {
        return 0
//        return api.account.findAll(completionHandler: {
//
//        })
    }
    
    
    func get(){
        let request = AF.request("http://127.0.0.1:7000/exampleuser/testproject/Account")
            request.responseDecodable(of: [Account].self) { (response) in
    
                guard let accounts = response.value else { return }
                print(accounts)
          }
    }
    
    func post() {
        let data: [String: Any] = ["name": "John", "id": "12332", "facebook": "JohnyD"]
        AF.request("http://127.0.0.1:7000/exampleuser/testproject/Account", method: .post, parameters: data, encoding: JSONEncoding.default).validate(contentType: ["application/json"]).responseJSON{
            (response) in
            if let httpStatusCode = response.response?.statusCode {
//              switch(httpStatusCode) {
//              case 200:
//              case 201:
//                  let String =
//                  message = "Username or password not provided."
//              case 401:
//                  message = "Incorrect password for user '\(name)'."
//              default:
                    
//              }
            }
        }
    }
}



