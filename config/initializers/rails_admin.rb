RailsAdmin.config do |config|
  

  require Rails.root.join('lib', 'rails_admin', 'rails_admin_pdf.rb')
  RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Pdf)

  require Rails.root.join('lib', 'rails_admin', 'rails_admin_flowcash.rb')
  RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::FlowCash)

  ### Popular gems integration

  ## == Devise ==
   config.authenticate_with do
     warden.authenticate! scope: :user
   end
   config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  config.default_items_per_page = 5

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard
    flow_cash                    # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    pdf do
      only Expense
    end
  end

  config.model 'User' do
    create do
      field :name
      field :kind
      field :phone
      field :email
      field :password
      field :password_confirmation
    end

    edit do
      field :name
      #field :kind
      field :phone
      field :email
      field :password
      field :password_confirmation
    end
  end
    #______

  config.model 'Provider' do
    create do
      field :name
      field :cnpj
      field :phone
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id #seta o id automaticamente
        end
      end
    end

    list do
      field :name
      field :cnpj
      field :phone
      field :user_id
      field :user do
        pretty_value do
          value.name #adiciona o nome ao inves de id
        end
      end
    end

    edit do
      field :name
      field :cnpj
      field :phone
    end
  end

  config.model 'Receipt' do
    create do
      field :description
      field :amount
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id #seta o id automaticamente
        end
      end
    end

    list do
      field :description
      field :amount do 
        pretty_value do
          ActionController::Base.helpers.number_to_currency(value)
        end
      end
      field :user_id
      field :user do
        pretty_value do
          value.name #adiciona o nome ao inves de id
        end
      end
    end

    edit do
      field :description
      field :amount
    end
  end

  config.model 'Expense' do
    create do
      field :provider
      field :category
      field :amount 
      field :duedate
      field :paymentdate
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id #seta o id automaticamente
        end
      end
    end

    list do
      field :provider
      field :category
      field :amount do
        pretty_value do
          ActionController::Base.helpers.number_to_currency(value)
        end
      end
      field :duedate
      field :paymentdate
      field :user do
        pretty_value do
          value.name #adiciona o nome ao inves de id
        end
      end
    end

    edit do
      field :provider
      field :category
      field :amount
      field :duedate
      field :paymentdate
    end
  end

  config.model 'Description' do
    create do
      field :name
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id #seta o id automaticamente
        end
      end
    end

    list do
      field :name
      field :user_id
      field :user do
        pretty_value do
          value.name #adiciona o nome ao inves de id
        end
      end
    end

    edit do
      field :name
    end
  end

  config.model 'Category' do
    create do
      field :name
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id #seta o id automaticamente
        end
      end
    end

    list do
      field :name
      field :user_id
      field :user do
        pretty_value do
          value.name #adiciona o nome ao inves de id
        end
      end
    end

    edit do
      field :name
    end
  end

  config.model 'Category' do
    parent Expense
  end

  config.model 'Expense' do
    navigation_icon 'fa fa-shopping-cart'
  end

  config.model 'Description' do
    parent Receipt
  end

  config.model 'User' do
    navigation_icon 'fa fa-users'
  end

  config.model 'Receipt' do
    navigation_icon 'fa fa-money'
  end

  config.model 'Provider' do 
    navigation_icon 'fa fa-barcode'
  end

  config.model 'Description' do 
    navigation_icon 'fa fa-pencil'
  end

  config.model 'Category' do
    navigation_icon 'fa fa-list'
  end


    ## With an audit adapter, you can add:
    # history_index
    # history_show
end
