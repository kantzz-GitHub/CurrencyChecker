//
//  SecondViewController.swift
//  CurrencyChecker
//
//  Created by admin on 2021-12-07.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var secondSearchTF: UITextField!
    @IBOutlet weak var secondTableView: UITableView!
    
    var currencies = ["USD", "EUR", "RUB"]
    
    var cData = [CurrencyData]()
    
    let defaults = UserDefaults.standard
    
    weak var delegate: PassDataDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        secondTableView.dataSource = self
        secondTableView.delegate = self
        
        if let curr = defaults.array(forKey: K.currenciesKey) as? [String]{
            currencies = curr
        }
        
        downloadJSON {
            self.secondTableView.reloadData()
        }
    }
    
    @IBAction func secondButtonPressed(_ sender: UIButton) {
        guard secondSearchTF.text != "" else {
            secondSearchTF.placeholder = "Type the currency name"
            return
        }
        
        let searchedCurrency = secondSearchTF.text
        
        if currencies.contains(where: {$0 == searchedCurrency}){
            secondSearchTF.text = ""
            secondSearchTF.placeholder = "Already have \(searchedCurrency!)"
            return
        }
        
        if let name = cData.first(where: {$0.Ccy == searchedCurrency}) {
            
            let newString = searchedCurrency!
            currencies.append(newString)
            
            saveCurrencies()
            
            secondSearchTF.text = ""
            secondSearchTF.placeholder = "\(name.Ccy) added"
            secondTableView.reloadData()
            
        } else {
            
            secondSearchTF.text = ""
            secondSearchTF.placeholder = "Don't have \(searchedCurrency!)"
        }
        secondTableView.reloadData()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        delegate?.update()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: K.cbuAPI)
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil{
                do{
                    self.cData = try JSONDecoder().decode([CurrencyData].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print(error)
                }
                
            }
        }.resume()
    }
    
    func saveCurrencies(){
        defaults.set(currencies, forKey: K.currenciesKey)
        delegate?.update()
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SecondViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = currencies[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        
        currencies.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        tableView.endUpdates()
        
        saveCurrencies()
    }
}
