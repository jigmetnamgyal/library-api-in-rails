class BookRepresenter
    def initialize(book)
        @book = book
    end

    def as_json
        {
            id: book.id,
            name: formatted_name(book),
            age: book.author.age,
            title: book.title
        }
    end

    private 
    attr_reader :book

    def formatted_name(book)
        "#{book.author.first_name} #{book.author.last_name}"
    end
end