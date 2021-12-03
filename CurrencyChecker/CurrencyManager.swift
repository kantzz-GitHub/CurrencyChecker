//
//  CurrencyManager.swift
//  CurrencyChecker
//
//  Created by admin on 2021-12-03.
//

//import Foundation
//
//protocol CurrencyManagerDelegate{
//    func didUpdateCurrency(currency: [CurrencyData])
//    func didFailWithError(error: Error)
//}
//
//struct CurrencyManager{
//    
//    let anor: String = "https://cbu.uz/oz/arkhiv-kursov-valyut/json/"
//    
//    var delegate: CurrencyManagerDelegate?
//    
//    
//    func performRequest(urlString: String){
//        if let url = URL(string: urlString){
//            let session = URLSession(configuration: .default)
//            
//            let task = session.dataTask(with: url) { data, response, error in
//                if error != nil{
//                    self.delegate?.didFailWithError(error: error!)
//                    return
//                }
//                
//                if let safeData = data{
//                    if let currency = self.parseJSON(currencyData: safeData){
//                        self.delegate?.didUpdateCurrency(currency: currency)
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
//    
//    func parseJSON(currencyData: Data) -> [CurrencyData]?{
//        let decoder = JSONDecoder()
//        do{
//            let decodedData: [CurrencyData] = try decoder.decode([CurrencyData].self, from: currencyData)
//            return decodedData
//        } catch {
//            delegate?.didFailWithError(error: error)
//            return nil
//        }
//    }
//    
//}
//
//
