//
//  ViewController.swift
//  TikTok
//
//  Created by Alsahlani, Yassin K on 1/22/20.
//  Copyright © 2020 Alsahlani, Yassin K. All rights reserved.
//

/*
 
    TODO: remove the lines inbetween the cells and add custom one
 
 */

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //Search Bar
    var searchBar = UISearchBar()
    let lightGrey = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    
    // Measurement Variables
    var width: CGFloat!
    var height: CGFloat!
    
    // Table View Variables
    var tableResultView = UITableView()
    var cellIdentifier = "Cell"
    var filteredArray = [String]()
    
    // Clear Search History Button
    var clear = UILabel()
    var horizontalBar = UIView()
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        height = view.frame.height
        self.setupSearchBar()
        self.setupTableView()
        loadTestList()
        self.createClearSearchHistoryView()
        self.clear.alpha = 0
        self.horizontalBar.alpha = 0
        self.createHorizontalBar()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupSearchBar() {
        searchBar.delegate = self;
        searchBar.placeholder = "Search"
        
        self.view.addSubview(searchBar)
        
        searchBar.frame = CGRect.zero
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: height/10).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: width).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = CGColor(srgbRed: 255, green: 255, blue: 255, alpha: 1)
        
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red:0.93, green:0.11, blue:0.32, alpha:1.0)]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
    
    func setupTableView() {
        view.addSubview(tableResultView)
        tableResultView.alpha = 0
        tableResultView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableResultView.translatesAutoresizingMaskIntoConstraints = false
        tableResultView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableResultView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableResultView.widthAnchor.constraint(equalToConstant: width).isActive = true
        tableResultView.dataSource = self
        tableResultView.delegate = self
        tableResultView.isEditing = false
        tableResultView.separatorStyle = .none
    }
    
    func loadTestList() {
        filteredArray = [
        "Apple",
        "Banana",
        "Carrot",
        "Broccoli",
        "Watermelon",
        "Orange"]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(filteredArray[indexPath.row])")
        currentIndex = indexPath.row
        nextView(text: filteredArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel!.text = "\(filteredArray[indexPath.row])"
        cell.imageView?.image = UIImage(named: "recent")
        var imageView = UIImageView(image: UIImage(named: "close"))
        cell.accessoryView = imageView
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.handleDelete(_:)))
        cell.accessoryView?.isUserInteractionEnabled = true
        cell.accessoryView!.addGestureRecognizer(labelTap)
        
        labelTap.name = "\(indexPath.row)"
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        tableResultView.alpha = 1
        clear.alpha = 1
        horizontalBar.alpha = 1
        print("Editingg")
        tableResultView.heightAnchor.constraint(equalToConstant: tableResultView.contentSize.height).isActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tableResultView.alpha = 0
        clear.alpha = 0
        horizontalBar.alpha = 0
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.setShowsCancelButton(false, animated: true)
        // You could also change the position, frame etc of the searchBar
        searchBar.endEditing(true)
    }
    
    // Not Working Fully. Adds to array but not dynamically added to tableview
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        print("Searching")
        if searchBar.text != nil {
            if filteredArray.count == 10 {
                filteredArray.insert(searchBar.text!, at: 0)
                tableResultView.reloadData()
                nextView(text: searchBar.text!)
            } else {
                filteredArray.append(searchBar.text!)
                tableResultView.reloadData()
                nextView(text: searchBar.text!)
            }
        }
        
        
    }
    
    func nextView(text: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        
        nextViewController.searchedValue = text
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func createClearSearchHistoryView() {
        clear.text = "Clear search history"
        clear.textColor = .gray
        //TODO: Add actual font
        clear.sizeToFit()
        clear.font = clear.font.withSize(width/30)
        clear.textAlignment = .center
        
        view.addSubview(clear)
        
        clear.frame = CGRect.zero
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        clear.heightAnchor.constraint(equalToConstant: clear.font.pointSize * 1.5).isActive = true
        clear.widthAnchor.constraint(equalToConstant: width*0.6).isActive = true
        clear.topAnchor.constraint(equalTo: tableResultView.bottomAnchor, constant: 20).isActive = true
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.handleClear(_:)))
        self.clear.isUserInteractionEnabled = true
        self.clear.addGestureRecognizer(labelTap)
    }
    
    func createHorizontalBar() {
        horizontalBar.backgroundColor = .systemGray5
        view.addSubview(horizontalBar)
        
        horizontalBar.frame = CGRect.zero
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        horizontalBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        horizontalBar.widthAnchor.constraint(equalToConstant: width*0.9).isActive = true
        horizontalBar.topAnchor.constraint(equalTo: clear.bottomAnchor, constant: 20).isActive = true
    }

    @objc func handleClear(_ sender: UITapGestureRecognizer) {
        print("Clear")
        filteredArray = []
        tableResultView.reloadData()
    }
    
    @objc func handleDelete(_ sender: UITapGestureRecognizer) {
        print("Delete")
        print(Int(sender.name!))
        filteredArray.remove(at: Int(sender.name!)!)
        filteredArray = filteredArray.filter({ $0 != ""})
        tableResultView.reloadData()
    }
}

// TODO: Possibly use custom cell, however default cells work too
//class MyCell: UITableViewCell {
//
//    var myTableViewController: ViewController?
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Sample Item"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        return label
//    }()
//
////    let actionButton: UIButton = {
////        let button = UIButton(type: .system)
////        button.setTitle("Delete", for: .Normal)
////        button.translatesAutoresizingMaskIntoConstraints = false
////        return button
////    }()
//
//
//        self.addSubview(nameLabel)
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
//
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
////        addSubview(actionButton)
//
////        actionButton.addTarget(self, action: "handleAction", forControlEvents: .touchUpInside)
//
//    }
//
//    func handleAction() {
////        myTableViewController?.deleteCell(self)
//    }
//
//}

