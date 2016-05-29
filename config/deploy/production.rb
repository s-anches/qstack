# server-based syntax
# ======================
server 'portnyagin.space', user: 'sanches', roles: %w{app db web}, primary: true

# role-based syntax
# ==================
role :app, %w{sanches@portnyagin.space}
role :web, %w{sanches@portnyagin.space}
role :db,  %w{sanches@portnyagin.space}

set :rails_env, :production
set :stage, :production

# Custom SSH Options
# ==================
set :ssh_options, {
  keys: %w(/home/sanches/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 8022
}