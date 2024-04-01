//
//  ListCameraVC.swift
//  English
//
//  Created by TaiTau on 30/12/2023.
//

import UIKit

class ListCameraVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tbvListCamera: UITableView!
    
    
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let titleFont = UIFont.boldSystemFont(ofSize: 24)
    //var cameraList: [CameraModel] = []
    var cameraList: [CameraModelAPI] = []
    var listCamViewModel: ListCameraViewModel = ListCameraViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listCamViewModel.getListCam()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let selectedIndexPath = tbvListCamera.indexPathForSelectedRow {
            tbvListCamera.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTbv()
        configUI()
        bindViewModel()
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
            // Set it to true/false as needed to show or hide the tab bar
        }
    }
    
    func bindViewModel() {
        listCamViewModel.complete! = { [weak self] result in
            if(result == nil){
                self?.cameraList = (self?.listCamViewModel.listCamera)!
                self?.tbvListCamera.reloadData()
            }
        }
    }
    
    fileprivate func configTbv() {
        self.tbvListCamera.register(UINib(nibName: "ListCameraTableViewCell", bundle: nil), forCellReuseIdentifier: "ListCameraTableViewCell")
        if #available(iOS 15.0, *) {
            self.tbvListCamera.sectionHeaderTopPadding = 0
        }
        tbvListCamera.separatorStyle = .none
        tbvListCamera.showsVerticalScrollIndicator = false
    }
    
    func createSampleCameraData() -> Camera {
        let camera1 = CameraModel(id: "1", name: "Camera 1", time: "time1", address: "404 Đ. Xuân Đỉnh, Xuân Đỉnh, Bắc Từ Liêm, Hà Nội",creator:"Tai",lat: 100.908,lng: 59.0904)
          let camera2 = CameraModel(id: "2", name: "Camera 2", time: "time2", address: "168 P. Đội Cấn, Đội Cấn, Ba Đình, Hà Nội",creator:"Tai",lat: 21.238,lng: 79.014)
          let camera3 = CameraModel(id: "3", name: "Camera 3", time: "time3", address: "161 Phạm Văn Đồng, Xuân Đỉnh, Bắc Từ Liêm, Hà Nội",creator:"Tai",lat: 10.915,lng: 99.672)

          return [camera1, camera2, camera3]
      }
    
    fileprivate func configUI() {
        lblTitle.font = titleFont
        lblTitle.textColor = tintColor
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func actionBack(_ sender: Any) {
        print("back")
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCameraTableViewCell") as? ListCameraTableViewCell else {
            return UITableViewCell();
        }
        let function = cameraList[indexPath.section];
        cell.setUp(cam:function)
        cell.selectionStyle = .none
        //cell.delegate = self
        return cell;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cameraList.count
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailCamVC()
        vc.cam = cameraList[indexPath.section]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
