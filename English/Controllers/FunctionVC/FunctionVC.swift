//
//  ResultQuizVC.swift
//  English
//
//  Created by TaiTau on 14/04/2023.
//

import UIKit

protocol PresentedViewControllerDelegate: AnyObject {
    func pushToAnotherViewController()
    func review()
}
class FunctionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var vBackground: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tbvFunc: UITableView!
    
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    weak var delegate: PresentedViewControllerDelegate?
    var scoreUser: String = ""
    var listData: [FunctionModel] = [
        FunctionModel(lbname: "Bản đồ camera giám sát", iconButton: "map"),
        FunctionModel(lbname: "Thêm camera", iconButton: "video.fill.badge.plus"),
        FunctionModel(lbname: "Danh sách camera", iconButton: "camera.fill"),
        FunctionModel(lbname: "Danh sách người dùng", iconButton: "person.3.fill"),
        FunctionModel(lbname: "Danh sách video", iconButton: "video.fill"),
       
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tbvFunc.indexPathForSelectedRow {
            tbvFunc.deselectRow(at: selectedIndexPath, animated: true)
        }
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
            // Set it to true/false as needed to show or hide the tab bar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTbv()
        configUI()
    }
    
    fileprivate func configTbv() {
        self.tbvFunc.register(UINib(nibName: "FunctionTableViewCell", bundle: nil), forCellReuseIdentifier: "FunctionTableViewCell")
        if #available(iOS 15.0, *) {
            self.tbvFunc.sectionHeaderTopPadding = 0
        }
        tbvFunc.separatorStyle = .none
        tbvFunc.showsVerticalScrollIndicator = false
    } 
    
    fileprivate func configUI() {
        lblTitle.font = titleFont
        lblTitle.textColor = tintColor
    }
    // MARK: - Navigation
    
    @IBAction func actionBackHome(_ sender: Any) {
        self.dismiss(animated: true)
        delegate?.pushToAnotherViewController()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FunctionTableViewCell") as? FunctionTableViewCell else {
            return UITableViewCell();
        }
        let function = listData[indexPath.section];
        cell.setUp(imgName: function.iconButton, funcName: function.lbname)
        //cell.delegate = self
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
        return 48;
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            let vc = MapCamVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 1:
            let vc = AddCamera()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 2:
            let vc = ListCameraVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 3:
            let vc = ListUserVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 4:
            let vc = ListVideoVC()
            self.navigationController?.pushViewController(vc, animated: true)
            break;
            //        case 5 :
            //            let vc = WarehouseTransactionManagementVC()
            //            self.navigationController?.pushViewController(vc, animated: true)
            //            break;
            //        case 6:
            //            let vc = PromotionProgamVC()
            //            self.navigationController?.pushViewController(vc, animated: true)
            //            break;
            
        default:
            print("Error")
        }
    }
}
