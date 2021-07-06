//
//  AuthTextField.swift
//  SAHL
//
//  Created by Mohamed Salman on 4/20/21.
//

import UIKit


extension VerificationCodeVC : UITextFieldDelegate {
    @objc func textFieldDidChange(textField: UITextField){
        let text = textField.text
        
        if text?.utf16.count == 1 {
            switch textField{
            case self.TFCodeIndex1:
//                TFCodeIndex1.borderColor = UIColor(hexString: "#707070FF")
                TFCodeIndex1.borderColor = UIColor(hexString: "#C8742AFF")
                ViewCodeIndex1.isHidden = true
                self.TFCodeIndex2.becomeFirstResponder()
            case self.TFCodeIndex2:
                TFCodeIndex2.borderColor = UIColor(hexString: "#C8742AFF")
                ViewCodeIndex2.isHidden = true
                self.TFCodeIndex3.becomeFirstResponder()
            case self.TFCodeIndex3:
                TFCodeIndex3.borderColor = UIColor(hexString: "#C8742AFF")
                ViewCodeIndex3.isHidden = true
                self.TFCodeIndex4.becomeFirstResponder()
            case self.TFCodeIndex4:
                TFCodeIndex4.borderColor = UIColor(hexString: "#C8742AFF")
                ViewCodeIndex4.isHidden = true
                self.TFCodeIndex4.resignFirstResponder()
            default:
                break
            }
        } else {
            switch textField{
            case self.TFCodeIndex4:
                TFCodeIndex4.borderColor = UIColor(hexString: "#707070FF")
                ViewCodeIndex4.isHidden = false
                self.TFCodeIndex3.becomeFirstResponder()
            case self.TFCodeIndex3:
                TFCodeIndex3.borderColor = UIColor(hexString: "#707070FF")
                ViewCodeIndex3.isHidden = false
                self.TFCodeIndex2.becomeFirstResponder()
            case self.TFCodeIndex2:
                TFCodeIndex2.borderColor = UIColor(hexString: "#707070FF")
                ViewCodeIndex2.isHidden = false
                self.TFCodeIndex1.becomeFirstResponder()
            case self.TFCodeIndex1:
                TFCodeIndex1.borderColor = UIColor(hexString: "#707070FF")
                ViewCodeIndex1.isHidden = false
                self.TFCodeIndex1.resignFirstResponder()
            default:
                break
            }
        }
    }
}
