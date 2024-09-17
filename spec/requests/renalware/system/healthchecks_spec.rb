# frozen_string_literal: true

describe "Azure healthcheck robotsXXX.txt request" do
  it "returns a 404 status code with some simple text context" do
    get "/robots456.txt"

    expect(response).to be_not_found
    expect(response.body).to eq("404 Not Found")
  end
end
