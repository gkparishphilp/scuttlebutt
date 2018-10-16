Scuttlebutt::Engine.routes.draw do


	match '/comment_on/:type/:id' => 'user_posts#create', as: 'comment_on', via: [:get, :post]

	resources :comments, only: [:index, :new, :edit, :show]

	resources :contacts do
		get :thank_you, on: :collection, path: 'thank-you'
	end


	if Scuttlebutt.discussion_path
		resources :discussions, path: Scuttlebutt.discussion_path
	end
	if Scuttlebutt.discussion_topic_path
		resources :discussion_topics, path: Scuttlebutt.discussion_topic_path
	end
	resources :discussion_posts

	resources :discussion_admin

	resources :notifications

	resources :optins, only: [:create] do
		get :thank_you, on: :collection, path: 'thank-you'
	end

	resources :subscriptions

	resources :votes, only: [:create, :destroy, :update, :index]


end
