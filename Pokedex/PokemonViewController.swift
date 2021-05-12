import UIKit

class PokemonViewController: UIViewController {
    var url: String!

    var caught = true
    var pokemonkey = ""
    var pokemonUrl = ""
    
    let listview = PokemonListViewController()
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var add: UIButton!
    @IBOutlet var image: UIImageView!
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""

        loadPokemon()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    self.pokemonkey = result.name

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    self.caught = UserDefaults.standard.bool(forKey: self.pokemonkey)
                    if !self.caught {
                        self.add.setTitle("Add to Pokédex", for: UIControl.State.normal)
                    }
                    else {
                        self.add.setTitle("Release Pokémon", for: UIControl.State.normal)
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    @IBAction func toggleCatch() {
        if !caught {
            caught = true
            self.add.setTitle("Release Pokémon", for: UIControl.State.normal)
            UserDefaults.standard.set("true", forKey: pokemonkey)
            
        }
        else {
            caught = false
            self.add.setTitle("Add to Pokédex", for: UIControl.State.normal)
            UserDefaults.standard.set("false", forKey: pokemonkey)
            
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image.image = UIImage(data: data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!
        downloadImage(from: url)
    }
//    func getImage(pokemonUrl:String , imageView:UIImageView) {
//        let url:URL = URL(string: pokemonUrl)!
//        let session = URLSession.shared
//        let task = session.dataTask(with: url, completionHandler: { (data, _ , Error) in
//            if data != nil {
//                let image = UIImage(data: data!)
//                if image != nil {
//                    DispatchQueue.main.async(execute: {
//                        imageView.image = image
//                    })
//                }
//            }
//        })
//    }
    
}
