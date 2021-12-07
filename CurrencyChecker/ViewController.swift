//
//  ViewController.swift
//  CurrencyChecker
//
//  Created by admin on 2021-12-02.
//

import UIKit

protocol PassDataDelegate: AnyObject{
    func update()
}

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var currencyData = [CurrencyData]()
    var currenciesToShow = [CurrencyData]()
    var currencies = [String]()
    var lolKek = [String]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserDefaults()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        downloadJSON {
            self.loadData(currency: self.currencies)
            self.tableView.reloadData()
        }
        
        loadData(currency: currencies)
        tableView.reloadData()
        
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "toChange"{
                if let toChangeVC = segue.destination as? SecondViewController{
                    toChangeVC.delegate = self
                }
            }
        }
    func loadUserDefaults(){
        
        if let array = UserDefaults.standard.object(forKey: "SecondVCCurrencies") as? [String]{
            currencies = array
        }
    }
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        
    }
    
    func loadData(currency: [String]){
        
        let newCTS = [CurrencyData]()
        currenciesToShow = newCTS
        for i in 0..<currency.count{
            print(currency[i])
        if let name = currencyData.first(where: {$0.Ccy == currency[i]}) {
                currenciesToShow.append(name)
            }
        }
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

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate{
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

extension ViewController: PassDataDelegate{
    func update() {

        loadUserDefaults()
        loadData(currency: currencies)
    }
}

