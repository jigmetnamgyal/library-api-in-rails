require 'rails_helper'

RSpec.describe'Books Api', type: :request do
  let(:first_author) {FactoryBot.create(:author, :first_name => "Michio", :last_name => "Kaku", :age => '66')}
  let(:second_author) {FactoryBot.create(:author, :first_name => "Mark", :last_name => "Manson", :age => '42')}

  describe 'GET /book' do
    before do
      FactoryBot.create(:book, :title => 'The physics of the impossible', :author => first_author)
      FactoryBot.create(:book, :title => 'The subtle art of not giving a F', :author => second_author)
    end

    it "Returns all the book created" do
      get('/api/v1/book')
      expect(response).to have_http_status(:success)
      expect(jsonParseHelper.size).to eql(2)
      expect(jsonParseHelper).to eql(
        [
          {
            "id" => 1,
            "title" => 'The physics of the impossible',
            "name" => "Michio Kaku",
            "age" => 66
          },
          {
            "id" => 2,
            "title" => 'The subtle art of not giving a F',
            "name" => "Mark Manson",
            "age" => 42
          }
        ]
      )
    end

    it "Returns a pagination of a limit" do
      get '/api/v1/book', params: {limit: 1}
      expect(response).to have_http_status(:success)
      expect(jsonParseHelper.size).to eql(1)
      expect(jsonParseHelper).to eql(
        [
          {
            "id" => first_author.id,
            "title" => 'The physics of the impossible',
            "name" => "Michio Kaku",
            "age" => 66
          }
        ]
      )
    end
  
    it "returns a pagination of a limit and offset" do
      get '/api/v1/book', params: {limit: 1, offset: 1}
      expect(response).to have_http_status(:success)
      expect(jsonParseHelper.size).to eql(1)
      expect(jsonParseHelper).to eql(
        [
          {
            "id" => second_author.id,
            "title" => 'The subtle art of not giving a F',
            "name" => "Mark Manson",
            "age" => 42
          }
        ]
      )
    end
  end

  describe 'POST /book' do
    it 'Creates a book with author and title attributes' do
      expect {
        post '/api/v1/book', params: {
          book: {:title => "Everything is F" }, 
          author: {first_name: "Mark", last_name: "Manson", age: '23'}
        }
      }.to change {Book.count}.from(0).to(1)

      expect(response).to have_http_status(:success)
      expect(Author.count).to eql(1)
      expect(jsonParseHelper).to eql(
        {
            "id" => 7,
            "name" => "Mark Manson",
            "age" => 23,
            "title" => "Everything is F"
        }
      )
    end
  end

  describe 'DELETE /book/:id' do
    let!(:book) {FactoryBot.create(:book, :author => first_author, :title => "Astro Credence")}
    it "Deletes a record" do
      expect{
        delete "/api/v1/book/#{book.id}"
      }.to change {Book.count}.from(1).to(0)

      expect(response).to have_http_status(:no_content)
    end
  end
end



