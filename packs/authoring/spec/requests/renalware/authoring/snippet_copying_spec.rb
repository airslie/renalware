describe "Copying a snippet" do
  let(:user) { Renalware::Authoring.cast_user(@current_user) }

  def find_and_validate_cloned_snippet_for(author, title:)
    cloned_snippet = author.snippets.find_by(title: title)
    expect(cloned_snippet).not_to be_nil
    expect(cloned_snippet.times_used).to eq(0)
    expect(cloned_snippet.last_used_on).to be_nil
  end

  def attributes_from_snippet(snippet)
    attributes = snippet.attributes.with_indifferent_access.slice(
      :last_used_on,
      :author_id,
      :title,
      :body
    )
    attributes[:last_used_on]&.change(usec: 0)
  end

  describe "POST clone - cloning another user's snippet" do
    it "clones and saves another user's snippet and assigns it to the current user" do
      another_user = create(:snippets_user)

      snippet_to_clone = create(:snippet,
                                author: another_user,
                                title: "A Snippet",
                                times_used: 10,
                                last_used_on: Time.zone.now)

      snippet_to_clone_attrs = attributes_from_snippet(snippet_to_clone)

      post authoring.snippet_clones_path(snippet_id: snippet_to_clone.id)

      follow_redirect!
      expect(response).to be_successful

      expect(user.reload.snippets.length).to eq(1)
      find_and_validate_cloned_snippet_for(user, title: "A Snippet [CLONE]")

      # original is untouched
      snippet_to_clone.reload
      expect(attributes_from_snippet(snippet_to_clone)).to eq(snippet_to_clone_attrs)
    end

    context "when the current user already clone the snippet (so the title is already taken)" do
      it "generates a unique title and before cloning" do
        # Make it look like the user has already cloned the other users snippet TWICE
        create(:snippet, author: user, title: "A Snippet [CLONE]")
        create(:snippet, author: user, title: "A Snippet [CLONE] (1)")

        another_user = create(:snippets_user)
        snippet_to_clone = create(:snippet,
                                  author: another_user,
                                  title: "A Snippet",
                                  times_used: 10,
                                  last_used_on: Time.zone.now)
        snippet_to_clone_attrs = attributes_from_snippet(snippet_to_clone)

        post authoring.snippet_clones_path(snippet_id: snippet_to_clone.id)

        follow_redirect!
        expect(response).to be_successful

        expect(user.reload.snippets.length).to eq(3)
        find_and_validate_cloned_snippet_for(user, title: "A Snippet [CLONE] (2)")

        # original is untouched
        expect(attributes_from_snippet(snippet_to_clone.reload)).to eq(snippet_to_clone_attrs)
      end
    end
  end

  describe "POST clone - cloning one of my own snippets" do
    it "clones and saves one of my snippets" do
      snippet_to_clone = create(:snippet,
                                author: user,
                                title: "My Snippet",
                                last_used_on: Time.zone.now,
                                times_used: 10)
      snippet_to_clone_attrs = attributes_from_snippet(snippet_to_clone)

      post authoring.snippet_clones_path(snippet_id: snippet_to_clone.id)

      follow_redirect!
      expect(response).to be_successful

      expect(user.reload.snippets.length).to eq(2)

      find_and_validate_cloned_snippet_for(user, title: "My Snippet [COPY]")

      # original is untouched
      expect(attributes_from_snippet(snippet_to_clone.reload)).to eq(snippet_to_clone_attrs)
    end
  end
end
