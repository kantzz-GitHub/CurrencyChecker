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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }


}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! CurrencyUITableViewCell
        
        let currentCountry = currencies[indexPath.row]
        
        cell.currencyLabel.text = currentCountry
        
        
        
        return cell
    }
    
}

