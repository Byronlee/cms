namespace :iaas do
  desc 'Modify load balancer backend attributes'
  task :preview_lbp => :environment do
    Deploy::Iaas.web3_lbp('pek2', 'lbb-pm71b6jb', 'lbp-718wod2g')
    Deploy::Iaas.apply_policy('pek2', 'lb-ym7veism')
  end
  task :online_lbp => :environment do
    Deploy::Iaas.web3_lbp('pek2', 'lbb-pm71b6jb', '')
    Deploy::Iaas.apply_policy('pek2', 'lb-ym7veism')
  end
end
