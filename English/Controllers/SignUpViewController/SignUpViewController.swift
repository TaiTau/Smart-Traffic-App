//
//  SignUpViewController.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameTextField: ATCTextField!
    @IBOutlet var phoneNumberTextField: ATCTextField!
    @IBOutlet var passwordTextField: ATCTextField!
    @IBOutlet var emailTextField: ATCTextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet weak var tfAddress: ATCTextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    private let tintColor = UIColor(hexString: "#ff5a66")
    private let backgroundColor: UIColor = HelperDarkMode.mainThemeBackgroundColor
    private let textFieldColor = UIColor.black
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    
    var viewModel: SignUpViewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
      //  view.backgroundColor = backgroundColor
        bindViewModel()
        titleLabel.font = titleFont
        titleLabel.text = "Đăng ký"
        titleLabel.textColor = tintColor
        configTF(tf: nameTextField, Str: "Họ và tên")
        configTF(tf: emailTextField, Str: "E-mail")
        configTF(tf: phoneNumberTextField, Str: "Số điện thoại")
        configTF(tf: passwordTextField, Str: "Mật khẩu")
        configTF(tf: tfAddress, Str: "Địa chỉ")
 
        signUpButton.setTitle("Tạo tài khoản", for: .normal)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        signUpButton.configure(color: backgroundColor,
                               font: buttonFont,
                               cornerRadius: 40/2,
                               backgroundColor: UIColor(hexString: "#334D92"))

        self.hideKeyboardWhenTappedAround()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(tapGestureRecognizer)
        if(imgAvatar.image == UIImage(systemName: "person.circle")){
            btnDelete.isHidden = true
        }
        imgAvatar.layer.masksToBounds = true
        imgAvatar.layer.cornerRadius = 100
        registorNoti()
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
        imgAvatar.image = image
        self.imgAvatar.contentMode = .scaleAspectFill
//        let imageData = image.jpegData(compressionQuality: 0)
//        let imageBase64 = imageData!.base64EncodedString()
//        viewModel.media = imageBase64
        btnDelete.isHidden = false
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

    func configTF(tf: UITextField, Str:String){
        tf.configure(color: textFieldColor,
                                       font: textFieldFont,
                                       cornerRadius: 40/2,
                                       borderColor: textFieldBorderColor,
            backgroundColor: backgroundColor,
            borderWidth: 1.0)
        tf.placeholder = Str
        tf.clipsToBounds = true
        if(tf == passwordTextField){
            tf.isSecureTextEntry = true
        }
    }
    
    func bindViewModel() {
        viewModel.complete! = { [weak self] result in
            if(result == nil){
                let alertController = UIAlertController(title: "Thông báo", message: "Đăng ký tài khoản thành công", preferredStyle: .alert)
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
    
    func isValidVietnamesePhoneNumber(_ phoneNumber: String) -> Bool {
        // Regular expression pattern to match a Vietnamese phone number
        let phoneNumberRegex = #"^(03[2-9]|05[6-9]|07[0-9]|08[1-6]|09[0-9])\d{7}$"#

        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }

    @IBAction func deleteImg(_ sender: Any) {
        imgAvatar.image = UIImage(systemName: "person.circle")
        btnDelete.isHidden = true
    }
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func didTapSignUpButton() {
        if(self.validate()){
//            viewModel.signUp(phone: phoneNumberTextField.text!, password: passwordTextField.text!, email: emailTextField.text!, name: nameTextField.text!, address: tfAddress.text!)
            viewModel.uploadProfileToServer(image: imgAvatar.image!, name: nameTextField.text!, phone: phoneNumberTextField.text!, email: emailTextField.text!,password:passwordTextField.text!,address:tfAddress.text!)
        }
    }

    func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Regular expression pattern for validating an email address
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func alertAndReturn(mess:String) -> Bool{
        let alertController = UIAlertController(title: nil, message: mess, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        return false
    }
   
    
    func validate() -> Bool {
        if(nameTextField.text == ""){
            return alertAndReturn(mess:"Vui lòng nhập họ và tên")
        }
        
        if(phoneNumberTextField.text == ""){
            return alertAndReturn(mess:"Vui lòng nhập số điện thoại")
        }
        
        if !isValidVietnamesePhoneNumber(phoneNumberTextField.text ?? "") {

            return alertAndReturn(mess:"Số điện thoại không đúng định dạng. Vui lòng nhập lại")
        }
        
        if(emailTextField.text == "" ){
            return alertAndReturn(mess: "Vui lòng nhập email")
        }
        
        if !isValidEmail(emailTextField.text ?? "") {
            return alertAndReturn(mess: "Email không đúng định dạng. Vui lòng nhập lại")
        }
       
        if (passwordTextField.text == ""){
            return alertAndReturn(mess: "Vui lòng nhập mật khẩu")
        }
      
        if(passwordTextField.text?.count ?? 0 < 8){
            return alertAndReturn(mess: "Mật khẩu bắt buộc dài hơn 8 ký tự")
        }
        
        return true
    }
}
