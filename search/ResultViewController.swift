//
//  ResultViewController.swift
//  search
//
//  Created by Ahmed Gedi on 2/3/20.
//  Copyright © 2020 Ahmed Gedi. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Search Bar
    var searchBar = UISearchBar()
    let lightGrey = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    var searchedValue = ""
    
    // Measurement Variables
    var width: CGFloat!
    var height: CGFloat!
    
    // Views
    var topView = UIView()
    var back = UIImageView()
    var collectionView: UICollectionView!
    var cellIdentifier = "Cell"
    var data: [Int] = Array(1..<6)
    var resultNav = UINavigationBar()
    var stackView = UIStackView()
    var horizontalBar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        width = view.frame.width
        height = view.frame.height
        navigationController?.navigationBar.backItem?.title = ""
        self.setupTopView()
        self.setupSearchBar()
        self.setupBackButton()
        self.setupStackView()
        self.createHorizontalBar()
        self.setUpCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupTopView() {
        view.addSubview(topView)

        topView.frame = CGRect.zero
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topView.heightAnchor.constraint(equalToConstant: height/10).isActive = true
        topView.widthAnchor.constraint(equalToConstant: width).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        topView.layer.borderWidth = 1
        topView.layer.borderColor = CGColor(srgbRed: 255, green: 255, blue: 255, alpha: 1)

    }
    
    func setupBackButton() {
        topView.addSubview(back)
        back.image = UIImage(named: "back")
        back.frame = CGRect.zero
        back.translatesAutoresizingMaskIntoConstraints = false
        back.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        back.heightAnchor.constraint(equalToConstant: (height/20)/2).isActive = true
        back.widthAnchor.constraint(equalToConstant: (height/20)/3).isActive = true
        back.rightAnchor.constraint(equalTo: searchBar.leftAnchor, constant: -(width*0.005)).isActive = true
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBack(_:)))
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(labelTap)
        
    }
    
    @objc func handleBack(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupSearchBar() {
       searchBar.delegate = self;
       searchBar.text = searchedValue
       topView.addSubview(searchBar)

       searchBar.frame = CGRect.zero
       searchBar.translatesAutoresizingMaskIntoConstraints = false
       searchBar.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalTo: topView.heightAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: width*0.9).isActive = true
        searchBar.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -10).isActive = true

       let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red:0.93, green:0.11, blue:0.32, alpha:1.0)]
       UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
   }

    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        self.view.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        print("Editingg")
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        tableResultView.alpha = 0
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Stop doing the search stuff and clear the text in the search bar
        searchBar.text = ""
        // Hide the cancel button
        searchBar.setShowsCancelButton(false, animated: true)
        // You could also change the position, frame etc of the searchBar
        searchBar.endEditing(true)
    }
    
    func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill // .leading .firstBaseline .center .trailing .lastBaseline
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        stackView.frame = CGRect.zero
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -10).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: height/20).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: width*0.85).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func createHorizontalBar() {
        let textLabel = UILabel()
        textLabel.text = "Results"
        textLabel.textAlignment = .center
        stackView.addArrangedSubview(textLabel)
        
        horizontalBar.backgroundColor = .black
        view.addSubview(horizontalBar)
        
        horizontalBar.frame = CGRect.zero
        horizontalBar.translatesAutoresizingMaskIntoConstraints = false
        horizontalBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        horizontalBar.heightAnchor.constraint(equalToConstant: 3).isActive = true
        horizontalBar.widthAnchor.constraint(equalToConstant: width/4).isActive = true
        horizontalBar.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 0).isActive = true
    }
    
    func setUpCollectionView() {
        var frame = CGRect(x: 0, y: height/1.75, width: width, height: height*2)
        collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .white
        self.collectionView.isScrollEnabled = true;
        configureCollectionView()
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.frame = CGRect.zero
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: width).isActive = true
        collectionView.topAnchor.constraint(equalTo: horizontalBar.bottomAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! Cell
        let data = self.data[indexPath.item]
        cell.nameLabel.text = "\(searchedValue) results"
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected")
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width)/2.01, height: (height)/2.5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

}

class Cell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
//    let picCollection: UIImageView = {
//        let image = UIImage(named: "example\(3)")
//        let imageView = UIImageView(image: image)
//        return imageView
//    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        backgroundColor = UIColor.systemGray6
        
//        addSubview(picCollection)
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": picCollection]))
//        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": picCollection]))
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
