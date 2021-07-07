//
//  API.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 31/05/2021.
//

import Foundation
import Alamofire
import SwiftyJSON


//var accessToken : String!

class API : NSObject {
    
    
    //MARK: --------- Register  --------
    /// -------------------- creat new user  -------------
    class func  userRegisteration ( Email : String ,MacAdress : String ,FirstName : String ,Gender : Int ,PhoneNumber : String , Image : String ,Password : String, completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let jsonString : [String : Any] = ["Email" : Email ,"MacAdress" : MacAdress ,"FirstName" : FirstName ,"Gender" : Gender ,"PhoneNumber" : PhoneNumber ,"Image" : Image ,"Password" : Password ]
        let url = URLs.Register
        //        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["StatusCode"] == 0 && json["Message"] == "Registration done successfully "{
                        completion(nil , 0 ,json["Message"].string ?? "")
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                }
            }
    }
    
    //MARK:  --------- upload image Multipart
    class func uploadUserImageMultipart ( image : UIImage , completion : @escaping( _ error : Error? , _ success : Int? , _ message : String? ,_ imageURL : String? ) ->Void) {
        
        let url = URLs.SaveUserImage
        let header : HTTPHeaders = ["content-type" : "image/png" ]
        let images = ["file" : image ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            for (key,value) in images {
                print("vvvvvv::::::: \(value)")
                
                let imgData = value.jpegData(compressionQuality: 0.5)
                //                    if value != nil {
                multipartFormData.append(imgData!, withName: key , fileName: "logo.PNG" , mimeType: "image/png")
                //                    }
            }
            //                    multipartFormData.append(Text.data(using: .utf8)!, withName: "text") // if uploading with another text parameter
            
        }, usingThreshold:UInt64.init(),
        to: "\(url)", //URL Here
        method: .post,
        //            parameters: nil ,
        headers: header, //pass header dictionary here
        encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                //  //                      uploadView.isHidden = false
                //                    upload.uploadProgress(closure: { (progress) in
                //                        uploadView.value = CGFloat(100 * progress.fractionCompleted)
                //                        print("Download Progress: \(progress.fractionCompleted)")
                //                    })
                upload.responseJSON { response in
                                        
                    switch response.result {
                    case .success(let value) :
                        let json = JSON(value)
                        // let jsonUser = json["user"]
                        print("multipart user image = \(json)")   //OK
                        
                        completion(nil , 0 , "Uplouded successfully" , json.string! )
                        Helper.setUserImage(user_imagee:json.string!)

                    case .failure(let error) :
                        completion(error , -1  , "\(error)" , nil)
                    }
                }
                break
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                
                completion(encodingError , 1 , "Failed to uploud" , nil)
                
            }
        })
        //        }
    }
    
    //MARK: save User image
    enum newimageEnum {
        case profileImage
        case coverImage
    }
    
    class func  updateImage (type: newimageEnum, Image : String, completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        

        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        var url : String
        var jsonString : [String : Any]
        
        switch type {
        case.profileImage:
             url = URLs.updateUserImage
            jsonString = ["Image" : Image]
        case.coverImage:
            url = URLs.uodateUserCover
            jsonString = ["Image" : Image]
        }
        
        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "Failed" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)

                    
                    print("updated image json\(json)")

                   
                    
                    if json["Status"] == 0 {

                        switch type {
                        case .profileImage:
                            Helper.setUserImage(user_imagee: json["Image"].string ?? "")
                        case .coverImage:
                            Helper.setUserCover(user_imagee: json["Image"].string ?? "")
                        }
                        
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["error_description"].string ?? "")
                        
                    }
                }
            }
    }
    
    
    
    
    //    //MARK: VerifyCodeByMail
    //    /// -------------------- Verify phone Number  -------------
    //    class func  requestLoginConfirmationCode ( Mobile : String , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
    //
    //        let jsonString = ["Mobile" : Mobile  ]
    //        let url = URLs.RequestVerificationCode
    //
    //        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: header)
    //            .validate(statusCode: 200..<500)
    //            .responseJSON{ response in
    //                switch response.result {
    //                case .failure(let error) :
    //                    completion(error , -1  , "" )
    //                case .success(let value) :
    //                    let json = JSON(value)
    //                    print(json)
    //
    //                    if json["Status"] == 0 && json["Message"] == "The activation code has been successfully sent check your email"{
    //                        completion(nil , 0 ,json["Message"].string ?? "")
    //
    //                    } else {
    //                        completion(nil , -1 ,json["Message"].string ?? "")
    //
    //                    }
    //                }
    //            }
    //    }
    
    //MARK: User Login
    /// -------------------- Login  -------------
    class func  userLogin ( Email : String, MacAdress : String, Password : String , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? , _ token : String?) ->Void) {
        
        let jsonString = ["Email" : Email,"MacAdress" : MacAdress,"Password" : Password ]
        let url = URLs.Login
        
        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "Failed" , "")
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 {
                        Helper.setAccessToken(access_token: "Bearer \(json["access_token"].string ?? "" )")
                        
                        
                        completion(nil , 0 ,json["Message"].string ?? "", json["access_token"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["error_description"].string ?? "", "")
                        
                    }
                }
            }
    }
    /// -------------------- user info  -------------
    class func  GetUserInfo ( completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let url = URLs.GetUser
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "")
                    
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 {
                        Helper.setUserData(Id: json["Response"]["Id"].string ?? "",
                                           Email:  json["Response"]["Email"].string ?? "",
                                           PhoneNumber:  json["Response"]["PhoneNumber"].string ?? "", FirstName:  json["Response"]["FirstName"].string ?? "", Image:  json["Response"]["Image"].string ?? "", Cover: json["Response"]["Cover"].string ?? "",
                                           Gender:  json["Response"]["Gender"].bool ?? true,
                                           RoleName:  json["Response"]["RoleName"].string ?? ""
                        )
                        print ("  info --> image :: \(json["Response"]["Image"].string ?? "")")
                        print ("  info --> cover :: \(json["Response"]["Cover"].string ?? "")")

                        Helper.setUserImage(user_imagee: "\(json["Response"]["Image"].string ?? "")")
                        Helper.setUserCover(user_imagee: "\(json["Response"]["Cover"].string ?? "")")
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["error_description"].string ?? "")
                        
                    }
                }
            }
    }
    
    
    //MARK: edit Profile
        /// -------------------- edit Profile  -------------
        class func  EditProfile ( Email : String, PhoneNumber : String,FirstName : String , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
            
            let jsonString = ["Email" : Email,"PhoneNumber" : PhoneNumber, "FirstName" : FirstName  ]
            let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]

            let url = URLs.editProfile
            
            Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: header)
                .validate(statusCode: 200..<500)
                .responseJSON{ response in
                    switch response.result {
                    case .failure(let error) :
                        completion(error , 1  , "" )
                    case .success(let value) :
                        let json = JSON(value)
                        print(json)
                        
                        if json["Status"] == 0 && json["Message"] == "Success"{
                            
                            Helper.setUserData(Id: Helper.getId(),
                                               Email:  Email ,
                                               PhoneNumber:  PhoneNumber , FirstName: FirstName , Image: Helper.getUserImage(), Cover: Helper.getUserCover(),
                                               Gender:  Helper.getGender(),
                                               RoleName:  Helper.getRoleName()
                            )
                            
                            completion(nil , 0 ,json["Message"].string ?? "")
                            
                        } else {
                            
                            completion(nil , -1 ,json["Message"].string ?? "")
                        }
                    }
                }
        }
    
    
    //MARK: Change User Password
    /// -------------------- change Password  -------------
    class func  userChangePassword ( Email : String, MacAdress : String, completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let jsonString = ["Email" : Email,"MacAdress" : MacAdress  ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.ChangePassword
        
        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                }
            }
    }
    
    
    //MARK: ---------------- Live --------------
    /// ---------- Get All Lives
    class func  GetAllLives (pagenum : Int, completion : @escaping (_ error : Error? ,_ Inbody : [LiveModel]? , _ message : String? ) ->Void) {
        let url = URLs.GetAllLives+"\(pagenum)"
        
        //        let param = ["id" : id ,  ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header )
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    let jsonInLiveVideos        = json["Response"]
                    var inbodyArr                = [LiveModel]()
                    var ArrComment                = [LiveCommentsModel]()
                    
                    
                    guard let inbody = jsonInLiveVideos.array else {
                        completion(nil,nil , json["Message"].string ?? "" )
                        return
                    }
                    for data in inbody {
                        
                        guard let comm = data["Comments"].array else {
                            return
                        }
                        for data in comm {
                            let object = LiveCommentsModel(CreationTime: data["CreationTime"].string ?? "" , text: data["text"].string ?? "" , Id: data["Id"].int ?? 0 , Image: data["Image"].string ?? "", UserId: data["UserId"].string ?? "", FirstName: data["FirstName"].string ?? "")
                            ArrComment.append(object)
                            
                        }
                        
                        
                        let object = LiveModel (Id: data["Id"].int ?? 0 ,  Title: data["Title"].string ?? "", Detailes: data["Detailes"].string ?? "", CreationDate: data["CreationDate"].string ?? "", UserId: data["UserId"].string ?? "", FirstName: data["FirstName"].string ?? "", ReactType: data["ReactType"].int ?? 0, ReactCount: data["ReactCount"].int ?? 0, UserImage: data["UserImage"].string ?? "", liveComments: ArrComment)
                        
                        inbodyArr.append(object)
                        ArrComment.removeAll()
                    }
                    print("..json....\(inbodyArr)")
                    completion(nil , inbodyArr , json["Message"].string ?? "")
                }
            }
    }
    
    /// -------------------- Add Live -------------
    class func  addNewLive ( Title : String , Detailes : String , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let jsonString = ["Title" : Title ,"Detailes" : Detailes ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.AddLive
        
        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                }
            }
    }
    
    
    /// -------------------- Delete Live -------------
    class func  deleteLive ( Id : Int , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        //        let parameters = ["Id" : Id ]
        let url = URLs.DeleteLive+"\(Id)"
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "request error" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                    
                }
            }
    }
    
    
    //MARK: ------------------- Posts ------------------------------------
    
    /// ---------- Get All Posts
    class func  GetAllPosts ( Type : String ,  pageNum : Int, completion : @escaping (_ error : Error? ,_ Inbody : [PostModel]? , _ message : String? ) ->Void) {
        
        var url = ""
        
        if Type == "post" {
            url = URLs.GetAllPosts+"\(pageNum)"
        } else if Type == "live"  {
            url = URLs.GetAllLives+"\(pageNum)"
        } else {
            // favourit
            url = URLs.GetMyFavoritePost
            
        }
        
        //        let param = ["id" : id ,  ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    let jsonPosts        = json["Response"]
                    var inbodyArr        = [PostModel]()
                    var ArrComment       = [CommentsModel]()
                    
                    
                    guard let inbody = jsonPosts.array else {
                        completion(nil,nil , json["Message"].string ?? "" )
                        return
                    }
                    for data in inbody {
                        
                        guard let comm = data["Comments"].array else {
                            return
                        }
                        for data in comm {
                            let object = CommentsModel(CreationTime: data["CreationTime"].string ?? "" , text: data["text"].string ?? "" , Id: data["Id"].int ?? 0 , Image: data["Image"].string ?? "" , UserId: data["UserId"].string ?? "" , UserImage: data["UserImage"].string ?? "" , FirstName: data["FirstName"].string ?? "" )
                            ArrComment.append(object)
                        }
                        
                        let object = PostModel( Title : data["Title"].string ?? "" , Detailes :  data["Detailes"].string ?? ""  , CreationDate :  data["CreationDate"].string ?? "" ,  CreationTime:  data["CreationTime"].string ?? "" , Id: data["Id"].int ?? 0, text:  data["text"].string ?? "" , Image: data["Image"].string ?? "", UserId: data["UserId"].string ?? "", UserImage: data["UserImage"].string ?? "", IsPinPost: data["IsPinPost"].bool ?? false, FirstName: data["FirstName"].string ?? "", IsFavoritePost: data["IsFavoritePost"].bool ?? false, ReactType: data["ReactType"].int ?? 0 , ReactCount: data["ReactCount"].int ?? 0 , PinTime : data["PinTime"].string ?? "" , Comments: ArrComment)
                        
                        inbodyArr.append(object)
                        ArrComment.removeAll()
                    }
                    print("..json....\(inbodyArr)")
                    completion(nil , inbodyArr , json["Message"].string ?? "")
                }
            }
    }
//    
//    /// ---------- Get Favourite Posts
//    class func  GetFavouriePosts ( completion : @escaping (_ error : Error? ,_ Inbody : [PostModel]? , _ message : String? ) ->Void) {
//        
//        let url = URLs.GetMyFavoritePost
//        
//        //        let param = ["id" : id ,  ]
//        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
//        
//        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header)
//            .validate(statusCode: 200..<500)
//            .responseJSON{ response in
//                switch response.result {
//                case .failure(let error) :
//                    completion(error , nil , "" )
//                case .success(let value) :
//                    let json = JSON(value)
//                    print(json)
//                    
//                    let jsonPosts        = json["Response"]
//                    var inbodyArr        = [PostModel]()
//                    var ArrComment       = [CommentsModel]()
//                    
//                    
//                    guard let inbody = jsonPosts.array else {
//                        completion(nil,nil , json["Message"].string ?? "" )
//                        return
//                    }
//                    for data in inbody {
//                        
//                        guard let comm = data["Comments"].array else {
//                            return
//                        }
//                        for data in comm {
//                            let object = CommentsModel(CreationTime: data["CreationTime"].string ?? "" , text: data["text"].string ?? "" , Id: data["Id"].int ?? 0 , Image: data["Image"].string ?? "" , UserId: data["UserId"].string ?? "" , UserImage: data["UserImage"].string ?? "" , FirstName: data["FirstName"].string ?? "" )
//                            ArrComment.append(object)
//                        }
//                        
//                        
//                        let object = PostModel(  Title : data["Title"].string ?? "" , Detailes :  data["Detailes"].string ?? ""  , CreationDate :  data["CreationDate"].string ?? "" , CreationTime:  data["CreationTime"].string ?? "" , Id: data["Id"].int ?? 0, text:  data["text"].string ?? "" , Image: data["Image"].string ?? "", UserId: data["UserId"].string ?? "", UserImage: data["UserImage"].string ?? "", IsPinPost: data["IsPinPost"].bool ?? false, FirstName: data["FirstName"].string ?? "", IsFavoritePost: data["IsFavoritePost"].bool ?? false, ReactType: data["ReactType"].int ?? 0 , ReactCount: data["ReactCount"].int ?? 0 , Comments: ArrComment)
//                        
//                        inbodyArr.append(object)
//                        ArrComment.removeAll()
//                    }
//                    print("..json....\(inbodyArr)")
//                    completion(nil , inbodyArr , json["Message"].string ?? "")
//                }
//            }
//    }
    
    // MARK: ------- upload Post image
    class func uploadImage ( image : UIImage , completion : @escaping( _ error : Error? , _ success : Int? , _ message : String? ,_ imageURL : String? ) ->Void) {
        
        let url = URLs.BaseURL+"/Post/UploadFile"
        //"X-Requested-With" : "XMLHttpRequest"  ,
        let header : HTTPHeaders = ["content-type" : "multipart/form-data"  , "Authorization" : Helper.getAccessToken() ]
        
        let images = ["file" : image ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            for (key,value) in images {
                print("vvvvvv::::::: \(value)")
                let imgData = value.jpegData(compressionQuality: 0.5)
                //                    if value != nil {
                multipartFormData.append(imgData!, withName: key , fileName: "logo.PNG" , mimeType: "image/png")
                //                    }
            }
            //                    multipartFormData.append(Text.data(using: .utf8)!, withName: "text") // if uploading with another text parameter
            
        }, usingThreshold:UInt64.init(),
        to: "\(url)", //URL Here
        method: .post,
        //            parameters: nil ,
        headers: header, //pass header dictionary here
        encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                //  //                      uploadView.isHidden = false
                //                    upload.uploadProgress(closure: { (progress) in
                //                        uploadView.value = CGFloat(100 * progress.fractionCompleted)
                //                        print("Download Progress: \(progress.fractionCompleted)")
                //                    })
                upload.responseJSON { response in
                    
                    //                    print("response : \(response)")
                    
                    switch response.result {
                    case .success(let value) :
                        let json = JSON(value)
                        // let jsonUser = json["user"]
                        print("Multipart json = \(json)")
                        
                        completion(nil , 0 , "Uplouded successfully", json.string! )
                    //                            Shared.shared.receivedPostImageUrlString = URLs.ImageBaseURL + json.string!
                    //                            // add your Post Here
                    //                            print("Imageurl\(URLs.ImageBaseURL + json.string!)" )
                    case .failure(let error) :
                        completion(error , 1  ,"Server error" , nil)
                    }
                }
                break
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                
                completion(encodingError , 1 , "Failed to uploud" , nil)
                
            }
        })
        //        }
    }
    
    /// -------------------- Check Post Allow -------------
    class func  checkPostAllow (completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        //        let jsonString = ["text" : text ,"Image" : Image  ]
        let url = URLs.CheckAllowPost
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                    }
                }
            }
    }
    
    /// -------------------- Add Post -------------
    class func  addPost ( text : String? , Image : String? , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let Parameter : [String : Any] = ["text" : text! ,"Image" : Image! ]
        let header : HTTPHeaders  = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.AddPost
        
        Alamofire.request(url, method: .post, parameters: Parameter , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                    
                }
            }
    }
    
    /// -------------------- Delete Post -------------
    class func  deletePost ( Id : Int , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        //                let parameters = ["Id" : Id ]
        let url = URLs.DeletePost+"\(Id)"
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "request error" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                    
                }
            }
    }
    
    /// -------------------- Add Post -------------
    class func  EditPost ( Id : Int , text : String , Image : String , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let jsonString : [String : Any ] = ["Id" : Id , "text" : text ,"Image" : Image  ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.AddPost
        
        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                    
                }
            }
    }
    
    
    /// -------------------- Add Comment -------------
    class func  addPostComment ( Type : String ,  Id : Int , text : String? , Image : String? , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        var jsonStringParam : [String : Any]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        var  url = ""
        
        if Type == "post" {
            url = URLs.AddPostComment
            jsonStringParam  = [ "PostId" : Id , "text" : text ?? "" , "Image" : Image ?? "" ]
            
        } else {
            url = URLs.AddLiveComment
            jsonStringParam = [ "LiveId" : Id , "text" : text ?? "" , "Image" : Image ?? "" ]
        }
        
        Alamofire.request(url, method: .post, parameters: jsonStringParam , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                    
                }
            }
        
    }
    
    
    /// -------------------- Delete Post Comment -------------
    class func  deletePostComment ( Type : String ,  Id : Int , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        var  url  = ""
        
        if Type == "post" {
            url = URLs.DeletePostComment+"\(Id)"
        } else {
            url = URLs.DeleteLiveComment+"\(Id)"
        }
        
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                    
                }
            }
    }
    
    
    
    /// -------------------- Edit Post Comment -------------
    
    enum Editenum {
        case post
        case postComment
        case Live
        case LiveComment
    }
    class func  EditAll (Type : Editenum , Id : Int , text : String? , Image : String , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        var  jsonStringParam : [String : Any]
        var  url = ""
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        switch Type {
        case .post:
            jsonStringParam = [ "Id" : Id, "text" : text ?? "" , "Image" : Image  ]
            url = URLs.EditPost
        case .postComment:
            jsonStringParam = [ "Id" : Id, "text" : text ?? "" , "Image" : Image  ]
            url = URLs.EditPostComment
        case .Live:
            jsonStringParam = [ "Id" : Id, "text" : text ?? "" , "Image" : Image  ]
            url = URLs.EditLive
        case .LiveComment:
            jsonStringParam = [ "Id" : Id, "text" : text ?? "" , "Image" : Image  ]
            url = URLs.EditLiveComment
            
        }
        
        Alamofire.request(url, method: .post, parameters: jsonStringParam , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                }
            }
        
    }
    
    /// -------------------- Add Comment -------------
    class func  addLiveComment ( LiveId : Int , text : String , Image : String , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let jsonStringParam : [String : Any] = [ "LiveId" : LiveId, "text" : text, "Image" : Image  ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.AddLiveComment
        
        Alamofire.request(url, method: .post, parameters: jsonStringParam , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                    
                }
            }
        
    }
    
    /// -------------------- Delete Live Comment -------------
    class func  deleteLiveComment ( Id : Int , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        //                let parameters = ["Id" : Id ]
        let url = URLs.DeleteLiveComment+"\(Id)"
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        Alamofire.request(url, method: .get, parameters: nil , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "request error" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                    
                }
            }
    }
    
    /// -------------------- Edit Live Comment -------------
    class func  editLiveComment ( Id : Int , text : String , Image : String , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let jsonStringParam : [String : Any] = [ "Id" : Id, "text" : text, "Image" : Image  ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.EditLiveComment
        
        Alamofire.request(url, method: .post, parameters: jsonStringParam , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                }
            }
        
    }
    
    //MARK: ---------------- Universities --------------
    /// ---------- Get All universities
    class func  GetUniversitiesAndCourses ( completion : @escaping (_ error : Error? ,_ Inbody : [UniversitiesModel]? ,  _ message : String? ) ->Void) {
        let url = URLs.GetUnivesitiesAndCourses
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        //        let param = ["id" : id ,  ]
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header )
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print("json ::\(json)")
                    
                    let jsonResponse              = json["Response"]
                    var ArrUniversities           = [UniversitiesModel]()
                    var ArrCourses                = [coursesModel]()
                    //                    print("response \(jsonResponse)")
                    
                    guard let jsonResponseToArr = jsonResponse.array else {
                        completion(nil,nil , json["Message"].string ?? "" )
                        return
                    }
                    
                    for data in jsonResponseToArr {
                        if data["Courses"].array == nil || data["Courses"].array?.isEmpty == true  {
                        } else {
                            guard let jsonResponseCourse = data["Courses"].array else {
                                return
                            }
                            for course in jsonResponseCourse {
                                let CoursesObject = coursesModel(Id: course["Id"].int ?? 0, Title: course["Title"].string ?? "", PaymentUrl: course["PaymentUrl"].string ?? "", Image: course["Image"].string ?? "", Created: course["Created"].string ?? "", Price: course["Price"].int ?? 0, DoctorName: course["DoctorName"].string ?? "", Description: course["Description"].string ?? "", TotalPlayLists: course["TotalPlayLists"].int ?? 0, Fk_univeristy: course["Fk_univeristy"].int ?? 0, Order: course["Order"].int ?? 0, University:course["University"].string ?? "" , IsAvailable: course["IsAvailable"].bool ?? true)
                                
                                ArrCourses.append(CoursesObject)
                                
                            }
                        }
                        
                        let object = UniversitiesModel(Id: data["Univeristy"]["Id"].int ?? 0, Image: data["Univeristy"]["Image"].string ?? "", OrderNumber: data["Univeristy"]["OrderNumber"].int ?? 0, Title: data["Univeristy"]["Title"].string ?? "", Courses: ArrCourses)
                        
                        ArrUniversities.append(object)
                        print("..json....\(ArrUniversities)")
                        
                        
                        ArrCourses.removeAll()
                    }
                    completion(nil , ArrUniversities , json["Message"].string ?? "")
                }
            }
    }
    
    
    //MARK: ---------------- PlayLists --------------
    /// ---------- Get All PlayLists
    class func  GetPlaylistByCourse (id:String, completion : @escaping (_ error : Error? ,_ Inbody : [PlaylistModel]? ,  _ message : String? ) ->Void) {
        let url = URLs.GetCoursePlaylist+id
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header )
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print("json ::\(json)")
                    
                    let jsonResponse              = json["Response"]
                    var ArrPlaylists           = [PlaylistModel]()
                    //                    var ArrReferences                = [String]()
                    //                    print("response \(jsonResponse)")
                    
                    guard let jsonResponseToArr = jsonResponse.array else {
                        completion(nil,nil , json["Message"].string ?? "" )
                        return
                    }
                    
                    for data in jsonResponseToArr {
                        
                        
                        
                        let object = PlaylistModel(Id: data["Id"].int ?? 0 , Title: data["Title"].string ?? "", Image: data["Image"].string ?? "", Description: data["Description"].string ?? "", IsAvailable: data["IsAvailable"].bool ?? false, CreationDate: data["CreationDate"].string ?? "", Price: data["Price"].double ?? 0.0 , TotalVideos: data["TotalVideos"].int ?? 0, CourseId: data["CourseId"].int ?? 0, CourseName: data["CourseName"].string ?? "", Reference: data["ReferencesArray"].arrayObject as! Array  )
                        
                        ArrPlaylists.append(object)
                        
                        print("..json....\(ArrPlaylists)")
                        
                        
                    }
                    completion(nil , ArrPlaylists , json["Message"].string ?? "")
                }
            }
    }
    
    
    
    
    
    
    
    class func S_UploadImageComment (Id : Int , text : String? , image : UIImage , completion : @escaping( _ error : Error? , _ success : Bool? , _ message : String? ) ->Void) {
        
        let url = URLs.AddPostComment
        var xx = ""
        //"X-Requested-With" : "XMLHttpRequest"  ,
        let header : HTTPHeaders = ["content-type" : "multipart/form-data"  , "Authorization" : "\(Helper.getAccessToken())" ]
        let images = [ "file" : image ]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Parameter for Upload files
            for (key,value) in images {
                print("vvvvvv::::::: \(value)")
                
                let imgData = value.jpegData(compressionQuality: 0.5)
                //                    if value != nil {
                xx = "\(imgData!)"
                print("xxxxxxxxx : \(xx)")
                
                multipartFormData.append(imgData! , withName: key , fileName: "image.png" , mimeType: "image/png")
                //                    }
            }
            multipartFormData.append(String(Id).data(using: .utf8)!, withName: "PostId")
            multipartFormData.append(text!.data(using: .utf8)!, withName: "text")
            //                multipartFormData.append(xx.data(using: .utf8)!, withName: "Image")
            //
        }, usingThreshold:UInt64.init(),
        to: "\(url)", //URL Here
        method: .post,
        //            parameters: nil ,
        headers: header, //pass header dictionary here
        encodingCompletion: { (result) in
            
            switch result {
            case .success(let upload, _, _):
                //  //                      uploadView.isHidden = false
                upload.uploadProgress(closure: { (progress) in
                    print("Download Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { response in
                    
                    print("response : \(response)")
                    
                    switch response.result {
                    case .success(let value) :
                        let json = JSON(value)
                        // let jsonUser = json["user"]
                        print("json = \(json)")
                        
                        if json["Status"] == 0 {
                            
                            completion(nil , true , json["Message"].string ?? "" )
                            
                        } else {
                            completion(nil , false , json["Message"].string ?? "" )
                        }
                        
                    case .failure(let error) :
                        completion(error , false  ,"Server error")
                    }
                }
                break
            case .failure(let encodingError):
                print("the error is  : \(encodingError.localizedDescription)")
                
                completion(encodingError , false , "")
                
            }
        })
        //        }
    }
    
    //MARK: ------- Reacts ----------
    
    
    /// -------------------- Post React  -------------
    class func  addOrRemovePostReact (Type : String , PostId : Int , ReactTypeId : Int , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        var jsonStringParam : [String : Any]
        
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        var  url = ""
        
        if Type == "post" {
            url = URLs.AddOrRemovePostReact
            jsonStringParam  = [ "PostId" : PostId, "ReactTypeId" : ReactTypeId  ]
        } else {
            url = URLs.AddOrRemoveLiveReact
            jsonStringParam  = [ "LiveId" : PostId, "ReactTypeId" : ReactTypeId  ]
            
        }
        
        Alamofire.request(url, method: .post, parameters: jsonStringParam , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                }
            }
        
    }
    
    
    /// -------------------- Live React  -------------
    class func  addOrRemoveLiveReact ( LiveId : Int , ReactTypeId : Int , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let jsonStringParam : [String : Any] = [ "LiveId" : LiveId, "ReactTypeId" : ReactTypeId  ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.AddOrRemoveLiveReact
        
        Alamofire.request(url, method: .post, parameters: jsonStringParam , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                }
            }
        
    }
    
    /// -------------------- Add post tofavourite  -------------
    class func  addOrRemoveFavouritePost ( PostId : Int ,  completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let jsonStringParam : [String : Any] = [ "PostId" : PostId ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.AddOrRemoveFavouritePost
        
        Alamofire.request(url, method: .post, parameters: jsonStringParam , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                }
            }
        
    }
    
    /// -------------------- Add Pin tofavourite  -------------
    class func  addOrRemovePinPost ( PostId : Int ,  completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        //       let jsonStringParam : [String : Any] = [ "PostId" : PostId ]
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        let url = URLs.AddOrRemovePinPost+"\(PostId)"
        
        Alamofire.request(url, method: .get , parameters: nil , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                    
                }
            }
        
    }
    
    
    
    
    /// ---------- Get All PDFs
    
    
    class func  GetAllPDfs (pagenum:Int, completion : @escaping (_ error : Error? ,_ pdfmodel : [CategoryModel]? ,  _ message : String? ) ->Void) {
        
        let url = URLs.GetAllPDF+"\(pagenum)"
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: header )
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , nil  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print("json ::\(json)")
                    
                    let jsonResponse              = json["Response"]
                    var ArrCategory           = [CategoryModel]()
                    var ArrPDfs           = [PDFModel]()
                    
                    guard let jsonResponseToArr = jsonResponse.array else {
                        completion( nil ,nil , json["Message"].string ?? "" )
                        return
                    }
                    for data in jsonResponseToArr {
                        if data["PDFs"].array == nil || data["PDFs"].array?.isEmpty == true  {
                        } else {
                            guard let jsonResponseCourse = data["PDFs"].array else {
                                return
                            }
                            for pdf in jsonResponseCourse {
                                let pdfobject = PDFModel(CreationTime: pdf["CreationTime"].string ?? "", Title: pdf["Title"].string ?? "", Id: pdf ["Id"].int ?? 0, Url: pdf ["Url"].string ?? "", UserImage: pdf ["UserImage"].string ?? "" , UserId: pdf["UserId"].string ?? "", FirstName: pdf ["FirstName"].string ?? "")
                                ArrPDfs.append(pdfobject)
                                
                            }
                        }
                        let object = CategoryModel(Id: data["Id"].int ?? 0, Name: data["Name"].string ?? "", PDFModel: ArrPDfs)
                        
                        ArrCategory.append(object)
                        print("..json....\(ArrCategory)")
                        
                        ArrPDfs.removeAll()
                    }
                    completion(nil , ArrCategory , json["Message"].string ?? "")
                }
            }
    }
    
    
    
    
    
    enum Category {
        case add
        case edit
        case delete
    }
    
    class func  PDFCategory(type : Category , Id : Int? ,  Name : String? , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        var jsonString : [String : Any]
        var url : String!
        
        switch type {
        case .add:
            url = URLs.AddPDFCategory
            jsonString = ["Name" : Name ?? "" ]
        case .edit:
            url = URLs.AddPDFCategory
            jsonString = ["Id" : Id ?? 0 , "Name" : Name!]
        case .delete:
            url = URLs.DeletePDFCategory
            jsonString = ["Id" : "\(Id ?? 0)" ]
        }
        
        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , -1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                }
            }
    }
    

    
    // MARK: ------- upload Document (PDF)
        class func uploadFileMultiPart( pdfDocument : Data , completion : @escaping( _ error : Error? , _ success : Int? , _ message : String? ,_ uploadedPdfURL : String? ) ->Void) {
            
            let url = URLs.UploadPDF
            let header : HTTPHeaders = ["content-type" : "multipart/form-data"  , "Authorization" : Helper.getAccessToken() ]
            
            let document = ["file" : pdfDocument ]
            Alamofire.upload(multipartFormData: { multipartFormData in
                //Parameter for Upload files
                for (key,value) in document {
                    multipartFormData.append(value as Data, withName: key , fileName: "logo.PDF" , mimeType: "file/pdf")
                }
            }, usingThreshold:UInt64.init(),
            to: "\(url)", //URL Here
            method: .post,
            headers: header, //pass header dictionary here
            encodingCompletion: { (result) in
                
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        switch response.result {
                        case .success(let value) :
                            let json = JSON(value)
                            print("Multipart json = \(json)")
                            completion(nil , 0 , "Document uploaded", json.string! )
                        //                            Shared.shared.receivedPostImageUrlString = URLs.ImageBaseURL + json.string!
                            
                        //                            // add your Post Here
                            print("PDF url : \(URLs.ImageBaseURL + json.string!)" )
                        case .failure(let error) :
                            completion(error , 1  ,"Server error" , nil)
                        }
                    }
                    break
                case .failure(let encodingError):
                    print("the error is  : \(encodingError.localizedDescription)")
                    completion(encodingError , 1 , "Failed to uploud" , nil)
                }
            })
        }
    
    
    
    
    
    
    
    enum PdfEnum {
        case add
        case edit
        case delete
    }
    
    class func  UploadPDF(type : PdfEnum , PDFCategoryId : Int ,  Title : String? , Url : String? , completion : @escaping (_ error : Error? , _ status : Int ,_ message : String? ) ->Void) {
        
        let header = [ "content-type" : "application/json"  , "Authorization" : Helper.getAccessToken() ]
        var jsonString : [String : Any]
        var url : String!
        
        switch type {
        case .add:
            url = URLs.AddPDF
            jsonString = ["PDFCategoryId" : PDFCategoryId  , "Title" : Title ?? ""  , "Url" : Url ?? ""    ]
        case .edit:
            url = URLs.EditPDF
            jsonString = ["Id" : PDFCategoryId  , "Title" : Title ?? ""  , "Url" : Url ?? ""    ]
        case .delete:
            url = URLs.DeletePDF
            jsonString = ["Id" : PDFCategoryId ]
        }
        
        Alamofire.request(url, method: .post, parameters: jsonString , encoding: JSONEncoding.default, headers: header)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .failure(let error) :
                    completion(error , 1  , "" )
                case .success(let value) :
                    let json = JSON(value)
                    print(json)
                    
                    if json["Status"] == 0 && json["Message"] == "Success"{
                        completion(nil , 0 ,json["Message"].string ?? "")
                        
                    } else {
                        completion(nil , -1 ,json["Message"].string ?? "")
                        
                    }
                }
            }
    }
    
    
}

