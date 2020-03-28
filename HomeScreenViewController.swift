//
//  HomeScreenViewController.swift
//  wodcrush
//
//  Created by michael gunnulfsen on 02/01/2020.
//  Copyright © 2020 michael gunnulfsen. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gymBoxes: [GymBox] = []
    var documentsPath = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocalImages()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func getLocalImages () {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if (documentsPath.count > 0) {
            self.documentsPath = documentsPath[0]
        }
    }
    
    func fetchData () {
        let url = URL(string: "https://shift-music.herokuapp.com/rest-api/wods")!
        print("Fething data...")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if error != nil {
                print("Fetch data error")
                print(error)
            } else {
                print("Got data, parsing...")
                if let urlContent = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        if let gymBoxes = jsonResult as? [[String: Any]] {
                            DispatchQueue.main.async {
                                self.renderData(gymBoxes: gymBoxes)
                                self.tableView.reloadData()
                                print("done parsing... \(self.gymBoxes.count)")
                            }
                            
                        }
                        
                    } catch {
                        print("JSON processing failed")
                    }
                }
            }
        }
        
        task.resume()
    
    }
    
    func renderData (gymBoxes: [[String: Any]]) {
        for gymBox in gymBoxes {
            let gymName = gymBox["boxName"] as? String
            let address = gymBox["address"] as? String
            var workoutStrings = ""
            if let workouts = gymBox["workouts"] as? NSArray {
                for (index, workout) in workouts.enumerated() {
                    let workout = workout as? NSDictionary
                    let wodText = workout?["workoutString"] as! String
                    if (index == 0) {
                        workoutStrings = wodText
                    } else if (index == workouts.count - 1) {
                        workoutStrings += "\n\n------------------------------\n\n"
                        workoutStrings += wodText
                    } else {
                        workoutStrings += "\n\n------------------------------\n\n"
                        workoutStrings += wodText
                    }
                    
                    if let instructions = workout?["instructions"] {
                        let instructionString = instructions as! String
                        
                        if (instructionString != "") {
                              workoutStrings += "\n\nInstructions: \(instructions)\n"
                        }
                    }
                }
            }
            
            
            let imageUri = gymBox["image"] as? String
            let box = GymBox(gymName: gymName!, wodText: workoutStrings, address: address!, imageLogoUri:imageUri!)
            self.gymBoxes.append(box)
        }
    }
    
    @objc
    func wodTextPressed(text: String) {
        let header = "\(String(text.prefix(24)))..."
        // 1
        let optionMenu = UIAlertController(title: nil, message: header, preferredStyle: .actionSheet)
        
        // 2
        let action = UIAlertAction(title: "YouTube it 📺", style: .default, handler: {(alert: UIAlertAction!) in self.onGoToYoutube(text: text)})
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        optionMenu.addAction(action)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func onGoToYoutube(text: String) {        
        var viewControllerStoryboardId = "YouTubeViewController"
        var storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: viewControllerStoryboardId) as! YouTubeViewController
        
        vc.text = text
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymBoxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GymBoxCell") as! GymBoxCell
        let gymBox = gymBoxes[indexPath.row]
        cell.renderGymBox(gymBox: gymBox)
        cell.fetchImage(documentsPath: self.documentsPath)
        
        // create the onpress callback, that will open the
        // youtube action sheet
        cell.selectionCallback = { (text) -> Void in
            self.wodTextPressed(text: text)
        }
        
        return cell
    }
    
    
}

