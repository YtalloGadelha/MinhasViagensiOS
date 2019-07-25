//
//  LocaisViagemViewController.swift
//  Minhas Viagens
//
//  Created by Ytallo on 15/07/19.
//  Copyright © 2019 CursoiOS. All rights reserved.
//

import UIKit

class LocaisViagemViewController: UITableViewController {

    var locaisViagens: [ Dictionary<String, String> ] = []
    var controleNavegacao = "adicionar"
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        controleNavegacao = "adicionar"
        atualizarViagens()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locaisViagens.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let viagem = locaisViagens[indexPath.row]["local"]
        let celulaReuso = "celulaReuso"
        
        let celula = tableView.dequeueReusableCell(withIdentifier: celulaReuso, for: indexPath)
        celula.textLabel?.text = viagem

        return celula
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete{
            
            ArmazenamentoDados().removerViagem(indice: indexPath.row)
            atualizarViagens()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.controleNavegacao = "listar"
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verLocal"{
            
            let viewControllerDestino = segue.destination as! ViewController
            
            if self.controleNavegacao == "listar"{
                
                if let indiceRecuperado = sender{
                    
                    let indice = indiceRecuperado as! Int
                    viewControllerDestino.viagem = locaisViagens[indice]
                    viewControllerDestino.indiceSelecionado = indice
                }
            }else{
                
                viewControllerDestino.viagem = [:]
                viewControllerDestino.indiceSelecionado = -1
            }
            
        }
        
    }
    
    func atualizarViagens() {
        locaisViagens = ArmazenamentoDados().listarViagens()
        tableView.reloadData()
    }
}
