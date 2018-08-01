//
//  AddViewController.swift
//  Wake On Lan
//
//  Created by James Tang on 17/7/2018.
//  Copyright © 2018年 JamesTang. All rights reserved.
//

import UIKit
import AnyFormatKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var macTextField: UITextField!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginSwitch: UISwitch!
    @IBOutlet weak var actionPickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var dict:NSDictionary!
    var isUpdate:Bool!
    var selectedIndex:Int!

    let actionArray = ["Shutdown","Reboot","Logoff","Lock","Sleep","Hibernate","MonitorOff","ScreenSaver","VolumeMute","VolumeUnmute","HangUp","Alarm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ipTextField.delegate = self
        portTextField.delegate = self
        macTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        actionPickerView.delegate = self
        actionPickerView.dataSource = self
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        
       // let height = Int(self.view.frame.height) + Int(passwordTextField.frame.origin.y)
       // scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(height))
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        if isUpdate == true {
            ipTextField.text = dict.value(forKey: "IP") as? String
            macTextField.text = dict.value(forKey: "MAC") as? String
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    @IBAction func switchChanged(_ sender: Any) {
        let switchButton = sender as! UISwitch
        if switchButton.isOn == true {
            usernameLabel.isHidden = false
            usernameTextField.isHidden = false
            passwordLabel.isHidden = false
            passwordTextField.isHidden = false
        }else {
            usernameLabel.isHidden = true
            usernameTextField.isHidden = true
            passwordLabel.isHidden = true
            passwordTextField.isHidden = true
        }
    }
    
    @IBAction @objc func save(_ sender: Any) {
        
        var userDefaultDict:[NSDictionary] = [NSDictionary]()
        var userDict: NSDictionary = NSDictionary()
        if loginSwitch.isOn {
            userDict = ["IP" : ipTextField.text!, "Port" : portTextField.text!, "MAC" : macTextField.text!,"Username" : usernameTextField.text!, "Password" : passwordTextField.text!, "Action" : actionArray[actionPickerView.selectedRow(inComponent: 0)]]
        }else {
            userDict = ["IP" : ipTextField.text!, "Port" : portTextField.text!, "MAC" : macTextField.text!,"Action" : actionArray[actionPickerView.selectedRow(inComponent: 0)]]
        }
        
        if UserDefaults.standard.object(forKey: "dict") != nil {
            userDefaultDict = UserDefaults.standard.object(forKey: "dict") as! [NSDictionary]
        }
        
        if isUpdate == true {
            update(userDefaultDict: userDefaultDict, userDict: userDict)
        }
        else{
            add(userDefaultDict: userDefaultDict, userDict: userDict)
        }
        let alert = UIAlertController(title: "Success", message: "Record update successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func update(userDefaultDict:[NSDictionary], userDict:NSDictionary){
        let dictForUpdate = userDefaultDict[selectedIndex].mutableCopy() as! NSDictionary
        var saveDict = userDefaultDict
        
        dictForUpdate.setValue(ipTextField.text, forKey: "IP")
        dictForUpdate.setValue(macTextField.text, forKey: "MAC")
        if loginSwitch.isOn{
            dictForUpdate.setValue(usernameTextField.text, forKey: "Username")
            dictForUpdate.setValue(passwordTextField.text, forKey: "Password")
        }
        dictForUpdate.setValue(actionArray[actionPickerView.selectedRow(inComponent: 0)], forKey: "Action")
        saveDict.remove(at: selectedIndex)
        saveDict.insert(dictForUpdate, at: selectedIndex)
        
        UserDefaults.standard.set(saveDict, forKey: "dict")
        UserDefaults.standard.synchronize()
    }
    
    func add(userDefaultDict:[NSDictionary], userDict:NSDictionary){
        var saveDict:[NSDictionary] = userDefaultDict
        saveDict.append(userDict)
        UserDefaults.standard.set(saveDict, forKey: "dict")
        UserDefaults.standard.synchronize()
    }
    
}

extension AddViewController:UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == macTextField && loginSwitch.isOn == false{
            save(textField)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        if textField == macTextField {
            macTextField.text = macTextField.text?.uppercased()
            if macTextField.text?.range(of: ":") == nil {
                let MACFormatter = TextFormatter(textPattern: "##:##:##:##:##:##")
                macTextField.text = MACFormatter.formattedText(from: macTextField.text)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return actionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return actionArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = actionArray[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView.endEditing(true)
    }
    
}

extension UIScrollView {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
}
