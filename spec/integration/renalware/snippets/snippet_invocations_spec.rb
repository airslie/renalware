# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Invoking a snippet (indicating it has been used)", type: :request do
  describe "Record snippet usage via an AJAX POST" do
    it "increments the usage counter for the snippet" do
      user = Renalware::Snippets.cast_user(@current_user)
      snippet = create(:snippet, author: user, times_used: 0)

      post(snippet_invocations_path(snippet, format: :js))

      expect(response).to have_http_status(:success)
      expect(snippet.reload.times_used).to eq(1)
      expect(response.content_type).to eq("text/javascript")
    end
  end
end
