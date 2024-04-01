//
//  ListUserVC.swift
//  English
//
//  Created by TaiTau on 30/12/2023.
//

import UIKit

class ListUserVC: UIViewController,UITableViewDelegate,UITableViewDataSource  {

    @IBOutlet weak var tbvUser: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let titleFont = UIFont.boldSystemFont(ofSize: 22)
    var cameraList: [CameraModel] = []
    var listData: [UserModel] = []
    var listCamViewModel: ListUserViewModel = ListUserViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listCamViewModel.getListUser()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configTbv()
        configUI()
        configData()
        bindViewModel()
    }
    
    func configData(){
        cameraList = createSampleCameraData()
    }
    
    fileprivate func configTbv() {
        self.tbvUser.register(UINib(nibName: "ListUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ListUserTableViewCell")
        if #available(iOS 15.0, *) {
            self.tbvUser.sectionHeaderTopPadding = 0
        }
        tbvUser.separatorStyle = .none
        tbvUser.showsVerticalScrollIndicator = false
    }
    
    func bindViewModel() {
        listCamViewModel.complete! = { [weak self] result in
            if(result == nil){
                self?.listData = (self?.listCamViewModel.listCamera)!
                self?.tbvUser.reloadData()
            }
        }
    }
    
    func createSampleCameraData() -> Camera {
        let camera1 = CameraModel(id: "0397528977", name: "Lê Minh Thiện", time: "manthien99@gmail.com", address: "Quận 4, Thành Phố Hồ Chí Minh",creator:"avt1",lat: 100.908,lng: 59.0904)
          let camera2 = CameraModel(id: "0903047332", name: "Phan Minh Đức", time: "Tuy Hòa,Tỉnh Phú Yên", address: "Tuy Hòa,Tỉnh Phú Yên",creator:"avt2",lat: 100.908,lng: 59.0904)
          let camera3 = CameraModel(id: "0985623212", name: "Nguyễn Công Thắng", time: "Đăk Lăk, Buôn Mê Thuật", address: "Đăk Lăk, Buôn Mê Thuật",creator:"avt3",lat: 100.908,lng: 59.0904)

          return [camera1, camera2, camera3]
      }
    
    fileprivate func configUI() {
        lblTitle.font = titleFont
        lblTitle.textColor = tintColor
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
            // Set it to true/false as needed to show or hide the tab bar
        }
    }
    
    @objc func callFarmer(_ sender: String) {
        if #available(iOS 13, *) {
            let alert = UIAlertController(
                title: sender, message: "",
                preferredStyle: .alert)
            let callAction = UIAlertAction(title: "Gọi", style: .default)
            {_ in
                if let url = NSURL(string: "tel://\(sender)"), UIApplication.shared.canOpenURL(url as URL) {
                  UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "Huỷ", style: .default)
            alert.addAction(callAction)
            alert.addAction(cancelAction)
            alert.preferredAction = callAction
            self.present(alert, animated: true, completion: nil)

        } else {
            let urlPhone: NSURL = NSURL(string:"telprompt:%@" + sender)!
            UIApplication.shared.open(urlPhone as URL, options: [:], completionHandler: nil)
        }
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListUserTableViewCell") as? ListUserTableViewCell else {
            return UITableViewCell();
        }
        let function = listData[indexPath.section];
        cell.setUp(user:function,index:indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section != 0) {
            return 10
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
extension ListUserVC: FarmerCellDelegate {
    func didChoose(cell: ListUserTableViewCell, phone:String) {
        if(!phone.isEmpty){
            callFarmer(phone)
        }
    }
}
