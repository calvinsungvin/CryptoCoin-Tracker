//
//  ViewController.swift
//  CryptoCoin Tracker
//
//  Created by Calvin Sung on 2021/8/4.
//

import UIKit

class ViewController: UIViewController {
    
    private var cryptoViewModels = [CryptoViewModel]()
    
    private let table: UITableView = {
       let tableView = UITableView()
        tableView.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    static let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.allowsFloats = true
        formatter.numberStyle = .currency
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(table)
        title = "Crypto Tracker"
        table.dataSource = self
        table.delegate = self
        
        getAllCryptoData()
    }
    
    private func getAllCryptoData() {
        
        APICaller.shared.getAllCryptoData { [weak self] (result) in
            switch result {
            case .success(let models):
                print("maping models to viewModels")
                self?.cryptoViewModels = models.compactMap({model in
                    //numberformatter
                    let price = model.price_usd ?? 0
                    let formatter = ViewController.numberFormatter
                    let priceString = formatter.string(from: NSNumber(value: price))
                    let iconUrl = URL(string: APICaller.shared.icons.filter({ icon in
                        icon.asset_id == model.asset_id
                    }).first?.url ?? ""
                    )
                    
                    return CryptoViewModel(name: model.name ?? "N/A", symbol: model.asset_id, price: priceString  ?? "N/A", iconUrl: iconUrl)
                })
                
                DispatchQueue.main.async {
                    self?.table.reloadData()
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as! CryptoTableViewCell
        cell.configure(with: cryptoViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
   
}
