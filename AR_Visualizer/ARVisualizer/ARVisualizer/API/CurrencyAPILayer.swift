//
//  CurrencyAPILayer.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 05. 01..
//

import Foundation

class CurrencyAPILayer{
    
    private let apiKey = "YNIJuQBfnnnQvmVHMDooFtGY4nE6u0Rj"
    var usdCurrent = 0.0
    var eurCurrent = 0.0
    
    func convert(mire: String){
        let semaphore = DispatchSemaphore (value: 0)

        let url = "https://api.apilayer.com/exchangerates_data/convert?to=HUF&from=\(mire)&amount=1"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: 50.0)
        
        request.httpMethod = "GET"
        request.addValue("\(apiKey)", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
            if(mire == "USD")
            {
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        /*if self.usdCurrent == json["result"] as? Float {
                            print("USD: \(self.usdCurrent)")
                        }*/
                        let ertek = json["result"]
                        print(ertek)
                        self.usdCurrent = ertek! as! Double
                        print("USD LEKÉRVE: \(self.usdCurrent)")
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
                
            }
            else if (mire == "EUR")
            {
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        // try to read out a string array
                        //print(type(of: json))
                        let ertek = json["result"]
                        print(ertek)
                        self.eurCurrent = ertek! as! Double
                        print(self.eurCurrent)
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    func fluctuation(){
        let semaphore = DispatchSemaphore (value: 0)

        let url = "https://api.apilayer.com/exchangerates_data/fluctuation?start_date=2023-05-02&end_date=2023-05-03&base=EUR&currencies=HUF"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("\(apiKey)", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
}
