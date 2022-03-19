//
//  ViewController.swift
//  MusicLibrary
//
//  Created by Idwall Go Dev 001 on 19/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var albumsTableView: UITableView!
    
    lazy var trackList = [MusicTrack]() {
        didSet {
            DispatchQueue.main.async {
                self.albumsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegates()
        getTracks()
        registerCell()
        
        title = "Home"
        // Do any additional setup after loading the view.
    }
    
    private func registerCell() {
        let nib = UINib(nibName: AlbumTableViewCell.identifier, bundle: nil)
        
        albumsTableView.register(nib, forCellReuseIdentifier: AlbumTableViewCell.identifier)
    }
    
    private func delegates() {
        albumsTableView.delegate = self
        albumsTableView.dataSource = self
    }
    
    private func getTracks() {
        ItunesService.shared.getTracks { result in
            switch result {
            case .success(let res):
                self.trackList = res
            case .failure(let error):
                print("deu ruim \(error)")
            }
        }
    }
    
    func alertSuccess() {}
    
    func alertError(_ error: String) {
        print(error)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let musicTrack = trackList[indexPath.row]
        
        ManagedObjectContext.shared.save(track: musicTrack) { result in
            switch result {
            case .Success:
                print("Salvo")
                break
            case .Error(let error):
                alertError(error)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = albumsTableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.identifier, for: indexPath) as? AlbumTableViewCell else {
            return UITableViewCell()
        }
        
        let track = trackList[indexPath.row]
        
        cell.setup(albumName: track.collectionName!,
                   trackName: track.trackName!,
                   imageUrl: track.artworkUrl100!)
        
        return cell
    }
    
    
}

