//
//  AddFormViewController.swift
//  Handzap
//
//  Created by Jagan on 18/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import UIKit
import CoreData
import AVKit
class AddFormViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var addFormModel:AddFormViewModel!
    @IBOutlet var textFieldsData:[UITextField]!
    @IBOutlet weak  var limitTextLabel:UILabel!
    @IBOutlet weak  var addFormButtom:UIButton!
    var isAddedData:((Bool)->(Void))?
    var uPloadingFilesArray = [UploadedDataArray]()
    @IBOutlet weak var collectionView:UICollectionView!
    private let cellID = "CollectionViewCell"

    let datePicker = UIDatePicker()
    var picker = UIPickerView()
    private var maxTextCount = 330

    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        picker.delegate = self
        picker.dataSource = self
        textFieldsData[3].setLeftView(leftImageView: UIImage(named: "US") ?? UIImage(), bgColor: .clear)
        let collectionViewCell = UINib(nibName: cellID, bundle: nil)
        self.collectionView.register(collectionViewCell, forCellWithReuseIdentifier: cellID)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
    //MARK:- ButtonAction
    @IBAction func dismisButtonTapped(_sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func attachmentButtonTapped(_sender:UIButton){
        DispatchQueue.main.async {
            self.addFormModel.addingActions(viewcontroller: self)
        }
    }
    @IBAction func saveFormButtonTapped(_sender:UIButton){
        addFormModel.addingNewForm(textFieldsData: textFieldsData) { (isFilledData, isSavedData) -> (Void) in
            if isFilledData == true {
                if isSavedData == true {
                    self.isAddedData?(true)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.addFormModel.presentingAlert(viewController: self, title: "Error", message: "Please try again")
                }
            }else{
                self.addFormModel.presentingAlert(viewController: self, title: "Error", message: "Please enter required fields")
            }
        }
    }
    
    //MARK:- Method to handle datepickerview
    func showDatePicker(){
        datePicker.datePickerMode = .date
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        addFormModel.addingToolBar(barButtonItems: [doneButton,spaceButton,cancelButton], textField: textFieldsData[6])
        textFieldsData[6].inputView = datePicker
        let budGetDoneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelDatePicker));
        addFormModel.addingToolBar(barButtonItems: [budGetDoneButton], textField: textFieldsData[2])
        for i in textFieldsData{
            i.setBottomLine(colour: .lightGray)
        }
    }
    
    @objc func donedatePicker(){
        addFormModel.donedatePicker(datePicker: datePicker, textField: textFieldsData[6])
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    //MARK:- Picker view delegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        addFormModel?.printingSelectedData(textFields: textFieldsData, row: row)
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addFormModel?.numberOfRowsInComponent() ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return addFormModel?.titlesForComponent(row: row)
    }
    
    //MARK:-Textfield delegatemethod
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           if(textField == textFieldsData[1]){
               let strLength = textField.text?.count ?? 0
               let lngthToAdd = string.count
               let lengthCount = strLength + lngthToAdd
               limitTextLabel.text = "\(maxTextCount-lengthCount) characters left"
           }
           return true
       }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setBottomLine(colour: .black)

        addFormModel?.changingPickerViewData(textField: textField, textFieldsData: textFieldsData, picker: picker)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setBottomLine(colour: .lightGray)
    }
}
extension AddFormViewController:UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    //MARK:-Image Pickerview delegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[.mediaType] as? String {
            if mediaType  == "public.image" {
                if let chosenURL = info[.imageURL] as? URL {
               let uploadingData = UploadedDataArray(fileName: chosenURL, fileType: "IMAGE")
                uPloadingFilesArray.append(uploadingData)
            }
            }
            if mediaType == "public.movie" {
                if let videoUrl = info[.mediaURL] as? URL {
             let uploadingData = UploadedDataArray(fileName: videoUrl, fileType: "VIDEO")
                        uPloadingFilesArray.append(uploadingData)
                }
                else{
                    print("Something went wrong in video")
                }
              }
          }
        picker.dismiss(animated: true)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension AddFormViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    //MARK:-Collection view methds to display uploaded media
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return  self.uPloadingFilesArray.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell{
        let attachmentsData = uPloadingFilesArray[indexPath.row]
        if attachmentsData.fileType == "IMAGE"  {
            cell.playButon.isHidden = true
            if let fileURL = attachmentsData.fileName{
                let imageData = try? Data(contentsOf: fileURL)
                if let data = imageData{
                    cell.thumbNailImage.image = UIImage(data: data)
                }
            }
        }
        else if attachmentsData.fileType == "VIDEO" {
            cell.playButon.isHidden = false

            if let fileURL = attachmentsData.fileName{
            let asset = AVAsset(url:fileURL)
            let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            let time = CMTimeMake(value: 1, timescale: 2)
            let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            if img != nil {
                let frameImg  = UIImage(cgImage: img!)
                    cell.thumbNailImage.image = frameImg
               }
           }
        }
        return cell
    }
    return UICollectionViewCell()
}
}
