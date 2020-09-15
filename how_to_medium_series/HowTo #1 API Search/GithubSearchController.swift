//
//  GithubSearchController.swift
//  how_to_medium_series
//
//  Created by Gokul on 14/09/20.
//  Copyright © 2020 techQrator. All rights reserved.
//

import UIKit

class GithubSearchController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet weak var tableView:UITableView!
    
    //MARK: - Var
    var dataSource = [UserInfo]()
    var searchQuery = ""
    //MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchBar()
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addSearchBar() {
        //Write this code in viewDidLoad() or your required function
        let searchBar:UISearchBar = UISearchBar()
        //IF you want frame replace first line and comment "searchBar.sizeToFit()"
        //let searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 10, y: 10, width: headerView.frame.width-20, height: headerView.frame.height-20))
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    //MARK: - API call
    @objc fileprivate func queryGitHubUsers() {
        print("#Search query: \(searchQuery)")
        guard let url = URL(string: "https://api.github.com/search/users?q=\(searchQuery)") else {return}
        var request = URLRequest(url:url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            do {
                let responseModel = try jsonDecoder.decode(GitHubSearchModel.self, from: data!)
                guard let info = responseModel.userInfo else {return}
                self.dataSource = info
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }

}

//MARK: - UISearchBarDelegate
extension GithubSearchController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        searchQuery = searchText
//        searchGithub()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        searchQuery = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector:#selector(queryGitHubUsers), object: nil)
        perform(#selector(queryGitHubUsers), with: nil, afterDelay: 1)
    }
}
//MARK: - UITableViewDelegate
extension GithubSearchController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell", for: indexPath) as! UserListCell
        cell.userInfo = dataSource[indexPath.row]
        cell.updateUI()
        return cell
    }
}

//MARK: - UITableViewCell
class UserListCell:UITableViewCell {
    @IBOutlet weak var userName:UILabel!
    @IBOutlet weak var userImage:UIImageView!
    @IBOutlet weak var userId:UILabel!
    
    var userInfo:UserInfo!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    fileprivate func updateUI() {
        userName.text = userInfo.login
        userId.text = "\(userInfo.id ?? 0)"
        if let url = userInfo.formatedImageURL {
            userImage.image = nil
            userImage.load(url: url)
        }
    }
    
}
