Scuttlebutt::Engine.routes.draw do


	match '/comment_on/:type/:id' => 'user_posts#create', as: 'comment_on', via: [:get, :post]

	resources :comments, only: [:index, :new, :edit, :show]

	resources :contacts do
		get :thank_you, on: :collection, path: 'thank-you'
	end


	if SwellSocial::discussion_path
		resources :discussions, path: SwellSocial.discussion_path do 
			resources :topics, controller: :discussion_topics
		end
		resources :discussion_posts
	end
	resources :discussion_admin

	resources :notifications

	resources :optins, only: [:create] do
		get :thank_you, on: :collection, path: 'thank-you'
	end

	resources :subscriptions

	resources :votes, only: [:create, :destroy, :update, :index]


end
