//
//  UserInfomationVC.swift
//  English
//
//  Created by TaiTau on 14/04/2023.
//

import UIKit

class UserInfomationVC: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var idUser: UILabel!
    @IBOutlet weak var emailUser: UILabel!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var btnLogOut: UIButton!
    
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var tfID: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let titleFont = UIFont.boldSystemFont(ofSize: 20)
    var rawImage:UIImage?
    var viewModel: SignUpViewModel = SignUpViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.hidesBackButton = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bindViewModel()
    }

    func configUI(){
        lblInfo.font = titleFont
        lblInfo.textColor = tintColor
        configBtn()
        configData()
        registorNoti()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped() {
        actionSheet()
    }
    
    fileprivate func actionSheet(){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionCamera = UIAlertAction(title: "Chụp hình", style: .default, handler: {_ in
            self.openCamera()
        })
        let actionGallery = UIAlertAction(title: "Chọn từ bộ sưu tập ảnh", style: .default, handler: {_ in
            self.openGallery()
        })
        let actionCancel = UIAlertAction(title: "Hủy", style: .default, handler: {_ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        actionGallery.setValue(UIColor(red: 0x03, green: 0x7B, blue: 0x64), forKey: "titleTextColor")
        actionCamera.setValue(UIColor(red: 0x03, green: 0x7B, blue: 0x64), forKey: "titleTextColor")
        actionCancel.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(actionGallery)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: Override
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imgUser.image = image
        self.imgUser.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func openCamera(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    fileprivate func openGallery(){
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
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

                        let textViewMaxY = tfAddress.frame.maxY
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
    
    func configData(){
        
        tfID.text = Utility.getKeyValue(identifier: "USER_ID")
        tfName.text = Utility.getKeyValue(identifier: "NAME")
        tfPhone.text = Utility.getKeyValue(identifier: "PHONE")
        tfEmail.text = Utility.getKeyValue(identifier: "EMAIL")
        tfAddress.text = Utility.getKeyValue(identifier: "ADDRESS")
        let url = "\(NetworkConstants.shared.serverAddress)\(Utility.getKeyValue(identifier: "URL_AVATAR")!)"
        imgUser.load(urlString:url)
        rawImage = imgUser.image
        imgUser.layer.masksToBounds = true
        imgUser.layer.cornerRadius = 65
        self.imgUser.contentMode = .scaleAspectFill
    }
    
    func configBtn(){
        btnLogOut.layer.cornerRadius = 6
        btnLogOut.clipsToBounds = true
        
        btnUpdate.layer.cornerRadius = 6
        btnUpdate.clipsToBounds = true
    
    }
    
    func bindViewModel() {
        viewModel.complete! = { [weak self] result in
            if(result == nil){
                self?.tfName.resignFirstResponder()
                self?.tfEmail.resignFirstResponder()
                self?.tfAddress.resignFirstResponder()
                self?.tfPhone.resignFirstResponder()
                let alertController = UIAlertController(title: "Thông báo", message: "Cập nhật thông tin thành công", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler:{_ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                self?.present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Lỗi", message: result?.detail, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actionLogOut(_ sender: Any) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let rootViewController = appDelegate.window?.rootViewController as? UINavigationController {
                rootViewController.popToRootViewController(animated: true)
            }
    }
    
    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionUpdate(_ sender: Any) {
        if(self.validate()){
            viewModel.updateProfileToServer(image:imgUser.image!,rawImage: rawImage!, name: tfName.text!, phone: tfPhone.text!,  email: tfEmail.text!, address: tfAddress.text!)
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for validating an email address
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alertAndReturn(mess:String) -> Bool{
        let alertController = UIAlertController(title: nil, message: mess, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        return false
    }
   
    func isValidVietnamesePhoneNumber(_ phoneNumber: String) -> Bool {
        // Regular expression pattern to match a Vietnamese phone number
        let phoneNumberRegex = #"^(03[2-9]|05[6-9]|07[0-9]|08[1-6]|09[0-9])\d{7}$"#

        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    func validate() -> Bool {
        if(tfName.text == ""){
            return alertAndReturn(mess:"Vui lòng nhập họ và tên")
        }
        
        if(tfPhone.text == ""){
            return alertAndReturn(mess:"Vui lòng nhập số điện thoại")
        }
        
        if !isValidVietnamesePhoneNumber(tfPhone.text ?? "") {

            return alertAndReturn(mess:"Số điện thoại không đúng định dạng. Vui lòng nhập lại")
        }
        
        if(tfEmail.text == "" ){
            return alertAndReturn(mess: "Vui lòng nhập email")
        }
        
        if !isValidEmail(tfEmail.text ?? "") {
            return alertAndReturn(mess: "Email không đúng định dạng. Vui lòng nhập lại")
        }
       
        if (tfAddress.text == ""){
            return alertAndReturn(mess: "Vui lòng nhập địa chỉ")
        }
      
        return true
    }
}
