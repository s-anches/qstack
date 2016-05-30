lock '3.5.0'

set :application, 'qna'
set :repo_url, 'git@github.com:s-anches/qstack.git'
set :deploy_to, '/home/deployer/qstack'
set :deploy_user, 'deployer'

set :linked_files, %w{config/database.yml config/private_pub.yml config/private_pub_thin.yml .env lib/ssl/portnyagin.space.crt lib/ssl/portnyagin.space.key}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tnp/sockets vendor/bundle public/system public/uploads}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

namespace :private_pub do
  desc 'Start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml start"
        end
      end
    end
  end

  desc 'Stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, 'exec thin -C config/private_pub_thin.yml stop'
        end
      end
    end
  end

  desc 'Restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
        end
      end
    end
  end
end

after 'deploy:finished', 'private_pub:restart'