//
//  MyCourses.swift
//  Work Courses LMS
//
//  Created by Arpit on 10/2/20.
//  Copyright © 2020 Dev Abhi. All rights reserved.
//

import UIKit

//MARK:- Data
// MARK: Slide
public struct Slide: Codable {
    public var slide: String?

    enum CodingKeys: String, CodingKey {
        case slide = "slide"
    }

    public init(slide: String?) {
        self.slide = slide
    }
}

// MARK: Course
public struct Course: Codable {
    public var coursename: String?
    public var slides : [String]?
    
    enum CodingKeys: String, CodingKey {
        case coursename = "coursename"
    }
    public init(coursename: String?) {
        self.coursename = coursename
    }
}

public struct MyCourses : Codable {
    public var courses : [Course]?
    public var count : Int {
        get {
            return courses?.count ?? 0
        }
    }
    enum CodingKeys: String, CodingKey {
        case courses = "courses"
    }
    public init(courses: [Course]?) {
        self.courses = courses
    }
}


// MARK: URLSession response handlers

public extension URLSession {
    func myCoursesTask(with url: URL, completionHandler: @escaping (Course?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(withUrl: url, completionHandler: completionHandler)
    }
    
    func slideTask(with url: URL, completionHandler: @escaping (Slide?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(withUrl: url, completionHandler: completionHandler)
    }
}


//MARK:- Controller
class TVCMyCourses : UITableViewController {
    var myCourses : MyCourses! {
        didSet {
            self.tableView.reloadData()
        }
    }
    var activeCourse : Course?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCourses()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.activeCourse = nil
    }
    
    func setRefreshController() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .white
        self.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender:Any) {
        self.loadCourses()
    }
    
    func loadCourses() {
        let p = WDManager.EndPoints.myCourses.url(query: "loggedin=\(String(describing: Preferences().auth?.email))")
        let task = URLSession.shared.myCoursesTask(with: p) { (course, response, error) in
            
            //TODO: Remove this statci code and make it dynamic
            let cn = ["Equal Opportunity", "Hazard Awareness and Reporting", "Apply First Aid", "Apply First Aid", "Apply First Aid"]
            let slides = ["Equal Opportunity":["166"],
                         "Hazard Awareness and Reporting":["167"],
                         "Apply First Aid":["1638","1639","1640","1641","1642","1643","1644","1645"]]
            var ca : [Course] = []
            for n in cn {
                var c = Course(coursename: n)
                c.slides = slides[n]
                ca.append(c)
            }
            DispatchQueue.main.async {
                self.myCourses = MyCourses(courses: ca)
            }
        }
        task.resume()
    }
}


//MARK- Table view delegate
extension TVCMyCourses {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myCourses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = myCourses.courses?[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ci_course")
        cell?.textLabel?.text = c?.coursename
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //var selectedMoment = self.momentFeed[indexPath.row]
        self.activeCourse = self.myCourses.courses?[indexPath.row]
        self.performSegue(withIdentifier: "si_courseListtoContent", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WebBrowser {
            vc.wbDataSource = self
            vc.navigationItem.title = self.activeCourse?.coursename
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
}

extension TVCMyCourses : WebBrowserDataSource {
    func getURL(for b: WebBrowser, index: Int) -> URL? {
        guard index < (self.activeCourse?.slides?.count ?? 0) else {return nil}
        
        if let slide = self.activeCourse?.slides?[index] {
            return WDManager.EndPoints.courseContent.url(query: "id=\(slide)")
        }
        return nil
    }
}
