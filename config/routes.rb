Scuttlebutt::Engine.routes.draw do

	resources :contacts do
		get :thank_you, on: :collection, path: 'thank-you'
	end

	resources :optins, only: [:create] do
		get :thank_you, on: :collection, path: 'thank-you'
	end


end
