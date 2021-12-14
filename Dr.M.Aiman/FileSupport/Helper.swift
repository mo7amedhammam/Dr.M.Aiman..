//
//  Helper.swift
//  Pina
//
//  Created by Mohamed Salman on 3/2/21.
//


import UIKit
import SystemConfiguration
import MapKit
class Helper: NSObject  {
    
  var Id           = ""
  var Email       = ""
  var PhoneNumber = ""
  var FirstName   = ""
  var Image       = ""
  var Cover       = ""
  var Gender      = true
  var RoleName    = ""
    
    class func setUserData(      Id : String,
                                 Email : String,
                                 PhoneNumber : String,
                                 FirstName : String,
                                 Image : String,
                                 Cover : String,
                                 Gender : Bool,
                                 RoleName : String
                                  ){
        let def = UserDefaults.standard
        
        def.setValue(  Id             , forKey:  "Id" )
        def.setValue(  Email       , forKey: "Email"  )
        def.setValue(  PhoneNumber         , forKey: "PhoneNumber"  )
        def.setValue(  FirstName         , forKey: "FirstName"   )
        def.setValue(  Image           , forKey: "Image"  )
        def.setValue(  Cover           , forKey: "Cover"  )
        def.setValue(  Gender             , forKey: "Gender"   )
        def.setValue(  RoleName            , forKey: "RoleName"  )

        def.synchronize()
        //        restartApp()
    }
    
    class func getUserId()->Bool{
        let def = UserDefaults.standard
        return (def.object(forKey: "Id") as? String) != nil
    }
    
    class func getId() ->String{
        let def = UserDefaults.standard
        return (def.object(forKey: "Id") as! String)
    }
    
    class func getEmail() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "Email") as! String)
    }
    
    class func getPhoneNumber() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "PhoneNumber") as! String)
    }
    class func getFirstName() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "FirstName") as! String)
    }
    class func getImage() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "Image") as! String)
    }
    class func getCover() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "Cover") as! String)
    }
    class func getGender() ->Bool {
        let def = UserDefaults.standard
        return (def.object(forKey: "Gender") as! Bool)
    }
    class func getRoleName() ->String {
        let def = UserDefaults.standard
        return (def.object(forKey: "RoleName") as! String)
    }
   
    //save access token
        class func setAccessToken(access_token : String) {
            let def = UserDefaults.standard
            def.setValue(access_token, forKey: "access_token")
            def.synchronize()
        }
        
        class func getAccessToken()->String{
            let def = UserDefaults.standard
            return (def.object(forKey: "access_token") as! String)
        }
    
    //save password
        class func setPasswordSave(password : String){
            let def = UserDefaults.standard
            def.setValue(password, forKey: "passwordSave")
            def.synchronize()
        }
        
        class func getPasswordSave()->String{
            let def = UserDefaults.standard
            return (def.object(forKey: "passwordSave") as! String)
        }
 
    
    class func logout() {
        let def = UserDefaults.standard
        def.removeObject(forKey:"Id"  )
        def.removeObject(forKey:"Email"   )
        def.removeObject(forKey:"PhoneNumber"  )
        def.removeObject(forKey:"FirstName"       )
        def.removeObject(forKey:"Image"       )
        def.removeObject(forKey:"Cover"       )
        def.removeObject(forKey:"Gender"       )
        def.removeObject(forKey:"RoleName"       )
        def.removeObject(forKey:"access_token"       )
        def.removeObject(forKey:"passwordSave"   )
     
    }
    class func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    class func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    class func isValidPassword(TargetPassword:String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: TargetPassword)

    }
    
    class func timeAgo(date : NSDate ,numericDates: Bool , language : String) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (date as Date == now as Date) ? date : now
        
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest as Date)
        
        let year = components.year ?? 0
        let month = components.month ?? 0
        let weekOfMonth = components.weekOfMonth ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        
        
        if language == "en" {
            switch (year, month, weekOfMonth, day, hour, minute, second) {
            case (let year, _, _, _, _, _, _) where year >= 2: return "\(year) years ago"
            case (let year, _, _, _, _, _, _) where year == 1 && numericDates: return "1 year ago"
            case (let year, _, _, _, _, _, _) where year == 1 && !numericDates: return "Last year"
            case (_, let month, _, _, _, _, _) where month >= 2: return "\(month) months ago"
            case (_, let month, _, _, _, _, _) where month == 1 && numericDates: return "1 month ago"
            case (_, let month, _, _, _, _, _) where month == 1 && !numericDates: return "Last month"
            case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth >= 2: return "\(weekOfMonth) weeks ago"
            case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && numericDates: return "1 week ago"
            case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && !numericDates: return "Last week"
            case (_, _, _, let day, _, _, _) where day >= 2: return "\(day) days ago"
            case (_, _, _, let day, _, _, _) where day == 1 && numericDates: return "1 day ago"
            case (_, _, _, let day, _, _, _) where day == 1 && !numericDates: return "Yesterday"
            case (_, _, _, _, let hour, _, _) where hour >= 2: return "\(hour) hours ago"
            case (_, _, _, _, let hour, _, _) where hour == 1 && numericDates: return "1 hour ago"
            case (_, _, _, _, let hour, _, _) where hour == 1 && !numericDates: return "An hour ago"
            case (_, _, _, _, _, let minute, _) where minute >= 2: return "\(minute) minutes ago"
            case (_, _, _, _, _, let minute, _) where minute == 1 && numericDates: return "1 minute ago"
            case (_, _, _, _, _, let minute, _) where minute == 1 && !numericDates: return "A minute ago"
            case (_, _, _, _, _, _, let second) where second >= 3: return "\(second) seconds ago"
            default: return "Just now"
            }
        } else {
            switch (year, month, weekOfMonth, day, hour, minute, second) {
            case (let year, _, _, _, _, _, _) where year >= 2: return "\(year) سنين مضت"
            case (let year, _, _, _, _, _, _) where year == 1 && numericDates: return "منذ ١ سنه"
            case (let year, _, _, _, _, _, _) where year == 1 && !numericDates: return "العام الماضي"
            case (_, let month, _, _, _, _, _) where month >= 2: return "\(month) منذ اشهر"
            case (_, let month, _, _, _, _, _) where month == 1 && numericDates: return "قبل ١ شهر"
            case (_, let month, _, _, _, _, _) where month == 1 && !numericDates: return "الشهر الماضي"
            case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth >= 2: return "\(weekOfMonth) منذ أسابيع"
            case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && numericDates: return "قبل ١ أسبوع"
            case (_, _, let weekOfMonth, _, _, _, _) where weekOfMonth == 1 && !numericDates: return "الاسبوع الماضى"
            case (_, _, _, let day, _, _, _) where day >= 2: return "\(day) أيام مضت"
            case (_, _, _, let day, _, _, _) where day == 1 && numericDates: return "منذ ١ يوم"
            case (_, _, _, let day, _, _, _) where day == 1 && !numericDates: return "في الامس"
            case (_, _, _, _, let hour, _, _) where hour >= 2: return "\(hour) منذ ساعات"
            case (_, _, _, _, let hour, _, _) where hour == 1 && numericDates: return "منذ ١ ساعة"
            case (_, _, _, _, let hour, _, _) where hour == 1 && !numericDates: return "منذ ساعة"
            case (_, _, _, _, _, let minute, _) where minute >= 2: return "\(minute) دقائق مضت"
            case (_, _, _, _, _, let minute, _) where minute == 1 && numericDates: return "منذ ١ دقيقة"
            case (_, _, _, _, _, let minute, _) where minute == 1 && !numericDates: return "منذ دقيقة"
            case (_, _, _, _, _, _, let second) where second >= 3: return "\(second)منذ ثواني "
            default: return "في هذة اللحظة"
            }
        }
        
    }
    
    
    class func SetImage (EndPoint : String? , image : UIImageView , name : String , status : Int) {
            // status == 0 system  else 1 named
            if !EndPoint!.isEmpty || EndPoint != nil {
                let url = URL(string: URLs.ImageBaseURL + EndPoint!)
                    image.kf.indicatorType = .activity
                    image.kf.setImage(with: url)
                } else {
                    if status == 0 {
                        image.image = UIImage(systemName: name)
                        
                    } else {
                        image.image = UIImage(named: name)
                        
                    }
                }
            }
    
    class func SetDate (TimeDate : String , label : UILabel ) {
        let time = TimeDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date (from: time)
        label.text     = timeAgo(date: date! as NSDate, numericDates: false, language: Shared.shared.lang)
    }
    
//    class func order (order_id : String) {
//        //        OrderDetailVC
//        Shared.shared.Order_Id = order_id
//        guard let window = UIApplication.shared.keyWindow else{return}
//        if Shared.shared.UserID == "\(Helper.getUserID())" {
//            // user
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            var vc:UIViewController
//            vc = storyboard.instantiateViewController(withIdentifier: "UserOrderInfo")
//            window.rootViewController = vc
//        } else {
//            // driver
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            var vc:UIViewController
//            vc = storyboard.instantiateViewController(withIdentifier: "DriverOrderInfo")
//            window.rootViewController = vc
//        }
//
//    }
    
    
    class func GoToAnyScreen (storyboard : String , identifier : String) {
        guard let window = UIApplication.shared.keyWindow else{return}
        let storyboard = UIStoryboard(name: storyboard , bundle: nil)
        var vc:UIViewController
        vc = storyboard.instantiateViewController(withIdentifier: identifier )
        window.rootViewController = vc
    }

    class func retreiveCityName(lattitude: Double, longitude: Double, completionHandler: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lattitude, longitude: longitude), completionHandler:
        {
            placeMarks, error in
            let country = placeMarks?.first?.country
            let admin = placeMarks?.first?.administrativeArea
            let subLocality = placeMarks?.first?.subLocality
            let name = placeMarks?.first?.name

            let address = "\(country ?? ""),\(admin ?? ""),\(subLocality ?? ""),\(name ?? "")"


            completionHandler(address)
         })
    }

    
    class func RateApp (url : String) {
        guard let url = URL(string: url) else {
            return
        }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    class func openWhatsapp(WhatsappNumber : String ){
        let urlWhats = "https://api.whatsapp.com/send?phone=\(WhatsappNumber)"

        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
   class func OpenYoutube(youtubeID: String) {

       let appURL = NSURL(string: "youtube://www.youtube.com/channel/\(youtubeID)")!
       let webURL = NSURL(string: "https://www.youtube.com/channel/\(youtubeID)")!
       let application = UIApplication.shared

       if application.canOpenURL(appURL as URL) {
           application.open(appURL as URL)
       } else {
           // if Youtube app is not installed, open URL inside Safari
           application.open(webURL as URL)
       }
    }

    class func openTelegram(telegramID : String){
//        let appURL = NSURL(string: "tg://resolve?domain=NujqkN0suwE1MzU0")!
        let appURL = NSURL(string: "https://t.me/joinchat/\(telegramID)")!
        let webURL = NSURL(string: "https://t.me/joinchat/\(telegramID)")!
        let application = UIApplication.shared

        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
    
    class func openFaceBook(pageId: String, pageName: String) {
        let appURL = NSURL(string: "fb://page/?id=\(pageId)")!
        let webURL = NSURL(string: "http://facebook.com/\(pageName)/")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Youtube app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
       }
    
    
   //MARK: BlurEffect
    class func addBlurEffect( targetView: UIView, targetstyle : UIBlurEffect.Style ){
    let blureffect = UIBlurEffect(style: targetstyle )
        let blureffectView = UIVisualEffectView(effect: blureffect)
        blureffectView.frame = targetView.bounds
        blureffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        targetView.addSubview(blureffectView)
//        targetView.addsubviewtooback
//        blureffectView.addSubview(secondvc)
//        blurView.frame = targetView.layer.bounds
    }
    
    class func PushToAnyScreen (TargetStoryboard : String , targetViewController : UIViewController) {
        let storyboard = UIStoryboard(name: TargetStoryboard , bundle: nil)
        var vc:UIViewController
        vc = storyboard.instantiateViewController(withIdentifier: "targetViewController") as! UIViewController
        let nav = UINavigationController()
        nav.pushViewController(vc, animated: true)
    }
    class func PopAnyScreen () {
      
        let nav = UINavigationController()
        nav.popViewController(animated: true)
    }
    class func PopAnyRootScreen () {
      
        let nav = UINavigationController()
        nav.popToRootViewController(animated: true)
    }
    
    
    }

@IBDesignable class CardView: UIView {
    
    
    var CornerRadius : CGFloat = 12
    var ofsetWidth : CGFloat = 0
    var ofsethHight : CGFloat = 0
    var ofsethShadowOpacity : Float = 0.6
    var mycolour = UIColor.black
    
    override func layoutSubviews() {
        layer.cornerRadius = self.CornerRadius
        layer.shadowColor = self.mycolour.cgColor
        layer.shadowOffset  = CGSize(width: self.ofsetWidth, height: self.ofsethHight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowOpacity = self.ofsethShadowOpacity
        
    }
    
}
