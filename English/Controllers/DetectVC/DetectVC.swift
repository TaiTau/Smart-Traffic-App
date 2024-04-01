//
//  DetectVC.swift
//  English
//
//  Created by TaiTau on 01/01/2024.
//

import UIKit
import AVFoundation
import AVKit

class DetectVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var videoPlayerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewControll: UIView!
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tbvImage: UITableView!
    @IBOutlet weak var stackCtrView: UIStackView!
    @IBOutlet weak var img10SecBack: UIImageView!{
        didSet {
            self.img10SecBack.isUserInteractionEnabled = true
            self.img10SecBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap10SecBack)))
        }
    }
    
    @IBOutlet weak var imgPlay: UIImageView!{
        didSet {
            self.imgPlay.isUserInteractionEnabled = true
            self.imgPlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapPlayPause)))
        }
    }
    
    @IBOutlet weak var img10SecFor: UIImageView!{
        didSet {
            self.img10SecFor.isUserInteractionEnabled = true
            self.img10SecFor.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap10SecNext)))
        }
    }
    
    
    
    var viewModel: ImageViewModel = ImageViewModel()
    var cameraList: [CameraModel] = []
    var imageList: [ImageModel] = []
    var videoid :Int = 0
    @IBOutlet weak var lbTotalTime: UILabel!
    @IBOutlet weak var lbCurrentTime: UILabel!
    
    func bindViewModel() {
        viewModel.completeDel! = { [weak self] result in
            if(result == nil){
                self?.imageList = (self?.viewModel.listImage)!
                self?.tbvImage.reloadData()
            }
        }
    }
    
    
    @IBOutlet weak var seekSlider: UISlider!{
        didSet {
            self.seekSlider.addTarget(self, action: #selector(onTapToSlide), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var imgFullScreenToggle: UIImageView!{
        didSet {
            self.imgFullScreenToggle.isUserInteractionEnabled = true
            self.imgFullScreenToggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapToggleScreen)))
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getImage(id: String(videoid))
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTbv()
        tapToView()
        bindViewModel()
        imgFullScreenToggle.isHidden = true
        if let tabBarController = self.tabBarController {
            tabBarController.tabBar.isHidden = true
        }
    }
    
    private var player : AVPlayer? = nil
    private var playerLayer : AVPlayerLayer? = nil
    var transferTime = 5
    override func viewDidAppear(_ animated: Bool) {
        self.setVideoPlayer()
    }
    
    let videoURL = "\(NetworkConstants.shared.serverAddress)/url_video"
    var timer : Timer?
    
    private func setVideoPlayer() {
        guard let url = URL(string: videoURL) else { return }
        
        if self.player == nil {
            self.player = AVPlayer(url: url)
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.videoGravity = .resizeAspectFill
            self.playerLayer?.frame = self.viewControll.bounds
            self.playerLayer?.addSublayer(self.viewControll.layer)
            if let playerLayer = self.playerLayer {
                self.videoPlayer.layer.addSublayer(playerLayer)
            }
            //self.player?.play()
        }
        self.setObserverToPlayer()
    }
    
    func tapToView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
                viewControll.addGestureRecognizer(tapGesture)
                
                // Enable user interaction for yourView
        viewControll.isUserInteractionEnabled = true
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
            // Perform actions when yourView is tapped
            print("YourView was tapped!")
        stackCtrView.isHidden = false
        startTimer()
            // Add your custom logic here
        }
    
    private var windowInterface : UIInterfaceOrientation? {
        return self.view.window?.windowScene?.interfaceOrientation
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        guard let windowInterface = self.windowInterface else { return }
        if windowInterface.isPortrait ==  true {
            self.videoPlayerHeight.constant = 300
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.playerLayer?.removeFromSuperlayer()
                self.playerLayer?.frame = self.videoPlayer.layer.bounds
                self.videoPlayer.layer.addSublayer(self.playerLayer!)
            })
        } else {
            self.videoPlayerHeight.constant = self.view.layer.bounds.width
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.playerLayer?.removeFromSuperlayer()
                self.playerLayer?.frame = self.view.layer.bounds
                
                self.view.layer.addSublayer(self.playerLayer!)
            })
        }
        print(self.videoPlayerHeight.constant)
      
    }
    
    func startTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(self.transferTime), target: self, selector: #selector(self.hideStackView), userInfo: nil, repeats: true)
    }
    
    @objc func hideStackView(){
        stackCtrView.isHidden = true
        stopTimer()
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    
    private var timeObserver : Any? = nil
    private func setObserverToPlayer() {
        let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsed in
            self.updatePlayerTime()
        })
    }
    
    private func updatePlayerTime() {
        guard let currentTime = self.player?.currentTime() else { return }
        guard let duration = self.player?.currentItem?.duration else { return }
        
        let currentTimeInSecond = CMTimeGetSeconds(currentTime)
        let durationTimeInSecond = CMTimeGetSeconds(duration)
        
        if self.isThumbSeek == false {
            self.seekSlider.value = Float(currentTimeInSecond/durationTimeInSecond)
        }
        
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        
        var hours = value / 3600
        var mins =  (value / 60).truncatingRemainder(dividingBy: 60)
        var secs = value.truncatingRemainder(dividingBy: 60)
        var timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lbCurrentTime.text = "\(hoursStr):\(minsStr):\(secsStr)"
        
        hours = durationTimeInSecond / 3600
        mins = (durationTimeInSecond / 60).truncatingRemainder(dividingBy: 60)
        secs = durationTimeInSecond.truncatingRemainder(dividingBy: 60)
        timeformatter = NumberFormatter()
        timeformatter.minimumIntegerDigits = 2
        timeformatter.minimumFractionDigits = 0
        timeformatter.roundingMode = .down
        guard let hoursStr = timeformatter.string(from: NSNumber(value: hours)), let minsStr = timeformatter.string(from: NSNumber(value: mins)), let secsStr = timeformatter.string(from: NSNumber(value: secs)) else {
            return
        }
        self.lbTotalTime.text = "\(hoursStr):\(minsStr):\(secsStr)"
    }
    
    
    @objc private func onTap10SecNext() {
        guard let currentTime = self.player?.currentTime() else { return }
        let targetTime = CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: currentTime.timescale))
        self.player?.seek(to: targetTime, completionHandler: { completed in
            
        })
    }
    
    @objc private func onTap10SecBack() {
        guard let currentTime = self.player?.currentTime() else { return }
        let seekTime10Sec = CMTimeGetSeconds(currentTime).advanced(by: -10)
        let seekTime = CMTime(value: CMTimeValue(seekTime10Sec), timescale: 1)
        self.player?.seek(to: seekTime, completionHandler: { completed in
            
        })
    }
    
    @objc private func onTapPlayPause() {
        if self.player?.timeControlStatus == .playing {
            self.imgPlay.image = UIImage(systemName: "pause.circle")
            self.player?.pause()
        } else {
            self.imgPlay.image = UIImage(systemName: "play.circle")
            self.player?.play()
        }
    }
    
    private var isThumbSeek : Bool = false
    @objc private func onTapToSlide() {
        self.isThumbSeek = true
        guard let duration = self.player?.currentItem?.duration else { return }
        let value = Float64(self.seekSlider.value) * CMTimeGetSeconds(duration)
        if value.isNaN == false {
            let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
            self.player?.seek(to: seekTime, completionHandler: { completed in
                if completed {
                    self.isThumbSeek = false
                }
            })
        }
    }
    
    @objc private func onTapToggleScreen() {
        if #available(iOS 16.0, *) {
            guard let windowSceen = self.view.window?.windowScene else { return }
            if windowSceen.interfaceOrientation == .portrait {
                windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) { error in
                    print(error.localizedDescription)
                }
            } else {
                windowSceen.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
                    print(error.localizedDescription)
                }
            }
        } else {
            if UIDevice.current.orientation == .portrait {
                let orientation = UIInterfaceOrientation.landscapeRight.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            } else {
                let orientation = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(orientation, forKey: "orientation")
            }
        }
        
        
    }
    
    
    fileprivate func configTbv() {
        self.tbvImage.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        if #available(iOS 15.0, *) {
            self.tbvImage.sectionHeaderTopPadding = 0
        }
        tbvImage.separatorStyle = .none
        tbvImage.showsVerticalScrollIndicator = false
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Navigation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: - Tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell else {
            return UITableViewCell();
        }
        let function = imageList[indexPath.section];
        cell.setup(cam:function, index: indexPath)
        cell.selectionStyle = .none
        //cell.delegate = self
        return cell;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return imageList.count
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
