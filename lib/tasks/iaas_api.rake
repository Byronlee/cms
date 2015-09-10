namespace :iaas do
  desc 'Modify load balancer backend attributes'
  task :web5_preview_lbp => :environment do
    Deploy::Iaas.web_lbp('pek2', 'lbb-1e6i97zu', 'lbp-z6agbjzn', '8098', '1')
    Deploy::Iaas.web_lbp('pek2', 'lbb-5zcqad0u', 'lbp-z6agbjzn', '8098', '1')
    Deploy::Iaas.apply_policy('pek2', 'lb-3hczjbvo')
  end
  task :web5_online_lbp => :environment do
    Deploy::Iaas.web_lbp('pek2', 'lbb-1e6i97zu', '', '8098', '5')
    Deploy::Iaas.web_lbp('pek2', 'lbb-5zcqad0u', '', '8098', '1')
    Deploy::Iaas.apply_policy('pek2', 'lb-3hczjbvo')
  end

  desc 'Block ip firewall'
  task :block_ip_firewall => :environment do
     Deploy::Iaas.block_ip_firewall(Settings.deploy.zone,
       Settings.deploy.firewall.security_group_rule, Settings.deploy.firewall.weight)
  end
end
