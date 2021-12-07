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
    @IBOutlet weak var lastUpdatedTime: UILabel!
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender: )), for: .valueChanged)
        return refreshControl
    }()
    
    var currencyData = [CurrencyData]()
    var currenciesToShow = [CurrencyData]()
    var currencies = [String]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = myRefreshControl
        
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
    
    func updateTime(){
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        var time = ""
        time = formatter.string(from: today)
        lastUpdatedTime.text = "Last updated: \(time)"
        //        print(time)
        defaults.set(time, forKey: K.updatedTimeKey)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segueIdentifier{
            if let toChangeVC = segue.destination as? SecondViewController{
                toChangeVC.delegate = self
            }
        }
    }
    
    func loadUserDefaults(){
        
        if let array = UserDefaults.standard.object(forKey: K.currenciesKey) as? [String]{
            currencies = array
        }
        
        if let timeString = UserDefaults.standard.object(forKey: K.updatedTimeKey) as? String{
            lastUpdatedTime.text = "Last updated: \(timeString)"
        }
    }
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        
    }
    
    func loadData(currency: [String]){
        
        let newCTS = [CurrencyData]()
        currenciesToShow = newCTS
        for i in 0..<currency.count{
            //            print(currency[i])
            if let name = currencyData.first(where: {$0.Ccy == currency[i]}) {
                currenciesToShow.append(name)
            }
        }
        tableView.reloadData()
    }
    
    func downloadJSON(completed: @escaping () -> ()){
        let url = URL(string: K.cbuAPI)
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
    //    let myRefreshControl: UIRefreshControl = {
    //        let refreshControl = UIRefreshControl()
    //        refreshControl.addTarget(self, action: #selector(refresh(sender: )), for: .valueChanged)
    //        return refreshControl
    //    }()
    
    @objc private func refresh(sender: UIRefreshControl){
        
        update()
        updateTime()
        sender.endRefreshing()
    }
    
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

//MARK: - PassDataDelegate
extension ViewController: PassDataDelegate{
    
    func update() {
        
        loadUserDefaults()
        loadData(currency: currencies)
        tableView.reloadData()
    }
}

