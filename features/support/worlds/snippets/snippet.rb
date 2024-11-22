# frozen_string_literal: true

module World
  module Authoring::Snippet
    module Domain
      def create_snippet_for(user, title:, body:)
        seed_snippet(user: user, title: title, body: body)
      end

      def seed_snippet(user:, title:, body:)
        author = snippets_user(user)
        Renalware::Authoring::Snippet.create(author: author, title: title, body: body)
      end

      def expect_user_to_have_snippet(user, title:, body:)
        expect(
          Renalware::Authoring::Snippet.where(author: user, title: title, body: body).count
        ).to eq(1)
      end
    end

    module Web
      include Domain

      def create_snippet_for(user, title:, body:)
        login_as user
        visit authoring.snippets_path

        click_on "Create new snippet"
        fill_in "Title", with: title
        fill_in "Body", with: body
        click_on t("btn.save")

        expect(page).to have_current_path(authoring.snippets_path)
      end

      def expect_user_to_have_snippet(_user, title:, body:)
        within "table.snippets" do
          expect(page).to have_content(title)
        end
      end
    end
  end
end
