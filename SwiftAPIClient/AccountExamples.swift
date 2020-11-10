import Alamofire
//Account
class AccountExamples {
    
    private static let api = TestProjectApi.clientForLocalhost()
    
    public static func run() {
        createAndRetrieveSingleAccount()
        //createMany()
    }
    
    public static func createAndRetrieveSingleAccount() {
        // Change this to ExampleDataHelper
        let accountToCreate = Account(name: "Pierce", id: "4321")

        if let account = api.account {

            account.create(account: accountToCreate, completionHandler: { (CreateResult: TestProjectApi.CreateResult) ->() in
                
                print("Create result: \(CreateResult.toString())")
                if CreateResult.isOk() {
                    print("Successfully created account:\(accountToCreate.toString())")
                }
                
                if let createdId = CreateResult.id {
                    account.findOne(id: createdId, completionHandler: { (FindResult: TestProjectApi.FindResult<Account>) -> () in
                        
                        print("Find result: \(FindResult.toString())")
                        
                        if let accountResult = FindResult.entity {
                          
                            //Check if this works rather than comment below it
                            self.printCount({
                                let id = accountResult.getId() ?? "0"
                                account.delete(id: id, {
                                    self.printCount();
                                })
                            }
                            )
                        }
                    })
                }
            }
        )
    }
    }
    
    //Todo: find out how to format when posting array of objects
    public static func createMany() {
        var accountList: [Account] = []
        accountList.append(Account(name: "John", id: "11"))
        accountList.append(Account(name: "Dick", id: "12"))
        accountList.append(Account(name: "Harry", id: "13"))
        
        if let account = api.account {
            account.createMany(entities: accountList, completionHandler: { (CreateManyResult: TestProjectApi.CreateManyResult) -> () in
                print("Create many result: \(CreateManyResult)")
                if CreateManyResult.isOk() {
                    for account in accountList {
                        print("Successfully created account:\(account.toString())")
                    }
                    
                }
            }
            )
        }
    }
    
    static func printCount(_ completionHandler: @escaping () -> () = {}) {
        if let account = api.account {
            account.findMany(completionHandler: {
                  (FindManyResult : TestProjectApi.FindManyResult) -> () in
                print(FindManyResult.errorMsg)
                print(FindManyResult.statusCode)
                if let entities = FindManyResult.entities{
                   
                    print("Account rows in the database (expecting at least 1):  \(entities.count)");
                    completionHandler()
                }
              })
        }
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




