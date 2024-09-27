import Foundation

struct Post {
    var author: String
    var content: String
    var likes: Int

    init(author: String, content: String, likes: Int) {
        self.author = author
        self.content = content
        self.likes = likes
    }

    func display() {
        print("Post by \(author)")
        print("Content: \(content)")
        print("Likes: \(likes)")
        print("--------------------------")
    }
}

struct Product {
    var name: String
    var price: Double
    var quantity: Int

    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

protocol DiscountStrategy {
    func applyDiscount(totalPrice: Double) -> Double
}

class NoDiscountStrategy: DiscountStrategy {
    func applyDiscount(totalPrice: Double) -> Double {
        return totalPrice
    }
}

class PercentageDiscountStrategy: DiscountStrategy {
    private let percentage: Double

    init(percentage: Double) {
        self.percentage = percentage
    }

    func applyDiscount(totalPrice: Double) -> Double {
        let remainingPercentage = (100 - percentage) / 100
        return totalPrice * remainingPercentage
    }
}

class ShoppingCartSingleton {
    static let sharedInstance = ShoppingCartSingleton()

    private var products: [Product] = []

    private init() {}

    func addProduct(product: Product, quantity: Int) {
        var newProduct = product
        newProduct.quantity = quantity
        products.append(newProduct)
    }

    func removeProduct(product: Product) {
        products.removeAll { $0.name == product.name }
    }

    func clearCart() {
        products.removeAll()
    }

    func getTotalPrice(withDiscount strategy: DiscountStrategy) -> Double {
        var totalPrice = 0.0
        for product in products {
            totalPrice += product.price * Double(product.quantity)
        }
        return strategy.applyDiscount(totalPrice: totalPrice)
    }
}

protocol PaymentProcessor {
    func processPayment(amount: Double) throws
}

enum PaymentError: Error {
    case paymentFailed(message: String)
}

class CreditCardProcessor: PaymentProcessor {
    private let availableBalance: Double

    init(availableBalance: Double) {
        self.availableBalance = availableBalance
    }

    func processPayment(amount: Double) throws {
        print("Processing credit card payment of \(amount)...")
        if amount > availableBalance {
            throw PaymentError.paymentFailed(message: "Insufficient funds on the credit card.")
        }

        print("Credit card payment of \(amount) was successful!")
    }
}

class CashProcessor: PaymentProcessor {
    private let availableCash: Double

    init(availableCash: Double) {
        self.availableCash = availableCash
    }

    func processPayment(amount: Double) throws {
        print("Processing cash payment of \(amount)...")
        if amount > availableCash {
            throw PaymentError.paymentFailed(message: "Not enough cash available.")
        }
        print("Cash payment of \(amount) was successful!")
    }
}

func main() {
    let post1 = Post(author: "Alice", content: "Had a great day at the park!", likes: 120)
    let post2 = Post(author: "Bob", content: "Just played 5 hours of badminton!", likes: 95)

    post1.display()
    post2.display()

    let product1 = Product(name: "Macbook", price: 5000.00, quantity: 1)
    let product2 = Product(name: "iPhone", price: 2000.00, quantity: 2)

    ShoppingCartSingleton.sharedInstance.addProduct(product: product1, quantity: 4)
    ShoppingCartSingleton.sharedInstance.addProduct(product: product2, quantity: 2)

    let noDiscount = NoDiscountStrategy()
    let percentageDiscount = PercentageDiscountStrategy(percentage: 10)

    print("Total price without discount: \(ShoppingCartSingleton.sharedInstance.getTotalPrice(withDiscount: noDiscount))")

    print("Total price with 10% discount: \(ShoppingCartSingleton.sharedInstance.getTotalPrice(withDiscount: percentageDiscount))")

    ShoppingCartSingleton.sharedInstance.removeProduct(product: product2)
    print("Total price after removing product: \(ShoppingCartSingleton.sharedInstance.getTotalPrice(withDiscount: noDiscount))")

    ShoppingCartSingleton.sharedInstance.clearCart()
    print("Total price after clearing the cart: \(ShoppingCartSingleton.sharedInstance.getTotalPrice(withDiscount: noDiscount))")

    let creditCardProcessor = CreditCardProcessor(availableBalance: 100.0)
    let cashProcessor = CashProcessor(availableCash: 50.0)

    do {
        try creditCardProcessor.processPayment(amount: 75.0)
    } catch {
        print("Error occurred \(error)")
    }

    do {
        try cashProcessor.processPayment(amount: 60.0)
    } catch {
        print("Error occurred \(error)")
    }

    do {
        try cashProcessor.processPayment(amount: 40.0)
    } catch {
        print("Error occurred \(error)")
    }
}

main()
