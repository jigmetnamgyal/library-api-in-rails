module Api
  module V1
    class BookController < ApplicationController
      MAX_LIMIT_OF_THE_BOOKS = 100
      def index
        @books = Book.limit(limit).offset(params[:offset])

        render json: BooksRepresenter.new(@books).as_json
      end

      def create
        @author = Author.create!(author_params)
        @book = Book.new(books_params.merge(author_id: @author.id))
        if @book.save()
          render(json: BookRepresenter.new(@book).as_json, status: :created)
        else
          render(json: @book.errors, status: :unprocessable_entity)
        end
      end
      def destroy
        Book.find(params[:id]).destroy
        head :no_content
      end

      private

      def limit 
        [params.fetch(:limit, MAX_LIMIT_OF_THE_BOOKS).to_i, 100].min
      end

      def books_params
        params.require(:book).permit(:title)
      end

      def author_params
        params.require(:author).permit(:first_name, :last_name, :age)
      end
    end
  end
end