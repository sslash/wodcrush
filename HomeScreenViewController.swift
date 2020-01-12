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
        let url = URL(string: "https://fde1d242.ngrok.io/rest-api/wods")!
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
                    let wodText = (workout as? NSDictionary)?["workoutString"] as! String
                    if (index == 0) {
                        workoutStrings = wodText
                    } else if (index == workouts.count - 1) {
                        workoutStrings += wodText
                    } else {
                        workoutStrings += wodText
                        workoutStrings += "\n\n========================\n\n"
                    }
                }
            }
            
            
            let imageUri = gymBox["image"] as? String
            let box = GymBox(gymName: gymName!, wodText: workoutStrings, address: address!, imageLogoUri:imageUri!)
            self.gymBoxes.append(box)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gymBoxes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let gymBox = gymBoxes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GymBoxCell") as! GymBoxCell
        cell.setGymBox(gymBox: gymBox)
        cell.fetchImage(documentsPath: self.documentsPath)
        
        return cell
    }
    
    
}

