require 'rails_helper'


RSpec.describe Api::V1::BookController, type: :controller do
    it 'Returns the offset and the limit of the controller ' do
        expect(Book).to receive(:limit).with(100).and_call_original

        get :index, params: {limit: 999}
    end
end