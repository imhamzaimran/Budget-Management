//
//  AddSavingAmountViewController.swift
//  Budget Management
//
//  Created by Intern on 10/11/2020.
//

import UIKit
import RealmSwift

class AddSavingAmountViewController: UIViewController {
    
    @IBOutlet weak var goalNameLBL: UILabel!
    @IBOutlet weak var targetDateLBL: UILabel!
    @IBOutlet weak var goalAmounLBL: UILabel!
    @IBOutlet weak var savedAmountLBL: UILabel!
    @IBOutlet weak var remainingAmountLBL: UILabel!
    @IBOutlet weak var goalImageView: UIImageView!
    @IBOutlet weak var addAmountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var depositTypeTextField: UITextField!
    @IBOutlet weak var descripitonTextField: UITextField!
    @IBOutlet var selectAccountTypeView: UIView!
    @IBOutlet weak var cashViewImage: UIView!
    @IBOutlet weak var bankViewImage: UIView!
    @IBOutlet weak var otherViewImage: UIView!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var bankBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    
    internal var selectedGoalDetails: GoalDetails?
    private var accountType = "Cash"
    private let relam = try! Realm()
    private let greenColor = UIColor(named: "PrimaryColor")!
    private let redColor = UIColor.systemRed
    private let datePicker = UIDatePicker()
    private typealias todaysDate = (month: String, day: String, year: String)
    
    override var prefersStatusBarHidden: Bool {
        true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAmountTextField.delegate = self
        dateTextField.delegate = self
        depositTypeTextField.delegate = self
        descripitonTextField.delegate = self
        
        addAmountTextField.text = nil
        addAmountTextField.textAlignment = .right
        addAmountTextField.textColor = UIColor(named: "PrimaryColor")
        changeBorderColor(name: greenColor)
        
        dateTextField.textFieldStyle(color: .darkGray)
        dateTextField.textColor = .darkGray
        
        depositTypeTextField.textFieldStyle(color: .darkGray)
        depositTypeTextField.textColor = .darkGray
        
        descripitonTextField.textFieldStyle(color: .darkGray)
        descripitonTextField.textColor = .darkGray
        
        cashViewImage.makeRoundedView()
        bankViewImage.makeRoundedView()
        otherViewImage.makeRoundedView()
        
        getDetails()
    }
    
    private func getDetails(){
        
        if let details = selectedGoalDetails {
            goalImageView.image = UIImage(named: details.goalIcon)
            goalNameLBL.text = details.goalName
            targetDateLBL.text = "Target Date: \(details.targetDate)"
            goalAmounLBL.text = "Goal: \(details.totalGoalAmount)"
            savedAmountLBL.text = "Saved: \(details.savedAmount)"
            descripitonTextField.text = details.goalDescription
            dateTextField.text = details.targetDate
            depositTypeTextField.text = details.accountType
            if let total = Int(details.totalGoalAmount) {
                remainingAmountLBL.text = "Remaining: \(total-details.savedAmount)"
            } else {
                remainingAmountLBL.text = "Remaining: N/A"
            }
            let type = details.accountType
            if type == "Cash" {
                cashViewImage.backgroundColor = .lightGray
            } else if type == "Bank" {
                bankViewImage.backgroundColor = .lightGray
            } else if type == "Other" {
                otherViewImage.backgroundColor = .lightGray
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if addAmountTextField.isFirstResponder {
            addAmountTextField.resignFirstResponder()
        } else if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
        } else if depositTypeTextField.isFirstResponder {
            depositTypeTextField.resignFirstResponder()
        } else if descripitonTextField.isFirstResponder {
            descripitonTextField.resignFirstResponder()
        }
    }
    
    private func saveData(){
        if let details = selectedGoalDetails {
            do {
                try self.relam.write {
                    let transactions = GoalTransactions()
                    details.accountType = accountType
                    let amount = Int(addAmountTextField.text!)!
                    details.lastAddedSavingAmount = amount
                    details.savedAmount = details.savedAmount + amount
                    details.targetDate = dateTextField.text!
                    details.goalDescription = descripitonTextField.text!
                    transactions.amount = amount
                    transactions.goalName = details.goalName
                    transactions.goalDescription = details.goalDescription
                    let date = getCurrentDate()
                    transactions.date = "\(date.month)\n\(date.day)\n\(date.year)"
                    details.goalTransactions.append(transactions)
                    print("Details updated successfully.")
                    self.view.makeToast("details updated!", duration: 1.0, position: .bottom)
                    dismissController()
                }
            } catch {
                print("Error Savings Details.\n\(error)")
            }
        }
    }
    private func getCurrentDate()-> todaysDate{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "E-dd-yyyy"
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: date)
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        
        let curDate: todaysDate = (month: month, day: day, year: year)
        return curDate
    }
    
    private func changeBorderColor(name: UIColor) {
        addAmountTextField.layer.borderColor = name.cgColor
        addAmountTextField.layer.borderWidth = 1.0
        addAmountTextField.layer.cornerRadius = 5.0
    }
    
    private func dismissController(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func backIconBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveDepositBtn(_ sender: UIButton) {
        
        if addAmountTextField.text?.isEmpty ?? true || dateTextField.text?.isEmpty ?? true || depositTypeTextField.text?.isEmpty ?? true || descripitonTextField.text?.isEmpty ?? true{
            self.view.makeToast("one of the field is empty", duration: 1.5, position: .bottom)
        }else {
             if let details = selectedGoalDetails{
                if let total = Int(details.totalGoalAmount) {
                    let amount = Int(addAmountTextField.text!)!
                    let remaining = total-details.savedAmount
                    if amount > remaining {
                        self.view.makeToast("entered amount should be less than the remaining amount!\nremaining goal amount is \(remaining)")
                    } else {
                        saveData()
                    }
                } else {
                    self.view.makeToast("error occured!")
                }
            }
        }
    }
    
    @IBAction func selectAccountTypeViewCloseBtn(_ sender: UIButton) {
        self.selectAccountTypeView.removeFromSuperview()
    }
    
    @IBAction func chosenAccountBtn(_ sender: UIButton) {
        
        if sender == cashBtn {
            
            cashBtn.tag = 1
            bankBtn.tag = 0
            otherBtn.tag = 0
            accountType = "Cash"
            cashViewImage.backgroundColor = .lightGray
            bankViewImage.backgroundColor = nil
            otherViewImage.backgroundColor = nil
            dismissSelectAccountView()
        } else if sender == bankBtn {
            
            cashBtn.tag = 0
            bankBtn.tag = 1
            otherBtn.tag = 0
            accountType = "Bank"
            cashViewImage.backgroundColor = nil
            bankViewImage.backgroundColor = .lightGray
            otherViewImage.backgroundColor = nil
            dismissSelectAccountView()
        } else if sender == otherBtn {
            
            cashBtn.tag = 0
            bankBtn.tag = 0
            otherBtn.tag = 1
            accountType = "Other"
            cashViewImage.backgroundColor = nil
            bankViewImage.backgroundColor = nil
            otherViewImage.backgroundColor = .lightGray
            dismissSelectAccountView()
        }
    }
    
    private func dismissSelectAccountView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.depositTypeTextField.text = self.accountType
            self.selectAccountTypeView.removeFromSuperview()
        }
    }
    
    private func showPicker(forView: UIView){
        forView.frame = self.view.frame
        self.view.addSubview(forView)
    }
}


//MARK:- extension textfield delegate

extension AddSavingAmountViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == addAmountTextField {
            changeBorderColor(name: greenColor)
        } else if textField == depositTypeTextField {
            textField.resignFirstResponder()
            self.showPicker(forView: selectAccountTypeView)
        } else if textField == dateTextField {
            showDatePicker()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if addAmountTextField.isFirstResponder {
            addAmountTextField.resignFirstResponder()
        } else if dateTextField.isFirstResponder {
            dateTextField.resignFirstResponder()
        } else if depositTypeTextField.isFirstResponder {
            depositTypeTextField.resignFirstResponder()
        } else if descripitonTextField.isFirstResponder {
            descripitonTextField.resignFirstResponder()
        }
        return false
    }
}

//MARK: - extension datepciker

extension AddSavingAmountViewController {
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        //ToolBar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-200, width: UIScreen.main.bounds.width, height: 44))
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}