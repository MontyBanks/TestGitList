//
//  ContentView.swift
//  GitList
//
//  Created by Vitalii Yaremchuk on 07.12.2020.
//

import SwiftUI
import Alamofire


struct ContentView: View {
    @ObservedObject var observed = Observer()

    var body: some View {
        
        List(observed.repoItems){ i in
            HStack{Text(i.name)
                Spacer()
                Text(String(i.stars))
                }
            }
        
    }
    func addRepo(){
            observed.fetchItems()
        }
}



struct Repo: Identifiable{
    let id: Int
    let name: String
    let stars: Int
    
}


class Observer : ObservableObject{
    @Published var repoItems = [Repo]()

    init() {
        fetchItems()
    }
    
    func fetchItems() {
        // 1
//        AF.request("https://api.github.com/search/repositories?q=most+ranked")
        AF.request("https://api.github.com/search/repositories?q=stars:%3E1&sort=stars&per_page=30")
            .responseJSON{
                            response in
                switch response.result {
                case let .success(value):
                    let json = value
                                if  (json as? [String : AnyObject]) != nil{
                                    if let dictionaryArray = json as? Dictionary<String, AnyObject?> {
                                        let jsonArray = dictionaryArray["items"]

                                        if let jsonArray = jsonArray as? Array<Dictionary<String, AnyObject?>>{
                                            for i in 0..<jsonArray.count{
                                                let json = jsonArray[i]
                                                if let id = json["id"] as? Int, let name = json["name"] as? String, let stars = json["stargazers_count"] as? Int{
                                                    self.repoItems.append(Repo(id: id, name: name, stars: stars))
                                                }
                                            }
                                        }
                                    }
                                }case let .failure(error):
                                    print(error)
                                }
                            }
                
            }
      }

    
    
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
