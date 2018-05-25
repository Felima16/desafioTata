//
//  ViewController.swift
//  DesafioTata
//
//  Created by Fernanda de Lima on 22/05/2018.
//  Copyright © 2018 FeLima. All rights reserved.
//

import UIKit

class SingUpViewController: UIViewController {
    
    var containerCell:[UIView] = []
    var activeField: UITextField?
    var messageAlert = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadCellInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard activeField != nil else {
            return
        }
        
        activeField?.resignFirstResponder()
        activeField = nil
    }
    
    
    private func loadCellInfo(){
        API.get(cellJSON.self, url: "https://floating-mountain-50292.herokuapp.com/cells.json", finish: {
            print("acabou")
        }, success: { (item) in
            mm.cellJSON = item
            self.createCells()
        }) { (error, code) in
            print("--- ERROR \(error.localizedDescription) --- CODE \(code ?? 0)")
        }
    }
    
    private func createCells(){
        let cellSorted = mm.cellJSON?.cells?.sorted(by: { $0.id! < $1.id! })
        
        for cell in cellSorted!{
            switch cell.type{
            case 1: //textfield
                let textField = UITextField()
                textField.placeholder = cell.message
                
                if let typeField = cell.typefield{
                    if typeField as? String == "telnumber"{
                        textField.textContentType = UITextContentType.telephoneNumber
                    }
                    
                    if typeField as? Int == 3{
                        textField.textContentType = UITextContentType.emailAddress
                    }
                }
                
                textField.borderStyle = .roundedRect
                textField.isHidden = cell.hidden!
                textField.delegate = self
                textField.tag = cell.id! - 1
                containerCell.append(textField)

            case 2: //label
                let label = UILabel()
                label.text = cell.message
                label.numberOfLines = 0
                label.lineBreakMode = .byWordWrapping
                label.isHidden = cell.hidden!
                containerCell.append(label)
                
            case 3: //image
                break
                
            case 4: //switch
                let check = UISwitch()
                check.tag = cell.show! - 1
                check.addTarget(self, action: #selector(self.switchIsOn(_:)), for: .valueChanged)
                containerCell.append(check)
                
            case 5: //button
                let button = UIButton()
                button.setTitle(cell.message, for: .normal)
                button.addTarget(self, action: #selector(self.validate(_:)), for: .touchUpInside)
                button.layer.borderColor = UIColor.blue.cgColor
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 1
                button.isHidden = cell.hidden!
                button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                containerCell.append(button)
                
            default:
                break
            }
        }
        let width = UIScreen.main.bounds.width * 0.7
        let height = UIScreen.main.bounds.height * 0.05
        let x:CGFloat = 20
        var y:CGFloat = 0
        
        for i in 0..<containerCell.count{
            y += CGFloat((mm.cellJSON?.cells?[i].topSpacing)!)
            containerCell[i].frame = CGRect(x: x, y: y, width: width, height: height)
            
            if let _ = containerCell[i] as? UISwitch{
                let message = UILabel(frame: CGRect(x: x + 60, y: y, width: width, height: height))
                message.text = cellSorted![i].message
                message.adjustsFontSizeToFitWidth = true
                self.view.addSubview(message)
            }
            
            self.view.addSubview(containerCell[i])
            y += height
        }
        
        
    }
    
    @objc func switchIsOn(_ sender:UISwitch){
        containerCell[sender.tag].isHidden = !sender.isOn
    }
    
    @objc func validate(_ sender:UIButton){
        print("validate")
        messageAlert = ""
        
        var cellFilterText = containerCell.filter { $0 is UITextField } as! [UITextField]
        let cellFilterSwitch = containerCell.filter { $0 is UISwitch } as! [UISwitch]
        
        for check in cellFilterSwitch{
            let text = cellFilterText.filter { $0.tag == check.tag}
            if check.isOn{
                print("check")
                validateTextFielf(text.first!)
            }
            let index = cellFilterText.index(of: text.first!)
            cellFilterText.remove(at: index!)
        }
        
        for text in cellFilterText{
            validateTextFielf(text)
        }
        
        if messageAlert == ""{
            print("proxima tela")
            let detail = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
            present(detail, animated: true, completion: nil)
            
        }else{
            let alert = UIAlertController(title: "Erro", message: "verificar campos \(messageAlert)", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validateTextFielf(_ text:UITextField){
        if text.textContentType == .emailAddress{
            if validateEmail(enteredEmail: text.text!){
            }else{
                messageAlert = "\(messageAlert)e-mail, "
            }
            return
        }
        
        if text.textContentType == .telephoneNumber{
            if validatePhone(value: text.text!){
            }else{
                messageAlert = "\(messageAlert)telefone, "
            }
            return
        }
        
        if !(text.text?.isEmpty)!{
            return
        }else{
            messageAlert = "\(messageAlert)nome, "
        }

    }
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func validatePhone(value: String) -> Bool {
        let phone = "^\\d{2}-\\d{4}-\\d{4}$"
        let cellPhone = "^\\d{2}-\\d{5}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@ OR SELF MATCHES %@", phone,cellPhone)
        let result =  phoneTest.evaluate(with: value)
        return result
    }

}

// MARK: UITextFieldDelegate
extension SingUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
}

