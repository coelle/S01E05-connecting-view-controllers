//
//  Example
//
//  Copyright © 2016 objc.io. All rights reserved.
//

import UIKit


struct Episode {
	var title: String
}


class ProfileViewController: UIViewController {
	var person: String = ""
	var didTapClose: () -> () = {
	}

	@IBAction func close(sender: Any) {
		didTapClose()
	}
}


class EpisodesViewController: UITableViewController {
	let episodes = [Episode(title: "Episode One"), Episode(title: "Episode Two"), Episode(title: "Episode Three")]

	var didSelect: (Episode) -> () = { _ in
	}

	var didTapOpenProfile: () -> () = {
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return episodes.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let episode = episodes[indexPath.row]
		cell.textLabel?.text = episode.title
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let episode = episodes[indexPath.row]
		didSelect(episode)
	}

	@IBAction func showProfile(sender: Any) {
		didTapOpenProfile()
	}
}


class DetailViewController: UIViewController {
	@IBOutlet weak var label: UILabel? {
		didSet {
			label?.text = episode?.title
		}
	}
	var episode: Episode?
}

final class App {
	let storyboard: UIStoryboard
	let nc: UINavigationController

	init(window: UIWindow) {
		self.storyboard = UIStoryboard(name: "Main", bundle: nil)
		self.nc = window.rootViewController as! UINavigationController
		let episodesVC = nc.viewControllers.first as! EpisodesViewController

		episodesVC.didSelect = showEpisode

		episodesVC.didTapOpenProfile = {
			let profileNC = self.storyboard.instantiateViewController(withIdentifier: "Profile") as! UINavigationController
			let profileVC = profileNC.viewControllers.first as! ProfileViewController
			profileVC.didTapClose = {
				self.nc.dismiss(animated: true, completion: nil)
			}
			self.nc.present(profileNC, animated: true, completion: nil)
		}
	}

	private func showEpisode(_ episode: Episode) {
		let detailVC = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
		detailVC.episode = episode
		nc.pushViewController(detailVC, animated: true)
	}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
	var app: App?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
		if let window = window {
			app = App(window: window)
		}
		return true
	}
}

