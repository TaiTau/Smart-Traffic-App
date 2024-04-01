//
//  ListVideoVC.swift
//  English
//
//  Created by TaiTau on 03/01/2024.
//

import UIKit

class ListVideoVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tbvVideo: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    var lisData: [VideoModel] = []
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let titleFont = UIFont.boldSystemFont(ofSize: 24)
    var cameraList: [CameraModel] = []
    var listCamViewModel: ListVideoViewModel = ListVideoViewModel()
    
    func createSampleCameraData() -> Camera {
        let camera1 = CameraModel(id: "Admin", name: "Video_QL1.mp4", time: "01/12/2023", address: "Address 1",creator:"Tai",lat: 100.908,lng: 59.0904)
          let camera2 = CameraModel(id: "Nguyễn Quốc Cường", name: "Video_12122023.mp4", time: "22/12/2023", address: "Address 2",creator:"Tai",lat: 100.908,lng: 59.0904)
          let camera3 = CameraModel(id: "Trần Văn Hào", name: "Video_01012023.mp4", time: "01/01/2024", address: "Address 3",creator:"Tai",lat: 100.908,lng: 59.0904)

          return [camera1, camera2, camera3]
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listCamViewModel.getListCam(id: "")
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
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
            // Set it to true/false as needed to show or hide the tab bar
        }
    }
    
    func bindViewModel() {
        listCamViewModel.complete! = { [weak self] result in
            if(result == nil){
                self?.lisData = (self?.listCamViewModel.listCamera)!
                self?.tbvVideo.reloadData()
            }
        } 
        
        listCamViewModel.completeDel! = { [weak self] result in
            if(result == nil){
                let alertController = UIAlertController(title: "Xóa video thành công", message: "", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Lỗi", message: "Xóa video thất bại", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func configData(){
        cameraList = createSampleCameraData()
    }

    
    fileprivate func configUI() {
        lblTitle.font = titleFont
        lblTitle.textColor = tintColor
    }

    fileprivate func configTbv() {
        self.tbvVideo.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCell")
        if #available(iOS 15.0, *) {
            self.tbvVideo.sectionHeaderTopPadding = 0
        }
        tbvVideo.separatorStyle = .none
        tbvVideo.showsVerticalScrollIndicator = false
    }
    
    func deleteCell(at indexPathToDelete: IndexPath) {
        listCamViewModel.delVideo(id: lisData[indexPathToDelete.section].VIDEO_ID)
        guard indexPathToDelete.section < lisData.count else {
               return // Handle invalid section index
           }

        lisData.remove(at: indexPathToDelete.section)
        tbvVideo.beginUpdates()
        tbvVideo.deleteRows(at: [indexPathToDelete], with: .automatic)
        tbvVideo.deleteSections(IndexSet(integer: indexPathToDelete.section), with: .automatic)
        tbvVideo.endUpdates()
    }

    
    @IBAction func actionBacl(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else {
            return UITableViewCell();
        }
        let function = lisData[indexPath.section];
        cell.setUp(user:function)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.lisData.count
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
extension ListVideoVC: VideoCellDelegate {
    func didChoose(cell: VideoTableViewCell, phone:String) {
        let indexPath = tbvVideo.indexPath(for: cell)
        deleteCell(at: indexPath!)
           
        if(!phone.isEmpty){
            //deleteCell(at: indexPath)
        }
    }
}
