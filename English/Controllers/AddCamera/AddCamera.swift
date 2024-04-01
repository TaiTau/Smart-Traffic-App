//
//  AddCamera.swift
//  English
//
//  Created by TaiTau on 30/12/2023.
//

import UIKit

class AddCamera: UIViewController, UITextViewDelegate {

    private let tintColor = UIColor(hexString: "#ff5a66")
    private let titleFont = UIFont.boldSystemFont(ofSize: 24)
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfCameraName: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfLng: UITextField!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var tfNote: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    var viewModel: AddCameraViewModel = AddCameraViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        registorNoti()
        bindViewModel()
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func bindViewModel() {
        viewModel.complete! = { [weak self] result in
            if(result == nil){
                let alertController = UIAlertController(title: "Thông báo", message: "Thêm camera thành công", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{_ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                self?.present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Thông báo", message: "Thêm camera thất bại", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{_ in
                    //self?.navigationController?.popViewController(animated: true)
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func configUI() {
        lblTitle.font = titleFont
        lblTitle.textColor = tintColor
        view.bringSubviewToFront(btnBack)
        navigationItem.hidesBackButton = true
        btnSave.layer.cornerRadius = 10
        btnSave.clipsToBounds = true
        
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
    
     @IBAction func actionBack(_ sender: Any) {
         self.navigationController?.popViewController(animated: false)
     }
  
    @IBAction func actionSave(_ sender: Any) {
        if(validate()){
            
            viewModel.addCamera( name: tfCameraName.text!, address: tfAddress.text!, lat: Double(tfLat.text!)!, lng: Double(tfLng.text!)!, note: tfNote.text)
        }
        print("save")
    }
    
    func alertAndReturn(mess:String) -> Bool{
        let alertController = UIAlertController(title: nil, message: mess, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        return false
    } 
    
    func registorNoti() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func actionMap(_ sender: Any) {
        let vc = MapVC()
        if(tfLat.text != ""){
            let selectedLatLng = LatLng(latitude: Double(tfLat.text!)!, longitude:  Double(tfLng.text!)!)
            vc.selectedLatLng = selectedLatLng
        }
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    func validate() -> Bool {
        if(tfCameraName.text == ""){
            return alertAndReturn(mess:"Vui lòng nhập tên camera")
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
}
extension AddCamera: AddProductVCDelegate {
    func didComplete(vc: MapVC, lat: String, lng: String) {
        tfLat.text = lat
        tfLng.text = lng
    }
    
    
}
