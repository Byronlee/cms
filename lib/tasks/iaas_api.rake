namespace :iaas do
  desc 'Modify load balancer backend attributes'
  task :preview_lbp => :environment do
    Deploy::Iaas.web3_lbp('pek2', 'lbb-olx8pelq', 'lbp-718wod2g', '8098', '1')
    Deploy::Iaas.apply_policy('pek2', 'lb-ym7veism')
  end
  task :online_lbp => :environment do
    Deploy::Iaas.web3_lbp('pek2', 'lbb-olx8pelq', '', '8098' '5')
    Deploy::Iaas.apply_policy('pek2', 'lb-ym7veism')
  end
end
