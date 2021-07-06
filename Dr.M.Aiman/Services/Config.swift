//
//  config.swift
//  Dr.M.Aiman
//
//  Created by Muhamed Hammam on 31/05/2021.
//

import Foundation

struct URLs {
    
    static let BaseURL             = "https://dr-m.ayman.dr-mideo.co//api"
    static let ImageBaseURL             = "https://dr-m.ayman.dr-mideo.co/"

    //MARK: User
    /// post >   Email - MacAdress - FirstName - Gender( int ) - PhoneNumber - Image
    static let Register          = BaseURL + "/Account/Register"
    /// post >   Mobile - MacAdress - ConfirmationCode
    static let Login             = BaseURL + "/Account/Login"
    /// post  -- Content-Type: multipart/form-data;
    static let SaveUserImage         = BaseURL + "/Account/SaveImage"
    /// post  > Mobile
    static let RequestVerificationCode         = BaseURL + "/Account/RequestLoginConfirmationCode"
    /// post  > Email & macAddress
    static let ChangePassword         = BaseURL + "/Account/ChangePasswordAndSendEmail"

    /// get  >   Id - Email - PhoneNumber - FirstName - Image - Gender( ) - RoleName
    static let GetUser         = BaseURL + "/User/GetProfile"
   
    //MARK: Live Videos
    static let AddLive             = BaseURL + "/Live/AddNew"
    static let GetAllLives         = BaseURL + "/Live/GetAll/"
    static let DeleteLive          = BaseURL + "/Live/Remove/"

    ///Post  > "LiveId":1 "ReactTypeId":2    -->   -1= remove   & other = add other reacts
    static let AddOrRemoveLiveReact       = BaseURL + "/Live/AddOrRemoveReact"    //-----------------

    ///Post  > text and image
    static let AddLiveComment       = BaseURL + "/Live/AddComment"
    
    ///Get  > int ->  comment id
    static let DeleteLiveComment       = BaseURL + "/Live/DeleteComment/"
    
    ///Get  > int ->  comment id
    static let EditLiveComment       = BaseURL + "/Live/EditComment"
    
    

    //MARK: Posts
    ///GET  >  check Allow post
    static let CheckAllowPost            = BaseURL + "/Post/CheckAllowAccessPost"
  
    ///Post  > text and image
    static let AddPost              = BaseURL + "/Post/AddPost"

    ///tGet  > int ->  comment id
    static let DeletePost              = BaseURL + "/Post/DeletePost/"

    ///GET  >  userid / date / text / image / reactType /
    static let GetAllPosts          = BaseURL + "/Post/GetAll/"

    ///Post  > post id & text and image
    static let EditPost              = BaseURL + "/Post/EditPost"

    ///Post  > "PostId":3 ,    "ReactTypeId":1  -->   -1= remove   & other = add other reacts
    static let AddOrRemovePostReact              = BaseURL + "/Post/AddOrRemoveReact"   //--------------------

    ///Get  > post id in ENdPoint
    static let AddOrRemovePinPost              = BaseURL + "/Post/AddOrRemovePinPost/" ///----------
    
    
    ///Post  > post id
    static let AddOrRemoveFavouritePost              = BaseURL + "/Post/AddOrRemoveFavoritePost"
    
    ///Post  > text and image
    static let AddPostComment       = BaseURL + "/Post/AddComment"
    
    ///Get  > int ->  comment id
    static let DeletePostComment       = BaseURL + "/Post/DeleteComment/"
    
    ///Get  > int ->  comment id
    static let EditPostComment       = BaseURL + "/Post/EditComment"
    
   /// GET
    static let GetMyFavoritePost       = BaseURL + "/Post/GetMyFavoritePost"
   // {
//    "Status":0,
//    "Message":"Success",
//    "Response":[{"CreationTime":"2021-05-29T13:21:31.807",
//    "Id":3,
//    "text":"post-2","Image":"/Images/Post/c7wy7hrzh4I7cuA9ub5ECcvuoFxJawnGGHC3ecwnwooxDw76Kor2pmbawckmEBzEAblo2G4rzBioH7K1IA9GfvrtFCqb2jD4JE7B.jpg",
//    "UserId":"982b153f-a8eb-4688-a967-2484a856fcea",
//    "IsPinPost":false,
//    "UserImage":null,
//    "FirstName":"admin",
//    "ReactType":2,
//    "IsFavoritePost":true,
//    "ReactCount":1,"Comments":
//                     [{"CreationTime":"2021-05-30T20:37:37.007",
//                         "text":"comment-2",
//                           "Id":2,"Image":"/Images/Post/wbvFiFv9AizfHfivejmd1nnIzIx6fp61d63hcFGJKhIl37HGlr1uhdEiHGfuhz3klIbKmbttwxmEzc5Ca1EIywEamEtpAmCloyaf.jpg",
//                               "UserId":"982b153f-a8eb-4688-a967-2484a856fcea",
//                                "UserImage":null,
//                                 "FirstName":"admin"}]}]}

    
    //MARK:------ Universities
    ///Get  >
    static let GetUnivesitiesAndCourses       = BaseURL + "/Univeristy/get2"
    
    ///Get  >
    static let   GetCoursePlaylist    = BaseURL + "/playlists/GetByCourse/"

    //MARK:------ PDF
        
        ///Post >> "Name":"cat1"
        static let AddPDFCategory       = BaseURL + "/PDF/AddPDFCategory"
        
         ///Post >> "Id":1, "Name":"cat1-2"
        static let EditPDFCategory       = BaseURL + "/PDF/EditPDFCategory"
        
        /// Post >> "Id":"1"
        static let DeletePDFCategory       = BaseURL + "/PDF/DeletePDFCategory"

        /// Multipart - Accept-Encoding: gzip, deflate, br / Content-Type: multipart/form-data
        static let UploadPDF       = BaseURL + "/PDF/UploadPDFFile"

        /// Post >> "Title":"frist","Url":"get from UploadPDFFile Api", "PDFCategoryId":2
        static let AddPDF       = BaseURL + "/PDF/AddPDF"

    //    /// Post  >> "Id":"1", "Title":"frist-edit","Url":"get from UploadPDFFile Api"
        static let EditPDF       = BaseURL + "/PDF/EditPDF"

        /// Post >> Id":"1"
        static let DeletePDF       = BaseURL + "/PDF/DeletePDF"

        /// Get >> 0 is pageNumber
        static let GetAllPDF       = BaseURL + "/PDF/GetAll/"
    
    static let EditLive        = BaseURL + ""
    
    
    /// post  > Email & PhoneNumber &  FirstName
        static let editProfile         = BaseURL + "/User/EditProfile"
}
