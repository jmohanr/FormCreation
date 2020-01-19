//
//  ViewController.swift
//  Handzap
//
//  Created by Jagan on 18/01/20.
//  Copyright © 2020 Jagan. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    private let cellID = "TableViewCell"
    
    @IBOutlet weak var listViewModel:FormListViewModel!
    @IBOutlet weak var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableViewCell = UINib(nibName: cellID, bundle: nil)
        self.tableView.register(tableViewCell, forCellReuseIdentifier: cellID)
         self.fetchingData()
    }
    //MARK:-Fetching data from core data
    func fetchingData(){
        listViewModel.fetchingData { (sucess) -> (Void) in
            DispatchQueue.main.async{
            self.tableView.reloadData()
        }
     }
    }
    //MARK:-Navigation methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addFormPage") {
            if let vc = segue.destination as? AddFormViewController {
                vc.isAddedData = {[weak self] sucess in
                    if sucess == true {
                        self?.fetchingData()
                    }
                }
            }
        }
    }
}
extension ViewController:UITableViewDataSource{
    //MARK:-Tableview delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.numberOfrows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? TableViewCell {
            cell.formTitleLabel.text = listViewModel.displayingFormTitle(row: indexPath.row)
            cell.startDateLabel.text = listViewModel.displayingSatrtDate(row: indexPath.row)
            cell.rateLabel.text = listViewModel.displayingRate(row: indexPath.row)
            cell.jobTermLabel.text = listViewModel.displayingFormjobTerm(row: indexPath.row)
            cell.postSettingButton.tag = indexPath.row
            cell.postSettingButton.addTarget(self, action: #selector(didTapEditButton(_:)), for: .touchUpInside)

            return cell
        }
        return UITableViewCell()
    }
    
    //MARK:-Button Actions
    @objc func didTapEditButton(_ sender:UIButton){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Form", style: .destructive) { (alert) in
            self.listViewModel.deleteFormFromCoreData(title: self.listViewModel.displayingFormTitle(row: sender.tag)) { (sucess) -> (Void) in
                if sucess == true {
                    self.fetchingData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let image = UIImage(named: "Trash icon")
        deleteAction.setValue(image, forKey: "image")
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
