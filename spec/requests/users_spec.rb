# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "POST /users/sign_up" do
    subject(:post_sign_up) { post "/users/sign_up", params: params }

    context "with valid request body" do
      let(:params) do
        {
          user: {
            email: Faker::Internet.email,
            password: Faker::Beer.brand
          }
        }
      end

      context "with not existing user" do
        it "responds with 201" do
          post_sign_up

          expect(response).to have_http_status(:created)
        end

        it "creates a user" do
          expect { post_sign_up }.to change(User, :count).by(1)
        end

        it "creates a token" do
          expect { post_sign_up }.to change(Token, :count).by(1)
        end

        it "returns the token value" do
          post_sign_up

          token = Token.last
          expect(token.value).not_to be_blank
          expect(parsed_body[:token][:value]).to eq token.value
          expect(token.expires_at).to be_within(1.second).of(1.day.from_now)
        end
      end

      context "with existing user" do
        it "responds with 409" do
          post_sign_up

          expect(response).to have_http_status(:conflict)
        end

        it "returns an error body with already existing user" do
          post_sign_up

          expect(parsed_body[:errors].first).to match(hash_including({
                                                                       code: "already_existing_user",
                                                                       title: "User already exists",
                                                                       description: "User with #{email} is already registered!"
                                                                     }))
        end

        it "does not create a user" do
          expect { post_sign_up }.to change(User, :count).by(0)
        end

        it "does not create a token" do
          expect { post_sign_up }.to change(Token, :count).by(0)
        end
      end
    end

    context "with missing root element user in request body" do
      let(:params) { {} }

      it "returns 400" do
        post_sign_up

        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error body with user invalid parameters message" do
        post_sign_up

        expect(parsed_body[:errors].first).to match(hash_including({
                                                                     code: "invalid_caption_parameters",
                                                                     title: "Invalid parameters in request body",
                                                                     description: "param is missing or the value is empty: user"
                                                                   }))
      end

      it "does not create a user" do
        expect { post_sign_up }.to change(User, :count).by(0)
      end

      it "does not create a token" do
        expect { post_sign_up }.to change(Token, :count).by(0)
      end
    end

    context "with missing email element in request body" do
      let(:params) do
        {
          user: {
            password: Faker::Beer.brand
          }
        }
      end

      it "returns 400" do
        post_sign_up

        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error body with email invalid parameters message" do
        post_sign_up

        expect(parsed_body[:errors].first).to match(hash_including({
                                                                     code: "invalid_user_parameters",
                                                                     title: "Invalid parameters in request body",
                                                                     description: "param is missing or the value is empty: email"
                                                                   }))
      end

      it "does not create a user" do
        expect { post_sign_up }.to change(User, :count).by(0)
      end

      it "does not create a token" do
        expect { post_sign_up }.to change(Token, :count).by(0)
      end
    end

    context "with missing password element in request body" do
      let(:params) do
        {
          user: {
            email: Faker::Internet.email
          }
        }
      end

      it "returns 400" do
        post_sign_up

        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error body with text invalid parameters message" do
        post_sign_up

        expect(parsed_body[:errors].first).to match(hash_including({
                                                                     code: "invalid_user_parameters",
                                                                     title: "Invalid parameters in request body",
                                                                     description: "param is missing or the value is empty: password"
                                                                   }))
      end

      it "does not create a user" do
        expect { post_sign_up }.to change(User, :count).by(0)
      end

      it "does not create a token" do
        expect { post_sign_up }.to change(Token, :count).by(0)
      end
    end

    context "with invalid email value" do
      let(:params) do
        {
          user: {
            email: email,
            password: password
          }
        }
      end

      context "with empty email" do
        let(:email) { "" }
        let(:password) { Faker::Beer.brand }

        it "returns 422" do
          post_sign_up

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid email value" do
          post_sign_up

          expect(parsed_body[:errors].first).to match(hash_including({
                                                                       code: "invalid_user_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "Email can't be blank"
                                                                     }))
        end

        it "does not create a user" do
          expect { post_sign_up }.to change(User, :count).by(0)
        end

        it "does not create a token" do
          expect { post_sign_up }.to change(Token, :count).by(0)
        end
      end

      context "with nil email" do
        let(:email) { nil }
        let(:password) { Faker::Beer.brand }

        it "returns 422" do
          post_sign_up

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid email value" do
          post_sign_up

          expect(parsed_body[:errors].first).to match(hash_including({
                                                                       code: "invalid_user_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "Email can't be blank"
                                                                     }))
        end

        it "does not create a user" do
          expect { post_sign_up }.to change(User, :count).by(0)
        end

        it "does not create a token" do
          expect { post_sign_up }.to change(Token, :count).by(0)
        end
      end

      context "with invalid email format" do
        let(:email) { Faker::Beer.brand }
        let(:password) { Faker::Beer.brand }

        it "returns 422" do
          post_sign_up

          expect(response).to have_http_status(:bad_request)
        end

        it "returns an error body with invalid password value" do
          post_sign_up

          expect(parsed_body[:errors].first).to match(hash_including({
                                                                       code: "invalid_user_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "Password can't be blank"
                                                                     }))
        end
      end
    end

    context "with invalid password value" do
      let(:params) do
        {
          user: {
            email: email,
            password: password
          }
        }
      end

      context "with empty password" do
        let(:email) { Faker::Internet.email }
        let(:password) { "" }

        it "returns 400" do
          post_sign_up

          expect(response).to have_http_status(:bad_request)
        end

        it "returns an error body with invalid password value" do
          post_sign_up

          expect(parsed_body[:errors].first).to match(hash_including({
                                                                       code: "invalid_user_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "Password can't be blank"
                                                                     }))
        end

        it "does not create a user" do
          expect { post_sign_up }.to change(User, :count).by(0)
        end

        it "does not create a token" do
          expect { post_sign_up }.to change(Token, :count).by(0)
        end
      end

      context "with nil password" do
        let(:email) { Faker::Internet.email }
        let(:password) { nil }

        it "returns 400" do
          post_sign_up

          expect(response).to have_http_status(:bad_request)
        end

        it "returns an error body with invalid password value" do
          post_sign_up

          expect(parsed_body[:errors].first).to match(hash_including({
                                                                       code: "invalid_user_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "Password can't be blank"
                                                                     }))
        end

        it "does not create a user" do
          expect { post_sign_up }.to change(User, :count).by(0)
        end

        it "does not create a token" do
          expect { post_sign_up }.to change(Token, :count).by(0)
        end
      end
    end
  end
end
