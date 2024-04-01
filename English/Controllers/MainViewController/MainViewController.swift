//
//  MainViewController.swift
//  English
//
//  Created by TaiTau on 07/04/2023.
//

import UIKit
import AVKit

class MainViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var autoSuggestionView: SwiftAutoSuggestionView!
    @IBOutlet weak var tfCamera: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var btnVideo: UIButton!
    @IBOutlet weak var lbComplete: UIButton!
    @IBOutlet weak var viewInfoVideo: UIView!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lblVideoSize: UILabel!
    @IBOutlet weak var lblNameVideo: UILabel!
    
  
    var playerViewController = AVPlayerViewController()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var listData:[String] = []
    var listDataRaw:[String] = []
    var typeUpload: Int = 0  // 0: Upload video, 1: Send video
    //ViewModel
    var cameraId:Int = 0
    var videoID:Int = 0
    var nameVideo :String?
    var urlVideo:URL?
    var viewModel: MainViewModel = MainViewModel()
    var listCamViewModel: ListCameraViewModel = ListCameraViewModel()
    let containerView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let loadingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listCamViewModel.getListCam()
        bindViewModel()
        configView()
       // UPloadvideo()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        setupSuggestionView()
        tfCamera.delegate = self
        
        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
                containerView.center = view.center
                containerView.backgroundColor = UIColor.lightGray
                containerView.layer.cornerRadius = 10
                view.addSubview(containerView)

                // Set up the activity indicator
                activityIndicator.hidesWhenStopped = true
                activityIndicator.center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY - 10)
                containerView.addSubview(activityIndicator)

                // Set up the label
                loadingLabel.text = "Đang xử lý..."
                loadingLabel.textAlignment = .center
                loadingLabel.textColor = UIColor.darkGray
                loadingLabel.frame = CGRect(x: 0, y: activityIndicator.frame.maxY + 5, width: containerView.bounds.width, height: 20)
                containerView.addSubview(loadingLabel)
        containerView.isHidden = true
        
    }
    
    func UPloadvideo(){
        let videoURL = ""
        let videoId = Int.random(in: 1000..<10000)
        videoID = videoId
        let user_id = Utility.getKeyValue(identifier: "USER_ID")!
//        viewModel.uploadVideo(name:urlVideo,user_id:user_id,camera_id:String(cameraId),video_id:String(videoID), fileURL: videoURL, completion: {result in
//            if(result == nil){
//                DispatchQueue.main.async { [weak self] in
//                    self?.stopLoading()
//                    let vc = DetectVC()
//                   // vc.videoid = 9568677
//                    vc.videoid = self?.videoID ?? 0
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
//            }else{
//                
//            }
//        })

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = false
        }
        actionDeleteVideo(1)
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        autoSuggestionView.showSuggestion(with: filterArea(areas: listData, input: tfCamera.text!)! as NSArray)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        autoSuggestionView.hideSuggestion()
    }
    
    func bindViewModel() {
        listCamViewModel.complete! = { [weak self] result in
            if(result == nil){
                (self?.listCamViewModel.listCamera)!.enumerated().forEach({ (i, e) in
                        self?.listData.append(e.NAME);
                })
                 
                self?.listDataRaw = self?.listData ?? []
            }
        }
    }
    
    private func filterArea(areas: [String]?, input: String) -> [String]? {
        let input = input.stringFilter();
        if (!input.isEmpty) {
            var result: [String] = [];
           
            areas?.enumerated().forEach({ (i, e) in
                if(e.stringFilter().contains(input)) {
                    result.append(e);
                }
            })
            
            return result;
        } else {
            return areas;
        }
        
    }
    
    private func setupSuggestionView() {
        autoSuggestionView.delegate = self
    }
    
    func configView(){
        lblTitle.font =  UIFont.boldSystemFont(ofSize: 30)
        lblTitle.textColor =  UIColor(hexString: "#ff5a66")
        btnVideo.layer.cornerRadius = 6
        btnVideo.clipsToBounds = true
        
        //lbComplete
        lbComplete.layer.cornerRadius = 11
        lbComplete.clipsToBounds = true
        
        //viewInfoVideo
        viewInfoVideo.layer.cornerRadius = 5
        viewInfoVideo.clipsToBounds = true
        viewInfoVideo.layer.borderWidth = 0.7
        viewInfoVideo.layer.borderColor = UIColor.opaqueSeparator.cgColor
        viewInfoVideo.isHidden = true //hiden when not choose video
        
    }
    
    func selectVideo() {
        let videoPicker = UIImagePickerController()
        videoPicker.sourceType = .photoLibrary
        videoPicker.mediaTypes = ["public.movie"]
        videoPicker.delegate = self
        present(videoPicker, animated: true, completion: nil)
        
    }
    
    
    func startLoading() {
        view.addSubview(containerView)
        activityIndicator.startAnimating()
        containerView.isHidden = false
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
        containerView.isHidden = true
    }
    
    @IBAction func textFieldEditingChange(_ sender: Any) {
        autoSuggestionView.showSuggestion(with: filterArea(areas: listData, input: tfCamera.text!)! as NSArray)
    }
    // Delegate method to handle the selected video
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[.mediaURL] as? URL {
            // Use the videoURL to access the selected video
            print("Selected video URL: \(videoURL)")
            showVideo(withURL: videoURL)
            self.urlVideo = videoURL
            self.nameVideo = videoURL.lastPathComponent
            
            self.lblNameVideo.text = "VIDEO_\(videoID).MOV"
            let videoSize = getFileSize(url: videoURL)!
            let formattedNumber = String(format: "%.3f", videoSize)
            self.lblVideoSize.text = "\(formattedNumber) MB"
            //let videoIdUP = Int.random(in: 0..<10000000)
            //videoID = videoId
            
        }
        picker.dismiss(animated: true, completion: nil)
        viewInfoVideo.isHidden = false
        btnVideo.setTitle("Gửi", for: .normal)
        typeUpload = 1
       
    }
    
    func getFileSize(url: URL) -> Double? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            if let fileSize = attributes[FileAttributeKey.size] as? Double {
                // Convert bytes to megabytes
                let fileSizeInMB = fileSize / (1024 * 1024)
                return fileSizeInMB
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    // Delegate method to handle cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func showVideo(withURL videoURL: URL) {
        generateThumbnail(from: videoURL) { thumbnailImage in
            if let thumbnailImage = thumbnailImage {
                DispatchQueue.main.async {
                    self.imgThumb.image = thumbnailImage
                    self.imgThumb.layer.cornerRadius = 10
                    self.imgThumb.layer.masksToBounds = true
                    self.imgThumb.clipsToBounds = true
                }
            } else {
                print("Failed to generate thumbnail")
            }
        }
        }
    
    func generateThumbnail(from videoURL: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: 1.0, preferredTimescale: 60)
        assetImgGenerate.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, _, _ in
            if let image = image {
                let thumbnail = UIImage(cgImage: image)
                completion(thumbnail)
            } else {
                completion(nil)
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        
    }
    @IBAction func actionDeleteVideo(_ sender: Any) {
        viewInfoVideo.isHidden = true
        btnVideo.setTitle("Chọn video", for: .normal)
        typeUpload = 0
    }
    
    @IBAction func uploadVideo(_ sender: Any) {
        if(typeUpload == 0){
            selectVideo()
        }else{
            if(cameraId == 0 ){
                let alertController = UIAlertController(title: nil, message: "Vui lòng chọn camera", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }else{
                startLoading()
                let videoURL = ""
                let videoId = Int.random(in: 1000..<10000)
                videoID = videoId
                let user_id = Utility.getKeyValue(identifier: "USER_ID")!
                viewModel.uploadVideo(name:nameVideo!,user_id:user_id,camera_id:String(cameraId),video_id:String(videoID), fileURL: urlVideo!, completion: {result in
                    if(result == nil){
                        DispatchQueue.main.async { [weak self] in
                            self?.stopLoading()
                            let vc = DetectVC()
                           // vc.videoid = 9568677
                            vc.videoid = self?.videoID ?? 0
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        
                    }
                })
                
            }
            
        }
    }
    
    func alertAndReturn(mess:String) -> Bool{
        let alertController = UIAlertController(title: nil, message: mess, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        return false
    }
    
 
}

extension MainViewController: SwiftAutoSuggestionDelegate {
    func swiftAutosuggestionDidSelectCell(with data: Any,cell index:IndexPath) {
        //Use the data
       // resultLabel.text = data as? String
        //Hide the suggestion
        print(index.row)
       
        self.view.endEditing(true)
        cameraId = listCamViewModel.listCamera[index.row].CAMERA_ID
        tfCamera.text = data as? String
        autoSuggestionView.hideSuggestion()
    }
}
