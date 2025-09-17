//
//  FeedViewController.swift
//  Prototype
//
//  Created by Parth Thakkar on 2025-06-24.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}

class FeedViewController: UITableViewController {

    private var feed = [FeedImageViewModel]()
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    
        onViewIsAppearing = { feedViewController in
            feedViewController.refresh()
            feedViewController.onViewIsAppearing = nil
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
        let viewModel = feed[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    // MARK: - Refresh Control
    
    @objc private func refresh() {
        refreshControl?.beginRefreshing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.feed.isEmpty {
                self.feed = FeedImageViewModel.prototypeData
                self.tableView.reloadData()
            }
            self.refreshControl?.endRefreshing()
        }
    }
}

extension FeedImageCell {
    func configure(with viewModel: FeedImageViewModel) {
        descriptionLabel.text = viewModel.description
        descriptionLabel.isHidden = viewModel.description == nil
        
        locationLabel.text = viewModel.location
        locationContainer.isHidden = viewModel.location == nil
        
        fadeIn(UIImage(named: viewModel.imageName))
    }
}
