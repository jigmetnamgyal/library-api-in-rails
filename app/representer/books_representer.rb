class BooksRepresenter
  def initialize(books)
    @books = books
  end

  def as_json
    @books.map do |book|
      {
        id: book.id,
        name: formattedName(book),
        age: book.author.age,
        title: book.title
      }
    end
  end

  private

  def formattedName(book)
    "#{book.author.first_name} #{book.author.last_name}"
  end

end