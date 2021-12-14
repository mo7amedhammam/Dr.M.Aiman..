//
//  AuthCountDown.swift
//  SAHL
//
//  Created by Mohamed Salman on 4/20/21.
//

import UIKit
import CountdownLabel

extension VerificationCodeVC : CountdownLabelDelegate {
    func countdownFinished() {
        self.LCountDown.text = ""
        self.BUResendCode.isHidden = false
        
    }
    func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
//        if self.language == "en" {
//            self.LCountDown.text = "\(timeCounted)"
//        } else {
//            self.LCountDown.text = "\(timeCounted)"
//
//        }
        
        
        self.LCountDown.text = "إعادة إرسال في \(timeCounted)"

    }
}
