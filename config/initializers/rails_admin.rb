RailsAdmin.config do |config|

  ### Popular gems integration

  # == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.excluded_models << "UserPermission"

  config.model User do
    label 'Users'
    create do
      field :admin
      field :username
      field :email
      field :password
      field :password_confirmation
      field :permissions do
        orderable true
      end
    end
    list do
      field :username
      field :email
      field :api_key
      field :last_sign_in_at
      field :last_sign_in_ip
      field :permissions do
        orderable true
      end
    end
    show do
      field :username
      field :email
      field :api_key
      field :last_sign_in_at
      field :last_sign_in_ip
      field :permissions do
        orderable true
      end
    end
    edit do
      field :username
      field :email
      field :password
      field :password_confirmation
      field :permissions do
        orderable true
      end
    end
  end

  config.model Bot do
    create do
      field :username
      field :posting_key
    end
    list do
      field :username
      field :permissions
    end
    show do
      field :username
      field :permissions
    end
    edit do
      field :username
    end
  end

  config.model Permission do
    create do
      field :action
      field :bot
    end
    list do
      field :action
      field :bot
    end
    show do
      field :action
      field :bot
    end
    edit do
      field :action
      field :bot
    end
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
