//
//  AddFormViewModel.swift
//  Handzap
//
//  Created by Jagan on 19/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos
import CoreMIDI

class AddFormViewModel: NSObject {
    var selectedTextData:FormTypeData?
    
    func donedatePicker(datePicker:UIDatePicker,textField:UITextField){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        textField.text = formatter.string(from: datePicker.date)
    }
    
    //MARK:- Storing the formdata into coredata
    func addingNewForm(textFieldsData:[UITextField],completion:@escaping((Bool,Bool)->(Void))){
        var dataDict = [String:Any]()
        if textFieldsData[0].text == "" || textFieldsData[2].text == "" || textFieldsData[6].text == "" {
            completion(false,false)
        }else{
            dataDict = ["formTitle":textFieldsData[0].text ?? "","formDescription":textFieldsData[1].text ?? "","budget":"\(textFieldsData[2].text ?? "")","currencyType":textFieldsData[3].text ?? "","rate":textFieldsData[4].text ?? "","paymentmethod":textFieldsData[5].text ?? "","startDate":textFieldsData[6].text ?? "","jobTerms":textFieldsData[7].text ?? ""]
            CoredataStack.createData(inputData: dataDict) { (sucess) -> (Void) in
                if sucess == true {
                    completion(true,true)
                    
                }else{
                    completion(true,false)
                    
                    print("error while saving")
                }
            }
        }
    }
    
    func numberOfRowsInComponent()->Int{
        return selectedTextData?.data?.count ?? 0
    }
    func titlesForComponent(row:Int)->String{
        return selectedTextData?.data?[row] ?? ""
    }
    //MARK:-Changing the pickerviewdata based on the event
    func changingPickerViewData(textField:UITextField,textFieldsData:[UITextField],picker:UIPickerView){
        switch textField {
        case textFieldsData[4]:
            selectedTextData = FormTypeData(selectedtype: "Rate", data: ["NoPreference","FixedBudget","HourlyRate"])
            textFieldsData[4].inputView = picker
            picker.reloadAllComponents()
        case textFieldsData[7] :
            selectedTextData = FormTypeData(selectedtype: "Job Term", data: ["NoPreference","Recuring Job","SameDay Job","MultiDays Job"])
            
            textFieldsData[7].inputView = picker
            picker.reloadAllComponents()
        case textFieldsData[5]:
            selectedTextData = FormTypeData(selectedtype: "PayMent", data: ["NoPreference","Cash","E-Payment"])
            textFieldsData[5].inputView = picker
            picker.reloadAllComponents()
        default:
            break
        }
    }
    
    func printingSelectedData(textFields:[UITextField],row:Int){
        let type = selectedTextData?.selectedtype
        switch type {
        case "Rate":
            textFields[4].text = selectedTextData?.data?[row]
        case "Job Term" :
            textFields[7].text = selectedTextData?.data?[row]
        case "PayMent" :
            textFields[5].text = selectedTextData?.data?[row]
            
        default:
            break
        }
    }
    func presentingAlert(viewController:UIViewController,title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert .addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
  
    
    func addingToolBar(barButtonItems:[UIBarButtonItem],textField:UITextField){
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.setItems(barButtonItems, animated: false)
        textField.inputAccessoryView = toolbar
    }
    //MARK:-Presenting the actions for uploading media
    func addingActions(viewcontroller:UIViewController){
        let actionSheet = UIAlertController(title: ImageConstants.actionFileTypeHeading, message: nil, preferredStyle: .actionSheet)
              actionSheet.addAction(UIAlertAction(title: ImageConstants.cancelBtnTitle, style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: ImageConstants.camera, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, viewcontroller: viewcontroller)
        }))
        actionSheet.addAction(UIAlertAction(title: ImageConstants.phoneLibrary, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, viewcontroller: viewcontroller)
        }))
        actionSheet.addAction(UIAlertAction(title: ImageConstants.video, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .video, viewcontroller: viewcontroller)
        }))
        actionSheet.addAction(UIAlertAction(title: ImageConstants.videoRecord, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .videoRecord, viewcontroller: viewcontroller)
        }))
        viewcontroller.present(actionSheet, animated: true, completion: nil)

    }
    func authorisationStatus(attachmentTypeEnum: AttachmentType,viewcontroller:UIViewController){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            if attachmentTypeEnum == AttachmentType.camera{
                openCamera(viewcontroller: viewcontroller)
            }
            if attachmentTypeEnum == AttachmentType.photoLibrary{
                photoLibrary(viewcontroller: viewcontroller)
            }
            if attachmentTypeEnum == AttachmentType.video{
                videoLibrary(viewcontroller: viewcontroller)
            }
            if attachmentTypeEnum == AttachmentType.videoRecord{
                openVideoCamera(viewcontroller: viewcontroller)
            }
            
           
        case .denied:
            self.addAlertForSettings(attachmentTypeEnum, viewcontroller: viewcontroller)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    if attachmentTypeEnum == AttachmentType.camera{
                        self.openCamera(viewcontroller: viewcontroller)
                    }
                    if attachmentTypeEnum == AttachmentType.photoLibrary{
                        self.photoLibrary(viewcontroller: viewcontroller)
                    }
                    if attachmentTypeEnum == AttachmentType.video{
                        self.videoLibrary(viewcontroller: viewcontroller)
                    }
                }else{
                    self.addAlertForSettings(attachmentTypeEnum, viewcontroller: viewcontroller)
                }
            })
        case .restricted:
            self.addAlertForSettings(attachmentTypeEnum, viewcontroller: viewcontroller)
        default:
            break
        }
    }
    func addAlertForSettings(_ attachmentTypeEnum: AttachmentType,viewcontroller:UIViewController){
           var alertTitle: String = ""
           if attachmentTypeEnum == AttachmentType.camera{
               alertTitle = ImageConstants.alertForCameraAccessMessage
           }
           if attachmentTypeEnum == AttachmentType.photoLibrary{
               alertTitle = ImageConstants.alertForPhotoLibraryMessage
           }
           if attachmentTypeEnum == AttachmentType.video{
               alertTitle = ImageConstants.alertForVideoLibraryMessage
           }
           if attachmentTypeEnum == AttachmentType.videoRecord{
               alertTitle = ImageConstants.alertForCameraAccessMessage
           }
           
           let cameraUnavailableAlertController = UIAlertController (title: alertTitle , message: nil, preferredStyle: .alert)
           let settingsAction = UIAlertAction(title: ImageConstants.settingsBtnTitle, style: .destructive) { (_) -> Void in
               let settingsUrl = NSURL(string:UIApplication.openSettingsURLString)
               if let url = settingsUrl {
                   UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
               }
           }
           let cancelAction = UIAlertAction(title: ImageConstants.cancelBtnTitle, style: .default, handler: nil)
           cameraUnavailableAlertController .addAction(cancelAction)
           cameraUnavailableAlertController .addAction(settingsAction)
           viewcontroller.present(cameraUnavailableAlertController , animated: true, completion: nil)
       }
       
       //MARK: - CAMERA PICKER
       //This function is used to open camera from the iphone and
    func openCamera(viewcontroller:UIViewController){
           if UIImagePickerController.isSourceTypeAvailable(.camera){
               let myPickerController = UIImagePickerController()
            myPickerController.delegate = viewcontroller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
               myPickerController.sourceType = .camera
               DispatchQueue.main.async {
                viewcontroller.present(myPickerController, animated: true, completion: nil)
               }
           }
       }
       
       func openVideoCamera(viewcontroller:UIViewController){
           if UIImagePickerController.isSourceTypeAvailable(.camera) {
               let imagePicker = UIImagePickerController()
            imagePicker.delegate = viewcontroller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
               imagePicker.sourceType = .camera
               imagePicker.mediaTypes = [kUTTypeMovie as String]
               imagePicker.videoQuality = .typeHigh
               imagePicker.allowsEditing = true
               viewcontroller.present(imagePicker, animated: true, completion: nil)
           } else {
           }
       }
       //MARK: - PHOTO PICKER
       func photoLibrary(viewcontroller:UIViewController){
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
               let myPickerController = UIImagePickerController()
            myPickerController.delegate = viewcontroller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
               myPickerController.sourceType = .photoLibrary
               DispatchQueue.main.async {
                   viewcontroller.present(myPickerController, animated: true, completion: nil)
               }
           }
       }
       
       //MARK: - VIDEO PICKER
       func videoLibrary(viewcontroller:UIViewController){
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
               let myPickerController = UIImagePickerController()
            myPickerController.delegate = viewcontroller as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
               myPickerController.sourceType = .photoLibrary
               myPickerController.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
               DispatchQueue.main.async {
                viewcontroller.present(myPickerController, animated: true, completion: nil)
               }
           }
       }
}
