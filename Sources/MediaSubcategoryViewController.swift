/*****************************************************************************
 * MediaSubcategoryViewController.swift
 * VLC for iOS
 *****************************************************************************
 * Copyright (c) 2018 VideoLAN. All rights reserved.
 * $Id$
 *
 * Authors: Carola Nitz <caro # videolan.org>
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class VLCVideoSubcategoryViewController: VLCMediaSubcategoryViewController {
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let movies = VLCMediaViewController<MLFile>(services: services, subcategory: VLCMediaSubcategories.movies)
        movies.delegate = mediaDelegate
        let episodes = VLCMediaViewController<MLShowEpisode>(services: services, subcategory: VLCMediaSubcategories.episodes)
        episodes.delegate = mediaDelegate
        let playlists = VLCMediaViewController<MLLabel>(services: services, subcategory: VLCMediaSubcategories.videoPlaylists)
        playlists.delegate = mediaDelegate
        return [movies, episodes, playlists]
    }
}

class VLCAudioSubcategoryViewController: VLCMediaSubcategoryViewController {
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let tracks = VLCMediaViewController<MLFile>(services: services, subcategory: VLCMediaSubcategories.tracks)
        tracks.delegate = mediaDelegate
        let genres = VLCMediaViewController<String>(services: services, subcategory: VLCMediaSubcategories.genres)
        genres.delegate = mediaDelegate
        let artists = VLCMediaViewController<String>(services: services, subcategory: VLCMediaSubcategories.artists)
        artists.delegate = mediaDelegate
        let albums = VLCMediaViewController<MLAlbum>(services: services, subcategory: VLCMediaSubcategories.albums)
        albums.delegate = mediaDelegate
        let playlists = VLCMediaViewController<MLLabel>(services: services, subcategory: VLCMediaSubcategories.audioPlaylists)
        playlists.delegate = mediaDelegate
        return [tracks, genres, artists, albums, playlists]
    }
}

class VLCMediaSubcategoryViewController: BaseButtonBarPagerTabStripViewController<VLCLabelCell> {

    var services: Services
    weak var mediaDelegate: VLCMediaViewControllerDelegate?
    private var rendererButton: UIButton

    init(services: Services) {
        self.services = services
        rendererButton = services.rendererDiscovererManager.setupRendererButton()
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {

        changeCurrentIndexProgressive = { (oldCell: VLCLabelCell?, newCell: VLCLabelCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) in
            guard changeCurrentIndex == true else { return }
            oldCell?.iconLabel.textColor = PresentationTheme.current.colors.cellDetailTextColor
            newCell?.iconLabel.textColor = PresentationTheme.current.colors.orangeUI
        }
        setupNavigationBar()
        super.viewDidLoad()
    }

    private func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("SORT", comment: ""), style: .plain, target: self, action: #selector(sort))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rendererButton)
    }

    @objc func sort() {
        // This should be in a subclass
        let sortOptionsAlertController = UIAlertController(title: NSLocalizedString("SORT_BY", comment: ""), message: nil, preferredStyle: .actionSheet)
        let sortByNameAction = UIAlertAction(title: SortOption.alphabetically.localizedDescription, style: .default) { action in
        }
        let sortBySizeAction = UIAlertAction(title: SortOption.size.localizedDescription, style: .default) { action in
        }
        let sortbyDateAction = UIAlertAction(title: SortOption.insertonDate.localizedDescription, style: .default) { action in
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: .cancel, handler: nil)
        sortOptionsAlertController.addAction(sortByNameAction)
        sortOptionsAlertController.addAction(sortbyDateAction)
        sortOptionsAlertController.addAction(sortBySizeAction)
        sortOptionsAlertController.addAction(cancelAction)
        sortOptionsAlertController.view.tintColor = UIColor.vlcOrangeTint()
        present(sortOptionsAlertController, animated: true)
    }

    // MARK: - PagerTabStripDataSource

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        fatalError("this should only be used as subclass")
    }

    override func configure(cell: VLCLabelCell, for indicatorInfo: IndicatorInfo) {
        cell.iconLabel.text = indicatorInfo.title
    }

    override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return PresentationTheme.current.colors.statusBarStyle
    }
}
