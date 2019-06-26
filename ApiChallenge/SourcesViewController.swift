//
//  ViewController.swift
//  ApiChallenge
//
//  Created by Dan Morton on 6/26/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

class SourcesViewController: UITableViewController {
    // api key
    let key = "5d892509a49046a087917c466fa80d09"
    
    // variable to hold raw data from http response
    var news : Any!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make a request to get all the news information on viewDidLoad()
        self.getNewsInformation()
    }

    // Function that forms a GET http request using URLSession to get news information from an external
    // api
    func getNewsInformation() {
        let url = URL(string: "https://newsapi.org/v1/sources?language=en&country=us&apiKey=\(key)")
        
        // Task object with closure to represent the httprequest
        // Closure is an asynchronous call, that occurs once the api has responded
        // with some data. At this point, the task has not been fired off yet 
        // ( no request has been made ) that is done with task.resume() below
        // this block of code.
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            // Make sure we can get the data back from the api response
            guard let dataResponse = data,
                error == nil else {
                    print("An error occured")
                    return
            }
            
            // do - catch block, meaning that an exception can potentially be thrown here
            // from JSONSerialization.jsonObject(with: ...)
            do {
                // Deserialize the response from the API into a json object we can access
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                self.news = jsonResponse
                
                // Call to function that will filter out and print the parts of the response
                // we are interested in
                self.filterNewsInfo(info: self.news)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        
        // Kick off the HTTP request to the api
        task.resume()
    }
    
    //Function that prints the name of each news source in the terminal
    func filterNewsInfo(info: Any) {
        // Uncomment this line to see what the raw JSON response looks like
        // print(info)
        
        // Upon inspection, the json object is a dictionary, containing one key value pair.
        // Initaially, cast the reponse to a dict to get at the information we need.
        guard let jsonDict = info as? [String: Any] else {
            print("Something went wrong")
            return
        }
        
        // The on key value pair has a key of 'sources' and a value of an array of more 
        // dictionaries. Get the key value from 'sources' and cast it to an array
        // of dictionaries to get at the information.
        guard let jsonArray = jsonDict["sources"] as? [[String: Any]] else {
            print("Something went wrong 2")
            return
        }
        
        // Loop the the array of dictionairies. Show the id from each dictionary to show
        // the name of the news source followed by a dashed line. More information can be 
        // extracted, such as dict["description"] if needed.
        for dict in jsonArray {
            print("Name \(dict["id"] as! String)")
            print("-------")
        }
    }

}

