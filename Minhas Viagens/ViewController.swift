//
//  ViewController.swift
//  Minhas Viagens
//
//  Created by Ytallo on 15/07/19.
//  Copyright © 2019 CursoiOS. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {    
    
    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var viagem: Dictionary<String,String> = [:]
    var indiceSelecionado: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let indice = indiceSelecionado{
            
            if indice == -1{//adicionar
                
                configuraGerenciadorLocalizacao()

            }else{//listar
                
                exibirAnotacao(viagem: viagem)
            }
        }
        
        //reconhecedor de gestos
        let reconhecedorGesto = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:)))
        reconhecedorGesto.minimumPressDuration = 2
        
        mapa.addGestureRecognizer(reconhecedorGesto)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let local = locations.last!
        
        exibirLocal(latitude: local.coordinate.latitude, longitude: local.coordinate.longitude)
    }
    
    func exibirLocal(latitude: Double, longitude: Double){
        
        let localizacao = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao, span: span)
        self.mapa.setRegion(regiao, animated: true)
    }
    
    func exibirAnotacao(viagem: Dictionary<String,String>){
        
        if let localViagem = viagem["local"]{
            if let latitudeString = viagem["latitude"]{
                if let longitudeString = viagem["longitude"]{
                    if let latitude = Double(latitudeString){
                        if let longitude = Double(longitudeString){                          
                            
                            //adiciona anotação
                            let anotacao = MKPointAnnotation()
                            
                            anotacao.coordinate.latitude = latitude
                            anotacao.coordinate.longitude = longitude
                            anotacao.title = localViagem
                            
                            self.mapa.addAnnotation(anotacao)
                            
                            //exibe local
                            exibirLocal(latitude: latitude, longitude: longitude)
                            
                        }
                    }
                }
            }
        }
    }
    
    @objc func marcar(gesture: UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizer.State.began{
            
            //recupera as coordenadas do ponto selecionado
            let pontoSelecionado = gesture.location(in: self.mapa)
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            let localizacao = CLLocation(latitude: coordenadas.latitude, longitude: coordenadas.longitude)
            
            //recupera o endereço do ponto selecionado
            var localCompleto = "Endereço não encontrado!!!"
            CLGeocoder().reverseGeocodeLocation(localizacao) { (local, erro) in
                
                if erro == nil{
                    
                    if let dadosLocal = local?.first{
                        
                        if let nome = dadosLocal.name{
                            
                            localCompleto = nome
                        }else{
                            
                            if let endereco = dadosLocal.thoroughfare{
                                
                                localCompleto = endereco
                            }
                        }
                    }
                    
                    //salvar no dispositivo
                    self.viagem = ["local": localCompleto, "latitude": String(coordenadas.latitude), "longitude": String(coordenadas.longitude)]
                    ArmazenamentoDados().salvarViagem(viagem: self.viagem)
                    
                    //exibe anotação com os dados de endereço
                    self.exibirAnotacao(viagem: self.viagem)
                    
                }else{
                    print(erro)
                }
            }
        }
    }
    
    func configuraGerenciadorLocalizacao(){
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse{
            
            let alertaConfiguracao = UIAlertController(title: "Permissão de localização", message: "Necessário permissão para acesso à sua localização!!! Por favor habilite!", preferredStyle: .alert)
            
            let acaoConfiguracoes = UIAlertAction(title: "Abrir configurações", style: .default) { (alertaConfiguracoes) in
                
                if let configuracoes = NSURL(string: UIApplication.openSettingsURLString){
                    
                    UIApplication.shared.open(configuracoes as URL)
                }
            }
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertaConfiguracao.addAction(acaoConfiguracoes)
            alertaConfiguracao.addAction(acaoCancelar)
            
            present(alertaConfiguracao, animated: true, completion: nil)
        }
    }
    

}

