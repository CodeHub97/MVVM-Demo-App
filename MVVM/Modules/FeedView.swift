//
//  feedView.swift
//  MVVM
//
//  Created by Gagan on 23/10/19.

import UIKit
class ListCell: UITableViewCell {
  @IBOutlet weak var lblTitle: UILabel!
  
  @IBOutlet weak var lblDetail: UILabel!
}

class FeedView: UIViewController {
  @IBOutlet weak var feedTableView: UITableView!
  var feedViewModel: FeedViewModel?
  override func viewDidLoad() {
    super.viewDidLoad()
   
    feedViewModel?.loadFeedData()
  
    feedViewModel?.onFeedUpated = { list in
      self.feedTableView.reloadData()
    }
  }
  
  
}
//MARK: - Table view
extension FeedView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return feedViewModel?.arrUsersList.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell =  feedTableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
      
      let user = feedViewModel?.arrUsersList[indexPath.row]
      cell.lblTitle.text = user?.title
      cell.lblDetail.text = user?.body
      return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
}
