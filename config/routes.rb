Dunamis::Application.routes.draw do

  
  resources :paginas

  resources :alertas do
    collection do
      get 'descargas'
    end
  end
  resources :tipos_alertas

  resources :usuarios

  resources :partidos

  resources :tipos_webnotas

  resources :posts

  resources :notas

  resources :tipos_notas

  resources :resumenes do
    collection do
      get 'paso1'
      get 'paso2'
      get 'unir'
      get 'separar'
    end
    resources :notas
    collection do
      get 'paso1'
      post 'paso1_guardar'
      get 'paso2'
      post 'paso2_guardar'
    end
  end

  resources :candidatos

  resources :tipos_cargos

  resources :municipios

  resources :voceros

  resources :elecciones

  

  resources :informes do
    collection do
      get 'enviar_por_correo'
      get 'paso1'
      get 'paso2'
      get 'paso2b'
      get 'paso3'
      get 'paso4'
      get 'paso5'
      get 'paso6'
      post 'agregar'
      get 'paso3_guardar'
      post 'desagregar_resumen'
    end
    resources :resumenes
  end

  resources :asuntos do
    resources :temas
  end

  resources :temas do
    resources :resumenes
  end

  resources :websites do
    collection do
      get 'barrer'
    end

    resources :paginas
  end

  resources :apariciones

  resources :cunas
  # resources :cunas do
  #   resources :candidates
  # end

  resources :organizaciones do
    match 'actualizar_select_municipios', :action => 'actualizar_select_municipios'
  end

  resources :estados do
    resources :municipios
  end

  resources :candidates
  # resources :candidates do
  #     resources :cunas
  # end

  get "home/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  match 'generar_reporte' => 'candidates#generar_reporte', :as => :generar_reporte
  
  match 'organizaciones/actualizar_select_municipios', :controller => 'organizaciones', :action => 'actualizar_select_municipios'
  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end
