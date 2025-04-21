import Foundation

func anyError() -> NSError {
    NSError(domain: "any error", code: 1)
}


func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}

