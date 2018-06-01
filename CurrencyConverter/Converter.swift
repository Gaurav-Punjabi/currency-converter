//
//  Converter.swift
//  CurrencyConverter
//
//  Created by Gaurav Punjabi on 5/31/18.
//  Copyright © 2018 Gaurav Punjabi. All rights reserved.
//

import Foundation


public class Converter {
    var dictionary = [String : Any]()
    public func fetchCurrentRates(completed: @escaping (Dictionary<String,Any>)->()) {
        let url = URL(string: API_KEY)!
        let session = URLSession.shared

        session.dataTask(with: url) { (data, response, error) in
            if let responseData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    let rates = self.parseJson(jsonObject: json)
                    completed(rates)
                } catch {
                    print("Could Not Serialize");
                }
            }
        }.resume()
    }
    private func parseJson(jsonObject: Any) -> Dictionary<String, Any> {
        let dict = jsonObject as? Dictionary<String, Any>
        if let success = dict!["success"] as? Bool {
            if !success {
                return Dictionary<String,Any>()
            }
        }
        return (dict!["quotes"] as! Dictionary<String, Any>)
    }
}
