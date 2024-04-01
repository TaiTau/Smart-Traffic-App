//
//  DetailCamVC.swift
//  English
//
//  Created by TaiTau on 30/12/2023.
//

import UIKit

class DetailCamVC: UIViewController, UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var historyView: UIView!
    
    @IBOutlet weak var tfCameraName: UITextField!
    @IBOutlet weak var tfCreator: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfLng: UITextField!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var tfNote: UITextView!
    @IBOutlet weak var tbvVideo: UITableView!
    
    var lisData: [VideoModel] = []
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let titleFont = UIFont.boldSystemFont(ofSize: 24)
    var cam:CameraModelAPI?
    var listCamViewModel: ListVideoViewModel = ListVideoViewModel()
    var addCamViewModel: AddCameraViewModel = AddCameraViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listCamViewModel.getListCam(id: "\(String( cam!.CAMERA_ID))")
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configButton(btn: btnInfo, btnHide: btnHistory)
        registorNoti()
        configData()
        bindViewModel()
    }
    
    func bindViewModel() {
        listCamViewModel.complete! = { [weak self] result in
            if(result == nil){
                self?.lisData = (self?.listCamViewModel.listCamera)!
                self?.tbvVideo.reloadData()
            }
        }
        
        addCamViewModel.complete! = { [weak self] result in
            if(result == nil){
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    fileprivate func configTbv() {
        self.tbvVideo.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "VideoTableViewCell")
        if #available(iOS 15.0, *) {
            self.tbvVideo.sectionHeaderTopPadding = 0
        }
        tbvVideo.separatorStyle = .none
        tbvVideo.showsVerticalScrollIndicator = false
    }
    
    func configUI(){
        configTbv()
        navigationItem.hidesBackButton = true
        lblTitle.font = titleFont
        lblTitle.textColor = tintColor
        navigationItem.hidesBackButton = true
        btnUpdate.layer.cornerRadius = 10
        btnUpdate.clipsToBounds = true
        historyView.isHidden = true
        
        tfNote.layer.borderWidth = 0.7
        tfNote.layer.borderColor = UIColor.opaqueSeparator.cgColor
        tfNote.layer.cornerRadius = 6
        tfNote.clipsToBounds = true
        
        tfNote.delegate = self
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
            // Set it to true/false as needed to show or hide the tab bar
        }
    }
    
    func configData(){
        tfCameraName.text = cam?.NAME
        tfCreator.text = cam?.CREATOR
        tfAddress.text = cam?.ADDRESS
        tfLat.text = String(format: "%f", cam!.LAT)
        tfLng.text = String(format: "%f", cam!.LNG)
        tfNote.text = cam!.NOTE
    }
    
    func registorNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self)
        }

      
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    if let window = UIApplication.shared.keyWindow {
                        let bottomPadding = window.safeAreaInsets.bottom
                        let keyboardHeight = keyboardSize.height - bottomPadding

                        let textViewMaxY = tfNote.frame.maxY
                        let keyboardY = UIScreen.main.bounds.height - keyboardHeight - 40 // Adjust this value to position the text view higher

                        if textViewMaxY > keyboardY {
                            let offsetY = textViewMaxY - keyboardY
                            UIView.animate(withDuration: 0.3) {
                                self.view.transform = CGAffineTransform(translationX: 0, y: -offsetY)
                            }
                        }
                    }
                }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }

    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configButton(btn:UIButton, btnHide: UIButton){
        btn.layer.borderColor = UIColor(hexString: "#CBD5FE").cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 6
        btn.clipsToBounds = true
        
        btnHide.layer.borderColor = UIColor.clear.cgColor
    }
    
    func alertAndReturn(mess:String) -> Bool{
        let alertController = UIAlertController(title: nil, message: mess, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        return false
    }
    
    func validate() -> Bool {
        if(tfCameraName.text == ""){
            return alertAndReturn(mess:"Vui lòng nhập tên camera")
        }
        
        if(tfCreator.text == ""){
            return alertAndReturn(mess:"Vui lòng nhập tên người thêm")
        }
        
        if (tfAddress.text == "") {

            return alertAndReturn(mess:"Vui lòng nhập địa chỉ camera")
        }
        
        if(tfLat.text == "" ){
            return alertAndReturn(mess: "Vui lòng nhập kinh độ")
        }
        
        if (tfLng.text == "") {
            return alertAndReturn(mess: "Vui lòng nhập vĩ độ")
        }
    
        return true
    }
    @IBAction func actionMap(_ sender: Any) {
        let vc = MapVC()
        if(tfLat.text != ""){
            var selectedLatLng = LatLng(latitude: Double(tfLat.text!)!, longitude:  Double(tfLng.text!)!)
            vc.selectedLatLng = selectedLatLng
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteCell(at indexPathToDelete: IndexPath) {
        guard indexPathToDelete.section < lisData.count else {
               return // Handle invalid section index
           }

        lisData.remove(at: indexPathToDelete.section)
        tbvVideo.beginUpdates()
        tbvVideo.deleteRows(at: [indexPathToDelete], with: .automatic)
        tbvVideo.deleteSections(IndexSet(integer: indexPathToDelete.section), with: .automatic)
        tbvVideo.endUpdates()
    }

    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
        if(validate()){
            addCamViewModel.updateCamera( name: tfCameraName.text!, address: tfAddress.text!, lat: Double(tfLat.text!)!, lng: Double(tfLng.text!)!, note: tfNote.text)
            print("save")
        }
       
    }
    
    @IBAction func actionInfo(_ sender: Any) {
        infoView.isHidden = false
        historyView.isHidden = true
        configButton(btn: btnInfo,btnHide: btnHistory)
    }
    
    @IBAction func actionHistory(_ sender: Any) {
        historyView.isHidden = false
        infoView.isHidden = true
        configButton(btn: btnHistory,btnHide: btnInfo)
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
extension DetailCamVC: AddProductVCDelegate {
    func didComplete(vc: MapVC, lat: String, lng: String) {
        tfLat.text = lat
        tfLng.text = lng
    }
}
extension DetailCamVC: VideoCellDelegate {
    func didChoose(cell: VideoTableViewCell, phone:String) {
        let indexPath = tbvVideo.indexPath(for: cell)
        deleteCell(at: indexPath!)
           
        if(!phone.isEmpty){
            //deleteCell(at: indexPath)
        }
    }
}
