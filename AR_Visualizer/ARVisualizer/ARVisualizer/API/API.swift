//
//  API.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 24..
//

import Foundation

class APICommunicator{
    
    func get_data(){
        guard let url = URL(string: "https://sochain.com//api/v2/get_price/DOGE/USD") else { return }

             let task = URLSession.shared.dataTask(with: url) { data, response, error in

                 guard let data = data, error == nil else { return }

                 do {
                     // make sure this JSON is in the format we expect
                     // convert data to json
                     if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                         // try to read out a dictionary
                         print(json)
                         if let data = json["data"] as? [String:Any] {
                             print(data)
                             if let prices = data["prices"] as? [[String:Any]] {
                                 print(prices)
                                 let dict = prices[0]
                                 print(dict)
                                 if let price = dict["price"] as? String{
                                     print(price)
                                 }
                             }
                         }
                     }
                 } catch let error as NSError {
                     print("Failed to load: \(error.localizedDescription)")
                 }

             }

             task.resume()
    }
    
}
