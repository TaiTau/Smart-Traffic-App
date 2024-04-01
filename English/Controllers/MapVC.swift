//
//  MapVC.swift
//  Traffic-Light App
//
//  Created by TaiTau on 05/01/2024.
//

import UIKit
import MapboxGeocoder
import Mapbox

protocol AddProductVCDelegate {
    func didComplete(vc: MapVC, lat: String, lng: String)
}
class MapVC: UIViewController,MGLMapViewDelegate {
    @IBOutlet var mapView: UIView!
    var mapViewVT: MGLMapView!
    public var delegate: AddProductVCDelegate?
    var style: MGLStyle!
    var selectedLatLng: LatLng?
    var Zoom: Double = 15
    @IBOutlet weak var btnSave: UIButton!
    
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
        initMap()
        configBtn()
    }
    
    func createButtonMyLocationByManual(frame: CGRect) -> UIButton {
            let btnMyLocation = UIButton(frame: frame)
            btnMyLocation.setImage(UIImage(named: "vtmap_ic_btn_gps"), for: .normal)
            btnMyLocation.layer.cornerRadius = 5
            btnMyLocation.layer.borderColor = UIColor.black.cgColor
            btnMyLocation.layer.borderWidth = 1.0
            return btnMyLocation
        }
    
    func configBtn(){
        btnSave.layer.cornerRadius = 6
        btnSave.clipsToBounds = true
    }

    func initMap() {
        mapViewVT = MGLMapView(frame: view.bounds)
        mapViewVT.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapViewVT.delegate = self

        mapViewVT.showsUserLocation = true
        mapView.addSubview(mapViewVT)
        mapView.sendSubviewToBack(mapViewVT)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        mapViewVT.addGestureRecognizer(singleTapGesture)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        let btnMyLocation = createButtonMyLocationByManual(frame: CGRect(x: UIScreen.main.bounds.size.width - 50,
                                                                                  y: UIScreen.main.bounds.size.height - 220,
                                                                                  width: 40, height: 40))
        btnMyLocation.addTarget(self, action: #selector(getCurrentMyLocation), for: .touchUpInside)
        button.backgroundColor = .clear
        mapViewVT.addSubview(btnMyLocation)
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(setCurrentLatLng), userInfo: nil, repeats: false)
        getCurrentMyLocation()
        mapView.addSubview(mapViewVT)
    }
    
    @objc func setCurrentLatLng() {
        if let selectedLatLng = self.selectedLatLng {
            addMarkerWithLatLng(latLng: selectedLatLng)
        }
    }

    func addMarkerWithLatLng(latLng: LatLng?) {
        if let latLng = latLng, latLng.longitude > 0 {
            clearMBAnnotation()
            addMapboxMarker(coordinate: CLLocationCoordinate2D(latitude: latLng.latitude, longitude: latLng.longitude), markerIcon: UIImage(named: "icon_flag")!, identifier: "1")
            selectedLatLng = latLng
            print(latLng)
        }
    }
    
    func clearMBAnnotation() {
        if let layer = style.layer(withIdentifier: "1"), let source = style.source(withIdentifier: "1") {
            style.removeLayer(layer)
            style.removeSource(source)
        }
        
        if let selectedAnnotation = mapViewVT.selectedAnnotations.first {
            mapViewVT.deselectAnnotation(selectedAnnotation, animated: false)
        }
        if((mapViewVT.annotations) != nil){
            mapViewVT.removeAnnotations(mapViewVT.annotations!)
        }
    }

    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        clearMBAnnotation()
    
        var tapLocation = recognizer.location(in: view)
        tapLocation.x += +25 // icon size 48x48 so divide by 2 to place at click position
              tapLocation.y += -18 //
        
        let tapCoordinate = mapViewVT.convert(tapLocation, toCoordinateFrom: nil)
        addMapboxMarker(coordinate: CLLocationCoordinate2D(latitude: tapCoordinate.latitude, longitude: tapCoordinate.longitude), markerIcon: UIImage(named: "icon_flag")!, identifier: "1")
        
        selectedLatLng = LatLng(latitude: 0, longitude: 0)
        selectedLatLng!.latitude = tapCoordinate.latitude
        selectedLatLng!.longitude = tapCoordinate.longitude
        print(tapCoordinate)
        self.delegate?.didComplete(vc: self, lat: "\(tapCoordinate.latitude)",lng: "\(tapCoordinate.longitude)")
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSave(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func getCurrentMyLocation() {

       
        if let userLocationCoordinate = mapViewVT.userLocation?.location?.coordinate {
            
            mapViewVT.showsUserLocation = true
            mapViewVT.setCenter(userLocationCoordinate, zoomLevel: Zoom, animated: true)
        }else{
//            let myLocation = CLLocationCoordinate2D(latitude: 21.04656821656774, longitude: 105.7849328676294)
//            
//            mapViewVT.showsUserLocation = true
//            mapViewVT.setCenter(myLocation, zoomLevel: Zoom, animated: true)
        }
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        self.style = style
            if let selectedLatLng = self.selectedLatLng {
                if selectedLatLng.latitude > 0.0 && selectedLatLng.longitude > 0.0 {
                    addMapboxMarker(coordinate:CLLocationCoordinate2D(latitude: selectedLatLng.latitude, longitude: selectedLatLng.longitude), markerIcon: UIImage(named: "icon_flag.png")!, identifier: "1")
                    mapViewVT.setCenter(CLLocationCoordinate2D(latitude: selectedLatLng.latitude, longitude: selectedLatLng.longitude), zoomLevel: 14, animated: true)
                } else {
                    if let userLocationCoordinate = mapViewVT.userLocation?.location?.coordinate {
                        mapViewVT.setCenter(userLocationCoordinate, zoomLevel: Zoom, animated: true)
                        getCurrentMyLocation()
                    }
                }
            } else {
                if let userLocationCoordinate = mapViewVT.userLocation?.location?.coordinate {
                    mapViewVT.setCenter(userLocationCoordinate, zoomLevel: Zoom, animated: true)
                    getCurrentMyLocation()
                }
            }
    }
    
    func addMapboxMarker(coordinate: CLLocationCoordinate2D, markerIcon: UIImage, identifier: String) {
        var featureProperties: [String: Any] = [:]
        featureProperties["identifier"] = identifier
        
        let feature = MGLPointFeature()
        feature.coordinate = coordinate
        feature.title = identifier
        feature.attributes = featureProperties
        
        style.setImage(markerIcon, forName: identifier)
        
        var shapeSource = style.source(withIdentifier: identifier)
        if shapeSource == nil {
            shapeSource = MGLShapeSource(identifier: identifier, shape: feature, options: nil)
            style.addSource(shapeSource!)
        }
        
        if style.layer(withIdentifier: identifier) == nil {
            let shapeLayer = MGLSymbolStyleLayer(identifier: identifier, source: shapeSource!)
            shapeLayer.iconImageName = NSExpression(forConstantValue: identifier)
            style.addLayer(shapeLayer)
        }
    }
}
