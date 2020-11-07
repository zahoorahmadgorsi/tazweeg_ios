//
//  ConsultantVC.swift
//  Tazweeg
//
//  Created by Naveed ur Rehman on 04/10/2018.
//  Copyright © 2018 Glowingsoft. All rights reserved.
//

import UIKit

class ConsultantVC: UIViewController, UITableViewDelegate, UITableViewDataSource,ConsultantCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var colView: UICollectionView!
    
    
    //MARK: - Custom Vars
//    var localize: Localize?
    var emirates = [Emirate]()
    var consultants = [Consultant]()
    var selected_index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tblView.tableFooterView = UIView(frame: CGRect.zero)
//        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(self.backTap(_:)))
//
//        self.navigationItem.rightBarButtonItem = backBtn
//
//        self.navigationItem.hidesBackButton = true
//        self.navigationItem.title = "المعرفين"
        
        getListEmirates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        localize = Localize()
//    }
    
    //MARK:- custom Methods
    @objc func backTap(_ btn: UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    func getListEmirates(){
        
        let dic = Dictionary<String,AnyObject>()
        
        let method = "listAllEmirates"
        Utility.shared.showSpinner()
        ALFWebService.shared.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
            
            if let status = response["status"] as? Int {
                if status == 1 {
                    if let emirate = response["emirates"] as? [Dictionary<String,AnyObject>] {
                        for em in emirate {
                            self.emirates.append(Emirate.init(fromDictionary: em))
                        }
                        self.selected_index = self.emirates.count - 1
                        self.colView.reloadData()
                        let indexPath = IndexPath(item: self.emirates.count - 1, section: 0)
                        self.colView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
                        if self.emirates.count != 0 {
                            if let id = self.emirates[self.emirates.count - 1].id{
                            self.getConsultantByEmirateID(id: id)
                            }
                        }
                        
                    }
                    
                } else {
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: response["message"] as! String, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }) { (response) in
            print(response)
            Utility.shared.hideSpinner()
        }
    }
    
    func getConsultantByEmirateID(id: Int){
        
        let dic = Dictionary<String,AnyObject>()
        
        let method = "listConsultants/\(id)"
        
        ALFWebService.shared.doGetData(parameters: dic, method: method, success: { (response) in
            print(response)
            Utility.shared.hideSpinner()
            if let status = response["status"] as? Int {
                if status == 1 {
                    if let consultant = response["consultants"] as? [Dictionary<String,AnyObject>] {
                        self.consultants.removeAll()
                        for con in consultant {
                            self.consultants.append(Consultant.init(fromDictionary: con))
                        }
                        self.tblView.reloadData()
                    }
                    
                } else {
                    self.consultants.removeAll()
                    self.tblView.reloadData()
                    Utility.showAlertWithTitle(title: "alert".localized, withMessage: response["message"] as! String, withNavigation: self)
                }
            }else {
                Utility.showAlertWithTitle(title: "alert".localized, withMessage: "general_error".localized, withNavigation: self)
            }
        }) { (response) in
            print(response)
            Utility.shared.hideSpinner()
        }
    }
    // MARK: - collection Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emirates.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmiratesCollCell
        if indexPath.item == selected_index {
            cell.backView.layer.borderWidth = 1
            cell.backView.layer.borderColor = UIColor(hexString: "#E8B059").cgColor
            cell.backView.backgroundColor = UIColor.white
        } else {
            cell.backView.layer.borderWidth = 1
            cell.backView.layer.borderColor = UIColor.white.cgColor
            cell.backView.backgroundColor = UIColor.clear
        }
        cell.imgEmirate.circulate(radius: 30)
        if let url = emirates[indexPath.item].logo{
            let imgUrl = URL(string: url)
            if imgUrl != nil {
                cell.imgEmirate.setImageWith(imgUrl!)
            }
        }
        cell.lblEmirateName.text = emirates[indexPath.item].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 109)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != selected_index {
            selected_index = indexPath.item
            colView.reloadData()
            Utility.shared.showSpinner()
            if let id = emirates[indexPath.item].id{
                self.getConsultantByEmirateID(id: id)
            }
        }
        
    }
    // MARK: - TableView Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consultants.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ConsultantCell
        let model = consultants[indexPath.row]
        cell.usrImg.circulate(radius: 50)
        let imgUrl = URL(string: model.image ?? "")
        if imgUrl != nil {
            cell.usrImg.setImageWith(imgUrl!)
        }
        cell.name.text = model.name
        cell.city.text = model.emiratesServesIn
        cell.phone.text = model.phoneNumber?.stringValue
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dvc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .signUpVC1) as! SignUpVC1
        dvc.consultantId = consultants[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(dvc, animated: true)
    }

    //MARK:- ConsultantCellDelegate
    func didTapMemberDetail(index: Int) {
        let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .memberDetailVC) as! MemberDetailVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
