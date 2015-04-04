namespace :tire do
  desc "reindex all data"
  task :reindex do
    on roles(:app) do
      within "#{release_path}" do
        with rails_env: :production do
          execute :rake, "environment tire:import:all FORCE=true"
        end
      end
    end
  end
end
