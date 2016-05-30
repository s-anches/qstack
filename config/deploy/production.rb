# server-based syntax
# ======================
server 'portnyagin.space', user: 'deployer', roles: %w{app db web}, primary: true

# role-based syntax
# ==================
role :app, %w{deployer@portnyagin.space}
role :web, %w{deployer@portnyagin.space}
role :db,  %w{deployer@portnyagin.space}

set :rails_env, :production
set :stage, :production

# Custom SSH Options
# ==================
set :ssh_options, {
  keys: %w(/home/deployer/.ssh/id_rsa),
  forward_agent: true,
  auth_methods: %w(publickey password),
  port: 8022
}