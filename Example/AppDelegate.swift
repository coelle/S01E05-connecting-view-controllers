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


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)

		let nc = window?.rootViewController as! UINavigationController
		let episodesVC = nc.viewControllers.first as! EpisodesViewController

		episodesVC.didSelect = { episode in
			let detailVC = storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
			detailVC.episode = episode
			nc.pushViewController(detailVC, animated: true)
		}
		episodesVC.didTapOpenProfile = {
			let profileNC = storyboard.instantiateViewController(withIdentifier: "Profile") as! UINavigationController
			let profileVC = profileNC.viewControllers.first as! ProfileViewController
			profileVC.didTapClose = {
				nc.dismiss(animated: true, completion: nil)
			}
			nc.present(profileNC, animated: true, completion: nil)
		}
		return true
	}
}

