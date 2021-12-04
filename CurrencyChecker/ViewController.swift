//
//  ViewController.swift
//  CurrencyChecker
//
//  Created by admin on 2021-12-02.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    
    var currencies = ["USD", "RUB", "EUR"]
    var currencyData = [CurrencyData]()
    var currenciesToShow = [CurrencyData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadJSON {
            self.tableView.reloadData()
        }
    }
    
    //    var currencyManager = CurrencyManager()
    @IBAction func addButtonPressed(_ sender: UIButton) {
        guard searchTextField.text != "" else {
            searchTextField.placeholder = "Type the currency name"
            return
        }
        
        let searchedCurrency = searchTextField.text
        if currenciesToShow.contains(where: {$0.Ccy == searchedCurrency}){
            searchTextField.text = ""
            searchTextField.placeholder = "Already have \(searchedCurrency!)"
            return
        }
        if let name = currencyData.first(where: {$0.Ccy == searchedCurrency}) {
            currenciesToShow.append(name)
            searchTextField.text = ""
            searchTextField.placeholder = "\(searchedCurrency!) added"
            tableView.reloadData()
        } else {
            searchTextField.text = ""
            searchTextField.placeholder = "Don't have \(searchedCurrency!)"
        }
        tableView.reloadData()
        
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        guard searchTextField.text != "" else {
            searchTextField.placeholder = "Type the currency name"
            return
        }
        let searchedCurrency = searchTextField.text
        if let name = currenciesToShow.first(where: {$0.Ccy == searchedCurrency!}){
            currenciesToShow = currenciesToShow.filter(){$0.Ccy != name.Ccy}
            searchTextField.text = ""
            searchTextField.placeholder = "\(searchedCurrency!) deleted"
            tableView.reloadData()
        } else {
            searchTextField.text = ""
            searchTextField.placeholder = "Don't have \(searchedCurrency!)"
        }
        tableView.reloadData()
        
    }
    
    
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        
        tableView.reloadData()
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
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesToShow.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CurrencyUITableViewCell
        
        cell.currencyLabel.text = currenciesToShow[indexPath.row].Ccy
        cell.countryImageView.image = UIImage(named: currenciesToShow[indexPath.row].Ccy)
        cell.centralBankLabel.text = currenciesToShow[indexPath.row].Rate
        return cell
    }
}




//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate{
    
}

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

