//
//  LoginVC.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var contactPointTextField: ATCTextField!
    @IBOutlet weak var passwordTextField: ATCTextField!
    private let backgroundColor = HelperDarkMode.mainThemeBackgroundColor
    private let tintColor = UIColor(hexString: "#ff5a66")
    
    private let titleFont = UIFont.boldSystemFont(ofSize: 30)
    private let buttonFont = UIFont.boldSystemFont(ofSize: 20)
    
    private let textFieldFont = UIFont.systemFont(ofSize: 16)
    private let textFieldColor = UIColor.black
    private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
    
    private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
    private let separatorTextColor = UIColor(hexString: "#464646")
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        contactPointTextField.text = "0397528977"
        passwordTextField.text = "123456789"
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func didTapBackButton() {
      self.navigationController?.popViewController(animated: true)
    }
    
    func bindViewModel() {
        viewModel.complete! = { [weak self] result in
            if(result == nil){
                let vc = MainTabBarViewController()
                self?.navigationController?.pushViewController(vc, animated: false)
            }else{
                let alertController = UIAlertController(title: "Lỗi", message: result?.detail, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func didTapLoginButton() {
        if(self.validate()){
            viewModel.login(phone: contactPointTextField.text ?? "", password: passwordTextField.text ?? "")
        }
////        
//        let vc = MainTabBarViewController()
//        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func pushToSignUP(_ sender: Any) {
        //if(self.validate()){
            let vc = SignUpViewController()
            self.navigationController?.pushViewController(vc, animated: false)
        //}
    }
    
    func alertAndReturn(mess:String) -> Bool{
        let alertController = UIAlertController(title: nil, message: mess, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        return false
    }
    
    func validate() -> Bool {
        if(contactPointTextField.text == ""){
            return alertAndReturn(mess: "Vui lòng nhập tài khoản")
        }
        
        if (passwordTextField.text == ""){
            return alertAndReturn(mess: "Vui lòng nhập mật khẩu")
        }

        return true
    }
    
      func display(alertController: UIAlertController) {
        self.present(alertController, animated: true, completion: nil)
      }
    
    func setupUI(){
        //view.backgroundColor = backgroundColor
        backButton.tintColor = UIColor(hexString: "#282E4F")
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        titleLabel.font = titleFont
        titleLabel.text = "Đăng nhập"
        titleLabel.textColor = tintColor
        
        contactPointTextField.configure(color: textFieldColor,
                                        font: textFieldFont,
                                        cornerRadius: 55/2,
                                        borderColor: textFieldBorderColor,
                                        backgroundColor: backgroundColor,
                                        borderWidth: 1.0)
        contactPointTextField.placeholder = "Tài khoản"
        contactPointTextField.textContentType = .emailAddress
        contactPointTextField.clipsToBounds = true
        
        passwordTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 55/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
        passwordTextField.placeholder = "Mật khẩu"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .emailAddress
        passwordTextField.clipsToBounds = true
        
        separatorLabel.font = separatorFont
        separatorLabel.textColor = separatorTextColor
        separatorLabel.text = "hoặc"
        
        loginButton.setTitle("Đăng nhập", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        loginButton.configure(color: backgroundColor,
                              font: buttonFont,
                              cornerRadius: 55/2,
                              backgroundColor: tintColor)
        
        facebookButton.setTitle("Đăng ký", for: .normal)
        //facebookButton.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
        facebookButton.configure(color: backgroundColor,
                                 font: buttonFont,
                                 cornerRadius: 55/2,
                                 backgroundColor: UIColor(hexString: "#334D92"))
        self.hideKeyboardWhenTappedAround()
    }
      
    }
    
    extension LoginVC {
      
      func showPopup(isSuccess: Bool) {
        let successMessage = "User was sucessfully logged in."
        let errorMessage = "Something went wrong. Please try again"
        let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
  }
