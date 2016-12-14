//
//  ViewController.swift
//  StarWarsEncyclopedia
//
//  Created by oscar echeverria on 12/13/16.
//  Copyright © 2016 oscar echeverria. All rights reserved.
//

import UIKit

class PeopleViewController: UITableViewController  {
    
    
    // Cached data
    var people = [Person]()
   
    
    // How many cells should I have?
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the count of people
        return people.count
    }
    
    // How should each cell look?
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Step 1: Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell")!
        
        // Step 2: Setting cell data and cell styling
        cell.textLabel?.text = self.people[indexPath.row].name
        
        // Step 3: Return the cell so that it can be rendered
        return cell
        
    }

   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Will run the NSURL code to get star wars data
        self.swAPI()
 
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Helper functions --------------------------------
    
    func swAPI(){
        
        // Specify the url that we will be sending the GET Request to
        let url = NSURL(string: "http://swapi.co/api/people/")
        // Create an NSURLSession to handle the request tasks
        let session = URLSession.shared
        // Create a "data task" which will request some data from a URL and then run a completion handler after it is done
        let task = session.dataTask(with: url! as URL, completionHandler: {
            data, response, error in
            do{
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    
                    // This is where we play with the JSON data..
                    
                    
                    if let results = jsonResult["results"] {
                        let resultsArray = results as! NSArray
                        
//                        print(resultsArray.count)
//                        print(resultsArray.firstObject!)
                        
                        
                        for x in resultsArray {
                            let thisPerson = x as! NSDictionary
                            
                            // Defaults
                            var nameSave = "no name"
                            var massSave = "n/a"
                            var heightSave = "n/a"
                            
                            if let name = thisPerson["name"] {
                                nameSave = name as! String
                            }
                            if let mass = thisPerson["mass"] {
                                massSave = mass as! String
                            }
                            if let height = thisPerson["height"] {
                                heightSave = height as! String
                            }
                            
                            
                            self.people.append(Person(name: nameSave, mass: massSave, height: heightSave))
                        }
                        
                        DispatchQueue.main.async(execute: {
                            // Load the new data into the table
                            self.tableView.reloadData()
                        })
                     
                        
               
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
            } catch {
                print("Something Went wrong")
            }
        })
        // Actually "execute" the task. This is the line that actually makes the request that we set up above
        task.resume()
        
        
        
    }
    
    


}

