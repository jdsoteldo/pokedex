import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonCaught: Codable {
    var state = [String : Bool]()
}

struct PokemonSprite: Codable {
    let sprites: PokemonSprites
}

struct PokemonSprites: Codable {
    let front_default: String
    let back_default: String
}

struct Description: Codable {
    let flavor_text_entries: [PokemonDescription]
}

struct PokemonDescription: Codable {
    let flavor_text: String
    let language: language
}

struct language: Codable {
    var name: String
}
