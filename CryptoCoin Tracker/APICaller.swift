//
//  APICaller.swift
//  CryptoCoin Tracker
//
//  Created by Calvin Sung on 2021/8/4.
//

import Foundation


class APICaller {
    
    static let shared = APICaller()
    
    var icons: [Icon] = []
    var getReadyBlock: ((Result<[Crypto], Error>) -> Void)?
    
    struct Constants {
        static let assetEndPoint = "https://rest-sandbox.coinapi.io/v1/assets?apikey="
        static let apiKey = "A24C31C1-29C9-4ED0-ABC8-41CE27C52A62"
    }
    
    
    func getAllCryptoData(completion: @escaping (Result<[Crypto], Error>) -> Void) {
        
        guard !icons.isEmpty else {
            getReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constants.assetEndPoint + Constants.apiKey) else {
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard data != nil && error == nil else {
                return
            }
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data!)
                print("get crypto array")
       
                completion(.success(cryptos.sorted(by: { (first, second) -> Bool in
                    return first.price_usd ?? 0 > second.price_usd ?? 0
                })))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func getAllIcons() {
        guard let url = URL(string: "https://rest-sandbox.coinapi.io/v1/assets/icons/55?apikey=A24C31C1-29C9-4ED0-ABC8-41CE27C52A62") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard data != nil && error == nil else {
                return
            }
            do {
                self.icons = try JSONDecoder().decode([Icon].self, from: data!)
                if let completion = self.getReadyBlock {
                    self.getAllCryptoData(completion: completion)
                }
            } catch {
                
            }
        }
        task.resume()
    }
    
    
}
