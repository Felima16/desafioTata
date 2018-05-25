//
//  DetailsViewController.swift
//  DesafioTata
//
//  Created by Fernanda de Lima on 24/05/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titlefund: UILabel!
    @IBOutlet weak var fundName: UILabel!
    @IBOutlet weak var whatIs: UILabel!
    @IBOutlet weak var defination: UILabel!
    @IBOutlet weak var riskTitle: UILabel!
    @IBOutlet weak var risk: UILabel!
    @IBOutlet weak var moreInfo: UIButton!
    
    @IBOutlet weak var moreInfoView: UIView!
    @IBOutlet weak var mesFund: UILabel!
    @IBOutlet weak var mesCDI: UILabel!
    @IBOutlet weak var anualFund: UILabel!
    @IBOutlet weak var anualCDI: UILabel!
    @IBOutlet weak var dozeFund: UILabel!
    @IBOutlet weak var dozeCDI: UILabel!
    
    @IBOutlet weak var infoTable: UITableView!
    
    @IBAction func moreInfoAction(_ sender: Any) {
        moreInfoView.isHidden = !moreInfoView.isHidden
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        moreInfoView.layer.borderColor = UIColor.black.cgColor
        moreInfoView.layer.borderWidth = 1
        moreInfoView.layer.cornerRadius = 10
        
        moreInfo.layer.borderColor = UIColor.blue.cgColor
        moreInfo.layer.borderWidth = 1
        moreInfo.layer.cornerRadius = 10
        
        loadAtivos()
    }
    
    private func loadAtivos(){
        API.get(AtivoFinanceiro.self, url: "https://floating-mountain-50292.herokuapp.com/fund.json", finish: {
            print("acabou")
        }, success: { (item) in
            mm.ativos = item
            self.preencherAtivos()
        }) { (error, code) in
            print("--- ERROR \(error.localizedDescription) --- CODE \(code ?? 0)")
        }
    }
    
    private func preencherAtivos(){
        if let screen = mm.ativos?.screen{
            titlefund.text = screen.title
            fundName.text = screen.fundName
            whatIs.text = screen.whatIs
            defination.text = screen.definition
            riskTitle.text = screen.riskTitle
            risk.text = "\(screen.risk ?? 0)"
            mesFund.text = "\(screen.moreInfo?.month?.fund ?? 0)"
            mesCDI.text = "\(screen.moreInfo?.month?.CDI ?? 0)"
            anualFund.text = "\(screen.moreInfo?.year?.fund ?? 0)"
            anualCDI.text = "\(screen.moreInfo?.year?.CDI ?? 0)"
            dozeFund.text = "\(screen.moreInfo?.dozeMonths?.fund ?? 0)"
            dozeCDI.text = "\(screen.moreInfo?.dozeMonths?.CDI ?? 0)"
            moreInfo.setTitle(screen.infoTitle, for: .normal)
            
            infoTable.reloadData()
        }
        
    }

}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mm.ativos != nil ? 2 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let info = mm.ativos?.screen?.info{
            if section == 0{
                return info.count
            }
        }
        
        if let down = mm.ativos?.screen?.downInfo{
            if section == 1{
                return  down.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infosCell", for: indexPath) as! InfosCell
        if let info = mm.ativos?.screen?.info{
            if indexPath.section == 0{
                cell.name.text = info[indexPath.row].name
                cell.data.text = info[indexPath.row].data
            }
        }
        
        if let down = mm.ativos?.screen?.downInfo{
            if indexPath.section == 1{
                cell.name.text = down[indexPath.row].name
                cell.data.text = down[indexPath.row].data
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20))
        header.backgroundColor = .white
        let label = UILabel(frame: header.frame)
        label.text = (section == 0) ? "Infos" : "Down Infos"
        label.textAlignment = .center
        header.addSubview(label)
        return header
    }
    
    
    
}
