//
//  ViewController.swift
//  CurrencyChecker
//
//  Created by admin on 2021-12-02.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var currencies = ["USD", "RUB", "EUR"]
    var currencyData = [CurrencyData]()
//    var currencyManager = CurrencyManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        currencyManager.delegate = self
//        tableView.dataSource = self
        
        downloadJSON {
            print("Successfull!")
        }
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: "https://cbu.uz/oz/arkhiv-kursov-valyut/json/")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil{
                do{
                    self.currencyData = try JSONDecoder().decode([CurrencyData].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print(error)
                }
                
            }
        }.resume()
    }
}

//MARK: - UITableViewDataSource
//extension ViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return currencies.count
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! CurrencyUITableViewCell
//        
//        let currentCountry = currencies[indexPath.row]
//        
//        cell.countryImageView.image = UIImage(named: currentCountry)
//        cell.currencyLabel.text = currentCountry
//        return cell
//      
//    }
//}

//extension ViewController: CurrencyManagerDelegate{
//    func didUpdateCurrency(currency: [CurrencyData]) {
//        DispatchQueue.main.async {
//            print(currency.count)
//        }
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//
//
//}

