//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Gaurav Punjabi on 5/31/18.
//  Copyright © 2018 Gaurav Punjabi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    /***************************************************************************************************************
                                                VARIABLE DECLARATION                                              */
    @IBOutlet weak var sourceCurrency: UIPickerView!
    @IBOutlet weak var targetCurrency: UIPickerView!
    @IBOutlet weak var sourceTextField: UITextField!
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var targetTextField: UITextField!
    var sourceCurrencies = ["USD", "INR", "AED", "EUR", "YEN", "GBP"]
    var converter = Converter()
    var selectedSource = String()
    var selectedTaget = String()
    var rates = [String:Any]()
    /*                                        END_OF_VARIABLE_DECLARATION
    ***************************************************************************************************************/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FETCHING THE CURRENT RATES AND PASSING THE DELEGATE
        converter.fetchCurrentRates(completed: completedDownload)
        
        //ADJUSTMENTS FOR BETTER USER INTERFACE
        convertButton.layer.borderColor = UIColor(displayP3Red: 1, green: 76/255, blue: 74/255, alpha: 0.85).cgColor
        convertButton.layer.borderWidth = 1
    }
    
    
    /***************************************************************************************************************
                                            SUPER PROTOCOL METHODS
                                                                                                                  */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sourceCurrencies.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sourceCurrencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            self.selectedSource = sourceCurrencies[row]
        } else {
            self.selectedTaget = sourceCurrencies[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 46;
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label  = view as? UILabel
        if label == nil {
            label = UILabel()
            if pickerView.tag == 1 {
                label?.textColor = UIColor.white
            } else {
                label?.textColor = UIColor(displayP3Red: 1, green: 76/255, blue: 74/255, alpha: 0.85)
            }
            label?.font = UIFont(name: "Helvetica Neue",size: 46);
        }
        label?.text = sourceCurrencies[row]
        return label!
    }
    /**************************************END_OF_OVERRIDEN)METHODS*********************************************/
    
    
    /***************************************************************************************************************
                                            SERVICE METHODS                                                       */
    /*
        @param : a dictionary of currency shortform and its rate
        This method just stores the rates of the currency and creates a array of all the currency avaialble
    */
    private func completedDownload(data: Dictionary<String, Any>)  {
        self.rates = data
        self.sourceCurrencies = getCurrencies(dictionary: data).sorted(by: <)
    }
    
    /*
     * @param  : dictionary - a dictionary of all the currency and its rate
     * @return : an array with name of all the avialable currencies.
     *
     * This method inputs the dictionary and removes the "USD" from each name and stores it in the array and then returns
     * the array.
     */
    private func getCurrencies(dictionary: Dictionary<String, Any>) -> Array<String>{
        var array = [String]()
        for (codeName , _) in dictionary {
            let name = codeName.replacingOccurrences(of: "USD", with: "")
            array.append(name)
        }
        array.append("USD")
        self.rates["USDUSD"] = NSNumber(floatLiteral: 1.00)
        print(array.count)
        return array;
    }
    
    /*
     * @return : the rate of the currently selected combination of currencies.
     *
     * This method
     */
    private func getRate() -> Float {
        let sourceRate = (rates["USD" + selectedSource] as! NSNumber).floatValue
        let targetRate = (rates["USD" + selectedTaget] as! NSNumber).floatValue
        let rate = targetRate/sourceRate
        print(rate)
        return rate
    }
    private func convert() {
        let rate = getRate()
        let convertedValue = Float(rate) * Float(sourceTextField.text!)!
        targetTextField.text = String(convertedValue)
    }
    
    
    @IBAction func convertButtonPressed(_ sender: Any) {
        convert()
    }
}

