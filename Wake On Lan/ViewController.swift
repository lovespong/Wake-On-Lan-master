//
//  ViewController.swift
//  Wake On Lan
//
//  Created by James Tang on 17/7/2018.
//  Copyright © 2018年 JamesTang. All rights reserved.
//

import UIKit
import Alamofire
import PlainPing
import PKHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dict:[NSDictionary] = [NSDictionary]()
    var isUpdate = false
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isUpdate = false
        
        if UserDefaults.standard.object(forKey: "dict") != nil {
            dict = UserDefaults.standard.object(forKey: "dict") as! [NSDictionary]
            tableView.separatorStyle = .singleLine
        }else {
            tableView.separatorStyle = .none
        }
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" && isUpdate == true{
            let dict = sender as! NSDictionary
            let vc = segue.destination as? AddViewController
            vc?.dict = dict
            vc?.isUpdate = true
            vc?.selectedIndex = selectedIndex
        }
        else {
            let vc = segue.destination as? AddViewController
            vc?.isUpdate = false
            vc?.selectedIndex = selectedIndex
        }
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        let switchButton = sender as! UISwitch
        let row = switchButton.tag
        let ip = dict[row].value(forKey: "IP") as? String
        let mac = dict[row].value(forKey: "MAC") as? String
        let action = dict[row].value(forKey: "Action") as? String
        let user = dict[row].value(forKey: "Username") as? String ?? ""
        let password = dict[row].value(forKey: "Password") as? String ?? ""
        
        if switchButton.isOn == true {
            let computer = Awake.Device(MAC: mac!, BroadcastAddr: ip!, Port: 9)
           _ = Awake.target(device: computer)
        }else {
            Alamofire.request("http://" + ip! + "/action", method: .get, parameters: ["id" : action!]).authenticate(user: user, password: password)
        }
    }
}

extension ViewController:UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let update = UITableViewRowAction(style: .normal, title: "Update") { action, index in
            self.isUpdate = true
            self.selectedIndex = indexPath.row
            self.performSegue(withIdentifier: "add", sender: self.dict[indexPath.row])
        }
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            self.dict.remove(at: indexPath.row)
            UserDefaults.standard.set(self.dict, forKey: "dict")
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
        return [delete,update]
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dict.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isUpdate = true
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "add", sender: self.dict[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MACListTableViewCell
        let ip = dict[indexPath.row].value(forKey: "IP") as? String
        let mac = dict[indexPath.row].value(forKey: "MAC") as? String
        let action = dict[indexPath.row].value(forKey: "Action") as? String ?? ""
        cell.ipLabel.text = "IP : " + ip!
        cell.macLabel.text = "MAC : " + mac!
        cell.actionLabel.text = "Action : " + action
        cell.pcSwitch.tag = indexPath.row
        
        return cell
    }
}
