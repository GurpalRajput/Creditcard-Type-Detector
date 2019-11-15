//
//  ViewController.swift
//  CardTypeValidator
//
//  Created by Gurpal Rajput on 15/11/19.
//  Copyright © 2019 Gaint coders. All rights reserved.
//

import UIKit


enum CardType: String {
  case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
 static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
  
  var regex: String {
    switch self {
    case .Amex:
      return "^3[47][0-9]{5,}$"
    case .Visa:
      return "^4[0-9]{6,}([0-9]{3})?$"
    case .MasterCard:
      return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
    case .Diners:
      return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
    case .Discover:
      return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
    case .JCB:
      return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
    case .UnionPay:
      return "^(62|88)[0-9]{5,}$"
    case .Hipercard:
      return "^(606282|3841)[0-9]{5,}$"
    case .Elo:
      return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
    default:
      return ""
    }
  }
}

class ViewController: UIViewController {
  
  
  @IBOutlet var textF: UITextField!
  @IBOutlet var cardTypeLbl: UILabel!
  @IBOutlet var isCardValidLbl: UILabel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    
  }
  @IBAction func kkkkk(_ sender: Any) {
    
    let abc =  self.textF.validateCreditCardFormat()
    print(abc.type , abc.valid)
    
    isCardValidLbl.text =    "\(self.textF.validateCreditCardFormat().valid)"
    cardTypeLbl.text =   "\(self.textF.validateCreditCardFormat().type)"
  }
}

//Uitextfield Delegate
extension UITextField
{
  func validateCreditCardFormat()-> (type: CardType, valid: Bool) {
          // Get only numbers from the input string
          let input = self.text!
    let numberOnly = input.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
      var type: CardType = .Unknown
      var formatted = ""
      var valid = false

      // detect card type
      for card in CardType.allCards {
        if (matchesRegex(regex: card.regex, text: numberOnly)) {
              type = card
              break
          }
      }

      // check validity
    valid = luhnCheck(number: numberOnly)

      // format
      var formatted4 = ""
      for character in numberOnly {
          if formatted4.count == 4 {
              formatted += formatted4 + " "
              formatted4 = ""
          }
          formatted4.append(character)
      }

      formatted += formatted4 // the rest

      // return the tuple
      return (type, valid)
  }
  
  func matchesRegex(regex: String!, text: String!) -> Bool {
      do {
        let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
          let nsString = text as NSString
        let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
          return (match != nil)
      } catch {
          return false
      }
  }

  func luhnCheck(number: String) -> Bool {
      var sum = 0
    let digitStrings = (number.reversed()).map { String($0) }

      for tuple in digitStrings.enumerated() {
          guard let digit = Int(tuple.element) else { return false }
          let odd = tuple.offset % 2 == 1

          switch (odd, digit) {
          case (true, 9):
              sum += 9
          case (true, 0...8):
              sum += (digit * 2) % 9
          default:
              sum += digit
          }
      }

      return sum % 10 == 0
  }
  
}

