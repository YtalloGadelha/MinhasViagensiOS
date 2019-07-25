//
//  ArmazenamentoDados.swift
//  Minhas Viagens
//
//  Created by Ytallo on 15/07/19.
//  Copyright © 2019 CursoiOS. All rights reserved.
//

import UIKit

class ArmazenamentoDados{
    
    let chaveArmazenamento = "locaisViagem"
    var viagens: [ Dictionary<String, String> ] = []
    
    func getDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func salvarViagem(viagem: Dictionary<String,String>){
        
        viagens = listarViagens()
        
        viagens.append(viagem)
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        getDefaults().synchronize()
    }
    
    func listarViagens() -> [ Dictionary<String, String> ] {
        
        let dados = getDefaults().object(forKey: chaveArmazenamento)
        if dados != nil{
            return dados as! Array
            
        }else{
            return []
        }
    }
    
    func removerViagem(indice: Int) {
        
        viagens = listarViagens()        
        viagens.remove(at: indice)
        
        getDefaults().set(viagens, forKey: chaveArmazenamento)
        getDefaults().synchronize()
        
    }
}
